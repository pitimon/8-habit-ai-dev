# Task Breakdown: `/consistency-check` + Spec Persistence Opt-In

**Issue**: pitimon/8-habit-ai-dev#165
**Status**: Draft (Step 3: Breakdown)
**PRD**: [./prd.md](./prd.md) (20 EARS)
**Design**: [./design.md](./design.md) (9 decisions)
**ADR**: [../../adr/ADR-013-spec-persistence-opt-in.md](../../adr/ADR-013-spec-persistence-opt-in.md)

> **ID linkage convention** (D9 / ADR-013): Each task references the PRD EARS criteria it satisfies and the design Decision(s) it implements. Format: `(PRD-EARS-X, Design-DN)`. This is the dogfood that lets `/consistency-check` run deterministic Coverage + Inconsistency passes against this very PR.

---

## Tasks

### Phase 1: Skill modifications (parallel-safe — same pattern, 3 files)

#### Task #1 implements: Design-D1, Design-D4 (PRD-EARS-1, 2, 3, 4, 5, 16, 19, 20)

**Modify `skills/requirements/SKILL.md`** — add `--persist <slug>` handling.

- Frontmatter: extend `argument-hint` to `"[--persist <slug>] [feature description]"`; add `"Write"` to `allowed-tools`
- Process section: new step "If `--persist <slug>` present: validate slug against `^[a-z0-9][a-z0-9-]{1,63}$`, ensure `docs/specs/<slug>/` exists, on conflict use AskUserQuestion (overwrite/numbered/abort) or default to numbered variant when non-interactive, write `prd.md` with YAML frontmatter (`feature, step, created, updated, source-issue, source-skill-version`)"
- Error message guidance: state what was attempted / what failed / what user can do next
- Files: `skills/requirements/SKILL.md` (1 file)
- Type: parallel-safe with #2 and #3

#### Task #2 implements: Design-D1, Design-D4 (PRD-EARS-1, 2, 3, 4, 5, 16, 19, 20)

**Modify `skills/design/SKILL.md`** — same pattern as Task #1, persists to `design.md`.

- Files: `skills/design/SKILL.md` (1 file)
- Type: parallel-safe with #1 and #3

#### Task #3 implements: Design-D1, Design-D4 (PRD-EARS-1, 2, 3, 4, 5, 16, 19, 20)

**Modify `skills/breakdown/SKILL.md`** — same pattern as Task #1, persists to `tasks.md`.

- Files: `skills/breakdown/SKILL.md` (1 file)
- Type: parallel-safe with #1 and #2

### Phase 2: New skill (sequential after Phase 1 design pattern locked)

#### Task #4 implements: Design-D2, Design-D5, Design-D6, Design-D8, Design-D9 (PRD-EARS-6, 7, 8, 9, 10, 11, 12, 17, 18)

**Create `skills/consistency-check/SKILL.md`** — main skill file.

