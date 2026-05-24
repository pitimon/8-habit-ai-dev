# ADR-018: Memory-Layer Activation — Close the Skill-Effectiveness Feedback Loop

**Status**: Accepted
**Date**: 2026-05-24
**Decision makers**: Pitimon (human) + Claude Opus 4.7 (AI, 1M context)
**Related**: [ADR-008 User Maturity Calibration](./ADR-008-user-maturity-calibration-design.md), [ADR-014 External Prior-Art Audit](./ADR-014-external-prior-art-audit.md), [ADR-016 T2 Bag Drop-Date](./ADR-016-t2-bag-drop-date-eviction-policy.md), [ADR-017 Anthropic Skills 5-Pattern Audit](./ADR-017-anthropic-skill-patterns-audit.md)
**External source audited**: NotebookLM notebook "Agent Harness Engineering 202605" (48 sources, ETCLOVG framework, AHE paper _Observability-Driven Automatic Evolution of Coding-Agent Harnesses_)
**Audit method**: 5 systematic NotebookLM queries + advisor review + repo audit against ETCLOVG seven-layer prescription

---

## Context

A 2026-05-24 audit of the external "Agent Harness Engineering" corpus against `8-habit-ai-dev`'s current primitives revealed one dominant finding:

> **The memory-layer feedback loop is built but dormant.** `~/.claude/lessons/` has 42 files (39 with `## Skill effectiveness` Q6 signals captured), yet `SKILL-EFFECTIVENESS.md` shows `Lessons analyzed: 0` — last updated 2026-04-11 when the ship-with-zero-data scaffolding was committed.

Two AHE benchmark findings sharpened the priority:

1. **Component transferability ranking** (AHE paper, Terminal-Bench 2 ablation): Memory (75.3%) > Tools (73.0%) > Middleware (71.9%) > **System Prompt alone regresses to 67.4%**. Prose-level rules don't transfer across tasks/models; structural memory does.
2. **"Harness Assumptions Expire"**: every rule in a static config was written for a model snapshot. Without a feedback signal that "this rule no longer fires usefully," prose rules become dead weight when models improve (e.g., Sonnet 4.5 → Opus 4.7).

Currently most of the project's discipline weight sits in **prompt-level** rules (CLAUDE.md 140 lines, rules/effective-development.md ~200 lines). The memory layer is healthy structurally (INDEX, consolidation >10 trigger, tags, frontmatter) but the loop that would let it inform skill evolution is open.

A secondary finding: **"Earn each line"** prescription from the corpus (rules must come from past failures, not speculation, with ≤60 line target for AGENTS.md-class files) holds for `AGENTS.md` (38 lines ✓) but not for `CLAUDE.md` (140 lines, several rules with no traceable lesson).

## Tier Framework Applied (from ADR-014)

| Tier   | Criterion                                                                     | Action                                       |
| ------ | ----------------------------------------------------------------------------- | -------------------------------------------- |
| **T1** | Real gap + fits read-only skill rule + fits plugin boundary + clear habit map | **Ship** in this release                     |
| **T2** | Plausible value but needs evidence or non-trivial change                      | **Defer** with ADR-016 drop date             |
| **T3** | Conflicts with existing architectural principle, redundant, or no fit         | **Reject**, document in `docs/out-of-scope/` |

## Options Considered

### Option A — Single-shot maintainer tally update only

- **Description**: Maintainer runs the existing protocol in `SKILL-EFFECTIVENESS.md` (grep Q6 across 39 lessons → update tally → note trends). No structural changes.
- **Pro**: Lowest risk, ~30 min. Uses infrastructure that already exists.
- **Con**: Likely to drift again — same dormancy condition (manual recurring task with no trigger).

### Option B — Activation + lightweight evolution gate (recommended)

- **Description**: One-time tally update (Option A) **plus** add three discipline edges:
  1. **Pre-ship contract field** in skill PR template (`predicted_uses` + `validation_window: 30 sessions`) — soft Falsifiable Contract, manual review only.
  2. **CLAUDE.md "Earn each line" audit pass** — every rule must cite a lesson file or memory obs ID; uncited rules move to a `proposed/` section pending evidence.
  3. **Recurring tally trigger** — note in next release checklist: "Run SKILL-EFFECTIVENESS protocol before bump."
- **Pro**: Closes the loop with low ceremony. Aligns weight from prompt-only → prompt+memory (the transferable component).
- **Con**: Adds three new lightweight obligations. Manual gates can be skipped under pressure.

### Option C — Build automated Falsifiable-Skill-Contract enforcement

