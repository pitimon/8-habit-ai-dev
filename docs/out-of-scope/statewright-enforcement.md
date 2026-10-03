# Out of scope: statewright-style runtime enforcement

**Status**: Out of scope (recorded 2026-10-03, v2.21.51)
**Source**: [statewright/statewright](https://github.com/statewright/statewright), reviewed at commit `2426f75`

## What it is

statewright is a state-machine guardrail engine for coding agents ("agents are suggestions, states are laws"). Each state declares `allowed_tools`, `allowed_commands`, `max_edit_lines`, guards, and `requires_approval`; hooks deny tool calls that the current state does not allow. It ships a Rust engine (Apache-2.0), an MCP gateway (FSL-1.1, converting to Apache-2.0 in 2029), a hosted cloud, and a patent pledge whose terms require a commercial licence for multi-team or organization-wide self-hosted deployments (`PATENTS.md` clause (d)). Its benchmark claim (2/10 → 10/10 on five SWE-bench tasks) is self-reported on a subset and has not been independently verified.

## Why it stays out

[ADR-021](../adr/ADR-021-dynamic-workflow-positioning.md) keeps this plugin as workflow discipline, not runtime enforcement. Denying tool calls, approval routing, and state machines belong in companion tooling such as [claude-governance](https://github.com/pitimon/claude-governance), the same boundary applied to gstack in [ADR-026](../adr/ADR-026-external-prior-art-audit-karpathy-gstack.md). The engine also adds a binary, a cloud dependency, and licence terms; this plugin is dependency-free for consumers.

## Already native

| statewright idea | Native equivalent |
| --- | --- |
| Phase states (planning → implementing → testing) | 7-step workflow, `/workflow` |
| Research template (scoping → verifying) | `/research` process and Deep-mode verifier |
| `requires_approval` gates | Human decision points in `/design`, `/cross-verify` holds |

## Adopted as discipline

- **Evidence packet → Owner note.** statewright approvals carry a summary, checklist, and artifacts so a reviewer can decide without the agent's turn history. `/review-ai` now ends with a one-line Owner note (five fields) written from repository artifacts alone and confirmed by the human merger.
- **`ToolSearch` exemption** is cited in [`guides/cross-verification.md`](../../guides/cross-verification.md) as independent corroboration of the [#399](https://github.com/pitimon/8-habit-ai-dev/issues/399) real-host rule.

## Revisit when

A user needs hard enforcement: point them to companion tooling. Reopen this record only if ADR-021 is superseded.
