# Workflow Overview

The workflow is a sequence of markdown skills that keeps AI-assisted work reviewable. Each step has a purpose, a handoff, and a skip rule.

## Steps

| Step | Skill | Habit | Output |
| --- | --- | --- | --- |
| 0 | [`/research`](Step-0-Research) | H5 | Research brief |
| 1 | [`/requirements`](Step-1-Requirements) | H2 | PRD-style scope and success criteria |
| 2 | [`/design`](Step-2-Design) | H8 | Architecture options and decision |
| 3 | [`/breakdown`](Step-3-Breakdown) | H3 | Atomic task list |
| 4 | [`/build-brief`](Step-4-Build-Brief) | H5 | Implementation brief |
| 5 | [`/review-ai`](Step-5-Review-AI) | H4 | Review findings before commit |
| 6 | [`/deploy-guide`](Step-6-Deploy-Guide) | H1 | Deploy, rollback, and verification plan |
| 7 | [`/monitor-setup`](Step-7-Monitor-Setup) | H7 | Observability and runbook updates |

```text
/research
  -> /requirements
  -> /design
  -> /breakdown
  -> /build-brief
  -> /review-ai
  -> /deploy-guide
  -> /monitor-setup
```

## Use This When

- The change is larger than a trivial local edit.
- The domain is unclear.
- Architecture, data, security, or deployment behavior may change.
- A production or operational finding needs controlled handling.

## Practical Skip Guide

| Change type | Typical path |
| --- | --- |
| Formatting only | `/review-ai` |
| Obvious one-line bug fix | `/review-ai` |
| Dependency or config change | `/review-ai` -> `/deploy-guide` |
| Small feature | `/requirements` -> `/breakdown` -> `/build-brief` -> `/review-ai` |
| Medium feature | `/requirements` -> `/design` -> `/breakdown` -> `/build-brief` -> `/review-ai` -> `/deploy-guide` |
| Unclear domain or architecture change | Full workflow |
| Production incident or config hotfix | `/diagnose` or `/operational-state`, then `/consistency-check`, `/review-ai`, `/deploy-guide` as applicable |

> [!WARNING]
> Do not skip `/review-ai` for AI-generated work. Other steps have legitimate skip cases; review is the baseline.

## Operational Extensions

The workflow now includes explicit operational support outside the linear steps:

- `/operational-state` classifies findings before mutation or closure.
- `/consistency-check` can check incident/config hotfix claims against evidence.
- `/deploy-guide` includes reconciliation gates for provider-managed canaries and capacity changes.

## See Also

- [Skills Reference](Skills-Reference)
- [Getting Started](Getting-Started)
- [Troubleshooting](Troubleshooting)
