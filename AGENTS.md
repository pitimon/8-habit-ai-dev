# Agents working on 8-habit-ai-dev

Start here for Codex, Cursor, Windsurf, Aider, Continue, or any non-Claude agent. Claude Code reads `CLAUDE.md` automatically; everyone else should treat `CLAUDE.md` as reference material, not runtime state.

## Project shape

`8-habit-ai-dev` is a Claude Code and Codex plugin that adds workflow discipline to AI-assisted development: 24 markdown skills across a 7-step workflow grounded in Covey's 8 Habits.

This repo is markdown-first and dependency-free for consumers. There is no application runtime or package-managed build; validation is implemented by Bash scripts, with one dependency-free Node.js catalog generator. Skills are read-only guidance: they tell an agent how to approach work, but they do not execute edits by themselves.

## Read first

1. `AGENTS.md` - this operating protocol.
2. `SPEC.md` - project digest and fast session re-entry.
3. `DOMAIN.md` - invariants, safety boundaries, and validation expectations.
4. `CLAUDE.md` - Claude Code architecture reference and skill authoring conventions.
5. `skills/RESOLVER.md` - phrase-to-skill dispatcher; read the cited `skills/<name>/SKILL.md` before using a skill.
6. `docs/compatibility-matrix.md` and `docs/codex-integration.md` - Codex and non-Claude runtime boundaries.
7. `llms.txt` - flat documentation map for LLM indexing.

## Repository layout

- `skills/*/SKILL.md` is the portable skill source of truth; `habits/`, `guides/`, and `rules/` provide references and doctrine.
- `hooks/` contains Claude Code hooks; `agents/` contains read-only reviewer definitions.
- `.claude-plugin/`, `.codex-plugin/`, and `.agents/plugins/marketplace.json` are packaging surfaces.
- `plugin/` is a real, tracked Codex child-package mirror. `tests/` is not mirrored.
- `docs/data/skills.json` is generated from skill frontmatter; `docs/adr/` stores architecture decisions; `docs/wiki/` is the wiki source published by CI.

## Validation commands

Run from the repository root with Bash; the scripts use process substitution, so `sh` is not supported:

```bash
bash tests/validate-structure.sh
bash tests/test-skill-graph.sh
bash tests/validate-content.sh
bash tests/test-verbosity-hook.sh
bash tests/test-pre-commit-hook.sh
bash tests/test-cross-verify-release-gates.sh
bash tests/test-hermes-tap-links.sh
bash tests/ci-local.sh
```

`bash tests/ci-local.sh` runs the exact seven-script CI validation set (keep it in lock-step with `.github/workflows/validate.yml`). `validate-content.sh` checks release-doc freshness against git tags, so shallow clones can produce incomplete results; CI uses full tag history. When skill metadata or discovery docs change, also run `node scripts/generate-skill-catalog.js --check`; regenerate with `node scripts/generate-skill-catalog.js`.

## Codex contract

- Install with `codex plugin marketplace add pitimon/8-habit-ai-dev` then `codex plugin add 8-habit-ai-dev@pitimon-8-habit-ai-dev`.
- Use `.codex-plugin/plugin.json` and `.agents/plugins/marketplace.json` as Codex packaging surfaces.
- Do not assume Claude hooks in `hooks/` run under Codex. Codex gets the same markdown skills, not Claude session hooks or hook-based verbosity adaptation.
- Keep any future Codex automation as an adapter around routing, reading skills, validation, release reconciliation, and curated memory deposit.
- Do not add policy enforcement, irreversible-action authorization, compliance certification, or dynamic orchestration engines to this plugin core. Those belong in companion tooling such as `claude-governance`.

## Hermes contract

- Hermes has no plugin manifest layer. It discovers skills via its Skills Hub tap: `hermes skills tap add pitimon/8-habit-ai-dev`, then `hermes skills install pitimon/8-habit-ai-dev/skills/<name>` per skill.
- Every `skills/*/SKILL.md` cross-reference to another repo doc MUST be an absolute `https://github.com/pitimon/8-habit-ai-dev/blob/main/...` URL, never a repo-root-relative `../../` link — Hermes's fetcher fail-closes the ENTIRE skill install on a same-directory link starting with `..` (path-traversal guard, [#386](https://github.com/pitimon/8-habit-ai-dev/issues/386)). Enforced by `tests/test-hermes-tap-links.sh` against both `skills/` and `plugin/skills/`.
- Hermes loads skill content only — no `AGENTS.md`/`CLAUDE.md` doctrine, session hook, or `SessionStart` reminder travels with a tap install.
- `${CLAUDE_PLUGIN_ROOT}`-prefixed load directives (`guides/`, `habits/`, `scripts/`) do not resolve on Hermes — a known functional gap, not yet fixed ([#388](https://github.com/pitimon/8-habit-ai-dev/issues/388)). Do not describe Hermes install as full functional parity with Claude Code/Codex in docs until it closes.

## Conventions and pitfalls

- Skill directories and frontmatter `name` values must match. Preserve frontmatter fields (`user-invocable`, `allowed-tools`, `prev-skill`, `next-skill`) and the required `When to Skip` / `Definition of Done` sections.
- Extract skill frontmatter with bounded `awk`, not `sed | grep | head` under `pipefail`; GNU `sed` can fail with SIGPIPE in Linux CI.
- After editing mirrored root content (`skills/`, `guides/`, `habits/`, `hooks/`, `agents/`, `rules/`, `scripts/`, `docs/`, or listed root files), run `bash scripts/sync-mirror.sh`; review both root and `plugin/` changes. `.codex-plugin/` manifests are intentionally distinct.
- Version-bearing files must stay synchronized: `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`, `.codex-plugin/plugin.json`, `plugin/.codex-plugin/plugin.json`, `README.md`, and `SELF-CHECK.md`.

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
- Preserve a durable lesson: in Claude Code use `/reflect`; in Codex select or mention the `reflect` skill through `/skills`, `$reflect`, or natural-language intent. Codex-created durable project notes go to the configured Obsidian vault, not to `claude-mem`.

## Memory policy

Use `claude-mem` as read-only historical agent memory when available. Write new durable project notes to the Obsidian vault at `/Volumes/ipv9-OneT/ObsidianVault`, preferably under `Claude-Mem/Projects/` or generated exports under `Claude-Mem/Exports/`. Treat `Codex/Inbox/` captures as raw evidence; promote only concise summaries, decisions, and runbooks.
