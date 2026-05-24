---
feature: skill-authoring-guide-235
step: requirements
created: 2026-05-24T22:00:00+07:00
updated: 2026-05-24T22:00:00+07:00
source-issue: 235
source-skill-version: 2.17.0
---

# PRD: `guides/skill-authoring.md` (Tier 1 forward guardrail)

## Feature: Skill Authoring Guide

**What**: A new contributor-and-Claude-discoverable guide at `guides/skill-authoring.md` documenting the methodology for authoring new 8-habit-ai-dev skills — Ben AI's Pre-Building Preparation pattern, the canonical SKILL.md skeleton (now with a dedicated **Objective** section), and the authoring lifecycle (when to invoke `/research`, `/reflect`, and the SKILL-EFFECTIVENESS feedback loop). Ships with a matching `CONTRIBUTING.md` template diff and a thin ADR-020 traceability deposit.

**Why**: Research brief (`~/.claude/plans/https-vibecodingthailand-com-blog-claude-vivid-wave.md`) identified two structural gaps:

- **N1 (Pre-Building Preparation)**: 23 skills exist, no discoverable authoring guide exists. `CONTRIBUTING.md §"Adding a New Skill"` template (lines 9-69) is contributor-only — not a `/research`-discoverable, model-readable doc.
- **P2 (Objective)**: Existing skills conflate "trigger" (frontmatter `description`, enforced by Check 25) with "objective" (what the skill accomplishes). No dedicated Objective section in the canonical skeleton.

8-habit-reviewer cross-verify (12/17) flagged a "Reuse, no action" verdict as repeating the selective-strictness anti-pattern that almost shipped the wrong ADR-017 verdict 4 days ago (lesson `~/.claude/lessons/2026-05-24-anthropic-5-pattern-audit-adr-017.md:25-26,33`). ADR-014 (4 patterns) and ADR-017 (P3) both shipped forward guardrails with zero documented friction signal — refusing N1 here on "no `/reflect` lesson cites it" would apply a stricter standard than the project's own recent precedent.

**Who**:

- **Primary**: Future contributors authoring new 8-habit-ai-dev skills (and future Claude sessions reading the guide before drafting a new SKILL.md)
- **Secondary**: Plugin maintainers reviewing skill PRs (the guide makes "good" skill-shape explicit and reviewable)
- **Not for**: End-users invoking existing skills — the guide is meta-doc, not a runtime skill

**In scope**:

- New `guides/skill-authoring.md` (~300-500 lines) covering: (a) Pre-Building Preparation pattern with a concrete example; (b) canonical SKILL.md skeleton including a dedicated **Objective** section; (c) lifecycle wiring — when to invoke `/research`, `/reflect`, the SKILL-EFFECTIVENESS feedback loop; (d) cross-references to ADR-009 (split convention), ADR-014 (external prior-art doctrine), ADR-017 (NEVER/MUST hygiene + sunset mechanism), ADR-018 (memory-layer activation), `CONTRIBUTING.md §"Adding a New Skill"` template
- `CONTRIBUTING.md` template diff (lines 19-69 region) — add `## Objective` section with one-line example
- New `docs/adr/ADR-020-skill-authoring-guide.md` (≤50 lines, doctrine-only) — cites ADR-014/017 precedent + cross-verify reconciliation; documents forward-guardrail sunset 2026-11-24
- `SKILL-EFFECTIVENESS.md` tally update entry for this release (per ADR-018 forcing function)
- Version bump per ADR-019 (consumer-doctrine: `guides/` edit MUST bump) — atomic across 4 files (`.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`, `README.md` badge+footer, `SELF-CHECK.md` header)
- CHANGELOG.md + docs/wiki/Changelog.md entries
- All validator suites pass: `tests/validate-structure.sh` (Check 4 version-sync, Check 25 description rubric, Check 26 NEVER/MUST hygiene), `tests/validate-content.sh`, `tests/test-skill-graph.sh`, `tests/test-verbosity-hook.sh`

**Out of scope**:

