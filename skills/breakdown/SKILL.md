---
name: breakdown
description: >
  Decompose feature into atomic tasks — 1 task per agent.
  Use AFTER /design and BEFORE /build-brief. Step 3 of 7-step workflow. Maps to H3 (First Things First).
user-invocable: true
argument-hint: "[feature or PRD to decompose]"
allowed-tools: ["Read", "Glob", "Grep"]
---

# Step 3: Plan (หั่นงานเป็นชิ้นเล็ก)

**Habit**: H3 — Put First Things First | **Anti-pattern**: One giant prompt that tries to do everything at once

## Process

1. **Read the requirements/design**: Load PRD or design decisions from previous steps.

2. **Decompose into atomic tasks** (1 task = 1 focused unit of work):

   ```
   ## Task List
   1. [ ] [Task name] — [1-sentence description] | Files: [list] | Depends on: [none or #N]
   2. [ ] [Task name] — [1-sentence description] | Files: [list] | Depends on: [#1]
   ...
   ```

3. **Prioritize** by importance, not interest:
   - Q1 (Urgent + Important): Blocking dependencies, security fixes
   - Q2 (Important, Not Urgent): Core features, tests, docs
   - Q3 (Urgent, Not Important): Nice-to-have polish
   - Q4 (Neither): Skip entirely

4. **Identify parallel work**: Tasks with no dependencies can run simultaneously using parallel agents.

5. **Scope guard**: For each task ask — "Is this in scope? Will this prevent future problems (Q2) or is it gold-plating (Q4)?"

6. **H3 Checkpoint**: "Am I doing what's important, or what's interesting?"

## Rule of Thumb

- If a task touches >5 files, break it down further
- If you can't describe a task in 1 sentence, it's too big
- If tasks have circular dependencies, redesign

Load `${CLAUDE_PLUGIN_ROOT}/habits/h3-first-things-first.md` for the full H3 principle and examples.
