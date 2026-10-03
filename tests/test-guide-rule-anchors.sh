#!/bin/bash
# test-guide-rule-anchors.sh — verdict-changing rules must live in SKILL.md (#404).
#
# WHY: in #402 a rule that changed the verdict lived only in an optional guide.
# Evaluators read SKILL.md and stop, so the rule never applied (blind eval 0/3;
# moving it into SKILL.md gave 3/3). The #404 audit found more rules with the
# same shape. Each row below pins a binding rule to the SKILL.md that must carry
# it, by an anchor phrase. Guide wording can change freely; deleting the anchor
# from SKILL.md fails this test.
#
# Adding a row: when a guide gains a rule that changes a verdict, score, status,
# or required output, put a short form in the owning SKILL.md and add its anchor
# here in the same PR (AGENTS.md: enforcement ships with the convention).
#
# Format: skill|anchor phrase (fixed string, case-sensitive)|source rule
# USAGE: bash tests/test-guide-rule-anchors.sh
set -euo pipefail
cd "$(dirname "$0")/.."

RULES=$(cat <<'EOF'
cross-verify|until you cite the line that writes it|cross-verification.md absence claims: find the writer (#402)
cross-verify|exercised on the real host with a control case|cross-verification.md integration boundaries need the real host
cross-verify|before setting Release state|production-release-gates.md required load for state criteria, read-back, FINAL_KEEP record
cross-verify|hold: verify core claim|cross-verification.md core-claim hold (#399)
whole-person-check|A score needs every indicator in its row|whole-person-rubrics.md:9 all indicators; partial = previous level
whole-person-check|not plans or intentions|whole-person-rubrics.md:9 observable indicators, not aspirations
research|**Confidence & Open Unknowns**|research-brief-template.md mandatory confidence section
research|mark it unverified (✓U) until re-checked this session|integrity-principles.md C7 staleness of prior-session claims
review-ai|Owner note caps the final verdict at `CONCERNS`|review-report-template.md Owner-note cap (v2.21.51)
EOF
)

FAIL=0
N=0
for root in skills plugin/skills; do
  while IFS='|' read -r skill anchor src; do
    [ -z "$skill" ] && continue
    N=$((N + 1))
    f="$root/$skill/SKILL.md"
    if [ ! -f "$f" ]; then
      echo "FAIL: $f missing (rule: $src)"
      FAIL=1
    elif ! grep -qF -- "$anchor" "$f"; then
      echo "FAIL: $f lacks anchor \"$anchor\""
      echo "      rule: $src"
      FAIL=1
    fi
  done <<< "$RULES"
done

if [ "$FAIL" -ne 0 ]; then
  echo ""
  echo "RESULT: FAILED — a verdict-changing rule left SKILL.md (#404)"
  exit 1
fi
echo "RESULT: PASS — $N guide-rule anchors present in skills/ and plugin/skills/"
