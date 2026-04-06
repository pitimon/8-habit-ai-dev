---
name: whole-person-check
description: >
  Assess a feature, component, or PR against Covey's 4 dimensions: Body, Mind, Heart, Spirit.
  Use to evaluate balance across discipline, vision, passion, and conscience.
  Maps to H8 (Find Your Voice — Whole Person Model).
user-invocable: true
argument-hint: "[feature, component, or PR to assess]"
allowed-tools: ["Read", "Glob", "Grep"]
prev-skill: any
next-skill: any
---

# Whole Person Check (ประเมิน 4 มิติ)

**Habit**: H8 — Find Your Voice | **Anti-pattern**: Optimizing only for technical correctness while neglecting craft, empathy, and ethics

## Why This Exists

AI-assisted development excels at Body (CI, tests) and Mind (architecture, design) but systematically neglects Heart (craft quality, user empathy) and Spirit (security conscience, ethical judgment). This assessment makes the gap visible and actionable.

## Process

1. **Identify the scope**: What feature, component, or PR is being assessed?

2. **Read the relevant code and docs**: Understand what exists before scoring.

3. **Score each dimension** (1-5) using the indicators below:

### Body (PQ/Discipline) — "Is it reliable and well-built?"

| Score | Indicator                                                     |
| ----- | ------------------------------------------------------------- |
| 1     | No tests, no CI, manual everything                            |
| 2     | Some tests exist but gaps, CI runs but not enforced           |
| 3     | CI green, tests cover core paths, coding standards followed   |
| 4     | >80% coverage, automated quality gates, monitoring configured |
| 5     | Fitness functions, self-healing, chaos-tested                 |

### Mind (IQ/Vision) — "Do we know where this is going?"

| Score | Indicator                                                                    |
| ----- | ---------------------------------------------------------------------------- |
| 1     | No docs, no design rationale, ad-hoc implementation                          |
| 2     | README exists but outdated, some inline comments                             |
| 3     | Architecture documented, ADR for key decisions, roadmap clear                |
| 4     | Design reviewed before implementation, tech debt tracked, patterns reusable  |
| 5     | Evolutionary architecture, fitness functions, strategy aligned with business |

### Heart (EQ/Passion) — "Would I want to use this?"

| Score | Indicator                                                               |
| ----- | ----------------------------------------------------------------------- |
| 1     | Error messages say "failed", no onboarding docs, code hard to read      |
| 2     | Basic error messages, some docs, code readable with effort              |
| 3     | Errors explain what went wrong AND how to fix, code readable in 5 min   |
| 4     | Empathetic error design, DX considered, mentoring visible in reviews    |
| 5     | Craft pride visible, active DX improvement, knowledge shared externally |

### Spirit (SQ/Conscience) — "Should we build this?"

| Score | Indicator                                                                        |
| ----- | -------------------------------------------------------------------------------- |
| 1     | No security review, no ethical consideration, compliance ignored                 |
| 2     | Basic input validation, secrets in env vars, HTTPS enforced                      |
| 3     | Security-by-design, privacy-by-default, "should we?" question asked              |
| 4     | Threat model exists, accessibility standards, compliance proactive               |
| 5     | Ethical impact assessed, knowledge shared with community, responsible disclosure |

4. **Identify gaps**: Flag any dimension scoring ≥2 points below the highest.

5. **H8 Checkpoint**: "Am I contributing something meaningful, or just completing a task?"

## Output

```
## Whole Person Assessment
**Scope**: [feature/component/PR name]

| Dimension | Score | Key Evidence |
|-----------|-------|-------------|
| Body (Discipline) | [1-5] | [1-line evidence] |
| Mind (Vision)     | [1-5] | [1-line evidence] |
| Heart (Passion)   | [1-5] | [1-line evidence] |
| Spirit (Conscience) | [1-5] | [1-line evidence] |

**Overall**: [average]/5
**Balance**: [balanced | imbalanced — specify gap]
**AI Blind Spot**: [flag if Heart or Spirit lags Body/Mind by ≥2]

### Recommendations
- [specific actions to address gaps]
```

## When to Skip

- Single-line bug fix or typo correction
- Dependency version bump with passing CI
- Already assessed in current session and scope unchanged

## Definition of Done

- [ ] All 4 dimensions scored with evidence
- [ ] Gaps identified (any dimension ≥2 below highest)
- [ ] AI Blind Spot flagged if Heart/Spirit lag Body/Mind
- [ ] At least 1 actionable recommendation per gap

Load `${CLAUDE_PLUGIN_ROOT}/guides/whole-person-rubrics.md` for detailed rubric definitions.
Load `${CLAUDE_PLUGIN_ROOT}/habits/h8-find-voice.md` for the full H8 principle and examples.
