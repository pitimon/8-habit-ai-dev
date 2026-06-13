---
date: 2026-06-13
originating-decision: "Issue #311 (deferred from /research deep on Egonex-AI/Understand-Anything → PR #310, v2.21.24)"
rejected-because: Redundant with the already-installed claude-mem comprehension suite (pathfinder / learn-codebase / smart-explore) + low predicted-use frequency for the maintainer; the only distinct angle (H5 discipline) fits a guide paragraph, not a 25th skill
---

# We don't ship a codebase-orientation skill (`/orient` / `/understand-onboard` analog) — T3 reject

During `/research deep` on [`Egonex-AI/Understand-Anything`](https://github.com/Egonex-AI/Understand-Anything) (→ [PR #310](https://github.com/pitimon/8-habit-ai-dev/pull/310), v2.21.24), a third candidate idea was surfaced: a guided **codebase-orientation / onboarding** surface analogous to their `/understand-onboard` — a narrative walkthrough of an unfamiliar codebase (entry points → module map → flow trace). Tracked and evaluated in [#311](https://github.com/pitimon/8-habit-ai-dev/issues/311), rejected as **Tier 3 (ADR-018 ship-decision table)**.

## The gap is real, but the fit is wrong

There genuinely is no 8-habit skill for "orient me in a system I've never seen":

- `/research` Quick is problem-**convergent** ("how does X work here?") and explicitly routes open-ended exploration **away** to `superpowers:brainstorming` (`skills/research/SKILL.md:17-21`). Orientation is **divergent** — the opposite mode.
- `/build-brief` reads code for an already-scoped task, not the whole system.
- `/using-8-habits` onboards to the _plugin_, not a _codebase_.

So it cannot be bolted onto `/research` as a 4th "mode" — Depth (Quick/Standard/Deep) and Mode (General/Compare/Audit) are orthogonal verification/output axes; "orient" is a third, _divergent-intent_ axis. Calling it a mode is a category error and contradicts `/research`'s declared convergent identity.

## Why we reject rather than ship a new skill

Evaluated against the ADR-018 `predicted_uses` contract ([#311 comment](https://github.com/pitimon/8-habit-ai-dev/issues/311)):

| Factor                       | Finding                                                                                                                                                                                                                                                                                                                                           |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **predicted_uses frequency** | Low for the primary user — maintainer work is mostly own, already-familiar repos (8-habit-ai-dev, memforge, infra), rarely onboarding _new_ unfamiliar codebases. High zero-signal risk (14/24 skills are already zero-signal).                                                                                                                   |
| **Redundancy (decisive)**    | `claude-mem:pathfinder` ("map a codebase into feature-grouped flowcharts"), `claude-mem:learn-codebase` ("prime a codebase by reading every source file"), and `claude-mem:smart-explore` (tree-sitter structural search) are **already installed** and cover this comprehension space. Matches the T3 criterion ("redundant / no fit") directly. |
| **Identity / boundary**      | The Understand-Anything original is a tree-sitter + React knowledge-graph engine — building that would violate the plugin's zero-dependency markdown identity and the `8-habit-ai-dev` ↔ `claude-governance` boundary. A markdown-only version would be the _only_ admissible form, and that form is what claude-mem already provides.            |

The one thing that keeps the idea alive at all — an **H5 "understand-before-you-write" discipline** framing — is a _discipline_, not a _capability_. It belongs in a guide, not a 25th skill.

## If reconsidering, read these conditions first

Re-open [#311] only if **all** of these hold:

1. The maintainer (or a contributor sharing a `/reflect` lesson) actually starts onboarding unfamiliar codebases frequently enough to cite the need — i.e., `predicted_uses` scenario 1/3 materializes in a real lesson, not in anticipation.
2. The installed `claude-mem` comprehension suite (pathfinder / learn-codebase / smart-explore) proves **insufficient** for the orientation need — with a concrete gap, not "ours would be nicer."
3. The distinct value is genuinely a _capability_ claude-mem lacks, not the H5 discipline framing (which should ship as a guide paragraph instead — see fallback below).

If only the discipline angle matters, the lighter move is **one paragraph in `/build-brief` or a `guides/` file**: "before scoping work in an unfamiliar system, orient first (e.g. via `claude-mem:pathfinder` / `learn-codebase`), then return." Zero new skill.

Decision is H8 (architecture owned by the human). Sourced from the `/research deep` brief and `8-habit-reviewer` cross-verify that flagged the `/research`-mode category error.
