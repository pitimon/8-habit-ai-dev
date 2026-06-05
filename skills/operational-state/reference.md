# Operational State Reference

Use this reference when the short state map in `SKILL.md` is not enough. The goal is consistent operational judgement, not a runtime workflow engine.

## State Matrix

| State | Required evidence | Allowed actions | Prohibited actions | Human approval | Required artifacts | Escalation / closure |
| --- | --- | --- | --- | --- | --- | --- |
| `Watch` | fresh recheck; event/log/metric evidence; recurrence pattern or uncertainty | ticket update, scheduled recheck, alert-noise note, owner assignment | production writes; declaring fixed; suppressing without criteria | not for read-only monitoring; yes before mutation | `ASSESSMENT.md` or ticket comment with recheck window | promote to `Fix Candidate` or `Active Incident` if recurrence threshold or impact appears; close only after quiet window or accepted risk decision |
| `Fix Candidate` | reproduced issue; likely owner; blast-radius notes; candidate remediation ladder | read-only validation, dry-run, rollback drafting, approval request | write/deploy/restart before approval; claiming resolution | yes before any mutation | `BEFORE-STATE.md`, `ROLLBACK-PLAN.md`, remediation options | promote to `Active Incident` if impact is current; close as `Resolved` only after approved fix and after-state verification |
| `Active Incident` | current user/customer/system impact; DoD; rollback/mitigation path | approved remediation, mitigation, status updates, after-state validation | unapproved risky writes; broad blast-radius changes without explicit approval; closing on partial recovery | yes for production/shared infra writes unless standing incident policy already grants it | `BEFORE-STATE.md`, `ROLLBACK-PLAN.md`, `AFTER-STATE.md`, incident timeline | move to `Resolved` after original symptom is verified clear; move to `Watch` if impact clears but recurrence risk remains |
| `Resolved` | original symptom clear; root cause or accepted explanation; fix or mitigation applied; after-state evidence | closure comment, post-mortem, management update, monitor follow-up | hiding remaining adjacent issues; overclaiming root cause; closing without original-symptom verification | no for closure text; yes for any additional mutation | `AFTER-STATE.md`, closure comment, optional `/post-mortem` | reopen or move to `Watch` if recurrence appears; split adjacent findings |
| `Handoff` | evidence that current owner is not root owner; suggested owner; validation criteria | handoff note, owner routing, joint triage request | mutating systems outside ownership; closing without receiving-owner path | yes if any interim mitigation writes are needed | `HANDOFF.md` or ticket handoff block | close local item only when receiving owner accepts or tracking link exists; keep Watch if local risk remains |
| `Known Accepted Issue` | explicit owner/risk acceptance; impact boundary; review/expiry date; suppression boundary | document, suppress from active counts, periodic review | deleting visibility; indefinite acceptance without owner/date; broad suppression | yes: owner acceptance is the approval | accepted-risk note, ticket label, expiry/review date | reopen as `Fix Candidate` if boundary exceeded or expiry passes |
| `False Positive` | signal independently disproved; detector/source identified; why no user/system impact | adjust alert wording/rule, document no-op, close detection bug | ignoring detector drift; calling the underlying system fixed if only the signal was wrong | yes only if changing production alerting/config | evidence note, optional alert-rule PR | close when detector is corrected or documented; open follow-up if alert quality remains risky |
| `Self-Resolved` | symptom cleared without confirmed fix; recovery timestamp; current healthy checks | record recovery, set watch window, define recurrence trigger | claiming root cause fixed; deleting evidence; broad suppression | no for observation; yes before any preventive mutation | recovery note, watch criteria | move to `Resolved` only after cause/fix/accepted explanation is established; otherwise close with self-resolved wording plus recurrence trigger |

## Artifact Map

- `ASSESSMENT.md`: current signal, affected scope, state, evidence, next check.
- `BEFORE-STATE.md`: pre-mutation inventory, health, current impact, blast radius.
- `ROLLBACK-PLAN.md`: rollback command/path, abort criteria, owner approval.
- `AFTER-STATE.md`: original symptom verification, health checks, residual findings.
- `HANDOFF.md`: evidence, recommended owner, requested action, validation criteria.

These filenames are examples. A ticket comment is acceptable when the repo or ops process does not use files; the content requirements still apply.

## Decision Heuristics

- If impact exists now, start at `Active Incident`.
- If impact does not exist now but recurrence risk is real, start at `Watch`.
- If a fix is plausible but not approved, use `Fix Candidate`.
- If another owner controls the next action, use `Handoff`.
- If the signal was wrong, use `False Positive`; if the system recovered without a confirmed fix, use `Self-Resolved`.
- If the issue is accepted, keep it visible as `Known Accepted Issue` with owner and expiry.

## Worked Examples

### Running Pod, Broken Mount

Signal: pod status is Running, but the application-visible mount path fails.

Decision:
- State: `Fix Candidate` if no current user impact; `Active Incident` if workloads are failing.
- Evidence: pod status, mount-path check, workload/user impact check.
- Prohibited: `Resolved`, because Running does not prove the dependency works.
- Next: remediation ladder and rollback plan before any mutation.

### Recovered but Recurring Alert

Signal: management plane recheck is healthy, but the alert recurs daily.

Decision:
- State: `Watch`.
- Evidence: healthy current check plus recurrence timestamps.
- Prohibited: cluster writes and early closure as fixed.
- Next: set recurrence threshold, owner, recheck window, and promotion criteria.

### Accepted Known Risk

Signal: a known legacy endpoint emits noise during maintenance windows.

Decision:
- State: `Known Accepted Issue`.
- Evidence: owner acceptance, window, affected service boundary, expiry date.
- Prohibited: suppressing unrelated alerts or removing visibility.
- Next: label/suppress from active incident count only inside the accepted boundary.
