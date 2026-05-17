---
feature: save-spec
step: breakdown
created: 2026-05-17T21:05:00+07:00
updated: 2026-05-17T21:05:00+07:00
source-issue: 199
source-skill-version: 2.15.9
---

# Tasks: `/save-spec` skill — Phase 1 implementation

Atomic task list for implementing Decisions 1–10 + covering all 16 FRs from `prd.md` + `design.md`. Each task is sized for one focused execution (≤5 files; describable in one sentence). Tasks are prioritized Quadrant II (important, prevents future crises).

## Task list

### Task #1 — Create `skills/save-spec/SKILL.md`

**Task #1 implements**: Decision-7 (8-step Process), Decision-8 (frontmatter) (FR-001, FR-002, FR-003, FR-004, FR-005, FR-006, FR-007, FR-008, FR-009, FR-010, FR-011, FR-012, FR-013, FR-014, FR-015, FR-016)

Write the new skill file with: frontmatter (name, description, user-invocable, argument-hint, allowed-tools=[Read,Write,Glob,AskUserQuestion], prev-skill:any, next-skill:any), habit mapping (H8+H2), 8-step Process section in the exact structure pinned by Decision-7, Handoff section (any → any standalone), When to Skip, Definition of Done, H8 Checkpoint, Load directives for reference.md + h8-find-voice.md.

**Files**: `skills/save-spec/SKILL.md` (new, ~150–180 lines)
**Depends on**: none (foundational)

---

### Task #2 — Create `skills/save-spec/reference.md`

**Task #2 implements**: Decision-9 (reference.md contents) → Decision-2 (skip-sentinels), Decision-3 (refusal canonical text), Decision-4 (error canonical template), Decision-5 (timestamp format), Decision-6 (glob list) (FR-003, FR-004, FR-007, FR-008, FR-009, FR-012)

Write the reference doc with: full SPEC.md output template (verbatim from `guides/spec-digest-pattern.md:39-99` with substitution markers), Decision-3 refusal message canonical text, Decision-4 3-line error template with substitution markers, Decision-2 skip-sentinels list, Decision-6 glob filename set, 3–5 parse-example sets (edge cases: 0 items, 1 item, ≥3 items truncation, comma-vs-semicolon, whitespace trim), Decision-5 timestamp format string + rationale, cross-reference links to #199 open-question Q1–Q6 defaults.

**Files**: `skills/save-spec/reference.md` (new, ~100–140 lines)
**Depends on**: none (cross-references SKILL.md but writes independently)

---

### Task #3 — Add `/save-spec` validator Check to `tests/validate-structure.sh`

**Task #3 implements**: Decision-10 (canonical pinning) (FR-001 allowed-tools assertion; pins Process step count + canonical first-line phrases)

Append a new Check section (likely "Check 23" — verify next available number first) that asserts: frontmatter `name == save-spec`, `user-invocable == true`, `allowed-tools` array equals exactly `["Read", "Write", "Glob", "AskUserQuestion"]`, `prev-skill == any` + `next-skill == any`, Process section contains exactly 8 numbered steps (regex `^[1-8]\.\s+\*\*` count = 8), SKILL.md body contains literal phrase `SPEC.md already exists at` (Decision-3 pin), SKILL.md body contains literal phrase `Tried to create SPEC.md at` (Decision-4 pin), reference.md contains literal phrase `Skip-sentinels:` (Decision-2 documentation pin). All assertions use the existing `pass`/`fail` helper functions; do NOT introduce a new helper.

**Files**: `tests/validate-structure.sh`
**Depends on**: Task #1, Task #2 (this Check validates their output)

---

### Task #4 — Add 3 `/save-spec` trigger rows to `skills/RESOLVER.md`

**Task #4 implements**: Open-question Q6 default from issue #199 (S5 success criterion + Check 20 invariant)

Add exactly 3 trigger-phrase rows under the appropriate section (Assessment Skills or new section if more fitting per RESOLVER.md convention). Suggested phrases: `"scaffold a SPEC.md"`, `"save-point file for this repo"`, `"set up a project digest"`. Each row points to `skills/save-spec/SKILL.md` with a one-line purpose. Pin row count at 3 — `tests/validate-structure.sh` Check 20 (RESOLVER ↔ skills bidirectional) enforces this.

**Files**: `skills/RESOLVER.md`
**Depends on**: Task #1 (path exists for the row to cite)

---

### Task #5 — Update `guides/spec-digest-pattern.md` Promotion section

