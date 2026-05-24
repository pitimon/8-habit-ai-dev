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

**Last updated**: 2026-05-24 (per ADR-018 memory-layer activation — first real-data harvest after 13-month dormancy)
**Lessons analyzed**: 43 (35 with primary 8-habit skill signal · 4 explicit `n/a` · 4 cited non-8-habit skills/agents only)
**Status**: First-pass tally complete. Signal is real but skewed — heavy left tail on three skills, 12 skills remain at 0.

> **v2.18.3 release pulse (2026-05-24, same-day re-release)** — tally unchanged. v2.18.3 ships `guides/anthropic-engineering-doctrine-audit.md` (contributor-doctrine deposit, no new skill invocations) within hours of the v2.18.2 first-harvest cycle, so no new Q6 signal to harvest. Next tally update at the release after the next non-trivial cycle of skill invocations accumulates. Anti-dormancy forcing function (ADR-018) honored via this release-pulse note rather than a false-claim tally bump.

| Skill                           | Most useful   | Least useful / confusing | Trend notes                                                                                                                                                                                                                                                                                                                              |
| ------------------------------- | ------------- | ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `/research`                     | 5             | 0                        | Compare mode + Audit mode cited as load-bearing in 4 of 5 — comparison-matrix discipline catches duplication before re-proposing already-rejected mechanics                                                                                                                                                                              |
| `/requirements`                 | 0             | 0                        | No data — typically skipped for sub-3-files-changed; expected n=low                                                                                                                                                                                                                                                                      |
| `/design`                       | 1             | 2                        | ⚠️ Negative-net signal (1 most, 2 least). Friction theme: "2+ options expectation feels ceremonial when prior locks force the decision" + "produces full architecture before upstream premises verified". Not enough data for action (threshold n≥5 negative); watch over next 3 releases. See `/design` ADR if invoked                  |
| `/breakdown`                    | 2             | 0                        | Atomic task decomposition + verification-command-per-task discipline cited positively                                                                                                                                                                                                                                                    |
| `/build-brief`                  | 1             | 1                        | Even split. Negative cite: "redundant in solo flows where same agent plans + implements". Consider marking optional rather than default for post-`/design` solo flows                                                                                                                                                                    |
| `/review-ai`                    | 0             | 0                        | No data — review work delegated to `8-habit-reviewer` agent or external `/code-review`, not the workflow skill                                                                                                                                                                                                                           |
| `/deploy-guide`                 | 0             | 0                        | No data                                                                                                                                                                                                                                                                                                                                  |
| `/monitor-setup`                | 0             | 0                        | No data                                                                                                                                                                                                                                                                                                                                  |
| `/cross-verify`                 | **13**        | 1                        | **Dominant signal — most-cited skill across all data**. Wins cited: NaN bug catch, demand-validation forcing, 14/14 PRDs PASS, domain-pack specificity (infra), Body-dimension 25% imbalance surfaced durability gap. One negative: "checklist lacks infra-reality / production-env question" (drove `cross-verify-packs/infra.md` pack) |
| `/whole-person-check`           | 0             | 0                        | No data — Body/Mind/Heart/Spirit decomposition is referenced via `/cross-verify` (Q15) but the skill itself rarely invoked standalone                                                                                                                                                                                                    |
| `/security-check`               | 0             | 0                        | No data                                                                                                                                                                                                                                                                                                                                  |
| `/using-8-habits`               | 0             | 0                        | No data — onboarding meta-skill, low expected n for established users                                                                                                                                                                                                                                                                    |
| `/eu-ai-act-check`              | 0             | 0                        | Migrated to `claude-governance` v3.1.0+ per ADR-012; redirect stub remains here. Not expected to accumulate signal locally                                                                                                                                                                                                               |
| `/ai-dev-log`                   | 0             | 0                        | No data                                                                                                                                                                                                                                                                                                                                  |
| `/reflect`                      | 0             | 0                        | The data-source skill itself — not typically cited as "most useful" because users don't reflect on `/reflect`                                                                                                                                                                                                                            |
| `/calibrate`                    | 0             | 0                        | One-time onboarding; low expected n                                                                                                                                                                                                                                                                                                      |
| `/workflow`                     | 0             | 0                        | Guided walkthrough; low expected n once workflow internalized                                                                                                                                                                                                                                                                            |
| `/scrutinize` (v2.18.0+)        | 0             | 0                        | Recent addition — data window too short                                                                                                                                                                                                                                                                                                  |
| `/consistency-check` (v2.15.0+) | 0             | 0                        | No data                                                                                                                                                                                                                                                                                                                                  |
| `/diagnose` (v2.18.0+)          | 1 (secondary) | 0                        | Cited as close-second to `/cross-verify` in cross-plugin drift session (5/24); "cheap probes caught two real LOW-severity bugs post-publish"                                                                                                                                                                                             |
| `/post-mortem` (v2.18.0+)       | 0             | 0                        | No data                                                                                                                                                                                                                                                                                                                                  |
| `/save-spec` (v2.16.0+)         | 1             | 0                        | "Clean generator, intentional user-enforced design boundary" (5/20)                                                                                                                                                                                                                                                                      |
| `/management-talk` (v2.18.0+)   | 0             | 0                        | No data                                                                                                                                                                                                                                                                                                                                  |

