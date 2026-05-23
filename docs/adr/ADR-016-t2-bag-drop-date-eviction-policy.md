# ADR-016: T2 Bag Drop-Date — Mechanical Eviction Policy for Deferred External-Pattern Candidates

**Status**: Accepted
**Date**: 2026-05-23
**Decision makers**: Pitimon (human) + Claude Opus 4.7 (AI, 1M context) + peer review via [#215](https://github.com/pitimon/8-habit-ai-dev/issues/215) (skeptical-validator session) and [#216](https://github.com/pitimon/8-habit-ai-dev/issues/216) (revised scope)
**Related**: [ADR-014 External Prior-Art Audit](./ADR-014-external-prior-art-audit.md) (parent doctrine — friction-first), [ADR-015 /diagnose Adoption](./ADR-015-diagnose-skill-adoption-and-n1-framing.md) (first reactive application), [ADR-009 Skill Split Convention](./ADR-009-skill-split-convention.md), [ADR-013 Spec Persistence](./ADR-013-spec-persistence-opt-in.md)
**Source discussion**: [#215](https://github.com/pitimon/8-habit-ai-dev/issues/215) original 4-amendment proposal collapsed to A3-only after skeptical-validator review; [#216](https://github.com/pitimon/8-habit-ai-dev/issues/216) revised scope. Deferred amendments archived at [`docs/out-of-scope/ADR-016-rfc-deferred-amendments.md`](../out-of-scope/ADR-016-rfc-deferred-amendments.md).

---

## Context

ADR-014 (2026-05-20) introduced the T2 bag — a list of deferred external-pattern candidates worth re-evaluating later. ADR-015 (2026-05-23) shipped `/diagnose` as the first T2 candidate to escape the bag via friction signal. **6 T2 candidates remain in the bag** at the time of this ADR (P2/P8/P10 from ADR-014's audit + P1/P3-aug/P4 from the 2026-05-23 second-pass audit).

The bag has **no documented eviction policy**. Without one:

- Candidates accumulate indefinitely as new audits add to the bag
- Mental load of "check if X is in bag" grows linearly with bag size
- Doctrine collapses from "ship friction-first from bag" to "we have a bag" — write-only ceremony

This is **the only operational gap in ADR-014/015 with materialized risk** (n=6 candidates already accumulating). A broader 4-amendment proposal at [#215](https://github.com/pitimon/8-habit-ai-dev/issues/215) was scoped down after skeptical-validator review to A3 alone, since the other 3 amendments addressed anticipated rather than materialized risks.

## Decision

Every T2 candidate carries a **drop date** = entry-into-bag + 6 months.

At drop date:

| Outcome                                                                  | Action                                                                                                                                                 |
| ------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Friction signal arrived during window → already shipped per ADR-015 flow | (no-op — candidate already promoted to skill)                                                                                                          |
| No friction signal                                                       | **Evict, do not ship.** Record in `docs/out-of-scope/` with: original audit rationale, eviction date, `no-friction-within-window`, re-entry conditions |
| SHA-churn re-audit OR explicit friction signal identifies same candidate | Re-enters bag with fresh drop date + explicit "re-considered after eviction" note                                                                      |

### Re-entry mechanism (Q3 modification per #216 review)

Re-entry to the T2 bag after eviction is permitted via **either** of two triggers (not just SHA-churn alone):

1. **SHA-churn re-audit** — upstream upstream-source delta surfaces the same candidate under a new SHA
2. **Explicit friction signal** — a first-person retrospective (lesson file, `/reflect` SKILL-EFFECTIVENESS, cross-verify imbalance) cites the evicted candidate as a missed-skill gap, regardless of upstream changes

Either trigger is sufficient. Both honor friction-first doctrine; gating re-entry on SHA-churn only would trap legitimately-deferred candidates behind upstream cadence we don't control. (Reviewer credit: this modification surfaced from #216 review.)

### Eviction record format (extends ADR-014's P4-lite OOS catalog)

```yaml
---
title: <Pattern name>
source: <upstream URL + SHA at audit time>
audit-date: <when added to T2 bag>
drop-date: <entry + 6mo>
eviction-date: <date evicted>
eviction-reason: no-friction-within-window
original-rationale: <copy from audit brief>
re-entry-condition: |
  Either:
  - SHA-churn re-audit surfaces same candidate under new upstream SHA, OR
  - Explicit first-person friction citation (lesson, /reflect signal, cross-verify imbalance)
---
```

### Existing T2 bag inventory (one-time grandfathered drop date)

The 6 candidates currently in bag get a uniform drop date of **2026-11-23** (6 months from ADR-016 ship date). One-time approximation acceptable per #216 review — 3-day delta between newest (P1 second-pass, 2026-05-23) and oldest (P2/P8/P10 from ADR-014, 2026-05-20) doesn't materially affect outcomes.

| ID                                                   | Source                                                          | Audit ADR                       | Drop date  |
| ---------------------------------------------------- | --------------------------------------------------------------- | ------------------------------- | ---------- |
| P2 LANGUAGE.md vocabulary                            | `mattpocock/skills` SHA `b8be62ff` `productivity/write-a-skill` | ADR-014                         | 2026-11-23 |
| P8 two-axis review split                             | `mattpocock/skills` SHA `b8be62ff` `in-progress/review`         | ADR-014                         | 2026-11-23 |
| P10 tracer-bullet vocab                              | `mattpocock/skills` SHA `b8be62ff` `engineering/prototype`      | ADR-014                         | 2026-11-23 |
| `handoff` skill                                      | `mattpocock/skills` SHA `b8be62ff` `productivity/handoff`       | second-pass research 2026-05-23 | 2026-11-23 |
| `to-issues` vertical-slice + AFK/HITL labels augment | `mattpocock/skills` SHA `b8be62ff` `engineering/to-issues`      | second-pass research 2026-05-23 | 2026-11-23 |
| `/tdd` skill                                         | `mattpocock/skills` SHA `b8be62ff` `engineering/tdd`            | second-pass research 2026-05-23 | 2026-11-23 |

After 2026-11-23: any candidate above without first-person friction citation OR SHA-churn re-audit entry → evicted to `docs/out-of-scope/`.

## Options Considered

| Option                                        | Description                                     | Verdict                                                                                                     |
| --------------------------------------------- | ----------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| **6mo drop date for all T2 candidates**       | Single uniform window                           | **Accepted** — operational simplicity; matches materialized risk                                            |
| 3mo drop date                                 | Tighter loop                                    | Rejected — twitchy for single-maintainer audit cadence; risks evicting before friction can plausibly emerge |
| 12mo drop date                                | Longer window                                   | Rejected — bag-rot risk grows linearly with window length                                                   |
| Variable window by candidate-type             | Lane-dependent timing                           | Rejected — requires lane split (deferred A1); single window simpler and ships now                           |
| Wait for n=12 before adopting eviction policy | Strict friction-first applied to this amendment | Rejected on **cost-of-correction asymmetry** (see Honest Framing)                                           |

## Honest Framing — Forward Guardrail with Asymmetric Cost-of-Correction

Per ADR-014's discipline:

- **Friction signal**: n=0 first-person + **n=6 latent risk** (6 candidates accumulating with no eviction policy)
- **Adoption justification**: cost-of-correction asymmetry — adding a date column to a 6-row mental list is trivial today, near-impossible to retrofit once the bag accumulates further

### Why "cost-of-correction asymmetry" is not the doctrine self-exception in disguise

#215 reviewer correctly flagged that the original RFC's "doctrine-level vs skill-level" exception was load-bearing for amendments that should not ship. A natural follow-up: is "cost-of-correction asymmetry" the same exception relabeled?

**No, for three concrete reasons:**

1. **Cost-of-correction asymmetry is doctrine-agnostic.** It is the standard engineering calculus applied to any decision (typo fix, config default, database migration) — preventive cost < expected correction cost × probability of need. It does not claim doctrine deserves special treatment; it claims **trivially cheap preventive actions with growing latent risk pass a separate, complementary gate** that exists alongside friction-first, not above it.

2. **The asymmetry gate has bounded activation criteria.** It triggers only when **all three** conditions hold:
   - Implementation cost is genuinely trivial (≤1 hour, reuses existing infrastructure)
   - Latent risk is concrete and currently growing (n>0 today, not anticipated abstract risk)
   - Retroactive correction is materially harder than pre-emptive action

   The original 4-amendment proposal failed condition 2 for A1/A2/A4 (anticipated only) and failed condition 1 for A2 (≥2-week trial is not trivial). The deferred amendments are real evidence the gate has bite.

3. **The asymmetry gate does not weaken friction-first; it covers a different failure mode.** Friction-first prevents shipping skills people don't need. Cost-of-correction asymmetry prevents accumulating cleanup debt on cheap-to-prevent operational gaps. A doctrine that ships A3 today and (hypothetically) rejects A2 next week applies both gates consistently — friction-first to A2 (n=0, expensive trial process), cost-asymmetry to A3 (n=6 latent, trivial cost). The two gates are orthogonal, not substitutes.

### Self-attestation requirement for future invocations (Q6 modification per #216 review)

Any future ADR invoking cost-of-correction asymmetry as adoption justification **must** include the following Self-Check items, each with concrete evidence:

- [ ] Implementation cost ≤1 hour verified by: <evidence — e.g., diff lines, files-touched count, reuse of existing infrastructure>
- [ ] Latent risk currently growing — quote count/observation: <evidence — e.g., "n=6 candidates today, n=3 added in last 7 days">
- [ ] Retroactive correction quantified as materially harder than pre-emptive: <evidence — e.g., "reconstructing entry dates for 60 candidates is impossible without lesson archeology; 6 candidates is approximation-with-acceptable-delta">

Self-attestation with falsifiable evidence > formal second-reviewer requirement for single-maintainer cadence. If a future contributor invokes the gate without these three Self-Check items, the appeal should be rejected by reference to this section. (Reviewer credit: this modification surfaced from #216 review.)

### Self-Check for THIS ADR

- [x] Implementation cost ≤1 hour verified by: ADR-016 itself = ~250 lines markdown + OOS schema extension (one added field `eviction-date` + `re-entry-condition`) + back-references to ADR-014/ADR-015 (2 lines each)
- [x] Latent risk currently growing — quote count: n=6 candidates in T2 bag at ADR-016 ship date; ADR-014 audit added 3 candidates (P2/P8/P10), second-pass audit 2026-05-23 added 3 more (handoff/to-issues-aug/tdd); growth rate = 3 candidates per audit cycle
- [x] Retroactive correction quantified as materially harder: reconstructing entry dates for 60 candidates requires lesson archeology across 6+ months of session transcripts; reconstructing for 6 is 3-day-delta approximation accepted by #216 reviewer (acceptable). The 10× growth between current state and retroactive horizon is the non-linear cost curve

## Consequences

### Positive

- Bag has explicit lifecycle — no indefinite accumulation
- Eviction format reuses ADR-014's P4-lite OOS catalog (no new infrastructure)
- Re-entry path via SHA-churn **OR** friction signal preserves option value (Q3 expansion)
- Cost-asymmetry gate has documented activation criteria + Self-Check enforcement (Q6 expansion) — prevents future doctrine drift
- Doctrine integrity: friction-first hypothesis gets tested empirically (eviction confirms or refutes "candidate genuinely wasn't needed")

### Negative / Honest disclosure

- **n=0 friction in this codebase** — adopted on cost-of-correction asymmetry, not field evidence
- 6 existing candidates get a uniform 2026-11-23 drop date (3-day delta approximation)
- Eviction may feel like wasted audit effort — framed as hypothesis-confirmed to mitigate
- This ADR creates a documented exception class to friction-first (cost-asymmetry gate) — boundedness depends on future contributors honoring the 3-condition Self-Check

### Risk register

| ID  | Risk                                                    | Mitigation                                                                                        |
| --- | ------------------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| R1  | Drop date evictions feel like failure                   | Frame eviction as hypothesis-confirmed (friction-first worked); OOS catalog records these as wins |
| R2  | 6mo window too short — real friction emerges at month 7 | Re-entry path via SHA-churn OR friction signal; evicted candidates not permanently rejected (Q3)  |
| R3  | 6mo window too long — bag rots within window            | Acceptable trade-off; revisit at 12-month doctrine review                                         |
| R4  | Grandfathered 2026-11-23 wrong for newer entries        | Acceptable per #216 reviewer; 3-day delta doesn't materially affect outcomes                      |
| R5  | Cost-asymmetry gate is invoked for non-trivial work     | Q6 Self-Check items are falsifiable; appeals citing the gate without evidence should be rejected  |
| R6  | Single ADR-016 doctrine review at month-12 misses drift | Future amendments can add interim review triggers (per friction signal, not schedule)             |

## Compliance with Plugin Boundary

| Domain                                                         | Plugin               |
| -------------------------------------------------------------- | -------------------- |
| T2 bag eviction policy (this ADR)                              | **8-habit-ai-dev** ✓ |
| Three Loops, EU AI Act applicability of any shipped candidates | `claude-governance`  |

This ADR is **workflow discipline meta-governance** — extends ADR-014's audit doctrine with one operational rule. No skills added/removed, no hooks, no compliance mappings.

## Article 14 Applicability

Process governance for plugin maintainers, not an AI decision system. Not in scope for EU AI Act Article 14. Human retains full control over each eviction decision (eviction is mechanical at drop date, but recording rationale and re-entry decisions remain human-in-the-loop).

## Constraints Honored

- **C1 (Zero-dep)**: Date tracking is YAML frontmatter; no new tooling
- **C2 (Plugin boundary)**: stays in 8-habit-ai-dev
- **C3 (No skill-graph DAG change)**: no skills affected
- **C4 (No new hooks)**: eviction is human-driven, not enforced
- **C5 (Version sync)**: ADR-only commit; no plugin.json bump (doctrine change, not skill change)
- **C6 (Honest framing per ADR-014)**: n=0 friction + cost-of-correction asymmetry + Q3/Q6 modifications all disclosed

## Future Reversal Conditions

This amendment should be revisited if:

1. **12 months post-acceptance, zero evictions have occurred** → either (a) every bag candidate found friction (success — doctrine works) or (b) eviction process was bypassed (process failure). Audit which.
2. **6mo window proves consistently too short or too long** → adjust window with empirical justification
3. **Re-entry mechanism (SHA-churn OR friction) never used** → evicted candidates are permanently dead; either accept or design lighter re-entry path
4. **Cost-asymmetry gate invoked >3 times without rejection** → either the bar is too low or the doctrine genuinely needs this complement; analyze the pattern
5. **Reviewer feedback indicates Self-Check items are routinely skipped or rubber-stamped** → tighten the gate (e.g., require explicit external review for cost-asymmetry invocations)

## Deferred Amendments

The original 4-amendment proposal at [#215](https://github.com/pitimon/8-habit-ai-dev/issues/215) was scoped down after peer review. Deferred items archived at [`docs/out-of-scope/ADR-016-rfc-deferred-amendments.md`](../out-of-scope/ADR-016-rfc-deferred-amendments.md):

- **A1 lane split** → replaced by reviewer's superior alternative (evidence-type taxonomy in ADR header), deferred until first preventive-skill proposal materializes
- **A2 trial gate** → deferred until n≥1 case of shipping-wrong-fix-after-n=1-citation
- **A4 SHA-watch as ADR clause** → reshaped to `scripts/sha-watch-mattpocock.sh` + `CONTRIBUTING.md` section (separate PR; not gated on ADR-016 acceptance). mattpocock/skills does not tag releases (`gh release list --repo mattpocock/skills` is empty); release-watch subscription would never fire

## Self-Check Before Merge

- [x] Drop date for existing 6 T2 candidates explicitly set (2026-11-23) — see inventory table
- [x] OOS catalog schema extended to support `eviction-date` + `re-entry-condition` fields (documented in this ADR's Eviction record format section)
- [x] Deferred amendments (A1/A2/A4) archived with reviewer credit at `docs/out-of-scope/ADR-016-rfc-deferred-amendments.md`
- [x] Q3 re-entry mechanism expanded (SHA-churn **OR** friction signal) — reviewer credit recorded
- [x] Q6 Self-Check items mandatory for future cost-asymmetry invocations — recorded with falsifiable evidence requirement
- [x] Cost-asymmetry gate Self-Check completed for THIS ADR (3 items above)
- [x] Back-reference links added to ADR-014 and ADR-015
- [ ] A4 SHA-watch script committed (separate PR; deferred from this ADR's scope)
- [ ] 12-month review checkpoint scheduled (depends on whether future scheduling skill emerges)
