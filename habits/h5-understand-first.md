# Habit 5: Seek First to Understand

**Read existing code before writing new code. Reproduce bugs before fixing them.**

AI coding assistants have a bias toward action — they generate solutions immediately. But the most common source of bugs in AI-assisted development isn't wrong code; it's code that's correct in isolation but wrong in context. The context comes from understanding first.

## The Principle

Empathic listening in development means truly understanding the codebase, the problem, and the constraints before proposing a solution. This is harder with AI assistants because they're so fast that skipping the understanding phase feels like efficiency. It isn't.

## Rules

**1. Read existing code before writing new code.**

Before asking an AI to implement a feature, read the module it will live in. Understand the patterns, conventions, and existing utilities. Otherwise the AI will reinvent something that already exists, or use a different pattern than the rest of the codebase.

```
// Common failure mode:
// AI generates a new date parser
// The project already has a date utility module with 15 edge cases handled
// Now there are two date parsers, and only one handles edge cases
```

**2. Reproduce bugs before fixing them.**

If you can't reproduce a bug, you can't verify the fix. AI assistants will happily generate a "fix" for a bug description, but without reproduction steps, you're guessing. The fix might suppress the symptom while leaving the root cause intact.

**3. Read ALL feedback; identify patterns, not just individual items.**

When reviewing test failures, error logs, or code review comments, look for patterns. Three different review comments about error handling aren't three separate issues — they're a systemic gap in how errors are handled across the codebase.

**4. Ask clarifying questions when scope is ambiguous — don't assume.**

"Add caching" could mean: add Redis, add in-memory cache, add HTTP cache headers, or add browser cache. Each is a different week of work. Ask before building.

## Anti-Patterns

- **Write-first, read-later**: Generating code immediately without reading the existing module. Results in duplicated utilities, inconsistent patterns, and style clashes.
- **Fix without reproduce**: "The bug report says X, so the fix must be Y." Without reproduction, you might fix a symptom while the root cause persists — or fix the wrong thing entirely.
- **Answering the wrong question**: The user asks "how do I speed up this query?" The real problem is that the query runs on every page load instead of being cached. Understanding the context reveals the real solution.

## Real Example

While optimizing a search retrieval pipeline for an AI memory system, the team went through 7 iterations of benchmark testing. Each iteration revealed something new about how the pipeline actually behaved versus how it was assumed to behave. The first attempt improved scoring by tweaking weights — a "write-first" approach that barely moved the needle. The breakthrough came in iteration 4, when the team stopped tweaking and instead instrumented the pipeline to understand _why_ certain queries failed. They discovered that the search wasn't missing relevant results — it was finding them but scoring them wrong due to a normalization bug. Understanding the actual behavior led to a targeted fix that improved accuracy by 12 points. The first 3 iterations were wasted because they skipped understanding.

## The Understanding Sequence

For any non-trivial task, follow this sequence:

1. **Read** — What code already exists in this area?
2. **Reproduce** — Can I trigger the current behavior?
3. **Understand** — Why does it behave this way?
4. **Propose** — What change would fix/improve it?
5. **Verify** — Does the change work without side effects?

AI assistants are great at steps 4-5. You need to ensure steps 1-3 happen first.

## Checkpoint

> "Have I fully understood the problem before proposing a solution?"

If you're generating code based on a title alone, stop. Read the code, reproduce the issue, understand the context.

---

_Next: [Habit 6 — Synergize](h6-synergize.md)_
