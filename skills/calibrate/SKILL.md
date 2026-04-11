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

## Scoring Rubric — Dominant-Level Selection

For each answered question, match the user's answer to the closest level-shape in the table below. Do not try to sum points. Instead, pick the modal level across all answered questions. Ties go to the higher level (benefit of the doubt — do not insult experienced users).

| Level | Q1 plugin-experience | Q2 ci-experience | Q3 team-context | Q4 vocabulary-comfort | Q5 orientation | Q6 heart-signal (opt) | Q7 spirit-signal (opt) |
|---|---|---|---|---|---|---|---|
| **Dependence** | First session / days | Still learning | Solo, no peers | Brand new terms | Mostly reactive | Not yet reviewing | Not a habit yet |
| **Independence** | Weeks / a few months | Comfortable solo | Solo or pair | Roughly familiar | Mix, tilting proactive | Peer review sometimes | Sometimes |
| **Interdependence** | Several months to a year | Mentor peers | Small team lead | Mostly clear, can explain | Mostly preventing, team-focused | Active mentoring | Systematic in work |
| **Significance** | Over a year, sustained | Set org standards | Multi-team or org-wide | Teach externally | Preventing for community, not self | Publish / teach publicly | Publicly advocating |

**How to use the table**:
1. For each question, read the user's answer and pick the column that best matches.
2. Collect the 5-7 chosen levels.
3. Count occurrences of each level across the answered questions.
4. The modal level wins.
5. If two levels are tied for the mode, pick the **higher** one (Significance > Interdependence > Independence > Dependence).
6. If the answer genuinely spans multiple levels (e.g. "I mentor but I'm still learning CI"), go with the lower of the two for that question — we want the level the user is SOLIDLY at, not aspirational.

Write the chosen level down. You will need it for Step 3.

## Step 3: Write the profile file

After scoring, persist the profile. This step should be automatic — do not ask the user extra questions.

1. **Ensure the directory exists**: `~/.claude/` is almost certainly present (Claude Code uses it), but do not assume. Skip silently if it exists.

2. **Generate the file path**: `~/.claude/habit-profile.md` (fixed path, not user-chosen).

3. **Get the current timestamp**: ISO 8601 with the user's local timezone. On macOS: `date -Iseconds`. On Linux: `date -Iseconds`. Record the value for the `calibrated` field.

4. **Write the profile** using this exact template, substituting the scored level, timestamp, and the user's raw answers:

   ```markdown
   ---
   level: <LEVEL>
   calibrated: <ISO8601_TIMESTAMP>
   schema-version: 1
   responses:
     plugin-experience: "<raw Q1 answer>"
     ci-experience: "<raw Q2 answer>"
     team-context: "<raw Q3 answer>"
     vocabulary-comfort: "<raw Q4 answer>"
     orientation: "<raw Q5 answer>"
   preferences:
     verbosity-override: none
   ---

   # Habit Profile — <LEVEL>

   Calibrated on <YYYY-MM-DD>. This profile informs how `/requirements`,
   `/review-ai`, `/cross-verify`, and other skills adapt their verbosity and
   checkpoint emphasis to your experience level.

   **Your level — <LEVEL>**: <short description from the verbosity mapping below>.

   **Re-calibrate**: Run `/calibrate` again anytime your practice changes
   meaningfully. Re-assess after ~90 days of different work or after a major
   workflow change.
   ```

   If Q6 or Q7 were answered, add them to the `responses:` block under the 5 core keys:

   ```yaml
     heart-signal: "<raw Q6 answer>"
     spirit-signal: "<raw Q7 answer>"
   ```

5. **Level-to-description mapping** for the body of the profile:

   | Level | One-liner to substitute |
   |---|---|
   | Dependence | "You're getting oriented. Skills will show full guidance, all checkpoints, and beginner examples. This is how everyone starts." |
   | Independence | "You can run the 7-step workflow without hand-holding. Skills will show key checkpoints only and skip beginner examples." |
   | Interdependence | "You lead or mentor others. Skills will focus on delegation, review, and synergy patterns over individual ceremony." |
   | Significance | "You set the standard for others. Skills will show minimal prompts, trust your judgment, and surface only non-obvious checkpoints." |

6. **Confirm success**: print one line to the user: `Profile saved: ~/.claude/habit-profile.md (level: <LEVEL>)`.

7. **Graceful failure**: if the write fails (permission, disk full, unexpected error), do NOT block the output. Show the user the complete profile content that should have been saved, with a note: "Write failed — please save this content manually to `~/.claude/habit-profile.md`:" followed by the rendered template inside a code fence. The conversation-level calibration is more valuable than persistence.

## Schema reference

The profile file format is documented in `guides/habit-profile-schema.md` (v1 contract). Future skill readers — the 16 existing skills will adopt this profile in a separate v2.7.0 follow-up — code against that schema, not against this skill's body. If the schema needs to change, update `guides/habit-profile-schema.md` first and bump `schema-version`.

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
