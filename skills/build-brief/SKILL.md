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

5. **H5 Checkpoint**: "Have I fully understood the problem before proposing a solution?"

## Common Mistakes

- Writing new code without reading what already exists
- Assuming a utility function exists when it doesn't
- Duplicating logic that's already implemented elsewhere

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

Load `${CLAUDE_PLUGIN_ROOT}/habits/h5-understand-first.md` for the full H5 principle and examples.
