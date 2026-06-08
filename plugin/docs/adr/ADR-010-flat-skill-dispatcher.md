# ADR-010: Flat Skill Dispatcher (`skills/RESOLVER.md`)

- **Status**: Accepted
- **Date**: 2026-04-22
- **Supersedes**: None
- **Related**: Issue #135 (this ADR's origin), Issue #136 (consumer — llms.txt links to RESOLVER), ADR-009 (skill split convention)

## Context

The plugin ships 17 skills. "Which skill for this task?" knowledge is spread across four existing sources, each indexed by a different dimension:

| Source                                  | Indexed by           | Shape            |
| --------------------------------------- | -------------------- | ---------------- |
| `CLAUDE.md` § Skills → Habits Mapping   | Workflow step        | Table            |
| Each skill's `description:` frontmatter | Skill name           | YAML field       |
| `/using-8-habits` decision tree         | User situation       | Narrative + tree |
| `prev-skill` / `next-skill` frontmatter | Predecessor in chain | DAG              |

None of these is a **phrase → path** lookup. A user who types raw intent — "I want to audit this PR for security" — has no direct way to learn that `/security-check` is the answer without first reading `/using-8-habits` or the full README skills table. The same gap hurts non-Claude agents (Codex, Cursor, Windsurf) that dispatch by phrase matching rather than slash-command mapping.

The idea for a flat dispatcher came from [`garrytan/gbrain`](https://github.com/garrytan/gbrain/blob/master/skills/RESOLVER.md) during the 2026-04-22 `/research` session (Issue #135).

## Options Considered

| Option                                          | Summary                                                                                                           | Trade-offs                                                                                                                   | Verdict                                                       |
| ----------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------- |
| **A. New `skills/RESOLVER.md`** (chosen)        | Flat table file grouped by the existing 3-category taxonomy, ≤3 triggers per skill, bidirectional validator check | ✅ Orthogonal to existing sources; standalone URL for #136; enforceable invariant. ⚠️ One more file in the doc surface.      | **Accepted**                                                  |
| B. `manifest.json` (machine-readable)           | Generate a JSON inventory of skills with trigger arrays                                                           | ✅ Parseable. ❌ Duplicates `test-skill-graph.sh` + frontmatter chains; drift risk without runtime consumer.                 | Rejected — no new machine need beyond what frontmatter gives. |
| C. Extend `/using-8-habits` with a flat section | Append a `## Triggers` table to the existing meta-skill                                                           | ✅ One fewer file. ❌ Dilutes 132-line narrative; denies #136 a standalone URL; violates the ADR-009 skill-split spirit.     | Rejected — wrong shape for the job.                           |
| D. Runtime auto-dispatch hook                   | Install a session hook that matches phrases and loads skills automatically                                        | ✅ Zero cognitive load. ❌ Enforcement gate — belongs in `claude-governance`, not `8-habit-ai-dev` (plugin boundary).        | Rejected — wrong plugin.                                      |
| E. Adopt gbrain's 7-category taxonomy verbatim  | Use Always-on / Brain ops / Content / Thinking / Operational / Setup / Identity                                   | ✅ Pattern match with source material. ❌ Our 17 skills fit cleanly into 3 existing categories; 7 categories would fragment. | Rejected — structure must fit our scope, not the source's.    |

## Decision

Add a single file **`skills/RESOLVER.md`** — a flat dispatcher grouped in 3 sections that mirror `/using-8-habits`'s existing taxonomy:

1. **Workflow Skills (Steps 0–7)** — 8 rows
2. **Assessment Skills** — 6 rows
3. **Meta / Onboarding** — 3 rows

Each row carries: trigger phrases (≤3 per skill), a `skills/<name>/SKILL.md` path citation, and a one-line purpose. RESOLVER is **lookup-only**; narrative and decision-tree stay in `/using-8-habits`.

A bidirectional integrity check (**Check 20** in `tests/validate-structure.sh`) enforces:

- Every RESOLVER path resolves to an existing `skills/<name>/SKILL.md`
- Every `skills/<name>/` directory appears in at least one RESOLVER row

A single pointer sentence is added to `CLAUDE.md` under `## Skills → Habits Mapping`. No skill frontmatter schema changes. No runtime dispatch.

## Consequences

### Positive

- **New users** can find a skill by typing their intent rather than learning slash-command names first.
- **Non-Claude agents** get a standalone URL to link to from llms.txt / AGENTS.md (Issue #136 unblocked).
- **Future skill authors** gain a mechanical onboarding step ("add a RESOLVER row") enforced by Check 20 — coverage invariant is now a test, not a hope.
- **Skill-split tradeoffs** are honored: `/using-8-habits` stays 132-line narrative, RESOLVER stays ≤110-line table. Neither bloats to cover the other's job.

### Negative / Risks

- RESOLVER and `/using-8-habits` must stay **shape-differentiated** (flat table vs narrative). Drift risk caught at code review — not runtime-enforceable.
- Trigger-phrase wording is **semi-sticky**: refinable per row post-ship, but the 3-section taxonomy and `skills/<name>/SKILL.md` path pattern are sticky (>50% rework to change — invalidates #136 llms.txt anchors).
- Adds one file to the on-demand load surface. Mitigated by: RESOLVER is not loaded by any hook or skill — it's read by humans / agents only.

## Compliance

- **Plugin boundary**: ✅ RESOLVER is guidance + a reference check. No enforcement gate or runtime hook.
- **Article 14 (EU AI Act)**: N/A — dev-tooling plugin feature, not an AI system under Annex III.
- **Validator invariants**: ✅ Check 20 enforces bidirectional coverage; 3 failure-message strings specified for debuggability.
- **Size limits**: ✅ `skills/RESOLVER.md` ≤ 110 body lines (file-size budget); within plugin's `<800 line` per-file rule.

## Supersession

If future work expands `/using-8-habits` to absorb RESOLVER's role (e.g., reorganizing around phrase lookup), a new ADR supersedes this one. Do not amend ADR-010 in place — the rejection of "extend `/using-8-habits` instead" is load-bearing history.
