# Step 2 · Design

`/design` turns requirements into architecture options and records the human decision. It is the step that keeps AI from silently choosing the architecture.

| Field | Value |
| --- | --- |
| Command | `/design [requirements or context]` |
| Habit | H8 Find Your Voice |
| Previous | [Step 1 · Requirements](Step-1-Requirements) |
| Next | [Step 3 · Breakdown](Step-3-Breakdown) |

## Use This When

- The change affects architecture, persistence, API contracts, security boundaries, or deployment shape.
- More than one viable implementation path exists.
- The decision should be reviewable later.

## Skip When

- The implementation path is already decided and local.
- The work is mechanical and does not change behavior or structure.

## Output

- Key decisions.
- At least two options for meaningful decisions.
- Trade-offs, risks, and constraints.
- Recommended option, with the human decision made explicit.
- ADR guidance when the decision is durable.

> [!IMPORTANT]
> Architecture decisions stay human-led. The skill structures options; it does not transfer accountability to the model.

## Handoff

`/breakdown` should receive the selected design, rejected alternatives, constraints, and any sequencing requirements.

## See Also

- [Workflow Overview](Workflow-Overview)
- [Architecture](Architecture)
- [Habits Reference](Habits-Reference#habit-8-find-your-voice)
- [Source skill](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/design/SKILL.md)
