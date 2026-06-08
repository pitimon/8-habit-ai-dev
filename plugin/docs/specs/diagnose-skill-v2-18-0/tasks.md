---
slug: diagnose-skill-v2-18-0
version: 1
created: 2026-05-23
predecessor: design.md
successor: build-brief (next: /build-brief per task)
authors: Pitimon (human) + Claude Opus 4.7 (1M context)
task_count: 8
backlog_bound: false
---

# Tasks: `/diagnose` skill for 8-habit-ai-dev v2.18.0

## Scope alignment (against `design.md` SKILL_OUTPUT)

- 5 decisions covered by tasks: Decision-1 (T1+T2), Decision-2 (T1), Decision-3 (T1), Decision-4 (T3), Decision-5 (T1+T2)
- 14 FRs from PRD distributed across T1+T2+T3 (Coverage Matrix below)
- All 5 risks mitigated by task design (no risky parallelism on sticky decisions)

## Task list

### Q2 — Core deliverables (Important, Not Urgent)

**Task #1**: Write `skills/diagnose/SKILL.md` — 6-phase methodology body, frontmatter (`prev-skill: any, next-skill: post-mortem, allowed-tools: Read/Glob/Grep/Bash`), habit map H1+H5 with checkpoint, when-to-use + when-to-skip, FR-014 user-supplied path prompt, handoff section, structured output block. Adapt-with-attribution from mattpocock SHA `b8be62ff` per Decision-5; verbatim quote anchor on FR-004 hypothesis template.

- Files: `skills/diagnose/SKILL.md` (new)
- Implements: Decision-1, Decision-2, Decision-3, Decision-5 → FR-001..006, FR-008..014
- Depends on: none
- ≤5 files: ✓ (1 file)
- ≤1 sentence: ✓ (compound but single deliverable)

**Task #2**: Write `skills/diagnose/reference.md` — full mattpocock prior-art notes with SHA-pinned source URL, longer per-phase examples, false-positive patterns from `~/.claude/lessons/2026-04-12-compression-worker-420-investigation.md`, license attribution.

- Files: `skills/diagnose/reference.md` (new)
- Implements: Decision-1 (split target), Decision-5 (offload of prior-art detail)
- Depends on: none (parallel-safe with T1)
- ≤5 files: ✓ (1 file)

**Task #3**: Write `docs/adr/ADR-015-diagnose-skill-adoption-and-n1-framing.md` — adoption decision, n=1 friction citation with verbatim lesson quote, ADR-014 doctrine inheritance, options-considered table (ship / defer-with-issue / bundle — bundle rejected per Decision-4), plugin-boundary compliance.

- Files: `docs/adr/ADR-015-diagnose-skill-adoption-and-n1-framing.md` (new)
- Implements: Decision-4 → PRD success criterion 6
- Depends on: none (parallel-safe with T1, T2)
- ≤5 files: ✓ (1 file)

### Q1 — Version sync (blocking dependency)

**Task #4**: Version bump to `2.18.0` across 4 sync files — atomic single-commit update.

- Files: `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`, `README.md` (badge + footer), `SELF-CHECK.md` (header)
- Implements: PRD DoD bullet 4 (version sync), C5 (atomicity)
- Depends on: #1, #2 (skill must exist before version claims it)
- ≤5 files: ✓ (4 files)

**Task #5**: CHANGELOG.md + `docs/wiki/Changelog.md` entries for v2.18.0 — feature note for `/diagnose` skill, friction citation, ADR-015 cross-reference.

- Files: `CHANGELOG.md`, `docs/wiki/Changelog.md`
- Implements: PRD DoD bullet 5
- Depends on: #1, #2, #3 (entries cite the work)
- ≤5 files: ✓ (2 files)

### Q1 — Mandatory verification (per CLAUDE.md workflow)

**Task #6**: Run all 4 validator suites and verify green — `tests/validate-structure.sh`, `tests/validate-content.sh`, `tests/test-skill-graph.sh`, `tests/test-verbosity-hook.sh`. No edits expected; if any fails, fix-loop returns to T1/T2/T3 as appropriate.

- Files: none modified (read-only execution); fixes may re-touch #1, #2, #3 files
- Implements: PRD DoD bullets 2 + 6, FR-012, FR-013
- Depends on: #1, #2, #3, #4, #5 (all artifacts must exist + version set)
- ≤5 files: ✓ (execution only)

**Task #7**: Run `/review-ai` + `/cross-verify` on the change — score ≥12/17 (Mostly ready band) gate per PRD DoD bullet 7; address all CRITICAL/HIGH findings before commit. Mandatory per `rules/workflow.md` Code Change Sequence step 2.

- Files: none modified (review-only); fixes may re-touch any earlier task's files
- Implements: PRD DoD bullets 7, 8
- Depends on: #6 (validators green)
- ≤5 files: ✓ (review only)

**Task #8**: `/commit-push-pr` — explicit file staging (no `git add -A`), conventional commit, PR with test-plan checklist citing the 4 validator suites + cross-verify score + ADR-015 reference. Honest-framing note: "forward guardrail with n=1 friction citation" per ADR-015.

- Files: git operations on the 11 modified/created files (1+1+1+4+2+2 = 11)
- Implements: PRD DoD bullets 5, 9 + `rules/workflow.md` Code Change Sequence step 3
- Depends on: #7 (review pass)
- ≤5 files: N/A (staging operation, not a touched-file count)

## Orchestration table

