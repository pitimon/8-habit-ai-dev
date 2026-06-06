# Skills Catalog

All **24 skills** shipped through `8-habit-ai-dev` v2.20.1. Skills are **read-only guidance** — they tell Claude how to approach a task, they do not modify files themselves.

> [!TIP]
> Not sure which skill to use? Type `/using-8-habits` for an interactive decision tree, or see the [quick-select matrix](#quick-select-matrix) below.

## 7-Step Workflow Skills

| #   | Skill                                    | Habit | When to use                                              |
| --- | ---------------------------------------- | ----- | -------------------------------------------------------- |
| 0   | [`/research`](Step-0-Research)           | H5    | Problem space is unclear — investigate before specifying |
| 1   | [`/requirements`](Step-1-Requirements)   | H2    | Any new feature or non-trivial change                    |
| 2   | [`/design`](Step-2-Design)               | H8    | Architecture decisions — human decides                   |
| 3   | [`/breakdown`](Step-3-Breakdown)         | H3    | Decompose work into atomic tasks                         |
| 4   | [`/build-brief`](Step-4-Build-Brief)     | H5    | Before coding each task — read existing code first       |
| 5   | [`/review-ai`](Step-5-Review-AI)         | H4    | **Always** before committing AI-generated code           |
| 6   | [`/deploy-guide`](Step-6-Deploy-Guide)   | H1    | Staging-first deploys with rollback plan                 |
| 7   | [`/monitor-setup`](Step-7-Monitor-Setup) | H7    | Observability after deploy                               |

## Assessment Skills

Run at any point in the workflow for deeper analysis.

### `/cross-verify` {#cross-verify}

17-question 8-Habit cross-verification checklist. Run **after** planning and **before** committing to implementation. Produces a dimension summary across all 8 habits with confidence levels.

- **Habit**: H1-H8 (all)
- **When to use**: Before `ExitPlanMode`, before PR creation
- **Source**: [`skills/cross-verify/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/cross-verify/SKILL.md)

### `/whole-person-check` {#whole-person-check}

Assess a feature/component/PR against Covey's 4 dimensions: **Body** (discipline), **Mind** (vision), **Heart** (passion), **Spirit** (conscience). Scores 1-5 per dimension.

- **Habit**: H8 Find Your Voice
- **When to use**: After `/review-ai` when you want a balance check
- **Source**: [`skills/whole-person-check/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/whole-person-check/SKILL.md)

### `/security-check` {#security-check}

Focused security review — secrets, injection, auth, dependencies, OWASP Top 10. A dedicated security lens separate from general code review.

- **Habit**: H1 Be Proactive
- **When to use**: Any change touching user input, auth, data handling, or dependencies
- **Source**: [`skills/security-check/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/security-check/SKILL.md)

### `/scrutinize` {#scrutinize}

Outsider-perspective end-to-end review — questions intent first ("is there a simpler way?"), then traces the actual code path (not just the diff) to verify the change does what it claims. Pairs with `/review-ai` (scope-question vs diff-local). Operating Rules hardened in v2.18.1 (ADR-017) with MUST/NEVER + Why blocks.

- **Habit**: H5 Understand First + H8 Find Your Voice
- **When to use**: Before committing to an implementation, or before merging a PR alongside `/review-ai`
- **Source**: [`skills/scrutinize/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/scrutinize/SKILL.md)

### `/consistency-check` {#consistency-check}

Cross-artifact consistency analyzer — runs 5 detection passes (Coverage, Drift, Ambiguity, Underspec, Inconsistency) across persisted spec artifacts (PRD ↔ design ↔ tasks). Also includes incident/config hotfix mode for symptom ↔ evidence ↔ root cause ↔ fix ↔ verification drift when no spec bundle exists. Read-only — reports drift, coverage gaps, contradictions. Inspired by github/spec-kit `/analyze`.

- **Habit**: H5 Understand First + H1 Be Proactive
- **When to use**: After `/requirements`, `/design`, `/breakdown` have been run with `--persist <slug>` to catch drift before code, or before closing an incident/config hotfix PR
- **Source**: [`skills/consistency-check/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/consistency-check/SKILL.md)

### `/operational-state` {#operational-state}

Operational finding classifier — chooses Watch, Fix Candidate, Active Incident, Resolved, Handoff, Known Accepted Issue, False Positive, or Self-Resolved before action. Maps evidence, allowed/prohibited actions, approval gates, required artifacts, escalation criteria, and closure criteria.

- **Habit**: H1 Be Proactive + H5 Understand First + H8 Find Your Voice
- **When to use**: Before mutating or closing an operational finding, especially recovered-but-recurring signals, Running-but-unhealthy workloads, source-of-truth drift, accepted known issues, or ownership handoffs
- **Source**: [`skills/operational-state/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/operational-state/SKILL.md)

### `/reflect` {#reflect}

Post-task micro-retrospective — 6 questions, 5 minutes. Captures lessons to `~/.claude/lessons/` for future retrieval by `/research` and `/build-brief`. Includes skill-effectiveness signal (Q6) feeding `SKILL-EFFECTIVENESS.md`.

- **Habit**: H7 Sharpen the Saw
- **When to use**: After completing a task or workflow
- **Source**: [`skills/reflect/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/reflect/SKILL.md)

### `/workflow` {#workflow}

Interactive guided walkthrough of the 7-step workflow. Prompts at each step to invoke or skip.

- **Habit**: All
- **When to use**: Starting a new feature when you're unsure which step comes next
- **Source**: [`skills/workflow/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/workflow/SKILL.md)

## Debug Discipline Skills

Active bug investigation and post-fix engineering record. Ported from prior-art (mattpocock/skills, 9arm-skills) per ADR-014 + ADR-015.

### `/diagnose` {#diagnose}

6-phase active bug investigation methodology — feedback-loop → reproduce → hypothesise → instrument → fix-with-regression-test → cleanup. Closes the gap between `/research` (too broad) and `/post-mortem` (too late). Phase 6 hardened in v2.18.1 (ADR-017) with MUST re-run Phase 1 feedback loop, citing Anthropic pptx.

- **Habit**: H1 Be Proactive + H5 Understand First
- **When to use**: When a bug needs to be fixed and the cause isn't obvious from stack trace; hands off to `/post-mortem` once fix lands
- **Source**: [`skills/diagnose/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/diagnose/SKILL.md)

### `/post-mortem` {#post-mortem}

Engineering RCA writeup — canonical record of a fixed bug (root cause, mechanism, fix, validation, how it slipped through). Refuses to draft without 4 inputs (reliable repro, known cause, identified fix, validated outcome).

- **Habit**: H4 Win-Win + H7 Sharpen the Saw
- **When to use**: AFTER a debug session lands a validated fix, BEFORE closing the ticket
- **Source**: [`skills/post-mortem/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/post-mortem/SKILL.md)

## Spec & Communication Skills

Helpers for project orientation and audience reshape — orthogonal to the 7-step workflow.

### `/save-spec` {#save-spec}

Scaffolds a project-root `SPEC.md` digest following the spec-digest-pattern archetype (project orientation hub). User-invoked. Generator-only Phase 1; refuses to overwrite an existing SPEC.md. Distinct from per-feature `/requirements --persist <slug>` mode.

- **Habit**: H2 Begin with End in Mind + H5 Understand First
- **When to use**: When starting on an unfamiliar repo or after a `/clear` flushing pain — gives Claude a 4-section orientation hub
- **Source**: [`skills/save-spec/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/save-spec/SKILL.md)

### `/management-talk` {#management-talk}

Channel-aware audience reshape — converts engineer-to-engineer content into leadership-channel-shaped form (JIRA / Slack / standup / email / meeting). Strips function/file/SHA noise but keeps JIRA keys, PR numbers, workload names. Inspired by 9arm-skills (v2.17.0).

- **Habit**: H4 Win-Win + H6 Synergize
- **When to use**: When VPs, directors, PMs, or release managers need a status — and your raw engineering notes are too dense
- **Source**: [`skills/management-talk/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/management-talk/SKILL.md)

## Meta & Onboarding Skills

Learn the plugin and adapt it to your style.

### `/using-8-habits` {#using-8-habits}

Onboarding meta-skill — explains the 8 habits, all 24 skills, and provides a decision tree for "which skill next?". Includes a complete walkthrough example (password-reset feature).

- **Habit**: H5 Understand First + H8 Find Your Voice
- **When to use**: First time using the plugin, or when unsure which skill applies
- **Source**: [`skills/using-8-habits/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/using-8-habits/SKILL.md)

### `/calibrate` {#calibrate}

Self-assessment skill that determines your maturity level (Dependence → Independence → Interdependence → Significance) and writes a profile to `~/.claude/habit-profile.md`. Other skills read this profile to adapt verbosity — full guidance for beginners, minimal prompts for experts.

- **Habit**: H8 Find Your Voice
- **When to use**: When plugin guidance feels too detailed or too sparse
- **Deep dive**: [Maturity Model](Maturity-Model)
- **Source**: [`skills/calibrate/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/calibrate/SKILL.md)

## Compliance & Audit Skills

Governance, transparency, and regulatory readiness.

### `/eu-ai-act-check` {#eu-ai-act-check}

EU AI Act Regulation 2024/1689 compliance checker. 9 obligations from Articles 9-15 with a tiered checklist: **25 MUST** + **27 SHOULD** + **8 COULD** items. Includes a scope-check pre-flight to skip quickly if your system is not high-risk or not EU-targeted.

- **Habit**: H1 Be Proactive + H8 Spirit (Conscience)
- **When to use**: Before major releases of high-risk AI systems targeting the EU
- **Enforcement date**: 2 August 2026
- **Source**: [`skills/eu-ai-act-check/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/eu-ai-act-check/SKILL.md)

### `/ai-dev-log` {#ai-dev-log}

Generates an AI-assisted development log from `git log` + `Co-Authored-By` trailers. 4 output modes: markdown, JSON, summary, and stdout. Useful for EU AI Act Article 11 (technical documentation) audit trails and team transparency.

- **Habit**: H4 Win-Win + H1 Be Proactive
- **When to use**: Before releases, audits, or when stakeholders ask "how much was AI-generated?"
- **Source**: [`skills/ai-dev-log/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/ai-dev-log/SKILL.md)

## Quick-Select Matrix

| I need to...                             | Use                                                                    |
| ---------------------------------------- | ---------------------------------------------------------------------- |
| Start a new feature from scratch         | [`/workflow`](#workflow) or [`/requirements`](#7-step-workflow-skills) |
| Understand this plugin                   | [`/using-8-habits`](#using-8-habits)                                   |
| Adjust guidance verbosity                | [`/calibrate`](#calibrate)                                             |
| Research before deciding                 | [`/research`](Step-0-Research)                                         |
| Review AI-generated code                 | [`/review-ai`](Step-5-Review-AI)                                       |
| Check all 8 habits at once               | [`/cross-verify`](#cross-verify)                                       |
| Assess Body/Mind/Heart/Spirit balance    | [`/whole-person-check`](#whole-person-check)                           |
| Run a focused security review            | [`/security-check`](#security-check)                                   |
| Check EU AI Act compliance               | [`/eu-ai-act-check`](#eu-ai-act-check)                                 |
| Generate AI audit trail                  | [`/ai-dev-log`](#ai-dev-log)                                           |
| Capture lessons after a task             | [`/reflect`](#reflect)                                                 |
| Deploy safely to production              | [`/deploy-guide`](Step-6-Deploy-Guide)                                 |
| Question whether the change should exist | [`/scrutinize`](#scrutinize)                                           |
| Catch drift between PRD↔design↔tasks or incident/config hotfix claims | [`/consistency-check`](#consistency-check)                             |
| Classify an operational finding          | [`/operational-state`](#operational-state)                             |
| Investigate a bug from feedback-loop     | [`/diagnose`](#diagnose)                                               |
| Write the engineering record post-fix    | [`/post-mortem`](#post-mortem)                                         |
| Scaffold a project orientation hub       | [`/save-spec`](#save-spec)                                             |
| Reshape engineer content for leadership  | [`/management-talk`](#management-talk)                                 |

## Skill Anatomy

Every skill follows the same structure ([source convention](https://github.com/pitimon/8-habit-ai-dev/blob/main/CLAUDE.md#skill-authoring-conventions)):

```yaml
---
name: <skill-name>
description: >
  When to use this skill
user-invocable: true
argument-hint: "[arg description]"
allowed-tools: ["Read", "Glob", "Grep"]
prev-skill: <predecessor|any|none>
next-skill: <successor|any|none>
---
```

Body: Habit mapping → Process → Handoff → When to Skip → Definition of Done → Checkpoint.

## See also

- **[Workflow Overview](Workflow-Overview)**
- **[Habits Reference](Habits-Reference)**
- **[Architecture](Architecture)** — how skills load and connect
- **[FAQ: When should I use which skill?](FAQ)**
