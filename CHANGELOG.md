# Changelog

All notable changes to `8-habit-ai-dev` are documented here.

**Authoritative sources**: [GitHub Releases](https://github.com/pitimon/8-habit-ai-dev/releases) and [git tag history](https://github.com/pitimon/8-habit-ai-dev/tags).

This file summarizes recent versions. For v2.2.0 and earlier, see `docs/wiki/Changelog.md` or the Releases page.

Versioning follows [Semantic Versioning](https://semver.org/).

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
