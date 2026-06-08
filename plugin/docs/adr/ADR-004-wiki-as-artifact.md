# ADR-004: GitHub Wiki as Build Artifact from `docs/wiki/`

**Status**: Accepted

**Date**: 2026-04-08

**Decision maker**: Human (itarun.p)

## Context

v2.2.0 overhauled `README.md` into a professional template, but README alone cannot carry deep-dive documentation (per-step workflow guides, FAQ, troubleshooting, habit references, skill catalog) without becoming bloated. GitHub Wiki is the conventional home for such content.

GitHub Wikis are backed by a separate git repository (`<repo>.wiki.git`) with no native PR review, no CI, and no governance hooks. Editing directly via the web UI bypasses the plugin's established rules: PR-first workflow, `/cross-verify` before publish, validation scripts, conventional commits, and the "no direct main pushes" feedback memory.

The question: how should wiki content be authored and published while preserving the plugin's governance discipline?

## Options Considered

### Option A: Edit wiki directly on github.com/.../wiki

- **Pro**: Zero tooling, immediate publish, GitHub UI handles history
- **Con**: Bypasses PR review, cannot run `/cross-verify`, no link checking, drift from repo, violates "always use PR" rule, no single source of truth

### Option B: Authoritative `docs/wiki/` in main repo, synced to `.wiki.git` by GitHub Action (chosen)

- **Pro**: PR review applies, validation scripts apply, versioned with plugin releases, aligns with governance rules, DRY (habits content generated from `habits/h*.md`), CI link checking, single source of truth
- **Con**: Requires sync Action, web-UI edits on the wiki will be overwritten (mitigated by `_Footer.md` notice)

### Option C: Git submodule pointing at `.wiki.git`

- **Pro**: Explicit separation
- **Con**: Submodule friction, contributors must learn submodule workflow, no benefit over Option B

## Decision

**Option B: `docs/wiki/` is the authoritative source; a GitHub Action syncs to `<repo>.wiki.git` on push to `main`.** The wiki becomes a build artifact, not a parallel universe. Habits content is generated at sync time from `habits/h*.md` via `scripts/gen-habits-reference.sh` to prevent drift.

Governance rules enforced:

- All wiki changes go through PR review on `docs/wiki/**`
- `lychee` link checker runs on PR via `.github/workflows/wiki-linkcheck.yml`
- Sync only triggers on merge to `main` via `.github/workflows/wiki-sync.yml`
- `_Footer.md` displays a "do not edit via web UI — changes will be overwritten" notice on every page
- `validate-structure.sh` verifies `docs/wiki/` skeleton integrity

## Consequences

**Positive**:

- Wiki content reviewable, reversible, and versioned alongside code
- Broken links caught before merge, not after publish
- Habits stay DRY — single source in `habits/`, rendered in wiki
- Contributors use familiar PR workflow, not a separate wiki workflow

**Negative**:

- First-time setup requires manually enabling the wiki and seeding a Home page via web UI (one-time prerequisite for the Action to push)
- Web-UI edits will be silently overwritten on next sync — must be communicated loudly
- Action uses `GITHUB_TOKEN` with wiki write permission; no PAT required but permissions must be set in workflow `permissions:` block

**Neutral**:

- `docs/wiki/` adds ~16 markdown files to the main repo; small footprint
- `_Sidebar.md` and `_Footer.md` prefixed with underscore per GitHub Wiki convention

## Implementation

- `docs/wiki/` — authoritative source (16 pages including `Home.md`, `_Sidebar.md`, `_Footer.md`, workflow steps, reference pages)
- `scripts/gen-habits-reference.sh` — concatenates `habits/h*.md` → `docs/wiki/Habits-Reference.md` at sync time
- `.github/workflows/wiki-sync.yml` — triggers on push to `main` affecting `docs/wiki/**` or `habits/**`; runs habits generator then `Andrew-Chen-Wang/github-wiki-action@v4`
- `.github/workflows/wiki-linkcheck.yml` — runs `lychee` on PRs affecting `docs/wiki/**`
- `tests/validate-structure.sh` — adds check for required wiki files and H1 presence
- `README.md` — adds Wiki badge and "Full documentation" link pointing to `github.com/pitimon/8-habit-ai-dev/wiki`

## Related

- ADR-001 Orchestration Patterns (this wiki documents those patterns in user-facing form)
- ADR-003 Content Validation (extends `validate-structure.sh` to cover wiki skeleton)
- Feedback memory: "Always create PR — never push directly to main"
