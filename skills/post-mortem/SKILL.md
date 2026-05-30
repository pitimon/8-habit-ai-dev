---
name: post-mortem
description: >
  Canonical engineering record of a fixed bug — root cause, mechanism, fix, validation, and how it slipped through.
  Use AFTER a debug session lands a validated fix, BEFORE closing the ticket — produces an engineer-audience artifact.
  Refuses to draft without a reliable repro, known root cause, identified fix, and validated outcome.
  Maps to H4 (Win-Win — engineer-to-engineer deposit) + H7 (Sharpen the Saw — capture learning for future-you).
user-invocable: true
argument-hint: "[bug identifier or 'last task']"
allowed-tools: ["Read", "Glob", "Grep", "Bash"]
prev-skill: any
next-skill: any
---

# Post-mortem (ชันสูตรบั๊กหลังแก้)

**Habit**: H4 — Think Win-Win + H7 — Sharpen the Saw | **Anti-pattern**: Closing a fix with "Fixed in PR #N" and walking away

Canonical engineering record of a bug fix. Written **after** debugging lands a validated fix, **for** other engineers (and future-you, who will have forgotten everything in 6 months). Code identifiers are first-class here — this is the artifact that lets the next person grep back to the cause in seconds, not hours.

## When to Use

- After a debug session has clearly landed a fix and the fix is validated.
- `/post-mortem` invoked explicitly.
- User says "write the post-mortem / postmortem / RCA / root-cause analysis", "document this fix", "close out this bug with a writeup".
- Pair with `/reflect` for a complete loop: `/reflect` captures the lightweight retrospective signal; `/post-mortem` captures the engineering record. They serve different audiences.

## When to Skip

- **Bug not fixed yet, or fix not validated.** A post-mortem of a hypothesis is misleading. Refuse and tell the user what's missing.
- **Customer-visible outage / incident.** Those need a separate incident report (timeline, blast radius, comms). This skill is bug-fix scope. Flag and confirm before producing one.
- **Trivial fix** (typo, obvious one-liner). The PR description is the record. Don't manufacture ceremony.
- **Auto-generated changes** (lint --fix, dependency bumps with no behavior change). Nothing to walk through.

## Required Inputs — Refuse to Draft Without These

Before writing a single line, confirm all four. If any are missing, list what's missing and stop:

- [ ] **Reliable repro** — a deterministic or high-rate-flake repro the next person can run. "Happens sometimes" is not enough.
- [ ] **Root cause is known** — the bug mechanism is identified, not a hypothesis.
- [ ] **Fix is identified** — PR / commit / branch pointer exists.
- [ ] **Fix is validated** — the original repro now passes; the failing test / customer workload / scan now succeeds.

These map to the H1 (Be Proactive) checkpoints: a fix without these inputs is just a guess in a green CI badge.

## Structure

Use these blocks in this order. **Summary, Root cause, Fix, and Validation are mandatory.** Other blocks are conditional but usually present.

### 1. Summary _(mandatory)_

One paragraph. What broke in user/workload terms. What fixed it in one sentence. Ticket key, PR number, owner. A reader who stops here should already have the right answer.

### 2. Symptom

What was actually observed — test output, error message, log line, performance number, customer report. Concrete identifiers, no paraphrasing.

### 3. Root cause _(mandatory)_

The actual bug mechanism. **Code identifiers welcome and expected** — function names, file paths, struct fields, branch conditions, commit SHAs of the offending change. Walk the cause chain end-to-end. This is the most expensive section and the reason the post-mortem exists at all.

### 4. Why it produced the symptom

Link the root cause to the symptom. Often non-obvious — the bug is in function `X` but the visible failure is two layers downstream. Walk the chain so a reader who only knows the symptom can connect it back to the cause without re-deriving it.

### 5. Fix _(mandatory)_

What changed and **why this change addresses the root cause** rather than hiding the symptom. Link to PR / commit. If a previous attempt papered over the symptom, name it and explain what was wrong with it — that history is part of the cause.

### 6. How it was found

Short. The debugging path:

