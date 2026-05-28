# ADR-021: Dynamic Workflow Positioning — Discipline Here, Engine in Governance

**Status**: Accepted
**Date**: 2026-05-29
**Decision makers**: Pitimon (human) + Claude Opus 4.8 (AI, 1M context)
**Related**: [ADR-005](./ADR-005-eu-ai-act-compliance-toolkit.md) (Three Loops table + Article 14 design-time checkpoint), [ADR-006](./ADR-006-audience-honesty-and-superpowers-deferral.md) (guidance-over-enforcement precedent), [ADR-012](./ADR-012-eu-ai-act-migration-completion.md) (Article 14 logic moved to claude-governance), [ADR-014](./ADR-014-external-prior-art-audit.md) (forward-guardrail tier framework), [ADR-017](./ADR-017-anthropic-skill-patterns-audit.md) (Forward-Guardrail Sunset mechanism), [ADR-019](./ADR-019-doctrine-only-scope-refinement.md) (consumer-doctrine version-bump rule), [ADR-020](./ADR-020-skill-authoring-guide.md) (prior guide forward-guardrail)
**Issue**: [#241](https://github.com/pitimon/8-habit-ai-dev/issues/241)
**Source**: Repo audit 2026-05-29 — 4-probe parallel scan (skills/`/workflow`, autonomy ADRs, plugin boundary, habit rules) via the Opus 4.8 Workflow engine, cross-verified against CLAUDE.md boundary rule

---

## Context

Opus 4.8 introduces a **dynamic workflow** capability: a deterministic multi-agent orchestration _engine_ — JavaScript scripts that spawn `parallel()` / `pipeline()` sub-agents and coordinate them autonomously. This collides with `8-habit-ai-dev` on two axes:

- **Name**: the plugin already ships a `/workflow` skill. A user typing "workflow" cannot tell from the word alone whether they mean the plugin's discipline or the harness engine. (This very session's SessionStart reminder auto-triggered the engine on a question that was analytical, demonstrating the ambiguity.)
- **Philosophy**: the plugin's `/workflow` is a **human-gated discipline** — `skills/workflow/SKILL.md:38-42` gates every step on Announce → **Ask** → record. The engine is **autonomous execution**. Different layers, opposite default postures.

A 4-probe audit established the facts:

| Probe           | Finding                                                                                                                                                               |
| --------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `/workflow`     | Discipline, not engine: every transition human-gated; core skills are read-only generators (`research` no Write; `design`/`breakdown` Write only under `--persist`).  |
| Autonomy ADRs   | Every autonomy-touching ADR (005/006/008/012/015/018) re-affirms **guidance, not gate**; enforcement lives in `claude-governance`. Article 14 oversight preserved.    |
| Plugin boundary | CLAUDE.md rule of thumb assigns runtime/decision-authorization to `claude-governance`; only the decompose-for-parallel discipline is `8-habit-ai-dev`'s.              |
| Habits          | H6 Synergize **reinforces** fan-out; H1/H3/H5/H8 are in **tension** with autonomous fan-out (trace-all-callers, one-thing-at-a-time, read-before-write, own-the-why). |

## Boundary Verdict (load-bearing — quoted so this ADR does not over-claim)

From `CLAUDE.md` § Plugin Boundary:

> **Rule of thumb**: workflow step or discipline practice → here. Runtime hook, compliance framework mapping, enforcement gate, or formal decision-authorization model → `claude-governance`.

The dynamic workflow **engine** (runtime coordination + which agent is authorized to spawn what) is a runtime + decision-authorization mechanism → it is **`claude-governance`'s domain, not ours**. The only sliver that is `8-habit-ai-dev`'s is the **discipline of deciding when fan-out serves the work** — which `/breakdown` and `guides/orchestration-patterns.md` already partly cover. `8-habit-ai-dev` does **not** own, ship, or wrap the engine.

## Options Considered

### Option A — New standalone guide `guides/dynamic-workflow-discipline.md`

- **Description**: Fresh guide for the fan-out discipline, cross-referencing `orchestration-patterns.md` for the "how".
- **Pro**: Clean topical file.
- **Con**: Splits multi-agent orchestration discipline across two guides. A reader asking "should I fan out here?" must know to check both — the exact fragmentation the "don't duplicate" instinct (CLAUDE.md § Plugin Boundary) warns against. Same scope-creep shape the 8-habit-reviewer flagged in the ADR-020 arc.

### Option B — Extend `orchestration-patterns.md` with Pattern 4 + this ADR (chosen)

- **Description**: Add **Pattern 4: Fan-Out Discipline** (habit-keyed when/when-not decision + Article 14 oversight-under-fan-out checklist + Quick Reference row) to the existing orchestration guide; this ADR owns the disambiguation and boundary positioning. Pattern 4 delegates the _how_ to existing Patterns 1-3 (worktree isolation, context boundaries) — no duplication.
- **Pro**: One home for orchestration discipline. ADR carries the positioning prose (its proper container, not guide body). Honors ADR-019 consumer-doctrine bump. Reuses ADR-017 sunset mechanism.
- **Con**: ~1 hour. Adds one row to the active forward-guardrail sunset surface.

### Option C — Document nothing; rely on the boundary being implicit

- **Description**: Acknowledge the layering verbally, ship no artifact.
- **Con**: The naming collision is real and recurring (this session demonstrated it). No discoverable record of _why_ the engine is not ours invites a future contributor to wrongly build engine-wrapping skills into `8-habit-ai-dev`, violating the boundary.

**Selected: Option B** — single discipline home, ADR as the positioning record, consistent with the ADR-014/017/020 forward-guardrail precedent.

## Decision — Shipments

