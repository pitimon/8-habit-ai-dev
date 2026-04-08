# Step 4 · Build Brief

**Command**: `/build-brief [task]` · **Habit**: H5 Seek First to Understand · **Previous**: [Step 3 · Breakdown](Step-3-Breakdown) · **Next**: [Step 5 · Review AI](Step-5-Review-AI)

## Purpose

Produce a context-rich implementation brief **before** Claude writes any code. Forces the "read first, write second" discipline that separates expert engineers from vibe coders.

## When to use

- Before every non-trivial task from the breakdown
- When the file you're editing has >100 lines you haven't read
- When the task touches an unfamiliar module

## When to skip

- Single-file bugfix in code you wrote this session
- Formatting / obvious mechanical changes

## Process

0. **Problem statement gate** (required) — state the problem in 1 sentence
1. **Read existing code** — files the task will touch, plus their callers
2. **Identify patterns** to follow (naming, error handling, testing style)
3. **List edge cases** — null inputs, permissions, concurrency, failure modes
4. **Produce the brief** — files to touch, functions to add/modify, test plan

## Output

```
## Brief: [Task]
**Problem**: 1 sentence
**Files to touch**: [list]
**Existing patterns**: [observations]
**Edge cases**: [list]
**Test plan**: [what to verify]
**Rollback**: [if applicable]
```

## Handoff

- **Expects**: A task from `/breakdown`
- **Produces for `/review-ai`**: Implemented code with a brief to review against

## H5 Checkpoint

> _"Have I read enough of the existing code to make good judgments here?"_

## See also

- [Source: `skills/build-brief/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/build-brief/SKILL.md)
- [Habits Reference → H5](Habits-Reference#habit-5-seek-first-to-understand)
