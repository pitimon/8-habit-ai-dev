# Production Release-Gate Contract

This guide defines the production-review vocabulary used by `/cross-verify`. It is a read-only evidence and decision framework, not a deployment controller, runtime state machine, approval service, or rollback executor.

## Release states

Use one state that describes the current evidence boundary:

- `PLAN` — change and success criteria are being defined; no mutation has occurred.
- `READY` — pre-deploy evidence, rollback pointer, and required approvals are complete; ready to begin a canary, not proof of release success.
- `CANARY` — the approved mutation has started or completed on the bounded target.
- `OBSERVING` — functional checks ran, but the observation window or economic/quality evidence is incomplete.
- `PROVISIONAL_KEEP` — no rollback trigger is active, but final promotion evidence or owner decision is still open.
- `FINAL_KEEP` — required gates, observation evidence, closure artifact, and owner decision are complete.
- `HOLD` — a blocking failure, missing evidence, or scope mismatch prevents promotion.
- `ROLLBACK` — rollback or mitigation is required because the post-mutation result is unsafe or outside the approved scope.

The normal path is:

```text
PLAN → READY → CANARY → OBSERVING → PROVISIONAL_KEEP → FINAL_KEEP
                                      ↘ HOLD / ROLLBACK
```

A state is a report of evidence, not authorization. The skill does not execute deployment commands and does not grant approval.

## Independent scoring

Keep these results separate. Core score is not the release verdict:

```text
Core checklist: PASS / FAIL / N/A / OPEN_VERIFICATION_DEBT
Adjusted score: PASS / (total - N/A)
Infrastructure gate: PASS / FAIL / N/A / OPEN_VERIFICATION_DEBT
Functional gate: PASS / FAIL / N/A / OPEN_VERIFICATION_DEBT
Economic gate: PASS / FAIL / N/A / OPEN_VERIFICATION_DEBT
Quality gate: PASS / FAIL / N/A / OPEN_VERIFICATION_DEBT
Release verdict: FINAL_KEEP / PROVISIONAL_KEEP / HOLD / ROLLBACK
```

`OPEN_VERIFICATION_DEBT` is not PASS and does not count as PASS in the adjusted score. `N/A` is excluded from the denominator only when the evidence explains why the gate is irrelevant. A high core score cannot override a blocking domain gate.

## Production evidence contract

For runtime-impacting work, record the source/runtime reconciliation:

| Evidence | Required record |
|---|---|
| Source | Git source pin, merged commit, and worktree cleanliness |
| Runtime | Service image, running image label, mounted Config, replicas/update state, health/readiness |
| Safety | Rollback pointer, approved mutation scope, and observed client path |
| Verification | Exact target read-back and unexpected changes |

Before and after mutation, distinguish expected from actual scope:

```text
Expected: LiteLLM image only
Changed: image yes, Config no, routing no, OCX no, replicas no, DB no
Read-back: exact target verified / not verified
```

A successful API or CLI command is not deployment proof until the exact target is read back.

## Conditional domain evidence

Require only the evidence relevant to the change:

- Functional: HTTP/SSE/tool contract and feature behavior.
- Economic: provider raw usage, gateway/SpendLog usage, client-visible usage, accepted/rejected denominator, retry/duplicate classification, and synthetic/health exclusions.
- Quality: paired corpus or explicit `QUALITY_UNKNOWN` with the reason and follow-up checkpoint.
- Data impact: `read-only`, `synthetic provider traffic`, `paid synthetic traffic`, `real-user traffic`, or `persistent DB/state mutation`.
- Test debt: skipped-test count, exact reasons, blocking status, and whether rerun evidence exists.

Synthetic provider traffic may incur cost even when no real-user traffic is involved.

## Closure artifact

`FINAL_KEEP` requires an owner decision record containing:

```text
Decision: PROVISIONAL_KEEP / FINAL_KEEP / HOLD / ROLLBACK
Scope
Evidence links
Accepted limitations
Rollback digest/config
Next observation checkpoint
Owner decision
```

The report must distinguish verified evidence, inference, and unresolved debt. Do not convert `UNKNOWN` or skipped evidence into PASS.
