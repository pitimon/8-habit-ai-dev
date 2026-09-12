#!/bin/bash
# Cross-Verify production release-gate contract regression test (#384).
# This is a documentation/plugin contract: it pins scoring semantics and
# read-only boundaries without claiming to exercise a live deployment.

set -euo pipefail

ERRORS=0
PASS=0

pass() { PASS=$((PASS + 1)); echo "  PASS: $1"; }
fail() { ERRORS=$((ERRORS + 1)); echo "  FAIL: $1"; }
require() {
  local file="$1" phrase="$2" label="$3"
  if grep -qF "$phrase" "$file"; then
    pass "$label"
  else
    fail "$label — missing '$phrase' in $file"
  fi
}

SKILL="skills/cross-verify/SKILL.md"
GUIDE="guides/production-release-gates.md"

printf '%s\n\n' "=== Cross-Verify Production Release-Gate Contract (#384) ==="

for file in "$SKILL" "$GUIDE"; do
  if [ -f "$file" ]; then
    pass "$file exists"
  else
    fail "$file missing"
  fi
done

if [ -f "$SKILL" ]; then
  require "$SKILL" "OPEN_VERIFICATION_DEBT" "cross-verify defines verification-debt status"
  require "$SKILL" "does not count as PASS" "verification debt cannot inflate the core score"
  require "$SKILL" "core score cannot override a blocking domain gate" "domain gates control production verdicts"
  require "$SKILL" "guides/production-release-gates.md" "cross-verify loads the production gate contract"
fi

if [ -f "$GUIDE" ]; then
  for state in PLAN READY CANARY OBSERVING PROVISIONAL_KEEP FINAL_KEEP HOLD ROLLBACK; do
    require "$GUIDE" "\`$state\`" "release state $state is documented"
  done
  require "$GUIDE" "PASS / FAIL / N/A / OPEN_VERIFICATION_DEBT" "gate status vocabulary is explicit"
  require "$GUIDE" "PASS / (total - N/A)" "adjusted-score formula is explicit"
  require "$GUIDE" "does not execute deployment commands" "production profile remains guidance-only"
  require "$GUIDE" "does not grant approval" "production profile preserves approval boundary"
  require "$GUIDE" "Core score" "production report separates the core score"
  require "$GUIDE" "Release verdict" "production report includes an independent verdict"
fi

printf '\n=== Summary ===\nPASS: %s\nFAIL: %s\n' "$PASS" "$ERRORS"
if [ "$ERRORS" -gt 0 ]; then
  echo "RESULT: FAILED ($ERRORS errors)"
  exit 1
fi
echo "RESULT: ALL CHECKS PASSED"
