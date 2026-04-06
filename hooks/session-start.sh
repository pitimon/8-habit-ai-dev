#!/bin/bash
# 8-Habit AI Dev — Session Start Reminder (≤300 tokens)

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
## 8-Habit AI Dev Active

**7-Step Workflow** (not Vibe Coding)${PROGRESS}:
1. \`/requirements\` — Define what, why, who (H2)${PRD:+ ✓}
2. \`/design\` — Architecture decisions (H8)${ADR:+ ✓}
3. \`/breakdown\` — Atomic tasks (H3)${TASKS:+ ✓}
4. \`/build-brief\` — Context before coding (H5)
5. \`/review-ai\` — Audit before commit (H4)
6. \`/deploy-guide\` — Staging first (H1)
7. \`/monitor-setup\` — Observe after deploy (H7)

**New**: \`/workflow\` — Guided 7-step walkthrough | \`/whole-person-check\` — Body/Mind/Heart/Spirit
**Cross-verify**: \`/cross-verify\` — 17-question 8-Habit checklist + dimension summary

**Principle**: ทำเสร็จ ≠ ทำดี — "Done" is not "Done well"
EOF
