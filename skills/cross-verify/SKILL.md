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

1. Glob for the persisted artifact files: `docs/specs/*/prd.md`, `docs/specs/*/design.md`, `docs/specs/*/tasks.md` (plus `*.vN.md` variants), and hand-saved `*-review.md` / `*-prd.md` / `*-tasks.md` in the working directory
2. Read each file and look for `<!-- SKILL_OUTPUT:` blocks. Blocks live only in persisted files ([#375](https://github.com/pitimon/8-habit-ai-dev/issues/375)); otherwise go to steps 5–6
3. If found, pre-populate evidence for:
   - **Q4**: Extract `ears_count` and `success_criteria_count` from requirements block
   - **Q5**: Extract `test_coverage_checked` from review block
   - **Q8**: Compare `task_count` vs `ears_count` for scope alignment — flag if `task_count > ears_count * 3`
   - **Q14**: Extract `decision_count` from design block — flag if only 1 option was presented (no third alternative considered)
   - **Q16**: Extract `sticky_decisions` from design block — flag if 0 sticky decisions in a design with >3 decisions (WHY not captured)
   - **Q4** also: flag if design `decision_count` < requirements `success_criteria_count`
   - **Q17**: if a handoff note exists, check it names current state, evidence, and next skill
4. Mark auto-populated answers `✓A`; report which blocks were found and which were missing
5. **Session-context fallback (no persisted block)**: if producer skills ran earlier **this session**, mine their prose still in context for Q4 / Q8 / Q14 / Q16. Mark `✓I`, or `✓A` only for explicit counts (e.g. a numbered EARS list).
6. If neither a persisted block nor prior producer output is available, proceed with manual assessment

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

> **When reviewing a diagnosis or root cause**, first ask **did it fail at all?** Name positive evidence (error, exit code, log line, wrong output). "X did not run / never triggered" is an absence claim even when framed as a failure with candidate causes: a missing artifact alone is `OPEN_VERIFICATION_DEBT` until you cite the line that writes it and confirm it runs on that path; artifacts that _are_ present may prove X ran. Then, before Q12: could the cause be **confidently wrong**? Confirm it independently; reconcile conflicts. See [`independent-source-verification.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/guides/independent-source-verification.md).

## Confidence Levels (Required for high-stakes reviews)

For critical decisions (architecture, security, production deploys), mark each Pass with a confidence level — separate what you verified from what you assumed (Feynman).

| Level         | Mark | Meaning                                                   |
| ------------- | ---- | --------------------------------------------------------- |
| Verified      | ✓V   | Evidence checked — test ran, code read, diff reviewed     |
| Inferred      | ✓I   | Reasonable belief based on context, not directly verified |
| Unverified    | ✓U   | Assumption — should verify before proceeding              |
| Auto-detected | ✓A   | Evidence extracted from structured output block           |

**Scoring**: Only `PASS` counts. Exclude `N/A` only with evidence that the item is irrelevant. `OPEN_VERIFICATION_DEBT` is unresolved evidence; it does not count as PASS. The core score cannot override a blocking domain gate.

**Staleness**: a ✓V resting on memory or a prior session, not a check made _this_ session, is really ✓U. Re-verify before it carries weight in the verdict.

**Required for**: Architecture reviews, security-sensitive changes, pre-production gates — these MUST carry the Confidence + Open-unknowns footer in the report header (below).
**Optional for**: Quick checks, formatting changes, familiar code — Pass/Fail/N/A is sufficient.

## Shadow Self-Check (before recording the recommendation)

After scoring, run a 10-second adversarial pass on your _own_ verdict:

- **What is the strongest counter-argument to my recommendation?** If you can't state one, you haven't pressure-tested it — re-examine the failed and ✓U items before proceeding.
- **Who is harmed if my verdict is wrong?** A false "proceed" ships the gap; a false "stop" wastes the work. Reweight borderline calls toward the costlier error.
- **Which conclusions have only been checked by me, with my own evidence?** For each core claim: if it were false, would my evidence look different? A "no" makes it a candidate for an independent pass (cross-vendor, reviewer agent, or live execution).
- **Is my recommendation itself a trap?** Check hidden cost, false economy, scaling failure, premature abstraction (commandment 14, `integrity-principles.md`).

Run it always; escalate to a reviewer subagent (`advisor-pattern.md`) only when the action is irreversible or the context is contaminated.

## Output

```
## Cross-Verification Report
**Feature**: [name]
**Score scope**: process completeness (verification) — not evidence that conclusions or changed runtime behavior are correct (validation).
**Core claims**: [headline + every integration/absence claim, each: claim — evidence source — independent? Y/N — PASS/FAIL/OPEN_VERIFICATION_DEBT]
**Core checklist**: [PASS X] / [FAIL Y] / [N/A Z] / [OPEN_VERIFICATION_DEBT W]
**Adjusted score**: [PASS X] / ([total] - [N/A Z]) = [%] (debt is not PASS)
**Band**: [see table below]
**Confidence**: [V: X, I: Y, U: Z — required for high-stakes reviews] · **Open unknowns**: [top 1-3 still unverified, or "none material"]
**Failed**: [list failed items with 1-line explanation each]
**Domain gates**: [Infrastructure: status] · [Functional: status] · [Economic: status] · [Quality: status]
**Release state**: [PLAN / READY / CANARY / OBSERVING / PROVISIONAL_KEEP / FINAL_KEEP / HOLD / ROLLBACK]
**Release verdict**: [PROVISIONAL_KEEP / FINAL_KEEP / HOLD / ROLLBACK]
**Blocking gates/debt**: [list, or "none"]
**Recommendation**: [proceed / address gaps / revisit plan / stop and rethink / hold: verify core claim]

### Dimension Summary
| Dimension | Questions | Pass | Score |
|-----------|-----------|------|-------|
| Body (Discipline)  | Q1,2,3,15        | [X]/4 | [%] |
| Mind (Vision)      | Q4,5,6,7,11,12,14 | [X]/7 | [%] |
| Heart (Passion)    | Q8,9,10,13       | [X]/4 | [%] |
| Spirit (Conscience) | Q1,16,17         | [X]/3 | [%] |
⚠️ Flag if any dimension scores <50% while others score >75%
```

For production work, load `${CLAUDE_PLUGIN_ROOT}/guides/production-release-gates.md` before setting Release state (entry criteria, mutation read-back, `FINAL_KEEP` record). `/deploy-guide` plans deployment; `/operational-state` classifies incidents.

### Scoring Bands

| Score | %    | Band             | Action                               |
| ----- | ---- | ---------------- | ------------------------------------ |
| 15-17 | ≥88% | Well-prepared    | Proceed with confidence              |
| 12-14 | ≥70% | Mostly ready     | Address gaps, then proceed           |
| 8-11  | ≥47% | Significant gaps | Revisit the plan before implementing |
| < 8   | <47% | Not ready        | Stop and rethink the approach        |

When calculating adjusted score, count only `PASS` in the numerator and exclude `N/A` from the denominator. `FAIL` and `OPEN_VERIFICATION_DEBT` stay visible and block a production `FINAL_KEEP` under a blocking gate policy. Use the adjusted percentage for the core band, then determine the release verdict independently from domain gates and evidence completeness.

**Core-claim hold**: if a core claim presented as established (built, diagnosed, observed) is `FAIL` or `OPEN_VERIFICATION_DEBT`, `proceed`/`address gaps` becomes `hold: verify core claim`; lower bands keep theirs. The score and band are computed unchanged; list the claim under Blocking gates/debt; production Release verdict is `HOLD`. Always list the claim the change exists to make true; evidence that would look the same if it were false makes a claim debt. Unbuilt claims in a pre-implementation plan go to Q5's test plan; diagnosed premises stay established. Integration claims (allowlists, hooks, CLI flags) pass only when exercised on the real host with a control case; mocks are debt. Rules: guide § Core-Claim Verification.

Common failure patterns (Q1-3, Q4-6, Q11-12, Q13, false failures): guide § Common Failure Patterns.

## Definition of Done

- [ ] All 17 questions answered with Pass/Fail/N/A and 1-line evidence
- [ ] Dimension Summary table rendered with per-dimension scores
- [ ] Core status buckets rendered: PASS/FAIL/N/A/OPEN_VERIFICATION_DEBT
- [ ] Band determined from adjusted score (PASS numerator; N/A excluded; debt not PASS); core-claim hold applied
- [ ] Failed items each have a specific remediation action
- [ ] Report follows the output template above (not free-form prose)
- [ ] High-stakes reviews carry the Confidence (V/I/U) + Open-unknowns footer in the report header
- [ ] Shadow self-check run on the verdict (counter-argument, who's harmed, own-evidence-only claims)
- [ ] Production reviews render independent domain gates and a release state/verdict; a core score cannot override a blocking domain gate

## Domain Question Packs (Optional)

If the work is domain-specific, load the relevant pack (5 extra questions each):

- **API work**: Load `${CLAUDE_PLUGIN_ROOT}/guides/cross-verify-packs/api.md`
- **Frontend work**: Load `${CLAUDE_PLUGIN_ROOT}/guides/cross-verify-packs/frontend.md`
- **Infrastructure work**: Load `${CLAUDE_PLUGIN_ROOT}/guides/cross-verify-packs/infra.md`
- **AI/ML work**: Load `${CLAUDE_PLUGIN_ROOT}/guides/cross-verify-packs/ai-ml.md`
- **Mobile work**: Load `${CLAUDE_PLUGIN_ROOT}/guides/cross-verify-packs/mobile.md`

Domain questions are scored separately and do not affect the main 17-question score.

Load `${CLAUDE_PLUGIN_ROOT}/guides/cross-verification.md` for detailed guidance on each question.
Load `${CLAUDE_PLUGIN_ROOT}/guides/integrity-principles.md` for evidence standards when using confidence levels.
Load `${CLAUDE_PLUGIN_ROOT}/guides/structured-output-protocol.md` for the structured output block format specification.

---

Hermes: no `${CLAUDE_PLUGIN_ROOT}`; use `https://github.com/pitimon/8-habit-ai-dev/blob/main` ([#388](https://github.com/pitimon/8-habit-ai-dev/issues/388)). OpenClaw: use `{baseDir}`, bundled file, or URL.
