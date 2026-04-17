# Changelog

All notable changes to `8-habit-ai-dev` are documented here.

**Authoritative sources**: [GitHub Releases](https://github.com/pitimon/8-habit-ai-dev/releases) and [git tag history](https://github.com/pitimon/8-habit-ai-dev/tags).

This file summarizes recent versions. For v2.2.0 and earlier, see `docs/wiki/Changelog.md` or the Releases page.

Versioning follows [Semantic Versioning](https://semver.org/).

---

## v2.12.0 — Code-Symbol Grep Evidence (2026-04-17)

Minor release adding a new Evidence Standard obligation to the `/research` skill and clarifying the scope of the `research-verifier` agent ([#133](https://github.com/pitimon/8-habit-ai-dev/issues/133)). Guidance-only — no automation, no hook, no change to verifier execution behavior.

**Motivation**: A real-world Deep-mode `/research` tech-stack audit (memforge v1.10.0, 2026-04-17) produced a findings row verdicting `neo4j-driver` as "dead/transitional". The `research-verifier` agent passed the brief: every file path and line number cited was accurate. A downstream PRD and Design doc were produced recommending removal. A simple grep at the next workflow step revealed 5+ files with active imports — `neo4j-driver` is the canonical Bolt-protocol client for Memgraph (both engines share the same TS/Node client library). Removing it would have broken production graph on first image rebuild. The verdict passed Deep-mode verification on pristine citations while carrying a load-bearing false semantic claim.

### Added

- **`skills/research/SKILL.md` — Evidence Standard bullet**: when an Audit-mode or Findings-table row's verdict matches `/remove|dead|unused|transitional|safe to (drop|remove)/i` on a code symbol (dep, module, function, exported type, file), the row must cite a grep-check across the repo's source directories showing whether consumers exist. Declaration-site citations (e.g. `package.json:6`, import statements) do not establish liveness. Two concrete examples included (dead-verdict and keep-verdict shapes).
- **`skills/research/SKILL.md` — Step 4 scope callout**: one-line note after the Deep-mode dispatch makes explicit that the verifier gates citation integrity, not semantic correctness, and that code-symbol verdicts need separate grep evidence even when Deep-mode passes.
- **`skills/research/SKILL.md` — Definition-of-Done line**: new checklist item so code-symbol verdicts are visible at handoff time.
- **`agents/research-verifier.md` — `description:` frontmatter**: rewritten to "citation-integrity verification agent" with an explicit out-of-scope clause callers see before dispatching.
- **`agents/research-verifier.md` — `## Limit of Verification` section**: defines in-scope (file paths exist, line numbers contain the claimed text, URLs resolve, documents are findable) vs. out-of-scope (semantic correctness of conclusions) and introduces a `SEMANTIC-EVIDENCE-MISSING` flag the verifier emits when a code-symbol verdict row lacks liveness evidence. The verifier does **not** attempt the grep itself — that remains the author's obligation.

### Intentionally not in scope

- Expanding the `research-verifier` agent to semantically check conclusions. Per CONTRIBUTING.md philosophy ("Skills provide guidance, not automation"), this is a documentation change that gives Claude an explicit obligation for a specific verdict shape.
- `"revisit"` is intentionally **excluded** from the obligation trigger. It is a weaker, follow-up-style verdict that would over-trigger the grep requirement on rows that are merely flagged for attention. The hard-removal verdicts (`remove`, `dead`, `unused`, `transitional`, `safe to drop/remove`) are the load-bearing class.

### Cost/benefit

~2 seconds of grep per dead-verdict row. Benefit in the incident above: ~1 hour of downstream workflow (PRD + Design + archive + correction log) saved, plus averted production-graph breakage.

---

## v2.11.1 — CHANGELOG Drift Guard (2026-04-17)

Patch release hardening `validate-content.sh` Check 19 against a recurring documentation-drift pattern ([#124](https://github.com/pitimon/8-habit-ai-dev/issues/124), [PR #131](https://github.com/pitimon/8-habit-ai-dev/pull/131)). Post-v2.11.0 `/cross-verify` exposed that the same drift class slipped through CI twice — at v2.9.0 and v2.11.0 — because Check 19's pointer-fallback logic (`grep -Eq "v${ver}|CHANGELOG\.md"`) passed purely on the literal string "CHANGELOG.md" in the wiki file, not on any actual version entry. Two releases in a row = capability-level pattern; the fix is a fitness-function assertion, not a checklist.

### Added

- **Check 19 hardening** — 3 new **FAIL**-severity assertions (`tests/validate-content.sh` lines 518–567):
  - B. `CHANGELOG.md` contains `^## v<version>` section header
  - C. `docs/wiki/Changelog.md` contains `^## v<version>` section (pointer-to-CHANGELOG.md fallback removed — the stealth loophole)
  - D. `docs/wiki/Changelog.md` badge `latest-v<version>-blue` matches

### Fixed

- **`CHANGELOG.md`** — backfill missing v2.9.0 + v2.11.0 entries (file previously jumped v2.10.0 → v2.8.0).
- **`docs/wiki/Changelog.md`** — backfill missing v2.11.0 entry + bump stale badge `latest-v2.10.0` → `latest-v2.11.0`.

### Fitness

- `validate-structure.sh` 243/0, `validate-content.sh` **185/0** (was 183 + 2 net new pass-able assertions), `test-skill-graph.sh` 57/0, `test-verbosity-hook.sh` 19/0.

Closes [#124](https://github.com/pitimon/8-habit-ai-dev/issues/124). Lesson persisted as H7 capability pattern.

---

## v2.11.0 — Design Pipeline Completion + Wiki Redesign (2026-04-16)

Close the only remaining structured-output-block gap in the `/requirements` → `/design` → `/breakdown` → `/review-ai` handoff chain ([#128](https://github.com/pitimon/8-habit-ai-dev/issues/128), [PR #129](https://github.com/pitimon/8-habit-ai-dev/pull/129)) and upgrade 20 wiki pages to a professional template ([#127](https://github.com/pitimon/8-habit-ai-dev/issues/127), [PR #130](https://github.com/pitimon/8-habit-ai-dev/pull/130)). Both PRs merged within 3 minutes of each other (14:13 and 14:16 UTC).

### Added

- **`SKILL_OUTPUT:design` structured block** ([#128](https://github.com/pitimon/8-habit-ai-dev/issues/128)) — closes the last cross-skill handoff gap. `/cross-verify` Q4, Q14, Q16 now auto-populate (`✓A`) from the design block instead of requiring manual re-reading.
- **Tech-stack decisions as formal concerns** — `/design` Step 2 + `/research` Step 1 now surface language/framework choices as explicit design outputs, not implicit assumptions.
- **Scope validation via `SKILL_OUTPUT:requirements`** — `/design` now consumes the requirements block so the skill can flag scope drift between decisions and success criteria.
- **Decision granularity heuristic** — H3-based guidance for splitting vs grouping design decisions.
- **H8 Whole Person dimensions in `/design` checkpoint** — Body/Mind/Heart/Spirit prompts added alongside the existing pass/fail gate.
- **`docs/wiki/Architecture.md`** (new) — 4-layer plugin design documentation.
- **`docs/wiki/Maturity-Model.md`** (new) — 4-level adaptive guidance system.

### Changed

- **`docs/wiki/Home.md`** — rewritten as a hero landing page (49 → 108 lines).
- **`docs/wiki/Skills-Reference.md`** — expanded from 13 → 17 skills with quick-select matrix.
- **`docs/wiki/Workflow-Overview.md`** — upgraded with a Mermaid diagram and full 17-skill coverage.
- **All 8 Step wiki pages** — upgraded with `> [!IMPORTANT]` checkpoint callouts.
- **`docs/wiki/_Sidebar.md`** — reorganized with a new "Concepts" section.
- **`docs/wiki/FAQ.md`** — 2 new FAQ entries; **`docs/wiki/Getting-Started.md`** + **`docs/wiki/Vibe-Coding-vs-Structured.md`** updated with GitHub Alert boxes.
- **`docs/wiki/Installation.md`** — skills list updated to 17 skills across 4 categories.
- **Wiki redesign totals**: 18 files changed, 291 insertions, 53 deletions.

### Fitness

- `validate-structure.sh` 243/243 PASS, `validate-content.sh` 183/183 PASS, `test-skill-graph.sh` PASS, `test-verbosity-hook.sh` PASS — all green at release.

---

## v2.10.0 — Progressive-Disclosure SKILL.md Split (2026-04-16)

Refactor the 3 largest skills into `SKILL.md + reference.md + examples.md` triads to create headroom below the 2000-word F3 fitness-function ceiling. Pattern sourced from external research (`shanraisshan/claude-code-best-practice`), filtered through plugin-boundary audit — see [ADR-009](docs/adr/ADR-009-skill-split-convention.md).

### Added

- **ADR-009 — Progressive-disclosure SKILL.md split convention** ([#125](https://github.com/pitimon/8-habit-ai-dev/issues/125)) — decides Load-directive mechanism (inline `${CLAUDE_PLUGIN_ROOT}` paths), naming (`SKILL.md` + `reference.md` + `examples.md`), and when to apply (SKILL >1500w). Reuses existing Check 8 for sibling existence — no new fitness function needed for that.
- **F6 — Sibling word-budget soft limit** (`tests/validate-structure.sh` Check 9b) — warns when `skills/*/reference.md` or `skills/*/examples.md` exceeds 5000 words.
- **`skills/using-8-habits/reference.md` + `examples.md`** — split from 1990-word SKILL.md. `reference.md` holds the 17-skill inventory and cross-plugin composition tables; `examples.md` holds the password-reset onboarding walkthrough.
- **`skills/eu-ai-act-check/reference.md`** — split from 1989-word SKILL.md. Full 9-obligation checklist (25 MUST / 27 SHOULD / 8 COULD items) with article/paragraph references. No `examples.md` (pure-reference skill).
- **`skills/calibrate/reference.md` + `examples.md`** — split from 1774-word SKILL.md. Scoring rubric + profile-write procedure + 4 sample profiles (one per maturity level).

### Changed

- **`using-8-habits/SKILL.md`**: 1990 → 1108 words.
- **`eu-ai-act-check/SKILL.md`**: 1989 → 908 words.
- **`calibrate/SKILL.md`**: 1774 → 1161 words.
- **`tests/validate-content.sh` Checks 15 and 18** — search the SKILL + reference + examples triad as a unit for anti-drift, tier-count, and paragraph-reference assertions. Content moved to a sibling still counts. Triad-existence detection uses a safe for-loop (avoids `ls` non-zero exit under `set -euo pipefail`).

### Rejected (from the research brief at `plans/shiny-singing-dove.md`)

- 27-event hook system, PermissionRequest routing, batch processing — plugin-boundary violation; belongs in `pitimon/claude-governance`.
- Auto-load `user-invocable: false` background skills (Idea B), parallel cross-verify dispatch (Idea D) — separate decision cycles, not bundled into v2.10.
- F3 word-budget upgrade from WARN to FAIL — deferred; stays as WARN for this release.

### Fitness

- All 3 validators pass: `validate-structure.sh` 243/0, `test-skill-graph.sh` PASS, `validate-content.sh` 183/0 with 0 fitness breaches.

---

## v2.9.0 — Deep-Project Inspired Improvements (2026-04-13)

Three features inspired by comparison research against [`piercelamb/deep-project`](https://github.com/piercelamb/deep-project). Cross-verified (14/17), advisor-reviewed, 8-habit QA passed (13/17 → 15/17 after fixes). Released via PRs [#121](https://github.com/pitimon/8-habit-ai-dev/pull/121), [#122](https://github.com/pitimon/8-habit-ai-dev/pull/122), [#123](https://github.com/pitimon/8-habit-ai-dev/pull/123).

### Added

- **Interview protocol for `/requirements`** ([#118](https://github.com/pitimon/8-habit-ai-dev/issues/118), [PR #121](https://github.com/pitimon/8-habit-ai-dev/pull/121)) — new `guides/templates/interview-protocol.md` gives structured conversation scaffolding (Quick / Standard / Deep depth) for discovering requirements before EARS criteria. Replaces the "ask the user 5 questions" default with a better-shaped discovery flow.
- **Workflow step awareness in session-start hook** ([#119](https://github.com/pitimon/8-habit-ai-dev/issues/119), [PR #122](https://github.com/pitimon/8-habit-ai-dev/pull/122)) — `hooks/session-start.sh` now surfaces a workflow step cue so partial chains can resume across sessions without per-skill rework. Respects existing `HABIT_QUIET=1` opt-out.
- **Machine-readable structured output blocks** ([#120](https://github.com/pitimon/8-habit-ai-dev/issues/120), [PR #123](https://github.com/pitimon/8-habit-ai-dev/pull/123)) — new `guides/structured-output-protocol.md` defines `<!-- SKILL_OUTPUT:... END_SKILL_OUTPUT -->` HTML comment blocks at the end of `/requirements`, `/breakdown`, and `/review-ai`. Enables `/cross-verify` to auto-populate (`✓A`) answers from producer skills instead of requiring manual re-reading of prior-step artifacts.

### Fixed

- **Scope-alignment threshold in `/cross-verify` Q8** — QA raised the `task_count` vs `ears_count` ratio guard from hardcoded `3×` to a documented `≤ 3×` threshold so the heuristic is auditable and adjustable.

### Fitness

- `validate-structure.sh` 238/238 PASS, `validate-content.sh` 177/177 PASS, `test-skill-graph.sh` 57/57 PASS, `test-verbosity-hook.sh` 19/19 PASS — 491/491 total at release commit `8123b25`.

---

## v2.8.0 — Claude Code Architecture Insights (2026-04-13)

Production patterns from Anthropic's Claude Code internals — reverse-engineered in ["Claude Code from Source"](https://github.com/alejandrobalderas/claude-code-from-source) (Alejandro Balderas, 18-chapter architectural analysis of the March 2026 npm source map leak) — adapted into 4 existing skills as workflow guidance. All changes are skill-level guidance additions; no runtime hooks, no new files, no new dependencies.

### Added

- **`/build-brief` step 6 "Context survival"** ([#114](https://github.com/pitimon/8-habit-ai-dev/issues/114)) — guidance for briefs that survive Claude Code's 4-layer context compression pipeline. Recommends: front-load critical info, keep briefs under ~4,000 tokens, stable-first ordering for prompt cache stability. Inspired by Ch5 (Agent Loop) and Ch17 (Performance).
- **`/design` step 5 "Identify sticky decisions"** ([#116](https://github.com/pitimon/8-habit-ai-dev/issues/116)) — rework-level classification table (Sticky >50% / Semi-sticky 10-50% / Flexible <10%). Decisions marked STICKY require a new `/design` cycle to change. Inspired by Ch17 sticky boolean latches for prompt cache stability. Maps to H2 (Begin with End in Mind).
- **`/reflect` Step 7 "Consolidation check" + `/reflect consolidate` argument** ([#113](https://github.com/pitimon/8-habit-ai-dev/issues/113)) — nudges when lesson files exceed 10; new consolidate mode runs 4-phase cycle (Orient → Gather → Consolidate → Prune) with human approval gate before deletions. Inspired by Ch11 auto-dream memory consolidation. Added Bash to allowed-tools for prune phase.
- **`/breakdown` step 5 "Token-efficient parallel design"** ([#115](https://github.com/pitimon/8-habit-ai-dev/issues/115)) — prompt prefix sharing guidance with efficiency table. Parallel tasks sharing context achieve ~90% input token savings via cache hits. Most valuable for 3+ parallel tasks. Inspired by Ch9 (Fork Agents).

### Research

- Deep research review of "Claude Code from Source" (18 chapters, 7 Parts) produced a [research brief](https://github.com/pitimon/8-habit-ai-dev/milestone/13) scoring the book 8.5/10 with live system cross-verification of Ch11 Memory claims (5/8 confirmed against running Claude Code v2.1.104).
- KAIROS mode and `/dream` command investigated — confirmed as real feature-flagged code (not speculation), but not shipped in external builds as of April 2026.

---

## v2.7.1 — Review Discipline Refinement (2026-04-11)

Small post-milestone patch on top of v2.7.0. Adds two review-time disciplines to `/review-ai` after a cost/benefit audit against Addy Osmani's `agent-skills` repository (MIT). Only one of six candidate mechanics was imported — the other five were explicitly rejected as duplicative of existing plugin features or out-of-scope for the `8-habit-ai-dev` plugin boundary. Scope deliberately minimal to honor the v2.7.0 "local maximum" framing from `~/.claude/lessons/2026-04-11-issue-96-reader-adoption.md`.

### Added

- **`/review-ai` Performance axis** ([#110](https://github.com/pitimon/8-habit-ai-dev/issues/110), [PR #111](https://github.com/pitimon/8-habit-ai-dev/pull/111)) — fourth review category alongside Security / Quality / Completeness, flagging N+1 queries, unbounded loops, missing pagination on list endpoints, unindexed queries on large tables, and memory leaks (unclosed streams, unbounded caches, retained references). Performance findings follow the same `file:line` evidence standard as the other axes.
- **`/review-ai` review-tests-first directive** — new Process step 2 directs the reviewer to open the new or changed test files _before_ judging the implementation. Tests declare the _intended_ behavior; reading them first gives you the specification to review the code against. If new logic has no corresponding test, record it as a Completeness finding.
- **Verdict output table** now lists four category rows (Security / Quality / Performance / Completeness); Definition of Done checkbox references all four categories by name.

### Not Added (deliberately rejected after cost/benefit audit)

The research brief evaluated six agent-skills mechanics; five were rejected. Rejection rationale is archived in PR #111's body and the local plan file `~/.claude/plans/drifting-waddling-pascal.md` so future "research hype" passes don't re-litigate the same ground:

- ❌ `guides/anti-rationalization.md` — already present as 24 anti-patterns in `rules/effective-development.md` + 12 commandments in `guides/integrity-principles.md`, just in different prose form
- ❌ `guides/red-flags.md` — `/reflect` and `/cross-verify` already provide self-detection
- ❌ `guides/google-engineering-principles.md` (Hyrum's Law / Beyoncé Rule / Trunk-Based Development) — cultural flavor over existing substance; no new discipline the plugin lacks
- ❌ `/cross-verify` Q18 "Beyoncé check" — existing questions already probe test coverage gaps
- ❌ Cross-plugin hard-gate progression spec — no user demand signal; runtime enforcement belongs in `claude-governance`, not here

### Fitness functions

- All 4 validators green: `validate-structure.sh` 238/238, `validate-content.sh` 177/177, F1/F2/F3 HEALTHY, `test-verbosity-hook.sh` 11/11
- `skills/review-ai/SKILL.md` word count: 890 → 1025 (F3 ceiling 2000, headroom 975 retained)
- Validator assertion total unchanged — this patch does not add or remove assertions

### Source attribution

- Research source: [`addyosmani/agent-skills`](https://github.com/addyosmani/agent-skills) (MIT)
- No code or text was directly copied; only the _idea_ of a Performance review axis and a tests-first directive were adapted

---

## v2.7.0 — Reader Adoption (2026-04-11)

Closes the reader-adoption half of the `/calibrate` feature loop. v2.6.0 shipped `/calibrate` which **writes** `~/.claude/habit-profile.md`; until this release, the 17 skills did not **read** the profile, so the feature delivered discovery but not adaptation. v2.7.0 closes that gap via a hook-based adaptation directive — zero changes to individual skill files.

### Added

- **Hook-based verbosity adaptation** ([#96](https://github.com/pitimon/8-habit-ai-dev/issues/96)) — `hooks/session-start.sh` now reads `~/.claude/habit-profile.md` at session start and emits a level-specific one-sentence directive into session context. Claude honors the directive when invoking any skill in the session, adapting verbosity automatically from Dependence (full guidance) through Independence, Interdependence, and Significance (minimal prompts).
- **`guides/verbosity-adaptation.md`** (new) — canonical per-level adaptation rules + worked examples across 5 skill archetypes (workflow planning, review/gate, research, implementation, retrospective). Reference material for maintainers and future skill authors. Not auto-loaded at runtime — the hook hardcodes its one-sentence directive per level from these rules.
- **`tests/test-verbosity-hook.sh`** (new) — 11-check regression coverage for all 8 hook branches: missing profile, 4 levels (Dependence/Independence/Interdependence/Significance), 2 overrides (verbose/concise), unknown level with Dependence fallback, plus HABIT_QUIET silence check and ≤300-token budget assertion. Wired into `.github/workflows/validate.yml` alongside the 3 existing validators.
- **`preferences.verbosity-override` precedence in the hook** — `verbose` promotes any level to Dependence; `concise` demotes any level to Significance; `none` or unset uses the profile `level` as-is. Matches the schema v1 contract documented in `guides/habit-profile-schema.md`.

### Architectural constraint honored (why hook-based, not per-skill)

A pre-implementation F3 word-budget audit surfaced two skills with dangerously thin headroom: `/using-8-habits` (1990/2000 words, 10 headroom) and `/eu-ai-act-check` (1989/2000 words, 11 headroom). Any per-skill text addition would have broken F3 fitness on the next edit — even a 15-word preamble like `Load guides/verbosity-adaptation.md` would overflow.

The only viable runtime injection point in a pure-markdown plugin is `hooks/session-start.sh`, which outputs into session context once per session and applies globally to all subsequent skill invocations. The hook approach ships with **zero changes to individual skill files** — F3 preserved, validators untouched, existing skill bodies unchanged. Future skill authors don't need to add level-handling boilerplate; the directive is already in session context when they're invoked.

### Changed

- `hooks/session-start.sh` — expanded from the v2.6.0 static `/calibrate` nudge to a full 8-branch profile reader. Existing behavior preserved: when no profile exists, the v2.6.0 nudge still fires unchanged. Uses the pipe-safe `awk` pattern from v2.6.1's SIGPIPE fix to parse YAML frontmatter.
- `.github/workflows/validate.yml` — now runs 4 validators instead of 3 (added `tests/test-verbosity-hook.sh`).
- `CLAUDE.md` — added a Key Conventions bullet documenting the hook-based verbosity adaptation mechanism.

### Milestone v2.7.0 — CLOSED (1/1)

With this release, [milestone v2.7.0 — Reader Adoption](https://github.com/pitimon/8-habit-ai-dev/milestone/12) is closed. Issue #96 was the sole scope. The #90 user-calibration feature loop is now complete: write (v2.6.0) → read (v2.7.0).

### Migration notes

No breaking changes. Users upgrading from v2.6.1:

- If you have a profile at `~/.claude/habit-profile.md`, the session-start hook will emit your level-specific directive on the next session start. No action needed.
- If you don't yet have a profile, the existing v2.6.0 nudge still fires suggesting `/calibrate`. Behavior unchanged from v2.6.1.
- `HABIT_QUIET=1` continues to silence everything (ADR-006 contract preserved).
- If you want to override your level-default behavior, edit `~/.claude/habit-profile.md` and set `preferences.verbosity-override` to `verbose` (max guidance) or `concise` (minimum). `none` or unset uses the level as-is.

### What's next (beyond v2.7.0)

The Hermes-inspired feature loop (milestones v2.6.0 + v2.7.0) is complete. Further enhancements are either out-of-scope (runtime-dependent features like Honcho passive inference — would violate the pure-markdown constraint) or delegated to companion plugins (`claude-mem`, `pitimon/claude-governance`, `devsecops-ai-team`). The plugin is at a local maximum given its constraints.

Potential v2.8.0+ targets, if user demand emerges:

- Dual-artifact strategy for agentskills.io (publish individual standalone skills to the open registry while keeping the chain-enforcing SKILL.md here) — per ADR-007 §Future Triggers
- Progressive disclosure for skill bodies (split `SKILL.md` into summary + `references/*.md` deep-dives) if token budgets get tight

---

## v2.6.1 — Skill Effectiveness Tracking (2026-04-11)

Closes milestone v2.6.0 by shipping the final P3 issue from the Hermes-Inspired research brief. This is a minor patch release — one question added to `/reflect` plus a new maintainer-curated report file. No breaking changes, no migrations.

### Added

- **`/reflect` Q6 — Skill effectiveness signal** ([#92](https://github.com/pitimon/8-habit-ai-dev/issues/92)) — `/reflect` now asks "which skill was most useful this session, and which was least useful or confusing?" after the 5 standard retro questions. Answer can be `n/a` if no skills were invoked. Feeds periodic maintainer trend analysis.
- **`SKILL-EFFECTIVENESS.md`** (repo root) — maintainer-curated trend tracker aggregating Q6 signals from `~/.claude/lessons/*.md` across time. Ships empty (initial state, awaiting data). Includes explicit update protocol, "what this is NOT" boundaries, and per-skill tally table for all 17 skills. This is **H7 (Sharpen the Saw) applied to the plugin itself** — invest in the capability of the skills, not just their output.
- **`guides/templates/lesson-template.md`** — added `## Skill effectiveness` section to the lesson template body so Q6 answers are captured consistently across user lesson files.

### Changed

- `skills/reflect/SKILL.md` — updated description from "5 questions" to "6 questions" (still fits the "5 minutes" DORA budget — Q6 is a 30-second signal question). Output table, Persist step, and Definition of Done all updated. Word count: 561 → 711 (well under 2000 F3 fitness budget).
- `CLAUDE.md` Skills → Habits table — `/reflect` row now notes the skill-effectiveness signal.

### Architectural constraint honored

`SKILL-EFFECTIVENESS.md` is **maintainer-curated, not auto-generated**. A runtime aggregator that scans `~/.claude/lessons/*.md` across users would need to be a hook (belongs in `pitimon/claude-governance` per plugin boundary) or would violate the "skills are read-only guidance" principle. The chosen design — maintainer reads lessons periodically, updates the report, commits — respects both constraints and matches ADR-008's schema-as-contract pattern (report format is a stable contract between `/reflect` writers and maintainer readers).

### Fixed

- **`tests/validate-content.sh` F3 convention-consistency check** — replaced `sed -n '/^---$/,/^---$/p' "$skill_file" | head -20` with an awk-based frontmatter extractor that exits cleanly at the second `---` marker. The old pattern was flaky under `set -o pipefail` on Linux CI (GNU sed) because `skills/ai-dev-log/SKILL.md` has a body horizontal rule at line 65, causing sed to emit 187 lines from a 239-line file; `head -20` closed early, sed hit SIGPIPE, and CI failed with exit code 4. BSD sed on macOS silently ignores SIGPIPE which masked the bug locally. Fix uses the same awk pattern already documented at `tests/validate-structure.sh:27`. The bug was latent since ai-dev-log gained its body `---` rule and caught PR #99 on its first CI run. No functional change to the F3 check — only the extraction mechanism.

### Milestone v2.6.0 — now CLOSED (5/5)

With this release, all five Hermes-Inspired issues are shipped:

- ✅ #88 Persistent Reflection Artifacts (v2.6.0)
- ✅ #89 Habit Nudge Guidance Document (v2.6.0)
- ✅ #91 agentskills.io Compatibility Evaluation — NO-GO (v2.6.0)
- ✅ #90 User Maturity Calibration — `/calibrate` (v2.6.0)
- ✅ #92 Skill Effectiveness Tracking — `/reflect` Q6 + report (v2.6.1, **this release**)

Follow-up [#96](https://github.com/pitimon/8-habit-ai-dev/issues/96) (16-skill reader adoption for `habit-profile.md`) remains open for v2.7.0.

### Migration notes

No breaking changes. Users upgrading from v2.6.0:

- Next `/reflect` invocation will include Q6. Answer `n/a` if no skills apply.
- Your existing lesson files at `~/.claude/lessons/*.md` are unchanged. New lessons written after upgrade will include the `## Skill effectiveness` section.
- `SKILL-EFFECTIVENESS.md` ships empty — data accumulates as you reflect.

---

## v2.6.0 — Hermes-Inspired Improvements (2026-04-11)

Operationalizes four user-modeling and learning-loop patterns inspired by Hermes Agent (Nous Research), filtered through plugin-boundary discipline and cross-verification. Milestone v2.6.0 scope: P1 + P2 issues shipped (4/5 closed); #92 deferred to v2.6.1 or v2.7.0.

### Added

- **`/calibrate` skill + habit-profile schema v1** ([#90](https://github.com/pitimon/8-habit-ai-dev/issues/90), [ADR-008](docs/adr/ADR-008-user-maturity-calibration-design.md)) — new standalone skill that asks 5-7 questions and writes `~/.claude/habit-profile.md` so other skills can adapt verbosity to the user's maturity level (Dependence → Independence → Interdependence → Significance). Uses dominant-level scoring rubric adapted from `guides/whole-person-rubrics.md`. Writer side only — reader adoption for the 16 existing skills is tracked as [#96](https://github.com/pitimon/8-habit-ai-dev/issues/96) for v2.7.0.
- **`guides/habit-profile-schema.md`** — public schema contract (v1, YAML frontmatter + markdown body, versioned via `schema-version`). Defines the API future reader skills code against; documents reader compatibility expectations and the BSD-vs-GNU date syntax caveat for age calculations.
- **Persistent reflection artifacts** ([#88](https://github.com/pitimon/8-habit-ai-dev/issues/88)) — `/reflect` now persists lessons to `~/.claude/lessons/YYYY-MM-DD-<slug>.md`. `/research` and `/build-brief` search these before starting work. Closes the learning loop: reflect → persist → retrieve → apply.
- **`guides/habit-nudges.md`** ([#89](https://github.com/pitimon/8-habit-ai-dev/issues/89)) — specification document for proactive workflow reminders (hook implementation belongs in `pitimon/claude-governance` per plugin boundary — this is the spec side).
- **`guides/agentskills-compatibility-eval.md`** + **ADR-007** ([#91](https://github.com/pitimon/8-habit-ai-dev/issues/91)) — Deep + Compare research brief evaluating migration to the agentskills.io open standard. Decision: **NO-GO**. Other tools only parse `name`/`description`, not `metadata.*`, so migrating would trade the DAG validator's chain enforcement for a prose convention — a net loss. Hands-on sandbox test included.
- **ADR-008** — User Maturity Calibration design record with 5 interlocking decisions: Alt E hybrid, dominant-level scoring, YAML frontmatter schema, standalone chain position, user-driven re-calibration with age warning.
- **`/calibrate` discovery nudge** in `hooks/session-start.sh` — when `~/.claude/habit-profile.md` is missing, append a one-line 💡 nudge to the Onboarding line. Fully respects existing `HABIT_QUIET=1` opt-out from ADR-006.

### Changed

- Skill count: **16 → 17** (`/calibrate` added). Updated across README badge, CLAUDE.md Skills → Habits table, SELF-CHECK.md, `/using-8-habits` inventory, and `validate-structure.sh` counter.
- `skills/using-8-habits/SKILL.md` — added `/calibrate` entry to the Assessment skills inventory; trimmed existing content to stay under F3 convention-consistency fitness budget (now 1990/2000 words — monitor margin for future edits).
- `hooks/session-start.sh` — Onboarding line now lists `/calibrate` alongside `/using-8-habits`.
- Validators expanded: **443 → 470 PASS** across 3 validators with 17/17 F3 convention-consistency.

### Not Changed (Deferred or Out-of-Scope)

- **Reader adoption for the 16 pre-v2.6.0 skills** — tracked as [#96](https://github.com/pitimon/8-habit-ai-dev/issues/96) for v2.7.0. Reading the profile and adjusting verbosity is a cross-cutting change that deserves its own PR.
- **Issue [#92](https://github.com/pitimon/8-habit-ai-dev/issues/92) Skill Effectiveness Tracking** (P3) — remains open, deferrable to v2.6.1 or v2.7.0.

### Migration notes

No breaking changes. New users installing v2.6.0 for the first time will be nudged to run `/calibrate` on their next session. Existing users can opt in anytime by running `/calibrate` directly. Users who prefer the previous behavior can export `HABIT_QUIET=1` to silence both the session-start reminder and the calibration nudge.

---

## v2.5.0 — Testing & Discoverability (2026-04-09)

### Added

- **`tests/test-skill-graph.sh`** — DAG validator for `prev-skill`/`next-skill` chains (#79). Checks: cycles, dangling refs, symmetric edges, chain anchors, orphans. 55 assertions. Wired into CI.
- **`hooks/pre-commit.sh.example`** — template that runs `/review-ai` on staged files before commit (#80). Copy to `.git/hooks/pre-commit` to opt in. NOT auto-installed.
- **Bidirectional wiki ↔ skills linking** (#81) — each workflow skill (Steps 0-7) now has a `## Further Reading` section linking to its wiki page. Validator Check 15b enforces both directions.
- **Validator Check 15a** — asserts `pre-commit.sh.example` exists and is NOT executable.

### Changed

- CI now runs 3 validators: `validate-structure.sh` + `test-skill-graph.sh` + `validate-content.sh`
- Version bump 2.4.1 → 2.5.0

---

## v2.4.1 — Honest Correction (2026-04-09)

Same-day correction after reading the `claude-plugins-official:superpowers` `brainstorming` source and confirming our `/brainstorm` (shipped in v2.4.0) was a weaker reimplementation of ~60% of its functionality.

### Removed (breaking — install `superpowers` for equivalent)

- **`/brainstorm` skill** — deleted. Superpowers' `brainstorming` ships a 500+ line hard-gate discipline suite with spec doc written to git, visual companion, one-question-at-a-time dialogue, and 143K installs. `/research` now references it for fuzzy problem statements. See ADR-006 for the lesson.

### Added

- **`HABIT_QUIET=1` opt-out** for `hooks/session-start.sh` — reduces religious adherence pressure. Users who internalize the workflow can silence the reminder via env var.
- **"Core 5" tier** in `/using-8-habits` — acknowledges 80/20 reality: most daily work uses `/requirements`, `/review-ai`, `/cross-verify`, `/research`, `/reflect`. The other 11 skills are optional depth.
- **ADR-006** — documents audience honesty + opt-out + "check installed peer plugins before building parity features" lesson.

### Changed

- `hooks/session-start.sh` banner softened: "7-Step Workflow (not Vibe Coding)" → "7-Step Workflow reference — use what fits the task"
- Skills count: 17 → 16 (removed `/brainstorm`)

---

## v2.4.0 — Workflow Completions (2026-04-09)

Three workflow additions closing parity gaps with peer plugins.

### Added

- **`/brainstorm`** (Step 0a) — divergent thinking BEFORE `/research`. 5 Whys, alternative framings, hidden assumptions. Crisp separation from `/research`: brainstorm = divergent (no sources), research = convergent (with sources). Maps to H2 + H5. Closes parity gap with Superpowers plugin (29K⭐, 143K installs).
- **EARS-notation in `/requirements`** — 5 structured acceptance criteria templates (Ubiquitous, Event-driven, State-driven, Unwanted, Optional) from Rolls-Royce (Mavin et al. 2009). New `guides/ears-notation.md` reference (~130 lines). Login worked example. Explicit opt-out rule for small features (<3 criteria). Closes parity gap with GitHub Spec Kit (84.7K⭐) and AWS Kiro.
- **`/using-8-habits`** — onboarding meta-skill with decision tree for "which skill next?" + complete walkthrough example (password reset, 11 skill invocations). Closes parity gap with addyosmani/agent-skills (8.3K⭐) `using-agent-skills`.
- **Check 16/17/18** in `validate-content.sh`: +52 assertions covering new skills with **anti-drift check** — meta-skill must mention every skill in `skills/` directory.

### Changed

- Skills: **15 → 17** (9 workflow + 8 standalone)
- `CLAUDE.md` Skills→Habits Mapping table updated with new rows
- `README.md` Skills badge `15` → `17`, tree "9 workflow + 8 standalone"
- `skills/workflow/SKILL.md` table adds Step 0a row for `/brainstorm`
- `skills/requirements/SKILL.md` gains new Step 4 with EARS template + opt-out rule

### Fixed

- **`validate-structure.sh`** regex `[a-z-]` → `[a-z0-9-]` — latent bug that rejected skill names containing digits (exposed by `using-8-habits`)

### Validation

Total assertions: **376** (up from 302): `validate-structure.sh` 219 + `validate-content.sh` 157.

Pull requests: #72 (brainstorm) · #73 (EARS) · #74 (meta-skill + version bump) · #76 (design Three Loops reference)

---

## v2.3.0 — EU AI Act Compliance Toolkit (2026-04-09)

Flagship blue-ocean feature: first Claude Code plugin with explicit EU AI Act compliance toolkit, shipped ~4 months before 2 August 2026 enforcement.

### Added

- **`/eu-ai-act-check`** — 9-obligation tiered checklist (25 MUST + 27 SHOULD + 8 COULD) covering Articles 9-15. Scope pre-flight (Annex III × EU market matrix). Default mode runs MUST only; `--full` includes SHOULD + COULD. All items anchored to Article paragraph numbers with verbatim quotes.
- **`/ai-dev-log`** + **`scripts/generate-ai-dev-log.sh`** — AI-assisted development log generator from `git log` + Co-Authored-By trailers. 4 modes: markdown (default), `--json`, `--summary`, `--out FILE`. Single-pass awk aggregation (4× faster than naive implementation). `set -euo pipefail`, dependency check, tempfile cleanup trap, macOS BSD + Linux GNU `date` compatible.
- **`/design`** Step 5 — Article 14 human-oversight 5-capability checkpoint (¶4(a-e): Understand / Automation bias / Interpret / Override / Stop button).
- **`docs/research/eu-ai-act-obligations.md`** (~351 lines) — primary-source research with verbatim Verified Quotes for all 7 articles (9-15), fetched via web.archive.org (FLI mirror of OJ text). Cross-verified by `research-verifier` agent against EC AI Act Service Desk.
- **`guides/eu-ai-act-mapping.md`** (~364 lines) — user-facing 3-step workflow with end-to-end medical triage example, bootstrap `mkdir` block, NOT LEGAL ADVICE disclaimer at top.
- **ADR-005** — decision record with 4 alternatives considered + CLAUDE.md convention compliance table.
- **Check 15** in `validate-content.sh` — 24 new assertions with **auto tier-count verification** (prevents "claimed 22 actual 25" bugs).
- **Plugin Boundary section** in `CLAUDE.md` — documents the complementary relationship with [`pitimon/claude-governance`](https://github.com/pitimon/claude-governance) to prevent future scope drift. 8-habit-ai-dev = workflow discipline; claude-governance = compliance enforcement + frameworks.

### Changed

- Version file convention: "Version lives in **4 files**" (was incorrectly documented as "3 files"). `tests/validate-structure.sh` enforces consistency across `plugin.json`, `marketplace.json`, `README.md` (badge + footer), and `SELF-CHECK.md`.
- `CLAUDE.md` Bash tool policy documented explicitly: allowed in `review-ai`, `eu-ai-act-check`, `ai-dev-log`. New skills default to `Read/Glob/Grep` only.

### Fixed

- `tests/validate-structure.sh` intermittent SIGPIPE failure — replaced `sed | head` with awk-only extraction to eliminate broken-pipe race under `set -o pipefail`.
- `SELF-CHECK.md` version drift — CI silently accepted stale version until validator was updated.

### Quality

- Cross-verify: **15/15 Well-Prepared** at ship (plan-level) + **16/16** at Stage A execution.
- 8 bugs caught in self-review before merge.
- Total assertions: **302** (199 structure + 103 content).

### Architectural Note

Post-ship boundary review identified that EU AI Act belongs architecturally in `claude-governance` (alongside existing DSGAI-MAPPING.md). A Path C hybrid migration is tracked in [pitimon/claude-governance#21](https://github.com/pitimon/claude-governance/issues/21) for a future release. v2.3.0 ships the toolkit here temporarily; install both plugins together for maximum coverage.

Pull requests: #65 (research + guide) · #66 (skill + design) · #67 (ai-dev-log) · #68 (version bump + ADR-005) · #69 (Check 15 validation) · #70 (version-files fix + SIGPIPE) · #71 (Plugin Boundary section, Stage A of Path C)

---

## Earlier Versions

See [`docs/wiki/Changelog.md`](docs/wiki/Changelog.md) for v2.2.0 and earlier, or the [GitHub Releases page](https://github.com/pitimon/8-habit-ai-dev/releases) for the authoritative release history.

### Recent Highlights (v2.0–v2.2)

- **v2.2.0** (2026-04-07) — Body Dimension Level-Up: content validation + fitness functions
- **v2.1.0** (2026-04-07) — Multi-Agent Research (Feynman-inspired)
- **v2.0.0** (2026-04-07) — Orchestration-Aware Development (ULW-inspired)
