# Task List Template

Output template for `/breakdown` (Step 3).

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
