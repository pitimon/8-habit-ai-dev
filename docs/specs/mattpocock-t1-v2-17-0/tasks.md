---
feature: mattpocock-t1-v2-17-0
step: breakdown
created: 2026-05-20T09:45:00+00:00
updated: 2026-05-20T09:45:00+00:00
source-skill-version: 2.16.5
prd-reference: ./prd.md
design-reference: ./design.md
---

# Task Breakdown — External Prior-Art Bundle v2.17.0

## Scope Guard (H3)

All tasks below are Q2 (Important, not Urgent — prevents future drift). No Q3 polish, no Q4 gold-plating. Each task implements exactly one decision or one constraint from `design.md`.

## Task List

### Task #1 implements: Decision-1 prerequisite (constraint C2)

**P5 manual description sweep** — audit all `skills/*/SKILL.md` `description:` fields against the FR-003 rubric (≤1024 chars; contains one of `{Use when, Use AFTER, Use BEFORE, Use to, Use for}`). Patch any drift in-place.

- **Files**: `skills/*/SKILL.md` (read 19, expect to patch ~2-5)
- **Depends on**: none
- **Q-quadrant**: Q2
- **Why first**: Per constraint C2, sweep MUST precede FR-003 check activation in same PR. If validator turned on with drift present, first commit fails CI.

### Task #2 implements: Decision-5 (FR-001a)

**Add `disable-model-invocation: true` to `/save-spec` frontmatter.**

- **Files**: `skills/save-spec/SKILL.md` (1 file, 1 line addition)
- **Depends on**: #1 (avoid edit conflict on same file)
- **Q-quadrant**: Q2

### Task #3 implements: Decision-5 (FR-001b)

**Add `disable-model-invocation: true` to `/ai-dev-log` frontmatter.**

- **Files**: `skills/ai-dev-log/SKILL.md` (1 file, 1 line addition)
- **Depends on**: #1 (avoid edit conflict on same file)
- **Q-quadrant**: Q2

### Task #4 implements: Decision-3 (FR-005)

**Author `guides/templates/agent-brief-template.md`** — habit-mapped variant with H2/H8 sections, Hard Rules block, Pickup Checklist. ≤120 lines. Header credits `mattpocock/skills/triage/AGENT-BRIEF.md`.

- **Files**: `guides/templates/agent-brief-template.md` (new)
- **Depends on**: none
- **Q-quadrant**: Q2

### Task #5 implements: Decision-4 (FR-006 narrowed)

**Add AGENT-BRIEF reference to `/breakdown` Handoff section** — 1-line link to `guides/templates/agent-brief-template.md`, framed as always-recommended (ubiquitous).

- **Files**: `skills/breakdown/SKILL.md` (1 line addition in Handoff section)
- **Depends on**: #4 (template must exist)
- **Q-quadrant**: Q2

### Task #6 implements: Decision-2 (FR-004)

**Create `docs/out-of-scope/` + 3 seed entries** — `brainstorm-removed.md` (cites ADR-006), `agentskills-no-go.md` (cites ADR-007), `eu-ai-act-migrated.md` (cites ADR-012). Each ≤200 words. YAML frontmatter per Decision-2 schema. Each ends with "If reconsidering, read these conditions first:" + bullet list.

- **Files**: `docs/out-of-scope/{brainstorm-removed,agentskills-no-go,eu-ai-act-migrated}.md` (3 new files)
- **Depends on**: none
- **Q-quadrant**: Q2

### Task #7 implements: PRD in-scope item (CONTRIBUTING.md link)

**Update `CONTRIBUTING.md`** — add paragraph linking `docs/out-of-scope/` and explaining the ADR-vs-OOS verb distinction ("we DID decide X" vs "we deliberately WON'T do Y"). Risk R3 mitigation.

- **Files**: `CONTRIBUTING.md` (1 paragraph addition)
- **Depends on**: #6 (OOS dir must exist before linking)
- **Q-quadrant**: Q2

### Task #8 implements: Decision-1 (FR-002 + FR-003)

**Update `tests/validate-structure.sh`** — (a) extend `check_allowed_frontmatter_fields()` (or equivalent) to include `disable-model-invocation` as valid boolean key, (b) add new `check_description_rubric()` function: per-skill char count + trigger phrase regex. Both register as new checks in the main runner.

