# CLAUDE.md

> **Non-Claude agents** (Codex, Cursor, Windsurf, Aider, Continue): start at [`AGENTS.md`](AGENTS.md). [`llms.txt`](llms.txt) is the full doc map. Claude Code users: this file is auto-loaded — keep reading.

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A **Claude Code plugin** (not a runnable application). No build system, no dependencies — the entire plugin is structured markdown files that Claude Code loads at runtime. Structural validation via `tests/validate-structure.sh` (pure bash, no test framework). The plugin provides a 7-step workflow discipline based on Covey's 8 Habits, designed to replace "vibe coding" with structured AI-assisted development. Install: `claude plugin marketplace add pitimon/8-habit-ai-dev && claude plugin install 8-habit-ai-dev@pitimon-8-habit-ai-dev`.

`deep-project/` is a git-ignored local vendor of a third-party plugin — not part of this repo's tracked surface.

## Validation Commands

CI ([`.github/workflows/validate.yml`](.github/workflows/validate.yml)) runs exactly these five scripts. Run them from the repo root with `bash` (they use process substitution — `sh` fails):

```bash
bash tests/validate-structure.sh   # frontmatter, 6-file version consistency, mirror parity (Check 28), size caps
bash tests/test-skill-graph.sh     # prev-skill/next-skill DAG integrity
bash tests/validate-content.sh     # content fitness functions; Check 19 needs full tag history (CI uses fetch-depth: 0)
bash tests/test-verbosity-hook.sh  # session-start verbosity regression (8 branches + override + budget)
bash tests/test-pre-commit-hook.sh # pre-commit F6 fail-closed verdict paths
```

When skill metadata or discovery docs change, also run `node scripts/generate-skill-catalog.js --check` (regenerate by running without `--check`). External URLs are link-checked in separate workflows (`link-check.yml`, `wiki-linkcheck.yml`); internal relative links are Check 12b in `validate-content.sh`.

When editing the test scripts themselves: extract frontmatter with a single `awk`, never `sed | grep | head` under `set -o pipefail` — the SIGPIPE race caused intermittent CI failures. See `CONTRIBUTING.md` §"Testing Conventions".

## The `plugin/` Mirror (edit → sync, always)

`plugin/` is a **real, git-tracked, byte-for-byte copy** of the root content — the Codex marketplace child package per [ADR-023](docs/adr/ADR-023-codex-native-packaging.md) (a `plugin -> .` symlink broke Linux installs; see `docs/out-of-scope/mirror-untracking.md` for why it stays tracked). Check 28 in `validate-structure.sh` enforces parity, so after editing any mirrored path — the dirs `skills/ guides/ habits/ hooks/ agents/ rules/ scripts/ docs/` or the root files listed in `scripts/sync-mirror.sh` (including `README.md`, `CHANGELOG.md`, and **this file**) — run:

```bash
bash scripts/sync-mirror.sh   # then git add the changed plugin/ files in the same commit
```

Exception: `.codex-plugin/` manifests are intentionally distinct between root and `plugin/` — never copy one over the other.

## Architecture

The plugin has three loading mechanisms with distinct timing:

