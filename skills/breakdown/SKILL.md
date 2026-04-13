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

4. **Identify parallel work and classify orchestration**: Tasks with no dependencies can run simultaneously. Classify each task:

   | Type                | When                                           | Isolation                             |
   | ------------------- | ---------------------------------------------- | ------------------------------------- |
   | `sequential`        | Output of A feeds input of B                   | Run after dependency completes        |
   | `parallel-safe`     | Tasks touch completely different files         | Same repo, concurrent execution       |
   | `parallel-worktree` | Tasks touch overlapping files or shared config | Each agent gets isolated git worktree |

   Produce an orchestration table for the task list:

   ```
   | Task | Type | Isolation | Depends On |
   |------|------|-----------|------------|
   | T1   | parallel-worktree | own worktree | none |
   | T2   | parallel-safe | same repo | none |
   | T3   | sequential | — | T1, T2 |
   ```

5. **Token-efficient parallel design** (for `parallel-safe` and `parallel-worktree` tasks):

   Claude Code's fork agents share a byte-identical prompt prefix with their parent, achieving ~90% input token savings. Apply this principle when designing parallel tasks:

   - **Maximize shared context**: Group tasks that read the same files and share the same architectural understanding. Their `/build-brief` context sections will overlap, and the shared prefix stays cached.
   - **Minimize divergence point**: Put the task-specific instruction LAST in the agent prompt. Everything before it is the shared prefix that gets cached.
   - **Avoid redundant reads**: If 3 agents all need to read `schema.prisma`, include it in the shared brief rather than having each agent read it independently (3x the token cost).

   | Pattern | When | Token Efficiency |
   |---------|------|-----------------|
   | Sequential (no sharing) | Tasks depend on each other | 1x (baseline) |
   | Parallel, independent briefs | Tasks touch different areas | ~1.3x (overhead from duplicate system prompts) |
   | Parallel, shared prefix brief | Tasks share context | ~0.3x (90% cache hit on shared prefix) |

   This step is most valuable for 3+ parallel tasks. For 2 tasks, the overhead of optimizing the prefix rarely pays off.

6. **Lazy Parallelism Gate**: Before spawning parallel agents, ask:
   - Can I do this sequentially in ≤5 tool calls? If yes, sequential is cheaper.
   - Are the tasks meaningfully disjoint (different files, different concerns)?
   - Will coordinating results add complexity that outweighs time savings?

   Parallel agents have overhead: context loading, coordination, result merging. Only parallelize when decomposition is genuinely independent and substantial enough to justify the cost.

7. **Scope guard**: For each task ask — "Is this in scope? Will this prevent future problems (Q2) or is it gold-plating (Q4)?"

8. **H3 Checkpoint**: "Am I doing what's important, or what's interesting?"

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
- [ ] Orchestration classification assigned to each task (sequential/parallel-safe/parallel-worktree)

## Structured Output Block

After writing the task list, append a structured output block for cross-skill handoff. This HTML comment is invisible when rendered but enables `/cross-verify` to auto-check scope alignment:

```
<!-- SKILL_OUTPUT:breakdown
task_count: [N]
tasks:
  - "[task 1]"
  - "[task 2]"
dependencies:
  - "[dependency description]"
estimated_complexity: "[low|medium|high]"
END_SKILL_OUTPUT -->
```

Place this at the very end of the task list output, after all human-readable content.

## Further Reading

See [Step 3 wiki page](../../docs/wiki/Step-3-Breakdown.md) for deeper walkthrough, examples, and common pitfalls.

Load `${CLAUDE_PLUGIN_ROOT}/guides/templates/task-list-template.md` for the output template.
Load `${CLAUDE_PLUGIN_ROOT}/habits/h3-first-things-first.md` for the full H3 principle and examples.
Load `${CLAUDE_PLUGIN_ROOT}/guides/orchestration-patterns.md` for worktree isolation and context boundary patterns.
Load `${CLAUDE_PLUGIN_ROOT}/guides/structured-output-protocol.md` for the structured output block format specification.
