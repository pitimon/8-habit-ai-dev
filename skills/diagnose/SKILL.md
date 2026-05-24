---
name: diagnose
description: >
  Active bug investigation discipline — 6-phase methodology covering feedback-loop, reproduce,
  hypothesise, instrument, fix-with-regression-test, and cleanup-with-post-mortem.
  Use when investigating a hard bug or performance regression that doesn't have an obvious
  root cause. Triggers: "diagnose", "debug this", "investigate this bug", "reproduce the
  failure", "why is X failing". Read-only guidance — guides the human through systematic
  investigation rather than auto-fixing. Refuses to skip Phase 1 (feedback loop) even under
  pressure, because guessing-before-loop is the documented anti-pattern this skill prevents.
  Maps to H1 (Be Proactive — trace all callers) + H5 (Seek First to Understand — reproduce
  before fixing). Hands off to /post-mortem once the fix lands and the feedback loop passes.
user-invocable: true
argument-hint: "[bug description, error message, or path to a prior /research brief]"
allowed-tools: ["Read", "Glob", "Grep", "Bash"]
prev-skill: any
next-skill: post-mortem
---

# `/diagnose` — Active Bug Investigation (6 Phases)

**Habits**: H1 (Be Proactive — prevent recurrence, not just patch the symptom) + H5 (Seek First to Understand — reproduce before fix)

## When to Use

- A bug is reported and the root cause is **not** obvious
- A performance regression appeared; you need to localize what changed
- Tests passed locally but failed in CI, or vice versa
- A feature works for some inputs and fails for others — you need to find the boundary
- A previous fix didn't hold; the bug returned in a different form

This skill enforces the discipline **build a fast feedback loop before you guess**. Documented friction: a lesson in `~/.claude/lessons/2026-04-12-compression-worker-420-investigation.md` notes that a 30-minute log-analysis session could have been a 5-minute SQL-comparison session if Phase 1 had been done first.

## When to Skip

- Single-line bug with obvious root cause (typo, wrong constant, off-by-one in plain sight)
- Lint/format errors with a clear fix
- Rename refactors and dependency bumps with passing CI
- Stack trace points to a single line that you can read and immediately understand

For these, fix directly and run tests. Save the 6 phases for hard bugs.

## Predecessor `/research` Brief (Optional Input)

If you ran `/research` before this — or have a saved brief from a prior session — paste its path now. Standard locations:

- `~/.claude/plans/*.md` (Deep-mode briefs)
- `docs/specs/<slug>/research.md` (persisted briefs)

If no prior brief exists, this skill proceeds without it. The skill never auto-globs your filesystem; user agency drives context loading.

---

## The 6 Phases

### Phase 1 — Build the Feedback Loop

Construct a fast, deterministic pass/fail signal. This is **the critical phase** — every other phase depends on it. Treat the loop as a product: optimize for speed, signal clarity, and determinism.

Acceptable loop shapes (use Bash for read-only execution):

- Failing test that reproduces the bug: `bun test path/to/test --watch`, `pytest -x path/to/test.py`
- HTTP probe: `curl -sf https://endpoint | jq .field` returning known-bad output
- CLI invocation: `./script.sh < fixture.txt | diff - expected.txt`
- Browser automation snippet that fails deterministically

**Blocker rule**: If you cannot make a loop fast (<10s ideal, <60s max) AND deterministic (same output every run), do NOT proceed to Phase 3. Surface this as a blocker and consider alternative approaches: `git bisect`, ablation (disable subsystems one at a time), telemetry inspection on production traffic.

### Phase 2 — Reproduce

Run the loop and confirm:

- The failure matches the user's description (not a different bug that happens to break the same test)
- Reproducibility is acceptable (≥80% — flaky bugs need more loop work, not more hypotheses)
- The exact symptom is captured (error message, status code, output diff)

If reproduction is intermittent, return to Phase 1 and stabilize the loop before continuing.

### Phase 3 — Hypothesise

Generate **3–5 ranked, falsifiable hypotheses**, each with an explicit prediction of the form:

> _"If X causes it, then changing Y will make the bug disappear."_

