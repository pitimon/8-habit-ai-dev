---
name: reflect
description: >
  Post-task micro-retrospective — 6 questions, 5 minutes.
  Use AFTER completing a task or workflow to capture lessons learned,
  including a skill-effectiveness signal that feeds SKILL-EFFECTIVENESS.md.
  Maps to H7 (Sharpen the Saw — invest in capability, not just output).
user-invocable: true
argument-hint: "[task just completed] or 'consolidate' to merge lessons"
allowed-tools: ["Read", "Glob", "Grep", "Write", "Bash"]
prev-skill: any
next-skill: none
---

# Reflect (ทบทวน)

**Habit**: H7 — Sharpen the Saw | **Anti-pattern**: All output, no capability improvement — repeating the same mistakes

## Why This Exists

DORA research shows per-task micro-retros (3-5 questions, 5 minutes) are more effective than monthly hour-long retrospectives. The key differentiator: teams that assign action items with owners improve; teams that just "discuss" don't. Q6 below extends the DORA pattern with a skill-effectiveness signal specific to this plugin (H7 applied to the plugin itself, per Issue #92).

## Process

Ask these 6 questions. Keep answers brief — this should take no more than 5 minutes.

### 1. What went well?

Reinforce good practices. What should we keep doing?

### 2. What surprised me?

Surface hidden complexity. What did we not expect?

### 3. What would I do differently?

Improve next iteration. If starting over, what would change?

### 4. What reusable pattern did I discover?

Extract for the team. Is there a script, template, or approach worth sharing?

### 5. Action item

One specific, assigned action with a deadline. Not "we should improve testing" but "create a test template for API endpoints by Friday."

### 6. Skill effectiveness signal

Which 8-habit skill was **most useful** this session, and which was **least useful or confusing**? Answer "n/a" if no skills were invoked (e.g., quick fix outside the 7-step workflow). This signal feeds `SKILL-EFFECTIVENESS.md` during periodic maintainer review — H7 applied to the plugin itself. Do not overthink it: name up to one skill per side, or "n/a".

## Output

```
## Reflection: [task/feature name]
**Date**: [YYYY-MM-DD]
**Duration**: [how long the task took]

| # | Question | Answer |
|---|----------|--------|
| 1 | Went well | [brief answer] |
| 2 | Surprised | [brief answer] |
| 3 | Do differently | [brief answer] |
| 4 | Reusable pattern | [brief answer or "none this time"] |
| 5 | Action item | [specific action] — **Owner**: [who] — **By**: [date] |
| 6 | Skill effectiveness | Most useful: [skill or "n/a"] · Least/confusing: [skill or "n/a"] |
```

## Step 6: Persist Lesson (automatic)

After the 6 questions are answered, persist the reflection as a lesson file for future sessions. This step should be automatic — do not ask the user additional questions.

1. **Create directory** if needed: `~/.claude/lessons/` (skip silently if it already exists)
2. **Generate filename**: `YYYY-MM-DD-<slug>.md` where `<slug>` is a lowercase, hyphenated summary of the task (max 50 chars, no spaces or special characters)
3. **Write the lesson file** using the template from `${CLAUDE_PLUGIN_ROOT}/guides/templates/lesson-template.md`:
   - `date`: today's date
   - `task`: the task/feature name from the reflection argument
   - `project`: basename of the current working directory
   - `tags`: 2-5 keywords extracted from the reflection answers (domain, technology, pattern)
   - `habit`: the primary habit that applied during this task (if identifiable)
   - Body: the 6-question answers from the reflection output, including the `## Skill effectiveness` section (Q6) which is parsed during periodic maintainer review for `SKILL-EFFECTIVENESS.md`
4. **Confirm**: Print a one-line confirmation: `Lesson saved: ~/.claude/lessons/<filename>`
5. **Graceful failure**: If the write fails (permissions, disk full), warn the user but do NOT block the reflection output. The conversation-level reflection is more valuable than persistence.

## Step 7: Consolidation check (periodic)

After saving the lesson file, check if lessons need consolidation. Inspired by Claude Code's auto-dream 4-phase consolidation pattern (Orient → Gather → Consolidate → Prune) — applied here as manual guidance, not automation.

1. **Count lessons**: `Glob ~/.claude/lessons/*.md`
2. **If count ≤ 10**: Skip — not enough lessons to consolidate yet.
3. **If count > 10**: Print a consolidation nudge:

   > **Consolidation suggested** — You have [N] lesson files. Consider running:
   > `/reflect consolidate` to merge duplicates and prune stale lessons.

4. **If the user runs `/reflect consolidate`** (argument = "consolidate"):

   Run the 4-phase cycle on `~/.claude/lessons/`:

   | Phase | Action | Tools |
   |-------|--------|-------|
   | **Orient** | Glob all lesson files, Read frontmatter (first 10 lines each) to build inventory | Glob, Read |
   | **Gather** | Group lessons by `tags` overlap and `project` match | Grep |
   | **Consolidate** | For each group with 2+ lessons: propose a merged lesson that combines insights, resolves contradictions, and keeps the most recent "do differently" actions. Present merge plan to user for approval before writing. | Read |
   | **Prune** | After user approves merges: delete superseded lesson files, keep merged files | Bash |

   **Human approval gate**: The consolidate phase MUST show the merge plan and get explicit user approval before deleting any files. This is In-the-Loop per governance — deletion is irreversible.

   Output after consolidation:
   ```
   ## Consolidation Report
   **Before**: [N] lesson files
   **After**: [M] lesson files
   **Merged**: [list of merged groups]
   **Pruned**: [list of deleted files]
   **Kept unchanged**: [list]
   ```

## When to Skip

- Task took less than 15 minutes
- Purely mechanical change (formatting, rename)
- Already reflected in a team retrospective covering the same work

## Definition of Done

- [ ] All 6 questions answered (even if briefly; Q6 can be "n/a")
- [ ] Action item has an owner and deadline (or explicitly "none needed")
- [ ] Skill effectiveness signal captured (Q6) — up to one "most useful" and one "least useful/confusing" skill, or "n/a"
- [ ] Lesson file persisted to `~/.claude/lessons/` (or warning printed if write failed)
- [ ] Consolidation check performed if lesson count > 10
- [ ] Took no more than 5 minutes

Load `${CLAUDE_PLUGIN_ROOT}/habits/h7-sharpen-saw.md` for the full H7 principle and examples.
Load `${CLAUDE_PLUGIN_ROOT}/guides/templates/lesson-template.md` for the lesson file format.
