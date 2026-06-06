# Agents working on 8-habit-ai-dev

Start here for Codex, Cursor, Windsurf, Aider, Continue, or any non-Claude agent. Claude Code reads `CLAUDE.md` automatically; everyone else should treat `CLAUDE.md` as reference material, not runtime state.

## Project shape

`8-habit-ai-dev` is a Claude Code and Codex plugin that adds workflow discipline to AI-assisted development: 24 markdown skills across a 7-step workflow grounded in Covey's 8 Habits.

This repo is markdown-only. There is no application runtime, build system, dependency install, or generated code path in normal development. Skills are read-only guidance: they tell an agent how to approach work, but they do not execute edits by themselves.

## Read first

1. `AGENTS.md` - this operating protocol.
2. `SPEC.md` - project digest and fast session re-entry.
3. `DOMAIN.md` - invariants, safety boundaries, and validation expectations.
4. `CLAUDE.md` - Claude Code architecture reference and skill authoring conventions.
5. `skills/RESOLVER.md` - phrase-to-skill dispatcher; read the cited `skills/<name>/SKILL.md` before using a skill.
6. `docs/compatibility-matrix.md` and `docs/codex-integration.md` - Codex and non-Claude runtime boundaries.
7. `llms.txt` - flat documentation map for LLM indexing.

## Codex contract

- Install with `codex plugin marketplace add pitimon/8-habit-ai-dev` then `codex plugin add 8-habit-ai-dev@pitimon-8-habit-ai-dev`.
- Use `.codex-plugin/plugin.json` and `.agents/plugins/marketplace.json` as Codex packaging surfaces.
- Do not assume Claude hooks in `hooks/` run under Codex. Codex gets the same markdown skills, not Claude session hooks or hook-based verbosity adaptation.
- Keep any future Codex automation as an adapter around routing, reading skills, validation, release reconciliation, and curated memory deposit.
- Do not add policy enforcement, irreversible-action authorization, compliance certification, or dynamic orchestration engines to this plugin core. Those belong in companion tooling such as `claude-governance`.

## Hard boundaries

- Do not delete or overwrite `CLAUDE.md`.
- Do not put secrets, tokens, credentials, private keys, or customer-sensitive raw data in repo docs, skills, examples, tests, or memory notes.
- Preserve the plugin identity: workflow discipline, not runtime enforcement.
- Keep skill content portable markdown. Do not add platform-specific syntax to every skill unless a new ADR accepts that coupling.
- If a change touches consumer-facing doctrine or packaging, check the version-sync convention in `CLAUDE.md` and `CONTRIBUTING.md`.

## Common actions

- Research a choice: read `skills/research/SKILL.md`.
- Plan feature behavior: read `skills/requirements/SKILL.md`.
- Decide architecture: read `skills/design/SKILL.md`.
- Audit AI-generated work: read `skills/review-ai/SKILL.md`.
- Check security risks: read `skills/security-check/SKILL.md`.
- Preserve a durable lesson: use `/reflect`; Codex-created durable project notes go to the configured Obsidian vault, not to `claude-mem`.

## Memory policy

Use `claude-mem` as read-only historical agent memory when available. Write new durable project notes to the Obsidian vault at `/Volumes/ipv9-OneT/ObsidianVault`, preferably under `Claude-Mem/Projects/` or generated exports under `Claude-Mem/Exports/`. Treat `Codex/Inbox/` captures as raw evidence; promote only concise summaries, decisions, and runbooks.
