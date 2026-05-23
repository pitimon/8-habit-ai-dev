---
slug: diagnose-skill-v2-18-0
version: 1
created: 2026-05-23
predecessor: ~/.claude/plans/deep-mattpocock-skills-second-pass-2026-05-23.md
successor: design.md (next: /design)
authors: Pitimon (human) + Claude Opus 4.7 (1M context)
related-adr: ADR-014 (external prior-art doctrine), ADR-015 (this work, planned)
external-source: mattpocock/skills SHA b8be62ffacb0118fa3eaa29a0923c87c8c11985c
---

# PRD: `/diagnose` skill for 8-habit-ai-dev v2.18.0

## Feature: `/diagnose`

**What**: New plugin skill providing a 6-phase methodology for active bug investigation (feedback-loop → reproduce → hypothesise → instrument → fix-with-regression-test → cleanup). Read-only guidance per ADR-009; chains to `/post-mortem` for the engineering record.

**Why**: Documented gap between `/research` (too broad — investigates problem space) and `/post-mortem` (too late — assumes fix has landed). Friction evidence: `~/.claude/lessons/2026-04-12-compression-worker-420-investigation.md` explicitly states _"Most useful: n/a (no 8-habit skills invoked during the fix session)"_ and _"Could have been found in 5 minutes by comparing the two SQL queries side-by-side instead of 30 minutes of log analysis"_ — exactly the Phase 1 (feedback-loop-first) discipline this skill enforces.

**Who**:

- **Primary**: Plugin users debugging hard bugs / performance regressions in their own projects
- **Secondary**: Plugin maintainers debugging issues within `8-habit-ai-dev` itself
- **Not for**: Single-line bug fixes with obvious root cause (use the existing skip rule)

**In scope**:

- New `skills/diagnose/SKILL.md` (≤2000 words per F3 fitness)
- 6-phase methodology ported from mattpocock/skills (SHA `b8be62ff`)
- Habit map: H1 (Be Proactive — trace-all-callers) + H5 (Understand First — reproduce before fix)
- Chain frontmatter: `prev-skill: any`, `next-skill: post-mortem`
- ADR-015 documenting n=1 friction-driven adoption + honest forward-guardrail framing
- Version sync across 4 files (`plugin.json`, `marketplace.json`, `README.md`, `SELF-CHECK.md`)
- Validator coverage: all 4 test suites must pass
- CHANGELOG.md + docs/wiki/Changelog.md entries
- Description field validation: ≤1024 chars + valid trigger phrase (Check 25, v2.17.0)

**Out of scope**:

