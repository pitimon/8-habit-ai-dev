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
