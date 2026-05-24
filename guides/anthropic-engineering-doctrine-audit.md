# Anthropic Engineering Doctrine Audit

> "Earn each line." — [ADR-018](../docs/adr/ADR-018-memory-layer-activation.md)

This guide catalogues which patterns from Anthropic / Karpathy / Claude Code engineering posts are **already operational** in `8-habit-ai-dev` vs **evaluated and deferred**. It is a **defensive citation surface**: when a contributor proposes adopting a pattern from a blog post, this is where they (and reviewers) check whether it's already shipped, already evaluated, or genuinely new.

The catalogue exists because [ADR-018](../docs/adr/ADR-018-memory-layer-activation.md) "Earn each line" doctrine requires every rule to cite friction evidence. Without a place to record "we evaluated this and didn't adopt it, here's why", future blog-reading contributors re-propose adopted or rejected patterns — wasting cycles and risking selective re-adoption under social pressure.

## Scope

This audit covers the **broader Anthropic / Claude Code engineering post corpus** (5 sources from the 2026-05-24 audit). For the narrower `github.com/anthropics/skills` 5-pattern audit, see [ADR-017](../docs/adr/ADR-017-anthropic-skill-patterns-audit.md). The two are complementary — ADR-017 evaluates skill-authoring patterns from one repo; this guide evaluates workflow / context / discipline patterns from a wider blog corpus.

## Self-reference note (N7)

The 2026-05-24 research brief identified the meta-pattern "doctrine doc that names adopted patterns" as N7 of the evaluation table. **This guide IS the implementation of N7.** It appears in Table 2 below for completeness, with status "Adopted as this guide — shipped v2.18.3".

## Table 1 — Already adopted (verify before re-proposing)

