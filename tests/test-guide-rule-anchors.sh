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
requirements|Target exists** → ask: overwrite, numbered|persistence-convention.md conflict policy (#407)
requirements|**Frontmatter** (required)|persistence-convention.md required frontmatter (#407)
requirements|show the result in the reply only, with no `SKILL_OUTPUT` block|persistence-convention.md mkdir fallback (#407)
requirements|paired failure case that must not pass|behavioral-spec-craft.md paired failure case (#407)
requirements|Stop only when you have 3+ testable criteria|interview-protocol.md stop gate (#407)
breakdown|Target exists** → ask: overwrite, numbered|persistence-convention.md conflict policy (#407)
breakdown|fan-out executes a plan, it does not author one|orchestration-patterns.md fan-out preconditions (#407)
breakdown|Never claim a release, deploy, or closure before it is verified|issue-tracking-comments.md honest closure (#407)
breakdown|always include "Why this matters"|agent-brief-template.md hard rules (#407)
design|ask overwrite / `design.vN.md` / abort|persistence-convention.md conflict policy (#407)
design|glossary conflicts surfaced|project-context-contract.md glossary conflicts (#407)
design|an ADR stands unless the user asks to revisit it|project-context-contract.md ADR precedence (#407)
build-brief|surface the conflict before building on it|project-context-contract.md glossary conflicts (#407)
build-brief|fails for the expected reason|tdd-tracer-bullet.md one behavior test at a time (#407)
review-ai|state what was checked and how|integrity-principles.md commandment 3 (#407)
cross-verify|**Q17**: if a handoff note exists|structured-output-protocol.md Q17 auto-check (#407)
cross-verify|report which blocks were found and which were missing|structured-output-protocol.md found/missing report (#407)
save-spec|every backtick path resolves|spec-digest-pattern.md 5 verification checks (#407)
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

# save-spec ships the CLAUDE.md recipe stanza in its own reference.md (a guide is not
# in the skill bundle); it must stay verbatim with the guide it mirrors (#407).
stanza() { awk '/^## After completing any task:/{f=1} f{print} f&&/^4\. Never claim/{exit}' "$1"; }
for root in skills plugin/skills; do
  if ! diff -q <(stanza "$root/save-spec/reference.md") <(stanza guides/spec-digest-pattern.md) >/dev/null \
     || [ -z "$(stanza "$root/save-spec/reference.md")" ]; then
    echo "FAIL: $root/save-spec/reference.md recipe stanza differs from guides/spec-digest-pattern.md"
    FAIL=1
  fi
done

if [ "$FAIL" -ne 0 ]; then
  echo ""
  echo "RESULT: FAILED — a verdict-changing rule left SKILL.md (#404)"
  exit 1
fi
echo "RESULT: PASS — $N guide-rule anchors present in skills/ and plugin/skills/"
