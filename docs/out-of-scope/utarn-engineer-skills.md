---
date: 2026-06-27
originating-decision: "ADR-026 external prior-art audit; closeout of the 2026-06-23 utarn/engineer-skills deep audit (memory obs #108139) that was never recorded in-repo"
rejected-because: utarn/engineer-skills is a fork of mattpocock/skills — already adjudicated in ADR-014 — so its inherited surface is pre-decided; the net-new candidate `improve-codebase-architecture` is plausible but has no first-person friction citation, so ADR-014's friction-first gate is unmet
---

# We don't ship from utarn/engineer-skills yet — it's a mattpocock fork; net-new items are T2-deferred

`utarn/engineer-skills` (<https://github.com/utarn/engineer-skills>, MIT, ~29★) is a **fork of
`mattpocock/skills`** by Utharn Buranasaksee, framed around four AI-coding failure modes (misalignment,
verbosity, non-functional code, **architectural decay**). It was deep-audited on 2026-06-23
(memory obs #108139 / #108130 / #108131; brief at
`~/.claude/plans/deep-https-github-com-utarn-engineer-ski-lexical-raccoon.md`) but the result was never
recorded in-repo. This file closes that thread, referenced from
[ADR-026](../adr/ADR-026-external-prior-art-audit-karpathy-gstack.md).

Because the base repo is the one already adjudicated in
[ADR-014](../adr/ADR-014-external-prior-art-audit.md) (2026-05-20), most of the surface is pre-decided.

## Bucket A — already covered by existing equivalents

≈8 forked skills map to surfaces we already ship: e.g. active bug investigation → `/diagnose`,
test-first → `guides/tdd-tracer-bullet.md`, skill authoring → `guides/skill-authoring.md`, multi-agent
handoff → the `CHANGES.log` bridge. No action.

## Bucket B — already deferred by ADR-014

- `codebase-design` (deep-modules / Ousterhout vocabulary) — same candidate as ADR-014 **P2 LANGUAGE.md
  vocabulary** (T2). A grep of `~/.claude/lessons/` returned **0 hits** for architecture-decay /
  deep-module / domain-language / verbosity pain. Friction gate unmet.
- `find-mismatch` (runtime-bug-focused review) — overlaps the ADR-014 **P8 two-axis review split** (T2,
  needs n≥2 adopter friction).
- `domain-modeling` + `grill-with-docs` — already adjudicated, with a split verdict recorded
  2026-06-27 in [`grill-with-docs-glossary.md`](./grill-with-docs-glossary.md): the glossary **format is
  adopted** (`guides/project-context-contract.md`), the **active-write loop** (G1–G3) is T2-deferred, and
  only the inline ADR/`CONTEXT.md` write _during_ a skill is rejected as conflicting with the
  read-only-skill charter (ADR-014 **P6**, T3). Not re-adjudicated here.

## Bucket C — net-new candidate

- **`improve-codebase-architecture`** — a user-invoked periodic **structural-decay scan** ("scan the
  codebase for design improvements, produce a report") with a _deletion test_, countering the entropy
  that accelerated AI development creates. This is the strongest net-new item: no existing 8-habit skill
  covers _structural decay_ (as opposed to runtime observability via `/monitor-setup`). Habit map: **H7
  Sharpen the Saw**.
  **Verdict: T2 defer** (ADR-016 drop date 2026-12-27). Adjacent to the Karpathy #2/#3 simplicity gaps in
  [ADR-026](../adr/ADR-026-external-prior-art-audit-karpathy-gstack.md), but distinct (decay scan vs
  edit discipline); do not merge the deferrals.

> utarn's "four failure modes" framing is a **free conceptual contribution** — it could enrich
> `/using-8-habits` onboarding without shipping any new skill — but that is a consumer-doctrine edit
> (version bump) and is left as a separate maintainer decision, not done here.

## Re-entry conditions

Build `improve-codebase-architecture` only when **either** fires:

1. **First-person structural-decay friction** — a `/reflect` lesson or issue citing real rework caused
   by architectural decay that `claude-mem:pathfinder` / `claude-mem:learn-codebase` did not surface.
2. **SHA-churn re-audit** — utarn ships a materially changed architecture-scan skill exposing a
   capability the deferred candidate lacks.

Bucket B items re-enter via their existing ADR-014 P2 / P8 gates. Until then: nothing ships; the audit
is recorded so the next prior-art pass starts from this verdict rather than re-discovering the fork.
