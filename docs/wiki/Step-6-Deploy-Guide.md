# Step 6 · Deploy Guide

**Command**: `/deploy-guide [staging|production]` · **Habit**: H1 Be Proactive · **Previous**: [Step 5 · Review AI](Step-5-Review-AI) · **Next**: [Step 7 · Monitor Setup](Step-7-Monitor-Setup)

## Purpose

Produce a staging-first deploy plan with a **rollback ready to paste**. Prevents the class of incidents caused by "let's just push it, it looks fine."

## When to use

- Any deploy touching production
- Any database migration
- Any config change to shared infrastructure

## When to skip

- Never for production. Local-only changes do not need this step.

## Process

1. Read existing deploy scripts, CI/CD configs, `docker-compose.yml`, `Makefile`
2. Produce **staging steps** first, with exact commands
3. Define staging **verification** — health check, smoke test, feature verify
4. Produce **production steps** (only after staging QA passes)
5. Produce **rollback procedure** — copy-pasteable commands
6. Produce **post-deploy verification**

## Output

A deploy plan document containing:

- **Deploy: [version/feature]** title
- **Staging** — numbered command list
- **Staging QA** — verification checklist (health, feature, smoke test)
- **Production** — numbered command list (only after staging QA passes)
- **Rollback (ready to paste)** — copy-pasteable commands inside a fenced block
- **Post-deploy verification** — checklist

## Rules

- **Never** combine build + deploy in one step for production
- **Never** skip staging
- **Never** deploy on a Friday afternoon without explicit reason

## Handoff

- **Expects**: Reviewed, passing code from `/review-ai`
- **Produces for `/monitor-setup`**: A deployed service ready to observe

## H1 Checkpoint

> _"Am I preventing future incidents, or reacting to current ones?"_

## See also

- [Source: `skills/deploy-guide/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/deploy-guide/SKILL.md)
- [Habits Reference → H1](Habits-Reference#habit-1-be-proactive)

```

```
