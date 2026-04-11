# Skill Effectiveness Report

**Status**: Maintainer-curated trend tracker (v2.6.1) | **Updated by**: Plugin maintainer | **Data source**: `~/.claude/lessons/*.md` — `## Skill effectiveness` section | **Related**: [Issue #92](https://github.com/pitimon/8-habit-ai-dev/issues/92), [`skills/reflect/SKILL.md`](skills/reflect/SKILL.md) Q6

## Purpose

Systematic tracking of which 8-habit skills users find **most useful** and which they find **least useful or confusing** over time. This is **H7 (Sharpen the Saw) applied to the plugin itself** — invest in the capability of the skills, not just the output they produce.

Without a signal like this, skills drift: some become verbose padding, some get forgotten, some quietly confuse users who never say so. `/reflect` Q6 is the cheapest possible signal — one skill name per session, or "n/a".

## How the data flows

```
User runs a task → invokes /reflect → answers Q6 (most useful / least useful)
  ↓
/reflect writes ~/.claude/lessons/YYYY-MM-DD-<slug>.md with `## Skill effectiveness` section
  ↓
(user-local — lives in user home, not plugin repo, not shared automatically)
  ↓
Periodically (monthly / per release), maintainer reads their own lessons
  (and contributor reports if shared) and updates this file
  ↓
Trend analysis informs /skill-improve cycles, skill deprecation, and scope decisions
```

## What this file is NOT

- ❌ **Not auto-generated** — skills are read-only guidance, not runtime aggregators. Cross-file lesson scanning would need either a runtime component (belongs in `claude-governance` per plugin boundary) or a manual maintainer step. This doc chooses manual.
- ❌ **Not enforcement** — low scores do not block skill invocation or trigger automated deprecation. Humans read, humans decide.
- ❌ **Not a ranking** — "least useful in context A" can be "most useful in context B". Trend notes capture nuance the raw count cannot.
- ❌ **Not a leaderboard** — the goal is improvement signal, not competition between skills.

## Maintainer update protocol

When updating this file:

1. **Read lesson files**: `ls ~/.claude/lessons/*.md` on the maintainer's machine, plus any contributor reports shared via PR or issue.
2. **Extract Q6 data**: `grep -A 3 '## Skill effectiveness' ~/.claude/lessons/*.md` — harvest "Most useful" and "Least useful / confusing" lines.
3. **Tally**: increment per-skill counters in the table below. Skip `n/a` entries.
4. **Update `Last updated`**, `Lessons analyzed`, and any **trend notes** per skill.
5. **Flag for action**: if a skill accumulates ≥5 "least useful/confusing" signals without offsetting "most useful" signals over a rolling 3-release window, add it to the Action Items section below for `/skill-improve` review or scope reconsideration.
6. **Commit** the updated report alongside other maintenance in a `chore(skill-eff): update report` commit.

## Current tally

**Last updated**: 2026-04-11 (initial state, ships with v2.6.1)
**Lessons analyzed**: 0
**Status**: Awaiting data — no user reflections captured since Q6 was added

| Skill | Most useful | Least useful / confusing | Trend notes |
|---|---|---|---|
| `/research` | 0 | 0 | — |
| `/requirements` | 0 | 0 | — |
| `/design` | 0 | 0 | — |
| `/breakdown` | 0 | 0 | — |
| `/build-brief` | 0 | 0 | — |
| `/review-ai` | 0 | 0 | — |
| `/deploy-guide` | 0 | 0 | — |
| `/monitor-setup` | 0 | 0 | — |
| `/cross-verify` | 0 | 0 | — |
| `/whole-person-check` | 0 | 0 | — |
| `/security-check` | 0 | 0 | — |
| `/using-8-habits` | 0 | 0 | — |
| `/eu-ai-act-check` | 0 | 0 | — |
| `/ai-dev-log` | 0 | 0 | — |
| `/reflect` | 0 | 0 | — |
| `/calibrate` | 0 | 0 | — |
| `/workflow` | 0 | 0 | — |

**Total skills tracked**: 17 (matches v2.6.0+ skill count)

## Action items (from trend analysis)

_None yet — awaiting data accumulation._

Future entries here will look like:

> **[Skill name] trending negative (v2.6.x)**: N reflections flagged this as least useful/confusing without offsetting positive signal. Common confusion: [brief pattern]. Recommended action: `/skill-improve` cycle focusing on [dimension]. Owner: [maintainer].

## References

- **Issue [#92](https://github.com/pitimon/8-habit-ai-dev/issues/92)**: Skill Effectiveness Tracking — H7 applied to the plugin itself
- **`skills/reflect/SKILL.md` Q6**: the data source (skill effectiveness signal)
- **`guides/templates/lesson-template.md`**: template that defines the `## Skill effectiveness` section structure
- **Issue #88**: Persistent Reflection Artifacts — the underlying persistence layer this builds on
- **Plugin boundary note**: this is a maintainer-curated report, **not** an auto-aggregator. A runtime aggregator that scans `~/.claude/lessons/*.md` across users would belong in [`pitimon/claude-governance`](https://github.com/pitimon/claude-governance), not here — per [CLAUDE.md § Plugin Boundary](CLAUDE.md).
