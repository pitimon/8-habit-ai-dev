#!/bin/bash
# test-self-link-targets.sh — self-referential main-branch URLs must resolve
# to real files in this repo (#419 follow-up).
#
# WHY: .github/workflows/link-check.yml (lychee) excludes EVERY self-referential
# (blob|tree|raw)/main/ URL — a deliberate chicken-and-egg guard, because those
# URLs only resolve on GitHub AFTER a PR merges. The blind spot shipped a real
# dead link: llms.txt pointed at guides/eu-ai-act-mapping.md for months after
# ADR-012 migrated it to pitimon/claude-governance. This test re-checks exactly
# that excluded class against the WORKING TREE instead of the network: on a PR
# checkout the working tree already contains the PR's files, so there is no
# chicken-and-egg and a same-repo /main/ URL has no excuse to dangle.
#
# Scope: tracked *.md and llms.txt source files. Exclusions (with reason):
#   - docs/wiki/  — wiki-style link semantics, covered by wiki-linkcheck.yml
#   - plugin/     — byte-for-byte mirror of root (Check 28 parity); scanning
#                   root covers the mirror
#
# Placeholders: prose like `https://github.com/.../blob/main/...` (literal ...)
# is a documentation example, not a link — paths containing "..." are skipped.
#
# USAGE: bash tests/test-self-link-targets.sh
set -euo pipefail
cd "$(dirname "$0")/.."

# Self-referential main-branch URLs, both GitHub web and raw forms.
PAT='https://(raw\.githubusercontent\.com/pitimon/8-habit-ai-dev/main|github\.com/pitimon/8-habit-ai-dev/(blob|tree)/main)/[^][)`[:space:]>"]+'

if ! files=$(git ls-files -- '*.md' llms.txt ':(exclude)docs/wiki' ':(exclude)plugin'); then
  echo 'FAIL: cannot enumerate tracked source files'
  exit 1
fi
if ! tracked=$(git ls-files); then
  echo 'FAIL: cannot enumerate tracked targets'
  exit 1
fi

# Compare exact index spelling, independent of filesystem case sensitivity.
# tree URLs need a tracked descendant; raw/blob URLs need a tracked file.
target_exists() {
  local path=$1 tree=$2 entry
  while IFS= read -r entry; do
    if [ "$tree" = yes ]; then
      case "$entry" in
        "$path"/*) [ -f "$entry" ] && return 0 ;;
      esac
    elif [ "$entry" = "$path" ] && [ -f "$path" ]; then
      return 0
    fi
  done <<< "$tracked"
  return 1
}

FAIL=0
N=0

# Explicit source pathspecs keep llms.txt in scope without scanning scripts.
while IFS= read -r f; do
  [ -z "$f" ] && continue
  if urls=$(grep -Eo "$PAT" "$f"); then
    :
  else
    rc=$?
    if [ "$rc" -ne 1 ]; then
      echo "FAIL: URL extraction failed for $f (grep exit $rc)"
      exit 1
    fi
  fi
  [ -z "$urls" ] && continue
  while IFS= read -r url; do
    case "${url#*/main/}" in
      *...*) continue ;;  # skip placeholders before trimming punctuation
    esac
    # Sentence punctuation is not part of these repository paths; preserve
    # internal periods/commas and strip only punctuation at the end.
    while :; do
      case "$url" in
        *.|*,|*\;|*:) url=${url%?} ;;
        *) break ;;
      esac
    done
    path=${url#*/main/}
    path=${path%%\?*}   # strip query string, if any
    path=${path%%#*}    # strip #fragment / #L10 line anchor, if any
    case "$path" in
      *...*) continue ;;  # literal-placeholder prose, not a link
    esac
    N=$((N + 1))
    tree=no
    case "$url" in
      https://github.com/pitimon/8-habit-ai-dev/tree/main/*) tree=yes; path=${path%/} ;;
    esac
    if target_exists "$path" "$tree"; then
      echo "  PASS: $f -> $url"
    else
      # awk line lookup, not grep | head (SIGPIPE under pipefail — DOMAIN.md)
      line=$(awk -v s="$url" 'index($0, s) { print NR; exit }' "$f")
      echo "  FAIL: $f:$line -> $url (no exact tracked working-tree target: $path)"
      FAIL=1
    fi
  done <<< "$urls"
done <<< "$files"

echo ""
if [ "$N" -eq 0 ]; then
  echo 'FAIL: no self-referential URLs found; refusing an empty scan'
  exit 1
fi
if [ "$FAIL" -ne 0 ]; then
  echo "RESULT: FAIL — $N self-links checked, at least one /main/ URL dangles."
  echo "Fix the file path, or point the link at its real replacement."
  exit 1
fi
echo "RESULT: PASS — $N self-referential /main/ URL occurrences resolve to exact tracked working-tree targets."
case "${1:-}" in
  --scan-only) ;;
  '') bash tests/test-self-link-targets-regression.sh ;;
  *) echo "FAIL: unsupported argument: $1"; exit 1 ;;
esac
