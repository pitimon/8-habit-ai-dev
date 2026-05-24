# ADR-020: Skill Authoring Guide as Forward Guardrail

**Status**: Accepted
**Date**: 2026-05-24
**Decision makers**: Pitimon (human) + Claude Opus 4.7 (AI, 1M context)
**Related**: [ADR-009](./ADR-009-skill-split-convention.md) (split convention), [ADR-014](./ADR-014-external-prior-art-audit.md) (external prior-art tier framework), [ADR-017](./ADR-017-anthropic-skill-patterns-audit.md) (sister 5-pattern audit + Forward-Guardrail Sunset mechanism), [ADR-018](./ADR-018-memory-layer-activation.md) (SKILL-EFFECTIVENESS feedback loop), [ADR-019](./ADR-019-doctrine-only-scope-refinement.md) (consumer-doctrine version-bump rule)
**Source brief**: `~/.claude/plans/https-vibecodingthailand-com-blog-claude-vivid-wave.md` (Standard depth + Audit mode, 8-habit-reviewer cross-verified 12/17 → reconciled)
**Issue**: [#235](https://github.com/pitimon/8-habit-ai-dev/issues/235)
**External source audited**: <https://vibecodingthailand.com/blog/claude-skills-pro-guide> (Ben AI 5-part authoring framework via Keerati Limkulphong, 22 May 2026)

---

## Context

A 2026-05-24 audit of Vibe Coding Thailand's article on Ben AI's skill-authoring framework surfaced two real gaps in `8-habit-ai-dev` (23 skills, v2.18.3):

- **N1 — Pre-Building Preparation absent.** No discoverable authoring guide. `CONTRIBUTING.md §"Adding a New Skill"` (lines 9-69) is a structural template, not a methodology — it tells you what the file looks like, not how to earn it.
- **P2 — Objective conflated with trigger.** Existing skills treat frontmatter `description` (a trigger phrase enforced by Check 25) and the `**Habit**: H?` annotation (a label) as substitutes for a dedicated Objective. They are not.

The brief's first draft recommended "ship nothing" (friction-first defense, no `/reflect` lesson cites the gap). The `8-habit-ai-dev:8-habit-reviewer` cross-verify scored that draft 12/17 and identified the same selective-strictness pattern that almost shipped the wrong ADR-017 verdict four days earlier (lesson `~/.claude/lessons/2026-05-24-anthropic-5-pattern-audit-adr-017.md:25-26,33`). [ADR-014](./ADR-014-external-prior-art-audit.md) and [ADR-017](./ADR-017-anthropic-skill-patterns-audit.md) both shipped patterns with zero documented friction signal as forward guardrails; refusing this one on the same evidence bar would apply a stricter standard than the project's two most recent ADRs.

## Tier Framework Applied (ADR-014)

| Tier   | Criterion                                                                               | Action                              |
| ------ | --------------------------------------------------------------------------------------- | ----------------------------------- |
| **T1** | Real gap (F11 confirmed: no guide exists) + fits read-only charter + clear habit map    | **Ship** as forward guardrail       |
| **T2** | Plausible value but needs evidence (N2 multi-option HITL ≥5; N4b per-skill examples.md) | **Defer** with drop date 2026-11-24 |
| **T3** | Charter conflict (N4a self-modifying skills) or low-value framing-only (N3)             | **Reject**                          |

## Options Considered

### Option A — Documentation-only deposit (original brief recommendation, reviewer-rejected)

- **Description**: Log the brief as research artifact; ship nothing.
- **Pro**: Lowest risk, ~0 hours.
- **Con**: 8-habit-reviewer flagged this as H1/H5/H8 failure — applies a stricter friction standard than ADR-014 (4 patterns) and ADR-017 (P3) used 4-21 days earlier. Same "selective strictness" shape that the reviewer rescued the ADR-017 draft from. Lesson `2026-05-24-anthropic-5-pattern-audit-adr-017.md:33` codifies the sanity check: "When the recommendation is 'ship nothing,' does the precedent justify the deferral?"

### Option B — Tier 1 forward-guardrail ship (chosen)

- **Description**: Ship `guides/skill-authoring.md` (~300-400 lines) + `CONTRIBUTING.md` template diff adding `## Objective` section + this ADR. Honor [ADR-019](./ADR-019-doctrine-only-scope-refinement.md) consumer-doctrine version-bump rule (`guides/` edit → patch bump v2.18.3 → v2.18.4). Set Forward-Guardrail Sunset 2026-11-24 per [ADR-017](./ADR-017-anthropic-skill-patterns-audit.md) §"Forward-Guardrail Sunset" mechanism.
- **Pro**: Matches ADR-014/017 precedent consistently. Closes F11 + P2 gaps. Trains future contributors (H7 Production Capability). Cross-verify reconciliation makes the reviewer's H5/H8 challenges load-bearing in the historical record.
- **Con**: ~1-2 hours implementation. Adds one row to the future-tally surface that ADR-018 forcing function must keep alive.

### Option C — Tier 1 ship + retroactive sweep of all 23 existing skills to add Objective sections

- **Description**: Above plus edit all 23 skills to add `## Objective` sections matching the new skeleton.
- **Pro**: Highest consistency.
- **Con**: ~6-8 hours. Speculative across 23 skills with no per-skill friction signal. Heart-dimension risk: turns coaching docs into churn. Existing skills get Objective sections when they're otherwise touched.

**Selected: Option B** — consistent with ADR-014/017 precedent, scope-bounded, preserves T2 deferrals for N2/N4b, and uses ADR-017's existing sunset mechanism rather than inventing a new one.

## Decision — Tier 1 Shipments

| Item                               | Status   | Mechanism                                                                                                                                          |
| ---------------------------------- | -------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| `guides/skill-authoring.md`        | **Ship** | New guide covering Pre-Building Preparation + canonical SKILL.md skeleton (including dedicated `## Objective` section) + lifecycle + cross-refs    |
| `CONTRIBUTING.md` template diff    | **Ship** | Add `## Objective` section to the skill template (after `**Habit**:` line, before `## Process`) + pointer to the new guide at section head         |
| Version bump v2.18.3 → v2.18.4     | **Ship** | Patch bump per [ADR-019](./ADR-019-doctrine-only-scope-refinement.md) consumer-doctrine rule (`guides/` edit MUST bump); 4-file atomic per Check 4 |
| SKILL-EFFECTIVENESS.md tally entry | **Ship** | Release pulse note per [ADR-018](./ADR-018-memory-layer-activation.md) anti-dormancy forcing function                                              |

## Honest Framing — Forward Guardrail Consistent with ADR-014/017 Precedent

Per the ADR-014 pattern, this audit records that the guide ships with **no first-person friction signal** at decision time:

| Tier 1 shipment             | Pre-shipment friction signal                                                                                                                                                                                                                      | Post-shipment intent                                                                                                                                                                   |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `guides/skill-authoring.md` | None observed — 49 lessons searched (`~/.claude/lessons/*.md`), no `/reflect` lesson cites "I should have drafted reference docs before SKILL.md." F11 confirms the gap is structural (no guide exists) but the friction is not yet first-person. | Forward guardrail per ADR-014/017 precedent. If by 2026-11-24 no `/reflect` lesson cites the guide and no contributor PR references it, evaluate reversion via separate amendment ADR. |

Cross-verify reconciliation is the load-bearing evidence: the reviewer's H5 challenge ("are you applying ADR-014/017's precedent consistently to N1?") forced the revision. The reconciliation paragraph is in the source brief §"Cross-Verify Reconciliation."

## Forward-Guardrail Sunset (inline mechanism owned by this ADR)

This ADR's Tier 1 shipments carry a review-checkpoint of **2026-11-24**. Reversal criteria (separate amendment ADR required — ADRs are immutable record):

- Zero `/reflect` lessons cite the guide in the 6 months since activation, AND zero contributor PRs reference it, AND no new skill since activation has demonstrated the Pre-Building Preparation pattern via reference docs preceding SKILL.md

Non-reversal criteria (any of the following = keep shipped):

- ≥1 `/reflect` lesson cites the guide as having helped during skill authoring
- ≥1 contributor PR references the guide
- A new skill lands with reference docs drafted before SKILL.md (the pattern operationalized)

This mechanism is [ADR-017](./ADR-017-anthropic-skill-patterns-audit.md) §"Forward-Guardrail Sunset" applied to this ADR's shipments. It is **not** [ADR-016](./ADR-016-t2-bag-drop-date-eviction-policy.md) eviction (which scopes only to never-shipped T2 items — see ADR-017 §"Forward-Guardrail Sunset" for the distinction).

## T2 Bag — Deferred Adoptions

Added to the T2 inventory per [ADR-016](./ADR-016-t2-bag-drop-date-eviction-policy.md):

| Pattern                                   | Why deferred                                                                                                                                | Re-entry condition                                                                                                                                | Drop date  |
| ----------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- |
| **N2 multi-option HITL ≥5**               | `working-with-pitimon.md` §2 already requires 2-4 ranked options. Ben AI's stronger ≥5 version has no friction signal that 2-4 is too few.  | A `/cross-verify` finding or `/reflect` lesson flags a skill for single-option railroading where 2-4 options would not have caught the failure.   | 2026-11-24 |
| **N4b per-skill `examples.md` extension** | Precedent exists (`skills/calibrate/examples.md`, `skills/using-8-habits/examples.md`); pattern not documented as a default for new skills. | A `/reflect` lesson cites "this skill would have been clearer with a curated examples.md" OR a PR review flags it consistently across new skills. | 2026-11-24 |

## Out-of-Scope — Rejected

| Pattern                                                   | Why rejected                                                                                                                                                                                                                                                           | Re-entry condition                                                                                                          |
| --------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| **N3 explicit iteration-cycle framing (~5 rounds)**       | SKILL-EFFECTIVENESS.md tally (ADR-018) already tracks iteration implicitly. Adding a "skills are never done" framing line adds no actionable check.                                                                                                                    | An H7 friction case where contributors give up on skill iteration prematurely because the "done" criterion is unclear.      |
| **N4a self-modifying skills (maximal reading of Ben P5)** | `CLAUDE.md §Architecture`: "skills are read-only guidance — they tell Claude how to approach a task, they do not modify files themselves." Same boundary [ADR-017](./ADR-017-anthropic-skill-patterns-audit.md) used to reject Anthropic Pattern 4 (embedded scripts). | A charter amendment ADR arguing the H7 benefit > the simplicity of guidance-only. No friction motivates this amendment now. |

## Constraints Honored

- **C1 (Zero-dep invariant)**: Guide + ADR are pure markdown; no new dependencies.
- **C2 (Charter integrity)**: Guide is read-only reference content per CLAUDE.md §"Architecture"; N4a rejection preserves the read-only-guidance principle.
- **C3 (Plugin boundary)**: Workflow discipline → here. No claude-governance overlap (no PreToolUse / PostToolUse hook).
- **C4 (Version-bump rule per [ADR-019](./ADR-019-doctrine-only-scope-refinement.md))**: `guides/` edit triggers consumer-doctrine bump → v2.18.3 → v2.18.4 atomic across 4 files (`plugin.json`, `marketplace.json`, `README.md`, `SELF-CHECK.md`); Check 4 enforces.
- **C5 (ADR-018 anti-dormancy forcing function)**: SKILL-EFFECTIVENESS.md tally entry added for this release per `CONTRIBUTING.md §"Release Checklist"`.

## Self-Check

- [x] Source brief preserved at `~/.claude/plans/https-vibecodingthailand-com-blog-claude-vivid-wave.md`
- [x] 8-habit-reviewer cross-verify report integrated (§"Cross-Verify Reconciliation" in brief)
- [x] `guides/skill-authoring.md` created and cross-references ADR-009/014/017/018/019 + CONTRIBUTING.md
- [x] `CONTRIBUTING.md` template includes `## Objective` section + pointer to the new guide
- [x] Version bump v2.18.3 → v2.18.4 atomic per Check 4
- [x] SKILL-EFFECTIVENESS.md tally entry added per ADR-018 forcing function
- [x] Forward-guardrail sunset 2026-11-24 set (this ADR's inline mechanism, not ADR-016 eviction)
- [x] T2 entries (N2, N4b) added to ADR-016 inventory with drop date 2026-11-24

## Consequences

**Positive**:

- Closes the F11 + P2 structural gaps surfaced by the audit
- Establishes a discoverable authoring methodology for future contributors and future Claude sessions
- Demonstrates the advisor-then-reviewer-then-revise pattern in the historical record (lesson `2026-05-24-anthropic-5-pattern-audit-adr-017.md:35-42`)
- Maintains friction-first integrity by applying ADR-014/017 precedent consistently rather than selectively

**Negative / Honest disclosure**:

- Adds 1 to the active forward-guardrail sunset queue (this ADR + ADR-017 + ADR-018 + ADR-019 all share the 2026-11-24 review-checkpoint surface)
- The guide may go uncited if existing contributors already internalized the methodology — that risk is what the sunset criterion measures
- ADR-014's precedent for "ship with zero friction" continues to be load-bearing; if any of those ADRs reverse at their respective sunsets, this ADR's reasoning chain weakens proportionally
