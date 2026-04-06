---
name: cross-verify
description: >
  Run 17-question 8-Habit cross-verification checklist on a plan or implementation.
  Use AFTER planning and BEFORE committing to implementation. Maps to ALL 8 Habits.
user-invocable: true
argument-hint: "[plan or feature to verify]"
allowed-tools: ["Read", "Glob", "Grep"]
---

# Cross-Verify (8-Habit Checklist)

**All Habits** | **Anti-pattern**: Shipping without reflecting on quality from multiple perspectives

## When to Use

- After writing a plan, before starting implementation
- Before creating a PR for a multi-file change
- When something feels off but you can't pinpoint why

## When to Skip

- Single-line bug fixes with obvious root cause
- Formatting or linting changes
- Dependency version bumps with passing CI

## Process

Run through this checklist. Flag any item that fails.

### Private Victory (Self-Management)

| #   | Habit            | Question                                                                    |
| --- | ---------------- | --------------------------------------------------------------------------- |
| 1   | H1: Be Proactive | Have I checked what else this change affects beyond the immediate scope?    |
| 2   | H1: Be Proactive | Have I considered edge cases: null input, missing files, permission errors? |
| 3   | H1: Be Proactive | Will documentation be updated as part of this change, not after?            |
| 4   | H2: End in Mind  | Do I have 3-5 concrete, verifiable success criteria?                        |
| 5   | H2: End in Mind  | Does the PR include a test plan with specific verification steps?           |
| 6   | H2: End in Mind  | Do commit messages explain WHY, not just WHAT?                              |
| 7   | H3: First Things | Am I working on the most important thing, or the most interesting thing?    |
| 8   | H3: First Things | Have I resisted scope creep — only what's needed, nothing extra?            |

### Public Victory (Collaboration)

| #   | Habit          | Question                                                                    |
| --- | -------------- | --------------------------------------------------------------------------- |
| 9   | H4: Win-Win    | Will issue closures include rationale, not just "fixed"?                    |
| 10  | H4: Win-Win    | Do error messages help the next developer understand AND fix the problem?   |
| 11  | H5: Understand | Have I read the existing code in the affected area before writing new code? |
| 12  | H5: Understand | If fixing a bug, have I reproduced it first?                                |
| 13  | H6: Synergize  | Are independent tasks running in parallel instead of sequentially?          |
| 14  | H6: Synergize  | Have I considered a third alternative beyond the obvious options?           |

### Renewal & Significance

| #   | Habit           | Question                                                                |
| --- | --------------- | ----------------------------------------------------------------------- |
| 15  | H7: Sharpen Saw | After this task, will I capture what I learned (script, doc, or issue)? |
| 16  | H8: Voice       | Do I understand WHY this task matters, not just WHAT needs to be done?  |
| 17  | H8: Voice       | Does this work empower the next person who touches this code?           |

## Output

```
## Cross-Verification Report
**Feature**: [name]
**Score**: [X]/17 (N/A excluded: [Y]/[Z] applicable = [%])
**Band**: [see table below]
**Failed**: [list failed items with 1-line explanation each]
**Recommendation**: [proceed / address gaps / revisit plan / stop and rethink]
```

### Scoring Bands

| Score | Band             | Action                               |
| ----- | ---------------- | ------------------------------------ |
| 15-17 | Well-prepared    | Proceed with confidence              |
| 12-14 | Mostly ready     | Address gaps, then proceed           |
| 8-11  | Significant gaps | Revisit the plan before implementing |
| < 8   | Not ready        | Stop and rethink the approach        |

When calculating adjusted score, exclude N/A items from both numerator and denominator. Use the adjusted percentage to determine the band.

### Common Failure Patterns

- **Q1-3 fail together**: Being reactive, not proactive — step back and think about impact
- **Q4-6 fail together**: Haven't defined success — write criteria first
- **Q11-12 fail together**: Jumping to solutions — read the code and reproduce the problem
- **Q13 always N/A**: May be underutilizing parallelization

Load `${CLAUDE_PLUGIN_ROOT}/guides/cross-verification.md` for detailed guidance on each question.