| Pattern                                                               | Where it lives in 8-habit-ai-dev                                                                                                                                 | Citation (file:line)                                                                                                          |
| --------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| Iterative requirements via `AskUserQuestion`                          | `/calibrate` (5-7 questions), `/research` (clarifying loop), `/requirements` (EARS-criteria interview)                                                           | `skills/calibrate/SKILL.md`, `skills/research/SKILL.md`, `skills/requirements/SKILL.md`                                       |
| 4-layer prompt order (system → project → session → message)           | Session-hook ≤300-token reminder + on-demand skill+habit `Load` directives + lesson search before research                                                       | `CLAUDE.md` (architecture section), `hooks/session-start.sh:2`                                                                |
| `<system-reminder>`-style runtime updates that don't invalidate cache | Session hook emits level-specific verbosity directive without re-loading skills                                                                                  | `hooks/session-start.sh` (verbosity adaptation, v2.7.0)                                                                       |
| Cache hit rate as architectural concern                               | `/build-brief` "Context survival" (#114), `/design` "Sticky decisions" (#116), `/breakdown` "Token-efficient parallel design" (#115)                             | CHANGELOG v2.15.0+                                                                                                            |
| Karpathy folder-structured wiki                                       | `~/.claude/lessons/INDEX.md` (curated theme map) + PostToolUse auto-commit hook for new lessons                                                                  | `~/.claude/lessons/INDEX.md`, lesson `2026-05-10-claude-lessons-auto-commit-hook-arc.md`                                      |
| `hot.md`-style recent-context cache                                   | `SKILL-EFFECTIVENESS.md` tally surfaces top-signal skills from the lesson corpus                                                                                 | `SKILL-EFFECTIVENESS.md` ([ADR-018](../docs/adr/ADR-018-memory-layer-activation.md))                                          |
| Periodic wiki linting                                                 | Release checklist forces `SKILL-EFFECTIVENESS.md` tally update; ≥2 skipped cycles → ADR-018 reversal review                                                      | `CONTRIBUTING.md` §"Release Checklist", [ADR-018](../docs/adr/ADR-018-memory-layer-activation.md) §"Forward-Guardrail Sunset" |
| Skill 3-layer architecture (description / instructions / tools)       | Every `SKILL.md` has frontmatter `description` (routing), Process steps (instructions), and `Load ${CLAUDE_PLUGIN_ROOT}/...` directives (reference content)      | [ADR-009](../docs/adr/ADR-009-skill-split-convention.md) skill-split convention                                               |
| Skill composability over monoliths                                    | 7-step DAG via `prev-skill` / `next-skill` frontmatter + cross-cutting skills with `any`                                                                         | 23 skills, all chained                                                                                                        |
| Post-session "should this become a skill?" refinement                 | `/reflect` Q6 (most / least useful skill) → `SKILL-EFFECTIVENESS.md` tally → `/skill-improve` cycles                                                             | [ADR-018](../docs/adr/ADR-018-memory-layer-activation.md) lesson → ADR pipeline                                               |
| Subagent context isolation                                            | `@8-habit-reviewer` (Sonnet, read-only) + advisor-pattern disprove-mode (fresh subagent, no named role)                                                          | `guides/advisor-pattern.md:69-120`                                                                                            |
| "Audit before deep dive" as research discipline                       | Already practiced — see lesson `2026-05-24-notebook-agent-harness-audit-adr018.md` which reframed ADR-018 from invention to activation via audit-first synthesis | `~/.claude/lessons/2026-05-24-notebook-agent-harness-audit-adr018.md`                                                         |

**12 rows.** Adding to this table requires citing the specific file/line and the date the pattern shipped.

## Table 2 — Evaluated and deferred

| ID  | Pattern                                                                                              | Source                                                                                      | Tier           | Rationale                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | Drop-date    |
| --- | ---------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------- | -------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ |
| N1  | HTML self-verifying artifacts (`data-verify-*` DOM attrs; 3-surface verify: human / Playwright / CI) | Anthropic "How we Claude Code" post                                                         | **OOS**        | Plan files and PRDs are markdown by design; runtime Playwright verification is enforcement territory owned by `pitimon/claude-governance`, not workflow discipline. Plugin boundary violation if adopted here.                                                                                                                                                                                                                                                                                                                                                                                                                                                    | — (rejected) |
| N2  | `AskUserQuestion`-style interactive `/requirements` replacing single-doc PRD                         | Anthropic "How we Claude Code" post                                                         | **T2**         | n=0 — no lesson cites "PRD-first produced mis-scoped specs". The EARS-criteria interview already covers iteration. Re-evaluate if a `/reflect` lesson surfaces with that first-person friction.                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | 2026-11-24   |
| N3  | Per-skill token budget declared in frontmatter + progressive-disclosure triggers                     | Anthropic prompt-caching post                                                               | **T2**         | n=0 — only the session hook has a measurable token budget today. Symptom-free pattern. Re-evaluate if a lesson cites "skill X bloated past Y tokens caused context-pressure regression".                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | 2026-11-24   |
| N4  | Stable-prefix declaration per skill (mark which section is cache-stable vs volatile)                 | Anthropic prompt-caching post                                                               | **OOS**        | 8-habit is read-mostly discipline content loaded on-demand for human-invoked skills, not a high-frequency agentic runtime. Stable-prefix matters for live agent loops; not for this plugin's shape.                                                                                                                                                                                                                                                                                                                                                                                                                                                               | — (rejected) |
| N5  | `hot-recent.md` rolling cache of last-7-day lessons (Karpathy `hot.md` pattern)                      | Karpathy LLM-wiki post                                                                      | **T2**         | n=0 — `~/.claude/lessons/INDEX.md` serves as cold index; auto-commit hook keeps it fresh. Re-evaluate if `/research` ever cites "had to re-read N stale lessons before finding the recent one".                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | 2026-11-24   |
| N6  | Skill description routing audit (`/audit-skill-descriptions` or `/diagnose` Phase extension)         | Anthropic "Skills > prompts" post ("bare-bones tools with poor documentation" anti-pattern) | **T2**         | Original brief proposed T1 on "weak n=1" citing `skills/RESOLVER.md` existence. `@8-habit-reviewer` cross-verify (2026-05-24) flagged: the 2026-04-22 lesson records `RESOLVER.md` as a **proactive discoverability feature** (issue #135), not a friction patch. No first-person "picked the wrong skill" admission exists. Evidence is n=0 not n=1. Demoted to T2 to match the same standard as N2/N3/N5 — applying [ADR-015](../docs/adr/ADR-015-diagnose-skill-adoption-and-n1-framing.md) §"unusually strong... first-person retrospective admission" criterion consistently. Re-evaluate when a lesson cites a first-person "picked wrong skill" admission. | 2026-11-24   |
| N7  | This guide — doctrine doc that names adopted patterns                                                | Meta (this 2026-05-24 audit)                                                                | **T1 Adopted** | Shipped as this guide in v2.18.3. The defensive-citation function closes a documented [ADR-018](../docs/adr/ADR-018-memory-layer-activation.md) gap: without a catalogue, future contributors re-propose adopted patterns.                                                                                                                                                                                                                                                                                                                                                                                                                                        | — (shipped)  |

**7 rows.** Adding a new row requires the same evidence discipline as the existing rows: source, tier, rationale, drop-date if T2.

## How to use this guide

**Before proposing a new pattern from a blog post:**

1. Grep Table 1 for the pattern keyword. If present → cite the existing implementation, don't re-propose.
2. Grep Table 2 for the pattern keyword. If present → check the tier and drop-date.
   - **OOS row** → re-entry requires a new ADR amending the rejection rationale.
   - **T2 row** → re-entry requires a `/reflect` lesson citing the specific friction the row's "Re-evaluate when" criterion describes.
   - **T1 Adopted row** → already shipped, no action.
3. If neither table matches → it may be genuinely new. Run `/research` Audit mode against the plugin, then propose with friction evidence per [ADR-015](../docs/adr/ADR-015-diagnose-skill-adoption-and-n1-framing.md).

**Before reviewing a PR that cites a blog post:**

1. Verify the proposal isn't a duplicate by greping this guide.
2. If a duplicate, comment on the PR with the row reference and the existing implementation citation.
3. If genuinely new, hold the proposal to the same friction-first standard as the existing T2 rows.

## Maintenance

- **Trigger**: a new Anthropic / Claude Code engineering post lands (or a community summary of one circulates that produces re-proposal pressure).
- **Action**: run `/research` Audit mode against the plugin, then append rows to Table 1 (already adopted) or Table 2 (evaluated and deferred). Same row format mandatory.
- **Cadence**: opportunistic. The forcing function is contributor re-proposal pressure, not a calendar.
- **Lifecycle**: T2 rows evict on drop-date per [ADR-016](../docs/adr/ADR-016-t2-bag-drop-date-eviction-policy.md). If a lesson cites the row's "Re-evaluate when" criterion before drop-date, ratchet the row to T1 with citation; otherwise drop silently.

## Habit mapping

| Habit                                      | Why this guide maps                                                                                                                                                                                                                              |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **H4** Win-Win — Emotional Bank Account    | A catalogue future contributors can use to verify "we already evaluated that" is a deposit. The next person doesn't re-discover what you discovered.                                                                                             |
| **H5** Seek First to Understand            | Read priors before proposing. This guide makes the priors greppable.                                                                                                                                                                             |
| **H8** Find Your Voice — Modeling (Spirit) | The plugin audits its own adoption discipline in public. The N6 reclassification trail (T1 → T2 after cross-verify) is the modeling artifact — we apply the friction-first standard to ourselves the same way we apply it to incoming proposals. |

## Self-Check

- [x] Table 1 has exactly 12 rows
- [x] Table 2 has exactly 7 rows (N1 through N7)
- [x] N6 is in Table 2 at T2 with drop-date 2026-11-24, not in Table 1
- [x] N7 is in Table 2 marked "T1 Adopted — shipped v2.18.3" (self-reference acknowledged)
- [x] Every Table 1 row cites file path or ADR
- [x] Every Table 2 T2 row has a "Re-evaluate when" friction criterion in its rationale
- [x] Every Table 2 OOS row names the rejection rationale (plugin boundary or charter conflict)
- [x] Maintenance rule documents trigger, action, cadence, lifecycle
- [x] Habit mapping covers H4 + H5 + H8

## Source brief and review trail

- Research brief: `~/.claude/plans/https-vibecodingthailand-com-blog-anthro-tranquil-rocket.md` (Deep mode + Audit submode, 5 URLs fetched and verified 2026-05-24)
- Cross-verify: `@8-habit-reviewer` agent run 2026-05-24 — 11/17 pass, 1 CRITICAL (cherry-picking) + 2 HIGH + 3 MEDIUM. The CRITICAL finding is the reason N6 sits at T2 in this guide, not T1 as the original brief proposed.
- Issue: [#231](https://github.com/pitimon/8-habit-ai-dev/issues/231)
