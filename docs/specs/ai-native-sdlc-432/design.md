---
feature: ai-native-sdlc-432
step: design
created: 2026-11-09T05:05:00+07:00
updated: 2026-11-09T05:55:00+07:00
source-issue: 432
source-skill-version: unversioned (Hermes-installed design skill; no version field)
---

# Design: Evidence & Handoff Contract + Behavioral Eval Pilot

PRD: [prd.md](./prd.md) · Research: [research.md](./research.md) · **Pass level: Focus** · Status: **proposed; owner said "ทำต่อ" without answering Decision-1/Decision-2, so the recommended options are recorded as the working choice and remain revisable before implementation.**

## Constraints (Confirmed)

| Fact | Evidence |
| --- | --- |
| Word counts: `review-ai` 1903, `research` 1567, `deploy-guide` 1391, `build-brief` 998; cap 2000, WARN above 1950 | `wc -w skills/*/SKILL.md`, [AGENTS.md](../../../AGENTS.md) |
| `research` and `review-ai` already load `integrity-principles.md`; `build-brief` and `deploy-guide` do not; all four carry the Hermes note | `grep` over the four SKILL.md files |
| A rule that changes a required output must live in the owning `SKILL.md` and be pinned in `tests/test-guide-rule-anchors.sh` | [AGENTS.md](../../../AGENTS.md), `tests/test-guide-rule-anchors.sh` header |
| Skills are guidance, not enforcement; no new skill or hook in core | [DOMAIN.md](../../../DOMAIN.md) |
| Eval scenarios are manual documents (owner decision 1); four skills are touched (owner decision 2) | [prd.md](./prd.md) § Owner Decisions |

### Decision-1: Host guide for the contract

**Option A**: add a "Handoff contract" section (≤150 words) to `guides/integrity-principles.md`. Pro: evidence classes match commandments 1–4; `research`/`review-ai` already load it. Con: the file is mostly "never do" rules; `build-brief`/`deploy-guide` need a Load line.
**Option B**: `guides/structured-output-protocol.md`. Pro: already about cross-skill handoff. Con: it specifies machine-readable blocks and emission gates, so human-readable handoff rules would mix with it.
**Option C**: `guides/cross-verification.md`. Con: 1955 words, already near its ceiling.
**Steelman of B**: one place for everything handoff-related. Rejected because the contract mainly defines what counts as evidence, which the integrity commandments already own.
**Recommendation**: A. **Classification**: semi-sticky. **Status**: Proposed, `Requires approval`.
Decision-1 covers: FR-001, FR-002, FR-003, FR-004, FR-004N, FR-005, FR-006

### Decision-2: How binding the contract is

**Option A**: MUST for all five fields whenever work is handed to another session or agent. **Option B**: SHOULD only. **Option C**: MUST for Evidence and Not verified; SHOULD for Intent, Decisions, Next/stop.
**Steelman of B**: lowest burden. Rejected because an unchecked SHOULD repeats the problem recorded in `SKILL-EFFECTIVENESS.md` (a passing score read as a correct conclusion).
**Steelman of A**: simplest rule. Rejected because the documented friction is only about unsupported conclusions; Intent/Decisions/Next have no recorded failure yet (friction-first, ADR-014).
**Recommendation**: C. **Classification**: sticky for the MUST set. **Status**: Proposed, `Requires approval` (Blocking).
Decision-2 covers: FR-001, FR-001N, FR-002, FR-002N, FR-005N

### Decision-3: Skill text and pinning

Add one sentence per skill in its Handoff section, about 40 words, for example: "Handoff to another session or agent: state Evidence (Static / Executed test / Runtime, with method and result) and Not verified; a static or test result never establishes runtime behavior. See `integrity-principles.md` § Handoff contract." Pin the anchor phrase `static or test result never establishes runtime behavior` for all four skills in `tests/test-guide-rule-anchors.sh`. `review-ai` must stay below 1950 words; shorten the new sentence rather than existing content. Hermes: any new reference uses an absolute `blob/main` URL.
Decision-3 covers: FR-006, FR-006N, FR-007, FR-007N

