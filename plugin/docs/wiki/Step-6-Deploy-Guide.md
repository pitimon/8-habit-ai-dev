# Step 6 · Deploy Guide

`/deploy-guide` produces a staging-first deployment plan with verification, rollback, and operational reconciliation before production is treated as complete.

| Field | Value |
| --- | --- |
| Command | `/deploy-guide [staging|production]` |
| Habit | H1 Be Proactive |
| Previous | [Step 5 · Review AI](Step-5-Review-AI) |
| Next | [Step 7 · Monitor Setup](Step-7-Monitor-Setup) |

## Use This When

- Production or shared infrastructure may change.
- A database, dependency, environment, alerting, or config change has runtime impact.
- You are planning a provider-managed canary or capacity change.

## Skip When

- The change is local-only and cannot affect a deployed runtime.
- You are only editing documentation with no consumer behavior change.

## Output

- Deploy type classifier.
- Staging plan and staging verification.
- Production plan gated on staging evidence.
- Rollback commands ready to paste.
- Post-deploy verification.
- For provider-managed canaries: planned target, actual provider-selected target, desired/min/max capacity, scheduling state, readiness, and mitigation path.

> [!WARNING]
> Do not call a provider-managed scale or canary complete only because the provider accepted the change. Reconcile the intended target and the actual runtime state.

## Handoff

`/monitor-setup` should receive deployed state, validation evidence, rollback notes, and any monitoring gaps discovered during rollout.

## See Also

- [Workflow Overview](Workflow-Overview)
- [Step 7 · Monitor Setup](Step-7-Monitor-Setup)
- [Skills Reference](Skills-Reference#deploy-guide)
- [Source skill](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/deploy-guide/SKILL.md)
