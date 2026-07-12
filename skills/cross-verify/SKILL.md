---
name: cross-verify
description: >
  Run 17-question 8-Habit cross-verification checklist on a plan or implementation.
  Use AFTER planning and BEFORE committing to implementation. Maps to ALL 8 Habits.
user-invocable: true
argument-hint: "[plan or feature to verify]"
allowed-tools: ["Read", "Glob", "Grep"]
prev-skill: any
next-skill: any
---

# Cross-Verify (8-Habit Checklist)

**All Habits** | **Anti-pattern**: Shipping without reflecting on quality from multiple perspectives

## When to Use

- After writing a plan, before starting implementation
- Before creating a PR for a multi-file change
- When something feels off but you can't pinpoint why

## When to Skip

- Single-line bug fixes with obvious root cause
- Formatting or linting changes
- Dependency version bumps with passing CI

## Auto-Detection (Structured Output Blocks)

Before running the manual checklist, search for structured output blocks in the current directory:

1. Glob for the persisted artifact files: `docs/specs/*/prd.md`, `docs/specs/*/design.md`, `docs/specs/*/tasks.md` (plus their `*.vN.md` conflict variants — the canonical `--persist` targets), and `*-review.md` / `*-prd.md` / `*-tasks.md` in the working directory for hand-saved reports
2. Read each file and look for `<!-- SKILL_OUTPUT:` blocks. As of v2.21.39 ([#375](https://github.com/pitimon/8-habit-ai-dev/issues/375)) these blocks live in the persisted files only, not the conversation transcript — a non-persisted run has no block, which is expected and falls through to manual assessment (step 5)
3. If found, pre-populate evidence for:
   - **Q4**: Extract `ears_count` and `success_criteria_count` from requirements block
   - **Q5**: Extract `test_coverage_checked` from review block
   - **Q8**: Compare `task_count` vs `ears_count` for scope alignment — flag if `task_count > ears_count * 3`
   - **Q14**: Extract `decision_count` from design block — flag if only 1 option was presented (no third alternative considered)
   - **Q16**: Extract `sticky_decisions` from design block — flag if 0 sticky decisions in a design with >3 decisions (WHY not captured)
   - **Q4**: Cross-check `decision_count` against requirements `success_criteria_count` — flag if decisions don't cover all criteria
4. Mark auto-populated answers with `✓A` (auto-detected) confidence level
5. If no blocks found, proceed with manual assessment (no change to current behavior)

## Process

Run through this checklist. Flag any item that fails.

### Private Victory (Self-Management)

| #   | Habit            | Dimension   | Question                                                                    |
| --- | ---------------- | ----------- | --------------------------------------------------------------------------- |
| 1   | H1: Be Proactive | Body+Spirit | Have I checked what else this change affects beyond the immediate scope?    |
| 2   | H1: Be Proactive | Body        | Have I considered edge cases: null input, missing files, permission errors? |
| 3   | H1: Be Proactive | Body        | Will documentation be updated as part of this change, not after?            |
| 4   | H2: End in Mind  | Mind        | Do I have 3-5 concrete, verifiable success criteria?                        |
| 5   | H2: End in Mind  | Mind        | Does the PR include a test plan with specific verification steps?           |
| 6   | H2: End in Mind  | Mind        | Do commit messages explain WHY, not just WHAT?                              |
| 7   | H3: First Things | Mind        | Am I working on the most important thing, or the most interesting thing?    |
| 8   | H3: First Things | Heart       | Have I resisted scope creep — only what's needed, nothing extra?            |

### Public Victory (Collaboration)

| #   | Habit          | Dimension | Question                                                                                                                                   |
| --- | -------------- | --------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| 9   | H4: Win-Win    | Heart     | Will issue closures include rationale, not just "fixed"?                                                                                   |
| 10  | H4: Win-Win    | Heart     | Do error messages help the next developer understand AND fix the problem?                                                                  |
| 11  | H5: Understand | Mind      | Have I read the existing code in the affected area before writing new code?                                                                |
| 12  | H5: Understand | Mind      | If fixing a bug, have I reproduced it first — and confirmed the root cause from an **independent** source (not the same tool/observation)? |
| 13  | H6: Synergize  | Heart     | Are independent tasks running in parallel instead of sequentially?                                                                         |
| 14  | H6: Synergize  | Mind      | Have I considered a third alternative beyond the obvious options?                                                                          |

### Renewal & Significance

| #   | Habit           | Dimension | Question                                                                |
| --- | --------------- | --------- | ----------------------------------------------------------------------- |
| 15  | H7: Sharpen Saw | Body      | After this task, will I capture what I learned (script, doc, or issue)? |
| 16  | H8: Voice       | Spirit    | Do I understand WHY this task matters, not just WHAT needs to be done?  |
| 17  | H8: Voice       | Spirit    | Does this work empower the next person who touches this code?           |

> **When the subject under review is a diagnosis or root cause** (not a plan or code change), add one reconciliation check before scoring Q12: could this root cause be **confidently wrong**? Confirm it by an **independent method** — a different tool, command, or vantage, not the same observation — and **reconcile** conflicting evidence before proceeding. Author-side gates all share your evidence, so only an independent source can diverge from it. See [`independent-source-verification.md`](../../guides/independent-source-verification.md).

## Confidence Levels (Required for high-stakes reviews)

For critical decisions (architecture, security, production deploys), mark each Pass with a confidence level. Inspired by Feynman's honest uncertainty principle — separate what you verified from what you assumed.

| Level         | Mark | Meaning                                                   | Example                                                             |
| ------------- | ---- | --------------------------------------------------------- | ------------------------------------------------------------------- |
| Verified      | ✓V   | Evidence checked — test ran, code read, diff reviewed     | "Read the function at api.ts:42, confirmed input validation exists" |
| Inferred      | ✓I   | Reasonable belief based on context, not directly verified | "Codebase uses Zod throughout, likely validated here too"           |
| Unverified    | ✓U   | Assumption — should verify before proceeding              | "Assuming tests exist but haven't checked coverage"                 |
| Auto-detected | ✓A   | Evidence extracted from structured output block           | "Parsed 5 EARS criteria from PRD structured block"                  |

**Scoring**: All Pass levels count toward the score, but ✓U items are flagged as verification debt.

**Staleness**: a ✓V resting on memory or a prior session — not a check made _this_ session — is really ✓U. Recalled state goes stale (a function, flag, or path may have changed). Re-verify before it carries weight in the verdict.

**Required for**: Architecture reviews, security-sensitive changes, pre-production gates — these MUST carry the Confidence + Open-unknowns footer in the report header (below).
**Optional for**: Quick checks, formatting changes, familiar code — Pass/Fail/N/A is sufficient.

## Shadow Self-Check (before recording the recommendation)

After scoring, run a 10-second adversarial pass on your _own_ verdict — the checklist judged the work; this judges your judgment:

- **What is the strongest counter-argument to my recommendation?** If you can't state one, you haven't pressure-tested it — re-examine the failed and ✓U items before proceeding.
- **Who is harmed if my verdict is wrong?** A false "proceed" ships the gap; a false "stop" wastes the work. Reweight borderline calls toward the costlier error.
- **Is my recommendation itself a trap?** Test it against the failure modes — hidden cost, false economy, scaling failure, premature abstraction (commandment 14, `integrity-principles.md`). A clean-looking verdict can still hide one. (Commandment 14's steelman half is N/A here: you are pressure-testing your _own_ verdict, not rejecting an alternative.)

This is the cheap inline complement to a full reviewer-subagent dispatch (`advisor-pattern.md`) — run it always; escalate to the subagent only when the action is irreversible or the context is contaminated.

## Output

```
## Cross-Verification Report
**Feature**: [name]
**Score**: [X]/17 (N/A excluded: [Y]/[Z] applicable = [%])
**Band**: [see table below]
**Confidence**: [V: X, I: Y, U: Z — required for high-stakes reviews] · **Open unknowns**: [top 1-3 still unverified, or "none material"]
**Failed**: [list failed items with 1-line explanation each]
**Recommendation**: [proceed / address gaps / revisit plan / stop and rethink]

### Dimension Summary
| Dimension | Questions | Pass | Score |
|-----------|-----------|------|-------|
| Body (Discipline)  | Q1,2,3,15        | [X]/4 | [%] |
| Mind (Vision)      | Q4,5,6,7,11,12,14 | [X]/7 | [%] |
| Heart (Passion)    | Q8,9,10,13       | [X]/4 | [%] |
| Spirit (Conscience) | Q1,16,17         | [X]/3 | [%] |
⚠️ Flag if any dimension scores <50% while others score >75%
```

### Scoring Bands

| Score | Band             | Action                               |
| ----- | ---------------- | ------------------------------------ |
| 15-17 | Well-prepared    | Proceed with confidence              |
| 12-14 | Mostly ready     | Address gaps, then proceed           |
| 8-11  | Significant gaps | Revisit the plan before implementing |
| < 8   | Not ready        | Stop and rethink the approach        |

When calculating adjusted score, exclude N/A items from both numerator and denominator. Use the adjusted percentage to determine the band.

### Common Failure Patterns

- **Q1-3 fail together**: Being reactive, not proactive — step back and think about impact
- **Q4-6 fail together**: Haven't defined success — write criteria first
- **Q11-12 fail together**: Jumping to solutions — read the code and reproduce the problem
- **Q13 always N/A**: May be underutilizing parallelization

## Definition of Done

- [ ] All 17 questions answered with Pass/Fail/N/A and 1-line evidence
- [ ] Dimension Summary table rendered with per-dimension scores
- [ ] Band determined from adjusted score (N/A items excluded)
- [ ] Failed items each have a specific remediation action
- [ ] Report follows the output template above (not free-form prose)
- [ ] High-stakes reviews carry the Confidence (V/I/U) + Open-unknowns footer in the report header
- [ ] Shadow self-check run on the verdict (counter-argument + who's harmed if wrong)

## Domain Question Packs (Optional)

If the work is domain-specific, load the relevant pack for additional questions:

- **API work**: Load `${CLAUDE_PLUGIN_ROOT}/guides/cross-verify-packs/api.md` (5 extra questions)
- **Frontend work**: Load `${CLAUDE_PLUGIN_ROOT}/guides/cross-verify-packs/frontend.md` (5 extra questions)
- **Infrastructure work**: Load `${CLAUDE_PLUGIN_ROOT}/guides/cross-verify-packs/infra.md` (5 extra questions)
- **AI/ML work**: Load `${CLAUDE_PLUGIN_ROOT}/guides/cross-verify-packs/ai-ml.md` (5 extra questions)
- **Mobile work**: Load `${CLAUDE_PLUGIN_ROOT}/guides/cross-verify-packs/mobile.md` (5 extra questions)

Domain questions are scored separately and do not affect the main 17-question score.

Load `${CLAUDE_PLUGIN_ROOT}/guides/cross-verification.md` for detailed guidance on each question.
Load `${CLAUDE_PLUGIN_ROOT}/guides/integrity-principles.md` for evidence standards when using confidence levels.
Load `${CLAUDE_PLUGIN_ROOT}/guides/structured-output-protocol.md` for the structured output block format specification.
