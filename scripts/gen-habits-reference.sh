#!/usr/bin/env bash
# Generate docs/wiki/Habits-Reference.md by concatenating habits/h*.md
# Called by .github/workflows/wiki-sync.yml before wiki push.
# Keeps habits content DRY — single source is habits/, wiki is rendered view.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/docs/wiki/Habits-Reference.md"
SRC_DIR="$ROOT/habits"

if [ ! -d "$SRC_DIR" ]; then
  echo "ERROR: $SRC_DIR not found" >&2
  exit 1
fi

mkdir -p "$(dirname "$OUT")"

{
  echo "# 8 Habits Reference"
  echo ""
  echo "> Auto-generated from [\`habits/\`](https://github.com/pitimon/8-habit-ai-dev/tree/main/habits) — **do not edit this page directly**. Edit the source files and submit a PR."
  echo ""
  echo "Based on Stephen Covey's *7 Habits of Highly Effective People* + *The 8th Habit*, adapted for AI-assisted development."
  echo ""
  echo "## Table of Contents"
  echo ""
  for f in "$SRC_DIR"/h*.md; do
    [ -f "$f" ] || continue
    title=$(head -n 1 "$f" | sed 's/^#[[:space:]]*//')
    anchor=$(echo "$title" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9 -]//g' | tr ' ' '-')
    echo "- [$title](#$anchor)"
  done
  echo ""
  echo "---"
  echo ""
  for f in "$SRC_DIR"/h*.md; do
    [ -f "$f" ] || continue
    # Rewrite inter-habit relative links to in-page anchors and ../README.md to a repo URL,
    # so the concatenated wiki page has no broken relative paths.
    sed \
      -e 's|(h1-be-proactive\.md)|(#habit-1-be-proactive)|g' \
      -e 's|(h2-begin-with-end\.md)|(#habit-2-begin-with-the-end-in-mind)|g' \
      -e 's|(h3-first-things-first\.md)|(#habit-3-put-first-things-first)|g' \
      -e 's|(h4-win-win\.md)|(#habit-4-think-win-win)|g' \
      -e 's|(h5-understand-first\.md)|(#habit-5-seek-first-to-understand)|g' \
      -e 's|(h6-synergize\.md)|(#habit-6-synergize)|g' \
      -e 's|(h7-sharpen-saw\.md)|(#habit-7-sharpen-the-saw)|g' \
      -e 's|(h8-find-voice\.md)|(#habit-8-find-your-voice-and-inspire-others)|g' \
      -e 's|(\.\./README\.md)|(https://github.com/pitimon/8-habit-ai-dev#readme)|g' \
      "$f"
    echo ""
    echo "---"
    echo ""
  done
} > "$OUT"

echo "Generated: $OUT ($(wc -l < "$OUT") lines)"