- **Description**: Adopt the full AHE `change_manifest.json` model — every skill PR ships with predicted_fixes/risk_skills, automated validation after N sessions, auto-rollback PR opened on miss.
- **Pro**: Closest to AHE's published benchmark mechanism.
- **Con**: Belongs in `claude-governance` per plugin boundary (it's an enforcement gate). Heavy ceremony. No evidence yet that simpler Option B is insufficient.

## Decision

**Choose Option B.** Ship a three-edge memory-layer activation in this release:

1. **Update `SKILL-EFFECTIVENESS.md` tally** from 39 captured Q6 signals (one-time data harvest using the protocol already documented in that file §"Maintainer update protocol").

2. **Add `predicted_uses` + `validation_window` to skill PR template** at `.github/PULL_REQUEST_TEMPLATE.md` (or create if absent) — optional fields for skill-touching PRs. Existing PRs unaffected. No runtime enforcement.

3. **Audit `CLAUDE.md` for cited lessons**: each behavioral rule must reference either a lesson file (`~/.claude/lessons/YYYY-MM-DD-*.md`), an ADR, or a dated memory obs ID. Uncited rules move to a `## Proposed (awaiting evidence)` section. File reduction target: 140 → ≤80 lines main body (rest in `Proposed` until ratcheted in).

### Out of Scope (T3)

- **Automated rollback / runtime falsifiable contracts** (Option C) — plugin boundary: enforcement belongs in `claude-governance`. Revisit only if Option B fails to produce signal-driven skill changes within 2 release cycles.
- **Trajectory-level checks in `/review-ai`** — separate ADR if pursued. Listed as future improvement candidate but no commitment.
- **`/research` sub-agent context isolation** — corpus suggests it, current implementation reads inline. Separate evaluation needed (current isolation may be sufficient since `/research` is bounded by user-set scope).

### Deferred (T2) — drop date 2026-11-24

- **Cross-plugin tally aggregator** (scanning `~/.claude/lessons/` across users): runtime concern, belongs in `claude-governance`. Drop if no maintainer pain reported within 6 months.

## Consequences

### Habit Mapping

- **H7 (Sharpen the Saw)** — primary. Plugin reflects on itself using its own `/reflect` data.
- **H4 (Win-Win, deposit)** — completed lessons now contribute to skill evolution, not just user reflection.
- **H8 (Find Your Voice, Conscience)** — "Earn each line" enforced for CLAUDE.md aligns rules with conscience (each rule has a reason, not just inertia).

### What changes

- `SKILL-EFFECTIVENESS.md` gets first real data populated.
- PR template adds optional fields (no breaking change for non-skill PRs).
- `CLAUDE.md` shrinks; some rules move to `Proposed` until lesson evidence accumulates.

### What doesn't change

- No new hooks, no runtime code.
- No new skills.
- Plugin boundary with `claude-governance` preserved (no automated enforcement).
- No skills modified or removed in this ADR.

### Risks

- **Maintainer overhead** — three obligations may degrade to lip service. _Mitigation_: tally update tied to release checklist (forcing function); PR template fields optional; CLAUDE.md audit one-time + ongoing rule-by-rule.
- **False signal from low-data tally** — 39 lessons is small. _Mitigation_: tally notes explicitly mark `n` per skill; trends require n≥3 before action. Aligns with AHE's "Falsifiable Contracts" requirement that predictions be evaluable.
- **"Proposed" section in CLAUDE.md may collect cruft** — _Mitigation_: subject to ADR-016 6-month drop date (same eviction rule as T2 bag).

## Validation

### Shipped in this ADR's PR (Edge #1 ratified by data)

- [x] `SKILL-EFFECTIVENESS.md` shows `Lessons analyzed: 43` after tally update, with per-skill non-zero counts where Q6 cited that skill (`/cross-verify` 13, `/research` 5, `/breakdown` 2, `/design` 1/2 ⚠️, `/build-brief` 1/1, `/diagnose` 1, `/save-spec` 1).
- [x] At least one skill has `Trend notes` populated from real data (not "—") — 7 skills now have notes.

### Deferred to follow-up PRs (Edges #2, #3 — ADR records the decision, execution is separate work)

- [ ] PR template includes `predicted_uses` and `validation_window` fields documented as optional, with example. **Filed as issue** before merge.
- [ ] `CLAUDE.md` main body ≤ 80 lines (excluding `Proposed` section). **Filed as issue** before merge.
- [ ] Each rule in CLAUDE.md main body cites a lesson, ADR, or memory obs ID. **Filed as issue** before merge.
- [ ] Next release PR checklist includes "Run SKILL-EFFECTIVENESS tally update." **Filed as issue** before merge.

### PR completion checklist (this merge)

- [x] Lesson file dogfooded (`~/.claude/lessons/2026-05-24-notebook-agent-harness-audit-adr018.md` saved — Edge #1 hypothesis tested on live session before ADR ratification).
- [x] INDEX.md updated additively (43 lessons, 8-habit-ai-dev project section 10 → 11).
- [x] ADR Validation section marks Edge #1 as ratified by output (not just promised).
- [ ] Follow-up issues filed for Edges #2-3 + release-checklist note.
- [ ] CHANGELOG entry added if doctrine-only commits warrant it (per ADR-017 §C5 doctrine compliance rule).

## Forward-Guardrail Sunset (per ADR-017 convention)

This ADR's T1 shipments are subject to review by **2026-11-24**. Reversal criteria:

- No skill PRs have used the `predicted_uses` field in the validation window.
- `SKILL-EFFECTIVENESS.md` tally has not been updated for ≥2 release cycles after this ADR ships (re-entered dormancy).
- The `CLAUDE.md` `Proposed` section has not produced any rule migrations (neither ratcheted in nor dropped) within 6 months.

Non-reversal criteria (any one):

- ≥1 skill PR uses `predicted_uses` and the prediction is later cited in a `/reflect` lesson or post-mortem.
- Tally update happens in ≥2 releases following this ADR.
- ≥1 CLAUDE.md `Proposed` rule is ratcheted into the main body with cited lesson evidence (proof the discipline is doing real work).

External re-evaluation (any of: another corpus audit, an updated AHE-class paper, an upstream Claude Code primitive that subsumes this) overrides the local sunset.

---

**Audit conversation reference**: NotebookLM conversation `1c054201-206d-47c9-9186-8f759e637ed4` (8 turns), notebook id `0f90fcee-b566-4a0b-919a-3df1aa7443cb` "Agent Harness Engineering 202605", 48 sources.
