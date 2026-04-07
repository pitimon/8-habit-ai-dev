---
name: requirements
description: >
  Generate PRD from user intent — define what, why, who, scope, and success criteria.
  Use BEFORE starting any feature. Step 1 of 7-step workflow. Maps to H2 (Begin with End in Mind).
user-invocable: true
argument-hint: "[feature description]"
allowed-tools: ["Read", "Glob", "Grep"]
prev-skill: research
next-skill: design
---

# Step 1: Requirements (คิดก่อนทำ)

**Habit**: H2 — Begin with End in Mind | **Anti-pattern**: Starting to code without knowing what "done" looks like

## Process

1. **Clarify intent**: Ask the user (or derive from context):
   - What are we building?
   - Why are we building it?
   - Who is it for?
   - What is in scope / out of scope?

2. **Check existing docs**: Read `CLAUDE.md`, `PRD.md`, `DOMAIN.md`, or `README.md` if they exist — don't duplicate what's already defined.

3. **Draft PRD summary** (keep concise — 10-20 lines):

   ```
   ## Feature: [Name]
   **What**: [1-2 sentences]
   **Why**: [Problem it solves]
   **Who**: [Target user]
   **In scope**: [Bullet list]
   **Out of scope**: [Bullet list]
   **Success criteria**: [3-5 verifiable conditions]
   **Definition of Done**: [What must be true before this is "done"]
   ```

4. **H2 Checkpoint**: "Can I describe what success looks like before writing code?"

## When to Skip

- Single-line bug fixes with obvious root cause
- Formatting or linting changes
- Dependency version bumps

## Handoff

- **Expects from predecessor**: User intent — a feature idea, bug report, or problem statement. If `/research` was run, a research brief with findings, constraints, comparison matrix (if applicable), and recommendation
- **Produces for successor** (`/design`): PRD summary with What/Why/Who/Scope/Success criteria

## Definition of Done

- [ ] PRD summary exists with What/Why/Who/Scope sections filled
- [ ] 3-5 concrete, verifiable success criteria defined
- [ ] Scope boundaries clear — both "in scope" and "out of scope" listed
- [ ] Stakeholder/target user identified

Load `${CLAUDE_PLUGIN_ROOT}/guides/templates/prd-template.md` for the output template.
Load `${CLAUDE_PLUGIN_ROOT}/habits/h2-begin-with-end.md` for the full H2 principle and examples.
