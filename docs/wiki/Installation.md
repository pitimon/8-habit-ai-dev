# Installation

Two commands, zero dependencies. The plugin is pure markdown — no `npm install`, no build step.

## Prerequisites

- [Claude Code](https://claude.com/claude-code) installed and authenticated
- Git (for plugin marketplace cloning)

## Install

```bash
claude plugin marketplace add pitimon/8-habit-ai-dev
claude plugin install 8-habit-ai-dev@pitimon-8-habit-ai-dev
```

That's it. Restart Claude Code (or start a new session) to load the plugin.

## Verify

Inside Claude Code, you should see the session-start banner:

```
## 8-Habit AI Dev Active
7-Step Workflow (not Vibe Coding):
0. /research — Investigate before specifying (H5)
...
```

List available skills:

```
/workflow
```

If the banner does not appear, see [Troubleshooting](Troubleshooting).

## Update

```bash
claude plugin update 8-habit-ai-dev@pitimon-8-habit-ai-dev
```

## Uninstall

```bash
claude plugin uninstall 8-habit-ai-dev@pitimon-8-habit-ai-dev
```

## What gets installed

- **Skills** (loaded on demand): `/research`, `/requirements`, `/design`, `/breakdown`, `/build-brief`, `/review-ai`, `/deploy-guide`, `/monitor-setup`, `/cross-verify`, `/whole-person-check`, `/security-check`, `/reflect`, `/workflow`
- **Rules** (auto-loaded every session): `rules/effective-development.md` — the full 8-Habit playbook
- **Session hook**: ≤300-token reminder of the 7-step workflow
- **Agent**: `8-habit-reviewer` — read-only cross-verification agent

Next: **[Getting Started](Getting-Started)**.
