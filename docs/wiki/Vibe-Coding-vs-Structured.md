# Vibe Coding vs Structured Development

> _"ทำเสร็จ ≠ ทำดี"_ — _Done_ is not _Done well_.

**Vibe coding** is the default failure mode of AI-assisted development: ad-hoc prompts, no requirements, no review, no rollback plan. It feels fast. It generates tech debt faster than any human ever could.

**Structured development** is the 7-step workflow in this plugin. It feels slightly slower at the start and dramatically faster by week 3.

## Side-by-side

| Phase                  | Vibe Coding                    | Structured (this plugin)                           |
| ---------------------- | ------------------------------ | -------------------------------------------------- |
| **Problem**            | "Hey Claude, build me X"       | `/research` → `/requirements`                      |
| **Architecture**       | Claude picks whatever's trendy | `/design` — human decides from options             |
| **Task decomposition** | One giant prompt               | `/breakdown` — atomic tasks, Q2 prioritized        |
| **Before coding**      | Straight to code generation    | `/build-brief` — read existing code first          |
| **Review**             | "Looks good, commit it"        | `/review-ai` + `/security-check` + `/cross-verify` |
| **Deploy**             | Push to prod directly          | `/deploy-guide` — staging first, rollback ready    |
| **After deploy**       | Forget about it                | `/monitor-setup` — observe and learn               |
| **Reflection**         | None                           | `/reflect` — capture lessons                       |

## What vibe coding costs you

> [!CAUTION]
> These are not hypothetical. Every item below has been observed in production AI-generated codebases.

- **Hallucinated APIs** shipped to production
- **Missing error handling** that surfaces during the first outage
- **Scope creep** — features nobody asked for
- **Architecture drift** — every feature picks its own pattern
- **No rollback plan** — 2 a.m. incidents become catastrophes
- **No shared understanding** — the next developer (or future-you) has no idea why
- **Invisible tech debt** — accumulating silently until the codebase is unmaintainable

## What structured costs you

- **~10 extra minutes** on small features, ~1 hour on larger ones
- **Discipline** — you have to actually run the steps
- **Human judgment** — you cannot delegate architecture

## Break-even

For a small feature: structured is break-even by the time of the first bug report. For a medium feature: by the first code review. For a large feature: before the first commit.

## The deeper point

Vibe coding optimizes for **production output** — lines of code shipped today. Structured development optimizes for **production capability** — the ability to keep shipping reliably for months. Covey calls this **P/PC balance** (Habit 7, Sharpen the Saw). Ignore PC and the P eventually collapses.

## When vibe coding is actually fine

- Throwaway scripts with lifespan < 1 day
- Personal experiments you will never deploy
- Learning exercises where the output is irrelevant

Everything else should be structured.

## See also

- **[Workflow Overview](Workflow-Overview)**
- **[Getting Started](Getting-Started)**
- **[Habits Reference → H7 Sharpen the Saw](Habits-Reference#habit-7-sharpen-the-saw)**
- **[FAQ](FAQ)**