- What repro made it deterministic.
- What tools cracked it (debugger, source tracing, in-code instrumentation).
- Hypotheses tried and rejected, with the one-line reason each was rejected.
- The single experiment that confirmed the cause.

This section is for the next debugger — make it learnable.

### 7. Why it slipped through

What allowed this bug to reach the branch / release / customer. Pick the real reason:

- CI gap (no test exercises this path / configuration).
- Latent code (correct when written, broken by a later change in a different file).
- Workload gap (no real input reached this code path until now).
- Incomplete prior fix, or **overturned** root cause (defensive check hid the symptom; or the **earlier** diagnosis was **wrong**, later reversed).
- Review miss (the change was reviewable; the implication wasn't).

If the honest answer is "no good reason — we should have caught this," say so. **Blameless** — describe the gap, not the person.

### 8. Validation _(mandatory)_

How we know the fix works. Concrete:

- Original failing test now passes (test name, link).
- Workload now completes (workload identifier, run link).
- Perf regression resolved (number before, number after).
- Stress / soak / fuzz run completed clean (duration, scale).

If you only validated one configuration, **say so explicitly** — _"validated on macOS bash 5.2; not retested on Linux or zsh."_ Implying broader coverage than you actually have is the failure mode that breeds repeat regressions. See `rules/coding-style.md` "False Success Report" anti-pattern.

### 9. Action items / follow-ups

Concrete next-steps that aren't in the fix PR itself. Each item: what + owner + tracking artifact.

- Regression test added at `<seam>`. (Owner, test name.)
- CI gap closed: `<new check>`. (Owner, PR.)
- Related ticket filed for `<adjacent issue you noticed>`. (Owner, key.)
- Lesson saved to `~/.claude/lessons/YYYY-MM-DD-<slug>.md` (via `/reflect` step).

If there are no action items, write _"None — the fix is sufficient and no class-of-bug follow-up is warranted."_ Don't manufacture action items to look thorough.

## Worked example — Hook false-pass bug

> **Summary.** The plugin's `session-start.sh` hook was reporting `status: ready` even when the verbosity-adaptation block failed to load, masking a missing `~/.claude/habit-profile.md` for every user without a calibration profile. Triggered for any new install. Fixed by removing the `|| true` suppression and adding an explicit fallback path. Issue #92, PR #95, owner @pitimon.
>
> **Symptom.** Users on fresh installs reported that `/calibrate` ran but subsequent `/research` calls didn't adapt verbosity. Reproduced on every clean home directory. Hook output showed `status: ready` — no error surfaced.
>
> **Root cause.** `hooks/session-start.sh:42` wrapped the `cat ~/.claude/habit-profile.md` call in `|| true`. When the file was absent (typical first-run state), `cat` exited 1, `|| true` swallowed it, and the script continued to print `status: ready`. The verbosity directive that should have been injected was simply missing from the hook output, but the hook reported success. This is the canonical "False Success Report" anti-pattern from `rules/coding-style.md`.
>
> **Why it produced the symptom.** Skills downstream of the hook (e.g. `/research`) read the injected verbosity directive at session start. With no directive present, they defaulted to Dependence-level verbosity — full ceremony, even for Significance-profile users. The user saw verbose output that didn't match their calibration, but no error pointed back to the hook.
>
> **Fix.** PR #95 replaces `cat ... || true` with a explicit `if [ -f ~/.claude/habit-profile.md ]; then ... else emit default Independence directive; fi`. The fallback directive is now part of the contract — never silent. A prior attempt (PR #88) added a comment warning "do not let this fail silently," which obviously didn't prevent the silent failure — that warning is now a `set -e` check instead.
>
> **How it was found.** A user on Significance profile reported `/research` was emitting full-template output on a clean machine. Initial hypothesis: skill regression in `/research` v2.16.3. Disproved by running the skill with a populated profile — output adapted correctly. Second hypothesis: hook not running. Disproved by adding `[DBG-9a4f]` trace to the hook — it ran, but the verbosity block was empty. Single experiment that nailed it: `bash -x hooks/session-start.sh` on a clean home → `cat` exited 1, `|| true` returned 0, the next line ran unconditionally.
>
> **Why it slipped through.** CI gap. `tests/test-verbosity-hook.sh` had 8 branches but all 8 assumed a profile file existed. The empty-profile case was never exercised. Latent since v2.7.0 (when the verbosity-adaptation feature shipped) — every first-time user hit it silently.
>
> **Validation.** Fresh clone, no `~/.claude/habit-profile.md`, `bash hooks/session-start.sh` now emits the default Independence directive. `tests/test-verbosity-hook.sh` extended with `test_empty_profile_falls_back_to_default` — passes. Verbosity directive observable in `/research` output on clean machine. Not retested on Windows (separate concern — plugin is bash-only).
>
> **Action items.**
>
> - Regression test added: `test_empty_profile_falls_back_to_default` in `tests/test-verbosity-hook.sh`. (@pitimon, merged PR #95.)
> - Audit: grep for `|| true` across all shell scripts → 3 more matches found, filed as #96. (@pitimon.)
> - Doc update: `rules/coding-style.md` "False Success Report" entry now cross-references this issue as the canonical example. (@pitimon, PR #97.)

What this post-mortem demonstrates: code identifiers preserved, cause chain walked end-to-end, prior fix attempt named, exact disproving experiment documented, validation coverage stated honestly, action items with owners.

## Tone

Engineer-to-engineer — different from leadership reframes:

- **Code identifiers are first-class.** Files, functions, lines, SHAs — keep them. The point is that future engineers can grep their way back.
- **Mechanism over narrative.** Walk the actual cause chain. Don't soften.
- **Active voice, concrete subjects, short paragraphs.** No hedging ("we believe", "appears to", "may have") — state it or don't write it.
- **Blameless.** Describe the bug, the gap, the fix. Never "X should have caught this." The CI gap is the failure mode, not the person.

## Handoff

- **Expects from predecessor**: A fixed-and-validated bug. Often follows `/review-ai` → fix → re-`/review-ai` PASS → here. May also be invoked directly after a hotfix.
- **Produces for successor**: An engineering-audience record. For a leadership reframe of the same bug, hand the finished post-mortem to a future `/management-talk` skill or paste it into an executive summary template. For learning capture, follow with `/reflect` — the post-mortem provides the raw material for the 6-question retro.

## H4 + H7 Checkpoint

- **H4**: "Does this leave the next engineer faster to root-cause a similar bug?" Stripping identifiers to sound nicer breaks it.
- **H7**: "Did this turn a one-time fix into a learnable pattern?" If action items are empty AND "why it slipped through" says "we should have caught this," the lesson isn't captured yet — write the regression test.

## Definition of Done

- [ ] All four Required Inputs confirmed before drafting
- [ ] Summary, Root cause, Fix, Validation sections are present (mandatory)
- [ ] At least one concrete code identifier per section where applicable (file:line, function name, commit SHA, test name)
- [ ] Validation coverage stated honestly — partial coverage explicit, not implied
- [ ] Blameless language — describes gaps and bugs, never people
- [ ] Action items have owner + tracking artifact, or explicit "None — fix is sufficient"
- [ ] Posting/destination confirmed (PR description, JIRA comment, `docs/postmortems/<ticket>.md`, internal wiki) — print-only by default

## Rules

- **Refuse to draft without all four Required Inputs.** A post-mortem of a hypothesis is worse than none.
- **Never invent** root cause, owner, validation runs, or action items. If facts aren't there, ask.
- **Never strip code identifiers.** They are the index.
- **State validation coverage honestly.** Implying broader coverage breeds repeat regressions.
- **One iteration normal, three is a smell.** Ask what specific section is wrong on third revision.

## Attribution

Structure and discipline inspired by [`thananon/9arm-skills/post-mortem`](https://github.com/thananon/9arm-skills). Adapted into 8-habit voice with original worked example.

## Further Reading

Load `${CLAUDE_PLUGIN_ROOT}/habits/h4-win-win.md` for the full H4 principle.
Load `${CLAUDE_PLUGIN_ROOT}/habits/h7-sharpen-saw.md` for the full H7 principle.
Load `${CLAUDE_PLUGIN_ROOT}/guides/integrity-principles.md` for evidence standards (the 13 commandments).
