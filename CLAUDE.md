# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A **Claude Code plugin** (not a runnable application). No build system, no dependencies — the entire plugin is structured markdown files that Claude Code loads at runtime. Structural validation via `tests/validate-structure.sh` (pure bash, no test framework). The plugin provides a 7-step workflow discipline based on Covey's 8 Habits, designed to replace "vibe coding" with structured AI-assisted development.

**Install**: `claude plugin marketplace add pitimon/8-habit-ai-dev && claude plugin install 8-habit-ai-dev@pitimon-8-habit-ai-dev`

## Architecture

The plugin has three loading mechanisms with distinct timing:

1. **`rules/effective-development.md`** — Auto-loaded into every Claude Code session (via Claude's rules system). Contains the full 8-Habit playbook with Rules, Anti-patterns, and Checkpoints per habit.
2. **`hooks/session-start.sh`** — Runs at SessionStart (registered in `hooks/hooks.json`). Prints a ≤300-token reminder of the 7-step workflow. Must stay concise — this is injected into every conversation.
3. **`skills/*/SKILL.md`** — Loaded on-demand when user invokes `/requirements`, `/design`, `/breakdown`, `/build-brief`, `/review-ai`, `/deploy-guide`, `/monitor-setup`, or `/cross-verify`.

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
- **`habits/`, `guides/`, `rules/` are reference content** — never generated or modified by skills
- **Agent (`agents/8-habit-reviewer.md`)** uses model `sonnet` with read-only tools (`Read`, `Glob`, `Grep`) — it analyzes and reports, never edits
- **Plugin metadata** lives in `.claude-plugin/plugin.json` (plugin config) and `.claude-plugin/marketplace.json` (marketplace listing)
- **Session hook budget**: `hooks/session-start.sh` output must stay ≤300 tokens
- **Version lives in 3 files** — must bump together: `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`, `README.md` footer

## Skills → Habits Mapping

| Skill                 | Step | Habit                 | Purpose                                       |
| --------------------- | ---- | --------------------- | --------------------------------------------- |
| `/research`           | 0    | H5 Understand First   | Investigate before specifying                 |
| `/requirements`       | 1    | H2 Begin with End     | Define done before starting                   |
| `/design`             | 2    | H8 Find Your Voice    | Human decides architecture                    |
| `/breakdown`          | 3    | H3 First Things First | Atomic tasks, no scope creep                  |
| `/build-brief`        | 4    | H5 Understand First   | Read code before writing                      |
| `/review-ai`          | 5    | H4 Win-Win            | Actionable feedback                           |
| `/deploy-guide`       | 6    | H1 Be Proactive       | Staging first, rollback ready                 |
| `/monitor-setup`      | 7    | H7 Sharpen the Saw    | Invest in observability                       |
| `/cross-verify`       | All  | H1-H8                 | 17-question checklist + dimension summary     |
| `/whole-person-check` | —    | H8 Find Your Voice    | Body/Mind/Heart/Spirit 4-dimension assessment |
| `/security-check`     | —    | H1 Be Proactive       | Focused security review — OWASP Top 10        |
