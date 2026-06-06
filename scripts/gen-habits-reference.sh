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
  echo "## Origin And Adaptation"
  echo ""
  echo "The source inspiration is Stephen R. Covey's *The 7 Habits of Highly Effective People* and *The 8th Habit*. This plugin is not official FranklinCovey training material; it is an engineering adaptation that uses the habit structure to make AI-assisted development more deliberate and reviewable."
  echo ""
  echo "FranklinCovey describes the 7 Habits as a framework that moves people from dependence and independence toward interdependence, organized around Private Victory, Public Victory, and Renewal. In this plugin, that becomes a development workflow:"
  echo ""
  echo "| Covey frame | Plugin adaptation | Example skills |"
  echo "| --- | --- | --- |"
  echo "| Private Victory, Habits 1-3 | Manage the work before asking AI to generate output | \`/deploy-guide\`, \`/requirements\`, \`/breakdown\` |"
  echo "| Public Victory, Habits 4-6 | Make collaboration, review, and handoff explicit | \`/review-ai\`, \`/management-talk\`, \`/cross-verify\` |"
  echo "| Renewal, Habit 7 | Improve the system after each cycle | \`/monitor-setup\`, \`/reflect\`, \`/post-mortem\` |"
  echo "| The 8th Habit | Keep human voice, conscience, and judgment visible | \`/design\`, \`/whole-person-check\`, \`/calibrate\` |"
  echo ""
  echo "The 8th Habit's \"voice\" idea maps especially well to AI-assisted development. In this plugin, voice means the human still owns architecture, purpose, conscience, and irreversible decisions. \"Inspire others to find theirs\" becomes reusable skills, clear docs, useful review comments, management-ready summaries, and lessons that help the next developer."
  echo ""
  echo "> [!NOTE]"
  echo "> The adaptation is intentionally conservative: Covey provides the human-effectiveness frame; the plugin translates that frame into markdown guidance, not runtime enforcement or compliance certification."
  echo ""
  echo "References:"
  echo ""
  echo "- [FranklinCovey: The 7 Habits of Highly Effective People](https://www.franklincovey.com/courses/the-7-habits/)"
  echo "- [FranklinCovey book page: The 7 Habits](https://www.franklincovey.com/books/the-7-habits-of-highly-effective-people/)"
  echo ""
  echo "## Table of Contents"
  echo ""
  echo "- [Origin And Adaptation](#origin-and-adaptation)"
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

perl -0pi -e 's/\n+\z/\n/' "$OUT"

echo "Generated: $OUT ($(wc -l < "$OUT") lines)"
