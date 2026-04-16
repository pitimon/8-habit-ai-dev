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

## Token-Efficient Parallel Design (v2.8.0)

When designing `parallel-safe` or `parallel-worktree` tasks, optimize for prompt cache sharing:

- **Maximize shared context** — group tasks that read the same files so their `/build-brief` prefixes overlap (~90% token savings)
- **Minimize divergence point** — task-specific instructions go LAST in the agent prompt; everything before is the cached shared prefix
- **Avoid redundant reads** — include shared files in the brief once rather than having each agent read them independently

Most valuable for 3+ parallel tasks. For 2 tasks, the optimization overhead rarely pays off.

## H3 Checkpoint

> [!IMPORTANT]
> _"Am I doing what's important, or what's interesting?"_

## See also

- [Source: `skills/breakdown/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/breakdown/SKILL.md)
- [Orchestration patterns guide](https://github.com/pitimon/8-habit-ai-dev/blob/main/guides/orchestration-patterns.md)
- [Habits Reference → H3](Habits-Reference#habit-3-put-first-things-first)
