#!/bin/bash
# 8-Habit AI Dev — Session Start Reminder (≤300 tokens)
#
# Opt out: export HABIT_QUIET=1 (silences this reminder entirely)

# Honor opt-out before any work
[[ "${HABIT_QUIET:-}" == "1" ]] && exit 0

# Read version from plugin.json for the session banner
VERSION=$(sed -n 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' \
  "${CLAUDE_PLUGIN_ROOT:-.}/.claude-plugin/plugin.json" 2>/dev/null | head -1)
VERSION="${VERSION:-unknown}"

# Check for workflow artifacts to show progress
PRD="" ; ADR="" ; TASKS="" ; BRIEF=""
[ -f PRD.md ] || [ -f docs/PRD.md ] && PRD="✓"
[ -d ADR ] || [ -d docs/ADR ] && ADR="✓"
[ -f TASKS.md ] || [ -f docs/TASKS.md ] && TASKS="✓"

if [ -n "$PRD$ADR$TASKS" ]; then
  PROGRESS=" | Progress: ${PRD:+①}${ADR:+②}${TASKS:+③}"
else
  PROGRESS=""
fi

cat <<EOF
## 8-Habit AI Dev Active (v${VERSION})

**7-Step Workflow reference** — use what fits the task:
0. \`/research\` — Investigate before specifying (H5)
1. \`/requirements\` — Define what, why, who + EARS criteria (H2)${PRD:+ ✓}
2. \`/design\` — Architecture decisions + Art. 14 checkpoint (H8)${ADR:+ ✓}
3. \`/breakdown\` — Atomic tasks (H3)${TASKS:+ ✓}
4. \`/build-brief\` — Context before coding (H5)
5. \`/review-ai\` — Audit before commit (H4)
6. \`/deploy-guide\` — Staging first (H1)
7. \`/monitor-setup\` — Observe after deploy (H7)

**Core 5** (80% of daily work): \`/requirements\` · \`/review-ai\` · \`/cross-verify\` · \`/research\` · \`/reflect\`
**Assessment**: \`/workflow\` · \`/whole-person-check\` · \`/security-check\` · \`/ai-dev-log\`
**Onboarding**: \`/using-8-habits\` (decision tree + Core 5 explained)
**Compliance**: \`/eu-ai-act-check\` (EU AI Act, migration to claude-governance planned)

_Silence this reminder: \`export HABIT_QUIET=1\`_
EOF
