# Whole Person Rubrics

**Concrete indicators at 3 maturity levels per dimension.**

Synthesized from Covey's Whole Person Model, CMMI, Westrum culture model, DORA metrics, and Software Craftsmanship movement. Three levels map to Covey's progression: Dependence → Independence → Interdependence.

## How to Use

Rate each dimension at Level 1, 2, or 3 based on observable indicators (not aspirations). If you meet ALL indicators at a level, you qualify for that level. Partial = previous level.

## Body (PQ/Discipline) — "Is the system reliable and well-built?"

| Level | Name        | Observable Indicators                                                                                                |
| ----- | ----------- | -------------------------------------------------------------------------------------------------------------------- |
| 1     | Reactive    | Manual deploys, tests run occasionally, no CI pipeline, ad-hoc standards                                             |
| 2     | Proactive   | CI/CD pipeline green, test coverage >80%, documented coding standards, automated linting                             |
| 3     | Significant | Quality gates enforce standards automatically, monitoring with alerting, fitness functions track architecture health |

**Key question**: "If we deployed right now, would we sleep well tonight?"

## Mind (IQ/Vision) — "Do we know where the system is going?"

| Level | Name        | Observable Indicators                                                                                                                           |
| ----- | ----------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| 1     | Reactive    | No architecture docs, reactive feature work only, decisions made ad-hoc                                                                         |
| 2     | Proactive   | ADRs for major decisions, clear roadmap exists, design reviews before implementation, tech debt tracked explicitly                              |
| 3     | Significant | Evolutionary architecture with measurable fitness functions, technology strategy aligned with business goals, patterns published for team reuse |

**Key question**: "Can a new team member understand our direction in 30 minutes?"

## Heart (EQ/Passion) — "Does this feel right? Would I want to use this?"

| Level | Name        | Observable Indicators                                                                                                                                          |
| ----- | ----------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1     | Reactive    | No code review culture, error messages say "failed" or "error", no onboarding docs, "just ship it" mindset                                                     |
| 2     | Proactive   | Constructive code review culture, error messages explain what went wrong AND how to fix it, README and onboarding docs maintained                              |
| 3     | Significant | Craftsmanship pride visible in code, active mentoring and knowledge sharing, empathetic error design that guides users, developer experience actively improved |

**Key question**: "Would I be proud to show this code to a colleague?"

## Spirit (SQ/Conscience) — "Should we build this? What are the consequences?"

| Level | Name        | Observable Indicators                                                                                                                                                                         |
| ----- | ----------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1     | Reactive    | No security review process, no ethical consideration, compliance only when forced                                                                                                             |
| 2     | Proactive   | Security-by-design (validated inputs, parameterized queries, secrets in env vars), privacy-by-default, accessibility standards followed                                                       |
| 3     | Significant | "Should we build this?" is a standard question before starting, knowledge shared with community (open source, blog posts, talks), responsible disclosure practiced, ethical impact considered |

**Key question**: "If this decision were public, would we be comfortable explaining it?"

## The AI Blind Spot

AI-assisted development systematically excels at Body and Mind but tends to neglect Heart and Spirit:

| Dimension | AI Strength                                              | Human Strength                                                 |
| --------- | -------------------------------------------------------- | -------------------------------------------------------------- |
| Body      | Generates tests, enforces lint rules, creates CI configs | Judges when to skip process for pragmatism                     |
| Mind      | Produces architecture docs, evaluates trade-offs         | Provides business context and strategic judgment               |
| Heart     | Can follow empathetic patterns if instructed             | Genuine user empathy, aesthetic judgment, craft pride          |
| Spirit    | Can run security scans, check compliance lists           | Ethical reasoning, "should we?" judgment, community conscience |

When reviewing AI-generated work, pay extra attention to Heart and Spirit dimensions — they are where human judgment is most irreplaceable.

---

_Referenced by `/whole-person-check` and `/cross-verify`. Back to [README](../README.md)_
