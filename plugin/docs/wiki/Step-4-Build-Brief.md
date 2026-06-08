# Step 4 · Build Brief

`/build-brief` prepares implementation by reading the existing code and turning one task into a concrete engineering brief.

| Field | Value |
| --- | --- |
| Command | `/build-brief [task]` |
| Habit | H5 Seek First to Understand |
| Previous | [Step 3 · Breakdown](Step-3-Breakdown) |
| Next | [Step 5 · Review AI](Step-5-Review-AI) |

## Use This When

- A task is ready to implement.
- The agent needs to inspect local code before writing.
- Existing patterns, tests, or integration points matter.

## Skip When

- The edit is trivial and the relevant context is already visible.
- The task is documentation-only and no repo pattern discovery is needed.

## Output

- Files likely to change.
- Existing patterns to follow.
- Edge cases and failure modes.
- Test and validation commands.
- Implementation constraints.

## Handoff

`/review-ai` should receive the implemented diff plus the brief, so review can check whether the code matches the intended task.

## See Also

- [Workflow Overview](Workflow-Overview)
- [Step 5 · Review AI](Step-5-Review-AI)
- [Habits Reference](Habits-Reference#habit-5-seek-first-to-understand)
- [Source skill](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/build-brief/SKILL.md)
