# Skills Reference

`8-habit-ai-dev` ships 24 user-facing markdown skills. Skills are read-only guidance: they structure investigation, planning, review, deployment, communication, and reflection, but they do not execute changes by themselves.

> [!TIP]
> If you are unsure where to start, use `/using-8-habits` or the quick selector below.

## Quick Selector

| Situation | Start with |
| --- | --- |
| New feature | [`/requirements`](#requirements) |
| Unclear problem | [`/research`](#research) |
| Architecture decision | [`/design`](#design) |
| AI-generated diff | [`/review-ai`](#review-ai) |
| Security-sensitive change | [`/security-check`](#security-check) |
| Production deploy | [`/deploy-guide`](#deploy-guide) |
| Operational finding | [`/operational-state`](#operational-state) |
| Bug with unclear cause | [`/diagnose`](#diagnose) |
| Incident/config hotfix drift | [`/consistency-check`](#consistency-check) |
| After a validated fix | [`/post-mortem`](#post-mortem) |
| Need stakeholder-ready wording | [`/management-talk`](#management-talk) |

## Workflow Skills

### `/research` {#research}

Investigate before specifying. Produces a research brief with findings, constraints, open questions, and recommended next step.

- Page: [Step 0 · Research](Step-0-Research)
- Habit: H5 Seek First to Understand
- Source: [`skills/research/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/research/SKILL.md)

### `/requirements` {#requirements}

Define what, why, who, scope, success criteria, and Definition of Done before implementation.

- Page: [Step 1 · Requirements](Step-1-Requirements)
- Habit: H2 Begin with End in Mind
- Source: [`skills/requirements/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/requirements/SKILL.md)

### `/design` {#design}

Surface architecture options and make the human decision explicit.

- Page: [Step 2 · Design](Step-2-Design)
- Habit: H8 Find Your Voice
- Source: [`skills/design/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/design/SKILL.md)

### `/breakdown` {#breakdown}

Decompose approved work into atomic, ordered tasks.

- Page: [Step 3 · Breakdown](Step-3-Breakdown)
- Habit: H3 Put First Things First
- Source: [`skills/breakdown/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/breakdown/SKILL.md)

### `/build-brief` {#build-brief}

Read existing code and produce an implementation brief before editing.

- Page: [Step 4 · Build Brief](Step-4-Build-Brief)
- Habit: H5 Seek First to Understand
- Source: [`skills/build-brief/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/build-brief/SKILL.md)

### `/review-ai` {#review-ai}

Review AI-generated changes before commit, with findings ordered by severity.

- Page: [Step 5 · Review AI](Step-5-Review-AI)
- Habit: H4 Think Win-Win
- Source: [`skills/review-ai/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/review-ai/SKILL.md)

### `/deploy-guide` {#deploy-guide}

Plan staging, production, rollback, verification, and reconciliation for deploys.

- Page: [Step 6 · Deploy Guide](Step-6-Deploy-Guide)
- Habit: H1 Be Proactive
- Current note: includes CI/CD proof-layer discipline and provider-managed canary/capacity reconciliation gates.
- Source: [`skills/deploy-guide/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/deploy-guide/SKILL.md)

### `/monitor-setup` {#monitor-setup}

Add or verify health checks, alerting, metrics, logging, dashboards, and runbooks after deployment.

- Page: [Step 7 · Monitor Setup](Step-7-Monitor-Setup)
- Habit: H7 Sharpen the Saw
- Source: [`skills/monitor-setup/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/monitor-setup/SKILL.md)

## Assessment And Review Skills

### `/cross-verify` {#cross-verify}

Run a 17-question 8-Habit readiness check across a plan, diff, or implementation.

- Use before implementation commitment, PR creation, or risky merge.
- Source: [`skills/cross-verify/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/cross-verify/SKILL.md)

### `/whole-person-check` {#whole-person-check}

Assess Body, Mind, Heart, and Spirit balance for a feature, component, or PR.

- Use when a technically correct change may still be unbalanced.
- Source: [`skills/whole-person-check/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/whole-person-check/SKILL.md)

### `/security-check` {#security-check}

Run a focused security lens across secrets, input handling, auth, dependencies, config, infrastructure, and source-of-truth drift.

- Use for code, infrastructure, alerting, email, webhook, container, environment, and mounted-config changes with risk-bearing behavior.
- Source: [`skills/security-check/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/security-check/SKILL.md)

### `/scrutinize` {#scrutinize}

Question whether the proposed change should exist, then trace the actual path to verify it does what it claims.

- Use before committing to a plan or before merging a PR.
- Source: [`skills/scrutinize/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/scrutinize/SKILL.md)

### `/consistency-check` {#consistency-check}

Check drift across PRD, design, and tasks. Also supports incident/config hotfix mode for symptom, evidence, root cause, fix, deploy path, and verification consistency.

- Use after persisted spec artifacts or before closing an operational hotfix PR.
- Source: [`skills/consistency-check/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/consistency-check/SKILL.md)

### `/reflect` {#reflect}

Capture a short post-task lesson, including what helped, what confused, and which skill was missed.

- Use after meaningful work, especially after incidents or release work.
- Source: [`skills/reflect/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/reflect/SKILL.md)

## Operations And Debugging Skills

### `/operational-state` {#operational-state}

Classify operational findings as Watch, Fix Candidate, Active Incident, Resolved, Handoff, Known Accepted Issue, False Positive, or Self-Resolved before action.

- Use before mutating production state, closing an alert/issue, accepting a known problem, or handing off ownership.
- Boundary: read-only guidance; no runtime state engine or automatic production change.
- Source: [`skills/operational-state/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/operational-state/SKILL.md)

### `/diagnose` {#diagnose}

Investigate a bug through feedback loop, reproduction, hypothesis, instrumentation, fix with regression test, and cleanup.

- Use when the cause is not obvious.
- Source: [`skills/diagnose/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/diagnose/SKILL.md)

### `/post-mortem` {#post-mortem}

Write the engineering record after a validated fix: root cause, mechanism, fix, validation, and how it slipped through.

- Use after a reliable repro, known cause, identified fix, and validated outcome exist.
- Source: [`skills/post-mortem/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/post-mortem/SKILL.md)

## Onboarding, Memory, And Communication Skills

### `/workflow` {#workflow}

Walk through the 7-step workflow interactively.

- Use when starting a feature and you want the agent to prompt step by step.
- Source: [`skills/workflow/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/workflow/SKILL.md)

### `/using-8-habits` {#using-8-habits}

Explain the plugin and route user intent to the most relevant skill.

- Use for onboarding or when a request does not map clearly to one skill.
- Source: [`skills/using-8-habits/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/using-8-habits/SKILL.md)

### `/calibrate` {#calibrate}

Assess guidance maturity and write a local verbosity profile for Claude Code.

- Use when guidance feels too verbose or too sparse.
- Source: [`skills/calibrate/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/calibrate/SKILL.md)

### `/save-spec` {#save-spec}

Scaffold a project-root `SPEC.md` orientation hub when a repository needs a durable project digest.

- Use when starting in an unfamiliar repo and the repo fits the project-orientation hub mode.
- Source: [`skills/save-spec/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/save-spec/SKILL.md)

### `/management-talk` {#management-talk}

Reshape engineer-to-engineer content for leadership channels such as JIRA, Slack, standup, email, or meeting notes.

- Use after technical investigation when the audience changes.
- Source: [`skills/management-talk/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/management-talk/SKILL.md)

## Audit And Governance-Adjacent Skills

### `/eu-ai-act-check` {#eu-ai-act-check}

Redirect stub for EU AI Act compliance work. The canonical implementation lives in `pitimon/claude-governance`.

- Use the governance plugin for the full checklist.
- Boundary: this plugin does not certify compliance.
- Source: [`skills/eu-ai-act-check/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/eu-ai-act-check/SKILL.md)

### `/ai-dev-log` {#ai-dev-log}

Generate an AI-assisted development log from git history and co-author trailers.

- Use for transparency, release review, or audit trail preparation.
- Source: [`skills/ai-dev-log/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/ai-dev-log/SKILL.md)

## See Also

- [Workflow Overview](Workflow-Overview)
- [Maturity Model](Maturity-Model)
- [Architecture](Architecture)
