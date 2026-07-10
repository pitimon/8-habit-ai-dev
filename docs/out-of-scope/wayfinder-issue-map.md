---
date: 2026-07-10
originating-decision: "/research deep on mattpocock/skills `wayfinder` + a Facebook post (หัวหน้าฮง) claiming it retires /grill-me, kills context management via 'smart zone / dump zone', and 'should be the new default'"
rejected-because: Wayfinder is a composite of patterns this plugin has already adjudicated — its orchestration half overlaps the already-bagged `handoff` + `to-issues` T2 candidates (ADR-016), its fog-work half is deliberately deferred to `superpowers:brainstorming` (ADR-006), and its context-economy is already taught (build-brief §Context-survival + orchestration-patterns Pattern 2). The one net-new fragment (size tasks by context budget) has zero first-person friction citation, so ADR-014's friction-first gate is unmet — it siblings under the existing `handoff`/`to-issues` T2 rows rather than minting a competing drop-date.
---

# We don't ship a wayfinder clone — audit + T2 sibling-defer

A Facebook post (~24h old) argued that Matt Pocock's new `wayfinder` skill (`mattpocock/skills`,
`skills/engineering/wayfinder/`) solves what `/grill-me` can't: for work "too big for one agent
session" with a foggy destination, it "charts the way as a shared map on the repo's issue tracker,
then works its tickets one at a time." The post added a context-management frame ("smart zone" ≈ 60%
of the window; past it a "dump zone" of context rot), claimed wayfinder needs "no handoff" and is
"one skill does it all", and said it "should be the new default instead of grill-me". The question
raised: how should this improve `8-habit-ai-dev`?

The honest answer, after a deep primary-source audit (GitHub API, commit `d574778`): **adapt narrowly.**
Wayfinder is a *composite* of patterns this plugin has already decided on. This file records what is
already covered, what the viral post got factually wrong, what is deliberately out of scope, and the
single net-new fragment — deferred under the friction-first gate.

## Wayfinder's verified mechanic (what it actually is)

- A **map** = one issue labelled `wayfinder:map`, an index (not a store) with Destination / Notes /
  Decisions-so-far / **Not-yet-specified** (the "fog of war") / Out-of-scope sections.
