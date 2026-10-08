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
# Scope: tracked *.md only. Exclusions (with reason):
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
PAT='https://(raw\.githubusercontent\.com/pitimon/8-habit-ai-dev/main|github\.com/pitimon/8-habit-ai-dev/(blob|tree)/main)/[^)[:space:]>"]+'

FAIL=0
N=0

# git ls-files pathspec exclusions keep docs/wiki and plugin out; tracked files
# only, so .gitignore'd build output can never be linked-by-mistake either.
while IFS= read -r f; do
  urls=$(grep -Eo "$PAT" "$f" || true)
  [ -z "$urls" ] && continue
  while IFS= read -r url; do
    path=${url#*/main/}
    path=${path%%\?*}   # strip query string, if any
    path=${path%%#*}    # strip #fragment / #L10 line anchor, if any
    case "$path" in
      *...*) continue ;;  # literal-placeholder prose, not a link
    esac
    N=$((N + 1))
    if [ -e "$path" ]; then
      echo "  PASS: $f -> $url"
    else
      # awk line lookup, not grep | head (SIGPIPE under pipefail — DOMAIN.md)
      line=$(awk -v s="$url" 'index($0, s) { print NR; exit }' "$f")
      echo "  FAIL: $f:$line -> $url (no such tracked path: $path)"
      FAIL=1
    fi
  done <<< "$urls"
done < <(git ls-files '*.md' -- . ':(exclude)docs/wiki' ':(exclude)plugin')

echo ""
if [ "$FAIL" -ne 0 ]; then
  echo "RESULT: FAIL — $N self-links checked, at least one /main/ URL dangles."
  echo "Fix the file path, or point the link at its real replacement."
  exit 1
fi
echo "RESULT: PASS — $N self-referential /main/ URLs all resolve to tracked files."
