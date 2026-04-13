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

# Habit profile state — emits level-specific adaptation directive (v2.7.0, Issue #96).
# When ~/.claude/habit-profile.md exists with a valid level, outputs a one-sentence
# directive that shapes how skills should adapt their verbosity in the session.
# When the profile is missing, falls back to the v2.6.0 /calibrate nudge.
#
# Override precedence: preferences.verbosity-override (verbose|concise) > level field.
# Unknown/missing level → Dependence fallback (safest for uncalibrated users).
#
# awk patterns use the pipe-safe "read until exit" technique from
# tests/validate-structure.sh:27 and validate-content.sh:614 to avoid the
# sed|head SIGPIPE flake fixed in v2.6.1.
PROFILE_MSG=""
PROFILE_FILE="${HOME}/.claude/habit-profile.md"
if [ -f "$PROFILE_FILE" ] && [ -r "$PROFILE_FILE" ]; then
  # Extract level from frontmatter (between --- markers)
  LEVEL=$(awk '/^---$/{c++; if(c==2) exit; next} c==1 && /^level:/{sub(/^level:[[:space:]]*/, ""); print; exit}' "$PROFILE_FILE" 2>/dev/null)
  # Extract verbosity-override (nested under preferences:)
  OVERRIDE=$(awk '/^preferences:/{f=1; next} /^[^[:space:]]/{if(f) exit; next} f && /verbosity-override:/{sub(/^[[:space:]]*verbosity-override:[[:space:]]*/, ""); print; exit}' "$PROFILE_FILE" 2>/dev/null)

  # Apply override precedence: explicit verbose/concise wins over level
  case "$OVERRIDE" in
    verbose)   EFFECTIVE_LEVEL="Dependence (verbose override)"; DIRECTIVE_LEVEL="Dependence" ;;
    concise)   EFFECTIVE_LEVEL="Significance (concise override)"; DIRECTIVE_LEVEL="Significance" ;;
    ""|none)   EFFECTIVE_LEVEL="$LEVEL"; DIRECTIVE_LEVEL="$LEVEL" ;;
    *)         EFFECTIVE_LEVEL="$LEVEL"; DIRECTIVE_LEVEL="$LEVEL" ;;
  esac

  # Emit level-specific one-sentence directive
  case "$DIRECTIVE_LEVEL" in
    Dependence)
      PROFILE_MSG="
📖 **Profile active: ${EFFECTIVE_LEVEL}** — skills should show full guidance, all checkpoints, and beginner examples inline."
      ;;
    Independence)
      PROFILE_MSG="
📖 **Profile active: ${EFFECTIVE_LEVEL}** — skills should show key checkpoints only and skip beginner examples."
      ;;
    Interdependence)
      PROFILE_MSG="
📖 **Profile active: ${EFFECTIVE_LEVEL}** — skills should focus on delegation, review, and synergy patterns over individual ceremony."
      ;;
    Significance)
      PROFILE_MSG="
📖 **Profile active: ${EFFECTIVE_LEVEL}** — skills should show minimal prompts, trust user judgment, and surface only non-obvious checkpoints."
      ;;
    *)
      # Unknown or missing level → Dependence fallback with visible note
      PROFILE_MSG="
⚠️ **Profile exists but level is unknown** (got: \"${LEVEL:-<missing>}\") — using Dependence (full guidance) as fallback. Run \`/calibrate\` to refresh."
      ;;
  esac
else
  # No profile file → v2.6.0 nudge (backwards compatible)
  PROFILE_MSG="
💡 **No habit profile detected** — run \`/calibrate\` to personalize guidance to your maturity level (H8)."
fi

# Workflow step awareness — detect highest completed step and suggest next skill
WORKFLOW_HINT=""
if [ "${HABIT_QUIET:-0}" != "1" ]; then
  HIGHEST_STEP=0

  # Check each step — use compgen (bash builtin) to test globs without ls exit-code issues
  has_glob() { compgen -G "$1" >/dev/null 2>&1; }

  # Check for Step 4 artifacts (build brief) — highest priority
  if has_glob "*-brief.md" || has_glob "*build-brief*"; then
    HIGHEST_STEP=4
  # Check for Step 3 artifacts (breakdown/tasks)
  elif has_glob "*-tasks.md" || has_glob "*-breakdown.md" || has_glob "*task-list*"; then
    HIGHEST_STEP=3
  # Check for Step 2 artifacts (design/architecture)
  elif has_glob "*-design.md" || has_glob "*-architecture.md" || has_glob "*ADR*"; then
    HIGHEST_STEP=2
  # Check for Step 1 artifacts (PRD/requirements)
  elif has_glob "*-prd.md" || has_glob "*-requirements.md" || has_glob "*PRD*"; then
    HIGHEST_STEP=1
  fi

  if [ "$HIGHEST_STEP" -gt 0 ]; then
    case $HIGHEST_STEP in
      1) NEXT_SKILL="/design" ;;
      2) NEXT_SKILL="/breakdown" ;;
      3) NEXT_SKILL="/build-brief" ;;
      4) NEXT_SKILL="/review-ai" ;;
    esac
    WORKFLOW_HINT="
📍 Workflow: artifacts suggest Step ${HIGHEST_STEP} done — next: \`${NEXT_SKILL}\`"
  fi
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
**Onboarding**: \`/using-8-habits\` (decision tree) · \`/calibrate\` (maturity profile)
**Compliance**: \`/eu-ai-act-check\` (EU AI Act, migration to claude-governance planned)${WORKFLOW_HINT}${PROFILE_MSG}

_Silence this reminder: \`export HABIT_QUIET=1\`_
EOF
