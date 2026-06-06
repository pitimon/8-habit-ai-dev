![Version](https://img.shields.io/badge/version-2.20.2-blue) ![Skills](https://img.shields.io/badge/skills-24-green) ![License](https://img.shields.io/badge/license-MIT-brightgreen) ![Dependencies](https://img.shields.io/badge/dependencies-0-orange)

# 8-Habit AI Dev

`8-habit-ai-dev` is a Claude Code and Codex plugin that adds workflow discipline to AI-assisted development. It ships portable markdown skills, a 7-step development workflow, and review habits grounded in Covey's 8 Habits.

> [!IMPORTANT]
> This plugin provides guidance, prompts, review structure, and documentation. It does not add runtime enforcement, policy authorization, compliance certification, cloud automation, or production mutation.

## Start Here

| Goal | Page |
| --- | --- |
| Install the plugin | [Installation](Installation) |
| Try the workflow once | [Getting Started](Getting-Started) |
| Choose the right skill | [Skills Reference](Skills-Reference) |
| Understand the full process | [Workflow Overview](Workflow-Overview) |
| Recover from common issues | [Troubleshooting](Troubleshooting) |

## What You Get

| Area | Included |
| --- | --- |
| Workflow | Steps 0-7 from research through monitoring |
| Skills | 24 markdown skills for planning, review, operations, audit, and reflection |
| Runtime support | Claude Code package and native Codex package |
| Validation | Bash validators for skill structure, content, graph integrity, and hook budget |
| Documentation | Wiki pages generated from `docs/wiki/` through PR review |

## Core Workflow

```text
/research -> /requirements -> /design -> /breakdown
    -> /build-brief -> /review-ai -> /deploy-guide -> /monitor-setup
```

Most users should begin with two habits:

- Run `/requirements` before building non-trivial work.
- Run `/review-ai` before committing AI-generated work.

Use the full workflow for larger features, unclear domains, architecture changes, production deploys, or operational fixes.

## Current Release Focus

Version `v2.20.2` keeps the plugin's markdown-only boundary while improving operational guidance:

- `/operational-state` classifies operational findings before action.
- `/consistency-check` includes incident/config hotfix drift checks.
- `/deploy-guide` includes reconciliation gates for provider-managed canaries and capacity changes.

## Compatibility Boundary

Claude Code and Codex both consume the same markdown skills. Claude Code also has Claude-specific hooks and session reminders. Codex uses `AGENTS.md`, the Codex plugin manifest, and the same `skills/` directory; it does not run Claude hooks.

For details, see [Architecture](Architecture), [Installation](Installation), and the repository compatibility docs.

## Reference

- [Workflow Overview](Workflow-Overview)
- [Skills Reference](Skills-Reference)
- [Habits Reference](Habits-Reference) - includes the Covey origin and engineering adaptation
- [Maturity Model](Maturity-Model)
- [Architecture](Architecture)
- [Changelog](Changelog)
