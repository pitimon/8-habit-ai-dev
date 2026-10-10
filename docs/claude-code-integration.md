# Use 8-Habit AI Dev with Claude Code

This guide takes you from installation to your first reviewed change in Claude Code. You need Claude Code installed and configured, and a project where you can run its existing tests. Start with a non-production task.

[Install](#install) · [Verify](#verify) · [First task](#first-task) · [Daily use](#daily-use) · [Update](#update) · [Troubleshooting](#troubleshooting)

## Install

Add the marketplace and install the package:

```bash
claude plugin marketplace add pitimon/8-habit-ai-dev
claude plugin install 8-habit-ai-dev@pitimon-8-habit-ai-dev
```

Start a new Claude Code session in your project after installation.

## Verify

Check that the plugin appears in the installed listing:

```bash
claude plugin list
```

Look for `8-habit-ai-dev@pitimon-8-habit-ai-dev`. The session reminder should contain `8-Habit AI Dev Active`, unless you intentionally set `HABIT_QUIET=1`. A missing reminder alone does not prove installation failed: also check the listing and skill availability.

Use slash-command completion to find the installed skill. Examples below use the namespaced plugin form to avoid ambiguity with other installed skills.

## First task

Use a feature such as adding a status filter to an existing list endpoint. Substitute a real feature from your project; this is an illustrative exercise, not an executed product demo.

**1. Define success before editing.** Ask for requirements, not implementation:

```text
/8-habit-ai-dev:requirements Add a status filter to our list endpoint.
Define allowed values, default behavior and testable acceptance criteria.
Do not edit implementation files yet.
```

Expected output: scope, acceptance criteria, edge cases and a definition of done. Review and approve the scope before continuing.

**2. Prepare the implementation context.** Ask the agent to inspect the real endpoint and tests:

```text
/8-habit-ai-dev:build-brief Prepare a brief for the approved status filter.
Read the handler, callers and tests. Identify what to change and verify.
Do not implement yet.
```

Expected output: an implementation brief grounded in the repository. Then ask the coding agent to implement the approved change and run the project's actual tests. The skill is guidance, not an automatic code-editing engine.

**3. Review before committing.** After implementation and tests:

```text
/8-habit-ai-dev:review-ai Review the status-filter diff and test evidence.
List defects and missing verification. Do not commit or push.
```

Expected output: a PASS/CONCERNS/REWORK/FAIL review with actionable findings. Verify the evidence and resolve blocking findings; a skill verdict does not replace your team's approval or CI.

## Daily use

Choose the skill that fits the task, rather than invoking every skill each time:

| Situation | Invoke | Expected result |
| --- | --- | --- |
| Define a feature | `/8-habit-ai-dev:requirements` | Scope and acceptance criteria |
| Understand implementation context | `/8-habit-ai-dev:build-brief` | Repository-grounded brief |
| Check a diff before commit | `/8-habit-ai-dev:review-ai` | Findings and evidence gaps |
| Assess a release plan | `/8-habit-ai-dev:cross-verify` | Readiness assessment, not deploy authorization |
| Capture a completed-task lesson | `/8-habit-ai-dev:reflect` | Short retrospective and skill-effectiveness signal |
| Find the next step | `/8-habit-ai-dev:using-8-habits` | Skill selection guidance |

See the [shared skill catalog](skills-reference.md) when you need another skill.

## Update

Refresh the marketplace, then update the plugin:

```bash
claude plugin marketplace update pitimon-8-habit-ai-dev
claude plugin update 8-habit-ai-dev@pitimon-8-habit-ai-dev
claude plugin list
```

Restart Claude Code. Check the listed version and repeat a representative task before expanding a team rollout. Marketplace snapshots are not automatically pinned deployments; record the version you verified.

To remove the plugin:

```bash
claude plugin uninstall 8-habit-ai-dev@pitimon-8-habit-ai-dev
```

## Troubleshooting

| Symptom | Check |
| --- | --- |
| Plugin is absent from the listing | Confirm the marketplace identifier and retry the documented installation flow |
| Skill name is missing | Start a new session and inspect command completion for the installed namespaced skill |
| Reminder is absent | Check `HABIT_QUIET`, the installed listing and the runtime's hook settings before concluding the plugin is broken |
| Updated version is not in use | Refresh the marketplace, update the plugin, inspect the listing and restart the session |
| Another plugin has the same skill name | Use `/8-habit-ai-dev:skill-name` rather than assuming the unqualified command selects this package |

For a reproducible issue, report the package version, runtime version and sanitized steps through [GitHub Issues](https://github.com/pitimon/8-habit-ai-dev/issues). Send vulnerabilities through [SECURITY.md](../SECURITY.md), not a public issue.

## What this integration includes

The Claude Code package includes shared Markdown skills, the session reminder, and read-only reviewer definitions. The optional pre-commit example is not an automatically installed organization-wide control. Skills do not authorize production changes or certify compliance.

Some skills describe Claude-local lesson/profile persistence. Check the owning skill and your project's memory policy before writing artifacts; do not assume every generated report is persisted automatically.

Your agent runtime and model provider determine tool permissions and data handling. Keep credentials and raw customer data out of prompts and shared artifacts. For rollout ownership and security review, use the separate [team adoption guide](team-adoption.md).