- **Files**: `tests/validate-structure.sh` (1 file, ~30-50 lines added)
- **Depends on**: #1 (sweep precedes activation per C2)
- **Q-quadrant**: Q2

### Task #9 implements: FR-007

**Author `docs/adr/ADR-014-external-prior-art-audit.md`** — canonical ADR template. Document (a) Tier 1/2/3 audit framework, (b) 4 adoptions habit-mapped (H1/H2/H4/H5/H7), (c) 3 rejections (P6/P7/P9) referencing ADR-009 + ADR-013, (d) cite research brief path. Include "Harness behavior observed" subsection for R1.

- **Files**: `docs/adr/ADR-014-external-prior-art-audit.md` (new)
- **Depends on**: none (can be written from PRD + design directly)
- **Q-quadrant**: Q2

### Task #10 implements: FR-008 trigger + C3 atomicity

**Version bump v2.16.5 → v2.17.0** across 4 files in a single commit: `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`, `README.md` (badge + footer), `SELF-CHECK.md` (header).

- **Files**: 4 (exactly the set Check 4 enforces)
- **Depends on**: #1-#9 (version bump is the last content change before validation)
- **Q-quadrant**: Q2

### Task #11 implements: PRD Success criterion #1 + #5

**Run all 4 validator suites locally + re-run `/cross-verify` on the v2.17.0 self-spec**. Must report ALL green: `validate-structure.sh`, `validate-content.sh`, `test-skill-graph.sh`, `test-verbosity-hook.sh`. SELF-CHECK ≥16/17 Pass.

- **Files**: none (read-only verification)
- **Depends on**: #10
- **Q-quadrant**: Q2
- **If red**: STOP. Diagnose, fix, return to whichever task introduced the regression. Do NOT push.

### Task #12 implements: Definition of Done

**Open PR with conventional-commits title** `feat: external prior-art bundle (v2.17.0)`. Body: link research brief, PRD, design, tasks, ADR-014. Include test plan referencing #11 outcomes.

- **Files**: GitHub PR (no working-tree files)
- **Depends on**: #11 (validators green)
- **Q-quadrant**: Q2

## Orchestration Classification

| Task | Type          | Isolation      | Depends On                         |
| ---- | ------------- | -------------- | ---------------------------------- |
| #1   | sequential    | same repo      | none                               |
| #2   | sequential    | same repo      | #1                                 |
| #3   | parallel-safe | same repo      | #1 (parallel with #2 once #1 done) |
| #4   | parallel-safe | same repo      | none                               |
| #5   | sequential    | same repo      | #4                                 |
| #6   | parallel-safe | same repo      | none                               |
| #7   | sequential    | same repo      | #6                                 |
| #8   | sequential    | same repo      | #1                                 |
| #9   | parallel-safe | same repo      | none                               |
| #10  | sequential    | same repo      | #1-#9 all                          |
| #11  | sequential    | n/a (run only) | #10                                |
| #12  | sequential    | n/a (PR API)   | #11                                |

## Execution Phases (Lazy Parallelism Gate applied)

