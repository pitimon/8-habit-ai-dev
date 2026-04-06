---
name: research
description: >
  Investigate before specifying — research existing solutions, prior art, and domain constraints.
  Use BEFORE /requirements when the problem space is unclear. Step 0 of 7-step workflow. Maps to H5 (Seek First to Understand).
user-invocable: true
argument-hint: "[topic or problem to investigate]"
allowed-tools: ["Read", "Glob", "Grep", "WebSearch", "WebFetch"]
prev-skill: none
next-skill: requirements
---

# Step 0: Research (ศึกษาก่อนกำหนด)

**Habit**: H5 — Seek First to Understand | **Anti-pattern**: Defining requirements without investigating the problem space

## Process

1. **Define research questions**: What do we need to know before specifying requirements?
   - What existing solutions address this problem?
   - What prior art or patterns exist in the codebase?
   - What domain constraints should we respect?
   - What have others tried? What worked? What failed?

2. **Search existing solutions**: Look for prior art in the codebase, libraries, and external references.
   - Glob/Grep the codebase for related patterns
   - WebSearch for existing tools, libraries, or approaches
   - Check documentation, ADRs, and past decisions

3. **Evaluate prior art**: For each solution found, assess:
   - Does it solve our problem? Partially? Fully?
   - What trade-offs does it make?
   - What can we reuse vs. build from scratch?

4. **Document constraints and findings**: Capture what you learned:

   ```
   ## Research Brief: [Topic]
   **Questions investigated**: [numbered list]
   **Existing solutions found**: [with assessment]
   **Domain constraints identified**: [list]
   **Key insight**: [1-2 sentence finding that shapes requirements]
   **Recommendation**: [build/reuse/adapt + reasoning]
   ```

5. **H5 Checkpoint**: "Have I understood the problem space before defining what to build?"

## Handoff

- **Expects from predecessor**: A problem statement or feature idea — "we need to..."
- **Produces for successor** (`/requirements`): Research brief with findings, constraints, and recommendation

## Evidence Standard

Every finding MUST cite its source (Feynman principle: "evidence or it didn't happen"):

- Codebase finding: file path and line number
- External finding: URL or document reference
- Domain constraint: source of the constraint (regulation, API doc, stakeholder)

No unsourced claims. If you can't cite it, mark it as "unverified assumption."

## When to Skip

- Requirements already clear from user or stakeholder — nothing to investigate
- Single-file bug fix with obvious root cause
- Well-understood domain with established patterns in the codebase
- Continuing work on an already-researched feature

## Definition of Done

- [ ] Research questions defined before searching
- [ ] At least 2 sources consulted (codebase + external or codebase + docs)
- [ ] Every finding cites its source
- [ ] Constraints documented with source
- [ ] Research brief ready for handoff to /requirements

Load `${CLAUDE_PLUGIN_ROOT}/habits/h5-understand-first.md` for the full H5 principle and examples.
Load `${CLAUDE_PLUGIN_ROOT}/guides/integrity-principles.md` for evidence standards.
