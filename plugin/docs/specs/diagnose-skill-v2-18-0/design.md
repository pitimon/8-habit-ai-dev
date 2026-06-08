---
slug: diagnose-skill-v2-18-0
version: 1
created: 2026-05-23
predecessor: prd.md
successor: tasks.md (next: /breakdown)
authors: Pitimon (human) + Claude Opus 4.7 (1M context)
decisions: 5
sticky_decisions: 3
article_14_applicable: false
---

# Design: `/diagnose` skill for 8-habit-ai-dev v2.18.0

## Scope alignment check (against `prd.md` SKILL_OUTPUT)

- `scope_in` from PRD: new SKILL.md ≤2000w, 6-phase methodology, H1+H5 map, ADR-015, version sync, validator coverage. ✓ Design stays within.
- `success_criteria_count: 6` from PRD — Decisions 1, 4, 5 cover criteria 1, 2, 3, 4; Decision 5 covers criterion 5; Decision 4 covers criterion 6.
- 5 risks from PRD all addressed in design constraints (see Coverage Matrix and Constraints sections).

## Decision-1: SKILL.md file structure — single-file vs split

**Option A**: Single `skills/diagnose/SKILL.md`, ≤2000 words.

- Pro: simpler maintenance; matches majority of skills (deploy-guide, monitor-setup, security-check)
- Con: 2000-word budget fragile once frontmatter + 6 phases + habit map + checkpoint + skip rule + handoff + structured output added. Edits risk breaching F3.

**Option B**: `SKILL.md` (≤2000w) + `skills/diagnose/reference.md` (no limit), with explicit `Load reference.md for X` directives in SKILL.md.

- Pro: F3 fitness safe; matches precedent (`skills/research/`, `skills/using-8-habits/`, `skills/cross-verify/` all split); detail preserved
- Con: 2 files to maintain; reference can drift from SKILL.md without discipline

**Decision**: **Option B** — covers FR-007 (frontmatter chain), FR-009 (frontmatter declarations), FR-012 (word budget).

> **STICKY**: Reversing the split mid-implementation means rewriting all content under word-budget pressure. Once committed to split, stay committed.

**Decision-maker**: Pitimon (human)

---

## Decision-2: Bash tool inclusion in `allowed-tools`

**Option A**: `allowed-tools: ["Read", "Glob", "Grep"]` — read-only, no Bash.

- Pro: matches ADR-009 strictest interpretation; lowest privilege
- Con: Phase 1 (build feedback loop) is hands-on — skill must explicitly recommend commands. Without Bash, the skill cannot demonstrate the loop running (must defer to user)

**Option B**: `allowed-tools: ["Read", "Glob", "Grep", "Bash"]` — include Bash with documented scope.

- Pro: Phase 1 demonstration possible (e.g., `bun test --watch`, `pytest -x`, `curl health-endpoint`); precedent in `/review-ai`, `/ai-dev-log`, `/eu-ai-act-check`
- Con: per `CLAUDE.md` — _"Bash tool is allowed in skills only when needed... add Bash only with justification"_ — requires explicit ADR/skill-body justification

**Decision**: **Option B**, with scope guardrail documented in SKILL.md body: _"Bash is permitted ONLY for read-only feedback-loop construction (running tests, curl health checks, log inspection). Mutations (writes, deploys, deletes) remain forbidden."_ Covers FR-005 (instrumentation), FR-006 (regression test), FR-008 (feedback loop). Justification recorded in ADR-015.

> **Non-sticky** (semi-sticky 10–50% rework): could remove Bash later if abuse pattern emerges; would refactor Phase 1 + Phase 4 examples.

**Decision-maker**: Pitimon (human)

---

## Decision-3: FR-014 — predecessor `/research` brief detection pattern

**Option A**: Lazy heuristic — SKILL.md says _"Read past briefs if `~/.claude/plans/` exists and contains topic-matching files."_ No glob spec.

- Pro: simple; no path coupling
- Con: heuristic; false-positives on unrelated briefs likely

**Option B**: Pattern-specified — SKILL.md prescribes exact glob: `~/.claude/plans/*.md`, `docs/specs/*/research.md`, plus `~/.claude/lessons/*.md` for past-friction grep.

- Pro: deterministic; reproducible
- Con: brittle if path conventions evolve

