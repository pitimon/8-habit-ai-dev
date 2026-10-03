---
feature: cross-verify-core-claims-399
step: design
created: 2026-10-03T00:00:00+07:00
updated: 2026-10-03T00:00:00+07:00
source-issue: 399
related-issue: 393
source-skill-version: 2.21.49
---

# Design: `/cross-verify` core-claim gating (#399 + #393)

**Pass level**: Focus — one skill, one guide, two validator scripts, one doctrine file. Not Full: no persistence, auth, deployment, or runtime surface; plugin stays doctrine-only (`DOMAIN.md:23`).

**Scope alignment** (PRD `scope_in`): every decision below maps to FR-001–012; none adds a skill, Q18, or enforcement.

## Decision-1: Where core claims live in the report — STICKY

Decision-1 covers: FR-002, FR-003

- **Option A**: New `**Core claims**` block in the report header, separate from the 17 questions; `hold: verify core claim` added to the Recommendation enum. — Pro: score/band/dimension math untouched; claim is named, not categorised (the Case 1 failure). Con: one more header line to fill.
- **Option B**: Fold core claims into Q12 evidence. — Pro: no template change. Con: Q12 is bug-fix-scoped (`SKILL.md:70`) and category-level — exactly where Case 1 flagged "single source" yet missed the claim.
- **Steelman B**: fewer moving parts, no new vocabulary, and Q12 already speaks independent-source language. It still loses because Q12 is one of 17 equally weighted PASS counts; a gating rule needs to sit outside the count.
- **Recommendation**: A (matches PRD FR-003 decision (a)).
- **Sticky**: the Recommendation enum is the consumer-visible contract; changing it later means re-running `/design`.

## Decision-2: Where FR-004/005/006 detail lives — semi-sticky

Decision-2 covers: FR-004, FR-005, FR-006, FR-008

- **Option A**: New `## Core-Claim Verification` section in `guides/cross-verification.md`; SKILL.md carries a one-line rule plus the existing `Load ${CLAUDE_PLUGIN_ROOT}/guides/cross-verification.md` directive (`SKILL.md:182`, Hermes note already present at `:189`).
- **Option B**: Extend `guides/production-release-gates.md` runtime-reconciliation section (`:45-59`). — Pro: runtime read-back vocabulary already exists. Con: that guide is production-scoped; Case 2 was a non-production patch — the exact gap.
- **Option C**: New guide `guides/core-claim-verification.md`. — Pro: clean. Con: new load directive + Hermes note + mirror + validator Check 8 entry, for ~150 words.
- **Steelman B**: one home for "runtime evidence" avoids two vocabularies drifting. Mitigation under A: the new section cross-links `production-release-gates.md` for production work instead of restating it.
- **Recommendation**: A.

## Decision-3: Band table format — flexible

Decision-3 covers: FR-007

- **Option A**: Add a `%` column next to existing counts in both tables (`SKILL.md:142-147`, `guides/cross-verification.md:79-84`). — Pro: backward compatible with `README.md:395` and past review records (`docs/reviews/2026-06-10-fable-model-review.md:66`).
- **Option B**: Replace counts with percent. — Con: forces README + historical wording churn.
- **Recommendation**: A. Thresholds: ≥88% / ≥70% / ≥47% / <47% (= 15, 12, 8 of 17), half-open. <!-- Amended after review F4: closed ranges left 87.5%, 69.2%, 46.2% in no band. -->

## Decision-4: Check 9 scope + margin WARN — flexible

Decision-4 covers: FR-010, FR-011

