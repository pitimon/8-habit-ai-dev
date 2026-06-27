# ADR-026: External Prior-Art Audit — karpathy-skills + gstack (with utarn/engineer-skills closeout)

**Status**: Accepted
**Date**: 2026-06-27
**Decision makers**: Pitimon (human) + Claude Opus 4.8 (AI, 1M context)
**Related**: [ADR-006 Audience Honesty + Superpowers Deferral](./ADR-006-audience-honesty-and-superpowers-deferral.md), [ADR-014 External Prior-Art Audit](./ADR-014-external-prior-art-audit.md) (tier framework + friction-first gate this ADR reuses), [ADR-016 T2 Bag Drop-Date](./ADR-016-t2-bag-drop-date-eviction-policy.md) (eviction policy for the T2 deferrals below), [ADR-017 Anthropic Skill Patterns](./ADR-017-anthropic-skill-patterns-audit.md), [ADR-019 Doctrine-Only Scope Refinement](./ADR-019-doctrine-only-scope-refinement.md) (consumer-vs-contributor doctrine — why this ADR is no-bump), [ADR-021 Dynamic-Workflow Positioning](./ADR-021-dynamic-workflow-positioning.md)
**Source brief**: `~/.claude/plans/deep-ai-dynamic-wreath.md` (Deep mode, Audit). Predecessor engineer-skills brief: `~/.claude/plans/deep-https-github-com-utarn-engineer-ski-lexical-raccoon.md`
**Related rejection record**: [`docs/out-of-scope/grill-with-docs-glossary.md`](../out-of-scope/grill-with-docs-glossary.md) (same viral-post genre; covered the domain-modeling / glossary slice on 2026-06-27)
**Tracking**: [issue #339](https://github.com/pitimon/8-habit-ai-dev/issues/339) · [PR #340](https://github.com/pitimon/8-habit-ai-dev/pull/340)
**External sources audited** (primary, verified June 2026 via WebFetch):

- <https://github.com/multica-ai/andrej-karpathy-skills> (single `CLAUDE.md`, 4 rules; ~220k★ combined across personal + org mirror)
- <https://github.com/garrytan/gstack> (23 core skills + 8 power tools, persona pipeline; ~110k★)
- <https://github.com/utarn/engineer-skills> (fork of `mattpocock/skills`; MIT, ~29★ — closeout of the dangling 2026-06-23 audit, memory obs #108139)

---

## Context

A viral social post promoted five "agent skills" repos (obra/superpowers, multica-ai/andrej-karpathy-skills, mattpocock/skills, garrytan/gstack, addyosmani/agent-skills, "600k+ combined stars") and asked: **how should these improve `8-habit-ai-dev`?** Four of the five are already adjudicated — superpowers ([ADR-006](./ADR-006-audience-honesty-and-superpowers-deferral.md) defer-to), mattpocock ([ADR-014](./ADR-014-external-prior-art-audit.md)), addyosmani (CHANGELOG v2.7.0 onboarding parity + SELF-CHECK v2.15.1 doubt-driven import), and Anthropic's own skills ([ADR-017](./ADR-017-anthropic-skill-patterns-audit.md)). This ADR closes the two repos with **no prior ADR** (karpathy-skills, gstack) and the one **dangling thread** (utarn/engineer-skills, audited 2026-06-23 but never recorded — memory obs #108139).

**Honest framing up front.** The request is driven by repo _popularity_, not by observed _friction_ in this codebase. The star counts are real (verified June 2026: superpowers ~226k, gstack ~110k), but **popularity is not a friction citation.** This is the exact trap [ADR-014 line 63](./ADR-014-external-prior-art-audit.md) names ("require explicit friction citation, not just pattern attractiveness") and the same gate that rejected the grill-with-docs glossary features hours earlier on 2026-06-27. This ADR therefore **defers by default**: it records verdicts and closes loose threads (the durable deposit) without shipping any new consumer surface.

## Tier Framework Applied

Reusing [ADR-014](./ADR-014-external-prior-art-audit.md)'s tiers:

| Tier   | Criterion                                                                     | Action                                                                            |
| ------ | ----------------------------------------------------------------------------- | --------------------------------------------------------------------------------- |
| **T1** | Real gap + fits read-only skill rule + fits plugin boundary + clear habit map | **Ship** in this release                                                          |
| **T2** | Plausible value but needs evidence (friction) or non-trivial change           | **Defer** with [ADR-016](./ADR-016-t2-bag-drop-date-eviction-policy.md) drop date |
| **T3** | Conflicts with an architectural principle, redundant, or no fit               | **Reject**, document in `docs/out-of-scope/`                                      |

## 1. multica-ai/andrej-karpathy-skills — 4 rules

A single `CLAUDE.md` distilling Karpathy's January-2026 list of LLM-coding failure modes into four rules (exact wording from the repo `README.md`, verified):

| #   | Karpathy rule (verbatim)                                                                   | Coverage in `8-habit-ai-dev`                                                                                                                                                                                                                                                      | Tier verdict |
| --- | ------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ |
| #1  | **Think Before Coding** — _"Don't assume. Don't hide confusion. Surface tradeoffs."_       | **Native (strong)** — `/research` → `/requirements` → `/build-brief` gate (H5/H2); `/build-brief` requires the problem statement before any write                                                                                                                                 | — (native)   |
| #4  | **Goal-Driven Execution** — _"Define success criteria. Loop until verified."_ + test-first | **Native (strong)** — H2 "Begin with End in Mind" (`/requirements` EARS success criteria), H3 no-scope-creep, `guides/tdd-tracer-bullet.md` for the test-first loop                                                                                                               | — (native)   |
| #2  | **Simplicity First** — _"Minimum code that solves the problem. Nothing speculative."_      | **Partial** — H3 covers _gold-plating_ (`habits/h3-first-things-first.md:54`) and Q4 names _premature optimization_ (`:14`), but there is no dedicated simplicity/YAGNI surface (no guidance on single-use abstraction, unasked flexibility, error handling for impossible cases) | **T2 defer** |
| #3  | **Surgical Changes** — _"Touch only what you must. Clean up only your own mess."_          | **Weak** — blast-radius minimization exists for deploys (`skills/deploy-guide/SKILL.md:71`) and size/nesting limits in `/review-ai`, but no "minimal-diff / don't rewrite the whole file" edit discipline                                                                         | **T2 defer** |

### The #3 ↔ H1 tension (why #3 must be designed, not copied)

Karpathy #3 forbids _improving adjacent code, refactoring unbroken code, or deleting pre-existing dead code_ — "every changed line must trace to the request." That **directly tensions with H1 Be Proactive** (`habits/h1-be-proactive.md:9`: "fix the bug, check every caller of the affected function, add edge case handling, and update the docs — all in the same session"). A naive port would read as anti-H1. Any future adoption must frame #3 as _"surgical within the **diff** of an intended change"_ — keep the change minimal and traceable — **without** suppressing H1's defense-in-depth (tracing callers, hardening edges). This design requirement is a second, independent reason #3 is T2 rather than T1.

### Why T2, not T1

Both #2 and #3 are **genuine gaps** at the level of a dedicated, consolidated discipline: neither appears in `guides/anthropic-engineering-doctrine-audit.md` Tables 1–2, and H3 only reaches them via gold-plating. (Partial #2 coverage does exist in passing — `guides/tdd-tracer-bullet.md:38` "no speculative future behavior was added" and the `guides/skill-authoring.md` speculative-skill gate — but neither is a general simplicity/YAGNI surface, and there is no surgical-edit discipline at all.) But **no first-person friction citation exists** — no `/reflect` lesson, cross-verify imbalance, or maintainer report describing rework caused by AI over-engineering or whole-file rewrites in _this_ project. Per the friction-first gate, attractiveness + a viral post is insufficient. Deferred under the [ADR-016](./ADR-016-t2-bag-drop-date-eviction-policy.md) eviction convention, **drop date 2026-12-27** (~6 months from this entry).

**Re-entry / ratchet to T1**: a documented friction signal (AI over-engineering or rewriting a whole file where a targeted edit was correct). On that signal, ship a _single_ `guides/simplicity-and-surgical-edits.md` (consumer-doctrine → version bump) wired into `/review-ai`, `/build-brief`, and `/cross-verify`, with #3 framed against the H1 tension above.

## 2. garrytan/gstack — persona pipeline

gstack ships 23 core skills + 8 power tools as a **sequential persona pipeline** (Think→Plan→Build→Review→Test→Ship→Reflect), prompt-skills that orchestrate multi-step pipelines and run autonomously with human approval gates (verified). The role _concepts_ map almost entirely onto surfaces we already have:

| gstack role / skill                                | Existing `8-habit-ai-dev` equivalent                      |
| -------------------------------------------------- | --------------------------------------------------------- |
| CEO / `/office-hours` ("find the 10-star product") | `/scrutinize` (questions whether the change should exist) |
| Eng Manager / `/plan-eng-review`                   | `/design` + `/breakdown`                                  |
| Staff Engineer / `/review` + QA Lead / `/qa`       | `/review-ai` + `8-habit-reviewer` agent                   |
| Release Engineer / `/ship`, `/land-and-deploy`     | `/deploy-guide`                                           |
| CSO / `/cso` (OWASP + STRIDE)                      | `/security-check`                                         |
| Technical Writer / `/document-*`                   | `/management-talk` (partial — audience reshape)           |

**Verdict: T3 reject.** The role _concepts_ are already native; the genuine differentiator is the **persona framing + sequential auto-pipeline orchestration**, which is a multi-agent _engine_, not single-human workflow _discipline_. The CLAUDE.md plugin-boundary rule-of-thumb routes _"Runtime hook, compliance framework mapping, enforcement gate, or formal decision-authorization model → `claude-governance`"_ (`CLAUDE.md:54`). A persona pipeline that runs autonomously and sequences approval gates is exactly a **runtime + decision-authorization** mechanism — the same basis [ADR-021](./ADR-021-dynamic-workflow-positioning.md) used to route the Opus dynamic-workflow engine out of this plugin (`ADR-021:34`). So persona-pipeline orchestration belongs in `claude-governance`, not here. Recorded in [`docs/out-of-scope/gstack-persona-pipeline.md`](../out-of-scope/gstack-persona-pipeline.md).

> Boundary basis is the **verbatim CLAUDE.md:54 rule-of-thumb** ("runtime hook" + "formal decision-authorization model"). [ADR-021](./ADR-021-dynamic-workflow-positioning.md) is cited only as _consistent precedent_ for the routing move, not as the controlling decision — it is narrowly about the Opus dynamic-workflow engine, whereas gstack is a bag of persona prompt-skills, so the general boundary rule controls here.

## 3. utarn/engineer-skills — closeout of the dangling thread

utarn/engineer-skills (audited 2026-06-23, never recorded — memory obs #108139, #108130, #108131) is a **fork of `mattpocock/skills`** — the exact repo already adjudicated in [ADR-014](./ADR-014-external-prior-art-audit.md). Its inherited surface is therefore pre-decided; only its net-new additions need a verdict. Closeout recorded in [`docs/out-of-scope/utarn-engineer-skills.md`](../out-of-scope/utarn-engineer-skills.md); summary: Bucket A (≈8 skills) already covered, Bucket B (`codebase-design`, `find-mismatch`) already deferred by ADR-014, Bucket C net-new candidate `improve-codebase-architecture` (structural-decay scan, H7) → **T2 defer** pending friction. The `domain-modeling` active-loop and `grill-with-docs` inline-write were already adjudicated (ADR-014 P6 + the grill-with-docs OOS record).

## 4. superpowers / addyosmani — re-confirm only

No new action. superpowers stays **defer-to** ([ADR-006](./ADR-006-audience-honesty-and-superpowers-deferral.md): `/research` and `/workflow` point users at `superpowers:brainstorming` rather than duplicating it). addyosmani parity was already taken (`/using-8-habits`, doubt-driven techniques in `guides/advisor-pattern.md`).

## Decision Summary

| Pattern                               | Tier           | Disposition                                              |
| ------------------------------------- | -------------- | -------------------------------------------------------- |
| Karpathy #1 think-before-code         | — (native)     | Already covered — cite existing                          |
| Karpathy #4 goal-driven / test-first  | — (native)     | Already covered — cite existing                          |
| Karpathy #2 simplicity / YAGNI        | **T2 defer**   | Drop date 2026-12-27; ratchet on friction                |
| Karpathy #3 surgical / minimal-diff   | **T2 defer**   | Drop date 2026-12-27; must reframe vs H1 before any ship |
| gstack persona pipeline               | **T3 reject**  | Boundary → `claude-governance` (CLAUDE.md rule-of-thumb) |
| utarn `improve-codebase-architecture` | **T2 defer**   | Closeout; reversal on structural-decay friction          |
| superpowers spec/TDD/brainstorm       | — (re-confirm) | ADR-006 defer-to stands                                  |

**Ship nothing this turn.** This ADR plus the two out-of-scope records are the deliverable.

## Compliance with Plugin Boundary

All verdicts stay inside `8-habit-ai-dev`'s charter (workflow discipline). The one rejection (gstack persona pipeline) is rejected _because_ it crosses into `claude-governance`'s domain (multi-agent orchestration). No enforcement hook, framework mapping, or runtime engine is added here. [ADR-005](./ADR-005-eu-ai-act-compliance-toolkit.md) / [ADR-019](./ADR-019-doctrine-only-scope-refinement.md) boundary analysis applies.

## Consequences

**Positive**:

- Closes the last two un-audited repos from the viral post + the dangling engineer-skills thread — the next viral post citing these repos hits a durable "already evaluated" record instead of re-litigating.
- Records two genuine gaps (Karpathy #2/#3) honestly as T2, with the #3↔H1 design tension captured so a future adopter doesn't ship an anti-H1 rule.

**Negative / Honest disclosure**:

- This is a popularity-driven audit, not a friction-driven one. Per ADR-014's lesson, that is acceptable **only** because it ships nothing — it records verdicts and defers. The two T2 gaps remain unaddressed until a real friction signal appears; if none does by 2026-12-27, they are evicted per ADR-016.
- The discoverability follow-up (appending Karpathy #2/#3 to `guides/anthropic-engineering-doctrine-audit.md` Table 2, so the grep-protocol at `:52-59` finds them) is **deliberately not done here** — touching `guides/` is a consumer-doctrine change requiring a version bump, and is left as a separate maintainer decision.

## Options Considered

1. **Defer-by-default, record only (chosen)** — advisor-preferred and consistent with the 2026-06-27 grill-with-docs rejection. Ships the audit deposit; no consumer change; no bump.
2. **Ship `guides/simplicity-and-surgical-edits.md` now (T1)** — rejected: no friction citation; would repeat the asymmetry ADR-014 was criticized for (memory obs #89040, #89418).
3. **Adopt gstack persona roles** — rejected: role concepts already native; the orchestration differentiator belongs in `claude-governance`.

## Self-Check

- [x] Primary sources cited with URLs; external quotes (Karpathy taglines, gstack roles) confirmed byte-for-byte against the raw repo files, not only the WebFetch extraction
- [x] Every tier verdict carries a habit map + boundary fit per ADR-014 criteria
- [x] gstack boundary cite = verbatim `CLAUDE.md:54` rule-of-thumb (ADR-021 cited as consistent precedent, not controlling)
- [x] Karpathy #3 ↔ H1 tension recorded so no anti-H1 port happens later
- [x] T2 deferrals carry the ADR-016 drop date 2026-12-27 + re-entry conditions
- [x] Out-of-scope records created for gstack (T3) and utarn/engineer-skills (closeout)
- [x] Docs-only — no version bump (contributor-doctrine, ADR-019); `plugin/` mirror synced (Check 28)
