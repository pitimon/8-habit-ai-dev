---
name: design
description: >
  Produce architecture decisions — DB, auth, API, constraints.
  Use AFTER /requirements and BEFORE /breakdown. Step 2 of 7-step workflow. Maps to H8 (Find Your Voice).
user-invocable: true
argument-hint: "[--persist <slug>] [component or system to design]"
allowed-tools: ["Read", "Glob", "Grep", "Write", "AskUserQuestion"]
prev-skill: requirements
next-skill: breakdown
---

# Step 2: Design (วางโครงสร้าง)

**Habit**: H8 — Find Your Voice | **Anti-pattern**: Letting AI decide architecture without human judgment

## Process

1. **Read existing architecture**: Check `CLAUDE.md`, `DESIGN.md`, `ARCHITECTURE.md`, `ADR/` directory — understand current state before proposing changes.

1b. **Validate scope alignment**: If a `SKILL_OUTPUT:requirements` block exists in the PRD output, read it and verify:

- Proposed architecture decisions don't expand beyond `scope_in`
- Success criteria are achievable with the proposed design
- Identified `risks` are addressed or accepted in design constraints

2. **Identify decisions** that need human input:
   - Database choice and schema
   - Authentication/authorization approach
   - API contract (REST, GraphQL, MCP)
   - Service boundaries
   - Language and runtime (if greenfield or migration)
   - Framework selection (when alternatives exist)
   - Third-party dependencies

3. **Present options** with trade-offs (not just one recommendation):

   ```
   ## Decision: [Topic]
   **Option A**: [Description] — Pro: [x], Con: [y]
   **Option B**: [Description] — Pro: [x], Con: [y]
   **Recommendation**: [Which and why]
   ```

4. **Human must decide**: AI proposes, human disposes. Mark each decision as In-the-Loop.

5. **Identify sticky decisions** (decisions that should not change mid-implementation):

   Some decisions act as **sticky latches** — once set, reversing them mid-session wastes all context built on top of them. Claude Code uses this pattern internally: boolean flags that once true, never revert, because toggling would invalidate the prompt cache (90% cost saving lost).

   For each decision in step 4, ask: **"If we change this after implementation starts, how much rework does it cause?"**

   | Rework Level | Classification                                                | Example                          |
   | ------------ | ------------------------------------------------------------- | -------------------------------- |
   | >50% redo    | **Sticky** — commit now, revisit only via new `/design` cycle | DB choice, auth model, API style |
   | 10-50% redo  | **Semi-sticky** — can adjust but flag the cost                | ORM choice, test framework       |
   | <10% redo    | **Flexible** — change freely during implementation            | Variable names, UI copy          |

   Mark sticky decisions explicitly in the ADR or design doc:

   > **STICKY**: This decision is load-bearing. Changing it requires re-running `/design`, not patching mid-build.

   This is H2 in practice: define done before starting, including which decisions ARE the definition of done.

5b. **Decision granularity heuristic** (H3):

- If one decision affects >3 layers (data + API + auth + UI), split into sub-decisions
- If multiple decisions share the same trade-offs, group them into one ADR
- Each ADR should have exactly one "Decision maker" — avoid committee deadlock

