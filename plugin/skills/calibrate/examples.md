# Calibrate — Sample Profile Outputs

Worked sample `~/.claude/habit-profile.md` files, one per maturity level. Loaded from `SKILL.md` when a user wants to see what the output looks like before running `/calibrate`, or when a maintainer is sanity-checking the write logic.

These samples use fictional answers that cleanly match one level — in real calibration, answers often span levels and the dominant-level rubric resolves the tie.

## Sample 1: Dependence

```markdown
---
level: Dependence
calibrated: 2026-04-16T07:15:00+07:00
schema-version: 1
responses:
  plugin-experience: "first session"
  ci-experience: "still learning — never set up CI myself"
  team-context: "solo, no peers"
  vocabulary-comfort: "brand new terms, haven't heard of Whole Person Model"
  orientation: "mostly fixing things that break"
preferences:
  verbosity-override: none
---

# Habit Profile — Dependence

Calibrated on 2026-04-16. This profile informs how `/requirements`,
`/review-ai`, `/cross-verify`, and other skills adapt their verbosity and
checkpoint emphasis to your experience level.

**Your level — Dependence**: You're getting oriented. Skills will show full guidance, all checkpoints, and beginner examples. This is how everyone starts.

**Re-calibrate**: Run `/calibrate` again anytime your practice changes
meaningfully. Re-assess after ~90 days of different work or after a major
workflow change.
```

## Sample 2: Independence

```markdown
---
level: Independence
calibrated: 2026-04-16T07:15:00+07:00
schema-version: 1
responses:
  plugin-experience: "a few weeks, running the 7-step workflow weekly"
  ci-experience: "comfortable solo — I run CI and write tests routinely"
  team-context: "pair with one or two peers"
  vocabulary-comfort: "roughly familiar with H5, Whole Person; fuzzier on Three Loops"
  orientation: "mix, tilting toward proactive"
preferences:
  verbosity-override: none
---

# Habit Profile — Independence

Calibrated on 2026-04-16. This profile informs how `/requirements`,
`/review-ai`, `/cross-verify`, and other skills adapt their verbosity and
checkpoint emphasis to your experience level.

**Your level — Independence**: You can run the 7-step workflow without hand-holding. Skills will show key checkpoints only and skip beginner examples.

**Re-calibrate**: Run `/calibrate` again anytime your practice changes
meaningfully. Re-assess after ~90 days of different work or after a major
workflow change.
```

## Sample 3: Interdependence (with Q6 answered)

```markdown
---
level: Interdependence
calibrated: 2026-04-16T07:15:00+07:00
schema-version: 1
responses:
  plugin-experience: "several months, daily use"
  ci-experience: "mentor peers on CI and testing conventions"
  team-context: "lead a small team of 4"
  vocabulary-comfort: "mostly clear — I can explain these to juniors"
  orientation: "mostly preventing, focused on my team"
  heart-signal: "active mentoring — weekly code reviews for 3 junior devs"
preferences:
  verbosity-override: none
---

# Habit Profile — Interdependence

Calibrated on 2026-04-16. This profile informs how `/requirements`,
`/review-ai`, `/cross-verify`, and other skills adapt their verbosity and
checkpoint emphasis to your experience level.

**Your level — Interdependence**: You lead or mentor others. Skills will focus on delegation, review, and synergy patterns over individual ceremony.

**Re-calibrate**: Run `/calibrate` again anytime your practice changes
meaningfully. Re-assess after ~90 days of different work or after a major
workflow change.
```

## Sample 4: Significance (with Q6 and Q7 answered)

```markdown
---
level: Significance
calibrated: 2026-04-16T07:15:00+07:00
schema-version: 1
responses:
  plugin-experience: "over a year, sustained daily use across multiple projects"
  ci-experience: "set CI and review standards for my org"
  team-context: "coordinate across multiple teams, org-wide"
  vocabulary-comfort: "I teach this externally — blog, conference talks"
  orientation: "preventing things from breaking for my community, not just myself"
  heart-signal: "publish technical articles, mentor publicly"
  spirit-signal: "publicly advocating for ethical AI practices"
preferences:
  verbosity-override: none
---

# Habit Profile — Significance

Calibrated on 2026-04-16. This profile informs how `/requirements`,
`/review-ai`, `/cross-verify`, and other skills adapt their verbosity and
checkpoint emphasis to your experience level.

**Your level — Significance**: You set the standard for others. Skills will show minimal prompts, trust your judgment, and surface only non-obvious checkpoints.

**Re-calibrate**: Run `/calibrate` again anytime your practice changes
meaningfully. Re-assess after ~90 days of different work or after a major
workflow change.
```

## Usage note

These samples are read-only reference. `/calibrate` writes the actual profile based on live user answers — do not copy a sample verbatim unless you literally match it across all seven questions.
