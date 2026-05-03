# Task List Template

Output template for `/breakdown` (Step 3).

> **OPTIONAL ID linkage** (recommended when persisting via `--persist <slug>`): Format each task as `Task #N implements: Decision-X (FR-Y)` to cite the design decision and PRD requirement it satisfies (e.g., `Task #12 implements: Decision-4 (FR-001, FR-003)`). When all artifacts in a `docs/specs/<slug>/` directory use ID markers, `/consistency-check` runs deterministic Coverage and Inconsistency passes. See [ADR-013](../../docs/adr/ADR-013-spec-persistence-opt-in.md).

## Feature: [Name]

**Source**: [Link to PRD or design decision]

## Tasks

| #   | Task        | Description (1 sentence)      | Files        | Depends on | Priority |
| --- | ----------- | ----------------------------- | ------------ | ---------- | -------- |
| 1   | [Task name] | [What this task accomplishes] | [file paths] | none       | Q2       |
| 2   | [Task name] | [What this task accomplishes] | [file paths] | #1         | Q2       |
| 3   | [Task name] | [What this task accomplishes] | [file paths] | none       | Q2       |

## Parallel Opportunities

- Tasks #1 and #3 have no dependencies — can run concurrently

## Scope Guard

- Total tasks: [N]
- Total files affected: [N] (if >15, consider splitting the feature)
- Estimated complexity: [small | medium | large]

<!-- SKILL_OUTPUT:breakdown
task_count: [N]
tasks:
  - "[task 1]"
dependencies:
  - "[dependency description]"
estimated_complexity: "[low|medium|high]"
END_SKILL_OUTPUT -->
