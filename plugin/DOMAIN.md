# DOMAIN.md

## Domain

`8-habit-ai-dev` is a portable workflow-discipline plugin for AI-assisted development. Its primary domain objects are markdown skills, habits, guides, ADRs, packaging manifests, and lightweight validation scripts.

## Core entities

- `skills/<name>/SKILL.md`: user-invocable guidance documents. Directory name and frontmatter `name` must match.
- `habits/h*.md`: reference principles loaded by skills when needed.
- `guides/*.md`: shared doctrine, templates, and process references.
- `rules/effective-development.md`: Claude rules payload for the 8-Habit playbook.
- `hooks/*`: Claude Code runtime hooks only.
- `.claude-plugin/*`: Claude Code packaging.
- `.codex-plugin/plugin.json` and `.agents/plugins/marketplace.json`: Codex packaging.
- `docs/adr/ADR-NNN-*.md`: architecture decisions.
- `docs/specs/<slug>/{prd,design,tasks}.md`: persisted feature-spec artifacts.

## Invariants

- The plugin remains markdown-first and dependency-free for consumers.
- Skills are guidance, not self-executing automation.
- Runtime enforcement, compliance gates, irreversible-action authorization, and policy certification stay outside this repo's core.
- Claude-specific hooks do not imply Codex runtime behavior.
- Codex packaging exposes the same markdown skill corpus; it must not fork skill semantics.
- Skill frontmatter must stay structurally valid and compatible with both Claude Code and Codex ingestion.
- The 7-step workflow remains numbered 0-7 unless an ADR explicitly changes the model.
- Version-bearing files must be bumped together when required by `CLAUDE.md` and `CONTRIBUTING.md`.
- ADRs record durable decisions; rejected ideas belong in `docs/out-of-scope/` when preservation is useful.

## Safety Rules

- Never commit secrets, tokens, credentials, private keys, or customer-sensitive raw data.
- Do not store raw customer data in examples, prompts, tests, docs, or memory notes.
- Do not delete or overwrite `CLAUDE.md`; update cross-agent instructions in `AGENTS.md`.
- Do not present Claude-only hook behavior as universal behavior.
- Do not duplicate governance or compliance-enforcement features from `claude-governance`.
- Do not add generated artifacts or build outputs unless a documented release process requires them.

## Data and Security Boundaries

This repository should contain public documentation, plugin metadata, validation scripts, examples, and decision records only. Local agent configuration such as `.claude/settings.local.json`, global memory, and Obsidian vault contents are outside the repo contract and must not be treated as portable project state.

Allowed durable project memory is curated, non-sensitive summary material. Raw captures, credentials, private operational details, and customer-sensitive evidence stay out of committed files.

## Operational Constraints

- Prefer shell validators already in `tests/` for repository checks.
- Keep shell scripts portable across macOS local development and Linux CI.
- Avoid `sed | grep | head` style frontmatter extraction under `pipefail`; use the awk pattern documented in `CONTRIBUTING.md`.
- Preserve relative links and paths in repository documentation.
- Use ADRs for architectural commitments and `SPEC.md` for session re-entry context.

## Validation Expectations

Before committing material changes, run the relevant checks:

```bash
bash tests/validate-structure.sh
bash tests/validate-content.sh
bash tests/test-skill-graph.sh
```

For hook changes, also run:

```bash
bash tests/test-verbosity-hook.sh
```
