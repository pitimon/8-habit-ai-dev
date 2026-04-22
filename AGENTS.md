# Agents working on 8-habit-ai-dev

This is your install + operating protocol. Claude Code reads `./CLAUDE.md` automatically. Everyone else (Codex, Cursor, Windsurf, Aider, Continue, or any LLM fetching this repo via URL) starts here.

## What this is

A Claude Code plugin that adds **workflow discipline** to AI-assisted development — 17 on-demand markdown skills across a 7-step workflow grounded in Covey's 8 Habits. The plugin is markdown only: no build system, no runtime code, no dependencies. Skills are **read-only guidance** — they tell an agent _how_ to approach a task; they never edit files on their own.

## Install

- **Claude Code**: `claude plugin marketplace add pitimon/8-habit-ai-dev && claude plugin install 8-habit-ai-dev@pitimon-8-habit-ai-dev`
- **Other agent platforms**: `git clone https://github.com/pitimon/8-habit-ai-dev` then load `skills/<name>/SKILL.md` via your platform's skill-loading mechanism (Codex `skill` tool, Cursor Rules, Windsurf memories, Aider `--read`, etc.). The skill _content_ is identical across platforms — only the invocation differs. Consult your tool's documentation for the exact command.

## Read this order

1. **`./AGENTS.md`** (this file) — install + operating protocol.
2. [`./CLAUDE.md`](./CLAUDE.md) — architecture reference, skill authoring conventions, plugin boundary with `claude-governance`.
3. [`./skills/RESOLVER.md`](./skills/RESOLVER.md) — phrase-to-path skill dispatcher. Read first for any task; pick the row matching user intent, then read the cited `SKILL.md`.
4. If new to the workflow: invoke `/workflow` for a guided 7-step walkthrough, or `/using-8-habits` for the decision tree.

## Trust boundary

Skills are **read-only guidance**. A skill tells you _how_ to approach a task (what questions to ask, what checklist to run, what artifact to produce). It does not modify files by itself — any edits are made by the agent loading the skill, under the user's approval. This matches the plugin's core philosophy: **discipline, not enforcement**. Compliance enforcement (gates, hooks, irreversible-action auth) lives in the sibling plugin [`pitimon/claude-governance`](https://github.com/pitimon/claude-governance) — install both for full coverage.

## Common tasks

- **"I want to research a library before choosing it"** → [`skills/research/SKILL.md`](./skills/research/SKILL.md) (Step 0 of the 7-step workflow)
- **"I need to plan what this feature does"** → [`skills/requirements/SKILL.md`](./skills/requirements/SKILL.md) (PRD + EARS criteria)
- **"I just got some AI-generated code, audit it before I commit"** → [`skills/review-ai/SKILL.md`](./skills/review-ai/SKILL.md)
- **"Something feels off in my plan, run a checklist"** → [`skills/cross-verify/SKILL.md`](./skills/cross-verify/SKILL.md) (17-question 8-habit review)
- **"I just finished a task, what did we learn?"** → [`skills/reflect/SKILL.md`](./skills/reflect/SKILL.md) (6-question micro-retrospective)

For the full phrase-to-path index, see [`./skills/RESOLVER.md`](./skills/RESOLVER.md).

## Full map

[`./llms.txt`](./llms.txt) is the flat documentation map used by LLM-based agents to fetch and index the plugin remotely. It lists every entry point, philosophy doc, and compliance reference with absolute URLs.
