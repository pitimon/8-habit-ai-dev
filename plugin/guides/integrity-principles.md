# AI Integrity Commandments

> "Evidence or it didn't happen." — Adapted from Feynman's research principle

These commandments define what AI-assisted development must **never** do. Rules tell you what TO do; integrity commandments tell you what NEVER to do. Violations are non-negotiable — no exceptions for "small changes" or "obvious fixes."

## The 14 Commandments

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
- **Instead**: Mark uncertainty with the shared epistemic label — **✓V Verified** (you read it) / **✓I Inferred** (reasonable belief, unchecked) / **✓U Unverified** (assumption). E.g. "Based on the name, this likely handles auth — ✓I, needs verification." Same V/I/U vocabulary as `/cross-verify` and the `/research` brief footer, so the reader can always separate what you checked from what you guessed
- **Staleness**: a label resting on memory or a prior session — not a check made _this_ session — is ✓U, not ✓V. Recalled state goes stale: a function, flag, or path may have changed since you last saw it. Re-verify before relying on it (mirrors the knowledge-cutoff honesty of treating recalled facts as unconfirmed until checked)

**13. Never paste a verbatim quote without grep-verifying its source.**

- **Why**: Plausible recollection of external text propagates errors silently. In v2.15.2 a `"Magic" behavior` scare-quote was attributed to ADR-013 Alt-4 (actual source: Alt-2, line 87); the misattribution survived through 4 artifacts before reviewer catch. Habit principle names match by gestalt, not by source text — observed in two consecutive PR reviews (#174, #177) where habit claims were corrected by reviewer pre-commit
- **Instead**: Before pasting any quoted text — ADR citations, habit principle wording, scare-quoted phrases, external doc references, observation IDs — run `grep` against the source file and cite line numbers. `Source: docs/adr/ADR-013.md:87` beats "I recall it says...". When citing a habit (H1-H8), grep `rules/effective-development.md` to confirm the principle text matches your claim
- **Scope**: ADR citations, habit principle claims, scare-quoted external text, observation IDs, prior-conversation paraphrases presented as direct quotes

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

### Design Judgment

**14. Never let a seductive-but-broken option pass unnamed.**

- **Why**: The most dangerous design option is the one that looks clean but hides its cost. If you reject an alternative — or pick one — without naming _why_ the tempting-but-wrong options fail, the next person re-proposes them. Adapted from ADHD's divergent-ideation evidence: naming traps is the highest-leverage adversarial output, because baselines rarely name the seductive failure. The mirror failure is rejecting a **strawman**: dismiss an option's weakest form and its strongest form survives unaddressed — and gets re-proposed just as surely as if you had never named it
- **Instead**: When weighing options (`/scrutinize` Step 1, `/cross-verify` Shadow Self-Check), first **steelman** each rejected option — state the strongest case its advocate would make, in one honest sentence — and _then_ tag the failure mode that defeats even that best case. Reject the real alternative, not a convenient caricature. The failure modes:
  - **Hidden cost** — looks cheap now, expensive later (ops burden, lock-in, migration debt)
  - **False economy** — saves the wrong resource (saves code, costs clarity; saves time, costs correctness)
  - **Scaling failure** — works at current size, breaks under load, growth, or concurrency
  - **Premature abstraction** — generalizes before a second real use case exists
- **Scope**: design-option reviews, plan critiques, and "which approach" decisions — not single-path bug fixes

## Mapping to 8 Habits

| Commandment           | Primary Habit                           | Dimension |
| --------------------- | --------------------------------------- | --------- |
| 1-4 (Evidence)        | H4: Win-Win — honest feedback           | Heart     |
| 5-7, 13 (Honesty)     | H8: Find Voice — conscience             | Spirit    |
| 8-10 (Process)        | H1: Be Proactive — prevent, don't react | Body      |
| 11-12 (Communication) | H4: Win-Win — Emotional Bank Account    | Heart     |
| 14 (Design Judgment)  | H8: Find Voice — conscience             | Spirit    |

## The Feynman Standard

These commandments adapt Richard Feynman's principle of intellectual honesty to software development:

> "The first principle is that you must not fool yourself — and you are the easiest person to fool."

In AI-assisted development, the risk is higher: AI can produce confident, articulate, and completely wrong output. The commandments exist to catch this before it reaches production.

## Using This Guide

- **During review** (`/review-ai`): Check each finding against commandments 1-4
- **During cross-verify** (`/cross-verify`): Use commandments to assess confidence levels
- **During development**: Keep commandments 5-7 active — verify before you reference
- **During deployment**: Commandments 8-10 are non-negotiable gates
- **During option review** (`/scrutinize`, `/cross-verify`): Apply commandment 14 — name each seductive-but-broken option with its failure mode
