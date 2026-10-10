# 8-Habit AI Dev

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Validation](https://github.com/pitimon/8-habit-ai-dev/actions/workflows/validate.yml/badge.svg)](https://github.com/pitimon/8-habit-ai-dev/actions/workflows/validate.yml)
[![Skills](https://img.shields.io/badge/Skills-24-blue)](docs/skills-reference.md)
[![Version](https://img.shields.io/badge/Version-2.21.62-brightgreen)](https://github.com/pitimon/8-habit-ai-dev/releases/tag/v2.21.62)

A development playbook for AI coding agents: define the task before coding, prepare repository context, and review evidence before shipping. The package contains 24 Markdown skills based on Stephen Covey's 8 Habits.

**Start by choosing your client below.** Each guide covers installation, verification, a first task, daily use, updates and troubleshooting without interleaving other clients' commands.

[Choose a client](#quick-start) · [Workflow](#the-7-step-workflow) · [Team adoption](docs/team-adoption.md) · [What's New](#whats-new-in-v22162)

## What you get

For a feature such as adding a status filter to an endpoint:

| Before | With the playbook | Output to review |
| --- | --- | --- |
| “Add the filter” with unspecified behavior | Agree on allowed values, defaults and failure cases | Acceptance criteria |
| Code without inspecting existing callers | Read the endpoint and its tests before implementation | Implementation brief |
| “It works” without evidence | Review the diff and actual test results before commit | Findings and verification gaps |

These are intended outputs, not automatic guarantees. The agent performs the work; your team verifies evidence and approves changes.

## Quick Start

Choose one route and stay in that guide through your first reviewed task:

| Your client | Start here | Installation model |
| --- | --- | --- |
| **Claude Code** | [Install and use with Claude Code](docs/claude-code-integration.md) | Plugin with Claude-specific hooks and reviewer definitions |
| **Codex** | [Install and use with Codex](docs/codex-integration.md) | Native plugin with Codex skill selection and mentions |
| **Hermes Agent** | [Install and use with Hermes](docs/hermes-integration.md) | Skills Hub tap; install selected skills individually |
| **OpenClaw** | [Install and use with OpenClaw](docs/openclaw-integration.md) | Compatible skill bundle; real-install verification remains open in [#413](https://github.com/pitimon/8-habit-ai-dev/issues/413) |
| **Another agent** | [Manual loading](docs/manual-integration.md) | Read selected Markdown guidance; no native integration promise |

Comparing clients rather than installing one? Use the [runtime compatibility matrix](docs/compatibility-matrix.md). It is reference material, not a prerequisite for the first task.

## The 7-Step Workflow

Seven delivery steps follow research at Step 0. Choose the steps relevant to the task; implementation remains the coding agent's work.

```text
Research → Requirements → Design → Tasks → Implementation brief
                     ↓
          Implement with your coding agent
                     ↓
              Review → Deploy → Monitor
```

For a bounded change, begin with `requirements`, prepare context with `build-brief`, and use `review-ai` before committing. For more uncertainty or risk, add research, architecture review, release checks or reflection.

Read the [workflow overview](https://github.com/pitimon/8-habit-ai-dev/wiki/Workflow-Overview) for the full process. Your client guide supplies invocation syntax.

## Skills Reference

The [shared skill catalog](docs/skills-reference.md) lists all 24 entries with their purpose and intended output. Names there are identifiers, not commands for every client.

Use the onboarding skill `using-8-habits` to choose the next step. Follow your client guide when invoking it. The [resolver](skills/RESOLVER.md) maps intent to a skill; the [generated JSON catalog](docs/data/skills.json) provides discovery metadata.

## For teams

Start with a non-production pilot, assign an owner, and evaluate whether requirements, review and handoffs become clearer. Keep existing CI, security scanning, access control, staging and production approvals in place.

The [team adoption guide](docs/team-adoption.md) covers responsibilities, data/provider review, rollout and support. Individual developers can start in their client guide without reading organizational rollout material first.

## Keeping the plugin updated

Update instructions belong to the selected client guide. Review [release notes](https://github.com/pitimon/8-habit-ai-dev/releases), record the installed version and verify a representative task after updating. Marketplace snapshots are not automatically pinned deployments.

## What's New in v2.21.62

Release v2.21.62 refreshed the team-adoption overview and clarified service boundaries without changing skill behavior. See [CHANGELOG.md](CHANGELOG.md) and [GitHub Releases](https://github.com/pitimon/8-habit-ai-dev/releases) for the release record.

## Scope, security and support

This is an MIT-licensed guidance package, not a hosted or managed service. It does not establish a contractual SLA, compliance certification, data-residency guarantee or production authorization. EU AI Act mappings live in the separate [claude-governance](https://github.com/pitimon/claude-governance) project; this package's related entry is a redirect.

Your runtime and model provider determine tool execution and data handling. Keep credentials and sensitive customer information out of shared artifacts. Read the [security policy](SECURITY.md) and [threat model](docs/security/threat-model.md).

Use [GitHub Issues](https://github.com/pitimon/8-habit-ai-dev/issues) for reproducible problems with versions and sanitized steps. Report vulnerabilities privately through SECURITY.md, not a public issue. Public support has no contractual response-time commitment.

## Documentation and contributions

- [Client guides](#quick-start): install and complete a first task in your runtime
- [Skill catalog](docs/skills-reference.md): purpose and selection of all entries
- [Wiki](https://github.com/pitimon/8-habit-ai-dev/wiki): workflow, habits, examples and reference material
- [CONTRIBUTING.md](CONTRIBUTING.md): authoring, validation and release conventions
- [AGENTS.md](AGENTS.md): instructions for agents working on this repository

The consumer package needs a compatible agent runtime, not an application build. Repository contributors use Bash, Git and Node.js; the CI-parity entry point is `bash tests/ci-local.sh`.

## License

[MIT](LICENSE)

_Version: 2.21.62 | Last updated: 2026-10-09_
