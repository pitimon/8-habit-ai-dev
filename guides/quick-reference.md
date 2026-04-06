# Quick Reference — 8 Habits at a Glance

**Scannable in 2 minutes.** Top rules from all 8 habits, sorted by priority.

Based on Miller's Law (5-9 items per group) and Kubernetes/Git cheat sheet patterns.

## CRITICAL — Always Do These

| Habit | Do                                                       | Don't                                          | Why                                                          |
| ----- | -------------------------------------------------------- | ---------------------------------------------- | ------------------------------------------------------------ |
| H4    | Review code before every commit                          | Skip review "just this once"                   | 2 CRITICAL + 3 HIGH issues shipped in one skipped review     |
| H1    | Trace ALL callers of a bug fix                           | Fix only the reported line                     | Root cause may affect 12 callers, not just 1                 |
| H2    | Define 3-5 success criteria before coding                | Start coding without "done" definition         | Without a target, you can't verify if AI output is correct   |
| H1    | Handle edge cases: null, missing file, permission denied | Write only the happy path                      | AI-generated code skews optimistic — you provide paranoia    |
| H5    | Read existing code before writing new code               | Generate new code without checking what exists | 120 lines of new parser vs 1-line import of existing utility |

## HIGH — Do Most of the Time

| Habit | Do                                                      | Don't                                          | Why                                                         |
| ----- | ------------------------------------------------------- | ---------------------------------------------- | ----------------------------------------------------------- |
| H3    | Work on most important thing (Q2), not most interesting | Gold-plate or add unasked features             | Nice-to-have features steal time from critical ones         |
| H2    | Commit messages explain WHY, not just WHAT              | `git commit -m "fix: update parser"`           | Future you (and reviewers) need context, not a diff summary |
| H1    | Update docs DURING feature work                         | "I'll document it later"                       | Later never comes; context is fresh now                     |
| H4    | Error messages: explain what went wrong + how to fix    | Error messages that just say "failed"          | Opaque errors cost hours of debugging downstream            |
| H6    | Run independent tasks in parallel                       | Sequential execution when parallel is possible | 37% time saved by identifying independent work              |
| H5    | Reproduce bugs before fixing them                       | Apply a fix without verifying the bug          | Fix might suppress symptom while leaving root cause         |

## MEDIUM — When Applicable

| Habit | Do                                            | Don't                                                 | Why                                                         |
| ----- | --------------------------------------------- | ----------------------------------------------------- | ----------------------------------------------------------- |
| H8    | Understand WHY before implementing            | "Just following orders" — execute without questioning | AI can suggest improvements if it understands the goal      |
| H3    | Finish current task before starting new one   | Context-switch between tasks                          | Half-done tasks produce poor results on both                |
| H6    | Consider a third alternative beyond A or B    | Accept binary choices at face value                   | "Redis vs Memcached?" → maybe in-memory with Redis fallback |
| H4    | Close issues with detailed rationale          | Close with just "fixed"                               | Future developers need context for similar issues           |
| H7    | Capture what you learned (script, doc, issue) | Complete task and immediately start next              | Lessons evaporate; same mistakes recur                      |

## LOW — Nice to Have

| Habit | Do                                                     | Don't                          | Why                                               |
| ----- | ------------------------------------------------------ | ------------------------------ | ------------------------------------------------- |
| H8    | Surface improvements the user hasn't asked for         | Wait to be asked               | A comment today prevents a bug tomorrow           |
| H7    | Periodically review frameworks, dependencies, security | "It works, don't touch it"     | Accumulated tech debt demands payment all at once |
| H8    | Publish patterns that could help others                | Keep useful solutions internal | Spirit dimension: "Should we share this? Yes."    |

## Quick Stats

- **CRITICAL**: 5 rules — always, no exceptions
- **HIGH**: 6 rules — do most of the time
- **MEDIUM**: 5 rules — when applicable
- **LOW**: 3 rules — nice to have
- **Total**: 19 rules covering all 8 habits

---

_See [situation-map.md](situation-map.md) for "which habit for which situation." Back to [README](../README.md)_