(Quote verbatim from [mattpocock/skills diagnose SKILL.md, SHA b8be62ff](https://raw.githubusercontent.com/mattpocock/skills/b8be62ffacb0118fa3eaa29a0923c87c8c11985c/skills/engineering/diagnose/SKILL.md).)

Share the ranked list with the user before testing. Domain knowledge from the human disambiguates better than another tool call. Rank by:

1. **Likelihood** — given symptoms and recent changes, which is most plausible?
2. **Cost to falsify** — which can you disprove with the cheapest probe?

A good rule: the top 3 should cover ~80% of probability mass.

### Phase 4 — Instrument

Test **one variable per probe**. Prefer debuggers (single-step, inspect state) over `print` statements; prefer focused logging over scattering `console.log` everywhere. Each debug output should carry a unique tag (e.g., `[DIAG-A]`, `[DIAG-B]`) so cleanup in Phase 6 is mechanical.

If a probe falsifies a hypothesis: remove it, mark the hypothesis dead, move to the next. If a probe confirms: narrow further until you've located the **architectural seam** where the real bug pattern lives — not just the symptom site.

### Phase 5 — Fix with Regression Test

**Write the regression test BEFORE the fix.**

The test must:

- Fail on current `main` (or the bug's branch)
- Pass after the fix
- Live at the correct architectural seam — if you fix in code at `services/payment.ts` but test through `api/checkout.test.ts`, the test is too far from the bug. Move it closer to the seam.

If the fix needs to touch multiple files, ask whether you've found the right seam. Often the right fix is upstream of where the symptom appeared.

### Phase 6 — Cleanup & Handoff to `/post-mortem`

- **MUST re-run the Phase 1 feedback loop and confirm it now reports green.** **Why**: a fix that compiles and a fix that solves the original bug are different things. Anthropic's `pptx/SKILL.md` (~line 243) frames the rule directly: "Do not declare success until you've completed at least one fix-and-verify cycle." Without this re-run, "Phase 5 wrote a test and the fix passes the test" can still ship a regression that the original feedback loop catches but the regression test doesn't.
- **MUST remove all probes** by grepping the unique tags from Phase 4 (`grep -rE 'DIAG-[A-Z]'`). **Why**: probe residue contaminates future diagnoses (false-positive matches) and ships diagnostic logging to users.
- **MUST restore any temporarily disabled subsystems** from ablation work. **Why**: ablation is a diagnostic technique, not a fix; shipping with a subsystem off is a silent feature regression.
- **MUST run the full test suite** to catch unrelated breakage. **Why**: a fix that touches the right seam can still break callers the regression test didn't enumerate.

Then invoke `/post-mortem` for the engineering record. This skill's job ends when the fix is validated; `/post-mortem` writes the durable artifact for future-you.

**NEVER declare diagnose complete on first-render results.** Anthropic's pptx skill states it bluntly (~line 206): "Your first render is almost never correct." Re-run Phase 1 even when the regression test passes — that's the verification the regression test cannot itself provide.

---

## H1 + H5 Checkpoint

- **H1**: _"Did I trace what else this bug affects, or only the reported callsite?"_
- **H5**: _"Did I build the feedback loop and reproduce, before generating hypotheses?"_

If either answer is "no", loop back to the relevant phase. The cost of an extra Phase 2 cycle is small; the cost of fixing the wrong thing is large.

---

## Handoff

- **Expects from predecessor (any)**: bug description, error message, failing test path, or a prior `/research` brief
- **Produces for successor (`/post-mortem`)**: validated fix + regression test + repro loop reference + cleanup confirmation

## Definition of Done

- [ ] Phase 1 feedback loop is fast (<10s ideal) AND deterministic — documented
- [ ] Phase 2 reproduction confirmed at ≥80% rate
- [ ] Phase 3 produced 3–5 ranked falsifiable hypotheses with explicit predictions
- [ ] Phase 4 probes were one-variable-at-a-time, uniquely tagged
- [ ] Phase 5 regression test written BEFORE the fix, located at the architectural seam
- [ ] Phase 6 cleanup grep returned zero residual probes
- [ ] **Phase 6 re-run of Phase 1 feedback loop confirmed green** (not just regression test passing)
- [ ] `/post-mortem` ready to be invoked

## Further Reading

Load `/Users/itarun/.claude/plugins/cache/pitimon-8-habit-ai-dev/8-habit-ai-dev/2.18.0/skills/diagnose/reference.md` for full mattpocock prior-art notes, per-phase examples, false-positive patterns from the compression-worker-420 lesson, and license attribution.

Load `/Users/itarun/.claude/plugins/cache/pitimon-8-habit-ai-dev/8-habit-ai-dev/2.18.0/habits/h1-be-proactive.md` for the H1 principle.

Load `/Users/itarun/.claude/plugins/cache/pitimon-8-habit-ai-dev/8-habit-ai-dev/2.18.0/habits/h5-understand-first.md` for the H5 principle.

---

[/diagnose] METHODOLOGY-COMPLETE SKILL_OUTPUT:diagnose

<!-- SKILL_OUTPUT:diagnose
phases: 6
feedback_loop_built: [true|false]
reproduction_rate: "[percentage]"
hypotheses_count: [3-5]
regression_test_written_first: [true|false]
cleanup_grep_clean: [true|false]
handoff_to: post-mortem
END_SKILL_OUTPUT -->
