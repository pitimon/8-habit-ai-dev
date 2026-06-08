# Step 1 · Requirements

`/requirements` defines what should change, why it matters, who it serves, and how success will be evaluated before implementation begins.

| Field | Value |
| --- | --- |
| Command | `/requirements [feature or change]` |
| Habit | H2 Begin with End in Mind |
| Previous | [Step 0 · Research](Step-0-Research) |
| Next | [Step 2 · Design](Step-2-Design) |

## Use This When

- Starting a feature, refactor, workflow change, or non-trivial bug fix.
- The request needs explicit scope or acceptance criteria.
- The agent needs a stable target before coding.

## Skip When

- The change is a small, obvious fix and the expected behavior is already explicit.
- You are only correcting formatting, typos, or generated docs noise.

## Output

- Problem and goal.
- Users or affected stakeholders.
- In-scope and out-of-scope items.
- Success criteria, preferably in EARS-style wording when useful.
- Definition of Done and test expectations.

## Handoff

`/design` should receive the requirements, constraints, acceptance criteria, and any decisions that still require human judgment.

## See Also

- [Workflow Overview](Workflow-Overview)
- [Step 2 · Design](Step-2-Design)
- [Habits Reference](Habits-Reference#habit-2-begin-with-end-in-mind)
- [Source skill](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/requirements/SKILL.md)
