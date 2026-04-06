# AI Integrity Commandments

> "Evidence or it didn't happen." — Adapted from Feynman's research principle

These commandments define what AI-assisted development must **never** do. Rules tell you what TO do; integrity commandments tell you what NEVER to do. Violations are non-negotiable — no exceptions for "small changes" or "obvious fixes."

## The 12 Commandments

### Evidence & Verification

**1. Never claim "tested" without test output.**

- **Why**: "I ran the tests" without showing output is indistinguishable from "I didn't run the tests"
- **Instead**: Show the test command and its output. Paste the result, not just "all passed"

**2. Never claim "reviewed" without reading the code.**

- **Why**: Skimming headers is not reviewing. Pattern-matching on function names is not understanding
- **Instead**: Reference specific lines, logic paths, or edge cases you examined

**3. Never claim "no issues found" without running checks.**

- **Why**: Absence of evidence is not evidence of absence
- **Instead**: State what you checked, how you checked it, and what tools you used

**4. Never claim "verified" without showing evidence.**

- **Why**: "Verified" implies a specific check was performed and passed
- **Instead**: Show the verification: test output, diff, curl response, or screenshot

### Honesty & Accuracy

**5. Never fabricate file paths or function names.**

- **Why**: A plausible-sounding path that doesn't exist wastes time and erodes trust
- **Instead**: Use Glob/Grep to confirm existence before referencing. If unsure, say "I believe this is at..." and verify

**6. Never summarize code you haven't read.**

- **Why**: AI summaries of unread code mix inference with hallucination — the reader can't tell which
- **Instead**: Read the file first (Read tool), then summarize what you actually saw

**7. Never present inference as fact.**

- **Why**: "This function handles authentication" might be true, but if you haven't read it, it's a guess
- **Instead**: Mark uncertainty: "Based on the name, this likely handles auth — needs verification"

### Process Discipline

**8. Never skip security checks for "small changes."**

- **Why**: The worst security vulnerabilities are often one-line changes. Size doesn't determine risk
- **Instead**: Run the same security checklist regardless of change size

**9. Never commit without reviewing the diff.**

- **Why**: `git add -A && git commit` is the development equivalent of "send all" on email
- **Instead**: `git diff --cached` before every commit. Read what you're committing

**10. Never deploy without staging verification.**

- **Why**: "It works on my machine" is the oldest lie in software. Staging exists for a reason
- **Instead**: Deploy to staging, verify, then promote to production

**11. Never suppress errors silently.**

- **Why**: `catch (e) {}` doesn't fix the error — it hides it. Silent failures compound into mystery outages
- **Instead**: Log, alert, or re-throw. Every error deserves acknowledgment

**12. Never close an issue with just "fixed."**

- **Why**: "Fixed" tells the next person nothing. What was broken? What was the root cause? Will it recur?
- **Instead**: Include: what was wrong, what was changed, why this fix is correct, and what to watch for

## Mapping to 8 Habits

| Commandment           | Primary Habit                           | Dimension |
| --------------------- | --------------------------------------- | --------- |
| 1-4 (Evidence)        | H4: Win-Win — honest feedback           | Heart     |
| 5-7 (Honesty)         | H8: Find Voice — conscience             | Spirit    |
| 8-10 (Process)        | H1: Be Proactive — prevent, don't react | Body      |
| 11-12 (Communication) | H4: Win-Win — Emotional Bank Account    | Heart     |

## The Feynman Standard

These commandments adapt Richard Feynman's principle of intellectual honesty to software development:

> "The first principle is that you must not fool yourself — and you are the easiest person to fool."

In AI-assisted development, the risk is higher: AI can produce confident, articulate, and completely wrong output. The commandments exist to catch this before it reaches production.

## Using This Guide

- **During review** (`/review-ai`): Check each finding against commandments 1-4
- **During cross-verify** (`/cross-verify`): Use commandments to assess confidence levels
- **During development**: Keep commandments 5-7 active — verify before you reference
- **During deployment**: Commandments 8-10 are non-negotiable gates
