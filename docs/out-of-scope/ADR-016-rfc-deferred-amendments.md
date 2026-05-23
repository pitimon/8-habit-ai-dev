---
date: 2026-05-23
originating-decision: ADR-016
originating-rfc: "#215 (closed superseded), #216 (revised scope)"
rejected-because: Three of four proposed amendments lacked materialized friction signals; failed cost-of-correction asymmetry gate's 3 activation conditions
---

# We don't ship A1/A2/A4 from the original ADR-016 RFC — they failed the cost-asymmetry gate

The original 4-amendment proposal at [#215](https://github.com/pitimon/8-habit-ai-dev/issues/215) was scoped down to A3 alone after [skeptical-validator peer review](https://github.com/pitimon/8-habit-ai-dev/issues/215#issuecomment-4525821643) and [revised RFC #216](https://github.com/pitimon/8-habit-ai-dev/issues/216). A3 shipped as [ADR-016](../adr/ADR-016-t2-bag-drop-date-eviction-policy.md); A1/A2/A4 archived here with their rationale + reviewer credit.

## Why we deferred 3 of 4 amendments

The revised [ADR-016](../adr/ADR-016-t2-bag-drop-date-eviction-policy.md) introduced a **cost-of-correction asymmetry gate** with 3 bounded activation conditions. A1/A2/A4 each failed one or more:

| Amendment                                                                 | Condition failed                                                                                                                                  | Why                                                                                                                                                                                   |
| ------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **A1 lane split** (reactive-pending vs preventive-candidate)              | Condition 2: latent risk not currently growing                                                                                                    | Zero preventive-skill proposals on the table; failure mode is anticipated, not materialized                                                                                           |
| **A2 trial gate** (≥2 weeks `~/.claude/skills/` trial before plugin ship) | Condition 1: implementation cost not trivial (≥2 week trial process per skill) + Condition 2: zero cases of shipping-wrong-fix-after-n=1-citation | High cost + anticipated risk = double failure                                                                                                                                         |
| **A4 SHA-watch as ADR clause**                                            | Out of scope (implementation, not decision)                                                                                                       | Empirically: `gh release list --repo mattpocock/skills` is empty; release-watch never fires. Reshaped to `scripts/sha-watch-mattpocock.sh` + `CONTRIBUTING.md` section in separate PR |

The fact that 3 of 4 amendments failed the gate is **evidence the gate has bite**, not evidence the gate is wrong.

## A1 — Lane split (reactive-pending vs preventive-candidate)

**Original proposal**: split T2 bag into two named lanes with asymmetric evidence bars (n=1 reactive vs n≥2 preventive).

**Why deferred**:

- Zero preventive-skill candidates in current bag — failure mode is anticipated
- Binary lane creates R3 (lane-assignment debate) per #215 reviewer
- Reviewer's superior alternative: **evidence-type taxonomy in ADR header** (`evidence: {in-codebase-reactive / cross-codebase-reactive / preventive} + n=X`) — same governance, no lane-assignment overhead, lighter implementation

**If reconsidering, read these conditions first:**

- A preventive-skill candidate is genuinely proposed (e.g., `/rollback-readiness` skill before we hit a bad deploy)
- The proposal cannot pass the standard friction-first gate (n=0 first-person citation by definition for preventive)
- The reviewer's evidence-type-taxonomy alternative is insufficient to capture the preventive case cleanly

When that case materializes, the future RFC should adopt the **evidence-type taxonomy in ADR header**, not the binary lane label. Reviewer credit: [#215 review](https://github.com/pitimon/8-habit-ai-dev/issues/215#issuecomment-4525821643).

## A2 — Trial gate (≥2 weeks `~/.claude/skills/` trial)

**Original proposal**: insert a trial phase between friction citation and plugin ship — skill lives in `~/.claude/skills/` for ≥2 weeks; promotion requires trial-validation note in ADR Self-Check.

**Why deferred**:

- **n=0 first-person friction** — we have zero cases where we shipped a wrong fix after n=1 citation
- Implementation cost not trivial — ≥2-week trial is a sustained process, not a date-field addition
- Calendar-time proxy weak — #216 review noted use-count (≥3 invocations) is a better signal than ≥2 weeks
- Skip rule "additive-only-zero-risk" was too broad — every read-only skill qualifies → default skip → trial gate doesn't fire
- For single-maintainer plugin: 2-week delay risks "skill never ships because no one prioritizes trial work" — A2 might create the failure mode it tries to prevent

**If reconsidering, read these conditions first:**

- A documented case exists where the plugin shipped a skill that didn't actually move the friction needle (i.e., friction-citation-without-validation gap materialized)
- The proposed trial mechanism is **use-count based** (≥3 invocations in real work) rather than calendar-time
- The skip rule has tightened beyond "additive-only-zero-risk" to a falsifiable criterion

Reviewer credit: [#215 review](https://github.com/pitimon/8-habit-ai-dev/issues/215#issuecomment-4525821643) and the RFC author's own concession.

## A4 — Auto SHA-watch as ADR clause

**Original proposal**: GitHub release-watch subscription + optional weekly cron diffing pinned SHA vs upstream HEAD, codified in the ADR.

**Why reshaped (not deferred)**:

- **Empirical correction**: `gh release list --repo mattpocock/skills` is empty; the upstream repo doesn't tag releases. Release-watch subscription would never fire.
- A4 is **implementation**, not **decision** — the decision ("watch SHA, surface diffs for human review") fits in 2 lines; the actual cron + script doesn't need an ADR clause.
- Better shape: `scripts/sha-watch-mattpocock.sh` + `CONTRIBUTING.md` section, in a separate PR not gated on ADR-016 acceptance.

**If reconsidering, read these conditions first:**

- An audited upstream starts tagging formal releases (changes the release-watch subscription calculus)
- The SHA-watch script consistently surfaces noise without producing T2 bag entries for 6+ months (consider pausing automation per ADR-016 future-reversal condition 3)
- Multiple upstream sources enter the audit scope (currently only `mattpocock/skills`; if others join, a more centralized SHA-watch design may be warranted)

Reviewer credit: [#215 review](https://github.com/pitimon/8-habit-ai-dev/issues/215#issuecomment-4525821643) including the empirical verification that `gh release list --repo mattpocock/skills` is empty.

## Meta-lesson preserved

This entire RFC cycle (#215 → review → #216 → acceptance) is **n=1 evidence that friction-first doctrine produces better doctrine when challenged**. The original 4-amendment proposal claimed a "doctrine-level vs skill-level" exception that was load-bearing for amendments that shouldn't have shipped. The peer-review friction (the slippery-slope objection at #215) forced the RFC author to either:

1. Document a concrete boundary for the exception (which they did: the 3-condition cost-asymmetry gate in #216), OR
2. Drop the amendments that needed the exception (which they did for A1/A2/A4)

The result: doctrine integrity preserved, only the amendment with materialized risk shipped, and a bounded gate now exists for any future "cheap-to-prevent-than-cure" appeals. This pattern is itself worth documenting in a `/reflect` lesson on **doctrine-stress-testing-via-peer-review**.
