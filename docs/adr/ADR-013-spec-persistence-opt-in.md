# ADR-013: Spec Persistence as Opt-In `--persist` Flag

**Status**: Accepted
**Date**: 2026-05-03
**Decision makers**: Pitimon (human) + Claude Opus 4.7 (AI, 1M context)
**Related**: pitimon/8-habit-ai-dev#165, [ADR-009 Skill Split Convention](./ADR-009-skill-split-convention.md), research brief at `~/.claude/plans/https-github-com-github-spec-kit-idea-in-robust-walrus.md`
**Inspired by**: github/spec-kit (`/analyze` cross-artifact pattern) — see research brief for full attribution and boundary analysis vs `claude-governance/spec-driven-dev`

---

## Context

This plugin's 7-step workflow skills (`/research`, `/requirements`, `/design`, `/breakdown`, `/build-brief`, `/review-ai`, `/deploy-guide`, `/monitor-setup`) emit their output as `SKILL_OUTPUT` blocks **into the conversation transcript**. By design (CLAUDE.md "Key Conventions"), most skills do not have the `Write` tool — they are read-only guidance.

This works well for single-session feature work but creates two failure modes:

1. **Cross-session loss**: Switching to a new conversation loses all artifacts. Only what's been committed to disk persists.
2. **No cross-artifact analysis possible**: A `/cross-verify` equivalent that compares PRD ↔ design ↔ tasks for drift cannot exist if those artifacts only live in transcript.

Issue #165 introduces `/consistency-check` (a cross-artifact analyzer modeled on github/spec-kit's `/analyze`). The advisor pattern review of the original Option 1 surfaced that **persistence is a structural prerequisite** for the analyzer — without files on disk, there is nothing to analyze.

We must decide: how do users opt into persistence?

## Decision

Add an **opt-in `--persist <slug>` flag** to `/requirements`, `/design`, and `/breakdown`. When the flag is present:

1. Skills produce their normal `SKILL_OUTPUT` block in conversation **AND** write the full output to `docs/specs/<slug>/{prd,design,tasks}.md`
2. Each persisted file includes a YAML frontmatter block: `feature`, `step`, `created`, `updated`, `source-issue` (optional), `source-skill-version`
3. If the target file already exists, the skill prompts the user (overwrite / numbered variant / abort)
4. If the target directory cannot be created, the skill surfaces the error and falls back to conversation-only output (no abort)

When the flag is absent, behavior is **byte-identical** to v2.14.3 — same conversation output, no file writes, no errors. This is a hard back-compat invariant enforced by tests.

### Naming convention

Persisted files use spec-kit-aligned names:

- `prd.md` (from `/requirements`)
- `design.md` (from `/design`)
- `tasks.md` (from `/breakdown`)

Located at `docs/specs/<feature-slug>/`. The slug is user-chosen (kebab-case recommended) and serves as the directory name.

### Slug validation

The slug MUST match `^[a-z0-9][a-z0-9-]{1,63}$` (lowercase alphanumeric + hyphen, 2-64 chars, no leading hyphen). This prevents:

- Path traversal (`../`, `/`, backslash)
- Hidden files (leading `.`)
- Shell special chars (`$`, `;`, `|`, `&`, `*`)
- Excessively long directory names

Invalid slugs cause the skill to abort with an error message naming the regex and an example of a valid slug.

### Flag-style argument convention

`--persist <value>` follows existing 8-habit-ai-dev convention. Verified precedents:

- `/ai-dev-log` accepts `--since YYYY-MM-DD`, `--repo path`, `--out file` (3-flag pattern)
- `/calibrate` accepts `--force` (boolean flag)

This ADR formalizes the convention: skills MAY accept `--<name> [<value>]` flags interleaved with positional args. Skills implementing flag args document them in `argument-hint` frontmatter with bracket notation: `"[--persist <slug>] [feature description]"`.

### Pass evaluation strategy (post-advisor review)

`/consistency-check`'s 5 detection passes use a HYBRID evaluation strategy (decided in design.md Decision 9):

| Pass          | When IDs present                    | When IDs absent                     |
| ------------- | ----------------------------------- | ----------------------------------- |
| Coverage      | Deterministic (FR-NNN match)        | LLM semantic + warning              |
| Drift         | Semantic (always)                   | Semantic (always)                   |
| Ambiguity     | Deterministic (token match)         | Deterministic (token match)         |
| Underspec     | Deterministic (Alternatives header) | Deterministic (Alternatives header) |
| Inconsistency | Deterministic (Decision-N match)    | LLM semantic + warning              |

