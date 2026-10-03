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

# --- #399: score scope + core-claim gating ---
# Pins the contract that a process-completeness score is not read as
# evidence of correctness, and that an unverified core claim holds the
# recommendation regardless of score.
XV_GUIDE="guides/cross-verification.md"
printf '\n%s\n' "--- #399 core-claim gating ---"
if [ -f "$SKILL" ]; then
  require "$SKILL" "Score scope**: process completeness (verification)" "report header states score scope (FR-001)"
  require "$SKILL" "not evidence that conclusions or changed runtime behavior are correct (validation)" "score scope disclaims correctness (FR-001)"
  require "$SKILL" "**Core claims**" "report lists core claims (FR-002)"
  require "$SKILL" "independent? Y/N" "core claims carry an independence flag (FR-002)"
  require "$SKILL" "hold: verify core claim" "unverified core claim holds the recommendation (FR-003)"
  require "$SKILL" "score and band are computed unchanged" "hold rule does not alter the score (FR-003)"
  require "$SKILL" "only been checked by me, with my own evidence" "Shadow Self-Check asks own-evidence question (FR-006)"
  require "$SKILL" "would my evidence look different" "Shadow Self-Check asks discriminating question (FR-006)"
  require "$SKILL" "≥88%" "skill band table states percent thresholds (FR-007)"
  require "$SKILL" "| ≥70% |" "skill bands are half-open — no gap at 87.5% (FR-007)"
  require "$SKILL" "lower bands keep theirs" "hold never raises a lower-band recommendation (FR-003)"
  require "$SKILL" "Unbuilt claims in a pre-implementation plan go to Q5's test plan" "pre-implementation carve-out protects plan reviews (FR-003)"
  require "$SKILL" "diagnosed premises stay established" "carve-out does not exempt diagnoses (FR-003)"
  require "$SKILL" "production Release verdict is \`HOLD\`" "core-claim hold maps to production HOLD (FR-003)"
  require "$SKILL" "Always list the claim the change exists to make true" "headline claim cannot be omitted (FR-002)"
  words=$(wc -w < "$SKILL" | tr -d ' ')
  if [ "$words" -le 1970 ]; then
    pass "cross-verify SKILL.md keeps ≥30-word margin ($words words, FR-008)"
  else
    fail "cross-verify SKILL.md has $words words — FR-008 requires ≤1970"
  fi
fi
if [ -f "$XV_GUIDE" ]; then
  require "$XV_GUIDE" "## Core-Claim Verification" "guide defines core-claim verification (FR-004)"
  require "$XV_GUIDE" "real host" "integration claims require real-host exercise (FR-004)"
  require "$XV_GUIDE" "control case" "integration claims require a control case (FR-004)"
  require "$XV_GUIDE" "find the writer" "absence claims cite the writer line (FR-005)"
  require "$XV_GUIDE" "≥88%" "guide band table states percent thresholds (FR-007)"
  require "$XV_GUIDE" "the reviewer does not get to pick only the safe ones" "guide defines mandatory core claims (FR-002)"
  require "$XV_GUIDE" "with mocks alone, record the claim as \`OPEN_VERIFICATION_DEBT\`" "mocked-host evidence is debt (FR-004)"
  require "$XV_GUIDE" "so the claim is \`OPEN_VERIFICATION_DEBT\`, not \`PASS\`" "non-discriminating evidence is debt (FR-006)"
  require "$XV_GUIDE" "This carve-out covers only unbuilt behavior" "plan carve-out is bounded (FR-003)"
  require "$XV_GUIDE" "The hold lifts when the claim is re-graded" "hold has an exit condition (FR-003)"
else
  fail "$XV_GUIDE missing"
fi
if [ -f "$GUIDE" ]; then
  require "$GUIDE" "core claim in \`FAIL\` or \`OPEN_VERIFICATION_DEBT\` is blocking too" "production guide honors the core-claim hold (FR-003)"
fi

printf '\n=== Summary ===\nPASS: %s\nFAIL: %s\n' "$PASS" "$ERRORS"
if [ "$ERRORS" -gt 0 ]; then
  echo "RESULT: FAILED ($ERRORS errors)"
  exit 1
fi
echo "RESULT: ALL CHECKS PASSED"
