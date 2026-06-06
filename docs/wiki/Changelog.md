![Latest](https://img.shields.io/badge/latest-v2.21.0-blue)

# Changelog

This page summarizes recent wiki-relevant releases. The authoritative release history remains the repository [`CHANGELOG.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/CHANGELOG.md), GitHub Releases, and git tags.

> [!NOTE]
> Wiki summaries intentionally focus on user-facing documentation changes and workflow boundaries. Use the repository changelog for exact release notes.

## v2.21.0 · Cross-Agent Discovery and Portability Contract

Adds a generated skill catalog and documents the shared `SKILL.md` frontmatter contract for Claude Code, Codex, and other markdown-capable agents.

Visible documentation points:

- `docs/data/skills.json` is generated from `skills/*/SKILL.md` for cross-agent discovery.
- `CONTRIBUTING.md`, `guides/skill-authoring.md`, and `docs/compatibility-matrix.md` document required, optional, cross-agent, and Codex-ingestible frontmatter fields.
- `docs/codex-integration.md` and `llms.txt` point tools to the generated catalog.
- `guides/structured-output-protocol.md` adds a compact handoff-integrity note pattern.
- `/review-ai`, `/reflect`, and `guides/quick-reference.md` add observable AI-work health signals such as loops, retries, context compaction, audit evidence, and next-session recovery.

Boundary: generated metadata and markdown guidance only. No runtime dispatcher, no Claude hook port to Codex, no budget enforcement, no policy gate, and no agent-to-agent orchestration protocol.

## v2.20.2 · Production Canary Reconciliation Gates

`/deploy-guide` now covers provider-managed production canaries and capacity changes where the requested canary target and the provider-selected target may differ.

Visible documentation points:

- Precheck, cordon, observation, drain, provider-side change, reconciliation, and postcheck phases.
- Planned target vs actual provider-selected target comparison.
- Desired/min/max capacity, readiness, schedulable capacity, and unintended `SchedulingDisabled` checks.
- Unresolved rollout state routes to `/operational-state`.

Boundary: no cloud execution, policy enforcement, Kubernetes automation, ASG automation, or runtime state engine.

## v2.20.1 · Incident/Config Consistency-Lite

`/consistency-check` now includes a lightweight mode for incident and config hotfix work that does not have persisted spec artifacts.

Visible documentation points:

- Checks symptom, evidence, root cause, actual fix, deploy path, live verification, and drift.
- Flags overclaiming PR/changelog text, missing evidence, scope mismatch, deploy drift, and unclassified adjacent operational state.
- Routes unresolved related findings to `/operational-state`.

Boundary: no runtime enforcement, cloud execution, alert mutation, or automatic issue closure.

## v2.20.0 · Operational State Model

Adds `/operational-state`, a read-only classifier for operational findings.

States:

- Watch
- Fix Candidate
- Active Incident
- Resolved
- Handoff
- Known Accepted Issue
- False Positive
- Self-Resolved

The skill maps each state to evidence, allowed and prohibited actions, approval gates, artifacts, escalation criteria, and closure criteria.

Boundary: no runtime state engine, policy enforcement, cloud execution, alert suppression automation, or automatic production write.

## v2.19.2 · Operational Doctrine Patch

Ships doctrine-only improvements to existing skills:

- `/deploy-guide` classifies deploy type before rollout planning.
- `/security-check` covers more infrastructure and configuration surfaces.
- `/reflect` captures more granular skill-effectiveness feedback.
- `/management-talk` includes an operational incident closure example.

Broader operational model work was intentionally deferred until later releases.

## v2.19.1 · Codex Runtime Compatibility Contract

Clarifies that Codex can install the plugin and load the same markdown skills, but does not run Claude hooks or gain runtime enforcement.

Related docs:

- [`docs/compatibility-matrix.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/compatibility-matrix.md)
- [`docs/codex-integration.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/codex-integration.md)

## v2.19.0 · Native Codex Plugin Packaging

Adds Codex packaging through `.codex-plugin/plugin.json` and `.agents/plugins/marketplace.json` while preserving the Claude Code package.

Install path:

```bash
codex plugin marketplace add pitimon/8-habit-ai-dev
codex plugin add 8-habit-ai-dev@pitimon-8-habit-ai-dev
```

Boundary: same read-only markdown skills, no Claude hook parity, and no runtime enforcement.

## Earlier Releases

For earlier versions, use:

- [Repository changelog](https://github.com/pitimon/8-habit-ai-dev/blob/main/CHANGELOG.md)
- [GitHub releases](https://github.com/pitimon/8-habit-ai-dev/releases)
- [Git tags](https://github.com/pitimon/8-habit-ai-dev/tags)

## See Also

- [Home](Home)
- [Skills Reference](Skills-Reference)
- [Architecture](Architecture)
