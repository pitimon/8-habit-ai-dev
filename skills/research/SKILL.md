---
name: research
description: >
  Investigate before specifying — research existing solutions, prior art, and domain constraints.
  Use BEFORE /requirements when the problem space is unclear. Step 0 of 7-step workflow. Maps to H5 (Seek First to Understand).
user-invocable: true
argument-hint: "[topic or problem to investigate]"
allowed-tools: ["Read", "Glob", "Grep", "WebSearch", "WebFetch", "Agent"]
prev-skill: none
next-skill: requirements
---

# Step 0: Research (ศึกษาก่อนกำหนด)

**Habit**: H5 — Seek First to Understand | **Anti-pattern**: Defining requirements without investigating the problem space

## Research Depth

Choose the appropriate depth based on the problem complexity. Default is **Standard**.

| Depth        | When to Use                                                          | Tools                       | Verification            |
| ------------ | -------------------------------------------------------------------- | --------------------------- | ----------------------- |
| **Quick**    | Codebase-only question; "how does X work here?"                      | Read, Glob, Grep            | Self-verify file paths  |
| **Standard** | Default — investigate problem space with codebase + external sources | + WebSearch, WebFetch       | Self-verify all sources |
| **Deep**     | High-stakes decision; multi-option evaluation; unfamiliar domain     | + Agent (research-verifier) | Agent-verified sources  |

**Auto-detection**: If the user provides no depth keyword, select based on the argument:

- Single codebase question → Quick
- General problem investigation → Standard
- "compare", "evaluate", "which should we", or 3+ options mentioned → Deep

## Research Modes

The research mode determines the output structure. Default is **General**.

| Mode        | Trigger                                                       | Output                      |
| ----------- | ------------------------------------------------------------- | --------------------------- |
| **General** | Default — "research [topic]"                                  | Standard research brief     |
| **Compare** | "research compare [A vs B vs C]" or multiple options detected | Brief + comparison matrix   |
| **Audit**   | "research audit [topic]" or "does our code match..."          | Brief + audit results table |

## Process

### 1. Define research questions

What do we need to know before specifying requirements?

- What existing solutions address this problem?
- What prior art or patterns exist in the codebase?
- What domain constraints should we respect?
- What have others tried? What worked? What failed?

### 2. Search existing solutions

Route by depth level:

**Quick** (codebase only):

- Glob/Grep the codebase for related patterns
- Read existing implementations, ADRs, and documentation
- Skip WebSearch/WebFetch entirely

**Standard** (codebase + external):

- Glob/Grep the codebase for related patterns
- WebSearch for existing tools, libraries, or approaches
- WebFetch to read key external documentation
- Check ADRs and past decisions

**Deep** (multi-source + verification):

- All Standard sources, plus:
- Search multiple external sources for comprehensive coverage
- Cross-reference findings between sources

### 3. Evaluate prior art

For each solution found, assess:

- Does it solve our problem? Partially? Fully?
- What trade-offs does it make?
- What can we reuse vs. build from scratch?

**Compare mode**: Build a comparison matrix with at least 3 evaluation criteria. Every cell must cite evidence — no "probably better" without a source.

**Audit mode**: For each documented behavior, find the corresponding code and assess whether they match. Every row must cite a file:line reference.

### 4. Verify sources

Before documenting findings, verify all cited sources:

**Quick**: Confirm file paths exist using Glob (spot-check)

**Standard**: Self-verify all sources:

- File paths: Glob to confirm existence, Read to confirm line accuracy
- URLs: WebFetch to confirm they resolve
- Mark any unverifiable source as "unverified assumption"

**Deep**: Dispatch the `research-verifier` agent for comprehensive verification. Use the Agent tool with `subagent_type: "8-habit-ai-dev:research-verifier"` passing the draft brief. The agent checks every citation and produces a verification report.

### 5. Document constraints and findings

Produce a research brief using the template. Load the template for the full structure:

```
## Research Brief: [Topic]
**Depth**: [Quick | Standard | Deep]
**Mode**: [General | Compare | Audit]
**Questions investigated**: [numbered list]
**Findings**: [table with source citations and verification status]
**Comparison Matrix**: [if Compare mode — criteria × options table]
**Audit Results**: [if Audit mode — claim vs code table]
**Constraints identified**: [list with source for each]
**Source Verification Report**: [if Deep mode — from research-verifier agent]
**Key insight**: [1-2 sentence finding that shapes requirements]
**Recommendation**: [build/reuse/adapt + reasoning]
```

### 6. H5 Checkpoint

"Have I understood the problem space before defining what to build?"

## Handoff

- **Expects from predecessor**: A problem statement or feature idea — "we need to..."
- **Produces for successor** (`/requirements`): Research brief with depth level, findings, constraints, and recommendation. In Compare mode, includes a comparison matrix. In Audit mode, includes a code-vs-docs audit table. In Deep mode, includes a source verification report.

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

- [ ] Research depth level selected and documented in brief header
- [ ] Research questions defined before searching
- [ ] At least 2 sources consulted (codebase + external or codebase + docs)
- [ ] Every finding cites its source
- [ ] All cited sources verified (file paths exist, URLs checked) — appropriate to depth level
- [ ] Constraints documented with source
- [ ] Comparison matrix included (if Compare mode) with evidence per cell
- [ ] Audit results included (if Audit mode) with file:line per row
- [ ] Research brief ready for handoff to /requirements

Load `${CLAUDE_PLUGIN_ROOT}/habits/h5-understand-first.md` for the full H5 principle and examples.
Load `${CLAUDE_PLUGIN_ROOT}/guides/integrity-principles.md` for evidence standards.
Load `${CLAUDE_PLUGIN_ROOT}/guides/templates/research-brief-template.md` for the output template.
