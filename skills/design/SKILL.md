---
name: design
description: >
  Produce architecture decisions — DB, auth, API, constraints.
  Use AFTER /requirements and BEFORE /breakdown. Step 2 of 7-step workflow. Maps to H8 (Find Your Voice).
user-invocable: true
argument-hint: "[component or system to design]"
allowed-tools: ["Read", "Glob", "Grep"]
prev-skill: requirements
next-skill: breakdown
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

5. **Article 14 Human-Oversight Checkpoint** (for AI-system designs):

   If the system being designed is an **AI system that may target the EU market** (or any high-risk AI system regardless of market), confirm the design satisfies EU AI Act Article 14 capabilities. Answer for each:

   | Capability (Art. 14)  | Question                                                                            | Pass? |
   | --------------------- | ----------------------------------------------------------------------------------- | ----- |
   | ¶4(a) Understand      | Can humans understand the system's capacities and limitations and detect anomalies? | Y/N   |
   | ¶4(b) Automation bias | Are humans aware of and protected from over-reliance on AI output?                  | Y/N   |
   | ¶4(c) Interpret       | Can humans correctly interpret the system's output?                                 | Y/N   |
   | ¶4(d) Override        | Can humans disregard, override, or reverse the output?                              | Y/N   |
   | ¶4(e) Stop button     | Can humans intervene OR trigger a 'stop' procedure for safe halt?                   | Y/N   |

   **All five must be YES for high-risk AI deployment to the EU.** If any are NO, the design needs revision before proceeding to `/breakdown`.

   > 🔗 **Skip if**: System is not AI-based, or is AI but not high-risk under Annex III, or not EU-targeted. Run `/eu-ai-act-check --scope` to confirm scope before applying this checkpoint.
   >
   > 🔗 **Three Loops — use claude-governance for the formal model**: The 5-capability table above is a lightweight design-time sanity check. For **formal Three Loops classification per decision** (Out-of / On-the / In-the-Loop with consequence-based gating for irreversible ops), install [`pitimon/claude-governance`](https://github.com/pitimon/claude-governance) alongside this plugin. The Three Loops Decision Model and its ADR-002 live in governance by design — `8-habit-ai-dev` references it rather than reimplementing (see `CLAUDE.md` → Plugin Boundary). Three Loops originates from human-autonomy teaming literature (Endsley 1999, DARPA) — it is a design pattern that _satisfies_ EU AI Act Article 14 ¶4(a-e), not a term used by EU law itself. Cite Article 14 ¶ refs in audits, not Three Loops labels.

6. **Document as ADR** if the decision is:
   - Hard to reverse
   - Affects >3 files
   - Changes public API

7. **H8 Checkpoint**: "Do I understand WHY we're building it this way, not just WHAT?"

## Handoff

- **Expects from predecessor** (`/requirements`): PRD summary with scope and success criteria
- **Produces for successor** (`/breakdown`): Architecture decisions (ADRs), technology choices, constraints

## When to Skip

- Solo bug fix that follows an existing, established pattern
- Cosmetic or UI-only change with no architecture impact
- Change already covered by a previously accepted ADR

## Definition of Done

- [ ] At least 2 options presented with trade-offs for each key decision
- [ ] Human has explicitly decided (not AI default) — decision recorded
- [ ] ADR created for decisions affecting >3 files or changing public API
- [ ] Constraints and non-goals documented

## Further Reading

See [Step 2 wiki page](../../docs/wiki/Step-2-Design.md) for deeper walkthrough, examples, and common pitfalls.

Load `${CLAUDE_PLUGIN_ROOT}/guides/templates/adr-template.md` for the output template.
Load `${CLAUDE_PLUGIN_ROOT}/habits/h8-find-voice.md` for the full H8 principle and examples.