- NOT a new user-invocable skill (read-only guide only — does not warrant `skills/` directory)
- NOT a validator extension — Check 25/26 already cover the load-bearing P1/P5 hygiene
- NOT a `claude-governance` PostToolUse hook (plugin-boundary discipline per memory obs #233270)
- NOT N2 (multi-option HITL ≥5) — T2 deferred per brief, drop date 2026-11-24
- NOT N4b (per-skill `examples.md` extension) — T2 deferred per brief, drop date 2026-11-24
- NOT a retroactive sweep of all 23 existing skills to add Objective sections — guide informs future authoring; existing skills get amended only when otherwise touched
- NOT a port of Ben AI's full framework verbatim — adapt to 8-habit voice + reject N3/N4a per brief

**Success criteria** (verifiable):

1. `guides/skill-authoring.md` exists, references all 4 cited ADRs by filename, contains a Pre-Building Preparation section with at least one concrete example, and defines a SKILL.md skeleton including an Objective section
2. `CONTRIBUTING.md §"Adding a New Skill"` template includes a new `## Objective` section with one-line example, retains all existing template elements
3. `docs/adr/ADR-020-skill-authoring-guide.md` exists, ≤50 lines, cites ADR-014 and ADR-017 as precedent, documents the 2026-11-24 sunset checkpoint with reversal criteria
4. All 4 validator suites green on local + CI
5. Version bumped atomically — `tests/validate-structure.sh` Check 4 passes
6. `SKILL-EFFECTIVENESS.md` tally entry added for this release per ADR-018 forcing function

**Definition of Done**:

- [ ] `guides/skill-authoring.md` written and committed
- [ ] `CONTRIBUTING.md` template diff applied at lines 19-69
- [ ] `docs/adr/ADR-020-skill-authoring-guide.md` written and committed
- [ ] `SKILL-EFFECTIVENESS.md` tally entry added
- [ ] Version bumped atomically across 4 files
- [ ] CHANGELOG.md + docs/wiki/Changelog.md entries added
- [ ] All 4 validator suites green
- [ ] `/code-review` run and CRITICAL/HIGH addressed
- [ ] PR opened against `main`, description quotes the falsifiability criterion + sunset checkpoint
- [ ] PR squash-merged after CI green
- [ ] Issue #235 closed with rationale (not just "fixed")

## Acceptance Criteria (EARS)

1. [Ubiquitous] **FR-001**: The `guides/skill-authoring.md` file shall exist in the project's `guides/` directory and shall pass `tests/validate-content.sh` without errors.

2. [Ubiquitous] **FR-002**: The guide shall document Ben AI's Pre-Building Preparation pattern with at least one concrete worked example showing the reference-doc workflow (process docs → ICP → voice → SKILL.md).

3. [Ubiquitous] **FR-003**: The guide shall define a canonical SKILL.md skeleton that includes a dedicated `## Objective` section, explicitly distinguished from frontmatter `description` (trigger, enforced by Check 25) and the `**Habit**: H? — <name>` label.

4. [Ubiquitous] **FR-004**: The guide shall cross-reference at minimum ADR-009 (split convention), ADR-014 (external prior-art doctrine), ADR-017 (NEVER/MUST hygiene + sunset mechanism), ADR-018 (memory-layer activation), and `CONTRIBUTING.md §"Adding a New Skill"`.

5. [Event-driven] **FR-005**: When a contributor follows the guide's authoring sequence, the guide shall direct them to invoke `/research` (before authoring), `/reflect` (after first iteration), and the SKILL-EFFECTIVENESS feedback loop (after each iteration) at the documented lifecycle stages.

6. [Ubiquitous] **FR-006**: The `CONTRIBUTING.md §"Adding a New Skill"` template (lines 19-69 region) shall include a new `## Objective` section with a one-line example, while preserving all existing template elements (frontmatter, `## Process`, `## Handoff`, `## When to Skip`, `## Definition of Done`).

7. [Ubiquitous] **FR-007**: The `docs/adr/ADR-020-skill-authoring-guide.md` file shall exist as a doctrine ADR (≤150 lines body, excluding frontmatter; each required section must carry at least one decision, precedent claim, or re-entry condition — no decorative sections) citing ADR-014 and ADR-017 as precedent, documenting the cross-verify reconciliation, and setting a forward-guardrail sunset checkpoint of 2026-11-24 with explicit reversal criteria. **Calibration note (2026-05-24)**: the original FR-007 ceiling of "≤50 lines body" was unrealistic against the ADR-017 template (Context, Tier Framework, Options Considered, Honest Framing, Sunset, T2 Bag, OOS, Constraints, Consequences). Amended to ≤150 lines after pre-PR reviewer flagged the ceiling as PRD-vs-reality drift contaminating future `/consistency-check` runs.

8. [Ubiquitous] **FR-008**: The plugin version shall be bumped atomically across all 4 files (`.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`, `README.md` badge+footer, `SELF-CHECK.md` header) per ADR-019 (consumer-doctrine `guides/` edit MUST bump) and `tests/validate-structure.sh` Check 4 shall pass.

9. [Ubiquitous] **FR-009**: `SKILL-EFFECTIVENESS.md` shall be updated with a tally entry naming this release per the ADR-018 forcing function (anti-dormancy gate).

10. [Unwanted] **FR-010**: If any of the 4 validator suites (`validate-structure.sh`, `validate-content.sh`, `test-skill-graph.sh`, `test-verbosity-hook.sh`) reports an error after the changes, then the PR shall not be merged until the failure is resolved at root cause (not by suppression).

11. [Optional] **FR-011**: Where reviewers identify language in the guide or ADR that violates Check 26 (NEVER/MUST without an accompanying reason), the affected text shall be revised to satisfy the check before merge.

12. [Ubiquitous] **FR-012**: The pull request description shall quote the forward-guardrail sunset checkpoint of 2026-11-24 with the reversal criteria per ADR-017 §"Forward-Guardrail Sunset" mechanism (explicitly NOT ADR-016 eviction, which scopes only to never-shipped T2 items).

## Risks

- **R1**: Guide could pollute itself by being too long (>800 lines) → mitigation: aim for 300-500 lines, defer extended examples to `guides/skill-authoring-examples.md` if needed (separate future PR)
- **R2**: `CONTRIBUTING.md` template diff could break existing template parsing if any tooling assumes line numbers → mitigation: spot-check `tests/` and skill-creator references; line-number drift is acceptable because no tooling indexes by line
- **R3**: ADR-020 could be perceived as ADR-creep → mitigation: keep ≤50 lines, frame as "thin traceability deposit citing 014/017 as load-bearing precedent" (per ADR-018 §"Earn each line" discipline)
- **R4**: 2026-11-24 sunset could pile onto the ADR-016 review checkpoint queue → mitigation: explicitly note this sunset uses ADR-017's separate mechanism, not ADR-016 eviction

[/requirements] COMPLETE SKILL_OUTPUT:requirements

<!-- SKILL_OUTPUT:requirements
ears_count: 12
ears_criteria:
  - "FR-001: guides/skill-authoring.md exists and passes validate-content.sh"
  - "FR-002: Guide documents Pre-Building Preparation with concrete example"
  - "FR-003: Guide defines SKILL.md skeleton including dedicated Objective section"
  - "FR-004: Guide cross-references ADR-009/014/017/018 + CONTRIBUTING.md"
  - "FR-005: Guide directs lifecycle invocations of /research, /reflect, SKILL-EFFECTIVENESS"
  - "FR-006: CONTRIBUTING.md template includes new ## Objective section"
  - "FR-007: ADR-020 exists (≤50 lines body), cites ADR-014/017, sets 2026-11-24 sunset"
  - "FR-008: Version bumped atomically across 4 files, Check 4 passes"
  - "FR-009: SKILL-EFFECTIVENESS.md tally entry added per ADR-018"
  - "FR-010: All 4 validator suites pass; no suppression"
  - "FR-011: Check 26 NEVER/MUST hygiene satisfied in guide+ADR"
  - "FR-012: PR description quotes sunset checkpoint and reversal criteria"
scope_in: "guides/skill-authoring.md (300-500 lines) + CONTRIBUTING.md template diff (## Objective section) + docs/adr/ADR-020-skill-authoring-guide.md (≤50 lines) + SKILL-EFFECTIVENESS.md tally update + version bump (4 files) + CHANGELOG.md + docs/wiki/Changelog.md"
scope_out: "no new user-invocable skill; no validator extension; no claude-governance hook; no N2/N4b ship (T2 deferred); no retroactive sweep of 23 existing skills; no Ben AI framework verbatim port"
primary_user: "future contributors authoring new 8-habit-ai-dev skills + future Claude sessions reading the guide before drafting SKILL.md"
risks:
  - "R1: guide could pollute itself (>800 lines) — mitigate by aiming 300-500 lines"
  - "R2: CONTRIBUTING.md template line-drift could break tooling — mitigate by spot-check (no tooling indexes by line)"
  - "R3: ADR-020 could be perceived as ADR-creep — mitigate ≤50 lines + thin traceability framing"
  - "R4: 2026-11-24 sunset piles on review queue — mitigate by noting ADR-017 mechanism (not ADR-016)"
success_criteria_count: 6
END_SKILL_OUTPUT -->
