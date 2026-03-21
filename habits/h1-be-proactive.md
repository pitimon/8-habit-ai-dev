# Habit 1: Be Proactive

**Focus on your Circle of Influence — act on what you can control, not what you can't.**

In AI-assisted development, your Circle of Influence is larger than you think. You can't control whether the AI generates perfect code, but you _can_ control how thoroughly you verify it, how many edge cases you consider, and whether you trace the impact of every change.

## The Principle

Reactive developers fix the bug that was reported. Proactive developers fix the bug, check every caller of the affected function, add edge case handling, and update the docs — all in the same session.

With AI assistance, being proactive costs almost nothing. An AI agent can trace all callers of a function in seconds. The question isn't capability — it's habit.

## Rules

**1. Every bug fix: trace ALL callers, not just the reported path.**

When you fix a function, ask: "What else calls this?" A bug in `parseDate()` might affect 12 callers, not just the one in the bug report. Defense-in-depth means fixing the root cause everywhere.

**2. Every new function: consider null input, missing file, permission denied, corrupt data.**

Before marking a function complete, mentally walk through the failure modes. AI assistants are optimistic — they write the happy path. You provide the paranoia.

**3. Update docs DURING feature work, not after release.**

"I'll document it later" is the most common lie in software. When the AI implements a feature, have it update the relevant docs in the same session. The context is fresh, the cost is low.

**4. Surface improvements proactively — don't wait to be asked.**

When working on area X and you notice area Y could benefit from the same fix, flag it. Even if it's out of scope, a comment like "FYI: the same date parsing issue exists in the export module" prevents future bugs.

## Anti-Patterns

- **Fix-the-line syndrome**: Changing only the exact line mentioned in the bug report without checking related code paths. The AI will happily do this — you need to ask for more.
- **Silent error suppression**: Wrapping code in try-catch with an empty catch block. The error didn't go away — you just hid it.
- **"Document later"**: Completing a feature without updating any docs. Later never comes, and the next developer (or your future self) pays the cost.

## Real Example

While running a standardized benchmark against an AI memory system, the team proactively tested not just the benchmark scenarios but also edge cases around retrieval pipeline behavior. This uncovered 2 production bugs that no user had reported — a date parser that silently returned wrong results for relative time expressions, and a search scoring function that over-weighted recency. Both would have caused subtle data quality issues. The benchmark was about measuring accuracy; the bugs were found because the team looked beyond what was asked.

## Checkpoint

> "Have I checked what else this change affects? Am I reacting or preventing?"

If you're only fixing what was reported, you're reactive. If you're preventing the next 3 bugs while fixing this one, you're proactive.

---

_Next: [Habit 2 — Begin with the End in Mind](h2-begin-with-end.md)_
