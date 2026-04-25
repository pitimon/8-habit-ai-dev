# Maturity Model

> [!IMPORTANT]
> The maturity model is not a judgment — it is a signal that lets the plugin meet you where you are, not where the template assumes.

The plugin adapts its guidance based on your self-assessed maturity level. A beginner gets full scaffolding; an expert gets minimal prompts. This prevents the common complaint about workflow tools: "too much ceremony for experienced users" or "not enough guidance for new ones."

## The 4 Levels

Based on Covey's maturity continuum, extended with the 8th Habit's Significance level:

```
   Dependence       full guidance — all examples, checkpoints, templates
        │
        ▼
   Independence     key checkpoints — skip beginner detail, trust user
        │
        ▼
   Interdependence  team focus — delegation, parallel execution, synergy
        │
        ▼
   Significance     minimal prompts — expert mode, flag exceptions only
```

| Level               | You are...                                                  | Plugin behavior                                                                                          |
| ------------------- | ----------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| **Dependence**      | New to structured AI dev. Need scaffolding to build habits. | Full guidance: all examples shown, all checkpoints explained, templates provided, skip rules spelled out |
| **Independence**    | Self-directed. Have foundations but still refining.         | Key checkpoints only: skip beginner explanations, show decision points, trust you to fill in details     |
| **Interdependence** | Team-embedded. Lead or mentor others.                       | Team and synergy focus: delegation patterns, review quality, parallel execution, minimal solo ceremony   |
| **Significance**    | Set standards. Define how others work.                      | Minimal prompts: expert mode, only flag exceptions, trust judgment on process, focus on meta-system      |

## How to Calibrate

Run `/calibrate` in Claude Code. The skill asks 5-7 questions about your development practices:

1. How do you typically start a new feature?
2. What happens after you write code?
3. How do you handle architecture decisions?
4. How do you work with AI assistants?
5. How do you share knowledge with your team?

Based on your answers, the skill identifies your dominant maturity level and writes a profile.

> [!TIP]
> You don't need to calibrate before using the plugin. It defaults to Independence level if no profile exists. Calibrate when you want more or less guidance than the default provides.

## Where the Profile Lives

The profile is stored at `~/.claude/habit-profile.md` — global, per-user, not per-project. Format:

```yaml
---
schema-version: 1
dominant-level: interdependence
assessed-date: 2026-04-15
---
## Assessment Summary
...
```

See [`guides/habit-profile-schema.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/guides/habit-profile-schema.md) for the full schema specification.

## How Skills Adapt

The adaptation happens at session start, not per-skill:

1. `hooks/session-start.sh` reads `~/.claude/habit-profile.md`
2. Emits a level-specific directive into session context
3. All 17 skills automatically adapt their verbosity — **zero per-skill changes needed**

This means a single calibration affects every skill invocation for the rest of the session. The canonical adaptation rules are in [`guides/verbosity-adaptation.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/guides/verbosity-adaptation.md).

## Opting Out

If you've internalized the workflow and find even the session-start reminder distracting:

```bash
export HABIT_QUIET=1
```

This suppresses the session-start banner entirely. Skills still work when invoked — only the automatic reminder is silenced. See [ADR-006](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-006-audience-honesty-and-superpowers-deferral.md) for rationale.

## Re-Calibration

Your maturity level changes over time. After ~90 days, consider re-running `/calibrate` — especially if:

- You've moved to a new team or role
- You've adopted or dropped development practices
- The plugin guidance feels too detailed or too sparse

## Connection to the Three Loops

The maturity levels map naturally to the decision authority model:

| Level           | Primary Loop              | Decision style                                              |
| --------------- | ------------------------- | ----------------------------------------------------------- |
| Dependence      | In-the-Loop               | Human decides everything, AI assists step by step           |
| Independence    | On-the-Loop               | AI proposes, human reviews and approves                     |
| Interdependence | On-the-Loop → Out-of-Loop | Team delegates well-scoped tasks to AI                      |
| Significance    | Out-of-Loop + Voice       | AI executes within guardrails; human defines the guardrails |

## See also

- [`/calibrate`](Skills-Reference#calibrate) — the self-assessment skill
- [Architecture](Architecture) — how the hook-based adaptation works
- [8 Habits → H8 Find Your Voice](Habits-Reference#habit-8-find-your-voice-and-inspire-others) — the principle behind adaptive guidance
- [ADR-008](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-008-user-maturity-calibration-design.md) — design decisions
