# ADR-014: External Prior-Art Audit — Adopting Four Patterns from mattpocock/skills

**Status**: Accepted
**Date**: 2026-05-20
**Decision makers**: Pitimon (human) + Claude Opus 4.7 (AI, 1M context)
**Related**: [ADR-006 Audience Honesty](./ADR-006-audience-honesty-and-superpowers-deferral.md), [ADR-007 agentskills NO-GO](./ADR-007-agentskills-compatibility-decision.md), [ADR-009 Skill Split Convention](./ADR-009-skill-split-convention.md), [ADR-012 EU AI Act Migration](./ADR-012-eu-ai-act-migration-completion.md), [ADR-013 Spec Persistence](./ADR-013-spec-persistence-opt-in.md)
**Source brief**: `~/.claude/plans/deep-https-github-com-mattpocock-skills-glimmering-prism.md` (Deep mode, 13/14 sources verified)
**Source spec chain**: `docs/specs/mattpocock-t1-v2-17-0/{prd,design,tasks}.md`
**External source audited**: <https://github.com/mattpocock/skills> (MIT, ~95.5k★, 14 published skills)

---

## Context

A 2026-05-20 Deep-mode research audit examined Matt Pocock's `mattpocock/skills` repo to identify patterns worth borrowing for `8-habit-ai-dev` v2.16.5. The audit identified 10 candidate patterns and tiered them by fit against our plugin's existing discipline + the boundary with `claude-governance`.

The audit also raised an **honest framing concern** (advisor critique, transcript-captured 2026-05-20): the original framing was "what novel patterns does mattpocock have?" rather than "what friction does 8-habit-ai-dev currently have?" None of the 4 ultimately-adopted patterns had a documented n≥1 friction signal in this codebase at decision time. This ADR records that limitation honestly so future contributors understand the patterns ship as **forward guardrails**, not as fixes for observed weakness.

## Tier Framework Applied

| Tier   | Criterion                                                                     | Action                                       |
| ------ | ----------------------------------------------------------------------------- | -------------------------------------------- |
| **T1** | Real gap + fits read-only skill rule + fits plugin boundary + clear habit map | **Ship** in this release                     |
| **T2** | Plausible value but needs evidence or non-trivial change                      | **Defer** to separate brief                  |
| **T3** | Conflicts with existing architectural principle, redundant, or no fit         | **Reject**, document in `docs/out-of-scope/` |

## Decision — 4 Adoptions (Tier 1)

| Pattern                                  | Source file in mattpocock/skills                                                               | Adopted as                                                                                                                                                                | Habit map |
| ---------------------------------------- | ---------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| **P1 AGENT-BRIEF template**              | `skills/engineering/triage/AGENT-BRIEF.md`                                                     | New `guides/templates/agent-brief-template.md` (habit-mapped variant adds H2/H8 sections, preserves behavioral-not-procedural rule); referenced from `/breakdown` Handoff | H2 + H4   |
| **P3 `disable-model-invocation: true`**  | `skills/engineering/zoom-out/SKILL.md`, `skills/engineering/setup-matt-pocock-skills/SKILL.md` | Applied to `/save-spec` and `/ai-dev-log` frontmatter; validator Check 24 validates well-formed boolean                                                                   | H1        |
| **P4-lite `docs/out-of-scope/` catalog** | `.out-of-scope/` directory (mattpocock root)                                                   | New `docs/out-of-scope/` with 3 seed entries (brainstorm-removed, agentskills-no-go, eu-ai-act-migrated); YAML frontmatter schema per Decision-2                          | H7        |
| **P5 description rubric**                | `skills/productivity/write-a-skill/SKILL.md` (description-as-system-prompt rigor)              | New validator Check 25: ≤1024 chars + trigger phrase from empirically-grounded set                                                                                        | H5        |

## Decision — 3 Rejections (Tier 3)

| Pattern                                | Why rejected                                                                                     | Constraint cited                                                               |
| -------------------------------------- | ------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------ |
| **P6 inline doc updates during skill** | `/grill-with-docs` writes CONTEXT.md/ADRs inline — conflicts with our read-only skill principle  | [ADR-009](./ADR-009-skill-split-convention.md) — skills are read-only guidance |
| **P7 CONTEXT.md / CONTEXT-MAP.md**     | Overlaps `/save-spec` §1 architecture pointer + `spec-digest-pattern.md`; risks governance drift | [ADR-013](./ADR-013-spec-persistence-opt-in.md) — spec persistence boundary    |
| **P9 lazy file creation**              | Already covered by `/save-spec` refusal-to-overwrite behavior                                    | (redundant — no constraint conflict)                                           |

## Decision — Deferred (Tier 2)

| Pattern                          | Why deferred                                                                                         | Future trigger                                                          |
| -------------------------------- | ---------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------- |
| **P2 LANGUAGE.md vocabulary**    | Worth doing eventually; needs sweep of every skill that uses "module"/"boundary"/"interface" loosely | Separate `/research` brief if maintainer chooses                        |
| **P8 two-axis review split**     | Would refactor flagship `/review-ai` skill; needs adopter evidence                                   | n≥2 adopter friction signal (per maturity ladder cited in source brief) |
| **P10 tracer-bullet vocabulary** | `/breakdown` already says "atomic"; marginal value                                                   | Re-evaluate at next `/breakdown` revision                               |

## Honest Framing — Forward Guardrail, Not Observed Fix

