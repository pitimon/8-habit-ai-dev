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
bash tests/test-hermes-skills-guard.sh
bash tests/test-guide-rule-anchors.sh
bash tests/ci-local.sh
```

`bash tests/ci-local.sh` runs the exact CI validation script set (keep it in lock-step with `.github/workflows/validate.yml`). `validate-content.sh` checks release-doc freshness against git tags, so shallow clones can produce incomplete results; CI uses full tag history. When skill metadata or discovery docs change, also run `node scripts/generate-skill-catalog.js --check`; regenerate with `node scripts/generate-skill-catalog.js`.

## Codex contract

- Install with `codex plugin marketplace add pitimon/8-habit-ai-dev` then `codex plugin add 8-habit-ai-dev@pitimon-8-habit-ai-dev`.
- Use `.codex-plugin/plugin.json` and `.agents/plugins/marketplace.json` as Codex packaging surfaces.
- Do not assume Claude hooks in `hooks/` run under Codex. Codex gets the same markdown skills, not Claude session hooks or hook-based verbosity adaptation.
- Keep any future Codex automation as an adapter around routing, reading skills, validation, release reconciliation, and curated memory deposit.
- Do not add policy enforcement, irreversible-action authorization, compliance certification, or dynamic orchestration engines to this plugin core. Those belong in companion tooling such as `claude-governance`.

## Hermes contract

- Hermes has no plugin manifest layer. It discovers skills via its Skills Hub tap: `hermes skills tap add pitimon/8-habit-ai-dev`, then `hermes skills install pitimon/8-habit-ai-dev/skills/<name>` per skill.
- Every `skills/*/SKILL.md` cross-reference to another repo doc MUST be an absolute `https://github.com/pitimon/8-habit-ai-dev/blob/main/...` URL, never a repo-root-relative `../../` link — Hermes's fetcher fail-closes the ENTIRE skill install on a same-directory link starting with `..` (path-traversal guard, [#386](https://github.com/pitimon/8-habit-ai-dev/issues/386)). Enforced by `tests/test-hermes-tap-links.sh` against both `skills/` and `plugin/skills/`.
- `hermes skills install` runs Hermes's static security scanner (`tools/skills_guard.py`) and blocks a community skill on any high finding (refuses on critical, even with `--force`). It matches wording, not behaviour: HTML comments containing `ignore/override/system/secret/hidden`, "print/share … context", or imperative "edit CLAUDE.md" prose all trip it. Keep every skill at verdict `safe`: `tests/test-hermes-skills-guard.sh` runs the real scanner when a local Hermes checkout exists (run it before a release) and a static HTML-comment check in CI.
- Hermes install docs MUST pass `--category` (`hermes skills install …/skills/<name> --category productivity`): Hermes refuses a skill whose name matches an existing category folder, and `research` collides on common Hermes homes ([#409](https://github.com/pitimon/8-habit-ai-dev/issues/409)). Enforced by `tests/test-hermes-tap-links.sh`.
- Hermes loads skill content only — no `AGENTS.md`/`CLAUDE.md` doctrine, session hook, or `SessionStart` reminder travels with a tap install.
- Never document or recommend a Hermes `quick_commands` alias whose name contains one of this repo's skill names (e.g. `research-skill`): the Hermes TUI omits skills from its exact-match map ([hermes-agent#96972](https://github.com/NousResearch/hermes-agent/issues/96972)), so the alias captures the exact `/research` command and the skill silently does nothing. Partly enforced by `tests/test-hermes-tap-links.sh` (YAML alias lines in README/AGENTS/CLAUDE/`docs/`; not prose or `skills/`).
- `${CLAUDE_PLUGIN_ROOT}`-prefixed load directives (`guides/`, `habits/`, `scripts/`) do not resolve on Hermes; every affected `SKILL.md` carries a one-line "Hermes" note with the exact `blob/main` substitution URL ([#388](https://github.com/pitimon/8-habit-ai-dev/issues/388)). New `${CLAUDE_PLUGIN_ROOT}`-prefixed loads must add the same note pattern. Do not describe Hermes install as full functional parity with Claude Code/Codex — it requires the agent to follow the substitution note, not automatic resolution.

## Conventions and pitfalls

- Skill directories and frontmatter `name` values must match. Preserve frontmatter fields (`user-invocable`, `allowed-tools`, `prev-skill`, `next-skill`) and the required `When to Skip` / `Definition of Done` sections.
- Extract skill frontmatter with bounded `awk`, not `sed | grep | head` under `pipefail`; GNU `sed` can fail with SIGPIPE in Linux CI.
- After editing mirrored root content (`skills/`, `guides/`, `habits/`, `hooks/`, `agents/`, `rules/`, `scripts/`, `docs/`, or listed root files), run `bash scripts/sync-mirror.sh`; review both root and `plugin/` changes. `.codex-plugin/` manifests are intentionally distinct.
- Version-bearing files must stay synchronized: `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`, `.codex-plugin/plugin.json`, `plugin/.codex-plugin/plugin.json`, `README.md`, `SELF-CHECK.md`, and the pinned install tag in `docs/openclaw-integration.md` (checked by `tests/test-hermes-tap-links.sh`).
- `skills/*/SKILL.md` has a hard 2000-word cap, enforced by `tests/validate-structure.sh` Check 9 (over both `skills/` and `plugin/skills/`, WARN above 1950) and by `tests/validate-content.sh` F3. Check margin with `wc -w skills/<name>/SKILL.md`, not Python `len(text.split())`, which can differ by about one word; quote `wc -w` numbers in CHANGELOG/README.
- A rule that changes a verdict, score, status, or required output must appear in the owning `SKILL.md`, not only in a guide it loads: agents usually read `SKILL.md` and stop (#402/#404). Pin it in `tests/test-guide-rule-anchors.sh`.
- When a change adds a new mandatory convention (a MUST rule, a required note, a naming pattern), ship its CI enforcement in the same PR, not as a follow-up.

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
