# Changelog

All notable changes to `8-habit-ai-dev` are documented here.

**Authoritative sources**: [GitHub Releases](https://github.com/pitimon/8-habit-ai-dev/releases) and [git tag history](https://github.com/pitimon/8-habit-ai-dev/tags).

This file summarizes recent versions. For v2.2.0 and earlier, see `docs/wiki/Changelog.md` or the Releases page.

Versioning follows [Semantic Versioning](https://semver.org/).

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
