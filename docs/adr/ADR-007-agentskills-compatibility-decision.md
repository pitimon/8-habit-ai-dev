# ADR-007: NO-GO on agentskills.io Frontmatter Migration

**Status**: Accepted
**Date**: 2026-04-11
**Decision type**: On-the-Loop (architecture / format standard adoption)
**Issue**: [#91](https://github.com/pitimon/8-habit-ai-dev/issues/91)
**Research brief**: [`guides/agentskills-compatibility-eval.md`](../../guides/agentskills-compatibility-eval.md)
**Related**: ADR-004 (wiki-as-artifact), ADR-006 (superpowers deferral) — both are precedents for format/adoption decisions

## Context

Issue #91 investigated whether `8-habit-ai-dev` should migrate its skill frontmatter from Claude Code-specific fields (`prev-skill`, `next-skill`, `user-invocable`, `argument-hint`) to the open [agentskills.io](https://agentskills.io) standard. The stated goal was **cross-agent portability** — enabling the plugin's skills to run in Cursor, VS Code/Copilot, Gemini CLI, OpenHands, and the 30+ other tools that adopted the standard.

The plugin currently uses 5 non-standard frontmatter fields across 16 skills. A full comparison of current fields vs the spec is in [`agentskills-compatibility-eval.md` §Audit Results](../../guides/agentskills-compatibility-eval.md#audit-results--current-frontmatter-vs-agentskillsio-spec).

## Options Considered

### Option A: Keep as-is (status quo)

- **Description**: No changes. Continue using `prev-skill`/`next-skill` as top-level frontmatter fields and `allowed-tools` as a YAML array.
- **Pro**: Zero migration cost. DAG validator and 3 test suites continue passing (443 checks). Workflow chain is fully enforced.
- **Con**: Spec non-compliance. Individual skills cannot be reused in non-Claude-Code tools.

### Option B: Full migrate to `metadata.*`

- **Description**: Move `prev-skill`/`next-skill` into the spec's optional `metadata:` field. Rewrite `allowed-tools` to the spec's space-separated string format. Remove or relocate VS Code extensions (`argument-hint`, `user-invocable`).
- **Pro**: Full agentskills.io spec compliance. Other tools can discover and load individual skills via `name`/`description`.
- **Con**: **Other tools still ignore `metadata.*`** — VS Code docs confirm no custom metadata parsing; Gemini CLI confirms only `name` and `description` are read. The 7-step chain loses its enforcement mechanism. Rewrite requires 16 skills × frontmatter edits + 3 validators × YAML-nesting logic + DAG validator re-implementation in pure bash. Violates the repo's "no build system, no dependencies" design principle (would need either a bash YAML parser or a new runtime dependency).

### Option C: Hybrid (dual-source — keep top-level + duplicate in `metadata.*`)

- **Description**: Add `metadata.prev-skill`/`metadata.next-skill` alongside the existing top-level fields. Other tools get the metadata copy; our validators continue reading the top-level copy.
- **Pro**: Existing validators unchanged. Some spec compliance.
- **Con**: Still has 4 non-compliant top-level fields → not fully compliant. Dual-source drift risk: top-level and `metadata.*` can diverge silently over edits. Delivers the same "no chain enforcement elsewhere" outcome as Option B, at lower cost but with ongoing maintenance overhead.

## Decision

**Option A — Keep as-is.** No frontmatter migration in v2.6.0 or subsequent versions until a [future trigger](#future-triggers--when-to-revisit) fires.

### Rationale

1. **Migration does not deliver its promised value.** The goal ("cross-agent portability") is only partially achievable — other tools would discover individual skills but **would not enforce the 7-step chain**, because no tool outside Claude Code parses `metadata.prev-skill`/`metadata.next-skill`. This is confirmed by VS Code's documented field list and Gemini CLI's documented parsing behavior, and was already flagged in Issue #91's Validation Gate.

2. **The 7-step workflow chain is the plugin's primary value proposition.** Individual skills (research, review, reflect, etc.) exist in many plugins. What makes 8-habit-ai-dev distinct is the *enforced chain* between them — prev-skill/next-skill symmetric edges validated by a DAG validator. Options B and C trade real enforcement for documented convention: a net loss.

3. **Empirical evidence.** A hands-on sandbox test rewrote one skill's frontmatter to place `prev-skill`/`next-skill` under `metadata:`. The DAG validator returned 2 FAIL ("missing prev-skill in frontmatter", "missing next-skill in frontmatter") because its line-anchored regex (`sed -n '/^prev-skill:/'`) cannot reach indented nested fields. Full details in [`agentskills-compatibility-eval.md` §Audit Results](../../guides/agentskills-compatibility-eval.md#audit-results--current-frontmatter-vs-agentskillsio-spec).

4. **Cost-benefit is unfavorable.** Full migration (Option B) requires 16 skills × rewrite + 3 validators × nested-YAML parsing re-implementation + documentation updates + release coordination. Even the cheaper hybrid (Option C) requires 16 duplicated-field edits and introduces drift risk — for identical user-facing outcomes (individual-skill discoverability, no chain enforcement elsewhere).

5. **Constraint preservation.** Migration violates the repo's "no build system, no dependencies" design principle (see [CLAUDE.md §What This Is](../../CLAUDE.md)). A bash YAML nested-field parser is fragile; adding Python/Node tooling contradicts the plugin's pure-markdown philosophy.

## Consequences

**Positive:**

- Zero code/structure changes required. v2.6.0 ships with 443/443 validator checks still green.
- The 7-step chain remains enforceable via the DAG validator — no degradation of core value.
- Future decisions have a clear precedent: format adoption is evaluated against *delivered value*, not *claimed portability*.

**Negative / costs:**

- Individual skills remain Claude Code-only. Users on Cursor, Gemini CLI, VS Code Copilot, etc. cannot load a single skill from this plugin. This is accepted because chain-less individual skills would be a different (lesser) product.
- The `allowed-tools` format mismatch (our YAML array vs spec's space-separated string) is not resolved by this ADR. Tracked separately in case spec compliance of individual fields becomes a priority — see §Separately Actionable in the research brief.
- We remain out-of-step with an open standard we philosophically align with. This is a reputational/positioning cost accepted in exchange for the functional guarantee.

**Follow-up actions:**

- No code changes. This ADR documents the decision; the research brief documents the evidence.
- Close Issue #91 as resolved with NO-GO + link to this ADR and the research brief.

## Future Triggers — When to Revisit

Revisit this decision if **any** of the following occurs (same list as in the research brief, repeated here for ADR discoverability):

1. **agentskills.io spec adds native chain/workflow support** (e.g. first-class `prev-skill`, `dependencies`, `workflow` fields). Watch [agentskills.io/specification](https://agentskills.io/specification) changelog.
2. **An adopting tool parses `metadata.*` for workflow logic.** Currently Cursor/VS Code/Gemini CLI do not — re-run cost-benefit if one of them ships support.
3. **User demand for cross-agent use becomes concrete.** Consider a **dual-artifact strategy**: a separate repo publishing standalone versions of individual skills to agentskills.io registries, while this plugin remains the chained workflow for Claude Code. Avoids compromising either use case.
4. **The DAG validator is rewritten in a proper language** (Node/Python/Go) as part of a larger refactor. Nested-YAML parsing cost drops to near-zero and the Option B calculation flips.

## The Lesson (H5 Understand First, applied to format standards)

**A standard's reach is measured by what adopting tools actually parse, not by their logo list.** The agentskills.io spec allows arbitrary `metadata.*` keys — but "allows" and "parses" are different things. VS Code's docs clearly list 8 parsed fields and exclude custom metadata from the parsing contract. Gemini CLI's docs explicitly say "these are the only fields that [it] reads to determine when the skill gets used." The 30-tool adoption count is real; the chain-enforcement portability is not.

This lesson generalizes: **when evaluating a standard for migration, enumerate what each adopting tool *actually* does with each field, not what the spec *permits*.** The gap between permitted and parsed is where portability claims go to die.

## References

- **agentskills.io specification**: [agentskills.io/specification](https://agentskills.io/specification) — core frontmatter fields (name, description, license, compatibility, metadata, allowed-tools)
- **VS Code agent-skills docs**: [code.visualstudio.com/docs/copilot/customization/agent-skills](https://code.visualstudio.com/docs/copilot/customization/agent-skills) — VS Code extension fields (argument-hint, user-invocable, disable-model-invocation); no custom metadata parsing documented
- **Gemini CLI skill docs**: [geminicli.com/docs/cli/creating-skills](https://geminicli.com/docs/cli/creating-skills/) — confirms only `name` and `description` are parsed for skill activation
- **Research brief**: [`guides/agentskills-compatibility-eval.md`](../../guides/agentskills-compatibility-eval.md) — full 11-finding Deep + Compare research brief with comparison matrix, audit table, and Source Verification Report (verified by `8-habit-ai-dev:research-verifier` agent)
- **DAG validator source**: [`tests/test-skill-graph.sh`](../../tests/test-skill-graph.sh) — chain-edge extraction regex at lines 36-37 (empirical test target)
- **Structure validator source**: [`tests/validate-structure.sh`](../../tests/validate-structure.sh) — 5 check blocks requiring top-level `prev-skill`/`next-skill`/`allowed-tools` (lines 37, 115, 143, 157, 221)
- **Issue #91**: [pitimon/8-habit-ai-dev#91](https://github.com/pitimon/8-habit-ai-dev/issues/91) — research-only evaluation mandate
- **Related ADRs**: [ADR-005](./ADR-005-eu-ai-act-compliance-toolkit.md) (plugin boundary discipline — precedent for "don't adopt what we can't enforce"), [ADR-006](./ADR-006-audience-honesty-and-superpowers-deferral.md) (H5 "read the peer source before claiming parity" — same lesson pattern applied here to a format spec instead of a peer plugin)