- **Option A**: Rewrite Check 9 loop to `find skills/ plugin/skills/ -name SKILL.md` (same file set as Check 8c, `tests/validate-structure.sh:253`); add `WARN` branch for 1951–2000 words with remaining margin.
- **Option B**: Keep Check 9, add Check 9c for `plugin/skills/` only. — Con: two loops, same rule, drift risk.
- **Recommendation**: A. WARN only — never fail below 2000 (keeps #392 hard gate semantics).

## Decision-5: SKILL.md word-budget source — flexible

Decision-5 covers: FR-008

Today 1996 words (`wc -w`). FR-001/002/003/006 + band `%` add ≈ +90 words; target ≤1970 ⇒ trim ≈ 120 words.

- **Option A**: Trim version-history parentheticals already recorded in CHANGELOG (Auto-Detection steps 2 and 5, `SKILL.md:34,43`) and compress the Confidence table example column (`:88-93`).
- **Option B**: Move Domain Question Packs list (`:170-180`) into the guide. — Con: discovery regression — users find packs from the skill.
- **Recommendation**: A. Verify during build that every trimmed fact exists in CHANGELOG.

## Decision-6: ADR or not — Requires approval

- **Option A**: No ADR; this PRD + design + CHANGELOG are the record. — Pro: change stays inside existing doctrine (`guides/independent-source-verification.md`, ADR-021 discipline/engine boundary); no boundary moves.
- **Option B**: Thin ADR-027 "cross-verify score scope and core-claim gating". — Pro: the Recommendation enum change is consumer-visible; >3 files touched (design DoD trigger).
- **Steelman B**: a future contributor seeing `hold: verify core claim` will look in `docs/adr/` first, not `docs/specs/`.
- **Recommendation**: A, with a CHANGELOG pointer to this spec directory. Human decides.

## Load-bearing claims

| Claim | Label | Evidence | Verify first |
|---|---|---|---|
| Band computed from PASS count only; debt blocks only production `FINAL_KEEP` | Confirmed | Direct — `SKILL.md:95,142-149` | No |
| No script parses the Recommendation field, so a new enum value breaks nothing | Inferred | grep: only `README.md:395`, `docs/reviews/…:66`, `SKILL.md:126` mention values; no test parses them | Yes — re-grep `tests/` + `scripts/` at build |
| Check 9 scans only `skills/`; Check 8c scans both trees | Confirmed | Direct — `tests/validate-structure.sh:264,253` | No |
| ~120 words trimmable without losing doctrine | Assumed | Assumed | Yes — confirm each trimmed fact is in CHANGELOG |
| Hermes resolves the guide via existing note | Confirmed | Direct — `SKILL.md:189`, Check 8c | No |

## Constraints / non-goals

- `wc -w` is the only margin measure (#393 item 4).
- New test assertions must fail on 5d5e0e3 before implementation (FR-009).
- No Q18; dimension table unchanged.
- `scripts/sync-mirror.sh` after every root edit; `.codex-plugin/` untouched except version.

## Approval required

- **Blocking**: Decision-1 (enum change) — already approved via PRD FR-003 (a).
- **Important**: Decision-6 (ADR yes/no).
- **Useful**: Decisions 2–5 — proceed on recommendation unless overridden.

**H8 check**: Body — CI covers it (FR-009/010/011). Mind — serves #399 without demoting the working low-score path (PRD success criterion 2). Heart — one header block, not a new question. Spirit — honest about what the score proves.

<!-- SKILL_OUTPUT:design
pass_level: Focus
decision_count: 6
decisions:
  - "Decision-1: Core-claims header block + 'hold: verify core claim' recommendation value (FR-002, FR-003)"
  - "Decision-2: FR-004/005/006 detail in guides/cross-verification.md; one-line rule in SKILL"
  - "Decision-3: Add % column beside pass counts in both band tables"
  - "Decision-4: Check 9 scans skills/ + plugin/skills/; WARN 1951-2000 words"
  - "Decision-5: Trim CHANGELOG-duplicated history + Confidence example column to reach <=1970 words"
  - "Decision-6: No ADR; spec dir + CHANGELOG are the record (requires approval)"
sticky_decisions:
  - "Decision-1: Recommendation enum is consumer-visible contract — >50% rework to change"
constraints:
  - "wc -w is the only word-margin measure"
  - "New test assertions must fail before implementation"
  - "No Q18; no runtime enforcement"
load_bearing_claims:
  - "Confirmed: band uses PASS count only; Evidence: Direct; Verify first: No"
  - "Inferred: no parser consumes Recommendation; Evidence: Inferred; Verify first: Yes"
  - "Confirmed: Check 9 scans skills/ only; Evidence: Direct; Verify first: No"
  - "Assumed: ~120 words trimmable without doctrine loss; Evidence: Assumed; Verify first: Yes"
approval_required:
  - "Blocking: Decision-1 (approved via PRD FR-003 a)"
  - "Important: Decision-6 ADR yes/no"
adr_references:
  - "ADR-021: dynamic-workflow-positioning (discipline vs engine)"
article_14_applicable: false
article_14_pass: n/a
END_SKILL_OUTPUT -->
