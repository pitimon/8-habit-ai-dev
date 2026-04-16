# Step 0 · Research

**Command**: `/research [topic]` · **Habit**: H5 Seek First to Understand · **Position**: Optional pre-step before [`/requirements`](Step-1-Requirements)

## Purpose

Investigate the problem space **before** writing requirements. Prevents specifying the wrong thing — the most expensive bug class.

## When to use

- Problem space is unclear or unfamiliar
- Multiple existing solutions exist and you need a comparison
- Domain has non-obvious constraints (regulatory, performance, security)
- You catch yourself thinking "I'll just start coding and see"

## When to skip

- You have deep domain knowledge already
- Requirement is crystal clear (e.g. "fix typo in header")
- Prior ADR already covers the decision space

## Process

1. **Define the question** — 1 sentence, specific
2. **Check past lessons** — search `~/.claude/lessons/` for relevant lessons from prior sessions (v2.6.0+)
3. **Gather prior art** — existing code, docs, web research, comparable libraries
4. **Compare** — if evaluating alternatives, produce a trade-off matrix
5. **Surface constraints** — legal, performance, team skills, budget
6. **Recommend** (not decide) — AI recommends; human decides in Step 2

## Output

A **research brief** containing:

- Problem statement
- Findings summary
- Comparison matrix (if applicable)
- Constraints
- Recommendation + rationale
- Open questions

## Handoff

- **Expects**: A topic or question from the user
- **Produces for `/requirements`**: Research brief that informs PRD scope and success criteria

## H5 Checkpoint

> [!IMPORTANT]
> _"Have I fully understood the problem before proposing a solution?"_

## See also

- [Source: `skills/research/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/research/SKILL.md)
- [Habits Reference → H5](Habits-Reference#habit-5-seek-first-to-understand)
- Next: [Step 1 · Requirements](Step-1-Requirements)
