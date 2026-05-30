# ADR-022: Spec-Driven Development Positioning — Discipline, Not Codegen Tooling

**Status**: Accepted
**Date**: 2026-05-30
**Decision makers**: Pitimon (human) + Claude Opus 4.8 (AI, 1M context)
**Related**: [ADR-006](./ADR-006-audience-honesty-and-superpowers-deferral.md) (guidance-over-enforcement precedent), [ADR-013](./ADR-013-spec-persistence-opt-in.md) (spec-kit-aligned artifact names), [ADR-014](./ADR-014-external-prior-art-audit.md) (external prior-art honesty + forward-guardrail tier), [ADR-017](./ADR-017-anthropic-skill-patterns-audit.md) (Forward-Guardrail Sunset mechanism), [ADR-019](./ADR-019-doctrine-only-scope-refinement.md) (consumer- vs contributor-doctrine), [ADR-021](./ADR-021-dynamic-workflow-positioning.md) (discipline-here / engine-in-governance — the sibling axis)
**Issue**: [#248](https://github.com/pitimon/8-habit-ai-dev/issues/248)
**Source**: `/research` brief 2026-05-30 (Deep mode) — verified the vibe-coding → Spec-Driven Development → governance landscape against primary sources, then ran an `8-habit-reviewer` cross-verify on the first positioning attempt (which proposed a comparison table in `docs/INTEGRATION.md`). PR [#247](https://github.com/pitimon/8-habit-ai-dev/pull/247) shipped the consumer-facing one-paragraph version; this ADR is the durable decision record behind it.

---

## Context

Spec-Driven Development (SDD) became a named industry movement in 2025–26. The landscape facts below are **as of this ADR's date (2026-05-30)** and are not maintained — the durable decision is the boundary verdict, not the tool list. The timeline, verified from primary sources during the research brief:

- **"Vibe coding"** — coined by Andrej Karpathy, 2 Feb 2025; Collins English Dictionary Word of the Year 2025. Definition: describe intent, accept AI-generated code, iterate on results without reading the diff.
- **Spec-Driven Development** — the reaction: specifications become the source of truth and code is generated from them. GitHub's blog post "Spec-driven development with AI" (Den Delimarsky, 2 Sep 2025) framed it explicitly against vibe coding ("great for quick prototypes, but less reliable when building serious, mission-critical applications").
- **Tooling** — GitHub **spec-kit** (OSS, workflow `Constitution → Specify → Plan → Tasks → Implement`, 30+ agent integrations), AWS **Kiro** (agentic IDE, EARS-notation specs), **Tessl** (framework + spec registry). Martin Fowler's "Kiro, spec-kit, and Tessl" treats the three as the reference set.
- **Governance** — Microsoft pushes AI-agent governance via Copilot Studio (DLP, Purview audit, Sentinel, Agent 365 control plane — verified on learn.microsoft.com). Gartner: ">40% of agentic AI projects will be canceled by end of 2027" (PR 2025-06-25) and "applying uniform governance across AI agents will lead to enterprise AI agent failure" (PR 2026-05-26).

This movement maps almost 1:1 onto `8-habit-ai-dev`'s reason for existing (`CLAUDE.md`: "replace 'vibe coding' with structured AI-assisted development"). That closeness is a **positioning hazard**: it is tempting to claim the plugin _is_ an SDD tool, or the "AI-Native SDLC" (Requirement Agent → BA → Solution → Dev → QA → Deploy) the source article envisions. It is neither. Without a durable record of what the plugin **is not**, a future contributor could build codegen or agent-orchestration features into it, violating the charter and the plugin boundary.

This ADR is the sibling of [ADR-021](./ADR-021-dynamic-workflow-positioning.md):

- **ADR-021** answers: discipline here, **engine** (multi-agent orchestration) in `claude-governance`.
- **ADR-022** answers: discipline here, **codegen tooling** (spec→code) is the external SDD tools' domain — not ours.

## Boundary Verdict (load-bearing — quoted so this ADR does not over-claim)

From `CLAUDE.md` § Plugin Boundary:

> **Rule of thumb**: workflow step or discipline practice → here. Runtime hook, compliance framework mapping, enforcement gate, or formal decision-authorization model → `claude-governance`.

Applied to SDD: the **discipline of producing a good spec before code** (the H5/H2 habits — understand first, begin with the end in mind) is `8-habit-ai-dev`'s domain. The **mechanism that turns a spec into code** (spec-kit, Kiro, Tessl) is external-tool domain. The **enforcement of the spec as a gate** is `claude-governance`'s domain. `8-habit-ai-dev` is **tool-agnostic discipline** — it helps a team produce a better spec for _any_ of those tools, or none.

Honest one-line claim: **8-habit supplies the spec-first _discipline_ half of SDD; the codegen half is external tooling and the enforcement half is the companion stack.**

What this plugin does **not** do, and must not start doing under SDD framing:

- It does **not** generate code, scaffolds, or artifacts from a spec (that is spec-kit/Kiro/Tessl).
- It does **not** ship a Requirement/BA/QA/Deploy _agent pipeline_ (that is the dynamic-workflow engine — ADR-021, → `claude-governance`).
- It does **not** enforce the spec as a runtime gate (that is `claude-governance`).
- Its skills (`/research`, `/requirements`, `/design`, `/breakdown`) are read-only guidance generators; `/design` and `/breakdown` only Write under explicit `--persist` ([ADR-013](./ADR-013-spec-persistence-opt-in.md)).

## Options Considered

### Option A — Comparison table in `docs/INTEGRATION.md` (rejected)

- **Description**: Add a "Where we fit" section + 6-row table (spec-kit / Kiro / Tessl / 8-habit / claude-governance / devsecops) to the integration guide.
- **Con**: `INTEGRATION.md` is the SSOT scoped to _companion-plugin composition_ — two external repos link to it under that contract. Injecting external/competing tools violates that scope. The 6-row table also imports live-product facts (star counts, workflow step-names) with no version anchor — the exact staleness the repo already shows (`guides/ears-notation.md` cites spec-kit at 84.7K stars; the 2026-05 research found ~107K). An `8-habit-reviewer` cross-verify flagged this as CRITICAL (wrong target) + HIGH (gold-plating + staleness).

### Option B — One README paragraph + this ADR (chosen)

- **Description**: A single paragraph in `README.md` § Design Principle (shipped in PR #247), mirroring the existing Garry Tan / gbrain external-positioning pattern; this ADR carries the durable decision and boundary verdict; an optional Thai blog carries the long-form argument.
- **Pro**: README paragraph is the consumer-facing claim (one sentence, no table, no stats → staleness-safe). ADR is the proper container for positioning prose (precedent: ADR-021). `INTEGRATION.md` untouched — SSOT scope preserved. `docs/**` is contributor-doctrine ([ADR-019](./ADR-019-doctrine-only-scope-refinement.md)) → no version-bump churn.
- **Con**: Positioning lives in three places (README para, ADR, blog); mitigated by the ADR being the single source the others point to.

### Option C — Document nothing; rely on README only (rejected)

- **Con**: The README paragraph states the claim but not the _why_. Without a decision record, a future contributor sees "SDD" in the README and could reasonably propose codegen or agent-pipeline features. The recurring boundary-confusion pattern (ADR-021 §Context documents the same shape for the engine) argues for a durable record.

**Selected: Option B** — README paragraph (consumer) + ADR (durable record) + optional Thai blog (long-form), consistent with the ADR-021 positioning-record precedent.

## Decision — Shipments

| Item                                                      | Status                | Mechanism                                                                                                                       |
| --------------------------------------------------------- | --------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| `README.md` § Design Principle paragraph                  | **Shipped** (PR #247) | Consumer-facing one-paragraph claim; mirrors Garry Tan / gbrain pattern; no table, no stats                                     |
| `docs/adr/ADR-022-spec-driven-development-positioning.md` | **Ship** (this ADR)   | Durable record — discipline vs codegen-tooling vs enforcement; boundary verdict quoted                                          |
| `docs/blog/*` Thai long-form                              | **Ship** (this PR)    | House-style thought-leadership; verified sources; honest plugin framing                                                         |
| Version bump                                              | **None**              | `docs/**` = contributor-doctrine ([ADR-019](./ADR-019-doctrine-only-scope-refinement.md)); Check 27 does not fire; no CHANGELOG |

## Honest Framing — Forward Guardrail, Real Friction Signal

Unlike ADR-021 (zero first-person friction signal), this ADR ships **with** a friction signal: the first positioning attempt this session actually misfired — it proposed the `INTEGRATION.md` table and an `8-habit-reviewer` pass caught the scope violation before merge. The ADR records that near-miss so the discipline-vs-tooling line is not re-crossed.

## Forward-Guardrail Sunset ([ADR-017](./ADR-017-anthropic-skill-patterns-audit.md) §"Forward-Guardrail Sunset" applied)

Review-checkpoint **2026-11-24** (shared with ADR-017/018/019/020/021).

Reversal (separate amendment ADR — ADRs are immutable record): zero `/reflect` lessons or contributor PRs cite this ADR **AND** no contributor was steered by it **AND** no SDD-framed feature proposal was redirected by it.

Non-reversal (any one = keep): ≥1 PR/issue cites it to reject a codegen/agent-pipeline feature **OR** ≥1 `/reflect` lesson references the discipline-vs-tooling line **OR** the Thai blog drives measurable inbound (the positioning earned its place).

## Constraints Honored

- **C1 (Zero-dep invariant)**: ADR + blog are pure markdown; no new dependencies.
- **C2 (Charter integrity)**: Content is read-only reference per `CLAUDE.md` § Architecture; external tools are _referenced_, never wrapped — preserving guidance-only.
- **C3 (Plugin boundary)**: The boundary verdict is the point — codegen → external tools; enforcement → `claude-governance`; only spec-first _discipline_ lands here. No hook added.
- **C4 (Version-bump rule per [ADR-019](./ADR-019-doctrine-only-scope-refinement.md))**: `docs/adr/**` and `docs/blog/**` are contributor-doctrine → no bump, no CHANGELOG; Check 27 confirms.
- **C5 (External-claim honesty per [ADR-014](./ADR-014-external-prior-art-audit.md))**: every external fact in this ADR was verified against a primary source during the research brief; stats are quoted precisely (Gartner "projects canceled," not "agents demoted"); no star counts inlined (staleness-safe).

## Self-Check

- [x] Boundary verdict quoted verbatim from `CLAUDE.md` so the ADR does not claim codegen or the agent pipeline
- [x] Positioned as the sibling of ADR-021 (engine axis) on a distinct axis (tooling axis) — no duplication
- [x] External facts traced to primary sources; Gartner quoted precisely; no inlined star counts
- [x] `INTEGRATION.md` left untouched — SSOT scope preserved (the rejected Option A)
- [x] No version bump — `docs/**` contributor-doctrine per ADR-019; Check 27 non-firing
- [x] Forward-guardrail framing honest (real friction signal: the INTEGRATION.md near-miss) with 2026-11-24 sunset

## Consequences

**Positive**:

- A discoverable record of _why_ 8-habit is not an SDD codegen tool or an AI-Native-SDLC agent pipeline — prevents future scope-violating features.
- Completes the positioning pair: ADR-021 (not an engine) + ADR-022 (not codegen tooling) fully bound what the plugin is by stating what it is not.
- Gives the Thai blog and README paragraph a single citable source of truth.

**Negative / Honest disclosure**:

- Adds 1 to the active forward-guardrail sunset queue (shares the 2026-11-24 review surface).
- The SDD landscape moves fast; if spec-kit/Kiro/Tessl converge or a new dominant tool appears, the Context section's tool list may need an amendment ADR (the boundary verdict itself is tool-agnostic and should survive).
