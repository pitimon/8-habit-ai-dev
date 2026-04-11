#!/bin/bash
# 8-Habit AI Dev — Verbosity Hook Regression Test (v2.7.0, Issue #96)
#
# Covers the 8 hook branches in hooks/session-start.sh:
#   1. No profile file            → /calibrate nudge
#   2. level: Dependence          → Dependence directive
#   3. level: Independence        → Independence directive
#   4. level: Interdependence     → Interdependence directive
#   5. level: Significance        → Significance directive
#   6. verbosity-override=verbose → Dependence (override)
#   7. verbosity-override=concise → Significance (override)
#   8. level: <unknown/missing>   → Dependence fallback with warning
#
# Plus a HABIT_QUIET=1 silence check that applies across all 8 branches.
#
# Usage: bash tests/test-verbosity-hook.sh
# Called from .github/workflows/validate.yml alongside the other 3 validators.
#
# The test writes throwaway profile files to a temp HOME to avoid clobbering
# the real ~/.claude/habit-profile.md. Each assertion checks the hook output
# contains the expected substring for its branch.

set -euo pipefail

ERRORS=0
PASS=0

pass() { PASS=$((PASS + 1)); echo "  PASS: $1"; }
fail() { ERRORS=$((ERRORS + 1)); echo "  FAIL: $1"; }

echo "=== Verbosity Hook Regression Test (Issue #96) ==="
echo ""

# Temp sandbox — avoids touching the real ~/.claude/habit-profile.md
TMPHOME=$(mktemp -d)
trap 'rm -rf "$TMPHOME"' EXIT
mkdir -p "$TMPHOME/.claude"
HOOK="hooks/session-start.sh"

if [ ! -f "$HOOK" ]; then
  fail "$HOOK not found — must be run from repo root"
  exit 1
fi

# Helper: run the hook against a given profile content (or nothing if "" passed)
# and assert the output contains $expected_substring.
run_case() {
  local case_name="$1"
  local profile_content="$2"  # empty string = no profile file
  local expected_substring="$3"

  if [ -n "$profile_content" ]; then
    printf '%s' "$profile_content" > "$TMPHOME/.claude/habit-profile.md"
  else
    rm -f "$TMPHOME/.claude/habit-profile.md"
  fi

  local output
  output=$(HOME="$TMPHOME" bash "$HOOK" 2>&1) || {
    fail "$case_name — hook exited non-zero"
    return
  }

  if echo "$output" | grep -qF "$expected_substring"; then
    pass "$case_name"
  else
    fail "$case_name — expected substring not found: \"$expected_substring\""
    echo "    got (last line): $(echo "$output" | tail -1)"
  fi
}

# --- Branch 1: No profile file → /calibrate nudge ---
echo "--- Branch 1: No profile → nudge ---"
run_case "no profile emits /calibrate nudge" "" "No habit profile detected"
echo ""

# --- Branches 2-5: Each level emits its directive ---
echo "--- Branches 2-5: Per-level directives ---"

DEPENDENCE_PROFILE='---
level: Dependence
calibrated: 2026-04-11T15:00:00+07:00
schema-version: 1
responses:
  plugin-experience: "first session"
  ci-experience: "still learning"
  team-context: "solo"
  vocabulary-comfort: "brand new terms"
  orientation: "mostly fixing"
preferences:
  verbosity-override: none
---

# Habit Profile — Dependence
'

INDEPENDENCE_PROFILE='---
level: Independence
calibrated: 2026-04-11T15:00:00+07:00
schema-version: 1
responses:
  plugin-experience: "a few months"
  ci-experience: "comfortable solo"
  team-context: "solo"
  vocabulary-comfort: "roughly familiar"
  orientation: "mix"
preferences:
  verbosity-override: none
---

# Habit Profile — Independence
'

INTERDEPENDENCE_PROFILE='---
level: Interdependence
calibrated: 2026-04-11T15:00:00+07:00
schema-version: 1
responses:
  plugin-experience: "several months"
  ci-experience: "mentor peers"
  team-context: "lead a team"
  vocabulary-comfort: "mostly clear"
  orientation: "mostly preventing"
preferences:
  verbosity-override: none
---

# Habit Profile — Interdependence
'

SIGNIFICANCE_PROFILE='---
level: Significance
calibrated: 2026-04-11T15:00:00+07:00
schema-version: 1
responses:
  plugin-experience: "over a year"
  ci-experience: "set org standards"
  team-context: "org-wide"
  vocabulary-comfort: "teach externally"
  orientation: "preventing for community"
preferences:
  verbosity-override: none
---

# Habit Profile — Significance
'

run_case "Dependence level directive"    "$DEPENDENCE_PROFILE"    "Profile active: Dependence"
run_case "Independence level directive"  "$INDEPENDENCE_PROFILE"  "Profile active: Independence"
run_case "Interdependence level directive" "$INTERDEPENDENCE_PROFILE" "Profile active: Interdependence"
run_case "Significance level directive"  "$SIGNIFICANCE_PROFILE"  "Profile active: Significance"
echo ""

