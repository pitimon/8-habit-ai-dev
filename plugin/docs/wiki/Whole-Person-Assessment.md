# Whole Person Assessment

The `/whole-person-check` skill evaluates work across Covey's 4 dimensions — Body, Mind, Heart, Spirit. AI-assisted development systematically scores high on Body and Mind (its strengths) and low on Heart and Spirit; this assessment makes that gap visible so teams can compensate.

| Dimension               | What It Measures                            | AI Strength         |
| ----------------------- | ------------------------------------------- | ------------------- |
| **Body** (Discipline)   | CI, tests, monitoring, quality gates        | Strong — AI excels  |
| **Mind** (Vision)       | Architecture, ADRs, roadmap, tech debt      | Strong — AI excels  |
| **Heart** (Passion)     | Craft quality, empathetic errors, UX, DX    | Weak — needs humans |
| **Spirit** (Conscience) | Security-first, ethics, compliance, sharing | Weak — needs humans |

## Worked Example: A REST API Feature

After building a user authentication API, `/whole-person-check` might produce:

| Dimension | Score | Finding                                                     |
| --------- | ----- | ----------------------------------------------------------- |
| Body      | 4/5   | CI green, 85% coverage, but no load test                    |
| Mind      | 5/5   | ADR documented, JWT vs session decision recorded            |
| Heart     | 2/5   | Error messages return raw 500s, no onboarding guide         |
| Spirit    | 3/5   | Input validation present, but no rate limiting or audit log |

**AI Blind Spot visible**: Body and Mind scored high (AI's strength). Heart and Spirit scored low (needs human attention).

**Action**: Before shipping, add user-friendly error messages (Heart) and rate limiting with audit logging (Spirit). These are the gaps AI won't catch on its own.

## Maturity Rubrics

3 levels per dimension (Reactive → Proactive → Significant): see `guides/whole-person-rubrics.md` in the repository.

## Plugin's Own Progression

The plugin dogfoods this assessment on itself:

```
v1.2.0  ████████████░░░░░░░░  3.0   (honest reassessment after inflated 4.5)
v1.9.0  ██████████████████░░  4.5   (evidence grounding + integrity)
v2.0.0  ██████████████████░░  4.625 (orchestration + meta-system)
v2.1.0  ███████████████████░  4.75  (verification agent + research rigor)
v2.2.0  ████████████████████  5.0   (content validation + fitness functions)
```

Full self-assessment: `SELF-CHECK.md` in the repository.

## See Also

- [Habits Reference](Habits-Reference)
- [Maturity Model](Maturity-Model)
- [Skills Reference](Skills-Reference)
