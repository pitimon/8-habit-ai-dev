# Step 2 · Design

**Command**: `/design [component]` · **Habit**: H8 Find Your Voice · **Previous**: [Step 1 · Requirements](Step-1-Requirements) · **Next**: [Step 3 · Breakdown](Step-3-Breakdown)

## Purpose

Make architecture decisions **with human judgment**. AI proposes options and trade-offs; the human decides. This is the most important checkpoint in the workflow — architecture is hard to reverse.

## When to use

- Any change affecting >3 files
- Any change to public API or data schema
- Any change to auth, authorization, or data flow
- Any change introducing a new dependency

## When to skip

- Change follows an existing, established pattern
- Cosmetic / UI-only with no architecture impact
- Already covered by a previously accepted ADR

## Process

1. Read existing `CLAUDE.md`, `DESIGN.md`, `ARCHITECTURE.md`, `docs/adr/`
2. Identify decisions needing human input (DB, auth, API, boundaries, deps)
3. Present **at least 2 options with trade-offs** for each decision
4. **Human decides** — record the choice
5. Write an **ADR** if the decision affects >3 files or changes public API

## Output

Decision document or ADR following `guides/templates/adr-template.md`:

```
## Decision: [Topic]
**Option A**: ... — Pro/Con
**Option B**: ... — Pro/Con
**Recommendation**: ...
**Chosen**: [by human]
```

## Handoff

- **Expects**: PRD summary from `/requirements`
- **Produces for `/breakdown`**: Architecture decisions, technology choices, constraints

## H8 Checkpoint

> [!IMPORTANT]
> _"Do I understand WHY we're building it this way, not just WHAT?"_

## Sticky Decisions (v2.8.0)

Some decisions act as **sticky latches** — once set, reversing them mid-session wastes all context built on top. For each decision, ask: _"If we change this after implementation starts, how much rework?"_

| Rework | Classification                                    | Example                          |
| ------ | ------------------------------------------------- | -------------------------------- |
| >50%   | **Sticky** — revisit only via new `/design` cycle | DB choice, auth model, API style |
| 10-50% | **Semi-sticky** — adjustable but flag the cost    | ORM, test framework              |
| <10%   | **Flexible** — change freely                      | Variable names, UI copy          |

Mark sticky decisions in the ADR: **STICKY — changing this requires re-running `/design`, not patching mid-build.**

## Three Loops reminder

Architecture decisions are **In-the-Loop** — human decides, not AI. Irreversible decisions (data migration, breaking API change) are always In-the-Loop regardless of perceived simplicity.

## See also

- [Source: `skills/design/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/design/SKILL.md)
- [Habits Reference → H8](Habits-Reference#habit-8-find-your-voice-and-inspire-others)
- [`docs/adr/` template](https://github.com/pitimon/8-habit-ai-dev/tree/main/guides/templates/adr-template.md)