**Option C**: User-supplied path — Phase 1 includes a prompt: _"If you ran `/research` on this bug, paste the brief path now. Otherwise this skill proceeds without prior context."_ Silent skip if not provided.

- Pro: explicit user agency; no filesystem coupling; honors H5 (user, not skill, decides what context matters)
- Con: depends on user remembering they ran `/research`

**Decision**: **Option C** with documented standard paths (`~/.claude/plans/`, `docs/specs/*/research.md`) listed in skill body as hint. Covers FR-014.

> **Non-sticky**: change to Option B (glob auto-detection) later if Option C friction emerges via reflect signal.

**Decision-maker**: Pitimon (human)

---

## Decision-4: ADR-015 outline + scope separation from design.md

**Option A**: ADR-015 documents adoption + n=1 friction + design decisions all in one ADR.

- Pro: single canonical record
- Con: ADR becomes design.md duplicate; future architectural reversals confusingly target a fat ADR

**Option B**: ADR-015 records ONLY the adoption decision + n=1 framing (mirrors ADR-014 structure). Design-time decisions (1-3, 5) live here in `design.md`. Future architectural changes get their own ADR-NNN.

- Pro: ADR-015 stays focused; clean separation of doctrine (ADR) vs design (design.md); precedent set by ADR-014 + `docs/specs/mattpocock-t1-v2-17-0/`
- Con: requires discipline to know which artifact gets which kind of change

**Decision**: **Option B**. ADR-015 structure:

1. Status: Accepted
2. Context: ADR-014 doctrine inheritance; n=1 friction citation (lesson 2026-04-12 with verbatim "no 8-habit skills invoked" quote)
3. Decision: adopt `/diagnose` as new skill in v2.18.0
4. Consequences: forward guardrail framing (per ADR-014); risk that n=1 is below ADR-014's n≥2 doctrine bar — accepted because friction is real and skill is additive
5. Options considered: ship, defer-with-issue, bundle (rejected per ADR-014 second-pass research brief)
6. Compliance with plugin boundary: workflow discipline → 8-habit-ai-dev (not claude-governance)

Covers PRD success criterion 6 (ADR-015 published) + FR-001 framing.

> **STICKY**: ADR-vs-design separation is a process invariant. Conflating them mid-build = rework on every future ADR/design touch.

**Decision-maker**: Pitimon (human)

---

## Decision-5: 6-phase content adaptation strategy from mattpocock SHA `b8be62ffacb0118fa3eaa29a0923c87c8c11985c`

**Option A**: Verbatim port — Copy mattpocock `skills/engineering/diagnose/SKILL.md` text directly, add 8-habit frontmatter on top.

- Pro: fastest; preserves discipline exactly; MIT-compatible
- Con: voice mismatch (Matt's tone is direct/concrete; 8-habit's is process-discipline); no H1+H5 value-add; FR-010 (habit map) not satisfied without re-write anyway

**Option B**: Adapt with attribution — Preserve 6 phases + key vocabulary (feedback-loop, falsifiable hypotheses, tagged probes, post-green refactor). Rewrite in 8-habit voice with explicit habit map, checkpoint, skip rule, handoff. Attribute source SHA in skill body footer and ADR-015.

- Pro: idiomatic; adds H1+H5 framing per FR-010; license attribution explicit; matches how P1 (AGENT-BRIEF) was adapted in v2.17.0
- Con: more writing work; paraphrasing risks methodology drift — mitigate by quoting the FR-004 _"If X causes it, then Y will make it disappear"_ prediction verbatim and citing source line numbers

**Option C**: Skeleton + reference.md offload — SKILL.md has phase names + 1-line each + `Load reference.md` for full methodology. Reference carries the depth.

- Pro: maximally compact SKILL.md
- Con: detail not visible to a user reading SKILL.md top-to-bottom; against "process disciplines should be self-contained at the top level"

**Decision**: **Option B + Decision-1 split**. SKILL.md carries: frontmatter, 6 phases (compact paragraph each, ~150 words/phase = ~900 words for phases), habit map H1+H5 + checkpoint, when-to-use, when-to-skip (FR-011), handoff (FR-007). `reference.md` carries: full mattpocock prior-art notes with SHA-pinned source URL, longer examples per phase, false-positive patterns from lesson 2026-04-12.