- NOT a replacement for `/research` (different intent — `/research` = investigate solution space; `/diagnose` = investigate bug behavior)
- NOT a replacement for `/post-mortem` (different timing — `/diagnose` = during debug; `/post-mortem` = after fix)
- NOT a code-modifying skill (read-only per ADR-009 — skill provides guidance, doesn't write code)
- NOT a hook/PreToolUse enforcement (that domain belongs to `claude-governance`)
- NOT a port of the FULL mattpocock skill body verbatim — we adapt to 8-habit voice + add habit-map sections + remove CONTEXT.md/LANGUAGE.md dependencies (rejected in ADR-014 as P7)
- NOT a debugger / IDE integration (skill is markdown guidance only)
- Tests automation, CI scaffolding, telemetry — out of scope for v2.18.0

**Success criteria** (verifiable):

1. `/diagnose` invocable from any session — appears in skill list, loads on demand
2. All 4 validator suites green: `validate-structure.sh`, `validate-content.sh`, `test-skill-graph.sh`, `test-verbosity-hook.sh`
3. SKILL.md ≤2000 words (F3 enforcement)
4. Description field ≤1024 chars + contains at least one trigger phrase from Check 25's set
5. Chain end-to-end demonstrable: invoking `/diagnose` → Phase 6 cleanup → handoff to `/post-mortem` works without prompt-leakage
6. ADR-015 published documenting n=1 friction + forward-guardrail intent (per ADR-014 doctrine)

**Definition of Done**:

- [ ] `skills/diagnose/SKILL.md` written, ≤2000 words, frontmatter complete
- [ ] All 4 validator suites pass on local + CI
- [ ] ADR-015 published in `docs/adr/`
- [ ] Version bumped in 4 sync files to `2.18.0` (atomic commit; Check 4 enforces)
- [ ] CHANGELOG.md + `docs/wiki/Changelog.md` updated
- [ ] PR opened with test plan checklist
- [ ] No `git add -A` — files staged explicitly
- [ ] `/cross-verify` run on the change, score ≥12/17 (Mostly ready band) before PR
- [ ] Honest framing: PR body states "forward guardrail with n=1 friction citation" explicitly

## Acceptance criteria (EARS)

1. [Ubiquitous] FR-001: The `/diagnose` skill shall provide a 6-phase methodology covering Phase 1 (feedback-loop) → Phase 2 (reproduce) → Phase 3 (hypothesise) → Phase 4 (instrument) → Phase 5 (fix-with-regression-test) → Phase 6 (cleanup-with-post-mortem).
2. [Event-driven] FR-002: When the user invokes `/diagnose [bug-description]`, the skill shall guide through Phase 1 first — establishing a fast, deterministic pass/fail signal — before any hypothesis generation.
3. [Event-driven] FR-003: When Phase 1 produces a working feedback loop, the skill shall proceed to Phase 2 (reproduce), confirming the failure matches the user's description and exhibits acceptable reproducibility.
4. [Ubiquitous] FR-004: The skill shall require 3–5 ranked, falsifiable hypotheses in Phase 3, each with an explicit prediction of form _"If X causes it, then changing Y will make the bug disappear."_
5. [Ubiquitous] FR-005: The skill shall recommend debugger-based instrumentation over log-based in Phase 4, with one variable tested per probe and uniquely-tagged debug output for cleanup.
6. [Ubiquitous] FR-006: The skill shall require a regression test written BEFORE applying the fix in Phase 5, located at the correct architectural seam (not just the reported symptom site).
7. [Event-driven] FR-007: When the fix lands and the original feedback loop passes, the skill shall hand off to `/post-mortem` for the engineering record, declared via `next-skill: post-mortem` in frontmatter.
8. [Unwanted] FR-008: If the feedback loop cannot be made fast and deterministic in Phase 1, then the skill shall surface this as a blocker and propose alternative approaches (bisect, ablation, telemetry inspection) before proceeding to Phase 3.
9. [Ubiquitous] FR-009: The skill SKILL.md frontmatter shall declare `prev-skill: any`, `next-skill: post-mortem`, `user-invocable: true`, and `allowed-tools: ["Read", "Glob", "Grep", "Bash"]` (Bash needed for feedback loops).
10. [Ubiquitous] FR-010: The skill body shall declare habit map **H1 + H5** with explicit checkpoint language at the end of the skill body ("H1 + H5 Checkpoint: 'Did I build the feedback loop before guessing?'").
11. [Unwanted] FR-011: If a single-line bug with obvious root cause is reported, then the skill shall surface the "When to Skip" rule (rename refactors, formatting, dep bumps, obvious one-liners don't warrant the 6-phase methodology).
12. [Ubiquitous] FR-012: The SKILL.md shall be ≤2000 words (F3 fitness function enforced by `tests/validate-content.sh`).
13. [Ubiquitous] FR-013: The skill description field shall be ≤1024 characters AND contain at least one trigger phrase from Check 25's empirically-grounded set (e.g., "debug", "diagnose", "investigate", "reproduce").
14. [Optional] FR-014: Where the user has invoked `/diagnose` after a related `/research` brief exists in `~/.claude/plans/` or `docs/specs/`, the skill shall reference that brief in Phase 1 setup rather than starting blind.

## Risks

| ID  | Risk                                                                  | Likelihood           | Impact              | Mitigation                                                                                                                                                 |
| --- | --------------------------------------------------------------------- | -------------------- | ------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| R1  | Overlap with `/post-mortem` causes user confusion ("which do I use?") | Medium               | Medium              | Explicit "When to Use vs When to Skip" boundary in skill body; `next-skill: post-mortem` chain clarifies sequencing                                        |
| R2  | Overlap with `/research` (both investigate something)                 | Low                  | Medium              | Boundary doc: `/research` = solution space; `/diagnose` = bug behavior. Different verbs in trigger phrases                                                 |
| R3  | n=1 friction signal weaker than ADR-014's stated bar                  | High (by definition) | Low                 | ADR-015 honest forward-guardrail framing; lesson's explicit "no skills invoked" quote is unusually strong n=1                                              |
| R4  | 6-phase methodology too prescriptive for simple bugs                  | Medium               | Low                 | FR-011 (skip rule for obvious bugs); Phase 1 itself acts as filter — if a 30-second feedback loop trivially proves the fix, the user has self-selected out |
| R5  | Skill body exceeds 2000-word F3 limit when adapted to 8-habit voice   | Low                  | High (blocks merge) | Reference loading pattern — push detail into `skills/diagnose/reference.md`, keep SKILL.md ≤2000 words                                                     |

## Constraints honored

- **C1 (ADR-009 read-only)**: `/diagnose` provides guidance only; doesn't write code or run mutations
- **C2 (Plugin boundary)**: workflow discipline → 8-habit-ai-dev (not `claude-governance` which owns enforcement hooks)
- **C3 (Zero-dep invariant)**: no new external deps; pure markdown skill
- **C4 (F3 fitness)**: ≤2000 words enforced by validator
- **C5 (Version sync atomicity)**: v2.18.0 bump touches 4 sync files in one commit (Check 4)
- **C6 (No skill-graph DAG break)**: new skill adds `prev-skill: any, next-skill: post-mortem` edges — additive, no existing edges modified
- **C7 (Honest framing per ADR-014)**: ADR-015 records n=1 friction citation explicitly; doctrine consistent

## Honest framing (ADR-014 inheritance)

Per ADR-014's doctrine — _"future contributors evaluating 'should we add X' should require explicit friction citation, not just pattern attractiveness"_ — this PRD's friction citation is **n=1**:

- `~/.claude/lessons/2026-04-12-compression-worker-420-investigation.md` documents an ad-hoc bug investigation where the lesson author's own retrospective explicitly says _"Most useful: n/a (no 8-habit skills invoked during the fix session)"_ and _"Could have been found in 5 minutes [vs 30] by comparing the two SQL queries side-by-side"_ (Phase 1 discipline).
- This is **stronger n=1 than ADR-014's 4 patterns** (which had n=0 friction) because the lesson is a first-person admission of an absent-skill gap, not just an attractive external pattern.

Even so, n=1 is below the n≥2 threshold ADR-014's Option-3 path would have set. Maintainer's decision (this PRD) is to proceed because:

1. n=1 is real friction, not pattern attractiveness
2. Skill is additive (no breaking change, no removal of existing capability)
3. ADR-015 will record the framing transparently

## H2 Checkpoint

"Can I describe what success looks like before writing code?"

✓ Yes — 6 verifiable success criteria, 14 EARS-shaped acceptance criteria, 7 named constraints, 5 enumerated risks with mitigations. Definition of Done is a 9-item checklist with validator gates.

## Handoff

- **Expects from predecessor** (`/research`): Research brief at `~/.claude/plans/deep-mattpocock-skills-second-pass-2026-05-23.md` (delivered ✓); Option 1 scope confirmed
- **Produces for successor** (`/design`): Architecture decisions — skill body structure (single-file vs split), Bash tool justification, reference.md split criterion if approaching 2000-word limit, FR-014 implementation pattern for `/research` brief detection, ADR-015 outline

[/requirements] COMPLETE SKILL_OUTPUT:requirements

<!-- SKILL_OUTPUT:requirements
ears_count: 14
ears_criteria:
  - "FR-001: The /diagnose skill shall provide a 6-phase methodology covering Phase 1 (feedback-loop) -> Phase 2 (reproduce) -> Phase 3 (hypothesise) -> Phase 4 (instrument) -> Phase 5 (fix-with-regression-test) -> Phase 6 (cleanup-with-post-mortem)"
  - "FR-002: When user invokes /diagnose [bug-description], skill shall guide through Phase 1 first"
  - "FR-003: When Phase 1 produces a working feedback loop, skill shall proceed to Phase 2"
  - "FR-004: Skill shall require 3-5 ranked falsifiable hypotheses in Phase 3"
  - "FR-005: Skill shall recommend debugger-based instrumentation over log-based in Phase 4"
  - "FR-006: Skill shall require regression test BEFORE fix in Phase 5"
  - "FR-007: When fix lands and feedback loop passes, skill shall hand off to /post-mortem"
  - "FR-008: If feedback loop cannot be deterministic in Phase 1, skill shall surface as blocker"
  - "FR-009: SKILL.md frontmatter shall declare prev-skill: any, next-skill: post-mortem, user-invocable: true, allowed-tools includes Bash"
  - "FR-010: Skill body shall declare habit map H1 + H5 with explicit checkpoint language"
  - "FR-011: If single-line bug with obvious root cause, skill shall surface When-to-Skip rule"
  - "FR-012: SKILL.md shall be <=2000 words (F3 fitness)"
  - "FR-013: Description field <=1024 chars + valid Check 25 trigger phrase"
  - "FR-014: Where related /research brief exists, skill shall reference it in Phase 1"
scope_in: "new skills/diagnose/SKILL.md (<=2000 words), 6-phase methodology, H1+H5 habit map, ADR-015 honest framing, version sync to v2.18.0 across 4 files, CHANGELOG updates, validator coverage"
scope_out: "NOT replacement for /research or /post-mortem, NOT code-modifying, NOT a hook/PreToolUse (claude-governance domain), NOT verbatim port of mattpocock body, NOT debugger/IDE integration, NOT CI scaffolding or telemetry"
primary_user: "plugin users debugging hard bugs in their projects; plugin maintainers debugging 8-habit-ai-dev itself"
risks:
  - "R1 Overlap with /post-mortem (Medium/Medium) - mitigate via boundary doc + chain"
  - "R2 Overlap with /research (Low/Medium) - mitigate via verb-different trigger phrases"
  - "R3 n=1 friction below ADR-014 n>=2 bar (High/Low) - mitigate via ADR-015 honest framing"
  - "R4 6-phase too prescriptive for simple bugs (Medium/Low) - mitigate via FR-011 skip rule"
  - "R5 SKILL.md exceeds 2000-word F3 limit (Low/High) - mitigate via reference.md split"
success_criteria_count: 6
END_SKILL_OUTPUT -->
