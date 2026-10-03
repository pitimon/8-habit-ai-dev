---
feature: cross-verify-core-claims-399
step: breakdown
created: 2026-10-03T00:00:00+07:00
updated: 2026-10-03T00:00:00+07:00
source-issue: 399
related-issue: 393
source-skill-version: 2.21.49
---

# Tasks: `/cross-verify` core-claim gating (#399 + #393) → v2.21.50

**Assumption**: Decision-6 = no ADR (design recommendation; user did not override). If ADR-027 is wanted, add it as T9 before T8.

**Branch**: `feat/399-cross-verify-core-claims` from `main`.

## Task List

1. [ ] **T1 — RED: pin #399 contract in the release-gates test** — add assertions for FR-001/002/003/006/007 (skill) and FR-004/005 + `%` bands (guide); run it and record the failure on 5d5e0e3. | Files: `tests/test-cross-verify-release-gates.sh` | Depends on: none
   Task #1 implements: Decision-1, Decision-2, Decision-3 (FR-009)
   Verify: `bash tests/test-cross-verify-release-gates.sh` → FAIL (new assertions only; existing 18 still PASS)

2. [ ] **T2 — Guide: Core-Claim Verification section + % bands** — add `## Core-Claim Verification` (integration runtime exercise + control case, absence-claim writer check, discriminating question, link to `production-release-gates.md` for production) and a `%` column in the Scoring Guide. | Files: `guides/cross-verification.md` | Depends on: T1
   Task #2 implements: Decision-2, Decision-3 (FR-004, FR-005, FR-006, FR-007)
   Verify: guide assertions in T1 pass

3. [ ] **T3 — Skill: header lines, core claims, hold rule, Shadow prompts, % bands, trims** — add `Score scope` + `Core claims` header lines, `hold: verify core claim` to the Recommendation enum + rule, two Shadow Self-Check prompts, `%` column; trim CHANGELOG-duplicated history (`:34,:43`) and Confidence examples to reach ≤1970 words. | Files: `skills/cross-verify/SKILL.md` | Depends on: T1, T2 (links to guide section name)
   Task #3 implements: Decision-1, Decision-3, Decision-5 (FR-001, FR-002, FR-003, FR-006, FR-007, FR-008)
   Verify: T1 test fully green; `wc -w skills/cross-verify/SKILL.md` ≤ 1970; every trimmed fact found by `grep` in `CHANGELOG.md`

4. [ ] **T4 — Validator: Check 9 scope + margin WARN** — loop over `find skills/ plugin/skills/ -name SKILL.md`; WARN for 1951–2000 with remaining margin; hard fail >2000 unchanged. | Files: `tests/validate-structure.sh` | Depends on: none
   Task #4 implements: Decision-4 (FR-010, FR-011)
   Verify: run suite → WARN lines for the near-cap skills (`management-talk`, `post-mortem`, `scrutinize`, `consistency-check`); fixture check: temp-append 10 words to a copy under `plugin/skills/` → FAIL fires, then revert

5. [ ] **T5 — AGENTS.md lessons** — add the two #393 item 1 lessons under "Conventions and pitfalls" (2000-word cap measured with `wc -w`; ship CI enforcement with any new mandatory convention). | Files: `AGENTS.md` | Depends on: none
   Task #5 implements: FR-012
   Verify: `grep -n "wc -w" AGENTS.md` and `grep -n "same PR" AGENTS.md` hit

6. [ ] **T6 — Effectiveness harvest** — `/cross-verify` least/confusing 1→2 citing the two lessons; record `missed_skill: edge-case-hunting` as non-skill signal; harvest note for v2.21.50. | Files: `SKILL-EFFECTIVENESS.md` | Depends on: none
   Task #6 implements: PRD DoD (harvest)
   Verify: row reads `24 | 2 |`; note names both lesson filenames

7. [ ] **T7 — Release surface** — bump 2.21.49→2.21.50 in the 6 version-bearing files; CHANGELOG + wiki Changelog entry (word margins from `wc -w`, pointer to `docs/specs/cross-verify-core-claims-399/`); README "What's New" + band line if needed. | Files: `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`, `.codex-plugin/plugin.json`, `plugin/.codex-plugin/plugin.json`, `README.md`, `SELF-CHECK.md`, `CHANGELOG.md`, `docs/wiki/Changelog.md` | Depends on: T2–T6
   Note: >5 files but a single mechanical version-sync unit enforced by Check 4 — splitting it would leave the tree failing validation between tasks.
   Task #7 implements: PRD success criterion 5
   Verify: `grep -rn '"version"' .claude-plugin .codex-plugin plugin/.codex-plugin` all 2.21.50; `validate-content.sh` release-doc freshness passes

8. [ ] **T8 — Mirror + full validation + replay** — `bash scripts/sync-mirror.sh`; `bash tests/ci-local.sh`; `node scripts/generate-skill-catalog.js --check`; paper-replay Case 2 (→ `hold: verify core claim`) and the 8/14 pre-code case (→ unchanged band and recommendation). | Files: `plugin/**` (generated) | Depends on: T7
   Task #8 implements: PRD success criteria 1–4
   Verify: all suites `ALL CHECKS PASSED`; replay results written into the PR description

## Orchestration

| Task | Type | Isolation | Depends On | Priority | Readiness |
|------|------|-----------|------------|----------|-----------|
| T1 | sequential | — | none | Q1 (RED first) | ready-for-agent |
| T2 | sequential | — | T1 | Q2 | ready-for-agent |
| T3 | sequential | — | T1, T2 | Q2 | ready-for-agent |
| T4 | parallel-safe | same repo | none | Q2 | ready-for-agent |
| T5 | parallel-safe | same repo | none | Q2 | ready-for-human (protected-file consent for `AGENTS.md`, per #393 item 1) |
| T6 | parallel-safe | same repo | none | Q2 | ready-for-agent |
| T7 | sequential | — | T2–T6 | Q2 | ready-for-agent |
| T8 | sequential | — | T7 | Q1 (gate) | ready-for-agent |

**Lazy parallelism gate**: T4/T5/T6 are disjoint, but each is ≤3 tool calls — run sequentially in one session; no sub-agents.

**Scope guard**: no Q18, no ADR, no trims of other near-cap skills (WARN surfaces them), no runtime enforcement. Q4 items eliminated: README band rewording beyond adding `%`, retroactive edits to `docs/reviews/`.

**After merge (human)**: close #399 and #393 with rationale comments; tag `v2.21.50`.

<!-- SKILL_OUTPUT:breakdown
task_count: 8
tasks:
  - "T1: RED test pins FR-001-007 in release-gates test"
  - "T2: Guide Core-Claim Verification section + % bands"
  - "T3: Skill header/core-claims/hold rule/Shadow prompts/% bands/trims <=1970 words"
  - "T4: Check 9 scans both trees + 1951-2000 WARN"
  - "T5: AGENTS.md two #393 lessons"
  - "T6: SKILL-EFFECTIVENESS harvest (least 1->2)"
  - "T7: Version 2.21.50 sync + changelogs"
  - "T8: Mirror sync + ci-local + catalog check + case replays"
dependencies:
  - "T2 after T1; T3 after T1+T2"
  - "T4, T5, T6 independent"
  - "T7 after T2-T6; T8 after T7"
estimated_complexity: "medium"
END_SKILL_OUTPUT -->
