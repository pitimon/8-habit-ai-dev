# 8-Habit AI Dev

**Anti-Vibe-Coding plugin for Claude Code.** A 7-step workflow discipline and 8-Habit cross-verification framework that replaces ad-hoc AI prompting with structured, reviewable, governable development.

> _"ทำเสร็จ ≠ ทำดี"_ — _Done_ is not _Done well_.

## Why this exists

AI-assisted coding is fast but often undisciplined: missing requirements, skipped reviews, no rollback plans, accumulating tech debt. This plugin enforces the habits that separate effective developers from vibe coders — based on Stephen Covey's _7 Habits_ + _The 8th Habit_, adapted for the AI era.

## Start here

1. **[Installation](Installation)** — one command, zero dependencies
2. **[Getting Started](Getting-Started)** — your first structured feature in 10 minutes
3. **[Workflow Overview](Workflow-Overview)** — the 7 steps at a glance

## The 7-Step Workflow

| Step | Command                                  | Habit | Purpose                            |
| ---- | ---------------------------------------- | ----- | ---------------------------------- |
| 0    | [`/research`](Step-0-Research)           | H5    | Investigate before specifying      |
| 1    | [`/requirements`](Step-1-Requirements)   | H2    | Define what, why, who              |
| 2    | [`/design`](Step-2-Design)               | H8    | Architecture decisions (human-led) |
| 3    | [`/breakdown`](Step-3-Breakdown)         | H3    | Atomic tasks, no scope creep       |
| 4    | [`/build-brief`](Step-4-Build-Brief)     | H5    | Context before coding              |
| 5    | [`/review-ai`](Step-5-Review-AI)         | H4    | Audit before commit                |
| 6    | [`/deploy-guide`](Step-6-Deploy-Guide)   | H1    | Staging first, rollback ready      |
| 7    | [`/monitor-setup`](Step-7-Monitor-Setup) | H7    | Observe after deploy               |

Plus standalone skills: `/cross-verify`, `/whole-person-check`, `/security-check`, `/reflect`, `/workflow`.

## Reference

- **[8 Habits](Habits-Reference)** — the full playbook
- **[Skills Catalog](Skills-Reference)** — all 13 skills, when to use each
- **[Vibe Coding vs Structured](Vibe-Coding-vs-Structured)** — side-by-side comparison
- **[FAQ](FAQ)** · **[Troubleshooting](Troubleshooting)**

## Principles

- **Read-only guidance**: Skills tell Claude _how_ to approach a task, never edit files themselves
- **Human-in-the-loop** for architecture and irreversible decisions
- **Zero dependencies**: pure markdown + bash validation
- **PR-first**: every change goes through review, even documentation

## Contributing

See [Contributing to Wiki](Contributing-to-Wiki). The wiki is a build artifact — edit `docs/wiki/<page>.md` and open a PR.
