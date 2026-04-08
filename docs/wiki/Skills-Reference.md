# Skills Catalog

All 13 skills shipped with `8-habit-ai-dev`. Skills are **read-only guidance** — they tell Claude how to approach a task, they do not modify files themselves.

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

## Standalone Skills

### `/cross-verify` {#cross-verify}

17-question 8-Habit cross-verification checklist. Run **after** planning and **before** committing to implementation. Produces a dimension summary across all 8 habits.

- **Habit**: H1–H8 (all)
- **When to use**: Before `ExitPlanMode`, before PR creation
- **Source**: [`skills/cross-verify/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/cross-verify/SKILL.md)

### `/whole-person-check` {#whole-person-check}

Assess a feature/component/PR against Covey's 4 dimensions: **Body** (discipline), **Mind** (vision), **Heart** (passion), **Spirit** (conscience).

- **Habit**: H8 Find Your Voice
- **When to use**: After `/review-ai` when you want a balance check
- **Source**: [`skills/whole-person-check/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/whole-person-check/SKILL.md)

### `/security-check` {#security-check}

Focused security review — secrets, injection, auth, dependencies, OWASP Top 10. A dedicated security lens separate from general code review.

- **Habit**: H1 Be Proactive
- **When to use**: Any change touching user input, auth, data handling, or dependencies
- **Source**: [`skills/security-check/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/security-check/SKILL.md)

### `/reflect` {#reflect}

Post-task micro-retrospective — 5 questions, 5 minutes. Captures lessons before context evaporates.

- **Habit**: H7 Sharpen the Saw
- **When to use**: After completing a task or workflow
- **Source**: [`skills/reflect/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/reflect/SKILL.md)

### `/workflow` {#workflow}

Interactive guided walkthrough of the 7-step workflow. Prompts at each step to invoke or skip.

- **Habit**: All
- **When to use**: Starting a new feature when you're unsure which step comes next
- **Source**: [`skills/workflow/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/workflow/SKILL.md)

## Skill anatomy

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
- **[FAQ: When should I use which skill?](FAQ)**
