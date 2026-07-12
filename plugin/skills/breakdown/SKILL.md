---
name: breakdown
description: >
  Decompose feature into atomic tasks — 1 task per agent.
  Use AFTER /design and BEFORE /build-brief. Step 3 of 7-step workflow. Maps to H3 (First Things First).
user-invocable: true
argument-hint: "[--persist <slug>] [feature or PRD to decompose]"
allowed-tools: ["Read", "Glob", "Grep", "Write", "AskUserQuestion"]
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

   For backlog-bound work, prefer vertical slices: each task should deliver a thin but complete path that can be verified or demonstrated on its own. Avoid horizontal layer tasks (`schema only`, `API only`, `UI only`) unless that layer is independently useful and has its own acceptance criteria. A good issue describes end-to-end behavior, not a list of implementation layers.

3. **Prioritize** by importance, not interest:
   - Q1 (Urgent + Important): Blocking dependencies, security fixes
   - Q2 (Important, Not Urgent): Core features, tests, docs
   - Q3 (Urgent, Not Important): Nice-to-have polish
   - Q4 (Neither): Skip entirely

4. **Identify parallel work, delegation readiness, and classify orchestration**: Tasks with no dependencies can run simultaneously. Also classify whether a task is ready for agent pickup or still needs human input.

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
   | T3   | sequential | - | T1, T2 |
   ```

   Add a readiness column when the task list may be filed into a backlog:

   | Readiness | Use when |
   | --- | --- |
   | `ready-for-agent` | The task has success criteria, scope boundaries, and enough context for an agent to pick up without asking the filer |
   | `ready-for-human` | The task needs human judgment, access, design approval, or manual verification before implementation |
   | `needs-info` | The task is not yet implementable because a requirement, owner, environment, or acceptance criterion is missing |

   If `docs/agents/triage-labels.md` exists, map these canonical states to the repo's real issue labels before recommending issue filing.

5. **Token-efficient parallel design** (for `parallel-safe` and `parallel-worktree` tasks):

   Claude Code's fork agents share a byte-identical prompt prefix with their parent, achieving ~90% input token savings. Apply this principle when designing parallel tasks:
   - **Maximize shared context**: Group tasks that read the same files and share the same architectural understanding. Their `/build-brief` context sections will overlap, and the shared prefix stays cached.
   - **Minimize divergence point**: Put the task-specific instruction LAST in the agent prompt. Everything before it is the shared prefix that gets cached.
   - **Avoid redundant reads**: If 3 agents all need to read `schema.prisma`, include it in the shared brief rather than having each agent read it independently (3x the token cost).

   | Pattern                       | When                        | Token Efficiency                               |
   | ----------------------------- | --------------------------- | ---------------------------------------------- |
   | Sequential (no sharing)       | Tasks depend on each other  | 1x (baseline)                                  |
   | Parallel, independent briefs  | Tasks touch different areas | ~1.3x (overhead from duplicate system prompts) |
   | Parallel, shared prefix brief | Tasks share context         | ~0.3x (90% cache hit on shared prefix)         |

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
- **Backlog-bound tasks**: When a task in the produced list will sit ≥7 days before pickup (or filer ≠ picker), recommend filing an issue using the repo's tracker contract if `docs/agents/issue-tracker.md` exists; otherwise default to GitHub issue wording. Use [`guides/templates/agent-brief-template.md`](../../guides/templates/agent-brief-template.md) for the durable issue spec. Habit-mapped variant of the pattern from [mattpocock/skills](https://github.com/mattpocock/skills).
- **Issue tracking comments**: When the user asks an agent to pick up, track, or close work through an issue, draft pickup/progress/completion comments using [`guides/templates/issue-tracking-comments.md`](../../guides/templates/issue-tracking-comments.md). Do not auto-post, auto-label, or auto-close unless the user or repo tracker contract explicitly allows it.

## Optional Persistence (`--persist <slug>`)

When invoked with `--persist <slug>`, this skill writes its task breakdown to `docs/specs/<slug>/tasks.md`, and the `SKILL_OUTPUT:breakdown` block lives in that file (not the conversation). Without the flag: no file writes and no block (byte-identical filesystem behavior to v2.14.3; conversation-block emission was removed in v2.21.39 per [#375](https://github.com/pitimon/8-habit-ai-dev/issues/375)).

For the canonical convention (slug regex `^[a-z0-9][a-z0-9-]{1,63}$`, conflict policy, YAML frontmatter format, error message rules, ID-linkage `Task #N` guidance), load `${CLAUDE_PLUGIN_ROOT}/guides/persistence-convention.md`.

ID-linkage tip: when persisting, format each task as `Task #N implements: Decision-X (FR-Y)` to cite the design decision and PRD requirement it satisfies. This enables deterministic Coverage and Inconsistency passes in `/consistency-check`. IDs are recommended, not required.

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
- [ ] Backlog-bound tasks classified as `ready-for-agent`, `ready-for-human`, or `needs-info`
- [ ] Backlog-bound tasks are vertical slices unless a horizontal task is independently verifiable

## Structured Output Block

**Emit this block only into the persisted `docs/specs/<slug>/tasks.md` file when `--persist` is used** — never append it to the conversation response (the HTML comment renders as visible noise in Codex; see [`guides/structured-output-protocol.md`](../../guides/structured-output-protocol.md) §"Emission gate"). It is machine-readable evidence for `/cross-verify`. The fenced block below is the **file template**:

Regardless of persistence, end your conversation output with the plain-text line `[/breakdown] complete` — see [`guides/structured-output-protocol.md`](../../guides/structured-output-protocol.md) §"Completion signal".

```
[/breakdown] COMPLETE SKILL_OUTPUT:breakdown
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

Place this at the very end of the persisted `tasks.md` file, after all human-readable content.

## Further Reading

See [Step 3 wiki page](../../docs/wiki/Step-3-Breakdown.md) for deeper walkthrough, examples, and common pitfalls.

Load `${CLAUDE_PLUGIN_ROOT}/guides/templates/task-list-template.md` for the output template.
Load `${CLAUDE_PLUGIN_ROOT}/habits/h3-first-things-first.md` for the full H3 principle and examples.
Load `${CLAUDE_PLUGIN_ROOT}/guides/orchestration-patterns.md` for worktree isolation and context boundary patterns.
Load `${CLAUDE_PLUGIN_ROOT}/guides/structured-output-protocol.md` for the structured output block format specification.
Load `${CLAUDE_PLUGIN_ROOT}/guides/persistence-convention.md` when `--persist <slug>` is used (canonical spec for opt-in persistence to `docs/specs/<slug>/tasks.md`).
Load `${CLAUDE_PLUGIN_ROOT}/guides/project-context-contract.md` when repo-local issue-tracker, triage-label, or domain context files are present.
