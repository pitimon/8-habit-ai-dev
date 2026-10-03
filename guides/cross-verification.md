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

| Score      | Adjusted % | Meaning          | Action                               |
| ---------- | ---------- | ---------------- | ------------------------------------ |
| 15-17 Pass | ≥88%       | Well-prepared    | Proceed with confidence              |
| 12-14 Pass | ≥70%       | Mostly ready     | Address gaps, then proceed           |
| 8-11 Pass  | ≥47%       | Significant gaps | Revisit the plan before implementing |
| < 8 Pass   | <47%       | Not ready        | Stop and rethink the approach        |

Use the adjusted percentage (PASS / (total − N/A)) when some items are N/A; bands are half-open, so 87.5% (14/16) is Mostly ready and 69.2% (9/13) is Significant gaps. The score measures **process completeness** — whether the right questions were asked and answered. It is not evidence that the conclusions are right or that the changed behavior works. A high score with an unverified core claim is still `hold: verify core claim` (see below).

## Core-Claim Verification

A core claim is what the change is supposed to make true: "the allowlist lets the child stage a skill", "the root cause is the bind mount", "reflection never ran". Name them in every review, each as `claim — evidence source — independent? Y/N`. Checking the 17 questions by category is not enough: a review can flag Q12 "single source" and still miss the one unsupported claim in front of it.

Which claims must be listed — the reviewer does not get to pick only the safe ones:

- the claim the change exists to make true (the headline conclusion of a diagnosis; the main behavior of a patch);
- every claim that crosses an integration boundary (below);
- every absence claim ("X did not happen").

If more than three qualify, list them all.

If a core claim presented as established — built, diagnosed, or observed — is `FAIL` or `OPEN_VERIFICATION_DEBT`, a `proceed` or `address gaps` recommendation becomes `hold: verify core claim`. Lower bands keep their own recommendation (`revisit plan`, `stop and rethink`) and list the claim as blocking. The score and band are computed unchanged; the hold sits beside them, not inside them. In a production review the same claim also sets the Release verdict to `HOLD` (see [`production-release-gates.md`](./production-release-gates.md)). The hold lifts when the claim is re-graded `PASS` on new evidence; the band's own recommendation then applies.

In a pre-implementation plan review, core claims about what will be built are intentions that cannot be verified yet. That is expected, not a hold: write each one into the test plan (Q5) with the check that will verify it — for integration claims, the real-host probe and its control case. This carve-out covers only unbuilt behavior. A diagnosis or observation the plan rests on ("the root cause is X", "the feature is unused") is established, and the hold applies to it.

**Integration boundaries need the real host.** When the change crosses a host boundary — permissions or allowlists, hooks, host↔plugin contracts, CLI flags — a core claim counts as `PASS` only after the changed behavior was exercised on the real host, together with a control case (for example, child session vs main session). Unit tests over a mocked host cannot see host behavior such as deferred tool schemas; with mocks alone, record the claim as `OPEN_VERIFICATION_DEBT`. Independent corroboration: the statewright guardrail project exempts `ToolSearch` from its own tool allowlist hooks (`plugins/claude-code/hook.sh`, `plugins/omx/src/hook.ts` at commit `2426f75`) — consistent with the host behavior that unit-tested allowlists missed in [#399](https://github.com/pitimon/8-habit-ai-dev/issues/399). For production work, use the runtime reconciliation in [`production-release-gates.md`](./production-release-gates.md) instead of restating it here.

**Absence claims: find the writer.** Before concluding "X did not happen because artifact Y is missing", find the writer: cite the code line that writes Y and confirm it executes on that path. An artifact that is only written on some paths (for example, only when a run produces output) says nothing about the other paths. Without the writer line, the conclusion is `OPEN_VERIFICATION_DEBT`. See "absence of evidence is not evidence of absence" in [`integrity-principles.md`](./integrity-principles.md).

**Ask the discriminating question.** For each core claim: "If this claim were false, would my evidence look different?" If the answer is "no", the evidence carries no information about the claim, so the claim is `OPEN_VERIFICATION_DEBT`, not `PASS` — however confident it feels. And: "Which of my conclusions has only been checked by me, with my own evidence?" Those claims are candidates for an independent pass — a cross-vendor challenge, a reviewer agent, or live execution. Author-side checks, including this checklist, share the author's evidence and cannot diverge from it ([`independent-source-verification.md`](./independent-source-verification.md)).

## PRO-READY Mapping

PRO-READY is a community checklist, not doctrine: its origin is unverified. It is mapped here so that a "pro-ready" request routes to existing skills (see [`skills/RESOLVER.md`](../skills/RESOLVER.md) § Composite Triggers) instead of a new checklist.

| Letter | Asks | Covered by |
| --- | --- | --- |
| P — Purpose | Does it meet the requirement? | `/requirements` success criteria; Q4 |
| R — Reliability | Are APIs and dependencies trustworthy? | `/security-check` dependencies; core-claim real-host rule above |
| O — Organizational context | Does it fit the system and security model? | `/build-brief`, `/design` context contract, `/security-check` |
| R — Reasoning | Can design and trade-offs be explained? | `/design` options and steelman; Q14, Q16 |
| E — Execution | Test, rollout, rollback? | Q5; `/deploy-guide` rollback plan |
| A — Accuracy | Build, test, security check pass? | `/review-ai`, `/security-check`; core claims above |
| D — Delivery quality | Code, PR, docs ready to hand off? | `/review-ai` completeness; Q3, Q9, Q17 |
| Y — You Own It | Does the merger understand and own it? | `/review-ai` step 7 ownership question and Owner note |

## Common Failure Patterns

- **Questions 1-3 fail together**: You're being reactive, not proactive. Step back and think about impact.
- **Questions 4-6 fail together**: You haven't defined what success looks like. Write criteria first.
- **Questions 11-12 fail together**: You're jumping to solutions. Read the code and reproduce the problem.
- **Question 13 always "N/A"**: You might be underutilizing parallelization. Look for independent subtasks.

---

_Back to [README](../README.md)_
