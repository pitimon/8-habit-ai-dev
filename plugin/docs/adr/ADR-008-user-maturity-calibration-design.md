# ADR-008: User Maturity Calibration — Skill Design and Profile Schema

**Status**: Accepted
**Date**: 2026-04-11
**Decision type**: On-the-Loop (architecture / new skill + cross-file coordination)
**Issue**: [#90](https://github.com/pitimon/8-habit-ai-dev/issues/90)
**Milestone**: v2.6.0 — Hermes-Inspired Improvements
**Related**: [ADR-006](./ADR-006-audience-honesty-and-superpowers-deferral.md) (HABIT_QUIET=1 opt-out precedent), [ADR-007](./ADR-007-agentskills-compatibility-decision.md) (plugin boundary discipline)

## Context

Issue #90 (Hermes Pattern #5 — User Modeling) flags that every 8-habit-ai-dev session treats senior and first-time users identically — verbose prompts, all checkpoints, full examples — regardless of experience. The maturity model defined in `rules/effective-development.md` (Dependence → Independence → Interdependence → Significance) is never operationalized. No skill adapts based on who's running it.

Hermes Agent implements passive dialectic user modeling via Honcho (12 identity dimensions, USER.md). We cannot replicate that verbatim — it requires a runtime we don't have and violates the plugin's "pure markdown, no dependencies" principle ([CLAUDE.md §What This Is](../../CLAUDE.md)). The inspiration is sound; the implementation must fit our constraints.

This ADR captures five interlocking design decisions for the `/calibrate` feature that ships in v2.6.0, documents why each was chosen over the alternatives considered, and records the public contract (profile file schema) that future skill readers will consume.

## Options Considered

The design involves **five interlocking decisions**. Each was evaluated independently; the recommendations cohere into a single design.

### Decision 1: Which implementation shape?

| Option | Description | Pro | Con |
|---|---|---|---|
| **A** | New standalone `skills/calibrate/SKILL.md` | Clean separation; easy re-calibration; matches existing 16-skill pattern | ❌ **Discovery problem** — first-time users have no reason to run a skill they've never heard of |
| **B** | Extend `skills/using-8-habits/SKILL.md` with a calibration block | No new skill; natural first-run flow | Mixes onboarding + assessment concerns; re-calibration forces re-reading onboarding; `/using-8-habits` grows unwieldy |
| **C** | Passive inference from `/reflect` responses aggregated over N sessions | Zero friction; matches Hermes philosophy; honest (observed practice, not self-report) | ❌ **Cold-start fatal** — new users have no profile for many sessions; aggregation logic fragile in pure markdown |
| **D** | Session-start hook asks question on first run | Automatic discovery | ❌ **Technically impossible** — Claude Code hooks output context one-way; they cannot receive interactive user input |
| **E** | **Hybrid**: new `/calibrate` skill + `/using-8-habits` body pointer + `hooks/session-start.sh` informational nudge if profile missing | Solves discovery via 3 paths; clean concern separation; respects existing `HABIT_QUIET=1` opt-out from ADR-006 | +1 skill count; touches 3 files (1 new + 2 small edits) instead of 1 |

**Chosen**: **E — Hybrid** (new skill + 2 small pointer/nudge edits).

**Why**: Alt A's discovery problem is fatal — a skill no one knows to run delivers no value. Alt B mixes concerns in a way that makes re-calibration painful. Alt C has a cold-start problem that specifically breaks for the target audience (new users). Alt D is technically impossible. Alt E is the minimum viable path that both solves discovery and keeps the skill single-purpose. The hook edit is ~10 lines and respects the existing `HABIT_QUIET=1` opt-out mechanism so silencers are unaffected.

### Decision 2: Scoring rubric for natural-language answers

| Option | Description | Pro | Con |
|---|---|---|---|
| **2a** | Threshold sum: each answer contributes N points; bands → level | Deterministic; easy to state | Needs exact point mapping — brittle if bands collapse |
| **2b** | Decision tree: early questions route to branches terminating in level | Fastest | Early-Q dominance — brittle to misinterpretation |
| **2c** | **Dominant-level selection**: each question offers 4 answer-shapes (one per level); Claude picks best-match per question; modal level across all questions wins | Matches existing `guides/whole-person-rubrics.md` pattern already used by `/whole-person-check`; handles NL fuzziness gracefully | Non-deterministic at the edge (ties) — handled by tie-break rule |
| **2d** | Weighted sum: per-question weights modulate threshold sum | Slightly more accurate | Weights are opaque; harder to explain/audit |

**Chosen**: **2c — Dominant-level selection**.

**Why**: Consistency with the existing rubric pattern is a first-order value. Users who already know `/whole-person-check` recognize the "rate each at level X" mental model. Dominant-level handles natural-language fuzziness without requiring Claude to do arithmetic on fuzzy inputs. Tie-break rule: **when the modal level is ambiguous (two levels tied), pick the higher one** — benefit of the doubt, don't insult experienced users.

### Decision 3: `~/.claude/habit-profile.md` file schema

| Option | Description | Pro | Con |
|---|---|---|---|
| **3a** | Plain markdown with key:value lines | Simplest for humans | Ambiguous parsing for skills that want to read it |
| **3b** | **YAML frontmatter + markdown body** | Matches SKILL.md pattern; skills already parse YAML frontmatter via `sed -n '/^---$/,/^---$/{...}'` idiom; body is human-readable | Slightly more verbose than 3a |
| **3c** | Pure JSON | Unambiguous parsing | Violates markdown-first philosophy; not human-readable |

**Chosen**: **3b — YAML frontmatter + markdown body**.

**Why**: The repo already has 16 skills with YAML frontmatter parsed by `sed` in three validators. Future skills that read `~/.claude/habit-profile.md` can reuse the exact same extraction pattern. This is the lowest-friction path for future reader implementations. Schema versioning is built in via the `schema-version: 1` field.

**Public contract (v1)**:

```markdown
---
level: Independence                    # one of: Dependence, Independence, Interdependence, Significance
calibrated: 2026-04-11T13:50:00+07:00  # ISO 8601
schema-version: 1
responses:
  plugin-experience: "~3 months"       # free-form NL captured from the user
  ci-experience: comfortable
  team-context: solo
  vocabulary-comfort: mostly clear
  orientation: preventive
preferences:
  verbosity-override: none             # none | verbose | concise — manual override regardless of level
---

# Habit Profile — Independence

Calibrated on 2026-04-11. This profile informs how /requirements, /review-ai, and other
skills adapt their verbosity to match your experience.

Re-calibrate anytime by running `/calibrate` again.
```

**Forward compatibility**: `schema-version: 1` means future skills can detect and migrate older profiles. The field name is stable; the rest is extensible.

### Decision 4: Chain position in the 7-step DAG

| Option | Description | DAG validator impact |
|---|---|---|
| **4a** | **Standalone**: `prev-skill: none, next-skill: any` | None — matches existing `/using-8-habits`, `/cross-verify`, `/reflect` pattern |
| **4b** | Chained from `/using-8-habits`: `prev-skill: using-8-habits, next-skill: any` | ❌ Changes `/using-8-habits` from `next-skill: any` to `next-skill: calibrate` — breaks its "any successor" contract and triggers symmetric-edge validation |

**Chosen**: **4a — Standalone**.

**Why**: Alt E handles discovery via body-text pointer in `/using-8-habits` (not frontmatter chain). This keeps `/using-8-habits` as `next-skill: any` and avoids DAG validator breakage. Three existing skills (`/using-8-habits`, `/cross-verify`, `/reflect`) already use the standalone pattern — `/calibrate` is the fourth in the same family.

### Decision 5: Re-calibration policy

| Option | Mechanism | Trade-off |
|---|---|---|
| **5a** | User-driven only | Simplest but risks stale profile |
| **5b** | **User-driven + age warning** on re-invocation | Respects user time; surfaces staleness without forcing |
| **5c** | Time-enforced: skill refuses to honor profile older than N days | Prevents stale profile but annoying and paternalistic |
| **5d** | Version-bump triggered: compare `calibrated-version` vs plugin.json on each invocation | Fresh each release but adds cross-file coupling |

**Chosen**: **5b — User-driven + age warning**.

**Why**: The plugin's philosophy (ADR-006, CLAUDE.md) is guidance over enforcement. Option 5c ("refuse profile") contradicts that. Option 5d ("force on version change") introduces coupling to plugin.json parsing from within a skill — possible but invasive. Option 5b surfaces the staleness signal ("your profile is 120 days old") when `/calibrate` is re-invoked AND when the `hooks/session-start.sh` nudge fires (since the hook already reads the file). User decides, skill suggests.

## Decision

Ship v2.6.0 with all five decisions together:

1. **Alt E** — new `skills/calibrate/SKILL.md` + pointer in `skills/using-8-habits/SKILL.md` body + informational nudge in `hooks/session-start.sh` guarded by `[ ! -f ~/.claude/habit-profile.md ]` and respecting existing `HABIT_QUIET=1` opt-out.
2. **Dominant-level scoring** — 5-7 questions, 4 answer-shapes each, modal-level selection with higher-wins tie-break.
3. **YAML frontmatter profile schema (v1)** — file at `~/.claude/habit-profile.md`; stable contract documented in `guides/habit-profile-schema.md`.
4. **Standalone chain position** — `prev-skill: none, next-skill: any`.
5. **User-driven re-calibration with age warning** — no enforcement, surface staleness on re-invocation and via hook nudge.

Out of scope for this PR (deferred to follow-up issues):

- Modifying the 16 existing skills to *read* the profile and adapt verbosity. This is a cross-cutting 16-file change that deserves its own issue + PR.
- Per-project calibration (current design is global, `~/.claude/habit-profile.md`).
- Schema v2 migration logic (not needed until schema changes).

## Consequences

**Positive**:

- The maturity model in `rules/effective-development.md`, unused since it was written, is finally operationalized.
- The profile contract (`schema-version: 1`) gives future skill readers a stable API to code against. Adapting the 16 skills in a follow-up PR will not need to touch this ADR.
- Three discovery paths ensure new users will find the feature: (a) `hooks/session-start.sh` nudge on first run, (b) `/using-8-habits` onboarding pointer, (c) direct `/calibrate` invocation.
- `HABIT_QUIET=1` continues to fully silence the plugin's session-start output — users who opt out don't get nagged about calibration.
- Standalone skill position keeps the DAG validator green (55 PASS) without any regression.

**Negative / costs**:

- Skill count grows from 16 to 17, adding one more file to maintain and requiring updates to `README.md`, `CLAUDE.md`, `SELF-CHECK.md`, and the validator's skill counter.
- `hooks/session-start.sh` output budget (CLAUDE.md says ≤300 tokens) tightens slightly — the nudge is ~3 lines but adds up if other nudges land later. Current headroom sufficient; monitor for future additions.
- Until the follow-up PR modifies the 16 existing skills, `habit-profile.md` will be *written* but *not read* — users won't see behavior change immediately. This must be documented explicitly in the PR body and README so expectations are correct.
- Plugin cache lag (lesson from #88): the new `/calibrate` skill won't be usable in this session until v2.6.0 is released and reinstalled. Test plan must account for this.

**Follow-up actions**:

- Open a new issue "`/calibrate` reader adoption — adapt 16 skills to read habit-profile.md" targeting v2.7.0.
- After this PR merges, capture a lesson file manually at `~/.claude/lessons/2026-04-11-issue-90-user-calibration.md` (cache-lag workaround; see Q15 in cross-verification).
- Update `docs/wiki/Step-1-Requirements.md` or create a new wiki page if calibration deserves its own documentation slot.

## Scope and Plugin Boundary Check

Per [CLAUDE.md § Plugin Boundary](../../CLAUDE.md#plugin-boundary):

| Concern | Decision |
|---|---|
| New skill (`/calibrate`) | ✅ In-scope for `8-habit-ai-dev` — workflow discipline skill |
| User-local config file (`~/.claude/habit-profile.md`) | ✅ In-scope — user preference storage, not runtime enforcement |
| `hooks/session-start.sh` edit (informational nudge) | ✅ In-scope — existing file, informational output only, NOT a PreToolUse/PostToolUse gate |
| PreToolUse or PostToolUse hook | ❌ Out-of-scope — belongs in `claude-governance` |
| Runtime enforcement of verbosity | ❌ Out-of-scope — skills read profile and adapt themselves (guidance, not gate) |

No plugin-boundary violations. This is genuinely a workflow discipline feature, not a compliance/enforcement feature.

## Article 14 (EU AI Act) Checkpoint

**SKIP** — `/calibrate` is a workflow aid that captures user preference for verbosity. It is:

- Not a high-risk AI system under Annex III.
- Not making decisions *about* people (e.g. credit, employment, healthcare).
- Not EU-targeted specifically (global plugin).
- Fully user-controlled (the user answers the questions; the "AI" is just templating).

The human-oversight capabilities (understand / automation bias / interpret / override / stop button) do not apply. The skill is under full human control at every step by design.

## References

- **Issue #90**: [pitimon/8-habit-ai-dev#90](https://github.com/pitimon/8-habit-ai-dev/issues/90) — User Maturity Calibration requirement
- **PRD (this PR)**: 6 EARS acceptance criteria + 5 Open Questions resolved in this ADR
- **Cross-verification (in-session)**: 12/12 applicable = 100% after Q14/Q15 remediation
- **Hermes Agent inspiration**: [deepwiki.com/NousResearch/hermes-agent](https://deepwiki.com/NousResearch/hermes-agent) — passive dialectic user modeling via Honcho/USER.md (philosophical source; implementation diverges due to plugin constraints)
- **Existing maturity model**: [`rules/effective-development.md`](../../rules/effective-development.md) § "Maturity Model" — Dependence → Independence → Interdependence → Significance
- **Existing rubric pattern**: [`guides/whole-person-rubrics.md`](../../guides/whole-person-rubrics.md) — dominant-level selection pattern for Body/Mind/Heart/Spirit (adapted here for user-level classification)
- **ADR-006**: [HABIT_QUIET=1 opt-out + audience honesty](./ADR-006-audience-honesty-and-superpowers-deferral.md) — the precedent for opt-out discipline this ADR honors in the hook nudge
- **ADR-007**: [agentskills.io NO-GO](./ADR-007-agentskills-compatibility-decision.md) — the precedent for "don't migrate to a standard that doesn't actually deliver the promised value"; cited here as an example of pattern-matching constraints against claimed benefits
- **Lesson file from #88/#89**: `~/.claude/lessons/2026-04-11-hermes-inspired-v2-6-0.md` — plugin cache lag caveat informs the test plan for this PR

## The Lesson (H8 Find Your Voice, applied to user modeling)

**The user's maturity is orthogonal to the system's maturity.** When I first considered whether to track per-dimension (Body/Mind/Heart/Spirit) for the user profile, I was conflating two different concepts:

- `guides/whole-person-rubrics.md` rates *what the user is building* — "Is the SYSTEM reliable?", "Do we know where THE SYSTEM is going?". It answers questions about code, CI, architecture.
- The maturity model in `rules/effective-development.md` rates *the user* — "Where are you in Dependence → Significance?". It answers questions about experience, collaboration style, discipline.

Both use "Whole Person" vocabulary, but they point at different subjects. Collapsing them into one data structure would have been a category error that future readers could not have untangled. Reading the existing rubric in full (Q11 verification debt → PASS) made this orthogonality visible before it became code.

**Generalization**: When re-using a pattern from elsewhere in the codebase, verify that the *subject* of the pattern matches the new use case, not just the *shape*. Shape reuse with mismatched subjects is a leading cause of confusing abstractions.
