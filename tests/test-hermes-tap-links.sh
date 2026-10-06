#!/bin/bash
# test-hermes-tap-links.sh — regression guard for issue #386.
#
# WHY: Hermes's Skills Hub fetcher (tools/skills_hub_models.py
# _referenced_support_paths) fail-closes an ENTIRE skill install — not just
# the offending link — on two distinct patterns in a SKILL.md:
#
#   1. A same-directory markdown link whose target starts with ".."
#      (_SAMEDIR_LINK_RE + `name.startswith("..")` -> return None).
#   2. A references/templates/scripts/assets/examples/ path that contains a
#      ".." traversal segment (_SUSPICIOUS_LOCAL_REF_RE -> return None).
#
# Every skills/*/SKILL.md link to repo docs must therefore use an absolute
# URL (https://github.com/...), never a repo-root-relative "../../" path,
# or `hermes skills tap add`/`install` breaks for that skill with
# "Could not fetch ... from any source." Checked against both skills/ (the
# Hermes-tap source of truth) and its plugin/ mirror, since the mirror ships
# the same content to Codex consumers reading it verbatim.
#
# USAGE: bash tests/test-hermes-tap-links.sh   (from repo root or anywhere)
set -euo pipefail

cd "$(dirname "$0")/.."

FAIL=0

check_dir() {
  local dir="$1"
  for f in "$dir"/*/SKILL.md; do
    [ -f "$f" ] || continue

    if grep -qE '\]\(\.\./' "$f"; then
      echo "FAIL: $f contains a relative parent-directory markdown link ']( ../...)'."
      echo "      Replace it with an absolute https://github.com/pitimon/8-habit-ai-dev/blob/main/... URL"
      echo "      (see issue #386 — this pattern breaks 'hermes skills tap add/install')."
      grep -nE '\]\(\.\./' "$f" | sed 's/^/      /'
      FAIL=1
    fi

    if grep -qE '(references|templates|scripts|assets|examples)/([^ )`"'"'"'<>]*/)?\.\.(/|$)' "$f"; then
      echo "FAIL: $f contains a traversal segment inside a references/templates/scripts/assets/examples/ path."
      echo "      This also fail-closes 'hermes skills tap add/install' (see issue #386)."
      grep -nE '(references|templates|scripts|assets|examples)/([^ )`"'"'"'<>]*/)?\.\.(/|$)' "$f" | sed 's/^/      /'
      FAIL=1
    fi
  done
}

check_dir "skills"
check_dir "plugin/skills"

# Install docs must pass --category (#409): Hermes refuses a skill whose name
# matches an existing category folder, and `research` collides on common homes.
for doc in README.md docs/compatibility-matrix.md docs/wiki/Installation.md docs/wiki/Troubleshooting.md; do
  [ -f "$doc" ] || continue
  if bad=$(grep -nE 'hermes skills install pitimon/8-habit-ai-dev/skills/[^ `]+' "$doc" | grep -v -- '--category'); then
    echo "FAIL: $doc has a Hermes install command without --category (see #409):"
    echo "$bad" | sed 's/^/      /'
    FAIL=1
  fi
done

# Guard alias NAMES, not targets. Only inspect fenced yaml/yml examples;
# prose is not a recommendation. This is a bounded snippet check, not a YAML parser.
SKILLS=""
for skill in skills/*/SKILL.md; do
  name=${skill%/SKILL.md}; name=${name##*/}
  SKILLS="${SKILLS:+$SKILLS|}$name"
done
unsafe_aliases() {
  awk -v names="$SKILLS" '
    FNR == 1 { yaml = 0; delete keys }
    /^```/ { yaml = ($0 ~ /^```ya?ml[[:space:]]*$/); delete keys; next }
    !yaml { next }
    /^[[:space:]]*[A-Za-z0-9_-]+:/ {
      match($0, /[^[:space:]]/); indent = RSTART - 1
      for (i in keys) if (i >= indent) delete keys[i]
      key = $0; sub(/^[[:space:]]*/, "", key); sub(/:.*/, "", key)
      keys[indent] = key
      if ($0 ~ /type:[[:space:]]*alias([[:space:],}]|$)/) {
        if (key == "type") {
          parent = -1
          for (i in keys) if (i < indent && i + 0 > parent) parent = i + 0
          key = keys[parent]
        }
        if (key ~ names) print FILENAME ":" FNR ": unsafe alias name: " key
      }
    }
  ' "$@"
}
# Runnable regression matrix: field order, target independence, block layout,
# sibling reset, unrelated-name control, and prose control.
for snippet in \
  'research-skill: {type: alias, target: /research}' \
  'research-skill: {target: /research, type: alias}' \
  'research-skill: {type: alias, target: /help}' \
  $'research-skill:\n  target: /help\n  type: alias'; do
  if [ -z "$(printf '```yaml\n%s\n```\n' "$snippet" | unsafe_aliases)" ]; then
    echo "FAIL: alias guard missed regression: $snippet"; FAIL=1
  fi
done
for snippet in \
  'rs: {type: alias, target: /research}' \
  $'research-skill:\n  type: shell\nrs:\n  type: alias\n  target: /research'; do
  if [ -n "$(printf '```yaml\n%s\n```\n' "$snippet" | unsafe_aliases)" ]; then
    echo "FAIL: alias guard rejected unrelated-name control"; FAIL=1
  fi
done
if [ -n "$(printf 'research-skill: {type: alias, target: /research}\n' | unsafe_aliases)" ]; then
  echo "FAIL: alias guard rejected prose control"; FAIL=1
fi
bad=$(unsafe_aliases README.md AGENTS.md CLAUDE.md docs/*.md docs/wiki/*.md)
if [ -n "$bad" ]; then
  printf '%s\n' "$bad"
  echo "FAIL: fenced YAML recommends an alias whose name contains a skill name (#96972)."
  FAIL=1
fi
if ! grep -q 'hermes-agent/issues/96972' docs/wiki/Troubleshooting.md; then
  echo "FAIL: docs/wiki/Troubleshooting.md lost the Hermes alias-collision entry (#96972)."
  FAIL=1
fi
if ! grep -q '^### Hermes TUI: `/research` Prints "Loading skill" Then Nothing Happens$' docs/wiki/Troubleshooting.md; then
  echo "FAIL: Troubleshooting heading changed; fix the anchors in Installation.md/Limitations.md (#96972)."
  FAIL=1
fi

# Pinned OpenClaw install tags in docs must match the current plugin version
# (docs/openclaw-integration.md drifted to v2.21.49 while README moved on, #409).
CUR=$(grep '"version"' .claude-plugin/plugin.json | head -1 | sed 's/.*"version": *"\([^"]*\)".*/\1/')
for doc in README.md docs/openclaw-integration.md; do
  [ -f "$doc" ] || continue
  if stale=$(grep -noE '8-habit-ai-dev@v[0-9]+\.[0-9]+\.[0-9]+' "$doc" | grep -v "@v$CUR\$"); then
    echo "FAIL: $doc pins an install tag other than v$CUR:"
    echo "$stale" | sed 's/^/      /'
    FAIL=1
  fi
done

if [ "$FAIL" -ne 0 ]; then
  echo ""
  echo "RESULT: FAILED"
  exit 1
fi

echo "RESULT: PASS — no skills/*/SKILL.md or plugin/skills/*/SKILL.md contains a Hermes-tap-breaking traversal pattern"
