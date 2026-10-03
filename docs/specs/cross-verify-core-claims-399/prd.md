---
feature: cross-verify-core-claims-399
step: requirements
created: 2026-10-03T00:00:00+07:00
updated: 2026-10-03T00:00:00+07:00
source-issue: 399
related-issue: 393
source-skill-version: 2.21.49
target-version: 2.21.50
---

# PRD: `/cross-verify` score scope + core-claim gating (#399, bundled with #393)

**Intake mode**: Existing-system mode — every requirement anchors to a cited file, lesson, or issue.

## Feature: Cross-verify core-claim gating

**What**: `/cross-verify` reports state that the score measures process completeness, not correctness; the review names its core claims; and an unverified core claim forces a `hold: verify core claim` recommendation without changing the score. Bundles the #393 residue cleanup (word-cap margin, validator scope, AGENTS.md lessons).

**Why**: Two `/cross-verify` runs (69% and 78.6%) were read as "ready" while substantive defects were found later only by independent checks — a cross-vendor challenge (`~/.claude/lessons/2026-07-28-evidence-that-cannot-discriminate.md:51-55`) and live host execution (`~/.claude/lessons/2026-10-02-autoharness-third-party-plugin-evaluation.md:39`). Root cause in the skill: only `PASS` counts and `OPEN_VERIFICATION_DEBT` blocks only a production `FINAL_KEEP` (`skills/cross-verify/SKILL.md:95,149`), so for non-production plan/patch reviews an unverified core claim cannot change the band or recommendation. No question covers runtime exercise of changed behavior outside bug fixes (Q5 `:58`, Q12 `:70`, diagnosis note `:82`). Author-side gates share the author's evidence (`guides/independent-source-verification.md:16-21`).

**Counter-evidence kept in scope**: 22 lessons cite `/cross-verify` most useful vs 2 least; it works when a **low** score forces change (8/14 pre-code run, `~/.claude/lessons/2026-07-28-meta-loop-ceremony-accretion-freeze.md:25-30`). The fix must not weaken that path.

**Who**: Anyone running `/cross-verify` on their own work, on Claude Code, Codex, or Hermes.

**In scope**:

- `skills/cross-verify/SKILL.md` (report header, core-claims line, recommendation rule, percent bands, Shadow Self-Check prompts)
- `guides/cross-verification.md` (detail for integration runtime exercise, absence-claim writer check, discriminating question; percent bands)
- `tests/test-cross-verify-release-gates.sh` (content pins for FR-001–007)
- #393 item 1: two lessons into `AGENTS.md` "Conventions and pitfalls"
- #393 item 2: `tests/validate-structure.sh` Check 9 scans `plugin/skills/` too
- #393 item 3: Check 9 WARN at >1950 words; restore margin on `cross-verify`
- #393 item 4: any margin claim in CHANGELOG/README uses `wc -w`
- `SKILL-EFFECTIVENESS.md` harvest of the two lessons
- `scripts/sync-mirror.sh` mirror, 6-file version sync to 2.21.50 (patch), `CHANGELOG.md`, `docs/wiki/Changelog.md`

**Out of scope**:

- Removing or demoting `/cross-verify`
- Runtime enforcement or automated cross-vendor dispatch (`DOMAIN.md:23`; belongs in `claude-governance`)
- A Q18 (keeps the 17-question dimension table intact)
- A new `edge-case-hunting` skill
- Trimming `management-talk`, `scrutinize`, `consistency-check`, `post-mortem` (the WARN from FR-011 surfaces them instead)

## Acceptance Criteria (EARS)

