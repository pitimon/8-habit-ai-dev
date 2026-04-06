---
name: breakdown
description: >
  Decompose feature into atomic tasks — 1 task per agent.
  Use AFTER /design and BEFORE /build-brief. Step 3 of 7-step workflow. Maps to H3 (First Things First).
user-invocable: true
argument-hint: "[feature or PRD to decompose]"
allowed-tools: ["Read", "Glob", "Grep"]
prev-skill: design
next-skill: build-brief
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

5. **Lazy Parallelism Gate**: Before spawning parallel agents, ask:
   - Can I do this sequentially in ≤5 tool calls? If yes, sequential is cheaper.
   - Are the tasks meaningfully disjoint (different files, different concerns)?
   - Will coordinating results add complexity that outweighs time savings?

   Parallel agents have overhead: context loading, coordination, result merging. Only parallelize when decomposition is genuinely independent and substantial enough to justify the cost.

6. **Scope guard**: For each task ask — "Is this in scope? Will this prevent future problems (Q2) or is it gold-plating (Q4)?"

7. **H3 Checkpoint**: "Am I doing what's important, or what's interesting?"

## Rule of Thumb

- If a task touches >5 files, break it down further
- If you can't describe a task in 1 sentence, it's too big
- If tasks have circular dependencies, redesign

## Handoff

- **Expects from predecessor** (`/design`): Architecture decisions and constraints
- **Produces for successor** (`/build-brief`): Prioritized task list with dependencies and file paths

## When to Skip

- Single-file change with no dependencies — nothing to decompose
- Bug fix with obvious root cause and single touch point
- Task already broken down in an external tracker (Linear, Jira, GitHub Project)

## Definition of Done

- [ ] Each task describable in 1 sentence — if not, break it down further
- [ ] Dependencies mapped (no circular dependencies)
- [ ] Parallel work identified — independent tasks marked for concurrent execution
- [ ] Tasks prioritized by importance (Q2 > Q1 > Q3, Q4 eliminated)
- [ ] No task touches more than 5 files

Load `${CLAUDE_PLUGIN_ROOT}/guides/templates/task-list-template.md` for the output template.
Load `${CLAUDE_PLUGIN_ROOT}/habits/h3-first-things-first.md` for the full H3 principle and examples.
