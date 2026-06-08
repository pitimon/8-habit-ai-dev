# ADR-023: Native Codex Plugin Packaging

**Status**: Accepted
**Amended**: 2026-06-08 by v2.21.10
**Date**: 2026-05-31
**Decision makers**: Pitimon (human) + Codex
**Related**: [ADR-011](./ADR-011-cross-agent-discoverability.md) (non-Claude entry points), [ADR-019](./ADR-019-doctrine-only-scope-refinement.md) (consumer-doctrine versioning), [ADR-022](./ADR-022-spec-driven-development-positioning.md) (tool-agnostic discipline layer)

---

## Context

The plugin already has cross-agent content: `AGENTS.md`, `llms.txt`, `skills/RESOLVER.md`, and 23 markdown-only `skills/*/SKILL.md` files. Codex can consume markdown skills, but it cannot install a Claude Code marketplace package directly. A Codex-native install needs two additional packaging surfaces:

- `.codex-plugin/plugin.json` at the plugin root, with Codex `interface` metadata and `skills: "./skills/"`.
- `.agents/plugins/marketplace.json` so `codex plugin marketplace add pitimon/8-habit-ai-dev` can discover the plugin and `codex plugin add 8-habit-ai-dev@pitimon-8-habit-ai-dev` can install it. Codex marketplace entries must point at a child path, so this repo exposes `./plugin` as the child source.

The implementation must preserve the core boundary: this repository provides workflow discipline, not runtime enforcement. Claude-specific hooks remain Claude packaging; Codex packaging exposes the same read-only markdown skills.

## Options Considered

### Option A - Document manual skill loading only

- **Pro**: No new packaging surface.
- **Con**: Users cannot install the plugin through Codex's marketplace flow; every install is bespoke.

### Option B - Add `.codex-plugin/plugin.json` only

- **Pro**: Makes the repo a valid Codex plugin archive when installed from a direct plugin path.
- **Con**: Does not support marketplace discovery from the Git repo, which is the release path users expect.

### Option C - Add Codex plugin manifest + Codex marketplace file (chosen)

- **Pro**: Supports Codex's native two-step flow: add marketplace, then add plugin. Keeps the existing Claude package intact. No skill rewrite.
- **Con**: Adds one more versioned manifest and one more packaging surface that validators must keep in sync.

## Decision

Choose Option C.

Ship:

- `.codex-plugin/plugin.json` with version, author, repository, `skills: "./skills/"`, and Codex `interface` metadata.
- `.agents/plugins/marketplace.json` with marketplace name `pitimon-8-habit-ai-dev`, plugin name `8-habit-ai-dev`, and source path `"./plugin"`.
- `plugin/.codex-plugin/plugin.json` plus `plugin/skills/` because the root `.codex-plugin/plugin.json` is still useful for source-level inspection, while Codex marketplace install needs a child source path that contains its own installable skill corpus.
- `disable-model-invocation` declarations on deterministic skills set to `false` for Codex ingestion compatibility. ADR-014 already records the field as decorative for Claude plugin skills until upstream support lands; native Codex packaging cannot ship with `true` because Codex rejects it during skill validation.
- Validator coverage in `tests/validate-structure.sh`:
  - `.codex-plugin/plugin.json` version must match the Claude package version.
  - Codex manifest and marketplace files must exist with required fields.
  - `.codex-plugin/**` and `.agents/plugins/marketplace.json` are treated as consumer-doctrine paths for version-bump enforcement.

## Consequences

Positive:

- Codex users get native install/update ergonomics instead of manually loading individual `SKILL.md` files.
- Claude Code users are unaffected; `.claude-plugin/*` stays in place.
- The plugin's cross-agent promise becomes testable packaging, not only documentation.

Negative / risks:

- The version convention expands from 4 to 6 version-bearing files after v2.21.10: Claude manifest, Claude marketplace, source Codex manifest, child Codex manifest, README, and SELF-CHECK.
- Codex CLI vocabulary currently uses `codex plugin add`, not `codex plugin install`; docs must use the current command to avoid copy-paste failure.
- The v2.17.0 `disable-model-invocation: true` intent marker is neutralized for now to satisfy Codex ingestion. If both Claude Code and Codex later support the field with matching semantics, restore it in a dedicated compatibility PR.

## Self-Check

- [x] No runtime hook or enforcement added.
- [x] Existing skills remain markdown-only and read-only guidance.
- [x] Codex marketplace source path points to `./plugin`, a real child package directory. This amends the original symlink design after Linux Claude Code install failed with `ENOENT: no such file or directory, symlink`.
- [x] Validator checks Codex packaging drift.
- [x] Version bump is included because native Codex install support is consumer-facing.

## Amendment: v2.21.10 Linux Claude Code install compatibility

The original `plugin -> .` symlink satisfied Codex child-source discovery, but it exposed a root self-symlink to Claude Code's package installer. On Linux, a fresh Claude Code install could clone the marketplace successfully and then fail during plugin install with `ENOENT: no such file or directory, symlink`.

v2.21.10 replaces the symlink with a real `plugin/` directory containing the child Codex manifest and packaged skill corpus. Codex still installs through `./plugin`; Claude Code no longer has to materialize a self-referential root symlink.
