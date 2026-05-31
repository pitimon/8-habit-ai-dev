# ADR-024: Codex Runtime Adapter Boundary

**Status**: Accepted
**Date**: 2026-05-31
**Decision makers**: Pitimon (human) + Codex
**Related**: [ADR-011](./ADR-011-cross-agent-discoverability.md), [ADR-019](./ADR-019-doctrine-only-scope-refinement.md), [ADR-021](./ADR-021-dynamic-workflow-positioning.md), [ADR-023](./ADR-023-codex-native-packaging.md)

---

## Context

`v2.19.0` added native Codex packaging. That made the same markdown skills installable in Codex, but it did not make Claude Code runtime features automatically available in Codex. The project needs a clear next boundary before adding more Codex-specific behavior.

The risk: a "make Codex fully integrated" request could accidentally turn `8-habit-ai-dev` from a portable markdown workflow-discipline plugin into a runtime automation system. That would conflict with the established plugin boundary: discipline here, enforcement and runtime engines in companion systems.

## Options Considered

### Option A - Keep only the v2.19.0 package

- **Pro**: No new docs or maintenance.
- **Con**: Users may infer false feature parity between Claude Code and Codex, especially around hooks.

### Option B - Port Claude hooks directly to Codex

- **Pro**: More runtime behavior in Codex.
- **Con**: Couples core skills to one runtime, risks incompatible semantics, and moves toward automation inside a markdown-discipline plugin.

### Option C - Document compatibility + define adapter boundary (chosen)

- **Pro**: Makes Codex support honest and operational. Keeps core skills portable. Leaves room for a future optional adapter without claiming runtime parity.
- **Con**: Less automated than a hook port; users must still understand the boundary.

## Decision

Choose Option C.

Ship:

- `docs/compatibility-matrix.md` documenting which capabilities work in Claude Code, Codex, and other agents.
- `docs/codex-integration.md` documenting the Codex runtime contract and recommended flow.
- Validator coverage that pins the compatibility docs and their README/AGENTS/llms entrypoints.

If a Codex runtime adapter is added later, it must remain outside the markdown skill core. Its acceptable scope is orchestration of reading, routing, validation, release reconciliation, and curated memory deposit. It must not become policy enforcement, compliance certification, irreversible-action authorization, or a dynamic workflow engine.

runtime enforcement remains outside `8-habit-ai-dev`; this ADR defines an adapter boundary, not an enforcement boundary expansion.

## Consequences

Positive:

- Codex support is clear without overstating parity with Claude Code.
- The shared skill corpus remains runtime-neutral.
- Future adapter work has an explicit boundary.
- Support burden drops because hooks, packaging, and enforcement are separated.

Negative:

- This is still documentation and validation, not full runtime automation.
- Codex users must understand that Claude hooks are not active in Codex.

## Self-Check

- [x] No runtime hook was added.
- [x] No skill was rewritten for Codex-specific syntax.
- [x] The compatibility contract explicitly says Claude hooks are not Codex runtime behavior.
- [x] Enforcement remains outside this plugin.
- [x] Future adapter scope is bounded before implementation begins.
