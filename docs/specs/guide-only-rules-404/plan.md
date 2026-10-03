---
feature: guide-only-rules-404
step: plan
created: 2026-10-03T22:30:00+07:00
source: Jev decision (openrouter/typesafe/jev-1.13, 2026-10-03) + owner review
---

# Plan: required rules that live only in optional guides (#404) + Hermes sync

## Input from Jev

| Question | Choice | Confidence | Distribution |
|---|---|---|---|
| Next step | A: #404 audit | 0.35 | A .47 · C .29 · B .10 · E .10 · D .04 |
| Nested-absence residual (C) | inside #404 | 0.82 | within .88 · before .09 · defer .03 |

Adjustments to Jev's ranking (owner may override):
- A's low confidence comes from C (0.29). Since C goes inside #404 with high confidence, A and C become one workstream.
- B (Hermes sync) is small and affects daily use. It runs first as a timeboxed step (≤ 30 min), not as a rival priority.
- D (three deferred drafts) stays parked under its drop dates (2027-01-03).

## Phase 0: Hermes sync (B), timeboxed

**Goal**: bring `~/.hermes/skills/productivity/{review-ai,8-habit-resolver}` up to v2.21.52, matching `cross-verify` and `8-habit-diagnose`.

1. Find how the port is built: the test session "rebuilt SKILL.md with the port's Hermes transforms". Locate that transform (script or skill) before editing by hand. **Do not hand-patch if a generator exists.**
2. Apply it to `review-ai` (Owner note, CONCERNS cap, DoD, template) and to the resolver plus the bundled `references/upstream/skills/RESOLVER.md` (Composite Triggers, `@pro-ready-review`).
3. Verify by grepping the Hermes copies for `Owner note confirmed` and `@pro-ready-review`, then run `/review-ai` once in Hermes on a trivial diff and check that an Owner note appears.

Exit: both skills carry the text, and one live run shows an Owner note. If no generator exists, stop and ask: a hand patch creates a third copy to maintain.

## Phase 1: Research (audit), #404

**Question**: which guide passages change a verdict, a score, or required output, yet have no counterpart in the owning `SKILL.md`?

Starting inventory (grep for binding language, 2026-10-03):

| Guide | Binding hits | Loaded by | First look |
|---|---|---|---|
| `structured-output-protocol.md` | 17 | breakdown, design, requirements, review-ai | Emission gate is already summarized in review-ai; check the others |
| `persistence-convention.md` | 11 | breakdown, consistency-check, design, requirements, save-spec | slug regex, required frontmatter: output-shape rules |
| `production-release-gates.md` | 6 | cross-verify | debt ≠ PASS is already in SKILL.md |
| `cross-verification.md` | 5 | cross-verify | #402 fixed; integration real-host rule only summarized |
| `behavioral-spec-craft.md` | 5 | design, requirements | likely guidance, not verdict |
| `integrity-principles.md` | 2 (+14 commandments) | research, review-ai, post-mortem, scrutinize, management-talk | commandments are "never" rules |
| `independent-source-verification.md` | 2 | diagnose, reflect, cross-verify | partly summarized already |

Method:
1. For each guide × loading skill, list every sentence that uses binding language (MUST, never, is debt, caps, blocks, required, counts as PASS only).
2. Classify each as **verdict-changing**, **output-shape**, or **background**.
3. For each verdict-changing or output-shape rule, check whether `SKILL.md` carries it (grep for the key phrase). Record: present / summarized / **missing**.
4. Note the word budget of each owning SKILL.md. `cross-verify` is at 1970/2000, so it has no room.

Output: `docs/specs/guide-only-rules-404/research.md`, an audit table with file:line for every row.

## Phase 2: Requirements + design

Decisions to make, with the options already visible:

| Decision | Options | Lean |
|---|---|---|
| Where a missing rule goes | (a) short form in SKILL.md; (b) make the guide load a numbered **required** step; (c) leave it, marked background | (a) when the word budget allows, else (b) |
| CI enforcement (AGENTS.md: same PR) | (1) lint: binding phrase in guide → matching anchor in SKILL.md or allowlist; (2) only a required-load check; (3) none | (1) with an explicit allowlist, WARN first then FAIL (validator brittleness risk) |
| Scope per release | one patch for all skills vs. per-skill patches | decide after the audit size is known |

## Phase 3: Build

Test-first: string pins for each moved rule fail before and pass after. Mirror sync, word caps checked with `wc -w`.

## Phase 4: Blind eval (A + C together)

- Rules: the top 2–3 verdict-changing rules found in Phase 1.
- **C case**: an absence nested inside a broader claim ("learning keeps working: reflection never triggered…"), written **before** the fix.
- Arms: old SKILL.md only / new SKILL.md only / old SKILL.md + guide. n=3, neutral prompt, SKILL.md-only file access.
- **Different model family**: run the independent arm through the other test machine, which used a different family for #402. One family alone is the main known limit.
- Pre-register the metrics before running, to avoid scoring drift.

## Phase 5: Review and release

`@pro-ready-review` → Owner note → merge → tag → update installed copies (Claude Code, Codex, **and the Hermes copy via the Phase 0 path**).

## Owner decisions needed

1. Phase 0: OK to timebox, and to stop and ask if there is no port generator?
2. CI check: start as WARN, or FAIL from day one?
3. Cross-model eval: use the other test machine for the independent arm?

## Not in scope

- New skills or new checklist questions (ceremony freeze).
- Runtime enforcement of guide loading (ADR-021).
- D drafts (parked until 2027-01-03).
