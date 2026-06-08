---
name: calibrate
description: >
  Assess your 8-habit maturity level via 5-7 questions and persist a profile
  to ~/.claude/habit-profile.md. Other skills read this profile to adapt their
  verbosity — Dependence (full guidance) → Independence (key checkpoints) →
  Interdependence (team focus) → Significance (minimal prompts).
  Maps to H8 (Find Your Voice — meet the user where they are, not where the template assumes).
user-invocable: true
argument-hint: "[optional: --force to skip confirmation]"
allowed-tools: ["Read", "Glob", "Grep", "Write"]
prev-skill: none
next-skill: any
---

# Calibrate (ปรับจูนระดับวุฒิภาวะ)

**Habit**: H8 — Find Your Voice | **Anti-pattern**: Giving identical verbose guidance to a senior engineer and a first-time user

## Why This Exists

The maturity model defined in `rules/effective-development.md` — Dependence → Independence → Interdependence → Significance — has existed in this plugin's rules for a long time but was never operationalized. Every session treated experienced users the same as first-run users: same verbose prompts, same checkpoint ceremony, same beginner examples. This wastes experienced users' tokens and time, and reads as condescending.

`/calibrate` closes that gap. It runs a brief self-assessment, writes a profile file, and lets other skills adapt. No enforcement, no tracking — just a signal the user opts into that informs the guidance they receive.

**Inspired by** (not copied from) Hermes Agent's USER.md pattern: explicit, user-facing, and editable. We do not implement passive inference (that would need a runtime we don't have) — this is active self-assessment instead.

## Process

### Step 0: Check for an existing profile

Read `~/.claude/habit-profile.md`. Three cases:

**Case A — no profile exists**: proceed to Step 1 (fresh calibration).

**Case B — profile exists and is less than 90 days old**: show the user their current level, calibrated date, and age in days. Ask: "Your profile says you're at [Level], calibrated [N] days ago. Re-calibrate anyway?" If no, exit with the current profile path. If yes, proceed to Step 1.

**Case C — profile exists and is 90+ days old**: show the user their current level and age. Say: "Your profile is [N] days old — your practice may have changed. Recommend re-calibrating." Then ask the same yes/no. Default to yes at this age.

If the argument `--force` is present, skip the confirmation entirely and proceed to Step 1.

### Step 1: Ask the 5 core questions

Ask these five questions one at a time. Wait for each answer before asking the next. Do not paste all five at once — give the user space to think.

**Q1 — Plugin experience**

> How long have you been using `8-habit-ai-dev` in your actual work? (e.g. "first session", "a few weeks", "several months", "over a year")

**Q2 — CI, testing, and review discipline**

> How comfortable are you with running CI pipelines, writing tests, and doing code review — as routine parts of your work, not occasional effort? (e.g. "still learning", "comfortable solo", "mentor others", "set standards for my team")

**Q3 — Team and collaboration context**

> What does your daily work look like in terms of collaboration? (e.g. "solo", "pair with a few peers", "lead a team", "coordinate across multiple teams or org-wide")

**Q4 — 8-habit vocabulary fluency**

> When I say "H5 Understand first", "Whole Person Model", "Three Loops", "In-the-Loop vs On-the-Loop", how do those land? (e.g. "brand new terms", "roughly familiar", "mostly clear", "I explain these to other people")

**Q5 — Reactive vs proactive orientation**

> When you think about your last 10 tasks, were they mostly fixing things that broke (reactive) or preventing things from breaking in the first place (proactive)? (e.g. "mostly fixing", "mix", "mostly preventing", "preventing things from breaking for my team/community, not just myself")

### Step 2: Optional Heart and Spirit signal questions

These two distinguish Independence from Interdependence, and Interdependence from Significance. Ask them unless the user's previous answers clearly place them at Dependence (in which case they add noise).

**Q6 — Heart signal (mentoring and craft pride)**

> Do you actively review, mentor, or teach other developers — and do you take craft pride in the code you ship (not just "does it work")? (e.g. "not yet", "peer review sometimes", "active mentoring", "publish/teach publicly")

**Q7 — Spirit signal (conscience)**

> Do you ask "should we build this at all?" before starting work — thinking about ethical impact, user harm, community consequences — not just "can we build it?" (e.g. "not a habit yet", "sometimes", "systematically", "I publicly advocate for this")

### Step 3: Score and write the profile

Use the **dominant-level rubric** to pick the modal level across all answered questions (ties go to the higher level — benefit of the doubt, do not insult experienced users). Then write the profile file to `~/.claude/habit-profile.md`.

The full scoring rubric table and the exact file-write procedure (directory check, ISO 8601 timestamp format, frontmatter template, level-to-description mapping, graceful-failure handling) are in the reference file.

Load `${CLAUDE_PLUGIN_ROOT}/skills/calibrate/reference.md` for the full scoring rubric, profile template, and level-to-description mapping.

For sample profile outputs at each of the 4 maturity levels, see the examples file.

Load `${CLAUDE_PLUGIN_ROOT}/skills/calibrate/examples.md` for worked sample profiles per level.

## Schema reference

The profile file format is documented in `guides/habit-profile-schema.md` (v1 contract). Skill readers (shipped in v2.7.0 via `hooks/session-start.sh` — see `guides/verbosity-adaptation.md`) code against that schema, not against this skill's body. If the schema needs to change, update `guides/habit-profile-schema.md` first and bump `schema-version`.

## Handoff

- **Expects from predecessor**: Nothing. Standalone onboarding skill. Typically invoked after `/using-8-habits` points the user here, or directly on first session via the `hooks/session-start.sh` nudge.
- **Produces for successor**: A written profile at `~/.claude/habit-profile.md` that any downstream skill can read. `next-skill: any` means the user is free to go wherever they need next.

## When to Skip

- The user has already calibrated within the last 90 days AND their practice has not materially changed. Running again adds noise without value.
- The user is running a quick one-off command where adapting verbosity would be gold-plating (e.g. a single typo fix — the maturity level is irrelevant for that scope).
- The user explicitly sets `HABIT_QUIET=1` in their environment and prefers to not be prompted about calibration — respect that signal per ADR-006.

## Definition of Done

- [ ] User answered 5-7 calibration questions (5 core, up to 2 optional signal questions).
- [ ] Skill computed a maturity level using the dominant-level rubric with higher-wins tie-break.
- [ ] `~/.claude/habit-profile.md` was written successfully, OR the user received the full profile content for manual save with a clear error message.
- [ ] Skill confirmed the saved level with a one-line message naming the level and the file path.
- [ ] Re-invocation with an existing profile showed the current level and age before overwriting.

Load `${CLAUDE_PLUGIN_ROOT}/rules/effective-development.md` for the full maturity model (Dependence → Independence → Interdependence → Significance) and the 8 habits each level implies.
Load `${CLAUDE_PLUGIN_ROOT}/guides/habit-profile-schema.md` for the v1 schema contract that this skill writes.
Load `${CLAUDE_PLUGIN_ROOT}/guides/whole-person-rubrics.md` for the dominant-level selection pattern this skill's scoring rubric adapts from (3 levels → 4 levels, system → user).
