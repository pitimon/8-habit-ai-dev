#!/bin/bash
# test-hermes-tap-links.sh — regression guard for issue #386.
#
# WHY: Hermes's Skills Hub fetcher (tools/skills_hub_models.py
# _referenced_support_paths) fail-closes an ENTIRE skill install — not just
# the offending link — when a SKILL.md contains a same-directory markdown
# link whose target starts with "..". Every skills/*/SKILL.md link to repo
# docs must therefore use an absolute URL (https://github.com/...), never a
# repo-root-relative "../../" path, or `hermes skills tap add`/`install`
# breaks for that skill with "Could not fetch ... from any source."
#
# USAGE: bash tests/test-hermes-tap-links.sh   (from repo root or anywhere)
set -euo pipefail

cd "$(dirname "$0")/.."

FAIL=0

for f in skills/*/SKILL.md; do
  if grep -qE '\]\(\.\./' "$f"; then
    echo "FAIL: $f contains a relative parent-directory markdown link ']( ../...)'."
    echo "      Replace it with an absolute https://github.com/pitimon/8-habit-ai-dev/blob/main/... URL"
    echo "      (see issue #386 — this pattern breaks 'hermes skills tap add/install')."
    grep -nE '\]\(\.\./' "$f" | sed 's/^/      /'
    FAIL=1
  fi
done

if [ "$FAIL" -ne 0 ]; then
  echo ""
  echo "RESULT: FAILED"
  exit 1
fi

echo "RESULT: PASS — no skills/*/SKILL.md contains a relative parent-directory link"