Verbatim-quote anchor (preserve methodology fidelity per R5 mitigation): FR-004 hypothesis template _"If X causes it, then changing Y will make the bug disappear"_ — quoted verbatim with source URL `https://raw.githubusercontent.com/mattpocock/skills/b8be62ffacb0118fa3eaa29a0923c87c8c11985c/skills/engineering/diagnose/SKILL.md`.

Covers FR-001 through FR-006, FR-008, FR-010, FR-011, FR-013.

> **STICKY**: Adaptation strategy committed. Changing mid-implementation (e.g., flipping to verbatim port) means rewriting the skill.

**Decision-maker**: Pitimon (human)

---

## Coverage Matrix (FR → Decision)

| FR     | Title                              | Covered by                                  |
| ------ | ---------------------------------- | ------------------------------------------- |
| FR-001 | 6-phase methodology                | Decision-5                                  |
| FR-002 | Phase 1 first on invoke            | Decision-5                                  |
| FR-003 | P1 → P2 transition                 | Decision-5                                  |
| FR-004 | 3–5 falsifiable hypotheses         | Decision-5 (with verbatim quote)            |
| FR-005 | Debugger > logs                    | Decision-5 + Decision-2 (Bash for examples) |
| FR-006 | Regression test before fix         | Decision-5 + Decision-2                     |
| FR-007 | Handoff to /post-mortem            | Decision-1 (frontmatter)                    |
| FR-008 | Phase 1 blocker fallback           | Decision-5                                  |
| FR-009 | Frontmatter declarations           | Decision-1 + Decision-2                     |
| FR-010 | Habit map H1+H5 + checkpoint       | Decision-5 (Option B explicitly adds)       |
| FR-011 | Skip rule for simple bugs          | Decision-5                                  |
| FR-012 | ≤2000 words                        | Decision-1 (split)                          |
| FR-013 | Description ≤1024 + trigger phrase | Decision-5 (description writing)            |
| FR-014 | Predecessor /research detection    | Decision-3 (Option C)                       |

All 14 FRs covered. No orphan requirements.

## Constraints (carried from PRD)

- **C1 (ADR-009 read-only)**: ✓ skill remains read-only guidance; Bash scope guardrail (Decision-2) explicitly forbids mutations
- **C2 (Plugin boundary)**: ✓ workflow discipline → 8-habit-ai-dev (not claude-governance enforcement)
- **C3 (Zero-dep)**: ✓ pure markdown
- **C4 (F3 fitness ≤2000 words)**: ✓ Decision-1 split + Decision-5 paragraph budget
- **C5 (Version sync atomicity)**: ✓ v2.18.0 across plugin.json, marketplace.json, README.md, SELF-CHECK.md in one commit (Check 4)
- **C6 (No DAG break)**: ✓ new skill adds `prev-skill: any, next-skill: post-mortem` — additive only
- **C7 (Honest framing per ADR-014)**: ✓ ADR-015 records n=1 transparently (Decision-4)

## Risks (from PRD) — design-time mitigations

| ID  | Risk                                     | Mitigation in this design                                                                                                                    |
| --- | ---------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| R1  | Overlap with /post-mortem                | Decision-5: explicit When-to-Use boundary in SKILL.md body; Decision-1 frontmatter chain establishes sequence                                |
| R2  | Overlap with /research                   | Decision-5: trigger-phrase differentiation (debug/diagnose/reproduce vs investigate/research/compare)                                        |
| R3  | n=1 friction below n≥2 bar               | Decision-4: ADR-015 records this transparently per ADR-014 doctrine                                                                          |
| R4  | 6-phase too prescriptive for simple bugs | Decision-5: FR-011 skip rule in SKILL.md body                                                                                                |
| R5  | SKILL.md exceeds 2000-word F3 limit      | Decision-1: split + Decision-5: paragraph budget (~150w × 6 phases = 900w core, leaves ~1100w for frontmatter/checkpoints/handoff/skip rule) |

## Article 14 Human-Oversight Checkpoint

| Capability            | Question | Pass? |
| --------------------- | -------- | ----- |
| ¶4(a) Understand      | n/a      | n/a   |
| ¶4(b) Automation bias | n/a      | n/a   |
| ¶4(c) Interpret       | n/a      | n/a   |
| ¶4(d) Override        | n/a      | n/a   |
| ¶4(e) Stop button     | n/a      | n/a   |