**Total skills tracked**: 23 (v2.18.1 skill count)

## Adjacent signal — not tracked above but observed

- **`8-habit-reviewer` agent**: cited as primary or co-primary 5 times — paired with `/cross-verify` as the "structural-completeness + content-substance" defensive layer. Strong signal that the agent (separate context window) is doing real work beyond the in-context skill
- **`advisor` (tool, not skill)**: cited as primary or co-primary 8+ times across the data — pattern: advisor-then-reviewer-then-revise cadence. Not in this plugin (it's a Claude Code primitive), but the dependency relationship is strong enough to note
- **`n/a` ratio**: 4 of 43 explicitly n/a. Common pattern: tactical Out-of-Loop bug-fix work where no 7-step skill applied. Suggests current data slightly _over-represents_ planning-stage skills vs daily/tactical work

## AHE benchmark context (for future trend interpretation)

Per the _Observability-Driven Automatic Evolution of Coding-Agent Harnesses_ paper benchmarked in the 2026-05-24 audit (ADR-018):

- **Memory** transfers across tasks at 75.3% pass@1
- **Tools** transfer at 73.0%
- **Middleware** transfers at 71.9%
- **System Prompt** alone _regresses_ to 67.4% (vs seed 69.7%)

This file IS the project's Memory layer. The strong `/cross-verify` signal makes sense in that frame — it's a tool/middleware-class primitive (structural completeness check), not a prose-level rule. The 12 zero-signal skills warrant attention not for deprecation but to understand which are tool-class vs prompt-class — prompt-class skills with no signal should justify their CLAUDE.md / SKILL.md weight under ADR-018's "Earn each line" pass.

## Action items (from trend analysis)

> **`/design` watch (low-priority, n=3, below threshold)**: 1 positive vs 2 negative citations. Pattern: "2+ options ceremony when prior decisions lock the answer" + "full architecture before upstream verified". _Not action-yet_ (threshold n≥5 negative within rolling 3-release window per protocol §6). Watch over v2.18.2 → v2.20.x; if negative reaches n≥5 without offsetting positives, `/skill-improve` cycle focusing on "skip-when-forced-choice" gating + "design-after-research-not-before" sequence note.

> **12 zero-signal skills** (`/requirements`, `/review-ai`, `/deploy-guide`, `/monitor-setup`, `/whole-person-check`, `/security-check`, `/using-8-habits`, `/ai-dev-log`, `/reflect`, `/calibrate`, `/workflow`, `/consistency-check`, `/post-mortem`, `/management-talk`, `/scrutinize`): not deprecation candidates yet — many are expected-low-n by design (onboarding, one-time, recent addition). Add a `last-citation-date` column in next tally update to distinguish "never cited" from "expected low n". Use ADR-018 PR template `predicted_uses` going forward to prevent new zero-signal skills from shipping without explicit rationale.

> **`/reflect` Q6 reliability concern**: 4 of 43 lessons skipped Q6 entirely or used non-parseable wording. Q6 self-reports also exhibit confirmation bias (the writer of the lesson is often the same person who chose the skill — favors skills used). Action: future Q6 refinement should consider "which skill did NOT trigger when it should have" angle to surface negative signal more aggressively.

Future entries here will look like:

> **[Skill name] trending negative (v2.6.x)**: N reflections flagged this as least useful/confusing without offsetting positive signal. Common confusion: [brief pattern]. Recommended action: `/skill-improve` cycle focusing on [dimension]. Owner: [maintainer].

## References

- **Issue [#92](https://github.com/pitimon/8-habit-ai-dev/issues/92)**: Skill Effectiveness Tracking — H7 applied to the plugin itself
- **`skills/reflect/SKILL.md` Q6**: the data source (skill effectiveness signal)
- **`guides/templates/lesson-template.md`**: template that defines the `## Skill effectiveness` section structure
- **Issue #88**: Persistent Reflection Artifacts — the underlying persistence layer this builds on
- **Plugin boundary note**: this is a maintainer-curated report, **not** an auto-aggregator. A runtime aggregator that scans `~/.claude/lessons/*.md` across users would belong in [`pitimon/claude-governance`](https://github.com/pitimon/claude-governance), not here — per [CLAUDE.md § Plugin Boundary](CLAUDE.md).