1. [Ubiquitous] FR-001: The cross-verify report header shall contain the line `Score scope: process completeness (verification) — not evidence that conclusions or changed runtime behavior are correct (validation).`
2. [Ubiquitous] FR-002: The cross-verify report shall list its **core claims** — the claim the change exists to make true, every integration-boundary claim, and every absence claim — each as `claim — evidence source — independent? (Y/N)`. <!-- Amended after review F3: a free choice of 1–3 claims let the reviewer omit the risky one. -->
3. [Unwanted] FR-003: If a core claim presented as established (built, diagnosed, observed) is `FAIL` or `OPEN_VERIFICATION_DEBT`, then a `proceed` or `address gaps` recommendation shall become `hold: verify core claim` (a new recommendation value); lower bands keep their recommendation; the score and band shall be computed unchanged; and the claim shall be listed under `Blocking gates/debt`. <!-- Amended during build: success criterion 2 replay showed an unqualified rule would hold every pre-implementation plan, whose claims are unbuilt by definition. Those go to the Q5 test plan instead. -->
4. [Optional] FR-004: Where the change crosses an integration boundary (permissions/allowlists, hooks, host↔plugin boundary, CLI flags), a core claim shall count as `PASS` only with evidence of exercise on the real host plus a control case; mocked-host unit tests alone shall be recorded as `OPEN_VERIFICATION_DEBT`.
5. [Unwanted] FR-005: If a conclusion asserts that X did not happen because artifact Y is absent, then the reviewer shall cite the code line that writes Y and confirm it executes on that path; otherwise the conclusion shall be recorded as `OPEN_VERIFICATION_DEBT`.
6. [Event-driven] FR-006: When the Shadow Self-Check runs, the reviewer shall answer (a) "Which conclusions have only been checked by me, with my own evidence?" and (b) "If this conclusion were false, would my evidence look different?"; any core claim answering no to (b) shall be recorded as `OPEN_VERIFICATION_DEBT`, and any answering yes to (a) or no to (b) shall be named as a candidate for an independent pass (cross-vendor, reviewer agent, or live execution). <!-- Amended after review F1: 'candidate' alone left non-discriminating evidence able to PASS. -->
7. [Ubiquitous] FR-007: The Scoring Bands tables in `skills/cross-verify/SKILL.md` and `guides/cross-verification.md` shall state half-open percent thresholds (≥88% / ≥70% / ≥47% / <47%, equivalent to 15, 12, 8 of 17) alongside raw pass counts. <!-- Amended after review: closed ranges left 87.5%, 69.2%, 46.2% in no band. -->
8. [Ubiquitous] FR-008: `skills/cross-verify/SKILL.md` shall be ≤1970 words by `wc -w`; FR-004–006 detail lives in `guides/cross-verification.md` with a one-line rule in the skill. <!-- Ceiling set by validator cap (2000, tests/validate-structure.sh:272) minus 30-word margin per #393 item 3; precedent calibration (step 4a) N/A — cap is validator-defined. -->
9. [Ubiquitous] FR-009: `tests/test-cross-verify-release-gates.sh` shall pin the key strings of FR-001–003, FR-006, and FR-007 in the skill and FR-004–005 in the guide; the new assertions shall fail on `main` at 5d5e0e3 and pass after the change.
10. [Ubiquitous] FR-010: `tests/validate-structure.sh` Check 9 shall scan both `skills/*/SKILL.md` and `plugin/skills/*/SKILL.md`, matching Check 8c's file set (#393 item 2).
11. [State-driven] FR-011: While a `SKILL.md` is above 1950 and at most 2000 words by `wc -w`, Check 9 shall emit a `WARN` naming the file and remaining margin, without failing (#393 item 3).
12. [Ubiquitous] FR-012: `AGENTS.md` "Conventions and pitfalls" shall contain the two #393 item 1 lessons — the 2000-word hard cap checked with `wc -w`, and ship CI enforcement in the same PR as any new mandatory convention.

## Success Criteria

1. **Case 2 replay**: filling the new template with Case 2's facts (78.6%, allowlist core claim = debt) yields recommendation `hold: verify core claim`, not "address gaps, then proceed".
2. **No regression on the working path**: replaying the 8/14 pre-code review yields the same band and recommendation as before.
3. `bash tests/ci-local.sh` and `node scripts/generate-skill-catalog.js --check` pass.
4. `skills/` and `plugin/skills/` are identical after `bash scripts/sync-mirror.sh`; Check 9 now proves it.
5. All six version-bearing files read `2.21.50`.

## Definition of Done

- [ ] FR-001–012 pass; new test assertions observed failing before the change
- [ ] CHANGELOG.md + docs/wiki/Changelog.md entries (margins quoted from `wc -w`)
- [ ] `SKILL-EFFECTIVENESS.md` harvests the two lessons: `/cross-verify` least/confusing 1→2; `missed_skill: edge-case-hunting` noted as a non-skill signal
- [ ] #399 and #393 closed with rationale

## Risks

- R1: FR-002 becomes ceremony (vague claims written to pass) — mitigated by requiring an evidence source and the `independent?` column.
- R2: Word budget (1996/2000 today) — mitigated by FR-008 moving detail to the guide; real trims required.
- R3: New recommendation value `hold: verify core claim` unknown to downstream readers — mitigated by defining it in the Output template and Scoring Bands prose in the same PR.
- R4: Absence-claim rule (FR-005) over-applied to trivial cases — scoped to conclusions only, not every observation.

<!-- SKILL_OUTPUT:requirements
ears_count: 12
ears_criteria:
  - "FR-001: Report header states score = process completeness, not correctness"
  - "FR-002: Report lists mandatory core claims (headline, integration, absence) with evidence source and independence flag"
  - "FR-003: Unverified/failed core claim forces 'hold: verify core claim'; score unchanged"
  - "FR-004: Integration-boundary core claim PASS requires real-host exercise + control"
  - "FR-005: Absence claims must cite the writer line or become debt"
  - "FR-006: Shadow Self-Check asks own-evidence-only + discriminating-evidence questions"
  - "FR-007: Scoring bands state percent thresholds"
  - "FR-008: cross-verify SKILL.md <=1970 words by wc -w"
  - "FR-009: release-gates test pins FR-001-007 strings; fails before, passes after"
  - "FR-010: Check 9 scans skills/ and plugin/skills/"
  - "FR-011: Check 9 WARN above 1950 words"
  - "FR-012: AGENTS.md gains the two #393 item 1 lessons"
scope_in: "cross-verify SKILL.md + guides/cross-verification.md + release-gates test + validate-structure Check 9 + AGENTS.md lessons + SKILL-EFFECTIVENESS harvest + mirror + 2.21.50 version sync + changelogs"
scope_out: "no removal/demotion of cross-verify; no runtime enforcement or automated cross-vendor dispatch; no Q18; no edge-case-hunting skill; no trims of other near-cap skills"
primary_user: "anyone running /cross-verify on their own work (Claude Code, Codex, Hermes)"
risks:
  - "R1: core-claims list becomes ceremony"
  - "R2: word budget at 1996/2000"
  - "R3: new recommendation value unknown downstream"
  - "R4: absence-claim rule over-applied"
success_criteria_count: 5
END_SKILL_OUTPUT -->
