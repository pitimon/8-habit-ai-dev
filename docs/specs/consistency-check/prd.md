# PRD: `/consistency-check` + Opt-In Spec Persistence

**Issue**: pitimon/8-habit-ai-dev#165
**Status**: Draft (Step 1: Requirements)
**Inspired by**: github/spec-kit `/analyze` (https://github.com/github/spec-kit)
**Research brief**: `/Users/itarun/.claude/plans/https-github-com-github-spec-kit-idea-in-robust-walrus.md`

---

## Feature: Cross-Artifact Consistency Analyzer + Opt-In Spec Persistence

**What**: (1) Add an opt-in convention for `/requirements`, `/design`, `/breakdown` to persist their `SKILL_OUTPUT` blocks (and human-readable PRD/design/tasks content) as files under `docs/specs/<feature>/`. (2) Add a new skill `/consistency-check` that reads those files and runs 5 cross-artifact detection passes, emitting severity-graded findings.

**Why**: `/cross-verify` runs the 17-question 8-habit checklist against a single artifact; it does not detect drift, coverage gaps, or contradictions **between** PRD ↔ design ↔ tasks. spec-kit's `/analyze` demonstrates the value of cross-artifact analysis as a first-class failure-mode check. Verified gap: `claude-governance/spec-driven-dev` produces a single spec.md and does not perform cross-artifact analysis. Neither plugin covers this today. Persistence is a structural prerequisite — without files on disk, the analyzer has nothing to read.

**Who**: Developers using the 7-step workflow (`/research → /requirements → /design → /breakdown → /build-brief → ...`) on multi-artifact features. Particularly valuable when:

- Working across multiple sessions (artifacts in conversation are lost between sessions)
- Reviewing AI-generated specs for drift before implementation
- Auditing whether a design actually covers all stated requirements
- Onboarding a new team member to an in-flight spec

**In scope**:

- Opt-in persistence flag/convention for `/requirements`, `/design`, `/breakdown` to write to `docs/specs/<feature>/{prd,design,tasks}.md`
- New skill `skills/consistency-check/SKILL.md` with 5 detection passes
- ADR-013 documenting persistence-as-opt-in decision
- Reference template for the analyzer output
- Validator additions enforcing the new skill structure
- CLAUDE.md skills→habits table update (1 new row)
- README + CHANGELOG entry; version bump across 4 files

**Out of scope**:

- Hard gating / blocking actions based on findings (boundary → `claude-governance` if ever needed)
- Auto-fix or remediation of findings (read-only analyzer)
- Multi-feature comparison (one feature at a time)
- CI integration (would belong in `claude-governance` enforcement)
- Renaming or migrating existing in-conversation `SKILL_OUTPUT` workflows (back-compat preserved)
- Story-tier P1/P2/P3 classification in `/breakdown` (separate Option 3 from research brief, deferred)
- Project-level `/constitution` skill (separate Option 2 from research brief, deferred)

**Success criteria** (verifiable):

1. On a synthetic feature spec containing 3 known coverage gaps + 2 known contradictions + 1 known ambiguity (`[NEEDS CLARIFICATION]` token), `/consistency-check` flags ≥5 of 6 within 60 seconds (≥83% recall on synthetic ground truth)
2. Existing workflows that do NOT opt into persistence continue to work unchanged — `tests/validate-structure.sh` and `tests/validate-content.sh` pass on all skills before AND after the change
3. Total LOC added across all SKILL.md changes ≤ 600 lines; no SKILL.md exceeds 800 lines (validator-enforced)
4. Issue #165 closes with PR linked, ADR-013 published, version bumped (next minor or patch per CHANGELOG convention), and `/consistency-check` self-applied to its own PRD/design/tasks artifacts (dogfood eval ≥80% pass band)
5. Validator additions enforce: `/consistency-check` SKILL.md has prev-skill/next-skill frontmatter, has reference to 5 detection passes, has output template, and persistence convention is documented in CLAUDE.md and CONTRIBUTING.md

**Definition of Done**:

- All success criteria met
- `/code-review` passes with no CRITICAL/HIGH unresolved
- `/cross-verify` on the implementation plan ≥ 12/17 (Mostly ready or better)
- `advisor()` consulted on the design (ADR) before implementation begins
- PR opened with Summary + Test plan + Refs #165
- This PRD's own `docs/specs/consistency-check/` directory exists and `/consistency-check` runs cleanly against it

---

## Acceptance Criteria (EARS)

### Persistence half

1. **[Optional]** FR-001: Where the user passes a persistence argument or flag (e.g., `--persist <feature-slug>`) to `/8-habit-ai-dev:requirements`, `/8-habit-ai-dev:design`, or `/8-habit-ai-dev:breakdown`, the skill SHALL write its full PRD/design/tasks output to `docs/specs/<feature-slug>/{prd,design,tasks}.md` AND emit the `SKILL_OUTPUT` block as before.

2. **[Ubiquitous]** FR-002: When persistence is NOT requested, the affected skills SHALL behave exactly as in v2.14.3 — emit `SKILL_OUTPUT` block in conversation only, no file writes.

3. **[Event-driven]** FR-003: When a persisted file already exists at the target path, the skill SHALL prompt the user (via AskUserQuestion or equivalent) to choose: overwrite, append revision history, or write to a numbered variant (`prd.v2.md`).

4. **[Unwanted]** FR-004: If the target `docs/specs/<feature-slug>/` directory cannot be created (permission denied, read-only filesystem), then the skill SHALL surface the error, fall back to conversation-only output, and continue without aborting.

5. **[Ubiquitous]** FR-005: All persisted artifact files SHALL include a YAML frontmatter block with: `feature`, `step` (requirements|design|breakdown), `created`, `updated`, `source-issue` (optional), `source-skill-version`.

### Analyzer half

6. **[Event-driven]** FR-006: When invoked as `/8-habit-ai-dev:consistency-check <feature-slug>` (or with a directory path), the skill SHALL read all artifact files present in `docs/specs/<feature-slug>/` and run 5 detection passes: Coverage, Drift, Ambiguity, Underspec, Inconsistency.

7. **[Ubiquitous]** FR-007: The skill SHALL emit findings as a severity-graded table with columns `severity | pass | location | finding | suggested action`. Severities: CRITICAL, HIGH, MEDIUM, LOW. Maximum 30 findings per run (truncate excess with a "+N more, narrow scope" footer).

8. **[Unwanted]** FR-008: If `docs/specs/<feature-slug>/` does not exist OR contains zero artifact files, then the skill SHALL emit a single CRITICAL finding "No persisted artifacts found — was `--persist <feature-slug>` used during /requirements/design/breakdown?" and exit cleanly.

9. **[State-driven]** FR-009: While running, the skill SHALL NOT write, edit, or delete any file (read-only by design). The skill's `allowed-tools` SHALL be `Read, Glob, Grep` only.

10. **[Optional]** FR-010: Where the user has opted in via maturity profile (`~/.claude/habit-profile.md` Significance tier), the skill SHALL emit the dimension summary and band table inline; otherwise it MAY defer to the standard scoring footer.

11. **[Ubiquitous]** FR-011: Each finding SHALL cite a `file:line` reference in the `location` column when applicable (file-level findings are acceptable when no specific line applies).

12. **[Unwanted]** FR-012: If a detection pass finds zero issues in its category, then the skill SHALL emit a "✓ Pass: 0 findings" row for that pass (NOT silence) so absence of evidence is distinguishable from non-execution.

### Cross-cutting

13. **[Ubiquitous]** FR-013: Both halves SHALL preserve backward compatibility: every existing test in `tests/validate-structure.sh` and `tests/validate-content.sh` SHALL continue to pass on the modified plugin without modification (new tests may be added; existing tests SHALL NOT be relaxed).

14. **[Event-driven]** FR-014: When the bundled feature ships, ADR-013 SHALL document the persistence-opt-in design decision with at least 3 alternatives considered and rationale for the chosen approach.

15. **[Ubiquitous]** FR-015: This feature SHALL self-apply: the `docs/specs/consistency-check/` directory containing this PRD SHALL also contain the design.md and tasks.md artifacts produced by the next workflow steps. `/consistency-check` SHALL be runnable manually against itself, with the manual procedure documented in `CONTRIBUTING.md`. (CI invocation deferred — skills cannot be invoked from bash; structural validator confirms artifact presence + frontmatter only.)

### Added post-advisor review

16. **[Unwanted]** FR-016: If the user passes a slug that does not match `^[a-z0-9][a-z0-9-]{1,63}$`, then the skill SHALL abort with an error message naming the required pattern and providing an example of a valid slug. (Prevents path traversal, hidden files, shell special chars, excessive length.)

17. **[Optional]** FR-017: Where artifacts in `docs/specs/<slug>/` contain explicit cross-reference ID markers (`FR-NNN`, `Decision-N`, `Task #N`), the Coverage and Inconsistency passes SHALL use deterministic structural matching. Otherwise they SHALL use LLM semantic comparison.

18. **[Event-driven]** FR-018: When ANY artifact in `docs/specs/<slug>/` lacks ID markers, the report SHALL emit a single warning at the top: `"ID linkage absent — using fuzzy match for Coverage and Inconsistency; results approximate. See ADR-013 for ID guidance."`

19. **[Ubiquitous]** FR-019: All error messages emitted by the persistence half (directory create failure, slug validation failure, file conflict with no interactive context) SHALL: (a) state what the skill attempted, (b) state what failed and why, (c) state what the user can do next. Generic "error" or "failed" messages are NOT acceptable.

20. **[Optional]** FR-020: Where the AskUserQuestion tool is unavailable (non-interactive context, batch invocation), the conflict policy (FR-003) SHALL default to writing to a numbered variant (`prd.v2.md`, `prd.v3.md`, ...) rather than prompting, and SHALL emit a warning naming the variant chosen.

---

## Risks

- **Maturity-tier feature creep**: Significance-tier users may want minimal output; Dependence-tier users may want more guidance. Mitigation: defer verbosity adaptation to the existing session-start hook directive; do NOT branch `/consistency-check` output by tier in v1.
- **Synthetic-eval gaming**: Success criterion 1 uses a synthetic input. Real-world consistency drift can be subtler. Mitigation: include 1 real-world input drawn from this very PR's artifacts (criterion 4 dogfood) as a second eval point.
- **Persistence path collisions**: Two features sharing a slug (e.g. `auth` and `auth-v2`) could overwrite. Mitigation: criterion 3 prompts on existing files.
- **Boundary creep risk**: Adding more file outputs to a "discipline" plugin moves it slightly toward enforcement territory. Mitigation: keep persistence opt-in (criterion 2 invariant), document boundary stance in ADR-013.

---

## Decision Loop Classification

**On-the-Loop** (per Three Loops Decision Model). AI proposes the implementation; human approves the design at ADR-013 stage and reviews PR. The new skill itself is read-only and out-of-loop after ship.

[/requirements] COMPLETE SKILL_OUTPUT:requirements

<!-- SKILL_OUTPUT:requirements
ears_count: 20
ears_criteria:
  - "[Optional] Where --persist <slug> is passed, write to docs/specs/<slug>/{prd,design,tasks}.md AND emit SKILL_OUTPUT"
  - "[Ubiquitous] Without --persist, skills behave exactly as v2.14.3 (back-compat invariant)"
  - "[Event-driven] On existing target file, prompt user: overwrite, append, or numbered variant"
  - "[Unwanted] On directory-create failure, surface error and fall back to conversation-only"
  - "[Ubiquitous] Persisted files include YAML frontmatter (feature, step, created, updated, source-issue, source-skill-version)"
  - "[Event-driven] /consistency-check <slug> reads docs/specs/<slug>/ and runs 5 passes (Coverage, Drift, Ambiguity, Underspec, Inconsistency)"
  - "[Ubiquitous] Output is severity-graded table (CRITICAL/HIGH/MEDIUM/LOW), max 30 findings"
  - "[Unwanted] On missing/empty docs/specs/<slug>/, emit single CRITICAL and exit cleanly"
  - "[State-driven] Read-only — allowed-tools: Read, Glob, Grep only"
  - "[Optional] Tier-aware verbosity inline if Significance profile detected"
  - "[Ubiquitous] Each finding cites file:line in location column where applicable"
  - "[Unwanted] Zero-finding passes emit ✓ Pass row (NOT silence)"
  - "[Ubiquitous] Existing validate-structure.sh + validate-content.sh continue to pass"
  - "[Event-driven] ADR-013 documents persistence-opt-in with ≥3 alternatives"
  - "[Ubiquitous] Self-apply: docs/specs/consistency-check/ contains this PRD + design + tasks; manual smoke procedure in CONTRIBUTING.md (CI invocation deferred — skills not bash-invokable)"
  - "[Unwanted] Slug must match ^[a-z0-9][a-z0-9-]{1,63}$ — abort with named pattern + example on violation"
  - "[Optional] When ID markers (FR-NNN, Decision-N, Task #N) present in artifacts → deterministic Coverage+Inconsistency; else LLM semantic"
  - "[Event-driven] When any artifact lacks ID markers, emit warning at top of report: 'ID linkage absent — using fuzzy match...'"
  - "[Ubiquitous] Persistence-half error messages must state: (a) what was attempted, (b) what failed and why, (c) what user can do next"
  - "[Optional] Where AskUserQuestion unavailable (non-interactive), conflict policy defaults to numbered variant (prd.v2.md) with warning"
scope_in: "Opt-in persistence for /requirements,/design,/breakdown; new /consistency-check skill with 5 passes (hybrid eval); ADR-013; reference template; validator additions; CLAUDE.md+README+CHANGELOG+version bump; CONTRIBUTING.md manual smoke procedure"
scope_out: "Hard gating; auto-fix; multi-feature comparison; CI invocation of skills (skills not bash-invokable); workflow rename; story-tier P1/P2/P3 (deferred Option 3); /constitution skill (deferred Option 2); mandatory ID markers (kept optional)"
primary_user: "Developers using 7-step workflow on multi-artifact features, especially across sessions or for AI-spec-drift audits"
risks:
  - "Maturity-tier feature creep — mitigation: defer to session-start verbosity directive in v1"
  - "Synthetic-eval gaming — mitigation: dogfood real-world eval (criterion 4) as second point"
  - "Persistence path collisions — mitigation: prompt on existing files (EARS-3) + numbered fallback (EARS-20)"
  - "Boundary creep toward enforcement — mitigation: opt-in invariant + ADR-013 boundary stance"
  - "Hybrid pass eval drift — mitigation: warning emitted when fallback to LLM semantic; users can opt into rigor by adding IDs"
  - "Slug abuse / path traversal — mitigation: regex validation (EARS-16)"
success_criteria_count: 5
END_SKILL_OUTPUT -->
