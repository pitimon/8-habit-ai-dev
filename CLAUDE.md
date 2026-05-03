# CLAUDE.md

> **Non-Claude agents** (Codex, Cursor, Windsurf, Aider, Continue): start at [`AGENTS.md`](AGENTS.md). [`llms.txt`](llms.txt) is the full doc map. Claude Code users: this file is auto-loaded — keep reading.

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A **Claude Code plugin** (not a runnable application). No build system, no dependencies — the entire plugin is structured markdown files that Claude Code loads at runtime. Structural validation via `tests/validate-structure.sh` (pure bash, no test framework). The plugin provides a 7-step workflow discipline based on Covey's 8 Habits, designed to replace "vibe coding" with structured AI-assisted development.

**Install**: `claude plugin marketplace add pitimon/8-habit-ai-dev && claude plugin install 8-habit-ai-dev@pitimon-8-habit-ai-dev`

## Architecture

The plugin has three loading mechanisms with distinct timing:

1. **`rules/effective-development.md`** — Auto-loaded into every Claude Code session (via Claude's rules system). Contains the full 8-Habit playbook with Rules, Anti-patterns, and Checkpoints per habit.
2. **`hooks/session-start.sh`** — Runs at SessionStart (registered in `hooks/hooks.json`). Prints a ≤300-token reminder of the 7-step workflow. Must stay concise — this is injected into every conversation.
3. **`skills/*/SKILL.md`** — Loaded on-demand when user invokes `/requirements`, `/design`, `/breakdown`, `/build-brief`, `/review-ai`, `/deploy-guide`, `/monitor-setup`, `/cross-verify`, `/consistency-check`, or `/calibrate`.

**On-demand loading**: Skills reference habit content via `Load ${CLAUDE_PLUGIN_ROOT}/habits/h*.md` — the habit files are NOT loaded at session start. This keeps the token budget lean.

## Skill Authoring Conventions

Each skill file (`skills/<name>/SKILL.md`) follows this structure:

```yaml
---
name: <skill-name> # Must match directory name
description: > # Multi-line, explains when to use
user-invocable: true # Always true for workflow skills
argument-hint: "[description]" # Shown in skill list
allowed-tools: ["Read", "Glob", "Grep"] # Bash only when needed (e.g., review-ai)
prev-skill: <skill-name|none|any> # Predecessor in 7-step chain
next-skill: <skill-name|none|any> # Successor in 7-step chain
---
```

Body pattern: Habit mapping → Process steps → Handoff → When to Skip → Definition of Done → H\* Checkpoint → Load directive.

**Handoff protocol**: Each skill declares what it expects from its predecessor and what it produces for its successor. Standalone skills (cross-verify, whole-person-check) use `any` for both.

## Key Conventions

- **Skills are read-only guidance** — they tell Claude how to approach a task, they do not modify files themselves
- **Bash tool is allowed in skills only when needed** — currently used by `review-ai`, `eu-ai-act-check`, `ai-dev-log`. New skills should default to `Read/Glob/Grep` only and add `Bash` only with justification
- **`habits/`, `guides/`, `rules/` are reference content** — never generated or modified by skills
- **Agent (`agents/8-habit-reviewer.md`)** uses model `sonnet` with read-only tools (`Read`, `Glob`, `Grep`) — it analyzes and reports, never edits
- **Plugin metadata** lives in `.claude-plugin/plugin.json` (plugin config) and `.claude-plugin/marketplace.json` (marketplace listing)
- **Lesson persistence** (v2.6.0): `/reflect` saves lesson files to `~/.claude/lessons/YYYY-MM-DD-<slug>.md`. `/research` and `/build-brief` search these before starting work. This closes the learning loop: reflect → persist → retrieve → apply
- **Verbosity adaptation** (v2.7.0): `hooks/session-start.sh` reads `~/.claude/habit-profile.md` and emits a level-specific adaptation directive into session context. Zero per-skill changes — the directive shapes Claude's behavior at runtime for all subsequent skill invocations. Canonical rules in `guides/verbosity-adaptation.md`. 8-branch regression coverage in `tests/test-verbosity-hook.sh`. Respects existing `HABIT_QUIET=1` opt-out from ADR-006. Closes #96 (the reader half of the #90 calibrate loop)
- **Session hook budget**: `hooks/session-start.sh` output must stay ≤300 tokens
- **Version lives in 4 files** — must bump together: `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`, `README.md` (badge + footer), and `SELF-CHECK.md` header. `tests/validate-structure.sh` enforces consistency across all four — CI will fail if any drifts.

## Plugin Boundary

`8-habit-ai-dev` and [`pitimon/claude-governance`](https://github.com/pitimon/claude-governance) are **complementary by design** (see memory obs #233270, 2026-04-07, titled "Both Recommended for Maximum Coverage"). Do not duplicate features across plugins.

| Plugin                      | Domain                                                                                     | Examples                                                                                                                                                                                                                                                                                        |
| --------------------------- | ------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **`8-habit-ai-dev`** (this) | Workflow **discipline** — how to develop well                                              | 7-step workflow, 8 Habits, Whole Person Model, `/research`, `/requirements`, `/design`, `/breakdown`, `/build-brief`, `/review-ai`, `/deploy-guide`, `/monitor-setup`, `/cross-verify`, `/reflect`, `/calibrate` (user maturity), `/ai-dev-log` (transparency), `/security-check` (review lens) |
| **`claude-governance`**     | Compliance **enforcement** + **frameworks** — blocking bad behavior + mapping to standards | PreToolUse secret-scanner hook (25 patterns), Three Loops Decision Model (ADR-002 consequence-based auth), OWASP DSGAI mapping (11 controls), EU AI Act compliance toolkit (planned v3.1.0+), `/governance-check`, `/spec-driven-dev`, `/create-adr`, `governance-reviewer` agent               |

**Rule of thumb before adding a new feature here**:

- If it's a **workflow step** or **discipline practice** → belongs here
- If it's a **runtime hook** (PreToolUse, PostToolUse), **compliance framework mapping** (DSGAI, EU AI Act, SOC2, NIST, etc.), **enforcement gate** that blocks actions, or **formal decision-authorization model** → belongs in `claude-governance`
- When uncertain, check both plugins' existing files first (`ls ~/claude-governance/skills/ ~/claude-governance/hooks/`) and search memory (`mem_search "plugin boundary"`)

**Historical boundary violations (corrected)**: Issues #58 (PreToolUse secret blocker) and #60 (OWASP DSGAI mapping) were originally scoped here despite being enforcement/compliance concerns — closed as wrong-plugin on 2026-04-09. Issue #57 (EU AI Act toolkit) shipped here in v2.3.0 via PRs #65-70, then was identified as a boundary error; Path C hybrid migration will move it to `claude-governance` (tracked in pitimon/claude-governance#21) in a future v2.3.1 release. See ADR-005 (and the future ADR-006 once Stage B ships) for full rationale.

**Users who want maximum coverage**: install both plugins together. They compose cleanly — no conflicts.

**Cross-plugin specs** (defined here, implemented in `claude-governance`):

- [`guides/habit-nudges.md`](guides/habit-nudges.md) (v2.6.0) — specification for proactive workflow nudges; hook implementation belongs in `claude-governance`. Catalog of 6 nudges with triggers, cooldowns, and opt-out via `HABIT_QUIET=1`.

## Skills → Habits Mapping

> For phrase-based lookup ("given these words, which skill?"), see [`skills/RESOLVER.md`](skills/RESOLVER.md). The table below indexes by workflow step; RESOLVER indexes by user intent.

| Skill                 | Step | Habit                 | Purpose                                                                                                                                                 |
| --------------------- | ---- | --------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `/research`           | 0    | H5 Understand First   | Investigate before specifying                                                                                                                           |
| `/requirements`       | 1    | H2 Begin with End     | Define done before starting                                                                                                                             |
| `/design`             | 2    | H8 Find Your Voice    | Human decides architecture                                                                                                                              |
| `/breakdown`          | 3    | H3 First Things First | Atomic tasks, no scope creep                                                                                                                            |
| `/build-brief`        | 4    | H5 Understand First   | Read code before writing                                                                                                                                |
| `/review-ai`          | 5    | H4 Win-Win            | Actionable feedback                                                                                                                                     |
| `/deploy-guide`       | 6    | H1 Be Proactive       | Staging first, rollback ready                                                                                                                           |
| `/monitor-setup`      | 7    | H7 Sharpen the Saw    | Invest in observability                                                                                                                                 |
| `/cross-verify`       | All  | H1-H8                 | 17-question checklist + dimension summary                                                                                                               |
| `/consistency-check`  | —    | H5 + H1               | Cross-artifact analyzer — 5 detection passes (Coverage, Drift, Ambiguity, Underspec, Inconsistency) over persisted PRD↔design↔tasks (v2.15.0, ADR-013)  |
| `/whole-person-check` | —    | H8 Find Your Voice    | Body/Mind/Heart/Spirit 4-dimension assessment                                                                                                           |
| `/security-check`     | —    | H1 Be Proactive       | Focused security review — OWASP Top 10                                                                                                                  |
| `/using-8-habits`     | —    | H5 + H8               | Onboarding meta-skill + decision tree (v2.4.0)                                                                                                          |
| `/eu-ai-act-check`    | —    | H1 + H8 (Spirit)      | EU AI Act 9-obligation tiered checklist (v2.3.0, migrating to claude-governance)                                                                        |
| `/ai-dev-log`         | —    | H4 Win-Win + H1       | AI-assisted dev log from git history (v2.3.0)                                                                                                           |
| `/reflect`            | —    | H7 Sharpen the Saw    | 6-question post-task retrospective + persistent lesson file (`~/.claude/lessons/`) + skill-effectiveness signal (v2.6.1, Q6 → `SKILL-EFFECTIVENESS.md`) |
| `/calibrate`          | —    | H8 Find Your Voice    | Self-assessment → `~/.claude/habit-profile.md` so other skills adapt verbosity to maturity level (v2.6.0)                                               |
| `/workflow`           | —    | All                   | Guided 7-step walkthrough                                                                                                                               |
