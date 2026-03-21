# Cross-Verification Checklist

**17 questions across 8 habits to verify your plan before execution.**

Use this after planning and before committing to implementation. It's not a gate for every commit — it's a sanity check for any task that touches 3+ files or takes more than an hour.

## When to Use This

- After writing a plan, before starting implementation
- Before creating a PR for a multi-file change
- During sprint planning, to evaluate task readiness
- When something feels off but you can't pinpoint why

## When to Skip

- Single-line bug fixes with obvious root cause
- Formatting or linting changes
- Dependency version bumps with passing CI
- Documentation typo fixes

## The Checklist

### Private Victory (Self-Management)

| #   | Habit            | Question                                                                                  | Pass? |
| --- | ---------------- | ----------------------------------------------------------------------------------------- | ----- |
| 1   | H1: Be Proactive | Have I checked what else this change affects beyond the immediate scope?                  |       |
| 2   | H1: Be Proactive | Have I considered edge cases: null input, missing files, permission errors, corrupt data? |       |
| 3   | H1: Be Proactive | Will documentation be updated as part of this change, not after?                          |       |
| 4   | H2: End in Mind  | Do I have 3-5 concrete, verifiable success criteria?                                      |       |
| 5   | H2: End in Mind  | Does the PR template include a test plan with specific verification steps?                |       |
| 6   | H2: End in Mind  | Do commit messages explain WHY, not just WHAT?                                            |       |
| 7   | H3: First Things | Am I working on the most important thing, or the most interesting thing?                  |       |
| 8   | H3: First Things | Have I resisted scope creep — only what's needed, nothing extra?                          |       |

### Public Victory (Collaboration)

| #   | Habit          | Question                                                                    | Pass? |
| --- | -------------- | --------------------------------------------------------------------------- | ----- |
| 9   | H4: Win-Win    | Will issue closures include rationale, not just "fixed"?                    |       |
| 10  | H4: Win-Win    | Do error messages help the next developer understand AND fix the problem?   |       |
| 11  | H5: Understand | Have I read the existing code in the affected area before writing new code? |       |
| 12  | H5: Understand | If fixing a bug, have I reproduced it first?                                |       |
| 13  | H6: Synergize  | Are independent tasks running in parallel instead of sequentially?          |       |
| 14  | H6: Synergize  | Have I considered a third alternative beyond the obvious options?           |       |

### Renewal & Significance

| #   | Habit           | Question                                                                | Pass? |
| --- | --------------- | ----------------------------------------------------------------------- | ----- |
| 15  | H7: Sharpen Saw | After this task, will I capture what I learned (script, doc, or issue)? |       |
| 16  | H8: Voice       | Do I understand WHY this task matters, not just WHAT needs to be done?  |       |
| 17  | H8: Voice       | Does this work empower the next person who touches this code?           |       |

## How to Use It

**Step 1: Copy the table into your plan or PR description.**

Not all 17 questions apply to every task. Mark irrelevant ones as "N/A" — but be honest about what's truly irrelevant versus what's inconvenient.

**Step 2: Answer each question with a brief note.**

Don't just check "Pass" — write a one-line answer. This forces you to actually think about each question instead of reflexively checking boxes.

```markdown
| 4 | H2: End in Mind | Concrete success criteria? | Yes: API returns 200 with sorted results, 400 on empty query, 401 without auth |
```

**Step 3: Address any "Fail" items before proceeding.**

A single "Fail" on H1-H3 (Private Victory) means you're not ready to implement. A "Fail" on H4-H6 (Public Victory) means the implementation might work but won't serve the team well.

**Step 4: Review the completed checklist with fresh eyes.**

If you can read through all 17 answers and feel confident, proceed. If any answer feels forced or uncertain, dig deeper on that point.

## Scoring Guide

| Score      | Meaning          | Action                               |
| ---------- | ---------------- | ------------------------------------ |
| 15-17 Pass | Well-prepared    | Proceed with confidence              |
| 12-14 Pass | Mostly ready     | Address gaps, then proceed           |
| 8-11 Pass  | Significant gaps | Revisit the plan before implementing |
| < 8 Pass   | Not ready        | Stop and rethink the approach        |

## Common Failure Patterns

- **Questions 1-3 fail together**: You're being reactive, not proactive. Step back and think about impact.
- **Questions 4-6 fail together**: You haven't defined what success looks like. Write criteria first.
- **Questions 11-12 fail together**: You're jumping to solutions. Read the code and reproduce the problem.
- **Question 13 always "N/A"**: You might be underutilizing parallelization. Look for independent subtasks.

---

_Back to [README](../README.md)_