| Task            | Type                    | Isolation                 | Depends On |
| --------------- | ----------------------- | ------------------------- | ---------- |
| #1 SKILL.md     | parallel-safe           | same repo, different file | none       |
| #2 reference.md | parallel-safe           | same repo, different file | none       |
| #3 ADR-015      | parallel-safe           | same repo, different dir  | none       |
| #4 Version sync | parallel-safe (with #5) | 4 distinct files          | #1, #2     |
| #5 CHANGELOG    | parallel-safe (with #4) | 2 distinct files          | #1, #2, #3 |
| #6 Validators   | sequential              | execution                 | #1..#5     |
| #7 Review pass  | sequential              | review-only               | #6         |
| #8 commit + PR  | sequential              | git ops                   | #7         |

## Lazy Parallelism Gate evaluation

**Q: Can I do this sequentially in ≤5 tool calls?** No — each of #1, #2, #3 is substantial markdown writing (#1 alone is ~1500-2000 words). Even single-author sequential, this is 3 Write tool calls minimum, plus version sync, CHANGELOG, validators, review, PR = ~10 tool calls.

**Q: Are tasks meaningfully disjoint?** ✓ Yes for #1/#2/#3 (different files, different concerns). #4 and #5 are also disjoint (version vs changelog).

**Q: Will coordinating add complexity outweighing savings?** ✓ No for single-author sequential mode. The orchestration table documents what COULD parallelize across worktrees, not what we're dispatching now.

**Decision**: This breakdown is for a single-author session. The orchestration table is documentation of independence boundaries (useful if the work were ever split across agents in worktrees); execution will be sequential through one Claude agent. Lazy parallelism gate honored — no Agent dispatch for these tasks; they're cheaper sequential.

## Coverage Matrix (FR → Task)

| FR     | Title                                   | Task #                             |
| ------ | --------------------------------------- | ---------------------------------- |
| FR-001 | 6-phase methodology                     | #1 (in SKILL.md body)              |
| FR-002 | Phase 1 first                           | #1                                 |
| FR-003 | P1 → P2 transition                      | #1                                 |
| FR-004 | Falsifiable hypotheses (verbatim quote) | #1                                 |
| FR-005 | Debugger > logs                         | #1 + #2 (examples in reference.md) |
| FR-006 | Regression test before fix              | #1 + #2                            |
| FR-007 | Handoff to /post-mortem                 | #1 (frontmatter `next-skill`)      |
| FR-008 | Phase 1 blocker fallback                | #1                                 |
| FR-009 | Frontmatter declarations                | #1                                 |
| FR-010 | Habit map H1+H5 + checkpoint            | #1                                 |
| FR-011 | Skip rule                               | #1                                 |
| FR-012 | ≤2000 words                             | #1 + #6 (validator gate)           |
| FR-013 | Description ≤1024 + trigger             | #1 + #6 (Check 25)                 |
| FR-014 | Predecessor brief detection             | #1 (Option C prompt)               |

All 14 FRs covered. No orphans.

## Scope guard — Q2 vs Q4 check

| Task   | Quadrant | Justification                                                   |
| ------ | -------- | --------------------------------------------------------------- |
| #1, #2 | Q2       | Core deliverable — the skill itself                             |
| #3     | Q2       | Doctrine record per ADR-014 inheritance — prevents future drift |
| #4     | Q1       | Blocking — Check 4 enforces version sync                        |
| #5     | Q2       | User-facing doc for the release                                 |
| #6     | Q1       | Blocking — must pass before commit                              |
| #7     | Q1       | Mandatory per workflow.md (NEVER skip)                          |
| #8     | Q1       | Blocking — only way work lands                                  |

No Q3 (gold-plating) or Q4 (busy-work) tasks. Scope tight.

## Backlog-bound check

**Will any task sit ≥7 days before pickup?** No — work proceeds in this session.
**Filer ≠ picker?** No — same agent + maintainer.

**AGENT-BRIEF template not invoked.** If session pauses unexpectedly, file an AGENT-BRIEF using `guides/templates/agent-brief-template.md` for resumption — but not pre-emptively.

## H3 Checkpoint

"Am I doing what's important, or what's interesting?"

✓ Important. Every task ties back to a PRD DoD bullet or a workflow.md MANDATORY step. The interesting-but-not-needed extras (additional examples, screencast docs, CI badge, related-skills cross-links beyond `/post-mortem`) are out of scope per PRD.

## Handoff

- **Expects from predecessor** (`/design`): 5 decisions at `docs/specs/diagnose-skill-v2-18-0/design.md` (delivered ✓)
- **Produces for successor** (`/build-brief`): atomic task list with file paths and dependencies. Each task is `/build-brief`-able individually if context-refresh needed before execution.

[/breakdown] COMPLETE SKILL_OUTPUT:breakdown

<!-- SKILL_OUTPUT:breakdown
task_count: 8
tasks:
  - "Task #1: Write skills/diagnose/SKILL.md (6-phase body, frontmatter, habit map, handoff)"
  - "Task #2: Write skills/diagnose/reference.md (mattpocock prior-art + lesson notes + examples)"
  - "Task #3: Write docs/adr/ADR-015-diagnose-skill-adoption-and-n1-framing.md"
  - "Task #4: Version bump to 2.18.0 across 4 sync files (plugin.json, marketplace.json, README.md, SELF-CHECK.md)"
  - "Task #5: CHANGELOG.md + docs/wiki/Changelog.md entries"
  - "Task #6: Run 4 validator suites, verify green"
  - "Task #7: /review-ai + /cross-verify pass (>=12/17 gate)"
  - "Task #8: /commit-push-pr with explicit staging + PR test plan"
dependencies:
  - "T4 depends on T1, T2"
  - "T5 depends on T1, T2, T3"
  - "T6 depends on T1-T5 (all artifacts present + version set)"
  - "T7 depends on T6 (validators green)"
  - "T8 depends on T7 (review pass)"
  - "T1, T2, T3 fully independent (parallel-safe)"
estimated_complexity: "medium"
END_SKILL_OUTPUT -->
