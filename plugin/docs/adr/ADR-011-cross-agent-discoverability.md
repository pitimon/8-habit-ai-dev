# ADR-011: Cross-Agent Discoverability (`llms.txt` + `AGENTS.md`)

- **Status**: Accepted
- **Date**: 2026-04-22
- **Supersedes**: None
- **Related**: Issue #136 (origin), Issue #135 / ADR-010 (enabling predecessor — `skills/RESOLVER.md` as shared link target)

## Context

The plugin is cross-agent by philosophy — workflow discipline is agent-agnostic. Today only `CLAUDE.md` exists as a file-named entry point, and Claude Code auto-loads it. Other agent platforms (Codex, Cursor, Windsurf, Aider, Continue) and LLM-based repo-fetchers have no canonical door into the plugin. `skills/RESOLVER.md` (added in #135) is the phrase-to-path lookup but requires a reader who already knows to look in `skills/`.

Two emerging cross-tool conventions address this gap:

- **`llms.txt`** — flat doc-map at repo root, fetched by LLM-based tools to index a project. Convention from [llmstxt.org](https://llmstxt.org).
- **`AGENTS.md`** — non-Claude operating protocol at repo root. Used by [garrytan/gbrain](https://github.com/garrytan/gbrain) and similar projects to guide Codex/Cursor/Aider users.

Both are real adoption signals, not speculative. Adding them closes the cross-agent gap with minimal surface area and reuses `skills/RESOLVER.md` as a shared link target.

## Options Considered

| Option                                   | Summary                                                                                                                                                          | Trade-offs                                                                                                                                                                                            | Verdict      |
| ---------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ |
| **A. `llms.txt` + `AGENTS.md`** (chosen) | Two root files: `llms.txt` (llmstxt.org convention, flat doc map) + `AGENTS.md` (non-Claude operating protocol). `skills/RESOLVER.md` is the shared link target. | ✅ Matches real emerging conventions. ✅ Remote fetchers and non-Claude agents get distinct shapes (machine-flat vs. human-operating). ✅ Works with #135's RESOLVER as-is. ⚠️ Two new files at root. | **Accepted** |
| B. `AGENTS.md` only (skip `llms.txt`)    | One file covers both audiences                                                                                                                                   | ✅ One fewer file. ❌ Denies `llmstxt.org` discovery pattern — crawlers look for the literal filename `llms.txt`.                                                                                     | Rejected     |
| C. `llms.txt` only (skip `AGENTS.md`)    | Rely on README for human-facing non-Claude guidance                                                                                                              | ✅ Machine-readable. ❌ Humans on non-Claude platforms get no install / trust-boundary / common-tasks page — README is too broad.                                                                     | Rejected     |
| D. Combined `agent-setup.md`             | Merge both files                                                                                                                                                 | ✅ One file. ❌ Breaks `llmstxt.org` convention (wrong filename). ❌ Mixes audiences (machine-flat list vs. human operating protocol) in one shape.                                                   | Rejected     |
| E. Rename `CLAUDE.md` → `AGENTS.md`      | Single source of truth for all agents                                                                                                                            | ❌ Claude Code auto-loads `CLAUDE.md` by literal name; rename breaks the auto-load behavior.                                                                                                          | Rejected     |
| F. Do nothing                            | Accept single-`CLAUDE.md` status quo                                                                                                                             | ❌ Counter to cross-agent philosophy; privileges Claude Code users.                                                                                                                                   | Rejected     |

## Decision

Add `llms.txt` + `AGENTS.md` at repo root following Option A. Extend `tests/validate-structure.sh` with **Check 21** enforcing both files exist and contain correct pointers to `skills/RESOLVER.md` + `CLAUDE.md`. Add one pointer line to `CLAUDE.md` (blockquote at line 3, before the first paragraph) and one ToC bullet to `README.md` under `Get Started`.

Cite upstream per-platform skill-loading references (Codex, Cursor, Windsurf, etc.) **by name only** — the `obra/superpowers-skills/using-superpowers/references/` path cited in Issue #136 body was confirmed HTTP 404 via `gh api` at design time (2026-04-22). Individual tool docs resolve the invocation details.

## Consequences

### Positive

- **Non-Claude agents** and `llmstxt.org`-aware tools have canonical entry points for the plugin.
- **`skills/RESOLVER.md`** (from #135) gains a discoverable URL pattern from outside Claude Code — the cross-agent story is now end-to-end (`llms.txt` → `AGENTS.md` → `RESOLVER.md` → individual `SKILL.md`).
- **Future skill authors** have a named cross-agent contract (`AGENTS.md` enforces that skills remain read-only guidance, not runtime behavior).
- **Check 21** makes cross-agent pointer integrity a test, not a hope — future file renames caught automatically.

### Negative / Risks

- **`AGENTS.md` drift risk** from `CLAUDE.md` over time (skill list, plugin boundary, conventions). Mitigated by tight discipline: `AGENTS.md` contains **how-to-use only** — no architecture content is duplicated from `CLAUDE.md`. 80-line cap + PR review enforce.
- **URL rot in `llms.txt`** on file moves — raw URLs hardcode `main/<path>`. Mitigated by treating `llms.txt` as a rename-PR touchpoint (low-priority follow-up: add to `CONTRIBUTING.md` reviewer checklist).
- **Dead upstream link exposure** — `obra/superpowers-skills/.../references/` was 404 at design time. Mitigation baked into the chosen design: cite by name, no hyperlink.

## Compliance

- **Plugin boundary**: ✅ Pure docs + validator — no hooks, no runtime enforcement gates. Matches 8-habit-ai-dev's role per `CLAUDE.md § Plugin Boundary`.
- **Article 14 (EU AI Act)**: N/A — dev-tooling plugin feature. Not an AI system under Annex III, not EU-targeted.
- **`llmstxt.org` convention**: ✅ H1 + blockquote summary + sectioned markdown-link lists with absolute URLs.
- **ADR-010 precedent**: ✅ Same ADR shape (Context / Options Considered / Decision / Consequences / Compliance); validate-content Check 13 enforces section integrity.

## Supersession

If a future cross-agent convention emerges that obsoletes either `llms.txt` or `AGENTS.md`, a new ADR supersedes this one. Do not amend ADR-011 in place — the HTTP-404-at-design-time observation and the dual-file rationale are load-bearing history.