### Decision-4: Eval pilot as a manual document

`docs/evals/handoff-pilot.md`, one file, linked from `llms.txt` only. Each scenario has Prompt, Expected behavior, Must-not-pass case, Deterministic check, Human-judged check and a result row (model, runtime, version, date, outcome, variance note). No script, no CI step, no pass threshold before a recorded baseline. Scenario 5 (Hermes/Codex not described as running Claude hooks) is checkable by grep against `docs/compatibility-matrix.md`.
Decision-4 covers: FR-003N, FR-009, FR-009N, FR-010, FR-010N, FR-011, FR-011N, FR-012, FR-012N

### Decision-5: Doctrine audit

Add playbook rows to `guides/anthropic-engineering-doctrine-audit.md` following its own rules: Table 1 rows need a file:line of the shipped implementation, Table 2 rows need tier and drop-date. Do not mix ECC items P1/P2/P4 into playbook rows; the article does not mention them.
Decision-5 covers: FR-008, FR-008N

### Decision-6: Verification and release hygiene

Run `bash scripts/sync-mirror.sh`, `bash tests/ci-local.sh` and `node scripts/generate-skill-catalog.js --check` (only if frontmatter changed). A release, version bump or merge is a separate owner gate under `guides/release-surface.md`.
Decision-6 covers: FR-013, FR-013N

## Load-bearing claims

| Claim | Label | Evidence | Verify first |
| --- | --- | --- | --- |
| The recorded friction is a passing score read as a correct conclusion | Confirmed | `SKILL-EFFECTIVENESS.md` v2.21.50 note | No |
| `review-ai` can take about 40 words and stay below 1950 | Inferred | current `wc -w` 1903 | Yes, measure after the edit |
| Adding the sentence to four skills keeps all validators green | Assumed | not yet tried | Yes, `ci-local.sh` |
| Option C (MUST for two fields) is sufficient | Proposed | friction evidence only | Yes, owner |
| Manual documents give a repeatable baseline | Unknown | untested | Yes, first pilot run |

## Approval gates still open

1. **Blocking**: Decision-2.
2. **Important**: Decision-1.
3. Separate gates, not authorized here: posting to issue #432, commit/merge/release, running the pilot on a paid model.

Article 14 checkpoint skipped: this is not an AI system targeting the EU market.

<!-- SKILL_OUTPUT:design
pass_level: Focus
decision_count: 6
decisions:
  - "Decision-1: host the Handoff contract in guides/integrity-principles.md"
  - "Decision-2: MUST for Evidence and Not verified; SHOULD for other fields"
  - "Decision-3: one pinned sentence in research, build-brief, review-ai, deploy-guide"
  - "Decision-4: manual eval pilot document docs/evals/handoff-pilot.md"
  - "Decision-5: playbook rows in the doctrine-audit guide"
  - "Decision-6: sync mirror and run ci-local; release is a separate gate"
sticky_decisions:
  - "Decision-2: MUST set of Evidence and Not verified"
constraints:
  - "SKILL.md at most 2000 words; review-ai stays below 1950"
  - "No new skill, hook or runtime enforcement"
  - "Rules that change required output live in SKILL.md and are pinned by anchor tests"
  - "No paid model run or CI eval step"
load_bearing_claims:
  - "Inferred: review-ai can take about 40 words; Evidence: Inferred; Verify first: Yes"
  - "Assumed: four-skill edit keeps validators green; Evidence: Assumed; Verify first: Yes"
  - "Proposed: Decision-2 option C is sufficient; Evidence: Inferred; Verify first: Yes"
approval_required:
  - "Blocking: Decision-2 enforcement level"
  - "Important: Decision-1 host guide"
adr_references:
  - "ADR-013: spec persistence opt-in"
  - "ADR-014: external prior-art audit"
  - "ADR-024: Codex runtime adapter boundary"
article_14_applicable: false
article_14_pass: n/a
END_SKILL_OUTPUT -->