| Item                                                 | Status   | Mechanism                                                                                                                                  |
| ---------------------------------------------------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| `guides/orchestration-patterns.md` Pattern 4         | **Ship** | Fan-out decision (H6 reinforce vs H1/H3/H5/H8 tension) + Article 14 oversight checklist + Quick Ref row                                    |
| `docs/adr/ADR-021-dynamic-workflow-positioning.md`   | **Ship** | This ADR — disambiguation + boundary verdict (engine = governance's, discipline = here)                                                    |
| Version bump v2.18.6 → v2.18.7                       | **Ship** | Consumer-doctrine patch bump per [ADR-019](./ADR-019-doctrine-only-scope-refinement.md) (`guides/` edit MUST bump); 4-file atomic, Check 4 |
| README "What's New" + CHANGELOG + SELF-CHECK + tally | **Ship** | Check 19 version mention; CHANGELOG entry; SELF-CHECK scorecard; SKILL-EFFECTIVENESS tally refresh (ADR-018)                               |

## Honest Framing — Forward Guardrail, Zero Friction Signal

Per the [ADR-014](./ADR-014-external-prior-art-audit.md)/[ADR-017](./ADR-017-anthropic-skill-patterns-audit.md)/[ADR-020](./ADR-020-skill-authoring-guide.md) pattern, this ships with **no first-person friction signal** at decision time:

| Shipment            | Pre-shipment friction signal                                                                                                                            | Post-shipment intent                                                                                                                  |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| Pattern 4 + ADR-021 | None first-person. The collision is structural (new Opus 4.8 capability + same word as `/workflow`), surfaced by audit, not yet by a `/reflect` lesson. | Forward guardrail. If by 2026-11-24 no lesson/PR cites it and no contributor was steered by it, evaluate reversion via amendment ADR. |

## Forward-Guardrail Sunset (inline mechanism, [ADR-017](./ADR-017-anthropic-skill-patterns-audit.md) §"Forward-Guardrail Sunset" applied)

Review-checkpoint **2026-11-24** (shared with ADR-017/018/019/020). Reversal (separate amendment ADR — ADRs are immutable record):

- Zero `/reflect` lessons cite Pattern 4 or this ADR, **AND** zero contributor PRs reference them, **AND** no skill or workflow script since activation invoked the fan-out gate.

Non-reversal (any one = keep):

- ≥1 `/reflect` lesson cites the fan-out gate as having prevented an inappropriate fan-out, **OR** ≥1 contributor PR references it, **OR** a dynamic-workflow script ships with the Article 14 oversight checklist applied.

Not [ADR-016](./ADR-016-t2-bag-drop-date-eviction-policy.md) eviction (which scopes only to never-shipped T2 items).

## Constraints Honored

- **C1 (Zero-dep invariant)**: Pattern 4 + ADR are pure markdown; no new dependencies.
- **C2 (Charter integrity)**: Content is read-only reference per CLAUDE.md § Architecture; the engine is _referenced_, never wrapped or shipped — preserving guidance-only.
- **C3 (Plugin boundary)**: The boundary verdict is the whole point — engine → `claude-governance`; only fan-out _discipline_ lands here. No PreToolUse/PostToolUse hook added. The Article 14 oversight reference in Pattern 4 is the _principle_ only (a discipline cue); the compliance checklist + enforcement stay in `claude-governance` `eu-ai-act-check/` per [ADR-012](./ADR-012-eu-ai-act-migration-completion.md) — Pattern 4 says so inline.
- **C4 (Version-bump rule per [ADR-019](./ADR-019-doctrine-only-scope-refinement.md))**: `guides/` edit triggers consumer-doctrine bump → v2.18.6 → v2.18.7 atomic across 4 files (`plugin.json`, `marketplace.json`, `README.md`, `SELF-CHECK.md`); Check 4 enforces.
- **C5 (ADR-018 anti-dormancy)**: SKILL-EFFECTIVENESS.md tally refreshed for this release per `CONTRIBUTING.md` §"Release Checklist".

## Self-Check

- [x] Boundary verdict quoted verbatim from CLAUDE.md so the ADR does not claim the engine
- [x] Pattern 4 delegates "how" to existing Patterns 1-3 (no duplication) + adds Quick Reference row
- [x] Article 14 oversight (Understand / Override / Stop) checklist included for fan-out — labelled as the oversight **principle** (discipline cue), explicitly **not** the compliance obligation; Pattern 4 points to `claude-governance` `eu-ai-act-check/` for the checklist + enforcement, acknowledging the [ADR-012](./ADR-012-eu-ai-act-migration-completion.md) migration so the label does not read as a boundary regression (both reviewers flagged this; resolved before PR)
- [x] Forward-guardrail framing honest (zero friction signal) with 2026-11-24 sunset + reversal criterion
- [x] Version bump v2.18.6 → v2.18.7 atomic per Check 4
- [x] SKILL-EFFECTIVENESS.md tally refreshed per ADR-018 forcing function

## Consequences

**Positive**:

- A discoverable record of _why_ the dynamic-workflow engine is not `8-habit-ai-dev`'s — prevents future engine-wrapping skills from violating the boundary.
- Turns a habit-tension risk (autonomous fan-out vs H1/H3/H5/H8) into an actionable gate, keeping the plugin's value (discipline) relevant in an autonomous-orchestration world.
- Keeps orchestration discipline in one guide (no fragmentation).

**Negative / Honest disclosure**:

- Adds 1 to the active forward-guardrail sunset queue (ADR-017/018/019/020 share the 2026-11-24 review surface).
- If the engine's naming or boundary changes upstream, Pattern 4's framing may need an amendment.
- Ships with zero friction signal; the sunset criterion is what measures whether it earned its place.