- **Tickets** = child issues labelled `wayfinder:{research,prototype,grilling,task}`, each sized to
  ~one 100K-token agent session, worked **one ticket per session** (hard rule: "never resolve more
  than one ticket per session"). Native tracker dependencies render the open/unblocked "frontier".
- It **dispatches** `/grilling`, `/domain-modeling`, `/prototype`, and merges onto the main flow at
  `/to-spec` → `/implement`. Frontmatter carries `disable-model-invocation: true` — user-invoked only.

## What the viral post got wrong (corrected against source)

| Post claim | Verdict | Evidence |
| --- | --- | --- |
| "new default instead of grill-me" | **FALSE** | CHANGELOG PR #464: wayfinder is a "situational on-ramp, **not** the new main entry flow"; crowning it default is "a v2-sized move, not a 1.1". grill-me is not deprecated. |
| "smart zone ≈ 60% / dump zone / context rot" | **NOT IN SOURCE** | "dump zone" and "context rot" appear nowhere in `mattpocock/skills`. "smart zone" exists only in the `ask-matt` skill, defined as **~120k tokens**, not "60% of context". The 60%/dump-zone framing is the post author's, not Matt's. |
| "no handoff needed / one skill does it all" | **NOT CLAIMED** | The word "handoff" never appears in the wayfinder skill; `/handoff` remains a recommended skill in the same repo. State-in-tracker plausibly *reduces* handoff need — an emergent property the skill never asserts. |

## What we already have (the mechanic maps onto existing surfaces)

| Wayfinder element | Already in this plugin | Evidence |
| --- | --- | --- |
| Context economy — offload large payloads, don't carry them in-window | Yes — "write to a known path + return the path"; keep briefs small and front-loaded so compression can't gut them | `guides/orchestration-patterns.md:75` (Pattern 2, Understand-Anything precedent); `skills/build-brief/SKILL.md:82-89` (§"Context survival": 4-layer compression pipeline, ≤~4,000-token briefs, split-per-phase, path-refs-not-payloads) |
| One-ticket-per-session focus | Yes (as discipline) — H3 "one thing at a time"; `/breakdown` produces atomic tasks | `rules/effective-development.md` (H3); `skills/breakdown/SKILL.md` |
| Issue tracker as the work surface | Yes (contract + templates, draft-only) | `guides/project-context-contract.md` (Issue Tracker Contract); `guides/templates/agent-brief-template.md`; `skills/breakdown/SKILL.md` (recommend-an-issue, "do not auto-post/label/close") |
| Foggy / divergent / destination-not-visible work | Deliberately outsourced | **ADR-006** deleted `/brainstorm` and defers fuzzy problems to `superpowers:brainstorming`; `/research` opens by redirecting fuzzy statements there |

## The orchestration half is already bagged (do not re-audit)

Wayfinder's issue-map-worked-ticket-by-ticket is the composition of two candidates **already in the
ADR-016 T2 bag** from prior `mattpocock/skills` audits — both deferred, both drop **2026-11-23**:

> `handoff` skill — `mattpocock/skills` SHA `b8be62ff` `productivity/handoff`
> ([ADR-016 inventory:71](../adr/ADR-016-t2-bag-drop-date-eviction-policy.md))
>
> `to-issues` vertical-slice + AFK/HITL labels augment — `mattpocock/skills` SHA `b8be62ff`
> `engineering/to-issues` ([ADR-016 inventory:72](../adr/ADR-016-t2-bag-drop-date-eviction-policy.md))

Wayfinder does not present a new capability here — it *packages* handoff-continuity + issue-map
decomposition into one user-invoked orchestrator. A wayfinder clone would additionally reverse
**ADR-006** (fog-work belongs to Superpowers) and cross the **ADR-021 / plugin-boundary** line the
moment it auto-creates/assigns/closes issues (runtime orchestration + auto-post is a
`claude-governance` concern; our issue surfaces stop at "draft/recommend" for exactly this reason).

## Resume/handoff is already settled — this is not a virgin gap

The "wayfinder needs no handoff → we lack one" framing re-opens a decision made **twice**:

- `~/.claude/lessons/2026-04-17-8habit-plugin-release-discipline.md:48` — a full resume/checkpoint
  system was planned **HIGH priority** and **explicitly descoped as scope creep** for v2.9.0 (advisor
  reframe → lightweight step awareness).
- `~/.claude/lessons/2026-05-12-current-state-save-point-v2-15-2.md:23,27` — re-examined; auto-persist
  rejected via **ADR-013 Alt-4** (no-build philosophy); the "current state" save-point judged "the
  only genuine gap" and **shipped** as the deliberately lightweight, user-owned `current-state.md`
  (v2.15.2). (These are user-local lesson files under `~/.claude/lessons/`, not repo-tracked — full
  paths given so a reader on the same machine can verify.)

## The one net-new fragment, and why we defer it

The only fragment wayfinder adds that isn't already covered or already bagged is a **sizing heuristic**:
size a work unit by its *context budget* (~one ≤100K-token session), not only by logical atomicity.
Our `/breakdown` sizes by files-touched / logical atomicity (`skills/breakdown/SKILL.md`), not by an
explicit token budget.

Per **ADR-014**'s friction-first gate, this ships only with a documented n≥1 in-repo friction signal.
A search of repo `*.md`, `~/.claude/lessons/`, and project memory for context-exhaustion / lost-work /
"too big for one session" friction returned **zero hits** — plus active counter-evidence (the two
settled decisions above). This is the "pattern attractiveness, not friction citation" trap ADR-014
warns against.

**Wiring** (per grill-with-docs-glossary.md's precedent — *do not mint competing drop-date rows*): the
sizing-heuristic candidate **siblings under the already-bagged `handoff` / `to-issues` T2 rows**
(ADR-016 inventory, drop **2026-11-23**). It is a smaller, downstream slice of the same
orchestration-continuity candidate family; it does not earn its own row.

## Re-entry conditions

Per [ADR-016 §"Re-entry mechanism"](../adr/ADR-016-t2-bag-drop-date-eviction-policy.md) (lines 35-42),
reconsider any wayfinder-derived adoption only when **either** trigger fires:

1. **First-person context-budget friction** — a `/reflect` lesson, cross-verify imbalance, or
   maintainer report citing real rework caused by a plan/task that couldn't fit one agent session, or
   work lost to context exhaustion mid-implementation (not the compression *survival* that
   `build-brief:82-89` already handles).
2. **SHA-churn re-audit** — `mattpocock/skills` ships a materially changed `wayfinder` /
   `handoff` / `to-issues` that exposes a capability our contract + `current-state.md` genuinely lack.

Until then: the mechanic maps onto surfaces we already have, the orchestration half stays bagged with
`handoff`/`to-issues`, the fog-work stays with Superpowers (ADR-006), and no wayfinder clone is built.
