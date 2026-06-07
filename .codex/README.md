# Repo-local Codex setup

This repo can be used from Codex through native plugin packaging.

## Install and verify

```bash
codex plugin marketplace add pitimon/8-habit-ai-dev
codex plugin add 8-habit-ai-dev@pitimon-8-habit-ai-dev
codex plugin list
```

## Update

Codex currently has no `codex plugin update` command. Refresh the Git marketplace snapshot, then reinstall the plugin from that refreshed snapshot:

```bash
codex plugin marketplace upgrade pitimon-8-habit-ai-dev
codex plugin list
codex plugin remove 8-habit-ai-dev@pitimon-8-habit-ai-dev
codex plugin add 8-habit-ai-dev@pitimon-8-habit-ai-dev
codex plugin list
```

Use `codex plugin marketplace list` if you need to confirm the configured marketplace name.

Packaging files:

- `.codex-plugin/plugin.json`
- `.agents/plugins/marketplace.json`
- `plugin` symlink back to the repo root for Codex marketplace discovery

## Operating flow

1. Read `AGENTS.md`.
2. Read `SPEC.md` for the project digest.
3. Read `DOMAIN.md` for invariants and safety boundaries.
4. Use `skills/RESOLVER.md` to choose the relevant skill.
5. Load the cited `skills/<name>/SKILL.md` before acting.
6. Run validators from `tests/` before commit when docs, skills, packaging, or hooks change.

## Hooks and config boundary

Codex does not run Claude Code hooks from `hooks/`. `hooks/session-start.sh` and `hooks/hooks.json` are Claude Code runtime surfaces only.

Repo-local Codex packaging exposes the markdown skills. It does not provide runtime enforcement, policy authorization, compliance certification, or dynamic orchestration.

User-level Codex configuration and global memory are outside this repo. When a session has the configured memory setup, use `claude-mem` as read-only history and write durable project notes to the Obsidian vault at `/Volumes/ipv9-OneT/ObsidianVault`, preferably under `Claude-Mem/Projects/`, rather than to `claude-mem`.

## Do not store

Do not add secrets, tokens, credentials, private keys, or customer-sensitive raw data to `.codex/`, docs, skills, tests, examples, or memory notes.
