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

## Anti-Patterns

- **Gold-plating**: Adding features nobody asked for because the AI makes it easy. "Let me also add pagination, sorting, and full-text search" when the ticket says "add a list endpoint." Ship the requirement, then enhance.
- **"Just this once" skipping**: Skipping tests "because this change is trivial." Trivial changes break production more often than complex ones — precisely because nobody reviews them carefully.
- **Context-switching**: Jumping between 3 features in one session. Each switch costs re-reading context, losing state, and introducing inconsistencies. AI assistants lose context too.

## Real Example

When implementing a benchmark evaluation for an AI memory system, the team faced a choice: spend time building proper benchmark infrastructure (test harness, data loading, scoring pipeline) or manually run a few queries and eyeball the results. They chose the infrastructure — a Q2 investment that felt slow at first. But when the benchmark needed to run 7 times over 3 weeks of optimization, the infrastructure paid for itself many times over. Teams that skip Q2 would have spent hours on each manual run, or worse, drawn wrong conclusions from inconsistent manual testing.

## Checkpoint

> "Am I doing what's important, or what's urgent? Will this prevent future problems?"

If you're firefighting the same issues repeatedly, you're stuck in Q1. Step back and invest in Q2.

---

_Next: [Habit 4 — Think Win-Win](h4-win-win.md)_
