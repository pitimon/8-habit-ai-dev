# PRD Template

Output template for `/requirements` (Step 1).

> **OPTIONAL ID linkage** (recommended when persisting via `--persist <slug>`): Prefix each EARS criterion with `FR-NNN:` (e.g., `1. [Event-driven] FR-001: When user submits...`). When all artifacts in a `docs/specs/<slug>/` directory use ID markers, `/consistency-check` runs deterministic Coverage and Inconsistency passes. See [ADR-013](../../docs/adr/ADR-013-spec-persistence-opt-in.md).

## Feature: [Name]

**What**: [1-2 sentences — what are we building?]

**Why**: [Problem it solves — why does this matter?]

**Who**: [Target user or stakeholder]

## Scope

**In scope**:

- [Bullet list of included functionality]

**Out of scope**:

- [Bullet list of explicitly excluded items]

## Success Criteria

1. [Verifiable condition — e.g., "API returns 200 with sorted results"]
2. [Verifiable condition]
3. [Verifiable condition]

## Definition of Done

- [ ] [What must be true before this feature is "done"]
- [ ] [Tests pass, docs updated, etc.]

## Constraints

- [Technical, timeline, or business constraints]

## Open Questions

- [Anything unresolved that needs human decision]

<!-- SKILL_OUTPUT:requirements
ears_count: [N]
ears_criteria:
  - "[criterion 1]"
scope_in: "[in-scope description]"
scope_out: "[out-of-scope description]"
primary_user: "[user role]"
risks:
  - "[risk 1]"
success_criteria_count: [N]
END_SKILL_OUTPUT -->
