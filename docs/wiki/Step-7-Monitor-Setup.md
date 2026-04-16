# Step 7 · Monitor Setup

**Command**: `/monitor-setup [project]` · **Habit**: H7 Sharpen the Saw · **Previous**: [Step 6 · Deploy Guide](Step-6-Deploy-Guide)

## Purpose

Set up error tracking, alerting, and health checks so you **learn from production**. The final step closes the loop between deploy and the next planning cycle.

## When to use

- After a new service is deployed
- When adding a new critical feature to an existing service
- When an incident reveals a monitoring gap

## When to skip

- Internal tools with zero users (use judgment — often you still want basic health)
- Ephemeral preview deploys

## Process

1. Read existing monitoring — don't duplicate what's already wired up
2. Define the **4 golden signals**: latency, traffic, errors, saturation
3. Add or verify:
   - `/health` endpoint (liveness + readiness)
   - Structured logging with correlation IDs
   - Error tracking (Sentry, Rollbar, etc.)
   - Metrics export (Prometheus, OpenTelemetry)
   - Alerts on SLO breach
4. Document the runbook: "If X alerts fire, do Y"

## Output

- Monitoring config (code + infra)
- Alert rules
- Runbook entry for this feature
- Dashboard link

## Handoff

- **Expects**: A deployed service from `/deploy-guide`
- **Produces for the next cycle**: Production feedback that informs the next `/research` or `/requirements`

## H7 Checkpoint

> [!IMPORTANT]
> _"Am I investing in future capability, or just grinding out output?"_

## See also

- [Source: `skills/monitor-setup/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/monitor-setup/SKILL.md)
- [Habits Reference → H7](Habits-Reference#habit-7-sharpen-the-saw)
- Next cycle: [Step 0 · Research](Step-0-Research)
