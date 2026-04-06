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

_Next: [Habit 5 — Seek First to Understand](h5-understand-first.md)_
