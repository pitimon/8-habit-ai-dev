# ADR-017: Anthropic Skills 5-Pattern Audit — Tier 1 P3 Ship, P4 OOS, P5 T2

**Status**: Accepted
**Date**: 2026-05-24
**Decision makers**: Pitimon (human) + Claude Opus 4.7 (AI, 1M context)
**Related**: [ADR-009 Skill Split Convention](./ADR-009-skill-split-convention.md), [ADR-014 External Prior-Art Audit](./ADR-014-external-prior-art-audit.md), [ADR-015 /diagnose Adoption + n=1 Framing](./ADR-015-diagnose-skill-adoption-and-n1-framing.md), [ADR-016 T2 Bag Drop-Date](./ADR-016-t2-bag-drop-date-eviction-policy.md)
**Source brief**: `~/.claude/plans/research-briefs/2026-05-24-anthropic-skill-patterns-audit.md` (Deep mode + Audit submode, 7/7 citations text-verified)
**Issue**: [#218](https://github.com/pitimon/8-habit-ai-dev/issues/218)
**External source audited**: <https://github.com/anthropics/skills> (specifically `skills/pdf`, `skills/pptx`, `skills/docx`)

---

## Context

A user-prompted audit (2026-05-24) examined Anthropic's official `github.com/anthropics/skills` repo against `8-habit-ai-dev`'s 23 skills, evaluating the 5 SKILL.md patterns surfaced in a Thai-language blog post:

1. **Description = trigger instruction** (verb + scenario + edge case + negative case)
2. **SKILL.md = table of contents** (sub-files for detail)
3. **NEVER/MUST + reason** (not soft language)
4. **Embedded executable scripts** (e.g., `pptx/scripts/thumbnail.py`)
5. **Bug-hunt / fix-verify loop** ("Assume there are problems")

The `8-habit-ai-dev:8-habit-reviewer` cross-verify pushed back on the brief's original "documentation-only" recommendation. The H5 push-back was load-bearing: ADR-014 shipped 4 patterns four days earlier with zero documented friction signal as forward guardrails (ADR-014 §"Honest Framing" lines 52-63). Applying a stricter standard to Anthropic patterns than to mattpocock patterns would be selective strictness.

The brief was revised to promote P3 to Tier 1 as a forward guardrail consistent with ADR-014 precedent. A **review-checkpoint of 2026-11-23** is set for this ADR's Tier 1 shipments (see §"Forward-Guardrail Sunset" below) — this is an inline mechanism owned by ADR-017, **not** the ADR-016 eviction mechanism (which scopes strictly to T2 bag candidates never shipped). Only this ADR's **T2 entry** (the P5 fix-verify extension to `/diagnose`/`/scrutinize`/`/security-check`) uses ADR-016's mechanism directly, because that entry IS a T2 candidate.

## Tier Framework Applied (from ADR-014)

| Tier   | Criterion                                                                     | Action                                       |
| ------ | ----------------------------------------------------------------------------- | -------------------------------------------- |
| **T1** | Real gap + fits read-only skill rule + fits plugin boundary + clear habit map | **Ship** in this release                     |
| **T2** | Plausible value but needs evidence or non-trivial change                      | **Defer** with ADR-016 drop date             |
| **T3** | Conflicts with existing architectural principle, redundant, or no fit         | **Reject**, document in `docs/out-of-scope/` |

## Options Considered

### Option A — Documentation-only deposit (original brief recommendation)

- **Description**: File GH issue + OOS file for Pattern 4 + record Patterns 3 and 5 in T2 bag with drop date 2026-11-23. No skill edits, no validator extension.
- **Pro**: Lowest risk, ~1 hour, strictly compliant with "friction-first" interpretation that no observed friction = no Tier 1 action.
- **Con**: 8-habit-reviewer cross-verify flagged this as H8/Spirit failure ("selective strictness reads as work-avoidance"). H5 misreads ADR-014: ADR-014 itself shipped 4 patterns 4 days earlier with the same zero-friction score as forward guardrails, so applying a stricter standard to Anthropic patterns is selective. Also fails H7 — pure documentation decays where ADR-014 paired adoption with validator (Check 25).

### Option B — Tier 1 P3 ship as forward guardrail (chosen)

- **Description**: Promote Pattern 3 (NEVER/MUST + reason) to Tier 1. Add warning-only Check 26. Edit 2 high-consequence skills (`/scrutinize`, `/diagnose` Phase 6). Keep Pattern 4 OOS, Pattern 5 split (T2 language nudge + claude-governance companion runtime hook). Set a forward-guardrail review-checkpoint of 2026-11-23 (inline mechanism — see §"Forward-Guardrail Sunset"; distinct from ADR-016's T2-bag eviction which applies only to the P5 T2 entry).
- **Pro**: Consistent with ADR-014 precedent (forward guardrails with zero friction signal); resolves the H5/H7/H8 push-backs from cross-verify; ships reusable Production Capability (Check 26); preserves friction-first safety net via drop date.
- **Con**: ~3-4 hours implementation; 2 skill text edits change runtime behavior (mitigated by warning-only validator + drop date eviction).

### Option C — Tier 1 P3 + P5 full ship

- **Description**: Above plus extend `/review-ai` fix-verify loop to `/diagnose`, `/scrutinize`, `/security-check`; implement claude-governance PostToolUse hook directly.
- **Pro**: Highest pattern coverage; full reviewer recommendation.
- **Con**: ~5-6 hours; methodology changes affect runtime register on 3 skills (Heart dimension risk — turns coaching tools into enforcement gates); cross-plugin implementation skips boundary discipline (PostToolUse hook in this repo violates plugin boundary per memory obs #233270).

**Selected: Option B** — matches the ADR-014 precedent (forward guardrails when friction-low, drop date as safety net), respects plugin boundary (P5 runtime half filed cross-plugin not implemented here), and pairs adoption with validator extension per the established Check-25 pattern.

## Decision — Per-Pattern Verdict

| #     | Pattern                           | Verdict                       | Mechanism                                                                                                                                                                                                                                                                                           |
| ----- | --------------------------------- | ----------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **1** | Description = trigger instruction | **Already shipped** (ADR-014) | Check 25 enforces ≤1024 chars + trigger phrase. 23/23 pass.                                                                                                                                                                                                                                         |
| **2** | SKILL.md = table of contents      | **Already shipped** (ADR-009) | `Load ${CLAUDE_PLUGIN_ROOT}/...` directive pattern. 5/23 split when >1500 words; 18/23 below threshold.                                                                                                                                                                                             |
| **3** | NEVER/MUST + reason               | **Tier 1 ship**               | New Check 26 (warning-only) + targeted skill edits on `/scrutinize` (Check 26-flagged) and `/diagnose` Phase 6 (proactive Pattern-5-adjacent edit, not Check 26-driven). Forward-guardrail review-checkpoint 2026-11-23 (see §"Forward-Guardrail Sunset" — inline mechanism, not ADR-016 eviction). |
| **4** | Embedded scripts                  | **Tier 3 reject**             | Conflicts with plugin charter ("skills are read-only guidance"). File `docs/out-of-scope/anthropic-pattern-4-scripts.md`.                                                                                                                                                                           |
| **5** | Bug-hunt / fix-verify loop        | **Tier 2 split**              | Language nudge half deferred (extension to `/diagnose`, `/scrutinize`, `/security-check` needs friction citation). Runtime hook half filed as companion issue in `pitimon/claude-governance` per plugin boundary. ADR-016 drop date 2026-11-23 for the T2 half.                                     |

## Honest Framing — Forward Guardrail Consistent with ADR-014 Precedent

Per ADR-014's pattern, this audit records that P3 ships with **no first-person friction signal** in the codebase at decision time:

| Pattern adopted (Tier 1)         | Pre-shipment friction signal                                                                                                                                                                                                                                                                                                                                | Post-shipment intent                                                                                                                                                                                                                                                                                                                                 |
| -------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **P3 Check 26 + targeted edits** | None observed — searched `~/.claude/lessons/` (empty), `SKILL-EFFECTIVENESS.md` (0 lessons analyzed), git log, project docs, memory. Check 26 flagged 3 skills at activation (post-mortem, reflect, scrutinize); 2 remain flagged post-edit (post-mortem, reflect) because this ADR's `/scrutinize` edit added the reason-markers Check 26 was looking for. | Forward guardrail — extending the ADR-014 Check 25 precedent (description rubric) to imperative-with-reason hygiene. If no friction signal accumulates by 2026-11-23, consider reverting Check 26 + the targeted skill edits via a separate amendment (see §"Forward-Guardrail Sunset" — this ADR's own inline mechanism, **not** ADR-016 eviction). |

The 8-habit-reviewer specifically tested whether this brief was using friction-first doctrine as work-avoidance (H8/Spirit challenge). It was, before the revision. The revision promotes P3 to Tier 1 to match the precedent set by ADR-014's 4 shipped patterns, all of which had identical (zero) friction scores.

## Forward-Guardrail Sunset (inline mechanism owned by this ADR)

This ADR's **Tier 1 shipments** (Check 26 + the `/scrutinize` and `/diagnose` skill edits) carry a **review-checkpoint of 2026-11-23**. If no friction signal accumulates by that date, the maintainer should consider reverting them via a **separate amendment ADR** (not this one — ADRs are immutable record).

**This is NOT the ADR-016 eviction mechanism**. ADR-016's mechanism (and the cost-of-correction asymmetry gate it formalizes) is scoped strictly to **T2 bag candidates that were never shipped** — its eviction branch is literally "Evict, do not ship." Applying it to already-shipped features would un-ship them, a path ADR-016 does not define. The #215→#216 contraction of ADR-016 (4 amendments → 1) deliberately narrowed its scope; this ADR honors that narrowing rather than re-expanding it.

**Reversal criteria for this ADR's Tier 1 items** (any of the following at the checkpoint date):

- Zero documented uses of Check 26 catching a real soft-language regression in the 6 months since activation
- `/scrutinize` Operating Rules + `/diagnose` Phase 6 hardening have not been cited in any `/reflect` lesson or post-mortem as having helped
- A friction signal emerges that suggests the hardening actively hurts (e.g., users report the imperatives feel preachy without adding clarity)

**Non-reversal criteria** (any of the following = keep shipped):

- ≥1 documented case where Check 26 caught a soft-language drift in a new skill PR
- ≥1 case where the hardened `/diagnose` Phase 6 re-verify caught a "declared success prematurely" pattern
- The hardening proves additive (no friction reports) — keep as forward guardrail until next external-pattern audit re-evaluates

## T2 Bag — Deferred Adoptions (per ADR-016 drop-date eviction policy)

Added to the T2 inventory (current count 6 + 1 new = 7):

| Pattern                                                                      | Why deferred                                                                                                                                                    | Re-entry condition                                                                                                                                        | Drop date  |
| ---------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- |
| **P5 fix-verify extension** to `/diagnose`, `/scrutinize`, `/security-check` | `/review-ai` already shipped P5 (#155). Extension to non-review skills needs n=1 friction citation — those skills are too divergent to mechanize as text edits. | A `/reflect` lesson or post-mortem documenting a case where one of those 3 skills declared success and a downstream issue later proved the verdict wrong. | 2026-11-23 |

P5 **runtime enforcement** (a PostToolUse hook that gates declarations of success without re-verify) belongs in `claude-governance` per plugin boundary — companion issue filed there (link in #218).

## Out-of-Scope — Rejected (per ADR-014 P4-lite OOS catalog)

| Pattern                                                     | Why rejected                                                                                                                                                                                                                                                                                                                                                                       | Re-entry condition                                                                                                                                                                                                                                                             |
| ----------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **P4 embedded scripts** (e.g., `pptx/scripts/thumbnail.py`) | Conflicts with plugin charter: "Skills are read-only guidance — they tell Claude how to approach a task, they do not modify files themselves." (`CLAUDE.md` §"Architecture"). Adopting would require a charter amendment via new ADR arguing the H7 "Sharpen the Saw" repeatable-script benefit > the "guidance-only" simplicity. No friction signal motivates that amendment now. | An H7 friction case where a skill repeatedly re-implements the same script logic across invocations and the absence of scripts/ provably wastes user tokens or causes script drift. File `docs/out-of-scope/anthropic-pattern-4-scripts.md` preserves the rejection rationale. |

## Constraints Honored

- **C1 (Zero-dep invariant)**: Check 26 is pure bash, no new dependencies.
- **C2 (Sweep-first ordering)**: Check 26 is warning-only at activation. 3 skills flagged at activation snapshot (post-mortem, reflect, scrutinize); `/scrutinize` was flagged then resolved by this ADR's Operating Rules edit (added MUST/NEVER + Why reason-markers Check 26 was looking for). **2 remain flagged post-edit** (post-mortem, reflect) as informational warnings — documented rather than silently fixed; their register is intentionally discretion-heavy (retrospective and reflection skills), and no friction signal motivates hardening them now.
- **C3 (Charter integrity)**: P4 rejection preserves the read-only-guidance principle.
- **C4 (Plugin boundary)**: P5 runtime half filed in `claude-governance`, not implemented here.
- **C5 (Version-bump rule from ADR-016)**: ADR-016 §C5 forbids version bumps for **doctrine-only** commits. This ADR + the OOS file alone would have been doctrine-only and warranted no bump. However, PR #219 also shipped **user-facing skill edits** (`/scrutinize` Operating Rules + `/diagnose` Phase 6) which marketplace clients need to pull — making C5 inapplicable. v2.18.1 was therefore released as a patch bump (PR #220), correctly distinguishing this from the doctrine-only ship that ADR-016 itself was (no bump after PR #217). Check 4 in `tests/validate-structure.sh` enforces atomic version-sync across 4 files when plugin.json bumps.

## Citation Precision Caveat (recorded for future readers)

The Thai blog post that triggered this audit cites Anthropic skills under a `document-skills/` URL prefix and at specific pptx line numbers (137, 143, 145, 203). Both are wrong:

- **URL prefix**: actual path is `skills/pdf/SKILL.md` (no `document-skills/` dir). Blog's exact URLs 404.
- **pptx line numbers**: actual positions are ~195-196, ~204, ~206, ~243 — off by 40-61 lines (likely an older commit).

The quoted text is verbatim correct in all 7 citations. The substance of the 5-pattern claim is accurate; the citation precision is not. Future readers chasing the blog's URLs/lines should adjust.

## Self-Check

- [x] Source brief preserved at `~/.claude/plans/research-briefs/2026-05-24-anthropic-skill-patterns-audit.md`
- [x] 8-habit-reviewer cross-verify report integrated (H5 reconciliation paragraph in brief)
- [x] Check 26 added to `tests/validate-structure.sh` — warning-only, runs in suite
- [x] OOS file `docs/out-of-scope/anthropic-pattern-4-scripts.md` created
- [x] Companion issue in `pitimon/claude-governance` filed for P5 runtime hook
- [x] Targeted skill edits on `/scrutinize` and `/diagnose` (Phase 6 re-verify) demonstrate the pattern; not a full sweep
- [x] Forward-guardrail review-checkpoint 2026-11-23 set for Tier 1 shipments (inline mechanism, see §"Forward-Guardrail Sunset")
- [x] ADR-016 eviction mechanism applied **only** to the P5 T2 entry (its in-scope use), not to shipped items

## Consequences

**Positive**:

- Check 26 catches regression silently — new soft-language SKILL.md gets a warning at validator time without blocking the build
- Pattern 3 ships as a forward guardrail consistent with the ADR-014 precedent — no selective strictness
- OOS catalog preserves the P4 rejection rationale for future contributors
- Companion issue in `pitimon/claude-governance` is the cross-plugin H6 deposit the reviewer flagged

**Negative / Honest disclosure**:

- Check 26 is warning-only; aggregate skill-language hygiene depends on maintainer reading the warnings, not on CI enforcement
- P5 T2 entry adds 1 to the ADR-016 eviction inventory (now 7 total) — ADR-016 review checkpoint at 12 months may need to re-tier if drop dates pile up
- The P3 forward guardrail relies on the same speculative uplift framing as ADR-014's 4 patterns — if those patterns prove decorative, this ADR's adoption may need re-evaluation at the 2026-11-23 review-checkpoint per §"Forward-Guardrail Sunset" (separate amendment ADR required for reversal — ADR-016 eviction does not apply to shipped items)