6. **Article 14 Human-Oversight Checkpoint** (for AI-system designs):

   If the system being designed is an **AI system that may target the EU market** (or any high-risk AI system regardless of market), confirm the design satisfies EU AI Act Article 14 capabilities. Answer for each:

   | Capability (Art. 14)  | Question                                                                            | Pass? |
   | --------------------- | ----------------------------------------------------------------------------------- | ----- |
   | ¶4(a) Understand      | Can humans understand the system's capacities and limitations and detect anomalies? | Y/N   |
   | ¶4(b) Automation bias | Are humans aware of and protected from over-reliance on AI output?                  | Y/N   |
   | ¶4(c) Interpret       | Can humans correctly interpret the system's output?                                 | Y/N   |
   | ¶4(d) Override        | Can humans disregard, override, or reverse the output?                              | Y/N   |
   | ¶4(e) Stop button     | Can humans intervene OR trigger a 'stop' procedure for safe halt?                   | Y/N   |

   **All five must be YES for high-risk AI deployment to the EU.** If any are NO, the design needs revision before proceeding to `/breakdown`.

   > 🔗 **Skip if**: System is not AI-based, or is AI but not high-risk under Annex III, or not EU-targeted. For formal scope pre-flight, install [`pitimon/claude-governance`](https://github.com/pitimon/claude-governance) v3.1.0+ and run `/eu-ai-act-check --scope` (the canonical skill, migrated from this plugin on 2026-05-02 per ADR-012).
   >
   > 🔗 **Three Loops — use claude-governance for the formal model**: The 5-capability table above is a lightweight design-time sanity check. For **formal Three Loops classification per decision** (Out-of / On-the / In-the-Loop with consequence-based gating for irreversible ops), install [`pitimon/claude-governance`](https://github.com/pitimon/claude-governance) alongside this plugin. The Three Loops Decision Model and its ADR-002 live in governance by design — `8-habit-ai-dev` references it rather than reimplementing (see `CLAUDE.md` → Plugin Boundary). Three Loops originates from human-autonomy teaming literature (Endsley 1999, DARPA) — it is a design pattern that _satisfies_ EU AI Act Article 14 ¶4(a-e), not a term used by EU law itself. Cite Article 14 ¶ refs in audits, not Three Loops labels.

7. **Document as ADR** if the decision is:
   - Hard to reverse
   - Affects >3 files
   - Changes public API

8. **H8 Checkpoint**: "Do I understand WHY we're building it this way, not just WHAT?"
   Also check all 4 dimensions: Body (CI/infra ready?), Mind (serves roadmap?), Heart (good DX/UX?), Spirit (security/ethics defaults baked in?).

## Handoff

- **Expects from predecessor** (`/requirements`): PRD summary with scope and success criteria
- **Produces for successor** (`/breakdown`): Architecture decisions (ADRs), technology choices, constraints

## Optional Persistence (`--persist <slug>`)

When invoked with `--persist <slug>`, this skill writes its design output to `docs/specs/<slug>/design.md` in addition to emitting the conversation `SKILL_OUTPUT:design` block. Without the flag, behavior is byte-identical to v2.14.3 (no file writes).

For the canonical convention (slug regex `^[a-z0-9][a-z0-9-]{1,63}$`, conflict policy, YAML frontmatter format, error message rules, ID-linkage `Decision-N` guidance), load `${CLAUDE_PLUGIN_ROOT}/guides/persistence-convention.md`.

ID-linkage tip: when persisting, label each decision as `### Decision-N: <topic>` and cite covered requirements as `Decision-N covers: FR-001, FR-003` to enable deterministic Coverage and Inconsistency passes in `/consistency-check`. IDs are recommended, not required.

## When to Skip

- Solo bug fix that follows an existing, established pattern
- Cosmetic or UI-only change with no architecture impact
- Change already covered by a previously accepted ADR

## Definition of Done

- [ ] At least 2 options presented with trade-offs for each key decision
- [ ] Human has explicitly decided (not AI default) — decision recorded
- [ ] ADR created for decisions affecting >3 files or changing public API
- [ ] Constraints and non-goals documented

## Structured Output

After documenting design decisions, append a structured output block for cross-skill handoff. This HTML comment is invisible when rendered but enables `/cross-verify` to auto-check design coverage:

```
[/design] COMPLETE SKILL_OUTPUT:design
<!-- SKILL_OUTPUT:design
decision_count: [N]
decisions:
  - "[decision 1: e.g., PostgreSQL for persistence]"
  - "[decision 2: e.g., REST API with versioned endpoints]"
sticky_decisions:
  - "[sticky 1: e.g., PostgreSQL — >50% rework to change]"
constraints:
  - "[constraint 1]"
adr_references:
  - "[ADR-NNN: title]"
article_14_applicable: [true|false]
article_14_pass: [true|false|n/a]
END_SKILL_OUTPUT -->
```

Place this at the very end of the design output, after all human-readable content.

## Further Reading

See [Step 2 wiki page](../../docs/wiki/Step-2-Design.md) for deeper walkthrough, examples, and common pitfalls.

Load `${CLAUDE_PLUGIN_ROOT}/guides/templates/adr-template.md` for the output template.
Load `${CLAUDE_PLUGIN_ROOT}/habits/h8-find-voice.md` for the full H8 principle and examples.
Load `${CLAUDE_PLUGIN_ROOT}/guides/persistence-convention.md` when `--persist <slug>` is used (canonical spec for opt-in persistence to `docs/specs/<slug>/design.md`).
