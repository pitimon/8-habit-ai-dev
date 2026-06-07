# Codex Integration Guide

This guide explains how to use `8-habit-ai-dev` from Codex without overstating runtime parity with Claude Code.

## Install

```bash
codex plugin marketplace add pitimon/8-habit-ai-dev
codex plugin add 8-habit-ai-dev@pitimon-8-habit-ai-dev
```

Verify with:

```bash
codex plugin list
```

## Update

Codex installs plugins from configured marketplace snapshots. Refresh the Git marketplace snapshot before checking for current plugin metadata:

```bash
codex plugin marketplace upgrade pitimon-8-habit-ai-dev
codex plugin list
```

If a local cache appears stale, reinstall from the refreshed snapshot:

```bash
codex plugin remove 8-habit-ai-dev@pitimon-8-habit-ai-dev
codex plugin add 8-habit-ai-dev@pitimon-8-habit-ai-dev
```

## Validation Contexts

`tests/validate-structure.sh` is valid in both the source/marketplace checkout and the installed Codex cache, but one packaging invariant is context-specific:

- In source or marketplace snapshots, `plugin -> .` must exist because `.agents/plugins/marketplace.json` points at `./plugin`.
- In the Codex installed cache under `~/.codex/plugins/cache/...`, the install root is already the plugin root, so Codex may omit the `plugin -> .` symlink. The validator treats that as expected installed-cache shape, not as a packaging regression.

Run source/marketplace validation when checking publishability. Run installed-cache validation when checking the shipped user artifact.

## Codex Runtime Contract

Codex integration promises:

- Codex can install the plugin through the native marketplace flow.
- Codex can load the same 24 markdown skills from `skills/`.
- Codex should start from `AGENTS.md`, then use `skills/RESOLVER.md` to select a skill.
- Codex and other tools may read `docs/data/skills.json` as generated discovery metadata.
- Codex should treat `CLAUDE.md` as architecture reference, not as automatically loaded runtime state.
- Codex should treat Obsidian or other memory systems as external curated memory, not as the plugin's internal state.

Codex integration does not promise:

- Claude hook feature parity.
- automatic verbosity adaptation as a required Codex runtime feature.
- runtime enforcement gates.
- policy authorization.
- dynamic sub-agent orchestration.
- compliance framework execution.

Those belong in companion tooling or a future adapter layer.

Compatibility note: if Codex invokes this package's `SessionStart` hook, `hooks/session-start.sh` emits Codex-compatible JSON with the existing reminder under `hookSpecificOutput.additionalContext`. Claude/default runs still emit the markdown reminder directly. This is a narrow hook-output adapter, not a general runtime enforcement layer.

## Recommended Codex Flow

1. Read `AGENTS.md` for the operating protocol.
2. Read `skills/RESOLVER.md` for intent-to-skill routing.
3. Optionally inspect `docs/data/skills.json` for a machine-readable skill list.
4. Load the cited `skills/<name>/SKILL.md`.
5. Follow the skill's process and Definition of Done.
6. For high-risk work, run `/cross-verify`, `/review-ai`, `/security-check`, or `/scrutinize` as appropriate.
7. For release work, reconcile GitHub Releases and git tags before updating release docs.

## Optional Adapter Layer

If Codex runtime automation is needed later, keep it outside the markdown skill core. Acceptable adapter responsibilities:

- suggest a skill from user intent,
- open the relevant `SKILL.md`,
- remind the user to run review before commit,
- run repository validators,
- reconcile releases,
- write curated project memory after completed work.

Adapter responsibilities that do not belong in this plugin core:

- policy enforcement,
- secret scanning gates,
- irreversible-action authorization,
- runtime orchestration engines,
- compliance certification checks.

## Source of Truth

| Topic | Source of truth |
| --- | --- |
| Skill behavior | `skills/*/SKILL.md` |
| Skill routing | `skills/RESOLVER.md` |
| Generated skill catalog | `docs/data/skills.json` |
| Cross-agent entrypoint | `AGENTS.md` |
| Claude Code architecture | `CLAUDE.md` |
| Codex packaging | `.codex-plugin/plugin.json` and `.agents/plugins/marketplace.json` |
| Official releases | GitHub Releases + git tags |
| Durable project memory | curated Obsidian notes, if configured |

## Related

- [Runtime Compatibility Matrix](compatibility-matrix.md)
- [ADR-023: Native Codex Plugin Packaging](adr/ADR-023-codex-native-packaging.md)
- [ADR-024: Codex Runtime Adapter Boundary](adr/ADR-024-codex-runtime-adapter-boundary.md)
