# Step 7 · Monitor Setup

`/monitor-setup` closes the loop after deploy by making the new behavior observable and supportable.

| Field | Value |
| --- | --- |
| Command | `/monitor-setup [project or feature]` |
| Habit | H7 Sharpen the Saw |
| Previous | [Step 6 · Deploy Guide](Step-6-Deploy-Guide) |
| Next | [Step 0 · Research](Step-0-Research) for the next cycle |

## Use This When

- A service, feature, integration, or operational workflow has been deployed.
- An incident revealed missing logs, metrics, alerts, or runbook detail.
- You need evidence that production is healthy after change.

## Skip When

- The change cannot affect runtime behavior.
- Existing monitoring already covers the new behavior and this has been verified.

## Output

- Health checks or readiness checks to add or verify.
- Logging, metrics, and tracing gaps.
- Alerting thresholds or ownership notes.
- Dashboard and runbook updates.
- Follow-up items for the next planning cycle.

## Handoff

The next `/research` or `/requirements` cycle should receive real production feedback rather than assumptions.

## See Also

- [Workflow Overview](Workflow-Overview)
- [Step 6 · Deploy Guide](Step-6-Deploy-Guide)
- [Habits Reference](Habits-Reference#habit-7-sharpen-the-saw)
- [Source skill](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/monitor-setup/SKILL.md)
