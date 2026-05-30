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

Surface hidden complexity. What did we not expect? Sub-prompt: did a **prior diagnosis** or shipped **fix prove wrong** this session — what evidence **reversed** it? A root cause that was confident-but-wrong is a high-value surprise to capture; this signal feeds `SKILL-EFFECTIVENESS.md`. See [`independent-source-verification.md`](../../guides/independent-source-verification.md).

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

## Step 7: Consolidation (automatic when count > 10)

After saving the lesson file, run the 4-phase consolidation cycle automatically. No separate `/reflect consolidate` invocation is needed when there are no deletions to approve.

1. **Count lessons**: `Glob ~/.claude/lessons/*.md`
2. **If count ≤ 10**: Skip — not enough lessons yet.
3. **If count > 10**: Run the 4-phase cycle inline:

   | Phase           | Action                                                                                                                                                                                        | Tools      |
   | --------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- |
   | **Orient**      | Glob all lesson files, read frontmatter (first 10 lines each) to build inventory. Note which are already-consolidated arcs (`consolidates:` in frontmatter — skip these as merge candidates). | Glob, Read |
   | **Gather**      | Group by `tags` overlap and `project` match. Flag same-incident candidates (same project + same day + overlapping tags).                                                                      | Grep       |
   | **Consolidate** | Evaluate each group with 2+ lessons. See branching logic below.                                                                                                                               | Read       |
   | **Prune**       | Only if merges were approved: delete superseded files, keep merged files.                                                                                                                     | Bash       |

   **Branching on Consolidate result**:
   - **No merges proposed** (all candidates are distinct incidents anchored to specific events — per INDEX maintenance rule "same theme across incidents = keep separate"): Update `~/.claude/lessons/INDEX.md` additively — refresh count, last-updated date, add new lesson entries to project sections and theme clusters, update By-habit table. Print one-line summary: `Consolidation: no merges. INDEX.md updated — [N] lessons, [K] new entries.`

   - **Merges proposed** (genuine duplicates detected): Present the full merge plan — which files merge, what the combined insight is, which files would be deleted. **STOP. Do not write or delete anything until the user gives explicit approval.** This is In-the-Loop per governance (ADR-002) — deletion is irreversible.

   **Human approval gate**: Required ONLY when deletions are proposed. INDEX-only updates (additive, non-destructive) run automatically without prompting.

4. **If the user runs `/reflect consolidate` explicitly** (argument = "consolidate"): Same 4-phase cycle with verbose output — print the full Consolidation Report (Before/After/Merged/Pruned/Kept) regardless of whether merges were found.

   ```
   ## Consolidation Report
   **Before**: [N] lesson files
   **After**: [M] lesson files
   **Merged**: [list of merged groups, or "none"]
   **Pruned**: [list of deleted files, or "none"]
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
- [ ] Consolidation auto-ran when count > 10: INDEX.md updated (no merges) or merge plan surfaced for approval (deletions proposed)
- [ ] Took no more than 5 minutes

Load `${CLAUDE_PLUGIN_ROOT}/habits/h7-sharpen-saw.md` for the full H7 principle and examples.
Load `${CLAUDE_PLUGIN_ROOT}/guides/templates/lesson-template.md` for the lesson file format.
