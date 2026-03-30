---
name: build-brief
description: >
  Generate context-rich implementation brief before coding.
  Use AFTER /breakdown for each task. Step 4 of 7-step workflow. Maps to H5 (Seek First to Understand).
user-invocable: true
argument-hint: "[task to implement]"
allowed-tools: ["Read", "Glob", "Grep"]
---

# Step 4: Build (บรีฟให้ชัด ไม่ใช่แค่สั่ง)

**Habit**: H5 — Seek First to Understand | **Anti-pattern**: Prompting "build X" without reading existing code

## Process

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

Load `${CLAUDE_PLUGIN_ROOT}/habits/h5-understand-first.md` for the full H5 principle and examples.