**Task #5 implements**: Promotion criterion 2 closure + Phase 1 ship status (covers issue #199 scope-resolution statement)

Rewrite the "## Promotion to a skill (deferred)" section (lines ~140–148) to:

1. Title change to "## Promoted to `/save-spec` in v2.16.0"
2. Add the scope-resolution statement from `prd.md` (the two-modes-are-disjoint paragraph) as a one-paragraph note inside this section
3. Replace the deferred-rationale text with: a one-line summary that the skill exists, a link to `skills/save-spec/SKILL.md`, and the criteria that were met (n=2 adopters, friction evidence in #197, scope question closed per this section)
4. Preserve issue #194 + #199 cross-references for historical traceability

**Files**: `guides/spec-digest-pattern.md`
**Depends on**: Task #1 (link target exists)

---

### Task #6 — Append Phase-1-shipped note to `docs/adr/ADR-013` addendum

**Task #6 implements**: ADR audit trail (no new ADR per Design Decision section "ADRs"; small note in existing addendum)

Append a 3–5 line "2026-05-17 follow-up" note to the existing addendum in `docs/adr/ADR-013-spec-persistence-opt-in.md` stating that the deferred `/save-spec` skill was promoted in v2.16.0 (link the SKILL.md path) and that the scope-resolution criterion was closed in writing via the prd.md statement (link). Do NOT touch the original Decision section or the existing addendum body — additive only.

**Files**: `docs/adr/ADR-013-spec-persistence-opt-in.md`
**Depends on**: Task #1 (link target exists)

---

### Task #7 — v2.16.0 release prep (version bump + release notes)

**Task #7 implements**: Release packaging (success criterion S4 — both validators pass after bump)

Coupled multi-file release commit per the established v2.15.x pattern (validator pins consistency across all version markers — must land atomically). Touch exactly:

1. `.claude-plugin/plugin.json` — `"version": "2.15.9"` → `"2.16.0"`
2. `.claude-plugin/marketplace.json` — `"version": "2.15.9"` → `"2.16.0"`
3. `README.md` — version badge URL, footer `_Version: 2.15.9 | Last updated: …_`, NEW `## What's New in v2.16.0` section (above existing v2.15.9 section), NEW row in "Skills Reference → Assessment Skills" table for `/save-spec`
4. `SELF-CHECK.md` — header `**Version**: 2.15.9 | **Date**: 2026-05-16 | **Previous**: 2.15.8 …` → `2.16.0 | 2026-05-17 | Previous: 2.15.9 …`, NEW v2.16.0 entry row above v2.15.9 in the version-log section, footer `_Updated with each release. Previous: 2.15.9 …_` (verifier `tests/validate-content.sh` Check 19 derives expected previous from git tags)
5. `CHANGELOG.md` — NEW `## v2.16.0 — …` section above v2.15.9 (Added/Changed/Pattern/Validator-state structure matching v2.15.9 release)
6. `docs/wiki/Changelog.md` — badge `v2.15.9` → `v2.16.0`, NEW v2.16.0 entry above v2.15.9

**6 files** — release prep is the canonical exception to the >5-file rule per workflow.md convention. Splitting would break validator atomicity invariants and cause CI red between intermediate commits.

**Files**: 6 listed above
**Depends on**: Task #1, Task #2, Task #3, Task #4, Task #5, Task #6 (release notes accurately describe what shipped)

---

### Task #8 — Run validators + 8-habit-reviewer + fix findings

**Task #8 implements**: Quality gate (PRD success criterion S4 + DoD checkbox "8-habit-reviewer dispatch passes")

Run in order: `bash tests/validate-structure.sh` (expect 256+ PASS / 0 FAIL — the new Check 23 from Task #3 adds ~8 assertions, count goes up); then `bash tests/validate-content.sh` (expect 217+ PASS / 0 FAIL / 1 WARN — Check 19 docs-freshness re-verifies after Task #7); then dispatch `8-habit-reviewer` agent against the full diff with focused-attention items (FR coverage, Decision-7 8-step Process integrity, canonical-string drift). Fix any HARD findings before Task #9. SOFT findings can be deferred to a follow-up PR.

**Files**: read-only validation + fix any flagged files
**Depends on**: Task #7

---

### Task #9 — Commit + push + open PR

**Task #9 implements**: Workflow.md mandatory sequence step 3 (commit-push-pr)

Single commit (or 2 commits if reviewer feedback in Task #8 generated a fixup) with conventional-commits message: `feat(save-spec): add /save-spec skill — Phase 1 minimum viable per #199`. Push branch `feat/199-save-spec-skill` with `-u origin`. Open PR base=`main`, head=`feat/199-save-spec-skill`, title same as commit, body with Summary / Why / Files changed table / Test plan checklist / Habit mapping / Refs #199 #197 + claude-governance#34.

**Files**: git tree only
**Depends on**: Task #8

---

## Orchestration table

| Task                   | Type          | Isolation                                 | Depends On             |
| ---------------------- | ------------- | ----------------------------------------- | ---------------------- |
| T1 (SKILL.md)          | parallel-safe | same repo, isolated new file              | none                   |
| T2 (reference.md)      | parallel-safe | same repo, isolated new file              | none                   |
| T3 (validator Check)   | sequential    | —                                         | T1, T2                 |
| T4 (RESOLVER rows)     | parallel-safe | same repo, shared file but different rows | T1                     |
| T5 (guide update)      | parallel-safe | same repo, isolated section               | none                   |
| T6 (ADR addendum)      | parallel-safe | same repo, additive append                | none                   |
| T7 (release prep)      | sequential    | —                                         | T1, T2, T3, T4, T5, T6 |
| T8 (validate + review) | sequential    | —                                         | T7                     |
| T9 (commit-push-pr)    | sequential    | —                                         | T8                     |

**Parallel-safe groups** (executable concurrently within same repo, no worktree needed):

- **Round 1**: T1, T2, T5, T6 — 4 independent file writes; no overlapping content; safe to dispatch as parallel subagents OR execute sequentially in one Claude session (lazy parallelism gate suggests sequential for ≤5 tool calls per task)
- **Round 2**: T3, T4 — both depend on Round 1; can run together if Round 1 fully complete

**Recommendation**: execute sequentially (T1 → T2 → T5 → T6 → T3 → T4 → T7 → T8 → T9) in a single Claude session per the lazy-parallelism gate. Each task is ≤5 tool calls; parallel coordination overhead exceeds the savings for a single-author PR. Significance profile — terse, no dispatching ceremony.

## Scope guard check

For each task, asked: "Is this Q2 (important + prevents future crises)?"

- T1, T2, T5, T6 — core implementation, Q2 ✅
- T3 — testability, prevents future regression, Q2 ✅
- T4 — discoverability per Check 20, Q2 ✅
- T7 — release packaging, Q2 ✅
- T8 — quality gate, Q1 (prevents urgent regressions) ✅
- T9 — delivery, Q2 ✅

No Q3 (urgent-not-important) gold-plating identified. No Q4 (neither) tasks present.

[/breakdown] COMPLETE SKILL_OUTPUT:breakdown

<!-- SKILL_OUTPUT:breakdown
task_count: 9
tasks:
  - "T1 implements: Decision-7+Decision-8 (FR-001 through FR-016) — Create skills/save-spec/SKILL.md with 8-step Process + frontmatter"
  - "T2 implements: Decision-9 (FR-003, FR-004, FR-007, FR-008, FR-009, FR-012) — Create skills/save-spec/reference.md with template + canonical strings + parse examples"
  - "T3 implements: Decision-10 (FR-001) — Add validator Check pinning frontmatter array, 8-step Process count, canonical phrases"
  - "T4 implements: Q6 default (S5) — Add 3 RESOLVER.md trigger rows for /save-spec"
  - "T5 implements: promotion criterion 2 closure — Update guides/spec-digest-pattern.md Promotion section to Promoted-in-v2.16.0 + scope-resolution statement"
  - "T6 implements: ADR audit trail — Append 2026-05-17 follow-up note to ADR-013 addendum"
  - "T7 implements: S4 release packaging — v2.16.0 bump across 4 version files + CHANGELOG + wiki Changelog + README What's New + SELF-CHECK entry"
  - "T8 implements: DoD validators-pass + 8-habit-reviewer ≥14/17 — Run validate-structure.sh + validate-content.sh + 8-habit-reviewer; fix HARD findings"
  - "T9 implements: workflow.md mandatory step 3 — Single conventional-commits commit, push -u, open PR base=main with full body"
dependencies:
  - "T3 depends on T1+T2 (validates them)"
  - "T4 depends on T1 (cites SKILL.md path)"
  - "T7 depends on T1+T2+T3+T4+T5+T6 (release notes describe complete diff)"
  - "T8 depends on T7 (gate after release prep)"
  - "T9 depends on T8 (commit after passing gate)"
estimated_complexity: "medium"
END_SKILL_OUTPUT -->
