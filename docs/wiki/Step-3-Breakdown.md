# Step 3 · Breakdown

**Command**: `/breakdown [feature]` · **Habit**: H3 Put First Things First · **Previous**: [Step 2 · Design](Step-2-Design) · **Next**: [Step 4 · Build Brief](Step-4-Build-Brief)

## Purpose

Decompose a feature into atomic tasks — 1 task per focused unit of work. Prevents "one giant prompt that tries to do everything at once."

## When to use

- Any feature with >1 distinct concern
- Any work that could be parallelized
- Any time you're tempted to write a 500-word prompt

## When to skip

- Single-file change with no dependencies
- Bug fix with single touch point
- Tasks already broken down in an external tracker

## Process

1. Read PRD and design decisions from previous steps
2. Decompose — each task in 1 sentence, ≤5 files, explicit dependencies
3. Prioritize by Covey's Quadrants: **Q2 > Q1 > Q3**, eliminate Q4 (gold-plating)
4. Classify orchestration: `sequential`, `parallel-safe`, `parallel-worktree`
5. Apply the **Lazy Parallelism Gate** — only parallelize when the cost of coordination is less than the wall-clock savings

## Output

```
| # | Task | Files | Depends | Type | Q |
```

## Handoff

- **Expects**: Architecture decisions from `/design`
- **Produces for `/build-brief`**: Prioritized task list with dependencies and file paths

## H3 Checkpoint

> _"Am I doing what's important, or what's interesting?"_

## See also

- [Source: `skills/breakdown/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/breakdown/SKILL.md)
- [Orchestration patterns guide](https://github.com/pitimon/8-habit-ai-dev/blob/main/guides/orchestration-patterns.md)
- [Habits Reference → H3](Habits-Reference#habit-3-put-first-things-first)
