# ADR Template

Output template for `/design` (Step 2). Based on MADR (Markdown Any Decision Records) format.

> **OPTIONAL ID linkage** (recommended when persisting via `--persist <slug>`): Number decisions as `Decision-N` (e.g., `### Decision-4: Database choice`) and cite covered PRD requirements as `Decision-N covers: FR-001, FR-003`. When all artifacts in a `docs/specs/<slug>/` directory use ID markers, `/consistency-check` runs deterministic Coverage and Inconsistency passes. See [ADR-013](../../docs/adr/ADR-013-spec-persistence-opt-in.md).

## ADR-NNN: [Decision Title]

**Status**: [Proposed | Accepted | Deprecated | Superseded]

**Date**: [YYYY-MM-DD]

**Decision maker**: [Human — not AI]

## Context

[What is the issue? Why do we need to make this decision?]

## Architecture Claims (Optional)

Use this table when claims are load-bearing, uncertain, or important for future handoff. Delete this section when the decision is simple and every claim is already obvious from the context.

| Claim | Label | Evidence strength | Source or basis | Verify first |
| ----- | ----- | ----------------- | --------------- | ------------ |
| [Claim] | [Confirmed, Inferred, Proposed, Assumed, Unknown, Requires approval] | [Direct, Inferred, Assumed, Unverified] | [File, doc, command, user statement, or assumption] | [Yes or No] |

## Options Considered

### Option A: [Name]

- **Description**: [1-2 sentences]
- **Pro**: [Advantages]
- **Con**: [Disadvantages]

### Option B: [Name]

- **Description**: [1-2 sentences]
- **Pro**: [Advantages]
- **Con**: [Disadvantages]

## Decision

[Which option was chosen and WHY — the rationale, not just the choice]

## Decisions Requiring Approval (Optional)

Use this section when one or more decisions still require explicit human acceptance before implementation.

| Decision or question | Priority | Required approver | Default if unanswered |
| -------------------- | -------- | ----------------- | --------------------- |
| [Decision or question] | [Blocking, Important, Useful] | [Human role/name] | [No default, or assumption to use temporarily] |

## Consequences

- [What changes as a result of this decision]
- [What new constraints does this introduce]
- [What follow-up actions are needed]
