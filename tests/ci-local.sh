#!/bin/bash
# ci-local.sh — run the EXACT validator set CI runs, in one shot (Fable F14, #360).
# Requires bash (child scripts use process substitution). Do not run with sh.
#
# WHY: the CI `validate` job (.github/workflows/validate.yml) runs FIVE scripts.
# Declaring "green" after running only validate-structure.sh has already caused
# one blocked merge (branch protection failed on validate-content.sh Check 19 —
# lesson 2026-06-28, "CI-parity local gate"). This script closes that gap:
# derive the set from validate.yml when editing — the list below MUST stay in
# lock-step with the workflow's steps.
#
# NOTE: validate-content.sh Check 19 sub-checks E/F need full git tag history.
# A fresh shallow clone will fail there; `git fetch --tags --unshallow` first.
#
# USAGE: bash tests/ci-local.sh   (from the repo root or anywhere; it cd's up)
set -euo pipefail

cd "$(dirname "$0")/.."

# Keep in lock-step with .github/workflows/validate.yml steps.
SCRIPTS="validate-structure.sh test-skill-graph.sh validate-content.sh test-verbosity-hook.sh test-pre-commit-hook.sh"

FAILED=""
for s in $SCRIPTS; do
  echo ""
  echo "════ tests/$s ════"
  if ! bash "tests/$s"; then
    FAILED="$FAILED $s"
    # Keep going: report ALL failing suites in one run instead of fixing one
    # at a time against CI.
  fi
done

echo ""
echo "════ ci-local summary ════"
if [ -n "$FAILED" ]; then
  echo "RESULT: FAILED —$FAILED"
  exit 1
fi
echo "RESULT: ALL 5 SUITES PASSED (CI parity: .github/workflows/validate.yml)"
