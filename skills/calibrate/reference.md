# Calibrate — Scoring Rubric and Profile Template

Full scoring rubric, profile-file template, and level-to-description mapping. Loaded from `SKILL.md` Step 3 when the skill is ready to compute a level and write the profile.

## Scoring Rubric — Dominant-Level Selection

For each answered question, match the user's answer to the closest level-shape in the table below. Do not try to sum points. Instead, pick the modal level across all answered questions. Ties go to the higher level (benefit of the doubt — do not insult experienced users).

| Level               | Q1 plugin-experience     | Q2 ci-experience  | Q3 team-context        | Q4 vocabulary-comfort     | Q5 orientation                     | Q6 heart-signal (opt)    | Q7 spirit-signal (opt) |
| ------------------- | ------------------------ | ----------------- | ---------------------- | ------------------------- | ---------------------------------- | ------------------------ | ---------------------- |
| **Dependence**      | First session / days     | Still learning    | Solo, no peers         | Brand new terms           | Mostly reactive                    | Not yet reviewing        | Not a habit yet        |
| **Independence**    | Weeks / a few months     | Comfortable solo  | Solo or pair           | Roughly familiar          | Mix, tilting proactive             | Peer review sometimes    | Sometimes              |
| **Interdependence** | Several months to a year | Mentor peers      | Small team lead        | Mostly clear, can explain | Mostly preventing, team-focused    | Active mentoring         | Systematic in work     |
| **Significance**    | Over a year, sustained   | Set org standards | Multi-team or org-wide | Teach externally          | Preventing for community, not self | Publish / teach publicly | Publicly advocating    |

**How to use the table**:

1. For each question, read the user's answer and pick the column that best matches.
2. Collect the 5-7 chosen levels.
3. Count occurrences of each level across the answered questions.
4. The modal level wins.
5. If two levels are tied for the mode, pick the **higher** one (Significance > Interdependence > Independence > Dependence).
6. If the answer genuinely spans multiple levels (e.g. "I mentor but I'm still learning CI"), go with the lower of the two for that question — we want the level the user is SOLIDLY at, not aspirational.

Write the chosen level down. You will need it for the profile-write step.

## Profile-Write Procedure

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

## Level-to-Description Mapping

For the body of the profile file, substitute one of these short descriptions based on the scored level:

| Level           | One-liner to substitute                                                                                                             |
| --------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| Dependence      | "You're getting oriented. Skills will show full guidance, all checkpoints, and beginner examples. This is how everyone starts."     |
| Independence    | "You can run the 7-step workflow without hand-holding. Skills will show key checkpoints only and skip beginner examples."           |
| Interdependence | "You lead or mentor others. Skills will focus on delegation, review, and synergy patterns over individual ceremony."                |
| Significance    | "You set the standard for others. Skills will show minimal prompts, trust your judgment, and surface only non-obvious checkpoints." |

## Confirmation and Graceful Failure

6. **Confirm success**: print one line to the user: `Profile saved: ~/.claude/habit-profile.md (level: <LEVEL>)`.

7. **Graceful failure**: if the write fails (permission, disk full, unexpected error), do NOT block the output. Show the user the complete profile content that should have been saved, with a note: "Write failed — please save this content manually to `~/.claude/habit-profile.md`:" followed by the rendered template inside a code fence. The conversation-level calibration is more valuable than persistence.
