---
name: design
description: >
  Produce architecture decisions — DB, auth, API, constraints.
  Use AFTER /requirements and BEFORE /breakdown. Step 2 of 7-step workflow. Maps to H8 (Find Your Voice).
user-invocable: true
argument-hint: "[component or system to design]"
allowed-tools: ["Read", "Glob", "Grep"]
---

# Step 2: Design (วางโครงสร้าง)

**Habit**: H8 — Find Your Voice | **Anti-pattern**: Letting AI decide architecture without human judgment

## Process

1. **Read existing architecture**: Check `CLAUDE.md`, `DESIGN.md`, `ARCHITECTURE.md`, `ADR/` directory — understand current state before proposing changes.

2. **Identify decisions** that need human input:
   - Database choice and schema
   - Authentication/authorization approach
   - API contract (REST, GraphQL, MCP)
   - Service boundaries
   - Third-party dependencies

3. **Present options** with trade-offs (not just one recommendation):

   ```
   ## Decision: [Topic]
   **Option A**: [Description] — Pro: [x], Con: [y]
   **Option B**: [Description] — Pro: [x], Con: [y]
   **Recommendation**: [Which and why]
   ```

4. **Human must decide**: AI proposes, human disposes. Mark each decision as In-the-Loop.

5. **Document as ADR** if the decision is:
   - Hard to reverse
   - Affects >3 files
   - Changes public API

6. **H8 Checkpoint**: "Do I understand WHY we're building it this way, not just WHAT?"

## When to Skip

- Solo bug fix that follows an existing, established pattern
- Cosmetic or UI-only change with no architecture impact
- Change already covered by a previously accepted ADR

## Definition of Done

- [ ] At least 2 options presented with trade-offs for each key decision
- [ ] Human has explicitly decided (not AI default) — decision recorded
- [ ] ADR created for decisions affecting >3 files or changing public API
- [ ] Constraints and non-goals documented

Load `${CLAUDE_PLUGIN_ROOT}/habits/h8-find-voice.md` for the full H8 principle and examples.
