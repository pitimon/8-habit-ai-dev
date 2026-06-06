# SPEC.md - 8-habit-ai-dev project digest

## Purpose

`8-habit-ai-dev` provides workflow discipline for AI-assisted development through markdown skills. It helps agents and humans move from vague prompts toward researched, specified, reviewed, and monitored work without turning the plugin into a runtime enforcement system.

## Audience

- Claude Code users installing the Claude plugin package.
- Codex users installing the Codex plugin package.
- Other agent users who load markdown instructions manually.
- Maintainers adding or revising skills, habits, guides, ADRs, packaging, and validators.

## Goals

- Keep a portable corpus of 24 markdown skills across the 7-step workflow.
- Preserve the "thin harness, fat skills" architecture.
- Make cross-agent entrypoints explicit through `AGENTS.md`, `llms.txt`, `skills/RESOLVER.md`, and compatibility docs.
- Keep Claude Code and Codex packaging honest about runtime differences.
- Record durable architecture choices in ADRs.
- Validate structure, links, content conventions, skill graph integrity, and packaging drift with shell tests.

## Non-goals

- No runnable application runtime.
- No dependency-managed build system for consumers.
- No policy enforcement gates inside this plugin core.
- No compliance certification engine.
- No irreversible-action authorization layer.
- No dynamic orchestration engine.
- No secrets, credentials, customer-sensitive raw data, or private operational evidence in repo files.

## Key Entry Points

- `AGENTS.md` - cross-agent operating protocol.
- `CLAUDE.md` - Claude Code architecture reference and maintainer conventions.
- `README.md` - user-facing overview and install flow.
- `DOMAIN.md` - invariants, boundaries, and validation expectations.
- `skills/RESOLVER.md` - phrase-to-skill dispatcher.
- `skills/*/SKILL.md` - skill source of truth.
- `docs/compatibility-matrix.md` - runtime capability contract.
- `docs/codex-integration.md` - Codex-specific install and boundary guide.
- `docs/adr/` - architecture decisions.
- `CONTRIBUTING.md` - authoring, testing, and release conventions.
- `.claude-plugin/` - Claude Code package metadata.
- `.codex-plugin/` and `.agents/plugins/marketplace.json` - Codex package metadata.
- `tests/` - validation scripts.

## Workflow

For feature or skill work, route intent through `skills/RESOLVER.md` and load the relevant skill. The core workflow is:

```text
/research -> /requirements -> /design -> /breakdown -> /build-brief -> /review-ai -> /deploy-guide -> /monitor-setup
```

Use only the steps that fit the task. For high-risk or ambiguous changes, add `/cross-verify`, `/security-check`, or `/scrutinize`. For completed learning, use `/reflect` and store durable notes according to the configured memory policy.

## Validation Expectations

Typical documentation, skill, or packaging changes should run:

```bash
bash tests/validate-structure.sh
bash tests/validate-content.sh
bash tests/test-skill-graph.sh
```

Hook behavior changes should also run:

```bash
bash tests/test-verbosity-hook.sh
```

Release work must reconcile the version-bearing files named in `CLAUDE.md` and `CONTRIBUTING.md`, then verify changelog and user-facing docs are current.

## Current State

Last updated: 2026-06-06

Codex support is already native through `.codex-plugin/plugin.json` and `.agents/plugins/marketplace.json`. `AGENTS.md`, `docs/codex-integration.md`, and `docs/compatibility-matrix.md` define that Codex consumes the same markdown skills but does not run Claude hooks.

The repo now has explicit Codex-ready project context files: `DOMAIN.md`, `SPEC.md`, `docs/adr/README.md`, `.codex/README.md`, and `docs/adr/ADR-025-codex-project-context-files.md`. Release `v2.21.2` clarified that source/marketplace validation and installed Codex cache validation have different `plugin -> .` symlink expectations; release `v2.21.3` ships the project context files through the plugin package.
