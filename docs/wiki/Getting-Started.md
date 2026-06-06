# Getting Started

This walkthrough shows the smallest useful way to use `8-habit-ai-dev`: define the work, make the architecture decision explicit, implement with context, review before commit, and plan deployment before production.

> [!TIP]
> Use a real small feature. The workflow is clearer when the output matters.

## 1. Define The Work

```text
/requirements I need to add a rate limiter to our /api/search endpoint
```

Expected output: a short PRD with purpose, users, scope, out-of-scope items, success criteria, and Definition of Done.

Human checkpoint: correct the intent before any code is written.

## 2. Decide Architecture

```text
/design
```

Expected output: at least two viable options with trade-offs for important decisions. The AI proposes; the human chooses.

Use an ADR when the decision affects architecture, public API, persistent data, security, or more than a small local change.

## 3. Break The Work Down

```text
/breakdown
```

Expected output: atomic tasks with dependencies, priorities, and scope boundaries. Tasks should be small enough to review and test independently.

## 4. Build With Context

```text
/build-brief
```

Expected output: a task brief based on existing code, local patterns, edge cases, and files likely to change.

Only implement after the agent has read the relevant code.

## 5. Review Before Commit

```text
/review-ai
```

Expected output: findings ordered by severity, with concrete fixes. This is the default review step for AI-generated work.

Add focused checks when needed:

- `/security-check` for auth, secrets, user input, dependencies, config, or infrastructure changes.
- `/cross-verify` for larger plans or pre-PR confidence.
- `/scrutinize` when the question is whether the change should exist at all.

## 6. Plan Deployment

```text
/deploy-guide production
```

Expected output: staging steps, production steps, rollback commands, verification, and post-deploy checks.

For provider-managed canaries or capacity changes, the guide also asks you to reconcile the planned target with the provider-selected target before calling the change complete.

## 7. Observe And Reflect

```text
/monitor-setup
/reflect
```

Expected output: monitoring gaps closed, runbook updates identified, and a short lesson captured for future work.

## When To Use Less

Small, obvious fixes usually do not need every step. They still need `/review-ai`, and production-impacting changes still need `/deploy-guide`.

See [Workflow Overview](Workflow-Overview) for skip guidance.
