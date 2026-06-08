# Step 2 · Design

`/design` turns requirements into architecture options and records the human decision. It is the step that keeps AI from silently choosing the architecture.

| Field | Value |
| --- | --- |
| Command | `/design [requirements or context]` |
| Habit | H8 Find Your Voice |
| Previous | [Step 1 · Requirements](Step-1-Requirements) |
| Next | [Step 3 · Breakdown](Step-3-Breakdown) |

## Use This When

- The change affects architecture, persistence, API contracts, security boundaries, or deployment shape.
- More than one viable implementation path exists.
- The decision should be reviewable later.

## Skip When

- The implementation path is already decided and local.
- The work is mechanical and does not change behavior or structure.

## Output

- Key decisions.
- At least two options for meaningful decisions.
- Trade-offs, risks, and constraints.
- Selected pass level: `Scan`, `Focus`, or `Full`.
- Load-bearing claims with label, evidence strength, and `Verify first: Yes/No`.
- Architecture-impacting questions prioritized as `Blocking`, `Important`, or `Useful`.
- Recommended option, with the human decision made explicit.
- ADR guidance when the decision is durable.

> [!IMPORTANT]
> Architecture decisions stay human-led. The skill structures options; it does not transfer accountability to the model.

## Example Claim Discipline

Use the smallest safe design pass, then make uncertainty visible before decisions become implementation constraints.

```markdown
## Selected pass

**Pass level**: Focus
**Why**: The change touches one API boundary and one persistence table.
**Promotion rule**: Stay Focus unless evidence shows authentication, deployment, or 3+ modules are affected.

## Architecture claims

| Claim | Label | Evidence strength | Source or basis | Verify first |
| ----- | ----- | ----------------- | --------------- | ------------ |
| Existing orders persist in PostgreSQL | Confirmed | Direct | `schema.sql`, `orders` table | No |
| Checkout API owns order creation | Inferred | Inferred | Route and service names align, but no ADR says ownership | Yes |
| New retry queue should be a separate worker | Proposed | Assumed | Design option pending human approval | Yes |

## Questions

| Priority | Question | Why it matters |
| -------- | -------- | -------------- |
| Blocking | Who owns failed payment retries? | Ownership changes service boundary and incident handoff |
| Important | Is 24h retry retention enough? | Changes storage and alerting requirements |
| Useful | Should dashboard copy say retry or recovery? | Can be deferred to implementation copy review |
```

Use Mermaid only when the diagram clarifies a boundary, data flow, workflow, module relationship, or ownership. Every node should trace to evidence, assumption, or proposal; uncertain nodes should be labeled instead of drawn as confirmed fact.

## Handoff

`/breakdown` should receive the selected design, rejected alternatives, constraints, and any sequencing requirements.

## See Also

- [Workflow Overview](Workflow-Overview)
- [Architecture](Architecture)
- [Habits Reference](Habits-Reference#habit-8-find-your-voice)
- [Source skill](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/design/SKILL.md)
