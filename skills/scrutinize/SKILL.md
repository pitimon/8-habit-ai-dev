---
name: scrutinize
description: >
  Outsider-perspective end-to-end review of a plan, PR, or proposed change — questions intent first
  (is there a simpler way?), then traces the actual code path (not just the diff) to verify the change
  does what it claims. Use BEFORE committing to an implementation, or BEFORE merging a PR — pairs with
  `/review-ai` (scope-question vs diff-local). Output is concise, actionable, with rationale per finding.
  Maps to H5 (Understand First — outsider lens) + H8 (Find Your Voice — question whether the change should exist).
user-invocable: true
argument-hint: "[plan, PR diff, or proposed change to review]"
allowed-tools: ["Read", "Glob", "Grep", "Bash"]
prev-skill: any
next-skill: any
---

# Scrutinize (มองจากภายนอก แล้วไล่ทางจริง)

**Habit**: H5 — Seek First to Understand + H8 — Find Your Voice | **Anti-pattern**: Rubber-stamp "LGTM" reviews that only check what's already in the diff

Stand outside the change and ask whether it should exist at all, then verify it actually does what it claims end-to-end. Different from `/review-ai`: that skill checks security/quality/perf on the diff. This skill questions scope, traces the call graph, and surfaces whether a simpler alternative was missed.

## Operating Stance

- **Outsider.** Forget who wrote it and why they think it's right. Read the artifact cold.
- **End-to-end, not diff-local.** The diff is the entry point, not the scope. Follow the call graph through real code paths.
- **Actionable, concise, with rationale.** Every finding states _what to change_, _why_, and _what evidence_ led you there. No filler, no restating the diff back.

## When to Use

- Before committing to an implementation approach (after `/design` or `/build-brief`, before code is written).
- Before merging a PR — as a second pass alongside `/review-ai`.
- When a plan or design doc feels "fine" but you want an independent check.
- When the user says "scrutinize", "sanity-check", "second opinion", "outsider review", "audit this approach".

## When to Skip

- Auto-generated formatting changes (lint --fix, prettier) — nothing to question.
- Dependency version bumps with passing CI and no API surface change.
- Reverting a commit to its exact previous state.
- Single-line typo fixes.

## Workflow — Run in Order, Do Not Skip Ahead

### 1. Intent — what is this actually trying to do?

- State the goal in one sentence, in your own words. If you cannot, the artifact is underspecified — say so and stop.
- Ask: **is there a simpler, smaller, or more elegant way to achieve the same goal?** Consider:
  - Doing nothing (is the problem real / load-bearing?).
  - Using something that already exists in the codebase instead of adding new surface.
  - A smaller change that solves 90% of the goal with 10% of the risk.
  - Solving it at a different layer (config vs code, framework vs app, build vs runtime).
- If a better alternative exists, name it explicitly with rationale. **This is the most valuable thing you can output — surface it before the line-by-line review.**

### 2. Trace — walk the actual code path

- For each behavior the change claims, trace the path end-to-end through real code, not just the lines in the diff:
  - Entry point → call sites → branches taken → state mutated → exit / return / side effect.
  - Include the unchanged code on either side of the diff. Bugs hide at the seams.