- Frontmatter: `name: consistency-check`, `argument-hint: "<slug> | <path-to-spec-dir>"`, `allowed-tools: ["Read", "Glob", "Grep"]`, `prev-skill: any`, `next-skill: any`, `user-invocable: true`
- Body: input resolution (slug-OR-path auto-detect per Decision-D5), 5 detection passes (Coverage, Drift, Ambiguity, Underspec, Inconsistency) with hybrid eval per Decision-D9, severity table (Coverage=HIGH, Drift=CRITICAL, Ambiguity=MEDIUM, Underspec=LOW, Inconsistency=HIGH), max 30 findings, ✓ Pass row for zero-finding passes, file:line citations
- ID-linkage warning: emit at top when any artifact lacks markers
- Empty-dir handling: single CRITICAL finding, exit cleanly
- Files: `skills/consistency-check/SKILL.md` (1 file new)
- Type: parallel-safe with Phase 3
- Depends on: Phase 1 patterns established (#1, #2, #3) for consistency

#### Task #5 implements: Design-D8 (PRD-EARS-7, 17 supporting docs)

**Create `skills/consistency-check/reference.md`** — full output template + examples.

- Output template: severity table format with all column definitions
- Worked examples: one with IDs (deterministic) + one without (LLM semantic + warning)
- ID marker convention reference: where `FR-NNN`, `Decision-N`, `Task #N` go in each artifact
- YAML frontmatter schema reference (for persisted artifacts)
- Files: `skills/consistency-check/reference.md` (1 file new)
- Type: sequential after #4
- Depends on: #4

### Phase 3: Templates + docs (parallel-safe — independent files)

#### Task #6 implements: Design-D9 (PRD-EARS-17 — supports ID-linkage convention)

**Update `guides/templates/prd-template.md`, `adr-template.md`, `task-list-template.md`** — add OPTIONAL ID marker guidance.

- prd-template: add comment "OPTIONAL: number EARS criteria as FR-001, FR-002... for /consistency-check rigor"
- adr-template: add comment "OPTIONAL: number decisions as Decision-1, Decision-2... for cross-artifact traceability"
- task-list-template: add comment "OPTIONAL: format tasks as 'Task #N implements: Decision-X (FR-Y)' for hybrid-eval rigor"
- Files: 3 template files (within 5-file limit)
- Type: parallel-safe with #4, #7-#11

#### Task #7 implements: scope_in (CLAUDE.md update)

**Update `CLAUDE.md`** — add new convention bullet under "Key Conventions"; add `/consistency-check` row in skills→habits table.

- Files: `CLAUDE.md` (1 file)
- Type: parallel-safe

#### Task #8 implements: scope_in (README update)

**Update `README.md`** — bump version badge + footer; add "What's New" v2.x.x entry; update skills count.

- Files: `README.md` (1 file)
- Type: parallel-safe

#### Task #9 implements: scope_in (CHANGELOG)

**Update `CHANGELOG.md`** — add new release entry: "Add `/consistency-check` cross-artifact analyzer + opt-in `--persist` for `/requirements`, `/design`, `/breakdown`".

- Files: `CHANGELOG.md` (1 file)
- Type: parallel-safe

#### Task #10 implements: PRD-EARS-15, scope_in (CONTRIBUTING manual smoke)

**Update `CONTRIBUTING.md`** — add manual smoke procedure for `/consistency-check` self-test (run skill against `docs/specs/consistency-check/`, expected: low or zero findings).

- Files: `CONTRIBUTING.md` (1 file)
- Type: parallel-safe

#### Task #11 implements: scope_in (SELF-CHECK header)

**Update `SELF-CHECK.md`** — header version bump.

- Files: `SELF-CHECK.md` (1 file)
- Type: parallel-safe

#### Task #12 implements: scope_in (version sync)

**Update `.claude-plugin/plugin.json` + `.claude-plugin/marketplace.json`** — version bump (next minor — v2.15.0 — per CHANGELOG convention; bundled new feature warrants minor not patch).

- Files: 2 plugin metadata files
- Type: parallel-safe (do near end to avoid in-flight version conflicts during dev)

### Phase 4: Validators (sequential after Phase 1+2)

#### Task #13 implements: PRD-EARS-13 (existing tests still pass)

**Update `tests/validate-structure.sh`** — new checks: `/consistency-check` SKILL.md exists, has correct frontmatter (name, allowed-tools = Read/Glob/Grep only, prev-skill, next-skill); reference.md exists; `docs/specs/consistency-check/{prd,design,tasks}.md` all exist with valid YAML frontmatter (dogfood enforcement per ADR-013 Verification).

- Files: `tests/validate-structure.sh` (1 file)
- Type: sequential after #4, #5
- Depends on: #4, #5 (must exist for checks to pass)

#### Task #14 implements: PRD-EARS-13, PRD-EARS-15 (validator dogfood)

**Update `tests/validate-content.sh`** — new checks: all 3 modified skills (`/requirements`, `/design`, `/breakdown`) document `--persist` in body and frontmatter; `/consistency-check` SKILL.md mentions all 5 passes by name + hybrid eval + severity table; reference.md has output template; CONTRIBUTING.md has manual smoke section; CHANGELOG has the new release entry; CLAUDE.md has the new convention bullet.

- Files: `tests/validate-content.sh` (1 file)
- Type: sequential after #1-#10
- Depends on: #1, #2, #3, #4, #5, #7, #9, #10

### Phase 5: Self-application (last, dogfood)

#### Task #15 implements: PRD-EARS-15, PRD-EARS-17 (dogfood ID-linkage)

**Verify `docs/specs/consistency-check/tasks.md` contains `Task #N implements: Decision-X (PRD-EARS-Y)` markers** (already done in this file). After all other tasks complete, manually run `/consistency-check consistency-check` against this very feature's directory; expected: zero findings (or only acceptable advisory items). Document the manual smoke output in PR description as part of test plan.

- Files: none (verification + PR description update)
- Type: sequential, last
- Depends on: ALL prior tasks

---

## Orchestration Table

| Task | Type                        | Isolation                    | Depends On                      |
| ---- | --------------------------- | ---------------------------- | ------------------------------- |
| #1   | parallel-safe               | same repo, distinct file     | none                            |
| #2   | parallel-safe               | same repo, distinct file     | none                            |
| #3   | parallel-safe               | same repo, distinct file     | none                            |
| #4   | parallel-safe               | same repo, distinct new file | (Phase 1 pattern)               |
| #5   | sequential                  | —                            | #4                              |
| #6   | parallel-safe               | distinct template files      | none                            |
| #7   | parallel-safe               | distinct doc file            | none                            |
| #8   | parallel-safe               | distinct doc file            | none                            |
| #9   | parallel-safe               | distinct doc file            | none                            |
| #10  | parallel-safe               | distinct doc file            | none                            |
| #11  | parallel-safe               | distinct doc file            | none                            |
| #12  | parallel-safe (do near end) | distinct config files        | (after dev stabilizes)          |
| #13  | sequential                  | —                            | #4, #5                          |
| #14  | sequential                  | —                            | #1, #2, #3, #4, #5, #7, #9, #10 |
| #15  | sequential, last            | —                            | ALL                             |

## Lazy Parallelism Gate Decision

**Verdict: Sequential execution by phase**, not parallel agents. Reasoning:

- All 15 tasks are markdown edits (no compilation, no test runtime to overlap)
- Tasks #1-#3 are pattern-replication — best done sequentially with the pattern locked from #1, then mirrored to #2 and #3 (avoids 3-way drift)
- Task #4 is the substantive work; benefits from focused single-agent attention
- Tasks #7-#12 are doc updates that benefit from cross-checking each other (e.g., README "What's New" version must match CHANGELOG must match plugin.json — easier to do sequentially with one mind tracking the version string)
- Coordination overhead of parallel agents (worktrees, merge conflicts on README/CHANGELOG when "What's New" entries collide) > token savings

**One exception**: Tasks #1, #2, #3 (the 3 skill mods) MAY be done with template-based copy-paste after #1 establishes the pattern. Treat as sequential mental cycles, but tooling can apply changes in a single pass if the pattern is identical.

## H3 Checkpoint

**"Am I doing what's important, or what's interesting?"**

- Q2 (Important, not urgent): Tasks #1-#5 (the actual feature), #13-#14 (validators that prevent regression). DO.
- Q1 (Urgent + important): None — no fires to put out.
- Q3 (Urgent, not important): Version bumps and "What's New" — necessary but conventional.
- Q4 (Skip): None identified. The "story-tier P1/P2/P3" and "/constitution" features from research brief Options 2 and 3 are explicitly out of scope per PRD.

[/breakdown] COMPLETE SKILL_OUTPUT:breakdown

<!-- SKILL_OUTPUT:breakdown
task_count: 15
tasks:
  - "Task #1: Modify /requirements SKILL.md — add --persist handling (Design-D1,D4; PRD-EARS-1,2,3,4,5,16,19,20)"
  - "Task #2: Modify /design SKILL.md — same pattern"
  - "Task #3: Modify /breakdown SKILL.md — same pattern"
  - "Task #4: Create skills/consistency-check/SKILL.md — 5 passes, hybrid eval (Design-D2,D5,D6,D8,D9; PRD-EARS-6-12,17,18)"
  - "Task #5: Create skills/consistency-check/reference.md — output template + examples"
  - "Task #6: Update 3 templates (prd, adr, task-list) — add OPTIONAL ID marker guidance"
  - "Task #7: Update CLAUDE.md — convention bullet + skills→habits row"
  - "Task #8: Update README.md — version badge + footer + What's New"
  - "Task #9: Update CHANGELOG.md — new release entry"
  - "Task #10: Update CONTRIBUTING.md — manual smoke procedure"
  - "Task #11: Update SELF-CHECK.md — header version bump"
  - "Task #12: Bump .claude-plugin/plugin.json + marketplace.json"
  - "Task #13: Update validate-structure.sh — new skill structural checks + dogfood artifact checks"
  - "Task #14: Update validate-content.sh — content checks for --persist docs + 5 passes + hybrid + CHANGELOG entry + CLAUDE.md update"
  - "Task #15: Self-apply — run /consistency-check on docs/specs/consistency-check/, document output in PR description"
dependencies:
  - "Phase 1 (#1-#3) parallel-safe; Phase 2 (#4) after pattern, #5 after #4; Phase 3 (#6-#12) parallel-safe; Phase 4 (#13-#14) sequential after needed inputs; Phase 5 (#15) last"
  - "ID-linkage dogfood: each task lists Design-DX and PRD-EARS-Y refs for /consistency-check deterministic Coverage+Inconsistency passes"
estimated_complexity: "medium"
END_SKILL_OUTPUT -->
