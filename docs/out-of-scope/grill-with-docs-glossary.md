---
date: 2026-06-27
originating-decision: "/research deep on mattpocock/skills `grill-with-docs` + a Facebook post (หัวหน้าฮง) on Matt Pocock retiring /grill-me for coding"
rejected-because: The headline pattern (CONTEXT.md ubiquitous-language glossary) is already adopted and attributed in guides/project-context-contract.md; the one net-new gap (a glossary-drift audit) has no first-person friction citation, so ADR-014's friction-first gate is unmet — same gate that blocked the Jun-24 codebase-design.md attempt
---

# We don't ship a new glossary/domain-modeling surface from `grill-with-docs` — audit + T2 defer

A Facebook post argued a Domain-Driven-Design idea: a _ubiquitous language_ (shared glossary)
makes AI sessions concise, consistent, and easier to navigate. Matt Pocock composed `/grilling`
(a relentless one-question-at-a-time interview) with `/domain-modeling` (which writes a `CONTEXT.md`
glossary + gated ADRs) into `/grill-with-docs`, and now uses it for coding while keeping plain
`/grill-me` for non-coding. The question raised: how should this improve `8-habit-ai-dev`?

The honest answer, after a deep audit: **mostly it already does.** This file records what is already
adopted, what is deliberately rejected, and what is deferred under the friction-first gate.

## What we already have (the post validates a past decision)

| Post element                                                 | Already in this plugin                                                      | Evidence                                                          |
| ------------------------------------------------------------ | --------------------------------------------------------------------------- | ----------------------------------------------------------------- |
| `CONTEXT.md` glossary with `_Avoid_` near-synonym lists      | Yes — same format, explicitly attributed to `grill-with-docs`               | `guides/project-context-contract.md:30-56`, attribution at `:129` |
| "Challenge the user's near-synonym / fuzzy term during work" | Yes — interview gate                                                        | `guides/templates/interview-protocol.md:61-62`                    |
| Glossary consumed before reasoning                           | Yes — `/requirements`, `/design`, `/breakdown`, `/build-brief`, `/diagnose` | `guides/project-context-contract.md:19-26`                        |

The `_Avoid_` glossary format here matches the upstream `domain-modeling/CONTEXT-FORMAT.md` verbatim
in spirit (`**Term**:` / one-or-two-sentence definition / `_Avoid_: …`). This was imported during the
Jun-7 project-context-contract work (memory obs #98928), and the maintainer already concluded that
vocabulary terms "appear organically across guides and skills without a formal definition" (obs #108120).

## What we reject: a verbatim port of `grill-me` / `grilling`

This plugin does **not** ship `grill-me` or `grilling`, and should not port them as-is. The upstream
`grilling` loop asks one question at a time with no fixed stopping count, ending only at "shared
understanding." Our interview is **deliberately time-boxed** (3 / 5 / 7 adaptive questions with explicit
stop conditions, `guides/templates/interview-protocol.md:70-78`). A relentless open-ended loop conflicts
with that design choice.

The post's practical takeaway — _"grill-with-docs for coding, grill-me for non-coding"_ — maps cleanly
onto surfaces we already have, so it needs no new install:

| Post rule                                                            | Our equivalent                                                                         |
| -------------------------------------------------------------------- | -------------------------------------------------------------------------------------- |
| `grill-with-docs` (coding: interview that also writes docs/glossary) | `/requirements` + `interview-protocol.md` (the doc-creating, glossary-aware interview) |
| `grill-me` (non-coding self-interview)                               | Not an engineering-workflow concern; out of this plugin's scope                        |

This is a **mapping onto our own skills**, not an endorsement to install Matt's three skills.

## Polysemy footnote (the post's real pain)

The post's headline example — "Platform" meaning a software environment in tech vs a railway platform
(ชานชาลา) — is **polysemy** (one word, multiple meanings), which is _not_ what `_Avoid_` solves. `_Avoid_`
handles near-synonyms (many words, one meaning). The existing answer to polysemy is the bounded-context
split via `CONTEXT-MAP.md` (`guides/project-context-contract.md:56`), where the same word can carry
different canonical meanings in different contexts.

## The one real gap, and why we defer it

There is a genuine _conceptual_ gap: the glossary is read-only **consumed** but never **audited for
drift**. `consistency-check`'s five passes don't check whether domain terms used across spec artifacts
are defined in `CONTEXT.md`, nor whether wording collides with an `_Avoid_` entry — Pass 3 (Ambiguity)
only matches literal `[NEEDS CLARIFICATION]` / `TBD` tokens (`skills/consistency-check/SKILL.md:78-84,
134-144`).

The smallest fix would be a 6th **"Glossary drift" pass** on `/consistency-check` (read-only; emit
MEDIUM suggestions to add a term to `CONTEXT.md` or use the canonical word). But **no first-person
friction justifies building it.** The three lessons that pattern-matched on "term/glossary/ambiguity"
were keyword collisions on direct read:

- `~/.claude/lessons/2026-05-04-...:22` — a missing cross-verify _checklist question_ ("domain-pack"
  = a `cross-verify-packs/` file, not a glossary).
- `~/.claude/lessons/2026-05-24-...:39` — RFC-2119 _normative-language_ consistency (must / should).
- `~/.claude/lessons/2026-05-12-...:27` — a frontmatter _scope_-ambiguity convention.

None describes rework caused by missing or ambiguous _domain vocabulary_. This is exactly the
"pattern attractiveness, not friction citation" trap ADR-014 warns against, and it matches the Jun-24
`codebase-design.md` attempt that was blocked on the same gate (0 genuine hits).

## Wiring: sibling of the existing P2 LANGUAGE.md T2 entry

The glossary-drift pass is **not a new free-floating deferral** — it is a sibling of the vocabulary
candidate already in the [ADR-016](../adr/ADR-016-t2-bag-drop-date-eviction-policy.md) T2 bag:

> `P2 LANGUAGE.md vocabulary` — `mattpocock/skills` SHA `b8be62ff` `productivity/write-a-skill` —
> drop date **2026-11-23** (`docs/adr/ADR-016-t2-bag-drop-date-eviction-policy.md:68`).

The glossary-drift pass shares P2's drop date and re-entry conditions; do **not** mint a competing
drop-date row.

## Re-entry conditions

Per [ADR-016 §"Re-entry mechanism"](../adr/ADR-016-t2-bag-drop-date-eviction-policy.md) (lines 35-42),
build the glossary-drift pass only when **either** trigger fires:

1. **First-person glossary friction** — a `/reflect` lesson, cross-verify imbalance, or maintainer
   report citing real rework caused by ambiguous or undefined _domain vocabulary_ (not normative
   language, not scope markers, not checklist gaps).
2. **SHA-churn re-audit** — `mattpocock/skills` ships a materially changed `domain-modeling` /
   `grill-with-docs` that exposes a capability our `CONTEXT.md` contract lacks.

Until then: the glossary pattern is adopted, the maintenance audit is deferred, and the verbatim
interview port is rejected.
