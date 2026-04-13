# Interview Protocol for Requirements Discovery

## Purpose

Guide structured conversation to surface requirements before formalizing them in EARS notation.

## Adaptive Depth

- **Quick** (3 core questions): When scope is small or user has clear vision
- **Standard** (5 questions): Default for most features
- **Deep** (7+ questions): Complex features, unclear scope, multiple stakeholders

## Core Discovery Questions

### Q1: What problem are you solving?

**Ask**: "What specific problem or need does this address? What happens today without it?"
**Listen for**: Pain points, workarounds, frequency of the problem
**Red flag**: If user describes a solution instead of a problem — probe deeper

### Q2: Who is affected?

**Ask**: "Who are the primary users? Are there secondary stakeholders?"
**Listen for**: User roles, personas, permission levels, edge-case users
**Red flag**: "Everyone" — push for specifics

### Q3: What does success look like?

**Ask**: "If this ships perfectly, what's different? How would you demo it?"
**Listen for**: Observable behaviors, measurable outcomes, specific scenarios
**Red flag**: Vague outcomes like "it works better" — ask for a concrete example

### Q4: What are the boundaries?

**Ask**: "What is explicitly OUT of scope? What should this NOT do?"
**Listen for**: Adjacent features to exclude, performance limits, platform constraints
**Red flag**: No boundaries stated — every feature has limits, probe for them

### Q5: What exists already?

**Ask**: "Is there existing code, APIs, or patterns we should build on or avoid?"
**Listen for**: Technical constraints, legacy systems, established patterns, tech debt
**Red flag**: Assumptions about architecture — verify with codebase

### Q6 (Deep): What could go wrong?

**Ask**: "What are the riskiest parts? What would make this fail?"
**Listen for**: Security concerns, performance bottlenecks, integration risks, data integrity
**Red flag**: "Nothing" — every feature has risks

### Q7 (Deep): How will we know it's done?

**Ask**: "What specific tests or checks would prove this works?"
**Listen for**: Acceptance criteria, edge cases, regression concerns
**Red flag**: No testable criteria — requirements aren't ready yet

## Stop Conditions

Stop the interview when you can:

1. Write 3+ EARS criteria (Event/Action/Response/State)
2. Define clear scope boundaries (in-scope AND out-of-scope)
3. Identify the primary user and their success scenario
4. Name at least one risk or constraint

If you can't do all 4, ask more questions.

## "Listen For" Signal Reference

| Signal | Meaning | Action |
|--------|---------|--------|
| Natural boundaries | User describes distinct components | Map to potential modules/phases |
| Ordering intuition | "First we need X, then Y" | Capture dependency chain |
| Uncertainty | "I'm not sure about..." | Flag for /design discussion |
| Existing context | "We already have..." | Read that code before specifying |
| Scope creep | "And also..." repeated | Gently redirect to boundaries (Q4) |

## Handoff to EARS

After the interview, use findings to write EARS criteria:

- **Event**: "When [trigger from Q1/Q3]..."
- **Action**: "The system shall [behavior from Q3]..."
- **Response**: "[Observable outcome from Q3/Q7]..."
- **State**: "While [condition from Q4/Q5]..."
