![Version](https://img.shields.io/badge/latest-v2.14.2-blue)

# Changelog

Release history for `8-habit-ai-dev`. This page summarizes notable changes; the authoritative sources are [`CHANGELOG.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/CHANGELOG.md) (v2.3.0+), the [GitHub releases page](https://github.com/pitimon/8-habit-ai-dev/releases), and the [git tag history](https://github.com/pitimon/8-habit-ai-dev/tags).

> Full detail for v2.3.0 and later lives in the root [`CHANGELOG.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/CHANGELOG.md). This wiki page summarizes recent versions and keeps v2.2.0 and earlier for continuity.

## v2.14.2 — EU AI Act Migration Completion (May 2026)

Plugin-boundary correction. The EU AI Act compliance toolkit (skill + reference + research + mapping guide) migrated to [`pitimon/claude-governance`](https://github.com/pitimon/claude-governance) v3.1.0 on 2026-05-02 per memory observation #233270 (2026-04-07): `8-habit-ai-dev` = workflow discipline; `claude-governance` = compliance enforcement + framework mappings. EU AI Act compliance is a framework mapping, not a workflow step. Original placement here was a boundary error.

- **Removed**: `skills/eu-ai-act-check/reference.md`, `docs/research/eu-ai-act-obligations.md`, `guides/eu-ai-act-mapping.md` (now canonical in `claude-governance` v3.1.0)
- **Stub**: `skills/eu-ai-act-check/SKILL.md` rewritten as a redirect to the canonical location with install + invocation examples; preserves NOT LEGAL ADVICE disclaimer; skill name remains valid in the catalog so existing cross-references resolve
- **ADR**: ADR-005 marked Superseded by ADR-012 (this migration completion)
- **Validator**: Check 15 in `tests/validate-content.sh` rewritten to assert post-migration state (stub correctness + deleted-file negative assertions + ADR-012 presence + ADR-005 Superseded marker)
- **Cross-refs**: reframed in RESOLVER, using-8-habits, design Step 5, ai-dev-log, session-start hook, README skill table

Wiki Architecture/FAQ/Home/Installation/Skills-Reference/Workflow-Overview pages and the README "EU AI Act ready" badge are deferred to a follow-up doc-only PR (precedent: `pitimon/claude-governance` PR #25 + #26 — local Markdown formatter rewrites tables on every Edit, producing 140+ lines of unrelated noise).

Coordination: this is the second half of the migration. The first half shipped in [`pitimon/claude-governance` v3.1.0 PR #26](https://github.com/pitimon/claude-governance/pull/26).

## v2.14.1 — README "What's New" Drift Guard (May 2026)

Patch release closing [#157](https://github.com/pitimon/8-habit-ai-dev/issues/157) — external QA found `validate-content.sh` Check 19A was passing on the README badge URL `releases/tag/v2.14.0` instead of asserting the section header `## What's New in v2.14.0`. Same bug class as [#124](https://github.com/pitimon/8-habit-ai-dev/issues/124) (CHANGELOG pointer-fallback) and [#141](https://github.com/pitimon/8-habit-ai-dev/issues/141) (SELF-CHECK.md body drift) — capability-level recurrence on a sibling surface.

- **README.md backfill** — restored missing `## What's New in v2.14.0` block, fixed broken TOC anchor (`#whats-new-in-v220` → `#whats-new-in-v2141`, broken since v2.3.0), backfilled 4 missing skills in the architecture file tree (calibrate, using-8-habits, eu-ai-act-check, ai-dev-log) so the tree matches the declared 17-skill count.
- **`tests/validate-content.sh` Check 19 sub-check G** — anchored grep `^## What's New in v${current_version}` in README.md. Closes the badge-URL false-positive class permanently. Mirrors the sub-checks E + F mechanism from PR #144.
- **Check 20 hardening** — pin literal `Find → Fix → Re-Verify` loop name + assert exactly 5 numbered steps in `skills/review-ai/SKILL.md` Verification Phase. Closes the v2.14.0 self-disclosed follow-up (passes-on-3-string-matches risk).

Pattern: same shape as v2.11.1 and v2.13.1 — QA surfaces drift class on a sibling surface → fix is fitness function, not checklist. Check 19 now covers README + CHANGELOG + wiki + SELF-CHECK + README-section-header — five anchored assertions, all co-located.

Fitness receipts: `validate-structure.sh` 246/0, `validate-content.sh` **206/0/1 WARN** (was 203; +3 new assertions), `test-skill-graph.sh` 57/0, `test-verbosity-hook.sh` 19/0.

External QA report by [@itarunp-apple](https://github.com/itarunp-apple) — ran the plugin's own `8-habit-reviewer` agent against v2.14.0 install per the framework's intended self-discipline workflow.

Closes #157.

---

## v2.14.0 — TOH Framework Inspirations (May 2026)

Minor release closing milestone [#15](https://github.com/pitimon/8-habit-ai-dev/milestone/15) — three workflow-discipline imports from [Toh Framework](https://github.com/Nathanphop/Toh-Framework) (an "AI-Orchestration Driven Development" framework for solo SaaS builders). Cross-pollination filtered through plugin-boundary: workflow discipline here, project-state persistence routed to `claude-governance`.

- **SKILL_OUTPUT attribution lines** ([#151](https://github.com/pitimon/8-habit-ai-dev/issues/151), [PR #152](https://github.com/pitimon/8-habit-ai-dev/pull/152)) — `[/<skill>] COMPLETE SKILL_OUTPUT:<type>` directly above each HTML comment in the 4 emitter skills. Status markers `COMPLETE` / `PARTIAL` / `FAILED` (text-only). New **Check 22** in `validate-structure.sh`; `cross-verify` parser unaffected. Inspired by Toh's Agent Announcement format.
- **Argument-driven smart-routing for `/using-8-habits`** ([#149](https://github.com/pitimon/8-habit-ai-dev/issues/149), [PR #154](https://github.com/pitimon/8-habit-ai-dev/pull/154)) — `/using-8-habits "<intent>"` returns ≤3 ranked skills + reasoning + alternatives + one direct question, instead of the full narrative tree. Reads `~/.claude/habit-profile.md` for verbosity and recent `~/.claude/lessons/` for context. Activates existing `argument-hint` frontmatter — no new skill file. Inspired by Toh's `/toh` Smart Command (reshape: extend rather than wrap).
- **`/review-ai` Verification Phase** ([#150](https://github.com/pitimon/8-habit-ai-dev/issues/150), [PR #155](https://github.com/pitimon/8-habit-ai-dev/pull/155)) — Find → Fix → Re-Verify loop: list CRITICAL/HIGH, apply fix, re-run review, cite evidence per finding, refuse to emit `pass: true` unless all CRITICAL closed. Output ends with a Verification Table. **Plugin boundary**: section header reads "guidance only — NOT a hook"; new **Check 20** in `validate-content.sh` enforces three-anchor boundary qualifier. Inspired by Toh's Test → Fix → Loop adapted as discipline guidance, not automated enforcement.

Pattern: external-framework cross-pollination kept tight by the boundary rule — 3 of 10 Toh ideas imported, 7 rejected with reason (multi-agent builders, "vibe" command, design profiles, component registry, multi-IDE adapters, 7-file project memory). Companion proposal in `claude-governance` ([#24](https://github.com/pitimon/claude-governance/issues/24)) for the persistence layer.

Fitness receipts: `validate-structure.sh` **246/0** (+1), `validate-content.sh` **201/0/1 WARN** (+3), `test-skill-graph.sh` 57/0, `test-verbosity-hook.sh` 19/0.

Closes #149, #150, #151.

---

## v2.13.1 — SELF-CHECK.md Body Freshness (April 2026)

Patch release closing the three-PR arc for [#141](https://github.com/pitimon/8-habit-ai-dev/issues/141) — SELF-CHECK.md body drift (header said v2.13.0 but footer said Previous: 2.7.1 and per-release list ended at v2.8.0, skipping 6 releases).

- **One-time catch-up** ([PR #142](https://github.com/pitimon/8-habit-ai-dev/pull/142)) — SELF-CHECK.md footer updated to `Previous: 2.12.0`; added 6 missing rows (v2.9.0 through v2.13.0). Plugin opens with _"H8 Modeling: Follow the process always, no shortcuts when unwatched"_ — contradicted by 6 consecutive silent releases.
- **Convention correction** ([PR #143](https://github.com/pitimon/8-habit-ai-dev/pull/143)) — CONTRIBUTING.md § Version Bumping "Version lives in **3 files**" → "**4 files**", adds `SELF-CHECK.md` header to the list (convention enforced since [#106](https://github.com/pitimon/8-habit-ai-dev/issues/106) but CONTRIBUTING.md never caught up).
- **CI invariant** ([PR #144](https://github.com/pitimon/8-habit-ai-dev/pull/144)) — `tests/validate-content.sh` Check 19 sub-checks E + F: footer must match `git tag -l "v2.*" | sort -V` predecessor of `plugin.json.version` (E); every v2.x tag must have a matching `^- v<x.y.z>: ` row in SELF-CHECK.md (F). Prevents recurrence of the drift class.
- **`.github/workflows/validate.yml`** — `fetch-tags: true` + `fetch-depth: 0` added to `actions/checkout@v4` so CI can read tag history.

Fitness receipts: `validate-structure.sh` 245/0, `validate-content.sh` **198/0/1 WARN** (was 196 + 2 net new pass-able assertions — same hardening shape as v2.11.1 drift guard), `test-skill-graph.sh` 57/0, `test-verbosity-hook.sh` 19/0.

Closes #141.

---

## v2.13.0 — Cross-Agent Discoverability (April 2026)

Minor release making the plugin discoverable from non-Claude agent platforms — three linked PRs from the 2026-04-22 `/research` session on [`garrytan/gbrain`](https://github.com/garrytan/gbrain). No breaking changes.

- **`skills/RESOLVER.md`** ([#135](https://github.com/pitimon/8-habit-ai-dev/issues/135), [PR #139](https://github.com/pitimon/8-habit-ai-dev/pull/139)) — flat phrase-to-skill dispatcher covering all 17 skills in 3 sections (Workflow / Assessment / Meta), ≤3 triggers each. Fills the phrase→path lookup gap; **Check 20** enforces bidirectional coverage (directory ↔ RESOLVER row).
- **`llms.txt` + `AGENTS.md`** at repo root ([#136](https://github.com/pitimon/8-habit-ai-dev/issues/136), [PR #140](https://github.com/pitimon/8-habit-ai-dev/pull/140)) — cross-agent entry points for Codex / Cursor / Windsurf / Aider / Continue / LLM-based fetchers. `llms.txt` follows [llmstxt.org](https://llmstxt.org) convention; `AGENTS.md` is the non-Claude operating protocol. **Check 21** enforces both files exist + 4× pointer integrity to `skills/RESOLVER.md` and `CLAUDE.md`.
- **README "Design Principle" section** ([#137](https://github.com/pitimon/8-habit-ai-dev/issues/137), [PR #138](https://github.com/pitimon/8-habit-ai-dev/pull/138)) — cites Garry Tan's 2026 essay _"Thin Harness, Fat Skills"_ as external validation of the bounded-hook + fat-skills pattern already enforced by `hooks/session-start.sh` (≤300 tokens).
- **ADR-010** (Flat Skill Dispatcher) and **ADR-011** (Cross-Agent Discoverability) — 6 options considered each; ADR-011 records the design-time empirical finding that `obra/superpowers-skills/.../references/` (cited in #136's issue body) was already HTTP 404 — AGENTS.md cites upstream tool patterns by name only.
- **Pattern extracted**: "Bidirectional Validator for Canonical Cross-References" — forward + reverse coverage invariants as the unit-test analog for documentation integrity. Check 12 / 20 / 21 share this shape.

Fitness receipts: `validate-structure.sh` 245/0, `validate-content.sh` 196/0/1 WARN, `test-skill-graph.sh` 57/0, `test-verbosity-hook.sh` 19/0. End-to-end cross-agent chain: `llms.txt → AGENTS.md → skills/RESOLVER.md → individual SKILL.md`.

Closes #135, #136, #137.

---

## v2.12.0 — Code-Symbol Grep Evidence (April 2026)

Minor release adding a new Evidence Standard obligation to `/research` and clarifying `research-verifier` scope ([#133](https://github.com/pitimon/8-habit-ai-dev/issues/133)). Guidance-only — no automation, no hook.

- **`/research` Evidence Standard** — code-symbol verdicts matching `/remove|dead|unused|transitional|safe to (drop|remove)/i` must cite a grep-check showing consumer usage across source directories; declaration-site citations (e.g. `package.json:6`) do not establish liveness. Closes a false-positive class surfaced by memforge `neo4j-driver` audit (the canonical Bolt client for Memgraph — brand-name mismatch passed Deep-mode with pristine citations).
- **`research-verifier` scope** — `description:` rewritten to "citation-integrity verification agent"; new `## Limit of Verification` section defines in-scope (citation accuracy) vs. out-of-scope (semantic correctness of conclusions). Verifier emits `SEMANTIC-EVIDENCE-MISSING` flag on code-symbol verdict rows lacking liveness evidence but does not perform the grep itself.
- **Trigger regex scope** — `"revisit"` intentionally excluded; over-triggers on follow-up-style verdicts. Hard-removal verdicts are the load-bearing class.

Fitness receipts: `validate-structure.sh`, `validate-content.sh`, `test-skill-graph.sh`, `test-verbosity-hook.sh` all green.

Closes #133.

---

## v2.11.1 — CHANGELOG Drift Guard (April 2026)

Patch release hardening `validate-content.sh` Check 19 against recurring CHANGELOG drift ([#124](https://github.com/pitimon/8-habit-ai-dev/issues/124), [PR #131](https://github.com/pitimon/8-habit-ai-dev/pull/131)). Post-v2.11.0 `/cross-verify` exposed the same drift class slipping CI twice (v2.9.0 + v2.11.0) through a pointer-fallback loophole.

- **3 new FAIL-severity assertions** in Check 19: `CHANGELOG.md ^## v<ver>` present, wiki `^## v<ver>` present (no pointer fallback), wiki badge `latest-v<ver>-blue` match.
- **Backfilled** missing v2.9.0 + v2.11.0 entries in root `CHANGELOG.md` and v2.11.0 in wiki `Changelog.md`.

Fitness receipts: `validate-structure.sh` 243/0, `validate-content.sh` 185/0, `test-skill-graph.sh` 57/0, `test-verbosity-hook.sh` 19/0.

Closes #124.

---

## v2.11.0 — Design Pipeline Completion + Wiki Redesign (April 2026)

Close the final gap in the `/requirements` → `/design` → `/breakdown` → `/review-ai` structured-output-block handoff chain, and upgrade 20 wiki pages to a professional template. Both PRs merged within 3 minutes of each other.

- **`SKILL_OUTPUT:design` structured block** ([#128](https://github.com/pitimon/8-habit-ai-dev/issues/128) / [PR #129](https://github.com/pitimon/8-habit-ai-dev/pull/129)) — closes the last cross-skill handoff gap; `/cross-verify` Q4/Q14/Q16 now auto-populate from the design block.
- **Tech-stack decisions as formal concerns** — `/design` Step 2 + `/research` Step 1 surface language/framework as explicit outputs.
- **Scope validation via `SKILL_OUTPUT:requirements`** — `/design` consumes the requirements block so scope drift between decisions and success criteria is flaggable.
- **H8 Whole Person in `/design` checkpoint** — Body/Mind/Heart/Spirit prompts.
- **Wiki redesign** ([#127](https://github.com/pitimon/8-habit-ai-dev/issues/127) / [PR #130](https://github.com/pitimon/8-habit-ai-dev/pull/130)) — new `Architecture.md` (4-layer plugin design), new `Maturity-Model.md` (4-level adaptive guidance), `Home.md` rewritten as hero landing page, `Skills-Reference.md` expanded 13 → 17 with quick-select matrix, `Workflow-Overview.md` Mermaid diagram, all 8 Step pages with `> [!IMPORTANT]` checkpoints, `_Sidebar.md` reorganized with Concepts section. 18 files, 291 insertions, 53 deletions.

Fitness receipts: `validate-structure.sh` 243/0, `validate-content.sh` 183/0, `test-skill-graph.sh` PASS, `test-verbosity-hook.sh` PASS.

---

## v2.10.0 — Progressive-Disclosure SKILL.md Split (April 2026)

Refactor the 3 largest skills into `SKILL.md + reference.md + examples.md` triads per [ADR-009](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-009-skill-split-convention.md). Creates headroom below the F3 word-budget fitness ceiling so future feature additions don't break the validator. Pattern sourced from external research (`shanraisshan/claude-code-best-practice`), filtered through plugin-boundary audit.

- **ADR-009** — codifies Load-directive mechanism (`${CLAUDE_PLUGIN_ROOT}` inline paths), naming convention, and when-to-apply threshold (SKILL >1500 words). Reuses existing Check 8 for sibling existence — no new fitness function needed for that.
- **F6 (Check 9b)** — soft word-budget warning for `reference.md` / `examples.md` (5000-word soft limit).
- **`using-8-habits`** split: SKILL 1990 → 1094 words; `reference.md` holds the full 17-skill inventory + cross-plugin composition tables; `examples.md` holds the password-reset onboarding walkthrough.
- **`eu-ai-act-check`** split: SKILL 1989 → 908 words; `reference.md` holds the full 9-obligation checklist (25 MUST / 27 SHOULD / 8 COULD items) with article/paragraph references. No `examples.md` (pure-reference skill).
- **`calibrate`** split: SKILL 1774 → 1161 words; `reference.md` holds the scoring rubric + profile-write procedure; `examples.md` holds 4 sample profiles (one per maturity level).
- **Content validator triad-awareness** — Checks 15 and 18 in `tests/validate-content.sh` now search the SKILL + reference + examples triad as a unit, so content moved to sibling files still satisfies anti-drift and tier-count assertions.
- **Rejected from this release** — 27-event hook catalog (referred to [`pitimon/claude-governance#22`](https://github.com/pitimon/claude-governance/issues/22)), Idea B (auto-load `user-invocable: false` habits), Idea D (parallel `/cross-verify` dispatch), F3 WARN→FAIL upgrade. Rejection rationale documented in root `CHANGELOG.md`.

Fitness receipts: `validate-structure.sh` 243/0, `test-skill-graph.sh` PASS, `validate-content.sh` 183/0 with 0 fitness breaches. Release shipped via [Issue #125](https://github.com/pitimon/8-habit-ai-dev/issues/125) / [PR #126](https://github.com/pitimon/8-habit-ai-dev/pull/126) in a single clean forward pass.

---

## v2.9.0 — Deep-Project Inspired Improvements (April 2026)

Three features inspired by comparison research against `piercelamb/deep-project`. Cross-verified (14/17), advisor-reviewed, 8-habit QA passed (13/17 → 15/17).

- **Interview protocol for `/requirements`** ([#118](https://github.com/pitimon/8-habit-ai-dev/issues/118)) — new `guides/templates/interview-protocol.md` gives structured conversation scaffolding (Quick/Standard/Deep depth) for discovering requirements before EARS criteria. Replaces the "ask the user 5 questions" default with a better-shaped discovery flow.
- **Workflow step awareness in session-start hook** ([#119](https://github.com/pitimon/8-habit-ai-dev/issues/119)) — `hooks/session-start.sh` now surfaces a workflow step cue so partial chains can resume across sessions without per-skill rework.
- **Machine-readable structured output blocks** ([#120](https://github.com/pitimon/8-habit-ai-dev/issues/120)) — new `guides/structured-output-protocol.md` defines `<!-- SKILL_OUTPUT:... END_SKILL_OUTPUT -->` HTML comment blocks at the end of `/requirements`, `/breakdown`, and `/review-ai`. Enables `/cross-verify` to auto-check scope alignment (task_count vs ears_count ≤ 3× ratio) and review coverage, reducing manual re-reading of prior-step artifacts.

---

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