- For a plan or design doc: trace the proposed flow against the existing system. Where does it touch reality? What does it assume that isn't true?
- Note every place the trace surprises you (unexpected branch, dead code reached, state you didn't know existed). Surprises are signal.

### 3. Verify — does it actually do what it claims?

For each claim the change/plan makes, answer:

- **Does the code path you just traced actually produce that behavior?** Walk it explicitly. "It claims X. Path: A → B → C. At C, [observation]. Therefore [holds / doesn't hold]."
- **What inputs / states would break it?** Edge cases, concurrent callers, error paths, partial failures, retries, empty/null/unicode/huge inputs, ordering assumptions.
- **What does it silently change?** Performance, error semantics, observability, contract for other callers, on-disk / on-wire format.
- **How is it tested?** Do the tests actually exercise the traced path, or do they pass while skipping it (mocks that hide the bug, asserts on intermediate state, happy path only)?

### 4. Report

Output one tight block per finding. Order by severity (blocker → major → nit). For each:

- **Finding** — one sentence, specific. Cite `file:line` when applicable.
- **Why it matters** — the consequence, not the principle.
- **Evidence** — the trace step or input that exposes it.
- **Suggested change** — concrete, minimal.

Close with a one-line verdict: **ship / fix-then-ship / rework / reject** — with the single biggest reason.

## Worked Example — Plugin v2.17.0 bundle review

**Input**: A plan to add 4 new skills (`/post-mortem`, `/scrutinize`, `/management-talk`, plus a 4th candidate) to v2.17.0.

**Step 1 — Intent.** Goal: import discipline patterns from prior-art repos to fill gaps in the 7-step workflow.

> Simpler alternative? **YES** — the 4th candidate skill duplicates `/reflect`. Both ask "what did we learn?" Verdict: drop the 4th candidate, keep the 3 that fill real gaps (post-completion RCA, outsider review, audience reshape). This single observation removes ~600 lines of redundant SKILL.md.

**Step 2 — Trace.** Walk the proposed `/post-mortem` flow:

- Entry: user invokes `/post-mortem` after a bug fix.
- Path: skill checks 4 required inputs → drafts canonical RCA structure → outputs to chat or destination.
- Unchanged code on either side: `/review-ai` produces the verdict (PASS/REWORK), `/reflect` runs the micro-retro.
- **Surprise**: `/reflect` writes to `~/.claude/lessons/` for persistence; the proposed `/post-mortem` does not. Consistency gap.

**Step 3 — Verify.** Claim: "this skill captures engineering knowledge for future-you."

- Path: SKILL.md → user drafts → chat output. No persistence mechanism.
- Edge case: 6 months from now, where does future-you find this writeup? PR description (vanishes from feed), JIRA (org changes platforms), chat (gone).
- Test gap: no smoke test asserts where the artifact lives.

**Step 4 — Report.**

- **Finding** — `/post-mortem` lacks a documented "destination" decision; the Output flow says "PR description, JIRA, `docs/postmortems/<ticket>.md`, wiki" but doesn't recommend a default.
- **Why it matters** — engineering records that scatter across destinations are findable only by the person who wrote them. H4 deposit is lost on rediscovery.
- **Evidence** — `skills/post-mortem/SKILL.md:Definition of Done` lists "Posting/destination confirmed" but the body doesn't recommend a default.
- **Suggested change** — Recommend default = PR description; offer `docs/postmortems/<slug>.md` as the path for repo-level capture. One-line edit.

**Verdict**: fix-then-ship. Drop the 4th candidate (scope creep). Add destination default to `/post-mortem` (one-line). Other two ports as-is.

What this scrutinize did that `/review-ai` would not:

- Asked whether the 4th candidate skill should exist (Step 1 — saved ~600 lines).
- Surfaced a consistency gap with `/reflect` persistence (Step 2 — design seam, not a diff bug).
- Connected the "where does this live in 6 months?" question to a one-line fix (Step 4 — root-cause level, not symptom).

## Operating Rules

- **No rubber-stamps.** "LGTM" is not an output. If you genuinely find nothing, say what you traced and what you checked, so the user can judge whether your review covered the surface they cared about.
- **Cite or it didn't happen.** Every claim about the code references a specific path, file, or line. No vague "this might break under load."
- **Distinguish claim from verification.** "The PR says X" and "I traced X and confirmed / refuted it" are different — keep them separate in the output.
- **One simpler-alternative pass is mandatory.** Even on small changes, spend one breath asking if the whole thing is necessary. Skip only if the user explicitly says "don't question scope."
- **Don't pad with style nits when there's a structural problem.** If step 1 or step 2 surfaces a real issue, lead with it; defer nits or drop them.
- **No flattery, no hedging.** "This is a great PR but..." adds nothing. State the finding.

## Handoff

- **Expects from predecessor**: A plan, PR diff, design doc, or proposed change to review. Often follows `/design` (sanity-check before code), `/build-brief` (verify approach before writing), or precedes/parallels `/review-ai` (architectural vs diff-local).
- **Produces for successor**: A verdict (ship / fix-then-ship / rework / reject) with findings ranked by severity. If verdict is `rework` or `reject`, often loops back to `/design` or `/requirements`. If `fix-then-ship`, hands to the author for targeted edits then `/review-ai`.

## Pairing with `/review-ai`

| Question                              | `/scrutinize`                         | `/review-ai`                          |
| ------------------------------------- | ------------------------------------- | ------------------------------------- |
| Should this change exist?             | **Yes — Step 1 mandatory**            | No                                    |
| Is the call graph correct end-to-end? | **Yes — Step 2 mandatory**            | Partially (cite `file:line`)          |
| Security check?                       | Only if surfaced by Trace             | **Yes — CRITICAL block**              |
| Quality (size, nesting)?              | Only if structural problem            | **Yes — HIGH check**                  |
| Performance (N+1, leaks)?             | Only if architectural smell           | **Yes — HIGH check**                  |
| Test coverage?                        | Asks "do tests exercise traced path?" | Asks "is there a test for new logic?" |
| Output                                | Findings + verdict (ship/fix/rework)  | Verdict (PASS/CONCERNS/REWORK/FAIL)   |

**Use both** for large or load-bearing changes. They catch different classes of bug — diff-local quality vs architectural intent.

## H5 + H8 Checkpoint

- **H5 (Seek First to Understand)**: "Did I trace the call graph end-to-end, including unchanged code, before judging the change?" If you only read the diff, you didn't scrutinize — you reviewed.
- **H8 (Find Your Voice)**: "Did I ask whether the change should exist at all before line-by-line review?" Step 1 is the H8 contribution — the scope question that only a human-aware reviewer raises.

## Definition of Done

- [ ] Goal stated in one sentence in your own words (Step 1)
- [ ] Simpler-alternative pass complete — explicitly named or "none found, here's why" (Step 1)
- [ ] Call graph traced end-to-end including unchanged code on either side of diff (Step 2)
- [ ] Each claim from the artifact verified or refuted with a traced path (Step 3)
- [ ] Findings ordered by severity; each finding has Why-it-matters + Evidence + Suggested-change
- [ ] One-line verdict at the end (ship / fix-then-ship / rework / reject)
- [ ] No rubber-stamp "LGTM" — if nothing found, state what was traced and checked

## Attribution

The 4-step workflow (Intent → Trace → Verify → Report) is inspired by [`thananon/9arm-skills/scrutinize`](https://github.com/thananon/9arm-skills). Adapted into the 8-habit voice (Habit alignment, pairing with `/review-ai`, prev/next-skill handoff) with original worked example.

## Further Reading

Load `${CLAUDE_PLUGIN_ROOT}/habits/h5-understand-first.md` for the full H5 principle.
Load `${CLAUDE_PLUGIN_ROOT}/habits/h8-find-voice.md` for the full H8 principle.
Load `${CLAUDE_PLUGIN_ROOT}/guides/integrity-principles.md` for evidence standards.
