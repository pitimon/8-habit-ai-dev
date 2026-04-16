# Step 1 · Requirements

**Command**: `/requirements [feature]` · **Habit**: H2 Begin with End in Mind · **Previous**: [Step 0 · Research](Step-0-Research) · **Next**: [Step 2 · Design](Step-2-Design)

## Purpose

Define what "done" looks like before touching code. A PRD you can verify against.

## When to use

- Any new feature
- Any bug fix whose scope is unclear
- Any refactor affecting >1 module

## When to skip

- Single-line bug fix with obvious root cause
- Formatting / linting
- Dependency version bumps

## Process

1. **Interview** — follow the [Interview Protocol](https://github.com/pitimon/8-habit-ai-dev/blob/main/guides/templates/interview-protocol.md) to discover requirements through structured conversation. Adaptive depth: Quick (3 questions) for small scope, Standard (5) by default, Deep (7+) for complex features
2. Read existing `CLAUDE.md`, `PRD.md`, `DOMAIN.md`, `README.md` — don't duplicate
3. Draft PRD summary (10–20 lines)
4. Define 3–5 verifiable success criteria in EARS notation
5. List what's **out of scope** explicitly

## Output

```
## Feature: [Name]
**What**: [1-2 sentences]
**Why**: [Problem it solves]
**Who**: [Target user]
**In scope**: [bullets]
**Out of scope**: [bullets]
**Success criteria**: [3-5 verifiable conditions]
**Definition of Done**: [what must be true]
```

## Handoff

- **Expects**: User intent (and optionally a research brief from Step 0)
- **Produces for `/design`**: PRD with scope and success criteria

## H2 Checkpoint

> [!IMPORTANT]
> _"Can I describe what success looks like before writing code?"_

## See also

- [Source: `skills/requirements/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/requirements/SKILL.md)
- [Habits Reference → H2](Habits-Reference#habit-2-begin-with-the-end-in-mind)
