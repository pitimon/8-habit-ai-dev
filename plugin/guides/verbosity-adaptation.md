# Verbosity Adaptation Rules (v2.7.0)

**Status**: Canonical reference (v2.7.0) | **Consumers**: `hooks/session-start.sh` (runtime); plugin maintainers (documentation) | **Related**: [Issue #96](https://github.com/pitimon/8-habit-ai-dev/issues/96), [ADR-008](../docs/adr/ADR-008-user-maturity-calibration-design.md), [`guides/habit-profile-schema.md`](habit-profile-schema.md)

## Purpose

Closes the reader-adoption half of the `/calibrate` feature loop (Issue #90 shipped the writer in v2.6.0; this doc is the reference material for the reader, shipped in v2.7.0).

When `~/.claude/habit-profile.md` exists and contains a valid `level` field, `hooks/session-start.sh` emits a level-specific adaptation directive into session context. Claude sees the directive at session start and applies it to every subsequent skill invocation. This document is the canonical reference the hook pulls its level-specific rules from, and the reference future skill maintainers should consult when they want to know how a given skill should feel at each level.

## Architectural constraint (why this file exists at all)

The naive approach — add "if level is X, do Y" text to each of the 17 skills — breaks F3 fitness on `/using-8-habits` (1990/2000 words, 10 headroom) and `/eu-ai-act-check` (1989/2000 words, 11 headroom). Per-skill additions were ruled out by the v2.7.0 plan. The only viable runtime injection point is `hooks/session-start.sh`, which runs once per session and outputs into shared context. This file is the rule book the hook reads from; the hook is the mechanism that enforces the rules at runtime.

**Zero changes to individual skill files** — F3 preserved, validators unaffected.

## The four levels (recap from `rules/effective-development.md`)

| Level | Maturity stage | One-line heuristic |
|---|---|---|
| **Dependence** | Getting oriented | Needs scaffolding — show everything |
| **Independence** | Self-directed | Has foundations — skip beginner stuff |
| **Interdependence** | Team-embedded | Leads/mentors — focus on synergy |
| **Significance** | Sets standards | Trust judgment — minimal prompts |

## Verbosity override precedence

The hook respects `preferences.verbosity-override` in the profile file:

| Override value | Effective behavior |
|---|---|
| `verbose` | Full Dependence mode regardless of `level` — user explicitly wants maximum guidance |
| `concise` | Full Significance mode regardless of `level` — user explicitly wants minimum ceremony |
| `none` (or unset) | Use `level` field as-is — normal behavior |

**Unknown override values** (anything other than `verbose` / `concise` / `none`) are ignored — hook uses `level` as if no override were set. This is forward-compatible for future override enums.

**Missing profile file** → Dependence fallback (safest for unknown users).
**Profile exists but `level` is missing or unknown** → Dependence fallback + visible note suggesting `/calibrate` refresh.

## Canonical adaptation rules per level

These are the rules the `hooks/session-start.sh` directive condenses into one sentence per level. The full rules here exist as reference material — maintainer-facing, not runtime-loaded.

### Dependence — "You're getting oriented"

Skills should:

- Show **full guidance** — every checkpoint, every section of the template
- Include **beginner examples inline** — don't assume the user has seen EARS notation, whole-person rubrics, or the 8-habit vocabulary before
- Explicitly state the "why" behind each step (not just "run `/cross-verify`" but "run `/cross-verify` because it catches gaps that silent confidence would miss")
- Link to full reference material (wiki pages, ADRs) for deeper context
- Use the word "checkpoint" liberally — the user is calibrating what "done" means
- Offer opt-outs only when the user is clearly skipping appropriately (e.g., "you can skip `/research` for small bug fixes with obvious root causes")

### Independence — "You run the workflow solo"

Skills should:

- Show **key checkpoints only** — skip the "why each step matters" preamble
- Assume **fluency with plugin vocabulary** — H1-H8, EARS, Whole Person, Three Loops, dimension scores, etc.
- Skip beginner examples — the user has seen them
- Keep the output **concise** — 2-3 paragraphs where Dependence would use 5-6
- Omit the "definitionally never skip" warnings (user already knows `/review-ai` is mandatory)
- Offer the full detail as an optional expansion ("want the full 17-question walkthrough?") rather than showing it by default

### Interdependence — "You lead or mentor others"

Skills should:

- Focus on **delegation, review, and synergy patterns** over individual-contributor ceremony
- Emphasize **handoff clarity** — "who else needs to see this PRD?" "which of your team's conventions should this ADR cite?"
- Prefer **team-oriented language** ("the team", "reviewers", "next maintainer") over individual framing ("you", "your next session")
- Minimize checkpoint ceremony that the user would impose on themselves — they already do
- Surface **cross-cutting concerns** that affect whole systems (plugin boundaries, ADR references, architectural fitness functions) more prominently than individual-task concerns
- Assume the user will **extract patterns for team reuse** — point out when something is worth adding to a team playbook or style guide

### Significance — "You set the standard"

Skills should:

- Show **minimal prompts** — trust user judgment
- Surface **only non-obvious or high-consequence checkpoints** — skip the routine ones
- Offer **optional depth** ("want the full walkthrough?") rather than showing it by default
- Respect the user's **time budget** — if a task is obviously 5 minutes, don't impose 30 minutes of ceremony
- Use **terse technical language** — no hand-holding, no ceremony theater
- Surface **systemic / second-order concerns** — the user is thinking about what the plugin itself does to the ecosystem, not just what the current task does

## Worked examples — representative patterns across 5 skill archetypes

Full 17 × 4 = 68-cell matrix is not shipped (per OQ3 approval — representative is enough). These 5 archetypes × 4 levels = 20 examples establish the pattern.

### Archetype 1: Workflow planning skill (`/requirements` representative)

| Level | How `/requirements` should behave |
|---|---|
| **Dependence** | Walk the user through every EARS shape (Ubiquitous / Event-driven / State-driven / Unwanted / Optional) with examples. Show all 6 PRD template sections. Explicitly state that acceptance criteria are testable. Link to `guides/ears-notation.md` for full reference. |
| **Independence** | Assume EARS familiarity. Skip the shape tutorial. Show PRD template sections but elide beginner examples. Offer the EARS reference as an optional expansion. |
| **Interdependence** | Focus on "who else will read this PRD?" Emphasize handoff clarity between the user and their team. Skip the EARS tutorial entirely. Show a minimal PRD scaffold and ask which team conventions should shape it. |
| **Significance** | Trust the user's PRD instinct. Surface only non-obvious constraints (compliance, plugin boundary, schema contracts). Offer: "want me to check against the 17-point cross-verify checklist?" as optional, not default. |

### Archetype 2: Review/gate skill (`/cross-verify` representative)

| Level | How `/cross-verify` should behave |
|---|---|
| **Dependence** | Walk through all 17 questions one by one. Explain each habit the question maps to. Show scoring band interpretation. Include common failure patterns. |
| **Independence** | Present all 17 questions as a block. Assume habit names are self-explanatory. Show scoring + band without explanation. Keep the report concise. |
| **Interdependence** | Emphasize the Whole Person dimension breakdown (Body/Mind/Heart/Spirit). Ask "what would your team's reviewer flag here?" Focus on the 5 questions most likely to catch team-facing gaps (Q1 impact scan, Q11 read-first, Q13 parallel, Q14 third alternative, Q17 empower next person). |
| **Significance** | Offer the 17-Q pass as "want the full walkthrough?" Default to: "name the 1-2 questions you're least confident about and I'll focus there." Trust the user's self-diagnosis. |

### Archetype 3: Research/discovery skill (`/research` representative)

| Level | How `/research` should behave |
|---|---|
| **Dependence** | Explain the Quick / Standard / Deep depth levels in detail. Walk through the Compare / Audit / General mode distinction. Show source verification rigor with examples. |
| **Independence** | Show depth + mode as a single-line choice. Skip examples. Assume the user picks the right combination for the scope. |
| **Interdependence** | Ask "who else on the team is affected by what you find?" Prefer sources the team already trusts (ADRs, previous research briefs). Suggest cross-referencing past lessons in `~/.claude/lessons/*.md`. |
| **Significance** | Assume Deep + Compare if the scope is non-trivial, Quick otherwise. Trust the user to pick sources. Surface only verification gaps (unverified assumptions) rather than all findings. |

### Archetype 4: Implementation skill (`/build-brief` representative)

| Level | How `/build-brief` should behave |
|---|---|
| **Dependence** | Walk through the problem-statement gate, existing-code read, pattern identification, constraint listing, and test approach. Show examples of each. Include context-boundary definitions for parallel work. |
| **Independence** | Present the brief template as a single scaffold to fill. Skip the "problem-statement gate" explanation (assumed). Skip context boundaries unless the task is parallel. |
| **Interdependence** | Emphasize "what does your team need to know about this change?" Focus on cross-cutting concerns: plugin boundaries, convention preservation, team-facing constants. Ask if the change should be documented in a shared playbook. |
| **Significance** | Assume the user knows what context is needed. Ask only: "what's the ONE thing you want me to verify before coding?" Trust the rest. |

### Archetype 5: Retrospective skill (`/reflect` representative)

| Level | How `/reflect` should behave |
|---|---|
| **Dependence** | Walk through all 6 questions (5 DORA + Q6 skill effectiveness) with examples of good answers. Show the lesson-template structure. Explain the persist step. |
| **Independence** | Present the 6 questions as a block. Show the lesson-template structure tersely. Skip persist-step explanation (assumed). |
| **Interdependence** | Focus on "what should your team learn from this?" Emphasize Q3 (do differently) and Q4 (reusable pattern) over self-improvement Qs. Suggest sharing lessons via team playbook. |
| **Significance** | Offer the 6-Q walkthrough as optional. Default to: "one thing to keep, one thing to change, one action item — 2 minutes." Trust the user to capture what matters. |

## How `hooks/session-start.sh` uses this file

The hook does **not** load this file at runtime. Instead, it hardcodes a single-sentence directive per level, distilled from the rules above:

```bash
case "$EFFECTIVE_LEVEL" in
  Dependence)
    ADAPT="📖 **Profile active: Dependence** — skills should show full guidance, all checkpoints, and beginner examples inline."
    ;;
  Independence)
    ADAPT="📖 **Profile active: Independence** — skills should show key checkpoints only and skip beginner examples."
    ;;
  Interdependence)
    ADAPT="📖 **Profile active: Interdependence** — skills should focus on delegation, review, and synergy patterns over individual ceremony."
    ;;
  Significance)
    ADAPT="📖 **Profile active: Significance** — skills should show minimal prompts, trust user judgment, and surface only non-obvious checkpoints."
    ;;
esac
```

The one-sentence directive is strong enough because Claude treats session-start content as high-salience system context. Maintainers who want more detail (or who are adding new skills) can read this file.

## For new skill authors

When adding a new skill to the plugin, the skill body **does not** need explicit level-handling code. The session-start hook directive applies globally to all skill invocations.

What you **should** do:

1. **Classify your skill into an archetype** — workflow planning, review/gate, research/discovery, implementation, retrospective, or a new archetype (add it to this file if so)
2. **Write the skill body in the Independence style by default** — it's the 80/20 of users who will read it
3. **Offer optional expansions** (`want the full walkthrough?`) rather than hand-holding by default
4. **Leave a note in your skill body** if level-specific behavior needs custom handling beyond what the hook directive provides (rare — most skills fit the archetypes cleanly)

## For users

- Run `/calibrate` if you haven't yet (creates the profile)
- If you want different behavior than your level suggests, set `preferences.verbosity-override` to `verbose` or `concise` in `~/.claude/habit-profile.md` — no re-calibration needed
- Re-calibrate every ~90 days or after a major workflow change (your level is not static)
- If a skill feels mismatched to your level, note it in `/reflect` Q6 "Least useful / confusing" — the maintainer reads those and adjusts the rules here

## References

- [Issue #96](https://github.com/pitimon/8-habit-ai-dev/issues/96) — Reader adoption (this feature)
- [Issue #90](https://github.com/pitimon/8-habit-ai-dev/issues/90) / [ADR-008](../docs/adr/ADR-008-user-maturity-calibration-design.md) — User maturity calibration (writer side, v2.6.0)
- [`guides/habit-profile-schema.md`](habit-profile-schema.md) — v1 schema contract for `~/.claude/habit-profile.md`
- [`rules/effective-development.md`](../rules/effective-development.md) — the maturity model source (Dependence → Significance)
- [`hooks/session-start.sh`](../hooks/session-start.sh) — the runtime enforcement mechanism
- [`tests/test-verbosity-hook.sh`](../tests/test-verbosity-hook.sh) — 8-branch regression coverage