**Phase 0 — sweep first** (sequential, blocker for #2/#3/#8):

- #1 P5 description sweep

**Phase 1 — independent authoring** (parallel-safe; do in parallel if 3+ tool calls each, else serial):

- #4 AGENT-BRIEF template
- #6 OOS dir + 3 seed entries
- #9 ADR-014

**Phase 2 — frontmatter + validator** (after #1):

- #2 + #3 (parallel-safe — different SKILL.md files)
- #8 validator (touches `tests/validate-structure.sh`; not co-edited with #2/#3)

**Phase 3 — sequential follow-ups**:

- #5 (after #4)
- #7 (after #6)

**Phase 4 — release prep** (strict serial):

- #10 version bump → #11 validators → #12 PR

### Parallel-batch decision per Lazy Parallelism Gate

Phase 1's 3 independent authoring tasks could be parallelized but each is small (1-3 tool calls to author the file). Sequential execution stays under the "5 tool calls" gate. **Default to sequential** unless wall-clock becomes a concern.

Phase 2's #2 + #3 are 1-line edits each. Sequential is trivially fast. **Default to sequential** for simplicity.

## Token-Efficient Parallel Design (step 5)

Not applicable — no batch reaches 3+ truly parallel agents. Shared-prefix optimization doesn't pay off below that threshold.

## Risk Reminders (from design.md)

- **R1 (harness behavior)**: ADR-014 (#9) MUST include "Harness behavior observed" subsection — initial state Unverified is acceptable, but the subsection must exist.
- **R2 (description false positives)**: Constraint C2 enforced by ordering: #1 sweep precedes #8 validator activation.
- **R3 (OOS vs ADR drift)**: Task #7 includes the verb-distinction paragraph in CONTRIBUTING.md.

## Coverage Check

| FR/Constraint                  | Implementing Task(s)         |
| ------------------------------ | ---------------------------- |
| FR-001                         | #2, #3                       |
| FR-002                         | #8                           |
| FR-003                         | #8 (gated by #1)             |
| FR-004                         | #6                           |
| FR-005                         | #4                           |
| FR-006                         | #5                           |
| FR-007                         | #9                           |
| FR-008                         | #10 (validated by #11)       |
| C1 (zero-dep)                  | #8 (verified by code review) |
| C2 (sweep-first)               | #1 → #8 ordering             |
| C3 (atomicity)                 | #10                          |
| C4 (no DAG)                    | (none; constraint, not task) |
| C5 (hook untouched)            | (none; constraint)           |
| Success criterion #1           | #11                          |
| Success criterion #2           | #6                           |
| Success criterion #3           | #9                           |
| Success criterion #4           | #10 (validated by #11)       |
| Success criterion #5           | #11                          |
| PRD CONTRIBUTING.md scope item | #7                           |

All 8 FRs + 5 success criteria + 3 risks covered. No orphan FR.

## Estimated Complexity

**Medium** — 12 tasks across ~14 distinct files (excluding the PR action). No architecture rewrites; mostly authoring (templates, ADR, OOS entries) + 1 validator extension + 1 version bump. Sequencing matters (Task #1 must precede #2/#3/#8) but no circular dependencies. Estimated effort: 1 focused session for a maintainer familiar with the codebase, ~2-3 hours including local validation and PR opening.

<!-- SKILL_OUTPUT:breakdown
task_count: 12
tasks:
  - "Task #1: P5 manual description sweep across 19 SKILL.md (precedes validator activation per C2)"
  - "Task #2: Add disable-model-invocation: true to /save-spec frontmatter (FR-001a)"
  - "Task #3: Add disable-model-invocation: true to /ai-dev-log frontmatter (FR-001b)"
  - "Task #4: Author guides/templates/agent-brief-template.md habit-mapped variant (FR-005)"
  - "Task #5: Add AGENT-BRIEF reference to /breakdown Handoff section (FR-006 narrowed)"
  - "Task #6: Create docs/out-of-scope/ + 3 seed entries (FR-004)"
  - "Task #7: Update CONTRIBUTING.md with OOS link + ADR-vs-OOS verb distinction (PRD scope item, R3 mitigation)"
  - "Task #8: Update validate-structure.sh — recognize disable-model-invocation + add description rubric check (FR-002, FR-003)"
  - "Task #9: Author ADR-014-external-prior-art-audit (FR-007, R1 documented)"
  - "Task #10: Version bump v2.16.5 -> v2.17.0 across 4 files (C3 atomicity, FR-008 trigger)"
  - "Task #11: Run 4 validator suites locally + cross-verify SELF-CHECK >=16/17 (Success criteria #1, #5)"
  - "Task #12: Open PR with conventional-commits title + research brief/PRD/design/ADR links (Definition of Done)"
dependencies:
  - "#1 blocks #2, #3, #8 (sweep must precede same-file frontmatter edits + validator activation per C2)"
  - "#4 blocks #5 (template must exist before /breakdown references it)"
  - "#6 blocks #7 (OOS dir must exist before CONTRIBUTING.md links it)"
  - "#1-#9 block #10 (version bump is final content change)"
  - "#10 blocks #11 (validators run on full delta)"
  - "#11 blocks #12 (no PR until green)"
estimated_complexity: "medium"
END_SKILL_OUTPUT -->