# --- Branches 6-7: verbosity-override precedence ---
echo "--- Branches 6-7: verbosity-override precedence ---"

VERBOSE_OVERRIDE_PROFILE='---
level: Significance
calibrated: 2026-04-11T15:00:00+07:00
schema-version: 1
responses:
  plugin-experience: "over a year"
  ci-experience: "set org standards"
  team-context: "org-wide"
  vocabulary-comfort: "teach externally"
  orientation: "preventing for community"
preferences:
  verbosity-override: verbose
---

# Habit Profile — Significance (verbose override)
'

CONCISE_OVERRIDE_PROFILE='---
level: Dependence
calibrated: 2026-04-11T15:00:00+07:00
schema-version: 1
responses:
  plugin-experience: "first session"
  ci-experience: "still learning"
  team-context: "solo"
  vocabulary-comfort: "brand new terms"
  orientation: "mostly fixing"
preferences:
  verbosity-override: concise
---

# Habit Profile — Dependence (concise override)
'

run_case "verbose override promotes Significance → Dependence" "$VERBOSE_OVERRIDE_PROFILE" "verbose override"
run_case "concise override demotes Dependence → Significance"  "$CONCISE_OVERRIDE_PROFILE" "concise override"
echo ""

# --- Branches 6b: optional heart/spirit signal keys don't break extraction ---
# (Regression test from Smart QA finding F1 — profile author who answered Q6/Q7
# writes heart-signal and spirit-signal keys under responses. The hook's awk
# extraction for `level` and `verbosity-override` must ignore these extra keys.)
echo "--- Branch 6b: optional Q6/Q7 signal keys are tolerated ---"

OPTIONAL_KEYS_PROFILE='---
level: Interdependence
calibrated: 2026-04-11T15:00:00+07:00
schema-version: 1
responses:
  plugin-experience: "several months"
  ci-experience: "mentor peers"
  team-context: "lead a team"
  vocabulary-comfort: "mostly clear"
  orientation: "mostly preventing"
  heart-signal: "publish/teach publicly"
  spirit-signal: "I publicly advocate for this"
preferences:
  verbosity-override: none
---

# Habit Profile — Interdependence (with optional Q6/Q7 signals)
'

run_case "optional heart/spirit keys: hook still emits correct Interdependence directive" "$OPTIONAL_KEYS_PROFILE" "Profile active: Interdependence"
echo ""

# --- Branch 8: Unknown/missing level → Dependence fallback ---
echo "--- Branch 8: Unknown/missing level → Dependence fallback ---"

UNKNOWN_LEVEL_PROFILE='---
level: Mastery
calibrated: 2026-04-11T15:00:00+07:00
schema-version: 1
responses:
  plugin-experience: "several months"
preferences:
  verbosity-override: none
---

# Habit Profile — Mastery (not a valid level)
'

MISSING_LEVEL_PROFILE='---
calibrated: 2026-04-11T15:00:00+07:00
schema-version: 1
responses:
  plugin-experience: "several months"
preferences:
  verbosity-override: none
---

# Habit Profile (missing level field)
'

run_case "unknown level string → fallback warning" "$UNKNOWN_LEVEL_PROFILE" "Profile exists but level is unknown"
run_case "missing level field → fallback warning"  "$MISSING_LEVEL_PROFILE" "Profile exists but level is unknown"
echo ""

# --- HABIT_QUIET silence check — applies to all branches ---
echo "--- HABIT_QUIET=1 silence (ADR-006 contract preserved) ---"
printf '%s' "$INTERDEPENDENCE_PROFILE" > "$TMPHOME/.claude/habit-profile.md"
quiet_output=$(HOME="$TMPHOME" HABIT_QUIET=1 bash "$HOOK" 2>&1 || true)
if [ -z "$quiet_output" ]; then
  pass "HABIT_QUIET=1 silences hook output even with active profile"
else
  fail "HABIT_QUIET=1 did not silence output (got: ${quiet_output:0:100}...)"
fi
echo ""

# --- Token budget check (≤300 per CLAUDE.md) ---
echo "--- Token budget check ---"
printf '%s' "$INTERDEPENDENCE_PROFILE" > "$TMPHOME/.claude/habit-profile.md"
word_count=$(HOME="$TMPHOME" bash "$HOOK" 2>&1 | wc -w | tr -d ' ')
# Rough token estimate: words * 1.3 for markdown + punctuation overhead
token_estimate=$((word_count * 13 / 10))
if [ "$token_estimate" -le 300 ]; then
  pass "hook output fits ≤300 token budget (estimate: ~${token_estimate} tokens from ${word_count} words)"
else
  fail "hook output exceeds 300 token budget (estimate: ~${token_estimate} tokens from ${word_count} words)"
fi
echo ""

# --- Summary ---
echo "=== Summary ==="
echo "PASS: $PASS"
echo "FAIL: $ERRORS"
echo ""
if [ "$ERRORS" -gt 0 ]; then
  echo "RESULT: FAILED ($ERRORS errors)"
  exit 1
else
  echo "RESULT: ALL CHECKS PASSED"
  exit 0
fi
