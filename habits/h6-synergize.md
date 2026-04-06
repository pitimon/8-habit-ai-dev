# Habit 6: Synergize

**Human judgment + AI execution is greater than either alone.**

Synergy isn't about the AI doing more or the human doing less. It's about each contributing what they do best — simultaneously, in complementary ways — to produce something neither could alone.

## The Principle

True synergy means 1+1=3. In AI-assisted development:

- **Human strengths**: Judgment, context, taste, "does this feel right?", understanding users, architectural decisions
- **AI strengths**: Speed, consistency, parallel execution, pattern matching, tireless iteration, exhaustive search

The magic happens when you combine both in the right way. Not AI-first or human-first — together.

## Rules

**1. Use parallel agents for independent tasks.**

When three modules need updating and they don't depend on each other, run three parallel AI agents instead of working sequentially. A task that takes 3 hours sequentially can finish in 1 hour with parallelization.

**2. Wave-based execution for dependent work.**

When tasks have dependencies, organize them in waves:

```
Wave 1 (parallel): Create database schema, design API contract, write test fixtures
Wave 2 (parallel): Implement routes, write integration tests (uses Wave 1 outputs)
Wave 3 (sequential): Integration testing, documentation update
```

Each wave can run in parallel internally, but waves execute in sequence.

### Before/After: Sequential vs Parallel

```
# BEFORE — sequential execution (40 min total):
  research (10m) → design (10m) → implement (15m) → test (5m)

# AFTER — parallel where independent (25 min total):
  research (10m) → design (10m) ──→ implement (15m) → test
                 └→ test fixtures ─┘  (parallel — no dependency)
  Saved: 15 min (37%) by identifying independent work
```

**3. Seek third alternatives — not just option A or B.**

AI assistants often present binary choices: "Should we use Redis or Memcached?" But the third alternative might be better: "Use in-memory cache with Redis fallback for shared state." Always ask: "Is there a creative option C?"

**4. Combine strengths deliberately.**

| Task                      | Who Does It Best | Why                 |
| ------------------------- | ---------------- | ------------------- |
| Write implementation code | AI               | Speed, consistency  |
| Review generated code     | Human            | Judgment, context   |
| Run tests exhaustively    | AI               | Tireless, thorough  |
| Decide what to test       | Human            | Risk assessment     |
| Refactor for patterns     | AI               | Pattern matching    |
| Choose the pattern        | Human            | Architecture vision |
| Search for related issues | AI               | Exhaustive search   |
| Decide priority           | Human            | Business context    |

## Anti-Patterns

- **Sequential when parallel is possible**: Working on files one at a time when they're independent. Ask: "Can any of these run simultaneously?"
- **"Not my problem" blinders**: Fixing a bug in module A without noticing that module B (open in the same session) has the same issue. When you touch area X, look around: "What else here benefits from improvement?"
- **Compromise instead of synergy**: Compromise means both sides give something up (lose-lose). Synergy means finding a solution where both sides get what they need (win-win). "Let's use half Redis and half Memcached" is compromise. "Let's use Redis for pub/sub and in-memory for hot cache" is synergy.

## Real Example

When documenting architectural patterns for an AI memory system, the team needed to produce 11 pattern files covering search, data architecture, AI infrastructure, and operations. Instead of writing them sequentially (which would have taken a full day), they launched 3 parallel AI agents — one for search patterns, one for data patterns, one for infrastructure patterns. Each agent had its own context and didn't depend on the others. All 11 files were drafted in under 2 hours. The human then reviewed all files in a single pass, catching 4 consistency issues across patterns that no single agent could have seen. Total time: 3 hours instead of 8+. Quality: higher, because the human review caught cross-cutting concerns.

## The Synergy Checklist

Before starting any multi-part task, ask:

1. Which parts are independent? (parallelize these)
2. Which parts depend on others? (sequence these in waves)
3. What does the human do best here? (judgment, decisions, review)
4. What does the AI do best here? (execution, search, iteration)
5. Is there a third alternative we haven't considered?

## Quick Reference

| Do                                               | Don't                                                | Why                                                  |
| ------------------------------------------------ | ---------------------------------------------------- | ---------------------------------------------------- |
| Run independent tasks in parallel                | Sequential execution when parallel is possible       | 37% time saved by identifying independent work       |
| Seek a third alternative beyond A or B           | Accept binary choices at face value                  | "Redis vs Memcached?" maybe in-memory + fallback     |
| Combine strengths: human judgment + AI execution | Try to do everything yourself or delegate everything | Neither alone matches the combination                |
| Use wave-based execution for dependent tasks     | Mix dependent and independent work randomly          | Waves = parallel within, sequential between          |
| When touching area X, check what else benefits   | "Not my problem" mindset                             | Nearby improvements are cheap while context is fresh |

## Checkpoint

> "Am I leveraging all available capabilities? Is there a third alternative?"

If you're working sequentially on independent tasks, or if you're choosing between two options without looking for a creative third, you're leaving synergy on the table.

---

_Next: [Habit 7 — Sharpen the Saw](h7-sharpen-saw.md)_
