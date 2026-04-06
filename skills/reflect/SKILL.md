---
name: reflect
description: >
  Post-task micro-retrospective — 5 questions, 5 minutes.
  Use AFTER completing a task or workflow to capture lessons learned.
  Maps to H7 (Sharpen the Saw — invest in capability, not just output).
user-invocable: true
argument-hint: "[task or feature just completed]"
allowed-tools: ["Read", "Glob", "Grep"]
prev-skill: any
next-skill: none
---

# Reflect (ทบทวน)

**Habit**: H7 — Sharpen the Saw | **Anti-pattern**: All output, no capability improvement — repeating the same mistakes

## Why This Exists

DORA research shows per-task micro-retros (3-5 questions, 5 minutes) are more effective than monthly hour-long retrospectives. The key differentiator: teams that assign action items with owners improve; teams that just "discuss" don't.

## Process

Ask these 5 questions. Keep answers brief — this should take no more than 5 minutes.

### 1. What went well?

Reinforce good practices. What should we keep doing?

### 2. What surprised me?

Surface hidden complexity. What did we not expect?

### 3. What would I do differently?

Improve next iteration. If starting over, what would change?

### 4. What reusable pattern did I discover?

Extract for the team. Is there a script, template, or approach worth sharing?

### 5. Action item

One specific, assigned action with a deadline. Not "we should improve testing" but "create a test template for API endpoints by Friday."

## Output

```
## Reflection: [task/feature name]
**Date**: [YYYY-MM-DD]
**Duration**: [how long the task took]

| # | Question | Answer |
|---|----------|--------|
| 1 | Went well | [brief answer] |
| 2 | Surprised | [brief answer] |
| 3 | Do differently | [brief answer] |
| 4 | Reusable pattern | [brief answer or "none this time"] |
| 5 | Action item | [specific action] — **Owner**: [who] — **By**: [date] |
```

## When to Skip

- Task took less than 15 minutes
- Purely mechanical change (formatting, rename)
- Already reflected in a team retrospective covering the same work

## Definition of Done

- [ ] All 5 questions answered (even if briefly)
- [ ] Action item has an owner and deadline (or explicitly "none needed")
- [ ] Took no more than 5 minutes

Load `${CLAUDE_PLUGIN_ROOT}/habits/h7-sharpen-saw.md` for the full H7 principle and examples.