The advisor pattern review (transcript 2026-05-20) flagged that the original brief never asked "what friction do we currently have?" Each adopted pattern's grounding is recorded here so future contributors don't mistake them for fixes to observed issues:

| Pattern                         | Pre-shipment friction signal in 8-habit-ai-dev                                                                         | Post-shipment intent                                                                  |
| ------------------------------- | ---------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- |
| **P1 AGENT-BRIEF**              | None observed (no backlog-rotted issue cited)                                                                          | Forward template — recommended for future backlog-bound work via `/breakdown` Handoff |
| **P3 disable-model-invocation** | None observed (Claude Code not seen improvising on `/save-spec` / `/ai-dev-log`)                                       | Intent-marking; behavior currently decorative per #22345                              |
| **P4-lite OOS catalog**         | Mild — ADRs partially cover; out-of-scope rejections lacked a per-decision file format                                 | Active value as 3 seed entries preserve real rejection rationale                      |
| **P5 description rubric**       | None observed — empirical 2026-05-20 sweep found 0/19 drift; all 19 descriptions ≤487 chars with valid trigger phrases | Forward guardrail against regression                                                  |

This honest framing is the ADR's contribution. **Future contributors evaluating "should we add X" should require explicit friction citation, not just pattern attractiveness.**

## R1 Harness Behavior Observed (FR-001)

The `disable-model-invocation: true` field is documented at <https://code.claude.com/docs/en/skills>. Verification of its honor-status (2026-05-20):

- [anthropics/claude-code#22345](https://github.com/anthropics/claude-code/issues/22345) — **OPEN** since 2026-02-01 (last updated 2026-05-11). Plugin skills do NOT currently honor `disable-model-invocation` the way user skills do. **Effect**: declaring the field on `/save-spec` and `/ai-dev-log` is decorative until #22345 closes.
- [#26251](https://github.com/anthropics/claude-code/issues/26251) — **CLOSED** 2026-02-27. Slash-command-invocation regression resolved.
- [#43875](https://github.com/anthropics/claude-code/issues/43875) — **CLOSED** 2026-04-16. Session-hide regression resolved.

**Risk mitigation**: Declaring the field doesn't break anything (silently ignored for plugin skills). When #22345 closes, the declaration activates without code changes. ADR-014's transparency on this is the user-visible commitment.

## Constraints Honored

- **C1 (Zero-dep invariant)**: All validator changes (Check 24, Check 25) are pure bash. No Python, no `yq`, no npm.
- **C2 (Sweep-first ordering)**: P5 description audit completed before Check 25 activated — all 19 skills pass at activation time, ensuring no first-commit CI failure.
- **C3 (Version sync atomicity)**: v2.17.0 bumps `plugin.json`, `marketplace.json`, `README.md`, `SELF-CHECK.md` in the same commit (Check 4 enforces).
- **C4 (No skill-graph DAG changes)**: No skills added/removed; `prev-skill`/`next-skill` edges unchanged.
- **C5 (Hook untouched)**: `hooks/session-start.sh` not modified.

## Consequences

**Positive**:

- 4 patterns ship as forward guardrails without breaking existing discipline
- `docs/out-of-scope/` catalog is a new contribution surface for preserving rejection rationale
- AGENT-BRIEF template gives `/breakdown` a durable handoff option for backlog-bound work
- Validator now enforces description quality (≤1024 chars + trigger phrase) — prevents future regression

**Negative / Honest disclosure**:

- P3 (`disable-model-invocation`) is decoration-only today (decorative until anthropics/claude-code#22345 closes)
- 4 adoptions ship with no documented prior friction signal in this codebase — they're guardrails, not fixes. Future contributors must apply this lens to their own pattern proposals.
- The premise-inversion lesson (asked "what's cool elsewhere?" instead of "what hurts here?") is recorded but the v2.17.0 release does not retrofit a friction-first audit. Next external-pattern audit will start friction-first per this ADR's discipline.

## Options Considered

1. **Option D (file the brief, ship nothing)** — Advisor's preferred pivot. Rejected: maintainer explicitly chose to proceed via `/goal` directive. ADR-014 records the audit findings either way; shipping forward guardrails adds the validator + OOS catalog with low risk.
2. **R1-gate variant (verify harness honor first, drop FR-001 if not honored)** — Empirically: #22345 makes the field decorative for plugin skills. Decision: ship anyway with explicit transparency rather than drop; honest declaration documents intent.
3. **Ship all 10 patterns** — Rejected. T2 patterns lack evidence, T3 patterns conflict with existing principles. Discipline > completeness.

## Compliance with Plugin Boundary

This bundle stays in `8-habit-ai-dev` because it's **workflow discipline** (AGENT-BRIEF template, description rubric, deterministic-scaffolder flag, rejection catalog). None of the 4 adoptions touch enforcement hooks (PreToolUse/PostToolUse) or compliance framework mappings — those would belong in `claude-governance`. ADR-005 boundary analysis applies.

## Self-Check

- [ ] Source brief preserved at `~/.claude/plans/deep-https-github-com-mattpocock-skills-glimmering-prism.md`
- [ ] Spec chain preserved at `docs/specs/mattpocock-t1-v2-17-0/{prd,design,tasks}.md`
- [ ] 3 OOS seed entries reference their originating ADR
- [ ] Validator Check 24 + 25 pass on all 19 skills at activation
- [ ] R1 harness status documented with verifiable upstream issue links
- [ ] Honest framing — forward guardrails not observed fixes — recorded for future audits
