# Skill Authoring Guide

> "If agent doesn't follow process, edit SKILL.md carefully — avoid polluting it with supplementary data. Keep core process focused." — Ben AI, summarized in Vibe Coding Thailand, May 2026

This guide explains **how to author a new 8-habit-ai-dev skill**: the pre-work that earns the SKILL.md, the canonical skeleton it should follow, and the lifecycle hooks that keep it honest after it ships. It is meta-doc, not a runtime skill — read this before drafting a new `skills/<name>/SKILL.md`, or before reviewing a contributor PR that adds one.

The guide closes two gaps surfaced by the 2026-05-24 [research brief](https://github.com/pitimon/8-habit-ai-dev/issues/235) against Vibe Coding Thailand's _"คู่มือสร้าง Claude Skills ให้เก่งกว่าคนทั่วไป"_:

- **N1 — Pre-Building Preparation absent.** 23 skills exist; the only authoring artifact was `CONTRIBUTING.md §"Adding a New Skill"` (a structural template, not a methodology). The reference-doc-first habit Ben AI promotes had no home in the project.
- **P2 — Objective conflated with trigger.** Existing skills treat frontmatter `description` (a trigger phrase enforced by Check 25) and the `**Habit**: H? — <name>` annotation (a label) as if they jointly substituted for a dedicated Objective. They do not. This guide makes the distinction explicit and ships a matching `CONTRIBUTING.md` template diff.

The audit comparison against [ADR-017](../docs/adr/ADR-017-anthropic-skill-patterns-audit.md) (which evaluated Anthropic's 5 _structural_ SKILL.md patterns) showed Ben AI's framework operates one layer up — **authoring methodology**, not runtime hygiene. The two layers are complementary; this guide names that complementarity instead of re-litigating it.

## Audience

- **Primary**: future contributors authoring a new `skills/<name>/SKILL.md` for this plugin
- **Primary**: future Claude sessions reading this guide before drafting a SKILL.md (the same model that loads `/research` should load this)
- **Secondary**: plugin maintainers reviewing skill PRs — the guide makes "good skill shape" explicit and reviewable
- **Not for**: end users invoking existing skills (they read `skills/RESOLVER.md` instead)

## Pre-Building Preparation (the work that earns the SKILL.md)

Skills fail more often from premature SKILL.md writing than from poor SKILL.md writing. The fix is to draft reference content collaboratively with Claude **before** opening `skills/<name>/SKILL.md`, then keep the SKILL.md itself focused on process — supplementary data lives in sibling files loaded on demand per [ADR-009](../docs/adr/ADR-009-skill-split-convention.md).

### Step 1 — Decide whether this is a skill at all

Three questions; if any answer is "no," don't open `skills/<name>/`:

1. **Is this guidance the plugin should carry, or doctrine for me alone?** Personal-workflow notes belong in `~/.claude/CLAUDE.md` or `~/.claude/rules/`. The plugin ships shared discipline.
2. **Does it map cleanly to one habit?** If two or more habits compete, decompose. If none fits, the skill is solving a problem outside the 8-habit charter.
3. **Is there friction evidence?** Per [ADR-014](../docs/adr/ADR-014-external-prior-art-audit.md) and [ADR-017](../docs/adr/ADR-017-anthropic-skill-patterns-audit.md), shipping discipline-doc with zero friction signal is acceptable as a **forward guardrail** — but the contributor must say so explicitly. If you cannot cite friction and cannot make the forward-guardrail case, the skill is speculative; file an issue and wait for friction.

### Step 2 — Draft the four reference docs first (read-only, sibling to future SKILL.md)

Ben AI's Pre-Building Preparation pattern names five reference-doc types (process, ICP, voice, frameworks, visual style). For an 8-habit-ai-dev skill, four map directly:

| Doc                           | What it contains                                                                                                                                                                      | Where it lives                                                                                                                        |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| **Process notes**             | The actual procedure the skill encodes, written in long-form before compression to SKILL.md. Bullet-style is fine — this is your working draft, not the final shape.                  | Scratch in `~/.claude/plans/<slug>.md` or `docs/specs/<slug>/prd.md` (if using `/requirements --persist`)                             |
| **Audience map**              | Who invokes the skill, when, what they already know. Drives the verbosity baseline.                                                                                                   | Embedded in the PRD's "Who" section                                                                                                   |
| **Voice + anti-pattern list** | The tone (terse / pedagogical / etc.) and the failure modes the skill is preventing. Drives the language register.                                                                    | `skills/<name>/references/voice.md` if non-trivial; otherwise a short "Anti-pattern" line at the top of SKILL.md                      |
| **Examples**                  | At least one concrete worked example demonstrating the skill end-to-end. Mattpocock's repo treats this as load-bearing; we adopt the same convention via `skills/<name>/examples.md`. | `skills/<name>/examples.md` — human-curated, the skill READS it but never WRITES it (read-only charter per `CLAUDE.md §Architecture`) |

Two in-repo precedents exist: `skills/calibrate/examples.md` (4.9K) and `skills/using-8-habits/examples.md` (2.5K). Whether new skills SHOULD ship an `examples.md` by default is **T2-deferred (N4b)** in [ADR-020](../docs/adr/ADR-020-skill-authoring-guide.md) §"T2 Bag" — the precedent works, but defaulting all new skills to it has no friction signal yet. Use the precedents when authoring a skill that hands off concrete artifacts (specs, briefs, decision matrices); skip otherwise. Re-entry as a default is triggered by a `/reflect` lesson citing "this skill would have been clearer with a curated examples.md" (drop date 2026-11-24).

### Step 3 — Compress to SKILL.md only when the references are stable

The SKILL.md is the **summary** of the references, not the references themselves. If a sentence in SKILL.md can be replaced by `Load ${CLAUDE_PLUGIN_ROOT}/skills/<name>/references/<file>.md`, do that — the load directive defers cost to when the section actually matters. The opposite mistake — inlining reference content into SKILL.md — bloats the description-routing surface that Check 25 enforces and the on-demand-load surface that [ADR-009](../docs/adr/ADR-009-skill-split-convention.md) protects.

## The canonical SKILL.md skeleton

Every skill in this plugin follows the same five-section shape. Sections may be expanded, but none should be omitted; the consistency is what lets `/cross-verify` and the validators reason about skills generically.

```markdown
---
name: <skill-name>
description: >
  This skill should be used when the user asks to [specific trigger phrases].
  [What it does in 1-2 sentences]. Maps to H[N] ([Habit Name]).
user-invocable: true
argument-hint: "[what the user provides]"
allowed-tools: ["Read", "Glob", "Grep"]
prev-skill: <skill-name|none|any>
next-skill: <skill-name|none|any>
---

# [Title] ([Thai translation])

**Habit**: H[N] — [Habit Name] | **Anti-pattern**: [What this skill prevents]

## Objective

[One sentence stating what the user gets from invoking this skill. Distinct from the trigger above and the habit tag — this is the outcome, in plain language, that justifies the skill existing.]

## Process

1. **[Step]**: [Instructions]
2. **[Step]**: [Instructions]

## Handoff

- **Expects from predecessor**: [What input this skill needs]
- **Produces for successor**: [What output this skill creates]

## When to Skip

- [Honest condition where this skill is genuinely unnecessary]
- [Another honest skip condition]

## Definition of Done

- [ ] [Verifiable checkbox item]
- [ ] [Verifiable checkbox item]
- [ ] [Verifiable checkbox item]

Load `${CLAUDE_PLUGIN_ROOT}/[reference-file].md` for detailed guidance.
```

### Why Objective is a section, not a tagline

The three fields above the Objective do **different jobs**:

| Field                      | Job                                                                                                                                                                        | Audience                                                        |
| -------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------- |
| Frontmatter `description`  | **Trigger** — the model routes to this skill when the user's message matches the description's trigger phrases. Enforced by Check 25 (≤1024 chars, trigger-phrase rubric). | The model deciding which skill to run                           |
| `**Habit**: H[N] — <name>` | **Label** — the one-line tag connecting the skill to its parent habit and the anti-pattern it prevents.                                                                    | The human reading the skill                                     |
| `## Objective`             | **Outcome** — what the user receives if the skill runs to completion. The single sentence a reviewer can quote in the PR to verify the skill earned its place.             | The human authoring, the human reviewing, the model summarizing |

Conflating the three is the failure mode Vibe Coding Thailand's article exposed (and the 2026-05-24 research-brief audit ratified). The Objective section is short — usually one sentence — but it must exist and must be distinct from the trigger and the label.

## Authoring lifecycle (when to invoke which skill)

Skill authoring is itself a feature; the 7-step workflow applies. The order:

1. **`/research`** — verify the problem space and check for prior art. For pattern-import work specifically (auditing an external framework, library, or post), invoke in **Audit mode** and dispatch the `research-verifier` agent if any code-symbol claims are made. The advisor-then-reviewer-then-revise pattern (documented in user-local lesson `~/.claude/lessons/2026-05-24-anthropic-5-pattern-audit-adr-017.md` and [`guides/advisor-pattern.md`](advisor-pattern.md)) is load-bearing for external-pattern audits.
2. **`/requirements`** (optional but recommended for skills with ≥3 acceptance criteria) — produce a PRD with EARS criteria. Persist with `--persist <slug>` so `/consistency-check` can verify the PRD-design-tasks chain later.
3. **Draft the four reference docs** (per "Pre-Building Preparation" above) — these may be informal scratch in `~/.claude/plans/`; what matters is that they exist before SKILL.md.
4. **Draft SKILL.md** following the skeleton above. Keep word count between 1,500 and 2,000 (per `CONTRIBUTING.md §"Adding a New Skill"` Conventions; max 5,000).
5. **`/reflect`** after the first end-to-end usage — answer Q6 honestly (most useful / least useful skill). The lesson file feeds `SKILL-EFFECTIVENESS.md` per [ADR-018](../docs/adr/ADR-018-memory-layer-activation.md). Skills that accumulate ≥5 "least useful/confusing" signals without offsetting positives trigger `/skill-improve` review.
6. **Iterate** until the skill earns its place. Ben AI's framework names ~5 iteration cycles to production quality; the 8-habit version of this is "the skill is done when `/reflect` lessons cite it without confusion for two consecutive non-trivial uses."

The SKILL-EFFECTIVENESS feedback loop is the project's anti-decay mechanism. Skills that never accumulate signal don't get deprecated automatically (per [ADR-018](../docs/adr/ADR-018-memory-layer-activation.md) — humans read, humans decide), but they do warrant a justification line in the next-tally update. Forecast the expected-use rate when shipping a new skill so future-you can tell "deliberately low-n" from "quietly broken."

## Cross-references (load these when authoring)

| When you need…                                                                                             | Read                                                                                        |
| ---------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| The skill-file template and frontmatter contract                                                           | [`CONTRIBUTING.md §"Adding a New Skill"`](../CONTRIBUTING.md)                               |
| The progressive-disclosure split convention (when to spin out reference files)                             | [ADR-009](../docs/adr/ADR-009-skill-split-convention.md)                                    |
| The external-prior-art doctrine (when adopting patterns from other repos / posts)                          | [ADR-014](../docs/adr/ADR-014-external-prior-art-audit.md)                                  |
| The NEVER/MUST + reason hygiene check (Check 26) and forward-guardrail sunset mechanism                    | [ADR-017](../docs/adr/ADR-017-anthropic-skill-patterns-audit.md)                            |
| The SKILL-EFFECTIVENESS feedback-loop activation + anti-dormancy forcing function                          | [ADR-018](../docs/adr/ADR-018-memory-layer-activation.md)                                   |
| The contributor-doctrine vs consumer-doctrine version-bump rule                                            | [ADR-019](../docs/adr/ADR-019-doctrine-only-scope-refinement.md)                            |
| The advisor-then-reviewer-then-revise pattern                                                              | [`guides/advisor-pattern.md`](advisor-pattern.md)                                           |
| Which patterns are already adopted vs evaluated-and-deferred from Anthropic / Karpathy / Claude Code posts | [`guides/anthropic-engineering-doctrine-audit.md`](anthropic-engineering-doctrine-audit.md) |
| EARS criteria template for `/requirements`                                                                 | [`guides/ears-notation.md`](ears-notation.md)                                               |
| Spec-persistence convention (`--persist <slug>`)                                                           | [`guides/persistence-convention.md`](persistence-convention.md)                             |

## Habit mapping

| Habit                                      | Why this guide maps                                                                                                                                                                                                                                                                       |
| ------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **H4** Win-Win — Emotional Bank Account    | A discoverable authoring guide is a deposit. The next contributor doesn't re-discover the four-reference-docs habit; the next Claude session doesn't re-conflate trigger with objective. Bank account credited per skill authored.                                                        |
| **H5** Seek First to Understand            | Pre-Building Preparation IS H5 applied to skill authoring. Drafting reference docs before SKILL.md is "read the existing problem space before writing the new code."                                                                                                                      |
| **H7** Sharpen the Saw                     | The guide closes a documented Production-Capability gap (23 skills, no discoverable authoring guide). Investing in the meta-tool that builds the tools is the canonical P/PC balance move.                                                                                                |
| **H8** Find Your Voice — Modeling (Spirit) | The plugin applies the friction-first standard to itself: this guide ships as a forward guardrail per ADR-014/017 precedent, with the same sunset mechanism, after the 8-habit-reviewer cross-verify rescued the brief from "ship nothing." We hold ourselves to the standard we publish. |

## Maintenance

- **Trigger**: a new SKILL.md authoring failure mode surfaces in a `/reflect` lesson or PR review, OR a new external-pattern audit (per `guides/anthropic-engineering-doctrine-audit.md` cadence) lands a row in Table 1 that this guide should reflect.
- **Action**: append to the relevant section (Pre-Building Preparation step, skeleton field, lifecycle stage, or cross-reference). Same evidence discipline as other guides — cite the lesson or ADR that motivates the change.
- **Cadence**: opportunistic. The forcing function is contributor friction or external-pattern adoption, not a calendar.
- **Sunset checkpoint**: 2026-11-24 per [ADR-020](../docs/adr/ADR-020-skill-authoring-guide.md) §"Forward-Guardrail Sunset". If by that date no `/reflect` lesson cites this guide and no contributor PR references it, the maintainer should evaluate reversion via a separate amendment ADR (per [ADR-017](../docs/adr/ADR-017-anthropic-skill-patterns-audit.md) §"Forward-Guardrail Sunset" mechanism — not [ADR-016](../docs/adr/ADR-016-t2-bag-drop-date-eviction-policy.md) eviction, which scopes only to never-shipped T2 items).
