# ADR-015: `/diagnose` Skill Adoption — n=1 Friction Citation and Forward-Guardrail Framing

**Status**: Accepted
**Date**: 2026-05-23
**Decision makers**: Pitimon (human) + Claude Opus 4.7 (AI, 1M context)
**Related**: [ADR-014 External Prior-Art Audit](./ADR-014-external-prior-art-audit.md) (parent doctrine), [ADR-009 Skill Split Convention](./ADR-009-skill-split-convention.md) (SKILL.md + reference.md precedent), [ADR-013 Spec Persistence](./ADR-013-spec-persistence-opt-in.md) (PRD/design/tasks linkage), [ADR-012 EU AI Act Migration](./ADR-012-eu-ai-act-migration-completion.md) (referenced in Article 14 checkpoint), [ADR-016 T2 Bag Drop-Date](./ADR-016-t2-bag-drop-date-eviction-policy.md) (eviction policy for deferred candidates; this ADR's `/diagnose` was the first to escape the bag via friction signal before the policy existed)
**Source research brief**: `~/.claude/plans/deep-mattpocock-skills-second-pass-2026-05-23.md` (Deep mode, 12/14 sources verified by `research-verifier` agent)
**Source spec chain**: `docs/specs/diagnose-skill-v2-18-0/{prd,design,tasks}.md`
**External source audited**: <https://github.com/mattpocock/skills> SHA [`b8be62ffacb0118fa3eaa29a0923c87c8c11985c`](https://github.com/mattpocock/skills/tree/b8be62ffacb0118fa3eaa29a0923c87c8c11985c) (MIT, ~95.5k★)

---

## Context

[ADR-014](./ADR-014-external-prior-art-audit.md) (PR #210, v2.17.0, 2026-05-20) shipped 4 patterns from `mattpocock/skills` as forward guardrails with **no documented prior-friction signal** in this codebase. The advisor pattern review caught the premise-inversion mid-flow ("what's cool elsewhere?" vs "what hurts here?") and ADR-014 recorded the doctrine for future audits:

> _"future contributors evaluating 'should we add X' should require explicit friction citation, not just pattern attractiveness."_

A 2026-05-23 second-pass Deep `/research` audit of the same repo (pinned at SHA `b8be62ff`) identified `mattpocock/skills/engineering/diagnose` as a candidate **not covered by ADR-014's P1–P10 evaluation grid**. Unlike the v2.17.0 bundle, this candidate has a friction citation: a lesson file in `~/.claude/lessons/` documenting an absent-skill gap.

## The n=1 Friction Citation

`~/.claude/lessons/2026-04-12-compression-worker-420-investigation.md` (memforge project, H5-tagged) documents an ad-hoc bug investigation. Two direct quotes establish the gap:

1. _"Skill effectiveness: Most useful: n/a (no 8-habit skills invoked during the fix session)"_ — explicit acknowledgment that no existing skill helped during the active debug phase.

2. _"Could have been found in 5 minutes by comparing the two SQL queries side-by-side instead of 30 minutes of log analysis."_ — direct evidence that **Phase 1 (feedback-loop) discipline** would have changed the outcome.

This is **n=1, but unusually strong n=1**: a first-person retrospective admission of an absent-skill gap, not a pattern-driven inference.

## Decision

Adopt `/diagnose` as a new skill in `8-habit-ai-dev` v2.18.0. Strategy per [design.md Decision-5](../specs/diagnose-skill-v2-18-0/design.md): **Adapt-with-attribution** from `mattpocock/skills/engineering/diagnose/SKILL.md` (SHA `b8be62ff`):

- Preserve all 6 phases + key vocabulary (feedback-loop, falsifiable hypotheses, tagged probes, post-green refactor)
- Rewrite in 8-habit voice with explicit habit map (H1 + H5), checkpoint, when-to-skip rule, and handoff to `/post-mortem`
- Verbatim quote anchor on FR-004 hypothesis template (_"If X causes it, then changing Y will make the bug disappear."_) for methodology fidelity
- License attribution via SHA-pinned source URL in `skills/diagnose/reference.md`

Split per [ADR-009](./ADR-009-skill-split-convention.md) and [design.md Decision-1](../specs/diagnose-skill-v2-18-0/design.md): `SKILL.md` (≤2000 words, F3 fitness) + `reference.md` (no word limit, prior art + per-phase examples + license).

## Options Considered

| Option                                       | Description                                                      | Verdict                                                                                                 |
| -------------------------------------------- | ---------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| **Ship `/diagnose` only**                    | Single new skill, n=1 friction, ADR-015 honest framing           | **Accepted**                                                                                            |
| Ship `/diagnose` + `/breakdown` augmentation | Adds vertical-slice + AFK/HITL labels per mattpocock `to-issues` | Deferred — no documented friction for `/breakdown` augmentation                                         |
| Defer; file issue for `/diagnose` only       | Apply strict friction-first lens; wait for n≥2 signal            | Rejected — friction is real, skill is additive, n=1 is genuine first-person retrospective               |
| Bundle all 4 T1/T2 candidates as v2.18.0     | Diagnose + breakdown aug + handoff + tdd                         | Rejected — repeats ADR-014's premise-inversion lesson, three of four candidates lack friction citations |

Source brief at `~/.claude/plans/deep-mattpocock-skills-second-pass-2026-05-23.md` carries the full option analysis with friction signal table for the 4 T1/T2 candidates and the 6 T3 rejections.

## Consequences

### Positive

- Closes a documented gap between `/research` (too broad) and `/post-mortem` (too late) — there is now a skill for the active debugging phase
- The n=1 lesson's stated _"5 minutes vs 30 minutes"_ outcome becomes the test of skill effectiveness — future `/reflect` runs in compression-worker-style situations should reference whether the skill helped
- Sets precedent for **friction-first** external prior-art adoption (vs ADR-014's pattern-first inheritance), strengthening the audit doctrine

### Negative / Honest disclosure

- **n=1 is below ADR-014's preferred n≥2 bar.** Accepted because the friction signal is unusually strong (first-person absent-skill admission, not third-party pattern attractiveness) and because the skill is additive (no breaking change, no removal of existing capability).
- Future use may reveal the 6-phase methodology is overkill for the bug types this codebase actually encounters. Mitigation: when-to-skip rule explicit in SKILL.md; `/reflect` SKILL-EFFECTIVENESS feedback loop will surface this.
- Adds a 22nd skill to the plugin's inventory; raises ongoing maintenance surface. Mitigation: skill is additive and follows existing ADR-009 split pattern — no new infrastructure.

### Risk register (carried from PRD)

| ID  | Risk                                         | Mitigation                                                                      |
| --- | -------------------------------------------- | ------------------------------------------------------------------------------- |
| R1  | Overlap with `/post-mortem` causes confusion | Explicit boundary in SKILL.md + `next-skill: post-mortem` chain                 |
| R2  | Overlap with `/research`                     | Trigger-phrase differentiation (`debug`/`diagnose` vs `research`/`investigate`) |
| R3  | n=1 below ADR-014 bar                        | This ADR records the framing transparently                                      |
| R4  | 6-phase too prescriptive for simple bugs     | FR-011 skip rule + 5 concrete skip examples in SKILL.md                         |
| R5  | SKILL.md exceeds 2000-word F3 limit          | Decision-1 split: `reference.md` carries depth                                  |

## Compliance with Plugin Boundary

This skill stays in `8-habit-ai-dev` because it is **workflow discipline** (a methodology for humans investigating bugs), not enforcement.

| Domain                                                                         | Plugin               |
| ------------------------------------------------------------------------------ | -------------------- |
| Bug-investigation discipline (this skill)                                      | **8-habit-ai-dev** ✓ |
| PreToolUse/PostToolUse enforcement hooks                                       | `claude-governance`  |
| Compliance framework mappings (OWASP, EU AI Act, NIST)                         | `claude-governance`  |
| Three Loops Decision Model (Out-of/On-the/In-the-Loop classification of fixes) | `claude-governance`  |

If a future `/diagnose` user wants to classify their fix's risk tier (e.g., "is this In-the-Loop?"), they should compose with `claude-governance`'s `/governance-check` — not have this skill subsume that model. ADR-005 boundary analysis applies.

## Article 14 Applicability

The `/diagnose` skill is **markdown guidance consumed by Claude Code**, not itself a high-risk AI decision system per Annex III. Not EU-targeted as a regulated AI deployment. Article 14 ¶4(a-e) capabilities (Understand / Automation bias / Interpret / Override / Stop) are preserved — humans retain full control throughout the 6 phases.

Formal Annex III scope check belongs to `pitimon/claude-governance` v3.1.0+ via `/eu-ai-act-check --scope` (migrated per [ADR-012](./ADR-012-eu-ai-act-migration-completion.md)).

## Constraints Honored

- **C1 (ADR-009 read-only)**: skill provides guidance; Bash tool scoped to read-only feedback-loop construction (no writes, no deploys, no deletes)
- **C2 (Plugin boundary)**: workflow discipline → 8-habit-ai-dev, not claude-governance
- **C3 (Zero-dep)**: pure markdown, no new external dependencies
- **C4 (F3 fitness ≤2000 words)**: `SKILL.md` 1202 words at adoption; `reference.md` unbounded
- **C5 (Version sync atomicity)**: v2.18.0 bumps `plugin.json`, `marketplace.json`, `README.md`, `SELF-CHECK.md` in one commit (Check 4 enforces)
- **C6 (No skill-graph DAG break)**: new skill adds `prev-skill: any, next-skill: post-mortem` — additive, no existing edges modified
- **C7 (Honest framing per ADR-014)**: this ADR records n=1 framing transparently

## Future Reversal Conditions

This skill should be revisited if:

1. Six months post-adoption, `/reflect` SKILL-EFFECTIVENESS data shows **zero recorded uses** in real bug investigations → consider deprecation
2. A second friction citation accumulates → friction signal strengthens to n≥2, validating retroactively
3. Users repeatedly report confusion between `/diagnose` and `/post-mortem` → R1 materializing; revise boundary docs or merge skills
4. mattpocock/skills upstream `diagnose` SKILL.md materially changes its methodology → re-audit against new SHA

## Self-Check

- [x] Source brief preserved at `~/.claude/plans/deep-mattpocock-skills-second-pass-2026-05-23.md` with SHA pin
- [x] Spec chain preserved at `docs/specs/diagnose-skill-v2-18-0/{prd,design,tasks}.md`
- [x] n=1 friction citation includes verbatim lesson quotes
- [x] Honest disclosure of n=1 being below ADR-014's n≥2 preference
- [x] Plugin boundary compliance documented
- [x] Article 14 checkpoint addressed
- [x] Future reversal conditions enumerated
