# ADR-006: Audience Honesty + Deferral to Superpowers for Brainstorming

**Status**: Accepted
**Date**: 2026-04-09
**Version**: 2.4.1
**Decision type**: In-the-Loop (cultural/positioning)

## Context

Two signals converged on 2026-04-09:

1. **Peer-machine critique**: an external QA cycle framed the plugin as "thoughtfully over-engineered" — every element has defensible rationale, but the sum exceeds what 80% of users need for daily work. The strongest point wasn't code volume (markdown is cheap) but **cultural pressure**: the session-start hook's "7-step workflow (not Vibe Coding)" banner implicitly pushes users to run all 7 steps even for 30-line fixes, with no opt-out.

2. **Superpowers comparison**: on the same day, we read the source of `claude-plugins-official:superpowers` `brainstorming` skill (500+ lines across SKILL.md + visual-companion.md + spec-document-reviewer-prompt.md + scripts/, 143K installs, 29K stars). Our `/brainstorm` skill — shipped in v2.4.0 less than 24 hours earlier — was a weaker reimplementation of ~60% of its functionality, lacking hard-gate discipline, spec-doc-to-git artifact, scope decomposition, one-question-at-a-time dialogue, and a visual companion.

Both signals pointed to the same root cause: **we didn't read the peer plugin before building a parity feature**, and we didn't differentiate "target audience" (team discipline, compliance) from "daily audience" (solo dev, fast-moving teams) at runtime.

## Decision

**(a) Audience honesty via opt-out + tier acknowledgment**

- Add `HABIT_QUIET=1` env var check to `hooks/session-start.sh`. If set, the hook exits silently. Users who have internalized the workflow pay zero session cost.
- Soften the banner framing: "7-Step Workflow (not Vibe Coding)" → "7-Step Workflow reference — use what fits the task". Removes implicit "you must run all 7" pressure.
- Add a "Core 5" section to `/using-8-habits` listing the 5 skills that cover ~80% of daily work (`/requirements`, `/review-ai`, `/cross-verify`, `/research`, `/reflect`). Acknowledge that the other 11 skills are optional depth.

**(b) Delete `/brainstorm` and defer to `superpowers:brainstorming`**

- Remove `skills/brainstorm/` entirely.
- Update `/research` and `/workflow` to point users at `superpowers:brainstorming` when the problem statement is fuzzy, with graceful fallback wording for users who don't have Superpowers installed.
- Remove `/brainstorm` references from `/using-8-habits`, README, CLAUDE.md, and the validator (Check 16).

## Options Considered

| Option                         | Why rejected                                                                                                                                                                                                   |
| ------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Y — Narrow rescope**         | Reduce `/brainstorm` to a 60-line "5-minute self-run divergent exercise" with a pointer to Superpowers for full sessions. Keeps a weak skill alive on weaker footing; adds maintenance burden for niche value. |
| **Z — Deprecate over a cycle** | Mark as deprecated in v2.4.1, remove in v2.5.0. Cowardly — adds maintenance burden to dodge admitting error. Same-day correction is cleaner.                                                                   |
| **Leave as-is**                | Ignores peer plugin duplication + peer critique. Breaks H4 (Win-Win with the tester who invested in the critique) and H8 (Spirit — conscience over compliance with our own recent decisions).                  |

## Consequences

**Positive:**

- Users who want discipline reference without session-cost can silence the hook.
- The Core 5 framing reduces "all 16 skills or nothing" pressure and matches how most users actually work.
- Users get the stronger brainstorming tool (Superpowers) with hard-gate discipline + spec-doc-to-git, instead of a weaker reimplementation.
- Fewer skills to maintain (17 → 16); less drift risk.

**Negative / costs:**

- **Breaking removal within 24 hours of v2.4.0 ship** — normally a semver red flag. Accepted because v2.4.0 had effectively zero external users when v2.4.1 shipped, and the alternative (leaving a weaker duplicate) is worse. Classified as a v2.4.1 patch, not v3.0.0, because of the <24h correction window.
- Users without Superpowers installed lose the /brainstorm skill. Mitigated by the graceful fallback text in `/research`.
- Same-day flip-flop on `/using-8-habits` (which listed `/brainstorm` as a core skill yesterday). Documented here as the honest correction.

## The Lesson (H5 Understand First, applied to plugin authoring)

**Before building a parity feature with a peer plugin, read the peer plugin's actual source.** The phrase "parity with Superpowers" in PR #72 was aspirational, not verified. Reading the Superpowers source took ~15 minutes and would have prevented a ship-and-delete cycle.

This lesson applies beyond this specific case:

- When CLAUDE.md mentions a peer plugin, `ls ~/.claude/plugins/cache/<owner>/<plugin>/<version>/skills/<skill>/` before claiming parity or complementarity.
- When the user has Plugin X installed and we ship a Plugin Y feature that overlaps, the burden of proof is ours: show the differentiation.
- Plugin boundary discipline (from ADR-005 / CLAUDE.md Plugin Boundary section) extends to peer plugins, not just the two plugins we maintain.

## References

- Peer-machine critique: 7 over-engineered claims verified against codebase (6/7 TRUE or PARTIAL TRUE). Audit results in session planning doc.
- Superpowers brainstorming source: `~/.claude/plugins/cache/claude-plugins-official/superpowers/5.0.7/skills/brainstorming/`
- v2.4.0 ship obs: memory #73591 (8-habit-ai-dev v2.4.1 plan approved), #73575 (decision to delete /brainstorm)
- ADR-005: Plugin Boundary between 8-habit-ai-dev and claude-governance
- CLAUDE.md: Plugin Boundary section (added in PR #71, Stage A of Path C)
