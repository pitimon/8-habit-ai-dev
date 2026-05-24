## Summary

<!-- 1-3 bullet points: what changed and why. -->

## Test plan

- [ ] `bash tests/validate-structure.sh` passes
- [ ] `bash tests/validate-content.sh` passes (if content/wiki/links changed)
- [ ] Related skill/agent invoked manually if behavior changed

## Refs

<!-- e.g. Refs #123, Closes #456 -->

<details>
<summary>Skill PR? Optional Falsifiable Contract fields (ADR-018 Edge #2)</summary>

If this PR adds or substantially modifies a skill, fill these in so the next `SKILL-EFFECTIVENESS.md` review can validate the prediction. Optional — no runtime enforcement. Non-skill PRs ignore this section.

- **predicted_uses**: brief list of session types or scenarios where this skill should help (e.g., "post-mortem of failed deploy", "new feature requirements gathering").
- **validation_window**: number of sessions (default `30`) after which absence of citation in `/reflect` Q6 → `SKILL-EFFECTIVENESS.md` becomes a deprecation signal.
- **risk_skills**: existing skills this might overlap or displace, if any.

These fields feed the next [`SKILL-EFFECTIVENESS.md`](../SKILL-EFFECTIVENESS.md) tally review. See [ADR-018](../docs/adr/ADR-018-memory-layer-activation.md) for rationale (memory-layer activation, lightweight Falsifiable Contract per AHE paper). Automated validation/rollback belongs in `claude-governance` per plugin boundary.

</details>
