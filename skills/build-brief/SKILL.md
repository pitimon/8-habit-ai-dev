---
name: build-brief
description: >
  Generate context-rich implementation brief before coding.
  Use AFTER /breakdown for each task. Step 4 of 7-step workflow. Maps to H5 (Seek First to Understand).
user-invocable: true
argument-hint: "[task to implement]"
allowed-tools: ["Read", "Glob", "Grep"]
prev-skill: breakdown
next-skill: review-ai
---

# Step 4: Build (บรีฟให้ชัด ไม่ใช่แค่สั่ง)

**Habit**: H5 — Seek First to Understand | **Anti-pattern**: Prompting "build X" without reading existing code

## Process

0. **Problem statement gate** (REQUIRED before anything else):

   > "What specific problem does this implementation solve?"

   Must cite one of: requirement (issue #), bug report, or design decision (ADR).
   If you cannot answer this question, go back to `/requirements` first.

   Research basis: Amazon Working Backwards, Basecamp Shape Up, and Google Design Docs all physically separate "what & why" from "how". Teams that skip this waste 30-40% of implementation time on rework.

1. **Read existing code first**: Before writing anything new, read the files in the affected area. Understand current patterns, naming conventions, and architecture.

1b. **Check past lessons** (if `~/.claude/lessons/` exists):
   - Grep `~/.claude/lessons/` for tags or keywords matching the task name, affected file paths, or domain
   - Search by tags first: `Grep pattern="tags:.*<keyword>" path="~/.claude/lessons/"`
   - Fall back to keyword search: `Grep pattern="<keyword>" path="~/.claude/lessons/"`
   - If relevant lessons found, include them in the context brief under "Lessons from past work"
   - If no lessons directory or no matches, skip silently

2. **Build the context brief**:

   ```
   ## Implementation Brief: [Task Name]
   **Goal**: [1 sentence]
   **Files to modify**: [list with paths]
   **Existing patterns to follow**: [e.g., "uses callRemoteAPI + wrapSuccess pattern"]
   **Constraints**: [e.g., "must be backward compatible", "max 800 lines"]
   **Test approach**: [what to test, TDD if applicable]
   ```

3. **Include relevant context** the AI needs:
   - CLAUDE.md project rules
   - DOMAIN.md entity definitions (if API work)
   - Existing similar implementations to reference

4. **Don't assume — verify**:
   - Does the function you plan to call actually exist?
   - Does the file path you reference exist?
   - Is the API endpoint you'll use actually implemented?

5. **Define context boundaries** (for parallel/multi-agent work):

   ```
   ## Context Boundaries
   **Must know** (include in agent prompt):
   - Files to read: [specific paths]
   - Domain context: [1-2 sentences]
   - Success criteria: [from /breakdown]

   **Must NOT know** (exclude to prevent pollution):
   - Other agents' tasks and their file changes
   - Unrelated codebase areas
   - Implementation details of dependencies not yet merged

   **Merge contract**:
   - Output: [what this agent produces — files, tests, types]
   - Merge point: [when/where results integrate — branch, PR, or sequential step]
   ```

   Skip this step for single-agent sequential work. Required when `/breakdown` classified tasks as `parallel-safe` or `parallel-worktree`.

6. **Context survival** (brief longevity in long sessions):

   Claude Code uses a 4-layer context compression pipeline that progressively removes older content as the context window fills. Briefs written early in a session may be summarized or removed mid-implementation. Structure your brief to survive compression:

   - **Front-load critical info**: Success criteria, key constraints, and file paths go at the TOP of the brief. Compression removes from the middle first.
   - **Keep briefs under ~4,000 tokens**: Longer briefs are prime compression targets. If your brief exceeds this, split into one brief per implementation phase rather than one mega-brief.
   - **Stable content first, volatile last**: Architecture decisions and conventions at the top; current task specifics at the bottom. This mirrors Claude Code's own prompt cache stability pattern — stable prefixes stay cached, volatile suffixes get refreshed.
   - **Self-contained references**: Use "see file X at line Y" instead of pasting large code blocks. Compression can't remove external files.

   Skip this step for quick tasks that will complete within a few exchanges.

7. **H5 Checkpoint**: "Have I fully understood the problem before proposing a solution?"

## Common Mistakes

- Writing new code without reading what already exists
- Assuming a utility function exists when it doesn't
- Duplicating logic that's already implemented elsewhere
- Writing a 10,000-token mega-brief that gets compressed away mid-session

## Handoff

- **Expects from predecessor** (`/breakdown`): Specific task with file paths and dependencies
- **Produces for successor** (`/review-ai`): Implementation brief with context, patterns, constraints, and test approach

## When to Skip

- Single-file change in code you already understand well
- Follow-up fix where context is still fresh from previous session
- Task already has a detailed spec with file paths and patterns documented

## Definition of Done

- [ ] Existing code in affected area has been read (not just assumed)
- [ ] All referenced file paths verified to exist
- [ ] Existing patterns and naming conventions documented in brief
- [ ] Constraints listed (backward compatibility, file size, performance)
- [ ] Test approach defined (what to test, TDD if applicable)
- [ ] Brief is ≤4,000 tokens (or split into per-phase briefs for complex tasks)
- [ ] Context boundaries defined for parallel tasks (must-know / must-not-know / merge contract)

## Further Reading

See [Step 4 wiki page](../../docs/wiki/Step-4-Build-Brief.md) for deeper walkthrough, examples, and common pitfalls.

Load `${CLAUDE_PLUGIN_ROOT}/habits/h5-understand-first.md` for the full H5 principle and examples.
Load `${CLAUDE_PLUGIN_ROOT}/guides/orchestration-patterns.md` for context boundary and orchestration patterns.
