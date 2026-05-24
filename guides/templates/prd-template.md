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

> **Numeric-ceiling FR example (calibrated)** — per `skills/requirements/SKILL.md` step 4a, when a criterion sets an upper bound on lines/words/characters of a markdown artifact, calibrate the ceiling against the closest precedent (+20%), not against an aspirational round number:
>
> _Good_: `FR-007: ADR-XXX.md body ≤180 lines, excluding frontmatter (calibrated from ADR-017 precedent of ~150 lines).`
> _Bad_: `FR-007: ADR-XXX.md body ≤50 lines.` (Contaminates `/consistency-check` once the artifact lands at its actual required size — see [#237](https://github.com/pitimon/8-habit-ai-dev/issues/237).)

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
