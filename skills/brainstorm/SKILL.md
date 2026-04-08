---
name: brainstorm
description: >
  Divergent thinking before convergent research — explore multiple framings of the problem
  and surface hidden assumptions before committing to solutions.
  Use BEFORE /research when the problem statement itself is fuzzy.
  Step 0a of the 7-step workflow (pre-research). Maps to H2 + H5.
user-invocable: true
argument-hint: "[problem or opportunity to brainstorm]"
allowed-tools: ["Read", "Glob", "Grep"]
prev-skill: none
next-skill: research
---

# Step 0a: Brainstorm (คิดให้กว้างก่อนลึก)

**Habit**: H2 (Begin with End in Mind) + H5 (Seek First to Understand)
**Anti-pattern**: Jumping to solutions before confirming the problem statement — "building the wrong thing efficiently"

## When to Use

Invoke `/brainstorm` BEFORE `/research` when:

- The problem statement itself feels fuzzy — you're not sure what you're really solving
- Stakeholders disagree on what the "real problem" is
- You suspect the presenting symptom is not the root cause
- You haven't written anything down yet and the idea is still in your head
- The feature request uses vague words like "improve", "fix", "optimize" without specifics

## When to Skip

- Problem is concrete and well-defined (single-line bug fix, rename refactor, formatting change)
- Research already done in a previous session and still fresh
- Requirements already documented by a human stakeholder (PM spec, design doc)
- You're continuing work on an already-scoped feature — brainstorm was already done

**Honest skip rule**: If you can write a one-sentence problem statement without handwaving, skip `/brainstorm` and go straight to `/research`.

## Brainstorm vs Research — Crisp Separation

This skill is **divergent** (no sources, no evidence). The successor `/research` is **convergent** (sources, evidence, verification). Do not conflate them:

| Phase | Skill         | Mode           | Sources              | Output                                             |
| ----- | ------------- | -------------- | -------------------- | -------------------------------------------------- |
| 0a    | `/brainstorm` | **Divergent**  | None (pure thinking) | List of framings, alternatives, hidden assumptions |
| 0     | `/research`   | **Convergent** | Codebase + external  | Research brief with citations + recommendation     |

If you catch yourself citing sources during `/brainstorm`, stop — you're in research mode. Finish brainstorming first, then invoke `/research`.

## Process

### 1. Capture the initial framing (1 min)

Write down the problem statement AS PRESENTED, verbatim. Do not refine it yet. This is the baseline.

```
Initial framing: "[exact words from the request]"
Source: [who said it — user, issue, teammate, self]
```

### 2. Generate 3 alternative framings (divergent, no filtering)

Force at least 3 alternative ways to describe the SAME problem. Each framing should be a different lens:

- **Framing A — Scope lens**: "What if the problem is bigger/smaller than stated?"
- **Framing B — Root cause lens**: "What if the presenting symptom is not the real issue?"
- **Framing C — Stakeholder lens**: "What does this look like from a different user's perspective?"

At least one framing should feel uncomfortable — if all three are just restatements of the initial framing, you haven't diverged enough.

### 3. Run 5 Whys on the presenting problem (5 min max)

Start with the initial framing. Ask "why does this matter?" 5 times, or until you hit something that changes your mind about what to solve.

```
Why #1: Why does X need to exist?
  → Because Y.
Why #2: Why does Y matter?
  → Because Z.
...
Why #5: ...
  → Root driver: [deepest WHY]
```

The root driver often differs from the presenting problem. That's the signal to update your framing.

### 4. List hidden assumptions (divergent)

What assumptions is the initial framing making that could be wrong? Aim for at least 5. Examples:

- "This must be a real-time feature" → is batch acceptable?
- "The user wants X" → did anyone ask them?
- "We need to build this in-house" → is there an existing tool?
- "This is the most important problem" → is it?
- "The constraint is technical" → is it actually organizational?

Each assumption is a potential pivot point. Do not verify them here — that's `/research`'s job. Just list them.

### 5. Synthesize: pick the best reframed problem statement

Given the alternative framings + 5 Whys + hidden assumptions, rewrite the problem statement in ONE SENTENCE:

```
Refined problem statement:
"[crisp sentence that survives scrutiny from alternative framings]"
```

Compare side-by-side with the initial framing. If they're identical, the brainstorm added no value — that's OK, sometimes the initial framing was already solid. If they differ, you just avoided building the wrong thing.

### 6. H2 + H5 Checkpoint

Before handing off to `/research`:

- **H2**: "Am I about to solve a real problem, or an invented one?"
- **H5**: "Have I understood the problem from at least 3 angles before picking a solution?"

## Output Template

```markdown
## Brainstorm: [topic]

**Date**: YYYY-MM-DD
**Initial framing**: "[verbatim from source]" (source: [who])

### Alternative Framings

- **A (scope)**: [alternative 1]
- **B (root cause)**: [alternative 2]
- **C (stakeholder)**: [alternative 3]

### 5 Whys

1. Why X? → Y
2. Why Y? → Z
3. Why Z? → ...
4. Why ...? → ...
5. Why ...? → **root driver**

### Hidden Assumptions

- [ ] Assumption 1 (could be wrong if ...)
- [ ] Assumption 2
- [ ] Assumption 3
- [ ] Assumption 4
- [ ] Assumption 5

### Refined Problem Statement

**"[one crisp sentence]"**

_Differs from initial framing?_ Yes/No. If yes, what changed and why?

### Handoff to /research

Top 2-3 questions for convergent investigation:

1. [question 1]
2. [question 2]
3. [question 3]
```

## Handoff

- **Expects from predecessor**: A fuzzy problem, feature request, or hunch. No prerequisites.
- **Produces for successor** (`/research`): Refined problem statement + 2-3 convergent questions + list of assumptions to verify

## Definition of Done

- [ ] Initial framing captured verbatim
- [ ] At least 3 alternative framings generated
- [ ] 5 Whys run to root driver
- [ ] At least 5 hidden assumptions listed (unverified — that's `/research`'s job)
- [ ] Refined problem statement written in one sentence
- [ ] H2 + H5 checkpoint answered honestly
- [ ] 2-3 questions handed off to `/research`

## Divergent Discipline

If any of these feel true during `/brainstorm`, you're in the wrong mode:

- You're citing sources → switch to `/research`
- You're verifying facts → switch to `/research`
- You're rejecting ideas as "not feasible" → stop filtering, divergent phase accepts wild ideas
- You're writing code → stop, you're 4 steps ahead of where you should be
- You're picking "the answer" → brainstorm produces a refined problem, not a solution

Brainstorm is cheap. Building the wrong thing is expensive. Err on the side of 5 extra minutes of divergence.

## References

- **Superpowers plugin** (29K stars, 143K installs): treats brainstorming as mandatory before any creative work. This skill is the 8-habit-ai-dev parity implementation.
- **5 Whys technique**: Originated at Toyota Production System (Taiichi Ohno). Used in root cause analysis across industries.
- **Divergent vs convergent thinking**: J.P. Guilford, 1950s creativity research. Separated the "generate options" phase from "evaluate options" phase.
