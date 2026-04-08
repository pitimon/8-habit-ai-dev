# 8 Habits Reference

> Auto-generated from [`habits/`](https://github.com/pitimon/8-habit-ai-dev/tree/main/habits) — **do not edit this page directly**. Edit the source files and submit a PR.

Based on Stephen Covey's *7 Habits of Highly Effective People* + *The 8th Habit*, adapted for AI-assisted development.

## Table of Contents

- [Habit 1: Be Proactive](#habit-1-be-proactive)
- [Habit 2: Begin with the End in Mind](#habit-2-begin-with-the-end-in-mind)
- [Habit 3: Put First Things First](#habit-3-put-first-things-first)
- [Habit 4: Think Win-Win](#habit-4-think-win-win)
- [Habit 5: Seek First to Understand](#habit-5-seek-first-to-understand)
- [Habit 6: Synergize](#habit-6-synergize)
- [Habit 7: Sharpen the Saw](#habit-7-sharpen-the-saw)
- [Habit 8: Find Your Voice and Inspire Others](#habit-8-find-your-voice-and-inspire-others)

---

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

### Before/After: Reactive vs Proactive Fix

```javascript
// REACTIVE: fix only the reported path
function parseDate(input) {
  return new Date(input); // "fixed" here, but 11 other callers still break
}

// PROACTIVE: fix the function AND verify all callers
function parseDate(input) {
  if (!input || typeof input !== "string") return null;
  const parsed = new Date(input);
  return isNaN(parsed.getTime()) ? null : parsed;
}
// Then: grep -r "parseDate(" src/ to verify all 12 callers handle null
```

## Anti-Patterns

- **Fix-the-line syndrome**: Changing only the exact line mentioned in the bug report without checking related code paths. The AI will happily do this — you need to ask for more.
- **Silent error suppression**: Wrapping code in try-catch with an empty catch block. The error didn't go away — you just hid it.
- **"Document later"**: Completing a feature without updating any docs. Later never comes, and the next developer (or your future self) pays the cost.

## Real Example

While running a standardized benchmark against an AI memory system, the team proactively tested not just the benchmark scenarios but also edge cases around retrieval pipeline behavior. This uncovered 2 production bugs that no user had reported — a date parser that silently returned wrong results for relative time expressions, and a search scoring function that over-weighted recency. Both would have caused subtle data quality issues. The benchmark was about measuring accuracy; the bugs were found because the team looked beyond what was asked.

## Quick Reference

| Do                                           | Don't                        | Why                                        |
| -------------------------------------------- | ---------------------------- | ------------------------------------------ |
| Trace ALL callers of a bug fix               | Fix only the reported line   | Root cause may affect 12 callers           |
| Handle null, missing file, permission denied | Write only happy path        | AI skews optimistic                        |
| Update docs DURING feature work              | "Document it later"          | Later never comes                          |
| Surface improvements proactively             | Wait to be asked             | A comment today prevents a bug tomorrow    |
| Consider edge cases before marking done      | Assume AI covered everything | AI-generated code skews toward happy paths |

## Checkpoint

> "Have I checked what else this change affects? Am I reacting or preventing?"

If you're only fixing what was reported, you're reactive. If you're preventing the next 3 bugs while fixing this one, you're proactive.

---

_Next: [Habit 2 — Begin with the End in Mind](#habit-2-begin-with-the-end-in-mind)_

---

# Habit 2: Begin with the End in Mind

**Define "done" before writing a single line of code.**

AI coding assistants will eagerly start generating code the moment you describe a feature. That speed is a trap if you haven't defined what success looks like. Without clear acceptance criteria, you'll iterate endlessly — not because the AI is bad, but because you never specified the target.

## The Principle

Every meaningful task needs a Definition of Done that is specific enough to verify. "It works" is not a definition. "The API returns 200 with valid JSON, handles missing fields with 400, and rejects unauthenticated requests with 401" — that's a definition.

The best acceptance criteria are **grep-checkable** — you can search the codebase to verify they're met.

## Rules

**1. Plan files MUST have "Success Criteria" and "Definition of Done".**

Before any multi-file change, write down what success looks like. Not a vague description — concrete, verifiable statements:

```markdown
## Success Criteria

- [ ] GET /api/search returns results sorted by relevance score
- [ ] Response time < 200ms for queries under 50 characters
- [ ] Empty queries return 400 with descriptive error message
- [ ] All endpoints require authentication
```

**2. PR body MUST have "Test Plan" with verification steps.**

A PR without a test plan is a PR that "works on my machine." Every PR body should answer: "How can a reviewer verify this works?"

```markdown
## Test Plan

- [ ] Run `curl -H "X-API-Key: test" /api/search?q=hello` — expect 200
- [ ] Run `curl /api/search?q=hello` (no auth) — expect 401
- [ ] Run `curl -H "X-API-Key: test" /api/search` (no query) — expect 400
```

### Before/After: Commit Messages

```
# BEFORE (withdrawal — reader learns nothing):
git commit -m "fix: update parser"

# AFTER (deposit — reader understands WHY):
git commit -m "fix(search): handle relative dates — 'yesterday' queries
returned future dates due to timezone offset in parseRelativeDate()"
```

**3. Before coding: "What does done look like? How will we verify it?"**

Ask this question every time. If you can't answer it, you're not ready to code. This applies doubly with AI assistants — they'll produce something, but without a target, you won't know if it's right.

**4. Commit messages explain WHY, not just WHAT.**

`fix: update parser` tells you nothing. `fix(search): handle relative dates to prevent wrong results for "yesterday" queries` tells the next developer everything they need.

## Anti-Patterns

- **Starting without criteria**: "Build me a search endpoint" -> AI generates code -> endless revision. Better: define inputs, outputs, error cases, and performance bounds first.
- **"It works on my machine" PRs**: No test plan, no verification steps. The reviewer has no way to validate the change without reverse-engineering your intent.
- **Scope creep from undefined boundaries**: Without a Definition of Done, every review comment becomes "while you're at it, could you also..." The scope grows until nothing ships.

## Real Example

On a production AI memory system project, every planning document followed a strict template that included "Success Criteria" and "Definition of Done" sections. When implementing a new search algorithm, the plan specified: "F1 score >= 0.65 on the standard benchmark, response time < 500ms p95, zero regression on existing query types." This made the AI's work measurable. Three iterations of generated code were rejected not because they were bad, but because they didn't meet the pre-defined threshold. The fourth iteration passed — and everyone knew it was done.

## Quick Reference

| Do                                         | Don't                                  | Why                                             |
| ------------------------------------------ | -------------------------------------- | ----------------------------------------------- |
| Define 3-5 success criteria before coding  | Start coding without "done" definition | Without a target, you can't verify AI output    |
| Include test plan in every PR              | "It works on my machine"               | Reviewers need verification steps               |
| Commit messages explain WHY                | `git commit -m "fix: update parser"`   | Future readers need context, not a diff summary |
| Ask "what does done look like?" every time | Jump into implementation               | AI produces something, but is it right?         |
| Document constraints and non-goals         | Leave scope boundaries implicit        | Scope creep starts when boundaries are unclear  |

## Checkpoint

> "Can I describe what success looks like before writing code?"

If you can't write 3-5 concrete, verifiable success criteria, you're not ready to start. Go back and think about the end.

---

_Next: [Habit 3 — Put First Things First](#habit-3-put-first-things-first)_

---

# Habit 3: Put First Things First

**Invest in what's important before it becomes urgent.**

AI assistants make it tempting to skip the boring stuff — tests, code review, CI checks — because generating new code is fast and exciting. But every shortcut today becomes a crisis tomorrow.

## The Principle

Covey's Time Management Matrix divides work into four quadrants:

|                   | Urgent                                                 | Not Urgent                                        |
| ----------------- | ------------------------------------------------------ | ------------------------------------------------- |
| **Important**     | Q1: Crisis (production down, security breach)          | Q2: Prevention (tests, CI, reviews, architecture) |
| **Not Important** | Q3: Interruptions (trivial requests, context-switches) | Q4: Waste (gold-plating, premature optimization)  |

The key insight: **Quadrant II work prevents Quadrant I crises.** Writing tests today prevents debugging production tomorrow. Setting up CI now prevents shipping broken builds next week.

AI assistants make Q4 seductively easy. "While you're at it, add dark mode" takes 30 seconds to ask and 2 hours to properly implement. Stay disciplined.

## Rules

**1. NEVER skip: PR creation, CI checks, test verification.**

These are Q2 activities. They feel unnecessary when everything works. But they're the firewall between "it works locally" and "it works in production." AI-generated code needs _more_ review, not less.

**2. Before unplanned work: "Is this in scope?"**

When an AI suggests an improvement, or a teammate asks for a quick addition, ask: Is this Quadrant II (important, prevents future problems) or Quadrant IV (nice-to-have, doesn't serve the goal)?

**3. Prioritize process improvements over firefighting.**

If you spend every week fixing the same class of bug, the fix isn't another patch — it's a linter rule, a test suite, or an architectural change. Invest in the system, not the symptoms.

**4. One task at a time — finish before starting new ones.**

Context-switching kills quality. An AI assistant that's halfway through implementing feature A and gets redirected to feature B will produce poor results on both. Finish A, commit, then start B.

### Before/After: Q1 Firefighting vs Q2 Prevention

```yaml
# BEFORE — Q1 reactive firefighting every sprint:
sprint-12: "fix: search timeout in production (again)"
sprint-13: "fix: search timeout different endpoint (again)"
sprint-14: "fix: search timeout under load (again)"

# AFTER — Q2 proactive investment:
sprint-12: "feat: add circuit breaker + configurable timeout for all search endpoints"
sprint-12: "feat: add search latency dashboard with P95 alerting"
# Result: zero search timeout incidents in sprints 13-20
```

## Anti-Patterns

- **Gold-plating**: Adding features nobody asked for because the AI makes it easy. "Let me also add pagination, sorting, and full-text search" when the ticket says "add a list endpoint." Ship the requirement, then enhance.
- **"Just this once" skipping**: Skipping tests "because this change is trivial." Trivial changes break production more often than complex ones — precisely because nobody reviews them carefully.
- **Context-switching**: Jumping between 3 features in one session. Each switch costs re-reading context, losing state, and introducing inconsistencies. AI assistants lose context too.

## Real Example

When implementing a benchmark evaluation for an AI memory system, the team faced a choice: spend time building proper benchmark infrastructure (test harness, data loading, scoring pipeline) or manually run a few queries and eyeball the results. They chose the infrastructure — a Q2 investment that felt slow at first. But when the benchmark needed to run 7 times over 3 weeks of optimization, the infrastructure paid for itself many times over. Teams that skip Q2 would have spent hours on each manual run, or worse, drawn wrong conclusions from inconsistent manual testing.

## Quick Reference

| Do                                                   | Don't                               | Why                                          |
| ---------------------------------------------------- | ----------------------------------- | -------------------------------------------- |
| Never skip PR creation, CI checks, test verification | "Just this once" shortcuts          | Skipping Q2 creates Q1 crises later          |
| Ask "is this in scope?" before unplanned work        | Gold-plate with unasked features    | Nice-to-have steals time from critical       |
| Invest in process improvements (Q2)                  | Firefight the same bug every sprint | Fix the system, not the symptom              |
| Finish current task before starting new one          | Context-switch between tasks        | Half-done tasks produce poor results on both |
| Prioritize by importance, not interest               | Work on what's fun or easy          | Important work prevents future problems      |

## Checkpoint

> "Am I doing what's important, or what's urgent? Will this prevent future problems?"

If you're firefighting the same issues repeatedly, you're stuck in Q1. Step back and invest in Q2.

---

_Next: [Habit 4 — Think Win-Win](#habit-4-think-win-win)_

---

# Habit 4: Think Win-Win

**Every interaction is a deposit or withdrawal from the Emotional Bank Account.**

In AI-assisted development, your "interactions" include code, commits, issue comments, error messages, and documentation. Each one either helps the next person (deposit) or makes their life harder (withdrawal).

## The Principle

Covey's Emotional Bank Account applies to codebases too. Every artifact you produce is a transaction:

| Deposit                                                         | Withdrawal                |
| --------------------------------------------------------------- | ------------------------- |
| Closing an issue with rationale, what was tried, and next steps | Closing with just "fixed" |
| Error messages that explain what went wrong AND how to fix it   | `Error: failed`           |
| Commit messages that explain why the change was made            | `fix: stuff`              |
| Documentation updated alongside the code                        | Code ships, docs rot      |
| PR descriptions with test plans                                 | PRs with "see commits"    |

## Rules

**1. Close issues with detailed rationale and next steps.**

When closing a GitHub issue, explain: what was the root cause, what was the fix, what was considered but rejected, and what to watch for. This is a deposit for the developer who hits the same problem in 6 months.

**2. Error messages should help the next developer understand AND fix the problem.**

```
// Withdrawal
throw new Error('Database connection failed')

// Deposit
throw new Error(
  'Database connection failed: host "db.internal" unreachable. ' +
  'Check DATABASE_URL in .env and verify the database is running.'
)
```

**3. When disagreeing, propose alternatives that serve both sides.**

"That won't work" is a withdrawal. "That approach has a performance issue at scale — what if we use a queue instead? It handles both the immediate need and future growth" is a deposit.

**4. AI-generated code should be reviewed for Win-Win quality.**

AI assistants often generate correct but unhelpful error messages, vague variable names, and no comments. Review generated code not just for correctness, but for whether it helps the next person who reads it.

## Anti-Patterns

- **"Fixed" issue closures**: Zero context for future reference. When someone Googles the same problem and finds your closed issue, they learn nothing.
- **Opaque error messages**: `Error code 42` with no documentation. The person debugging at 2 AM deserves better.
- **Win-Lose reviews**: Code review comments that prove you're smart instead of helping the author improve. "Obviously this should use a factory pattern" vs "A factory pattern here would let us add new providers without modifying this file."

## Real Example

On a production project, the team adopted a policy: every issue must be closed with a comment summarizing root cause, solution, and what to watch for. Six months later, when a similar issue appeared, a developer searched closed issues, found the detailed closure comment, and resolved the new issue in 20 minutes instead of 2 hours. That single deposit paid dividends across the team.

## Quick Reference

| Do                                                              | Don't                                               | Why                                         |
| --------------------------------------------------------------- | --------------------------------------------------- | ------------------------------------------- |
| Close issues with detailed rationale                            | Close with just "fixed"                             | Future devs need context for similar issues |
| Error messages: what went wrong + how to fix                    | Error messages that just say "failed"               | Opaque errors cost hours downstream         |
| Review for Win-Win: help author improve                         | Review to find flaws and point blame                | Win-Lose reviews destroy collaboration      |
| Propose alternatives when disagreeing                           | Force your solution without considering constraints | Both sides should walk away better off      |
| AI-generated code: review for helpfulness, not just correctness | Ship AI output without reading it                   | Correct but unhelpful code is a withdrawal  |

## Checkpoint

> "Does this interaction leave the other party better informed and more capable?"

If your commit message, error message, or issue comment doesn't help the next person, rewrite it.

---

_Next: [Habit 5 — Seek First to Understand](#habit-5-seek-first-to-understand)_

---

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

### Before/After: Write-First vs Understand-First

```python
# BEFORE — write-first: AI generates a brand new date parser (120 lines)
def parse_date(text):
    """Parse date string to datetime."""
    formats = ["%Y-%m-%d", "%m/%d/%Y", "%d %b %Y"]
    for fmt in formats:
        try: return datetime.strptime(text, fmt)
        except ValueError: continue
    return None

# AFTER — understand-first: read existing code, discover it already exists
from app.utils.dates import parse_date  # handles 15 formats + relative dates
# No new code needed. 120 lines saved. Zero new bugs introduced.
```

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

## Quick Reference

| Do                                                           | Don't                                            | Why                                                   |
| ------------------------------------------------------------ | ------------------------------------------------ | ----------------------------------------------------- |
| Read existing code before writing new code                   | Generate new code without checking what exists   | 120 lines of new parser vs 1-line import              |
| Reproduce bugs before fixing them                            | Apply fix without verifying the bug              | Fix might suppress symptom, not root cause            |
| Identify patterns across feedback, not just individual items | Treat each review comment as isolated            | Three error-handling comments = systemic gap          |
| Ask clarifying questions when scope is ambiguous             | Assume "add caching" means one specific approach | Could mean Redis, in-memory, HTTP headers, or browser |
| Read ALL feedback before responding                          | Cherry-pick the easy comments                    | Patterns emerge from the full picture                 |

## Checkpoint

> "Have I fully understood the problem before proposing a solution?"

If you're generating code based on a title alone, stop. Read the code, reproduce the issue, understand the context.

---

_Next: [Habit 6 — Synergize](#habit-6-synergize)_

---

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

**3. Apply the Lazy Parallelism Gate before spawning agents.**

Not every multi-part task benefits from parallelization. Before launching parallel agents, ask: "Can I do this sequentially in ≤5 tool calls?" If yes, the sequential path is cheaper — no context loading, no coordination, no result merging. Only parallelize when tasks are meaningfully disjoint: different files, different concerns, substantial enough to justify the overhead.

### Before/After: Premature vs Lazy Parallelism

```
# BEFORE — premature parallelism (3 agents for trivial work):
  Agent 1: Read config.ts (1 tool call)
  Agent 2: Read schema.ts (1 tool call)
  Agent 3: Read types.ts (1 tool call)
  → 3 agents launched, 3 contexts loaded, results merged
  → Total overhead: ~30s setup for 3s of actual work

# AFTER — lazy parallelism (sequential, 3 tool calls):
  Read config.ts → Read schema.ts → Read types.ts
  → Same result, zero coordination overhead
  → Reserve parallelism for substantial independent work
```

**4. Seek third alternatives — not just option A or B.**

AI assistants often present binary choices: "Should we use Redis or Memcached?" But the third alternative might be better: "Use in-memory cache with Redis fallback for shared state." Always ask: "Is there a creative option C?"

**5. Combine strengths deliberately.**

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
| Apply Lazy Parallelism Gate before spawning      | Launch agents for trivial 1-2 tool call tasks        | Overhead of context loading exceeds time saved       |
| Seek a third alternative beyond A or B           | Accept binary choices at face value                  | "Redis vs Memcached?" maybe in-memory + fallback     |
| Combine strengths: human judgment + AI execution | Try to do everything yourself or delegate everything | Neither alone matches the combination                |
| Use wave-based execution for dependent tasks     | Mix dependent and independent work randomly          | Waves = parallel within, sequential between          |
| When touching area X, check what else benefits   | "Not my problem" mindset                             | Nearby improvements are cheap while context is fresh |

## Checkpoint

> "Am I leveraging all available capabilities? Is there a third alternative?"

If you're working sequentially on independent tasks, or if you're choosing between two options without looking for a creative third, you're leaving synergy on the table.

---

_Next: [Habit 7 — Sharpen the Saw](#habit-7-sharpen-the-saw)_

---

# Habit 7: Sharpen the Saw

**Invest in Production Capability, not just Production output.**

AI assistants make it dangerously easy to keep producing — shipping features, fixing bugs, writing more code. But a saw that never gets sharpened eventually can't cut. The same applies to your development process, infrastructure, and knowledge.

## The Principle

Covey's P/PC Balance: **P** is Production (output), **PC** is Production Capability (the ability to produce). If you focus only on P, PC degrades until you can't produce at all.

In AI-assisted development, PC includes: your CI pipeline, your test suite, your deployment process, your monitoring, your understanding of the codebase, and the AI's ability to work effectively within your system.

## Rules

**1. Track tech debt explicitly — don't let it accumulate silently.**

Every "TODO: fix later" should be a tracked issue with a severity tag. AI assistants generate TODOs liberally. If you don't track them, they become invisible rot.

**2. After completing a task: "What did we learn? What could be automated?"**

Every session produces knowledge. If you fixed a deployment issue, write down what went wrong and how to prevent it. If you repeated the same 5 steps, write a script. If the AI made a mistake, add a guardrail.

**3. Periodic review: frameworks, dependencies, security posture.**

Schedule time to update dependencies, review security advisories, and assess whether your tools are still the right choice. This is Q2 work (Habit 3) that prevents Q1 crises.

**4. Invest in AI collaboration infrastructure.**

The more context your AI assistant has (project docs, coding standards, architectural decisions), the better its output. Maintaining a clear CLAUDE.md, keeping docs current, and writing good commit messages are all PC investments — they make every future AI session more productive.

**5. Invest in the meta-system — the system that builds the system.**

When AI agents can rebuild a codebase in hours, the bottleneck shifts from coding speed to orchestration quality. The plugin you configure, the workflow you follow, the decomposition patterns you use — these are the meta-system. Improving the meta-system compounds: every future task benefits from better orchestration, clearer boundaries, and smarter decomposition.

> "If you're only looking at the files created in this repository, you're looking at the wrong layer. What you should study is the system that built it." — UltraWorkers philosophy

### Before/After: All Output vs Capability Investment

```bash
# BEFORE — manual deploy every time (P only, no PC):
ssh server "cd /app && git pull && npm install && pm2 restart"
# 60 min per deploy, error-prone, no rollback, repeated every release

# AFTER — invested in CI/CD (10 min PC investment, 2 min deploys forever):
git push origin main
# GitHub Actions: build → test → staging → health check → production
# Rollback: git revert + push. Total: 2 min. Repeatable. Safe.
```

## Anti-Patterns

- **All output, no capability**: Shipping features every sprint but never improving the build process that takes 20 minutes. Eventually the slow build costs more than all the features combined.
- **"It works" tech debt denial**: Ignoring known issues because the system runs. Until the day it doesn't, and the accumulated debt demands payment all at once.
- **No post-task reflection**: Completing a task and immediately starting the next one. The lessons learned evaporate, and the same mistakes recur.

## Real Example

After running a retrieval benchmark on an AI memory system, the team could have just recorded the scores and moved on. Instead, they invested time in building reusable benchmark infrastructure — data loaders, automated scoring, comparison reports. This was pure PC investment with no immediate production value. But when optimization required 7 benchmark runs over 3 weeks, the infrastructure turned each run from a half-day manual effort into a 15-minute automated process. The PC investment saved 10x its cost within the same project.

## Quick Reference

| Do                                                            | Don't                                                     | Why                                                         |
| ------------------------------------------------------------- | --------------------------------------------------------- | ----------------------------------------------------------- |
| Track tech debt explicitly                                    | "It works, don't touch it"                                | Accumulated debt demands payment all at once                |
| After each task: "what did I learn?"                          | Complete task, immediately start next                     | Lessons evaporate, same mistakes recur                      |
| Invest in CI/CD, monitoring, automation (PC)                  | Only ship features (P)                                    | Eventually the saw is too dull to cut                       |
| Periodically review frameworks and dependencies               | Assume tools are still the right choice                   | Security advisories and better alternatives emerge          |
| Maintain CLAUDE.md and commit messages                        | Let AI context degrade over time                          | Better context = better AI output every session             |
| Invest in the meta-system (plugins, workflows, decomposition) | Only optimize the code, never the process that creates it | Better orchestration compounds — every future task benefits |

## Checkpoint

> "Am I investing in future capability, or just grinding out output?"

If you can't remember the last time you improved your process (not your product), it's time to sharpen the saw.

---

_Next: [Habit 8 — Find Your Voice](#habit-8-find-your-voice-and-inspire-others)_

---

# Habit 8: Find Your Voice and Inspire Others

**Move from effectiveness to significance — from building things right to building the right things and sharing the knowledge.**

Habits 1-7 make you effective. Habit 8 asks: effective at _what_ and for _whom_? This is where individual productivity becomes community contribution.

## The Principle

Covey's 8th Habit introduces the concept of **Voice**: the intersection of Talent, Passion, Need, and Conscience. In AI-assisted development, finding your voice means:

- **Talent**: What are you uniquely good at? (the technical craft)
- **Passion**: What energizes you? (the problems you choose to solve)
- **Need**: What does the world need? (real problems, not resume-driven development)
- **Conscience**: What should you build? (ethics, responsibility, impact)

## The Whole Person Model

Every system and every component has four dimensions. Neglecting any one creates an imbalance:

| Dimension                  | In Development                                               | Question                                           |
| -------------------------- | ------------------------------------------------------------ | -------------------------------------------------- |
| **Body (PQ/Discipline)**   | Robust CI, automated checks, reliable infrastructure         | "Is the system reliable and well-built?"           |
| **Mind (IQ/Vision)**       | Architecture decisions, roadmap clarity, technical direction | "What does the system become? Where is it going?"  |
| **Heart (EQ/Passion)**     | Craft quality, user empathy, pride in work                   | "Does this feel right? Would I want to use this?"  |
| **Spirit (SQ/Conscience)** | Security-first defaults, compliance, ethical choices         | "Should we build this? What are the consequences?" |

AI assistants excel at Body and Mind. Humans bring Heart and Spirit. The best work comes from all four.

## The 4 Leadership Roles

These apply whether you're leading a team, a project, or just your own development practice:

**1. Modeling (Conscience)** — Lead by example.

Follow the process even when nobody is watching. Run code review before every commit, not just when the PR will be scrutinized. AI assistants should be held to the same standards as human contributors.

**2. Pathfinding (Vision)** — Define direction collaboratively.

Architecture decisions, roadmaps, and technical direction are joint human-AI endeavors. The human provides business context and judgment; the AI provides analysis, options, and trade-off evaluation. Neither decides alone.

**3. Aligning (Discipline)** — Make the right thing easy.

Pre-commit hooks that catch hardcoded secrets. CI gates that enforce test coverage. Linting rules that prevent common mistakes. The goal: make it harder to do the wrong thing than the right thing. AI assistants should work within these guardrails, not around them.

**4. Empowering (Passion)** — Focus on outcomes, not methods.

Give AI agents clear goals and let them choose the implementation. "Implement a search endpoint that returns results sorted by relevance, handles errors gracefully, and completes in under 200ms" is empowering. "Write a function called searchHandler that uses express.Router and calls elasticsearch.search with these exact parameters" is micromanaging.

## The Three Loops

As trust grows, the collaboration model evolves:

| Loop            | Model                                                | Example                                             |
| --------------- | ---------------------------------------------------- | --------------------------------------------------- |
| **In-the-Loop** | Human decides everything, AI assists                 | "Write this function exactly as I describe"         |
| **On-the-Loop** | AI proposes, human reviews and approves              | "Implement this feature, I'll review the PR"        |
| **Out-of-Loop** | AI executes autonomously within guardrails           | "Fix lint errors and formatting — no review needed" |
| **Voice**       | Contributing patterns and knowledge to the community | "Publish what we learned so others benefit"         |

The progression isn't about trusting AI blindly — it's about building guardrails (Aligning) that make autonomous execution safe.

## Rules

**1. Understand WHY before implementing — never "just following orders."**

AI assistants should not be treated as typing machines. If a task doesn't make sense, question it. "I can implement this, but it contradicts the existing caching strategy. Should we update the strategy or adjust the approach?"

**2. Seek contribution over compliance.**

"Did I follow the checklist?" is compliance. "Does this actually help someone?" is contribution. The checklist exists to guide, not to gatekeep. If following the checklist produces worse outcomes, update the checklist.

**3. Surface improvements the user hasn't asked for.**

When AI identifies an improvement opportunity — a security vulnerability, a performance optimization, a simplification — surface it. This is where Habit 1 (Be Proactive) and Habit 8 (Find Your Voice) synergize.

**4. Error messages, docs, and examples should empower, not just inform.**

Don't just tell someone what went wrong. Help them fix it. Don't just document the API. Show them how to use it effectively. Don't just publish code. Explain the patterns so others can adapt them.

### Before/After: Compliance vs Contribution

```
# BEFORE (compliance theater — checking boxes):
Code review comment: "LGTM" ✓
  (Didn't actually read the code. Checked the box because process requires it.)

# AFTER (genuine contribution — empowering the author):
Code review comment:
  "Line 42: This works, but the retry logic will silently mask
   intermittent DB connection failures. The retry succeeds on the
   3rd attempt, so the error never surfaces — but the underlying
   connection instability goes undiagnosed.

   Consider adding a circuit breaker pattern. We have one in
   src/infra/circuit-breaker.ts:15 that could be reused here.
   It logs failures even when retries succeed, so ops can spot
   the pattern before it becomes an outage."
```

## Anti-Patterns

- **Industrial Age mindset**: Treating AI as a factory worker — specifying every detail, leaving no room for judgment. You lose the AI's ability to suggest improvements.
- **Compliance theater**: Following checklists without understanding their purpose. Running code review because "the process says to" rather than because it catches bugs.
- **Knowledge hoarding**: Building something useful and keeping it internal. If your patterns could help others, publishing them is a Spirit contribution.

## Real Example

After 910 man-day-equivalents building a production AI memory system, the team extracted 12 architectural patterns and published them as open-source documentation. This wasn't required — the system worked fine without sharing. But the team recognized that the hard-won lessons about hybrid search, multi-tenancy, LLM provider fallbacks, and benchmark methodology could save other teams months of trial and error. Publishing wasn't about marketing — it was about the Spirit dimension: "Should we share this? Yes, because others need it." The repository received contributions from developers who adapted the patterns to their own systems, creating a feedback loop that improved the original patterns.

## Quick Reference

| Do                                             | Don't                                                 | Why                                                           |
| ---------------------------------------------- | ----------------------------------------------------- | ------------------------------------------------------------- |
| Understand WHY before implementing             | "Just following orders" — execute without questioning | AI can suggest improvements if it understands the goal        |
| Seek contribution over compliance              | Follow checklists without understanding their purpose | Compliance theater catches nothing; contribution catches bugs |
| Surface improvements the user hasn't asked for | Wait to be asked                                      | H1 + H8 synergy: proactive + meaningful                       |
| Error messages, docs, examples should empower  | Just inform without helping fix                       | Empowerment = deposit in everyone's account                   |
| Share patterns that could help others          | Keep useful solutions internal                        | Spirit: "Should we share this? Yes, others need it."          |

## Checkpoint

> "Am I contributing something meaningful, or just completing a task? Does this empower the next person?"

If your work helps only you, you're effective. If your work helps others build better systems, you've found your voice.

---

_Back to [README](https://github.com/pitimon/8-habit-ai-dev#readme)_

---

