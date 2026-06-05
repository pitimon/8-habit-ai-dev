---
name: operational-state
description: >
  Classify operational findings before action: Watch, Fix Candidate, Active Incident,
  Resolved, Handoff, Known Accepted Issue, False Positive, or Self-Resolved.
  Use when an infra/app/alert finding is not simply "fix" or "done", especially when
  recovered-but-recurring signals, Running-but-unhealthy workloads, ownership handoffs,
  or accepted known issues need explicit evidence and closure criteria. Read-only
  guidance; maps state to required evidence, allowed/prohibited actions, approval gates,
  artifacts, escalation criteria, and next action without executing mutations. Maps to
  H1 (Be Proactive) + H5 (Seek First to Understand) + H8 (Find Your Voice).
user-invocable: true
argument-hint: "[finding, alert, incident note, or operational assessment]"
allowed-tools: ["Read", "Glob", "Grep"]
prev-skill: any
next-skill: any
---

# Operational State

**Habits**: H1 (Be Proactive) + H5 (Seek First to Understand) + H8 (Find Your Voice) | **Anti-pattern**: treating every operational signal as either "fix now" or "close"

## When to Use

- An alert, daily-fix item, health check, or ops finding needs classification before action.
- The system is currently healthy but the signal recurs or could become noisy.
- A pod/service says Running, but a mount path, dependency, endpoint, or user-visible check is unhealthy.
- Ownership is unclear and the next step may be AppDev, Registry, vendor, or another team handoff.
- A known issue should stay visible without counting as an active incident.
- You need to distinguish report hygiene from a cluster/service mutation.

Use this before `/deploy-guide` for operational mutations, before `/post-mortem` for fixed incidents, and before `/management-talk` when leadership needs state wording.

## When to Skip

- The finding already has a validated root cause, approved fix, rollback plan, and current impact; go to `/deploy-guide` or `/post-mortem`.
- The work is only a wording/status update with no operational ambiguity.
- The user explicitly asks for an incident RCA after a validated fix; use `/post-mortem`.
- The problem is a hard unknown-root-cause bug; use `/diagnose` first.

## State Decision Process

1. **Capture the signal**: symptom, source, timestamp, environment, owner candidate, and user/customer impact if any.
2. **Check current reality**: fresh status, logs/events/metrics, and one independent confirmation when root cause or recovery is claimed.
3. **Choose exactly one current state** from the table in [`reference.md`](reference.md).
4. **Name the evidence threshold** that would promote, demote, close, or hand off the finding.
5. **Separate action classes**:
   - report hygiene: docs, ticket wording, owner routing, alert wording
   - read-only validation: logs, metrics, dry-run, rendered config, endpoint check
   - mutation: deploy, restart, scale, config write, secret rotation, data repair
6. **Gate mutations**: if production/shared infrastructure is involved, require explicit human approval plus rollback/mitigation notes before any write.

## State Quick Map

| State | Use when | Next action |
| --- | --- | --- |
| `Watch` | healthy now, but recurring or noisy | define escalation criteria and recheck window |
| `Fix Candidate` | reproducible issue, likely needs action, not approved | write remediation ladder + rollback plan |
| `Active Incident` | current impact exists and remediation is needed | execute approved incident flow with after-state validation |
| `Resolved` | root cause/fix/verification all match | close with evidence and recurrence watch if needed |
| `Handoff` | another owner must act | send evidence + validation criteria to that owner |
| `Known Accepted Issue` | accepted risk should stay visible | document owner, expiry/review date, and suppression boundary |
| `False Positive` | signal is wrong and independently disproved | fix detection or document why no action is needed |
| `Self-Resolved` | recovered without confirmed fix | record recovery evidence and promotion criteria; do not call it fixed |

## Guardrails

**Why:** operational findings often look healthy from one layer while failing at another. State wording must preserve that ambiguity until evidence closes it.

- **Running is not healthy.** If the pod/process is Running but the mount, endpoint, job, dependency, or user-visible behavior is broken, the state is not `Resolved`.
- **Recovered is not fixed.** If the signal cleared but may recur, classify as `Watch` or `Self-Resolved`, not `Resolved`.
- **A source-of-truth drift is actionable even when the live system works.** Classify drift separately from impact.
- **Report hygiene is not a production mutation.** Updating PR text, changelog, ticket wording, or alert copy can proceed with normal review; service writes still need approval gates.
- **Do not hide adjacent state.** If one issue is resolved but a related finding remains, close the resolved item and open or link the remaining state.

## Output Template

```md
## Operational State Decision
**State**: [Watch | Fix Candidate | Active Incident | Resolved | Handoff | Known Accepted Issue | False Positive | Self-Resolved]
**Rationale**: [1-2 sentences]
**Evidence**: [fresh checks, timestamps, independent confirmation if relevant]
**Allowed actions now**: [report hygiene | read-only validation | approved mutation]
**Prohibited actions now**: [what must not happen in this state]
**Required artifacts**: [ASSESSMENT.md / BEFORE-STATE.md / ROLLBACK-PLAN.md / AFTER-STATE.md / HANDOFF.md / ticket comment]
**Escalate/promote if**: [specific trigger]
**Closure criteria**: [specific evidence needed to close]
**Next action**: [one concrete action]
```

## Examples

**Recovered but recurring**: Rancher management-plane signal is green at recheck time, but it recurs daily. State: `Watch`. Next action: define recurrence threshold and owner; no cluster writes unless promoted.

**Running but unhealthy**: JuiceFS pod is Running, but the mount path fails an application-visible check. State: `Fix Candidate` or `Active Incident` depending on impact. It is not `Resolved`.

**Ownership handoff**: Registry authentication is healthy from infra vantage, but image publishing still fails in the AppDev pipeline. State: `Handoff`. Next action: send evidence, owner recommendation, and validation criteria.

## Handoff

- **Expects from predecessor (any)**: alert, ticket, health check, incident note, or current operational assessment.
- **Produces for successor**: state decision, action class, approval requirement, artifacts, escalation criteria, and closure criteria. Common successors: `/deploy-guide`, `/post-mortem`, `/management-talk`, `/consistency-check`.

## Definition of Done

- [ ] Exactly one current state selected with 1-2 sentence rationale
- [ ] Fresh evidence listed, including independent confirmation for root cause/recovery claims when relevant
- [ ] Allowed and prohibited actions named for the state
- [ ] Human approval requirement stated for any production/shared-infra mutation
- [ ] Required artifacts named
- [ ] Escalation/promotion criteria stated
- [ ] Closure criteria stated and do not confuse Running/recovered with healthy/fixed

Load `${CLAUDE_PLUGIN_ROOT}/skills/operational-state/reference.md` for the full state matrix, artifact map, and worked examples.
