---
feature: ai-native-sdlc-432
step: breakdown
created: 2026-11-09T05:05:00+07:00
updated: 2026-11-09T05:40:00+07:00
source-issue: 432
source-skill-version: unversioned (Hermes-installed breakdown skill; no version field)
---

# Tasks: Evidence & Handoff Contract + Behavioral Eval Pilot

**Source**: [prd.md](./prd.md), [design.md](./design.md).

**Status (2026-11-09)**: T1–T7 implemented in the working tree, not committed; `bash tests/ci-local.sh` passes all 11 suites, catalog is fresh, `review-ai` is 1943 words, and removing an anchor makes `test-guide-rule-anchors.sh` fail. T8–T10 await the owner. Decision-1/Decision-2 use the recommended options and remain open for owner confirmation.

## Tasks

| #   | Task | Description (1 sentence) | Files | Depends on | Priority | Readiness |
| --- | ---- | ------------------------ | ----- | ---------- | -------- | --------- |
| 1 | Add Handoff contract section | Add a ≤150-word section (5 fields, evidence classes, not-authorization; MUST only for Evidence and Not verified) to the integrity guide. | `guides/integrity-principles.md` | none | Q2 | ready-for-agent |
| 2 | Add handoff sentence to research, build-brief, deploy-guide | Insert the contract pointer in each Handoff section and add the integrity-principles Load line to build-brief and deploy-guide. | `skills/research/SKILL.md`, `skills/build-brief/SKILL.md`, `skills/deploy-guide/SKILL.md` | #1 | Q2 | ready-for-agent |
| 3 | Add handoff sentence to review-ai within word budget | Insert the same sentence and prove by `wc -w` it stays below 1950 words, trimming the new sentence, not existing content. | `skills/review-ai/SKILL.md` | #1 | Q2 | ready-for-agent |
| 4 | Pin the rule with anchor tests | Add four anchor rows and prove a deleted anchor makes the test fail. | `tests/test-guide-rule-anchors.sh` | #2, #3 | Q2 | ready-for-agent |
| 5 | Write manual eval pilot document | Create the five-scenario pilot with must-not-pass cases, deterministic and human checks, and a result table; link it from `llms.txt`. | `docs/evals/handoff-pilot.md`, `llms.txt` | #1 | Q2 | ready-for-agent |
| 6 | Add playbook rows to doctrine audit | Record the playbook as adopted/adapt/defer/out-of-scope rows with citations and update the self-check counts. | `guides/anthropic-engineering-doctrine-audit.md` | #2, #3 | Q2 | ready-for-agent |
| 7 | Sync mirror and run full validation | Run `sync-mirror.sh`, `ci-local.sh` and the catalog check, then report exact results. | `plugin/` (generated mirror) | #4, #5, #6 | Q1 | ready-for-agent |
| 8 | Run the pilot baseline manually | Owner picks model/runtime and runs the five scenarios once; the agent runs no paid model. | `docs/evals/handoff-pilot.md` | #5, #7 | Q2 | ready-for-human |
| 9 | Confirm and post issue #432 correction | Owner reviews the drafted wording and chooses comment or body edit before anything is posted. | external issue #432 | none | Q3 | ready-for-human |
| 10 | Release decision gate | Owner decides on a release; if yes, follow `guides/release-surface.md`. Not authorized by this plan. | release surface | #7 | Q3 | ready-for-human |

Task #1 implements: Decision-1, Decision-2 (FR-001, FR-002, FR-003, FR-004, FR-005)
Task #2 implements: Decision-3 (FR-006)
Task #3 implements: Decision-3 (FR-006)
Task #4 implements: Decision-3 (FR-007)
Task #5 implements: Decision-4 (FR-009, FR-010, FR-011, FR-012)
Task #6 implements: Decision-5 (FR-008)
Task #7 implements: Decision-6 (FR-013)
Task #8 implements: Decision-4 (FR-010, FR-011, FR-012)
Task #9 implements: owner decision 3 (no FR)
Task #10 implements: Decision-6 (no FR)

## Orchestration

| Task | Type | Isolation | Depends On |
| ---- | ---- | --------- | ---------- |
| T1 | sequential | - | none |
| T2 | parallel-safe | same repo | T1 |
| T3 | parallel-safe | same repo | T1 |
| T4 | sequential | - | T2, T3 |
| T5 | parallel-safe | same repo | T1 |
| T6 | sequential | - | T2, T3 |
| T7 | sequential | - | T4, T5, T6 |
| T8 | sequential | - | T5, T7 |
| T9 | sequential | - | none |
| T10 | sequential | - | T7 |

Lazy-parallelism gate: each agent task is small (a few tool calls) and the sentence in T2/T3 must be identical, so run **sequentially** in one session; the parallel-safe labels only mean the files do not overlap.

## Mechanical plan check (computed before writing)

- 10 tasks; every dependency points to an earlier task (acyclic).
- No task touches more than 5 files; `docs/evals/handoff-pilot.md` does not exist yet and is claimed by tasks 5 and 8 only (8 edits the result table).
- The union of covered FR IDs is 13 of the PRD's 13 (FR-001 to FR-013), with no missing and no extra.
- Tasks 8, 9 and 10 are `ready-for-human`; no task calls a paid model or uses credentials.

## Scope Guard

- Total tasks: 10 (7 agent, 3 human)
- Files affected: about 9 source files plus the generated mirror
- Estimated complexity: medium (word budget in `review-ai` and the anchor-test negative case are the risky points)

<!-- SKILL_OUTPUT:breakdown
task_count: 10
tasks:
  - "T1 Add Handoff contract section"
  - "T2 Add handoff sentence to research, build-brief, deploy-guide"
  - "T3 Add handoff sentence to review-ai within word budget"
  - "T4 Pin the rule with anchor tests"
  - "T5 Write manual eval pilot document"
  - "T6 Add playbook rows to doctrine audit"
  - "T7 Sync mirror and run full validation"
  - "T8 Run the pilot baseline manually (ready-for-human)"
  - "T9 Confirm and post issue #432 correction (ready-for-human)"
  - "T10 Release decision gate (ready-for-human)"
dependencies:
  - "T2,T3,T5 depend on T1; T4,T6 depend on T2,T3; T7 depends on T4,T5,T6; T8 on T5,T7; T10 on T7"
estimated_complexity: "medium"
END_SKILL_OUTPUT -->
