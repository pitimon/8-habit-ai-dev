# Changelog

Release history for `8-habit-ai-dev`. This page summarizes notable changes; the authoritative sources are [`CHANGELOG.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/CHANGELOG.md) (v2.3.0+), the [GitHub releases page](https://github.com/pitimon/8-habit-ai-dev/releases), and the [git tag history](https://github.com/pitimon/8-habit-ai-dev/tags).

> Full detail for v2.3.0 and later lives in the root [`CHANGELOG.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/CHANGELOG.md). This wiki page summarizes recent versions and keeps v2.2.0 and earlier for continuity.

## v2.8.0 — Claude Code Architecture Insights (April 2026)

Production patterns from Anthropic's Claude Code internals (reverse-engineered in ["Claude Code from Source"](https://github.com/alejandrobalderas/claude-code-from-source)) adapted into 4 existing skills as workflow guidance.

- **`/build-brief` context compression awareness** ([#114](https://github.com/pitimon/8-habit-ai-dev/issues/114)) — step 6 "Context survival" for briefs that survive the 4-layer compression pipeline
- **`/design` sticky latch principle** ([#116](https://github.com/pitimon/8-habit-ai-dev/issues/116)) — step 5 "Sticky decisions" with rework-level classification table
- **`/reflect` lesson consolidation** ([#113](https://github.com/pitimon/8-habit-ai-dev/issues/113)) — Step 7 + `/reflect consolidate` argument with 4-phase dream-inspired cycle
- **`/breakdown` fork agent pattern** ([#115](https://github.com/pitimon/8-habit-ai-dev/issues/115)) — step 5 "Token-efficient parallel design" with ~90% cache hit guidance

## v2.7.1 — Review Discipline Refinement (April 2026)

Small post-milestone patch adding two disciplines to `/review-ai` after a cost/benefit audit against `addyosmani/agent-skills` (MIT). Scope deliberately minimal — only one of six candidate mechanics was imported.

- **`/review-ai` Performance axis** ([#110](https://github.com/pitimon/8-habit-ai-dev/issues/110), [PR #111](https://github.com/pitimon/8-habit-ai-dev/pull/111)) — fourth review category flagging N+1 queries, unbounded loops, missing pagination, unindexed queries, and memory leaks; same `file:line` evidence standard as the other axes
- **Review-tests-first directive** — new Process step 2 directs the reviewer to read new/changed tests before judging implementation
- **Rejections preserved in PR #111 body** — `guides/anti-rationalization.md`, `guides/red-flags.md`, `guides/google-engineering-principles.md`, `/cross-verify` Q18, and a cross-plugin hard-gate spec were all evaluated and rejected as duplicative of existing features or out-of-scope

## v2.7.0 — Reader Adoption (April 2026)

Closes the `/calibrate` feature loop by making skills read `~/.claude/habit-profile.md` via a session-start hook.

- **Hook-based verbosity adaptation** ([#96](https://github.com/pitimon/8-habit-ai-dev/issues/96)) — `hooks/session-start.sh` emits a per-level directive into session context; 16 existing skills auto-adapt with zero file changes
- **`guides/verbosity-adaptation.md`** — canonical per-level rules with 5 skill-archetype examples
- **`tests/test-verbosity-hook.sh`** — 12-assertion regression coverage for all 8 hook branches + HABIT_QUIET opt-out + ≤300-token budget check
- **4 validators in CI, 482 total assertions** (up from 3 / 470)
- **Milestone v2.7.0 CLOSED** — Hermes-inspired feature loop (v2.6.0 + v2.7.0) complete

## v2.6.1 — Skill Effectiveness Tracking (April 2026)

- **`/reflect` Q6 Skill Effectiveness signal** ([#92](https://github.com/pitimon/8-habit-ai-dev/issues/92)) — 6th retro question captures "most useful" and "least useful/confusing" skill
- **`SKILL-EFFECTIVENESS.md`** (repo root) — maintainer-curated trend tracker; H7 applied to the plugin itself
- **`guides/templates/lesson-template.md`** — new `## Skill effectiveness` section for consistent Q6 capture
- **Fix**: SIGPIPE flake in `validate-content.sh` F3 extractor — replaced `sed | head` with pipe-safe awk

## v2.6.0 — Hermes-Inspired Improvements (April 2026)

- **`/calibrate` skill + habit-profile schema v1** ([#90](https://github.com/pitimon/8-habit-ai-dev/issues/90), [ADR-008](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-008-user-maturity-calibration-design.md)) — 5-7 question self-assessment writing `~/.claude/habit-profile.md` with dominant-level scoring
- **`guides/habit-profile-schema.md`** — public schema contract (YAML + markdown body, versioned via `schema-version`)
- **Persistent reflection artifacts** ([#88](https://github.com/pitimon/8-habit-ai-dev/issues/88)) — `/reflect` writes lessons to `~/.claude/lessons/`; `/research` and `/build-brief` read them before starting work
- **`guides/habit-nudges.md`** + **ADR-007** — nudge spec (hook delegated to claude-governance) + agentskills.io NO-GO decision
- **Skill count: 16 → 17** (`/calibrate` added)

## v2.5.0 — Testing & Discoverability (April 2026)

- **`tests/test-skill-graph.sh`** — DAG validator for `prev-skill` / `next-skill` chains (#79): cycles, dangling refs, symmetric edges, orphans
- **`hooks/pre-commit.sh.example`** — template running `/review-ai` on staged files (opt-in, not auto-installed)
- **Bidirectional wiki ↔ skills linking** (#81) — each workflow skill has a `## Further Reading` section linking to its wiki page
- CI now runs 3 validators; 443 total assertions

## v2.4.1 — Honest Correction (April 2026)

Same-day correction after comparing `/brainstorm` to `superpowers:brainstorming`.

- **Removed `/brainstorm` skill** (breaking) — superpowers' 500+ line hard-gate discipline suite is a better fit; `/research` now references it for fuzzy problem statements
- **`HABIT_QUIET=1` opt-out** for `hooks/session-start.sh` — users who internalize the workflow can silence the reminder
- **"Core 5" tier** in `/using-8-habits` — 80/20 reality acknowledgment
- [ADR-006](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-006-audience-honesty-and-opt-out.md) — audience-honesty + opt-out + "check peer plugins before building parity" lesson

## v2.4.0 — Workflow Completions (April 2026)

- **`/brainstorm`** (Step 0a, later removed in v2.4.1) — 5 Whys, alternative framings, hidden assumptions
- **EARS-notation in `/requirements`** — 5 structured acceptance criteria templates from Rolls-Royce (Mavin et al. 2009)
- **`/using-8-habits`** — onboarding meta-skill with decision tree and complete walkthrough example
- Validators: +52 assertions, anti-drift check ensures meta-skill references every directory skill
- Fix: `validate-structure.sh` regex allowing digits in skill names

## v2.3.0 — EU AI Act Compliance Toolkit (April 2026)

Flagship blue-ocean feature: first Claude Code plugin with explicit EU AI Act compliance toolkit, shipped ~4 months before 2 August 2026 enforcement.

- **`/eu-ai-act-check`** — 9-obligation tiered checklist (25 MUST + 27 SHOULD + 8 COULD) covering Articles 9-15
- **`/ai-dev-log`** + **`scripts/generate-ai-dev-log.sh`** — AI-assisted development log from `git log` + Co-Authored-By trailers (4 modes: markdown/json/summary/out)
- **`/design` Step 5** — Article 14 human-oversight 5-capability checkpoint (Understand / Automation bias / Interpret / Override / Stop button)
- **`docs/research/eu-ai-act-obligations.md`** — primary-source research with Verified Quotes for all 7 articles
- **[ADR-005](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-005-eu-ai-act-toolkit.md)** + **Plugin Boundary section** in `CLAUDE.md` — documents complementary relationship with [`pitimon/claude-governance`](https://github.com/pitimon/claude-governance)
- Version file convention corrected to **4 files** (added `SELF-CHECK.md`)
- Fix: `validate-structure.sh` SIGPIPE race replaced `sed | head` with awk

## v2.2.0 — April 2026

- README overhauled with a professional 8-Habit aligned template
- Hero tagline reframed around pain-point + benefit
- Quick Start split into install + use blocks
- 7-Step Workflow diagram simplified
- GitHub repo description and topics updated
- Wiki infrastructure introduced (`docs/wiki/`, sync Action, link check) — see [ADR-004](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-004-wiki-as-artifact.md)

## v2.1.0

- Smart QA integration with 8-Habit framework
- README internal link and skill cross-reference validation
- `validate-content.sh` fitness function improvements

## v2.0.0

- Three accepted ADRs drive architecture:
  - [ADR-001 Orchestration Patterns](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-001-orchestration-patterns.md)
  - [ADR-002 Research Modes](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-002-research-modes.md)
  - [ADR-003 Content Validation](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-003-content-validation.md)
- Three architecture fitness functions (skill complexity, content depth, cross-reference integrity)
- `validate-content.sh` added alongside `validate-structure.sh`

## v1.x

- Initial 7-step workflow and 8-habit skill set
- Cross-verify agent (`8-habit-reviewer`)
- External QA review v1.0.0 scored 9.5/10 (EXCELLENT) — [Issue #1](https://github.com/pitimon/8-habit-ai-dev/issues/1)

## Versioning policy

This plugin follows [semantic versioning](https://semver.org/):

- **Major** — breaking change to skill interfaces, skill removal, or workflow restructuring
- **Minor** — new skills, new habits content, backward-compatible additions
- **Patch** — documentation fixes, typo corrections, clarifications

Version is tracked in four files that must bump together (enforced by `tests/validate-structure.sh`):

- `.claude-plugin/plugin.json`
- `.claude-plugin/marketplace.json`
- `README.md` (badge + footer)
- `SELF-CHECK.md` header

## Full history

- **Releases**: [github.com/pitimon/8-habit-ai-dev/releases](https://github.com/pitimon/8-habit-ai-dev/releases)
- **Tags**: [github.com/pitimon/8-habit-ai-dev/tags](https://github.com/pitimon/8-habit-ai-dev/tags)
- **Commits**: [github.com/pitimon/8-habit-ai-dev/commits/main](https://github.com/pitimon/8-habit-ai-dev/commits/main)