1. **`rules/effective-development.md`** — Auto-loaded into every Claude Code session (via Claude's rules system). Contains the full 8-Habit playbook with Rules, Anti-patterns, and Checkpoints per habit.
2. **`hooks/session-start.sh`** — Runs at SessionStart (registered in `hooks/hooks.json`). Prints a ≤300-token reminder of the 7-step workflow.
3. **`skills/*/SKILL.md`** — Loaded on-demand when user invokes a skill. Skills reference habit content via `Load ${CLAUDE_PLUGIN_ROOT}/habits/h*.md` — habit files are NOT loaded at session start. Keeps the token budget lean.

## Skill Authoring Conventions

Each skill file (`skills/<name>/SKILL.md`) uses this frontmatter:

```yaml
---
name: <skill-name> # Must match directory name
description: > # Multi-line, explains when to use
user-invocable: true
argument-hint: "[description]"
allowed-tools: ["Read", "Glob", "Grep"] # Bash only when justified
prev-skill: <skill-name|none|any> # Predecessor in 7-step chain
next-skill: <skill-name|none|any> # Successor in 7-step chain
---
```

Body pattern: Habit mapping → Process steps → Handoff → When to Skip → Definition of Done → H\* Checkpoint → Load directive. Standalone skills use `any` for prev/next. See [ADR-009](docs/adr/ADR-009-skill-split-convention.md) for convention rationale.

## Key Conventions (cited)

- **Session hook ≤300 tokens** — `hooks/session-start.sh` output budget (file header line 2). Compliance tracked in [ADR-005](docs/adr/ADR-005-eu-ai-act-compliance-toolkit.md) §"Session hook ≤300 tokens" check; relaxation discussed in [ADR-008](docs/adr/ADR-008-user-maturity-calibration-design.md).
- **Version lives in 6 files** — `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`, `.codex-plugin/plugin.json`, `plugin/.codex-plugin/plugin.json`, `README.md` (badge + footer), `SELF-CHECK.md` header. Bumped together; `tests/validate-structure.sh` fails CI on drift. See [issue #106](https://github.com/pitimon/8-habit-ai-dev/issues/106) (the drift incident that motivated `SELF-CHECK.md` enforcement), [ADR-023](docs/adr/ADR-023-codex-native-packaging.md) (Codex packaging), and `CONTRIBUTING.md` §"Version Bumping".
- **Lesson persistence** — `/reflect` saves lesson files to `~/.claude/lessons/YYYY-MM-DD-<slug>.md` (v2.6.0); `/research` and `/build-brief` search these before starting. Feedback loop activated in [ADR-018](docs/adr/ADR-018-memory-layer-activation.md) (memory-layer activation).
- **Verbosity adaptation** — `hooks/session-start.sh` reads `~/.claude/habit-profile.md` and emits a level-specific directive into session context (v2.7.0). Closes [#96](https://github.com/pitimon/8-habit-ai-dev/issues/96) (reader half of the [#90](https://github.com/pitimon/8-habit-ai-dev/issues/90) `/calibrate` loop). Respects `HABIT_QUIET=1` opt-out from [ADR-006](docs/adr/ADR-006-audience-honesty-and-superpowers-deferral.md). Canonical rules in [`guides/verbosity-adaptation.md`](guides/verbosity-adaptation.md).
- **Release checklist must include the SKILL-EFFECTIVENESS tally update** — anti-dormancy forcing function per [ADR-018](docs/adr/ADR-018-memory-layer-activation.md) §"Forward-Guardrail Sunset". See `CONTRIBUTING.md` §"Release Checklist" and [issue #227](https://github.com/pitimon/8-habit-ai-dev/issues/227). Skipping ≥2 cycles triggers ADR-018 reversal review.

## Plugin Boundary

`8-habit-ai-dev` and [`pitimon/claude-governance`](https://github.com/pitimon/claude-governance) are **complementary by design** (memory obs #233270, 2026-04-07). Do not duplicate features across plugins. Historical violations and their corrections are documented in [ADR-005](docs/adr/ADR-005-eu-ai-act-compliance-toolkit.md) and [ADR-012](docs/adr/ADR-012-eu-ai-act-migration-completion.md) (EU AI Act toolkit migration).

| Plugin                  | Domain                                              | Examples                                                                                                                     |
| ----------------------- | --------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| **`8-habit-ai-dev`**    | Workflow **discipline** — how to develop well       | 7-step workflow, 8 Habits, Whole Person Model, `/research`…`/monitor-setup`, `/cross-verify`, `/reflect`, `/calibrate`       |
| **`claude-governance`** | Compliance **enforcement** + **framework mappings** | PreToolUse hooks, Three Loops Decision Model, OWASP DSGAI, EU AI Act, `/governance-check`, `/spec-driven-dev`, `/create-adr` |

**Rule of thumb**: workflow step or discipline practice → here. Runtime hook, compliance framework mapping, enforcement gate, or formal decision-authorization model → `claude-governance`. When uncertain: `ls ~/claude-governance/skills/ ~/claude-governance/hooks/` and `mem_search "plugin boundary"`. Cross-plugin specs (defined here, implemented there) live alongside their owners — e.g., [`guides/habit-nudges.md`](guides/habit-nudges.md) (v2.6.0 spec, hook implementation in `claude-governance`).

## Skills → Habits Mapping

> For phrase-based lookup ("given these words, which skill?"), see [`skills/RESOLVER.md`](skills/RESOLVER.md). The table below indexes by workflow step.

| Skill                 | Step | Habit                 | Purpose                                                                                                                            |
| --------------------- | ---- | --------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| `/research`           | 0    | H5 Understand First   | Investigate before specifying                                                                                                      |
| `/requirements`       | 1    | H2 Begin with End     | Define done before starting                                                                                                        |
| `/design`             | 2    | H8 Find Your Voice    | Human decides architecture                                                                                                         |
| `/breakdown`          | 3    | H3 First Things First | Atomic tasks, no scope creep                                                                                                       |
| `/build-brief`        | 4    | H5 Understand First   | Read code before writing                                                                                                           |
| `/review-ai`          | 5    | H4 Win-Win            | Actionable feedback                                                                                                                |
| `/deploy-guide`       | 6    | H1 Be Proactive       | Staging first, rollback ready, provider canary reconciliation                                                                      |
| `/monitor-setup`      | 7    | H7 Sharpen the Saw    | Invest in observability                                                                                                            |
| `/cross-verify`       | All  | H1-H8                 | 17-question checklist + dimension summary                                                                                          |
| `/consistency-check`  | —    | H5 + H1               | Spec artifact analyzer + incident/config hotfix consistency-lite (v2.20.1, [ADR-013](docs/adr/ADR-013-spec-persistence-opt-in.md)) |
| `/operational-state`  | —    | H1 + H5 + H8          | Classify operational findings before action: Watch, Fix Candidate, Active Incident, Resolved, Handoff, Known Accepted Issue        |
| `/whole-person-check` | —    | H8 Find Your Voice    | Body/Mind/Heart/Spirit 4-dimension assessment                                                                                      |
| `/security-check`     | —    | H1 Be Proactive       | Focused security review — OWASP Top 10                                                                                             |
| `/using-8-habits`     | —    | H5 + H8               | Onboarding meta-skill + decision tree (v2.4.0)                                                                                     |
| `/eu-ai-act-check`    | —    | H1 + H8 (Spirit)      | Redirect stub — canonical skill migrated to `claude-governance` ([ADR-012](docs/adr/ADR-012-eu-ai-act-migration-completion.md))    |
| `/ai-dev-log`         | —    | H4 Win-Win + H1       | AI-assisted dev log from git history (v2.3.0)                                                                                      |
| `/reflect`            | —    | H7 Sharpen the Saw    | 6-question retrospective + lesson file + Q6 → `SKILL-EFFECTIVENESS.md` ([ADR-018](docs/adr/ADR-018-memory-layer-activation.md))    |
| `/calibrate`          | —    | H8 Find Your Voice    | Self-assessment → `~/.claude/habit-profile.md` ([ADR-008](docs/adr/ADR-008-user-maturity-calibration-design.md))                   |
| `/workflow`           | —    | All                   | Guided 7-step walkthrough                                                                                                          |

## Proposed (awaiting evidence)

Rules below have no traceable lesson, ADR, or memory obs ID yet. Per [ADR-018](docs/adr/ADR-018-memory-layer-activation.md) "Earn each line" discipline and [ADR-016](docs/adr/ADR-016-t2-bag-drop-date-eviction-policy.md) eviction convention: **drop date 2026-11-24**. If no citation accumulates by then, the rule is dropped (soft fail, not silent deletion). If a lesson cites the rule, ratchet back into "Key Conventions" with the citation.

- **Bash tool minimization in skills** — new skills default to `Read/Glob/Grep` only; Bash is added only with justification. Currently used by 9 skills: `ai-dev-log`, `deploy-guide`, `diagnose`, `monitor-setup`, `post-mortem`, `reflect`, `review-ai`, `scrutinize`, `security-check` (each justifies it via git/test/deploy/scan workflows; the `eu-ai-act-check` redirect stub dropped Bash in #353, closing the least-privilege carry from #343). Rationale is least-privilege but no failure mode has been recorded.
- **Reference directories are skill-immutable** — `habits/`, `guides/`, `rules/` are reference content; skills must never generate or modify them. No incident has been recorded of a skill attempting this; rule stands on convention alone.