When ANY artifact lacks ID markers, the report emits a single warning at the top: `"ID linkage absent — using fuzzy match for Coverage and Inconsistency; results approximate. See ADR-013 for ID guidance."` Templates ship with OPTIONAL `FR-NNN`, `Decision-N`, `Task #N` markers — recommended, not required.

## Options Considered

### Alternative 1: Positional slug as first arg (no flag)

**Rejected.** Breaking change for users who currently pass a feature description as the first arg (e.g., `/requirements add user login`). Existing arguments would be misinterpreted as a slug. Backward compatibility is a hard PRD invariant (PRD-EARS-2).

### Alternative 2: Auto-detect from current working directory

**Rejected.** "Magic" behavior tied to shell state is hard to debug and surprising. Users would unintentionally persist artifacts when running skills from inside an unrelated `docs/specs/` subdirectory. Implicit > explicit fails the H8 voice principle (developer should know exactly what their commands do).

### Alternative 3: Frontmatter directive (`persist: <slug>` line in conversation)

**Rejected.** Brittle parsing, undiscoverable, and confusing for users who don't read the SKILL.md carefully. No precedent for this pattern in the plugin.

### Alternative 4: Always-on persistence to a default temp location

**Rejected.** Violates the core no-build philosophy ("skills are read-only guidance" — CLAUDE.md). Always-writing skills create unintended file artifacts that may surprise users in clean checkouts.

### Alternative 5: Two-phase — persistence ADR shipped first, analyzer in next release

**Rejected by user (`เอา` 1a, 2026-05-03).** Splitting into two PRs adds release overhead without clear value. The bundled approach lets the analyzer ship with its prerequisite in one coherent reviewable change. Risk mitigation: persistence is opt-in (back-compat preserved), so the bundled change is no riskier than the split.

## Consequences

### Positive

- Closes the structural gap that prevented cross-artifact analysis
- Enables cross-session feature continuity (`docs/specs/<slug>/` is committable)
- Aligns 8-habit's artifact model with spec-kit and `claude-governance/spec-driven-dev` (which uses Write to persist), making cross-plugin workflows easier
- Self-applies: this PR's own design uses `docs/specs/consistency-check/` as the dogfood
- Future skills can adopt the same convention (e.g., `/build-brief` could persist to `docs/specs/<slug>/build-briefs/<task-id>.md`)

### Negative

- Three skills (`/requirements`, `/design`, `/breakdown`) gain `Write` in their `allowed-tools` — small expansion of the principle "skills don't write." Justified by opt-in invariant.
- Adds a new convention developers must learn (`docs/specs/<slug>/` layout, `--persist` flag).
- Shell state coupling: cwd matters for relative paths, slugs may collide across features.

### Boundary stance

This decision does **NOT** move us toward enforcement / gating territory. The persisted artifacts are inputs to the (read-only) `/consistency-check` analyzer, not pre-commit hooks. Compliance enforcement on persisted specs (e.g., "PRD must have ≥3 EARS criteria to merge") would still belong in `pitimon/claude-governance` per the plugin boundary doctrine (CLAUDE.md "Plugin Boundary"). This ADR commits only to the artifact convention, not to enforcement on top of it.

### Reversibility

If this design proves wrong, reverting is straightforward:

1. Remove `--persist` handling from the 3 skills
2. Delete `/consistency-check`
3. Update CLAUDE.md / README to drop the convention reference

User-created `docs/specs/<slug>/` directories would become inert documentation but harm nothing. Persisted files have no runtime side effects.

## Verification

This ADR is satisfied when:

- [ ] `/requirements`, `/design`, `/breakdown` accept and process `--persist <slug>` per Decision section
- [ ] `tests/validate-content.sh` includes a check that all three skills document the `--persist` flag in their `argument-hint` and process section
- [ ] `tests/validate-content.sh` includes a check that `docs/specs/consistency-check/{prd,design,tasks}.md` exists and has valid frontmatter (dogfood enforcement)
- [ ] CHANGELOG records the new opt-in convention
- [ ] CLAUDE.md "Key Conventions" section adds a bullet for the new convention
