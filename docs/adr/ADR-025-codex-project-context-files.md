# ADR-025: Codex Project Context Files

**Status**: Accepted
**Date**: 2026-06-01
**Decision makers**: Pitimon (human) + Codex
**Related**: [ADR-018](./ADR-018-memory-layer-activation.md), [ADR-023](./ADR-023-codex-native-packaging.md), [ADR-024](./ADR-024-codex-runtime-adapter-boundary.md)

---

## Context

This repository already supported Claude Code through `CLAUDE.md` and Codex through native packaging plus `AGENTS.md`, `docs/codex-integration.md`, and `docs/compatibility-matrix.md`.

The remaining gap was session ergonomics for Codex and other non-Claude agents. A new session could infer the project shape only by reading several longer files. The project also lacked root-level `DOMAIN.md` and `SPEC.md` files that summarize invariants, safety boundaries, and fast re-entry context.

The change must be non-destructive: `CLAUDE.md` stays intact, Claude-specific behavior remains documented as Claude-specific, and no secrets or private operational data are introduced.

## Options Considered

### Option A - Keep existing docs only

- **Pro**: No new maintenance surface.
- **Con**: Codex sessions still need to reconstruct invariants from multiple files.

### Option B - Move Claude guidance into AGENTS.md

- **Pro**: One entrypoint for all agents.
- **Con**: Breaks the established Claude Code convention and risks overwriting mature guidance.

### Option C - Add lightweight project context files (chosen)

- **Pro**: Preserves `CLAUDE.md`, gives Codex concise local context, and records boundaries in stable files.
- **Con**: Adds docs that must be kept in sync when project identity or runtime boundaries change.

## Decision

Choose Option C.

Add and maintain:

- `DOMAIN.md` for invariants, safety rules, data/security boundaries, and operational constraints.
- `SPEC.md` as the project digest and session re-entry point.
- `docs/adr/README.md` as a local ADR index and authoring convention.
- `.codex/README.md` for repo-local Codex setup notes and hook/config boundaries.
- This ADR to record why these files exist.

Update `AGENTS.md` to point Codex and other non-Claude agents at the new context files while keeping `CLAUDE.md` as reference material.

## Consequences

Positive:

- New Codex sessions can identify the project purpose, invariants, and validation path faster.
- Claude Code guidance is preserved instead of rewritten.
- The difference between Claude hooks and Codex runtime behavior is repeated at the project-entry layer.
- Memory policy is explicit: durable Codex notes go to configured Obsidian project notes, while `claude-mem` remains read-only historical memory when available.

Negative:

- `SPEC.md` can become stale unless maintainers update it after meaningful project shifts.
- Boundary statements now exist in several docs and need consistency checks during future Codex or hook work.

## Validation

- [x] Existing `CLAUDE.md` preserved.
- [x] Existing `AGENTS.md` updated additively for Codex project context.
- [x] `DOMAIN.md`, `SPEC.md`, `docs/adr/README.md`, and `.codex/README.md` added without secrets.
- [x] Runtime enforcement remains outside the markdown skill core.
- [x] Codex hook parity is not claimed.