**Article 14 applicable**: false. The `/diagnose` skill is **markdown guidance consumed by Claude Code**, not itself a high-risk AI decision system per Annex III. Not EU-targeted as a regulated AI deployment. The skill HELPS humans diagnose bugs — humans retain full Article 14 capabilities throughout (understand the system, override, stop).

Reference: `pitimon/claude-governance` v3.1.0+ owns the formal Annex III scope check via `/eu-ai-act-check --scope` (migrated per ADR-012).

## Sticky vs non-sticky summary

| Decision                               | Sticky?     | Rework if changed mid-build           |
| -------------------------------------- | ----------- | ------------------------------------- |
| Decision-1 (split)                     | **STICKY**  | >50% (rewrite all content)            |
| Decision-2 (Bash inclusion)            | semi-sticky | 10–50% (rewrite Phase 1 + 4 examples) |
| Decision-3 (FR-014 detection Option C) | non-sticky  | <10% (swap prompt language)           |
| Decision-4 (ADR-vs-design separation)  | **STICKY**  | >50% (re-fragment all artifacts)      |
| Decision-5 (Option B adaptation)       | **STICKY**  | >50% (rewrite skill content)          |

3 sticky decisions of 5 — appropriate for a new skill where structure and adaptation strategy are load-bearing.

## H8 Checkpoint

"Do I understand WHY we're building it this way, not just WHAT?"

✓ Yes:

- **Body**: validators ensure CI gates pass; F3 (≤2000w) baked into Decision-1
- **Mind**: serves the documented gap between `/research` (too broad) and `/post-mortem` (too late) — vision is "active debugging discipline"
- **Heart**: skill respects user agency (Decision-3 Option C); when-to-skip rule respects simple cases
- **Spirit**: honest framing (Decision-4 ADR-015); n=1 disclosed; license attribution preserved

## Handoff

- **Expects from predecessor** (`/requirements`): PRD at `docs/specs/diagnose-skill-v2-18-0/prd.md` (delivered ✓)
- **Produces for successor** (`/breakdown`): atomic task list — write SKILL.md, write reference.md, write ADR-015, version sync 4 files, CHANGELOG + wiki/Changelog entries, validator-suite verification

[/design] COMPLETE SKILL_OUTPUT:design

<!-- SKILL_OUTPUT:design
decision_count: 5
decisions:
  - "Decision-1: SKILL.md split — single-file vs SKILL.md+reference.md → Option B (split)"
  - "Decision-2: Bash inclusion — strict read-only vs +Bash-with-scope → Option B (+Bash with feedback-loop scope guardrail)"
  - "Decision-3: FR-014 predecessor brief detection → Option C (user-supplied path, with documented standard locations)"
  - "Decision-4: ADR-015 vs design.md separation → Option B (ADR records adoption + n=1 framing only; design decisions live in design.md)"
  - "Decision-5: 6-phase content adaptation from mattpocock SHA b8be62ff → Option B (adapt with attribution, verbatim FR-004 quote anchor)"
sticky_decisions:
  - "Decision-1 (split) — STICKY, >50% rework if reversed"
  - "Decision-4 (ADR-vs-design separation) — STICKY, >50% rework if conflated"
  - "Decision-5 (Option B adaptation) — STICKY, >50% rework if flipped to verbatim or skeleton"
constraints:
  - "C1 ADR-009 read-only (Bash scope guardrail in skill body)"
  - "C2 Plugin boundary — workflow discipline in 8-habit-ai-dev"
  - "C3 Zero-dep — pure markdown"
  - "C4 F3 fitness <=2000 words (Decision-1 split + Decision-5 budget)"
  - "C5 Version sync atomicity — 4 files in one commit"
  - "C6 No DAG break — additive only"
  - "C7 Honest framing — ADR-015 records n=1"
adr_references:
  - "ADR-015: this work (planned, scope per Decision-4)"
  - "ADR-014: external prior-art doctrine (parent)"
  - "ADR-009: skill split convention (precedent for Decision-1)"
  - "ADR-012: EU AI Act migration (referenced in Article 14 checkpoint)"
article_14_applicable: false
article_14_pass: n/a
END_SKILL_OUTPUT -->
