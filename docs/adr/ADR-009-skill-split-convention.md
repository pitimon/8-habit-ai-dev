# ADR-009: Progressive-Disclosure SKILL.md Split Convention

**Status**: Accepted

**Date**: 2026-04-16

**Decision maker**: Human (Pitimon / P.Itarun-xOps)

## Context

As of v2.9.0, the three largest `skills/*/SKILL.md` files are at or near the F3 word-budget fitness-function ceiling (2000 words):

- `skills/using-8-habits/SKILL.md` — 1990 words (99.5%)
- `skills/eu-ai-act-check/SKILL.md` — 1989 words (99.5%)
- `skills/calibrate/SKILL.md` — 1774 words (88.7%)

Any future feature addition to these skills breaks the word budget. External research (`shanraisshan/claude-code-best-practice/implementation/claude-skills-implementation.md`, captured in the research brief at `plans/shiny-singing-dove.md`) surfaced the Anthropic-documented progressive-disclosure pattern: split large SKILL.md files into a scannable core + sibling reference and example files loaded on demand.

We need to commit to a convention now so the three refactors in v2.10.0 (and future refactors as other skills grow) follow a uniform structure.

## Options Considered

### Option A: Sibling files with inline `Load` directive

- **Description**: Create `skills/<name>/reference.md` and `skills/<name>/examples.md` alongside `SKILL.md`. SKILL.md body contains inline `Load \`${CLAUDE_PLUGIN_ROOT}/skills/<name>/reference.md\` for X`directives at the appropriate spots (matches the existing`habits/h\*.md` load pattern used in 5 current skills).
- **Pro**: Zero frontmatter schema change; proven pattern (Check 8 in `validate-structure.sh` already enforces Load-directive resolution as a hard fail); Claude loads lazily when body reaches the directive.
- **Con**: Reference-file path appears twice — once in SKILL body, once implicitly in the sibling file itself.

### Option B: Frontmatter `references:` array field

- **Description**: Add `references: [reference.md, examples.md]` to SKILL.md frontmatter. Validator reads YAML list instead of grep'ing body.
- **Pro**: Machine-readable.
- **Con**: Schema migration pressure on all 17 skills; unclear whether Claude auto-loads frontmatter-declared references or still needs an inline directive; forces a breaking change to skill frontmatter shape.

### Option C: Convention-based discovery (directory scan)

- **Description**: Claude discovers `reference.md` / `examples.md` siblings automatically by scanning the skill directory.
- **Pro**: Zero declaration overhead.
- **Con**: Undeclared files are not loaded reliably; defeats lazy-load intent; validator cannot distinguish intended references from stray files.

## Decision

**Option A** — sibling files named `reference.md` and `examples.md`, referenced from SKILL.md body via the existing `Load \`${CLAUDE_PLUGIN_ROOT}/skills/<name>/<file>.md\`` directive format.

**Rationale**:

1. **Reuses existing infrastructure**. `validate-structure.sh` Check 8 (lines 167-180) already hard-fails on broken `Load` directives — missing sibling files are caught automatically without any new validator logic. No new fitness function required for existence checks.
2. **Zero schema churn**. Frontmatter fields stay unchanged across all 17 skills.
3. **Proven pattern**. Five current skills (breakdown, build-brief, deploy-guide, design, monitor-setup) already use this directive format to load `habits/h*.md` references. Claude reliably follows them.
4. **Honest to the underlying mechanism**. Claude reads the SKILL body linearly and executes Load directives when it reaches them. An inline directive is a direct expression of that model; a frontmatter field would be a lie (Claude doesn't pre-load frontmatter references — it still needs the inline instruction).

## Consequences

### What changes

1. **New file convention**: `skills/<name>/reference.md` holds long-form reference material (tables, full schemas, extended rubrics). `skills/<name>/examples.md` holds worked examples.
2. **When to apply**: Skills where SKILL.md exceeds 1500 words OR where reference content (matrices, multi-case examples) bloats the skill body.
3. **When NOT to apply**: Skills with SKILL.md <1200 words. Don't split for the sake of splitting.
4. **Lazy-load semantics**: `Load` directives appear at the point in the SKILL body where the content is relevant — not at the top or bottom en bloc. Users who invoke the skill but don't hit the referenced section never pay the cost.
5. **No empty placeholders**: If a skill has no worked examples, do not create an empty `examples.md`. Create only `reference.md`.

### New fitness function

**F6 — sibling soft word budget** (added to `tests/validate-structure.sh`):

- Warn (not fail) if `skills/*/reference.md` or `skills/*/examples.md` exceeds 5000 words.
- Rationale: sibling files exist precisely to hold long content; a hard ceiling would defeat the purpose. A 5000-word warning catches unbounded growth without blocking legitimate reference material.

**F5 (existence check) — already covered by Check 8**. No new code needed.

### What stays the same

- Frontmatter schema: unchanged.
- DAG (`prev-skill` / `next-skill`): unchanged.
- `user-invocable: true` on all refactored skills.
- `argument-hint`: unchanged.
- Check 1-7, 10-15b in `validate-structure.sh`: unchanged.
- F3 word budget: remains a warning (historically a warning per Check 9 lines 183-197 — this ADR does not upgrade it to a hard fail).

### Follow-up actions

- Refactor 3 skills in v2.10.0: `using-8-habits`, `eu-ai-act-check`, `calibrate`.
- Add F6 warning to `validate-structure.sh`.
- Track in Issue #125.

### What this ADR does NOT commit to

- Refactoring the remaining 14 skills. That is a v2.11+ decision evaluated case-by-case.
- Changing `habits/h*.md` into background skills (Idea B from the research brief). Separate decision cycle.
- Parallel-dispatch `/cross-verify` using domain packs (Idea D). Separate decision cycle.

## References

- Research brief: `plans/shiny-singing-dove.md` (2026-04-16)
- Issue: [#125](https://github.com/pitimon/8-habit-ai-dev/issues/125)
- Precedent ADR: ADR-003 (content validation approach)
- External source: `shanraisshan/claude-code-best-practice/implementation/claude-skills-implementation.md`
- Existing Load pattern: `skills/research/SKILL.md:178-180`, `skills/design/SKILL.md`, `skills/breakdown/SKILL.md`, `skills/build-brief/SKILL.md`, `skills/deploy-guide/SKILL.md`, `skills/monitor-setup/SKILL.md`
