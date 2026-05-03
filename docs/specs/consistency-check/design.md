# Design: `/consistency-check` + Opt-In Spec Persistence

**Issue**: pitimon/8-habit-ai-dev#165
**Status**: Draft (Step 2: Design)
**PRD**: [./prd.md](./prd.md) (15 EARS criteria, 5 success criteria)
**Related ADR**: [ADR-013-spec-persistence-opt-in.md](../../adr/ADR-013-spec-persistence-opt-in.md)

---

## Architecture Overview

```
┌──────────────────────┐    ┌──────────────────────┐
│ /requirements        │    │                      │
│ /design              │───▶│ docs/specs/<slug>/   │
│ /breakdown           │    │   prd.md             │
│   (with --persist)   │    │   design.md          │
└──────────────────────┘    │   tasks.md           │
                            └──────────┬───────────┘
                                       │
                                       ▼
                            ┌──────────────────────┐
                            │ /consistency-check   │
                            │   <slug>             │
                            │                      │
                            │ 5 detection passes:  │
                            │  • Coverage          │
                            │  • Drift             │
                            │  • Ambiguity         │
                            │  • Underspec         │
                            │  • Inconsistency     │
                            └──────────┬───────────┘
                                       │
                                       ▼
                            severity-graded findings
                            CRITICAL/HIGH/MEDIUM/LOW
                            (max 30, file:line cited)
```

Read-only data flow. No mutation of source artifacts. Backwards compatible — without `--persist`, behavior is unchanged from v2.14.3.

---

## Sticky Decisions

> **STICKY** decisions are load-bearing. Changing them mid-implementation requires re-running `/design`, not patching mid-build. Decisions marked here cannot be reversed without ADR amendment.

### Decision 1: Persistence trigger mechanism — STICKY

| Option                                                                | Description                                                   | Pro                                             | Con                                                                        |
| --------------------------------------------------------------------- | ------------------------------------------------------------- | ----------------------------------------------- | -------------------------------------------------------------------------- |
| **A: Positional slug** (`/requirements <slug> [feature description]`) | First positional arg is the feature slug; description follows | Simple; no flag parsing; works in any UI        | Breaks backward compat (existing args become description by accident)      |
| **B: `--persist <slug>` flag**                                        | Explicit opt-in flag preserves existing positional args       | Backward compatible; explicit intent; greppable | Slightly more typing; flag-parsing in skill (skills are markdown, not CLI) |
| **C: Auto-detect from cwd**                                           | If invoked while cwd is `docs/specs/<slug>/`, persist there   | Zero-config; "magic" UX                         | Implicit; surprising; hard to debug; tied to shell state                   |
| **D: Frontmatter directive** in conversation                          | User writes `persist: <slug>` line; skill detects             | No arg parsing; conversational                  | Confusing for users; brittle parsing; not discoverable                     |

**Recommendation: B (`--persist <slug>` flag)** — preserves all 15 PRD EARS criteria including the back-compat invariant (PRD-EARS-2). Skills already document `argument-hint` patterns; flag fits naturally.

**Rework cost if changed**: ~70% — every skill modification, every doc reference, every test would change. Definite sticky.

### Decision 2: File naming convention — STICKY

| Option                                                                     | Description                                   | Pro                                                                   | Con                                                                                               |
| -------------------------------------------------------------------------- | --------------------------------------------- | --------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| **A: spec-kit aligned** (`prd.md`, `design.md`, `tasks.md`)                | Matches spec-kit's user-facing artifact names | Familiar to spec-kit users; concise; aligns with our PRD nomenclature | "tasks.md" is semantically narrower than `/breakdown` output (which includes orchestration class) |
| **B: Skill-name aligned** (`requirements.md`, `design.md`, `breakdown.md`) | Matches our skill names exactly               | 1:1 traceability skill→file                                           | "requirements.md" is more verbose than "prd.md"                                                   |
| **C: Numbered** (`01-prd.md`, `02-design.md`, `03-tasks.md`)               | Sort order = workflow order                   | Visual workflow ordering in directory listing                         | Coupling order to filename; renumbering pain if order changes                                     |
| **D: Single file** (`spec.md` with sections)                               | All artifacts in one file                     | One file to read                                                      | Conflicts on parallel writes; harder to diff per-step                                             |

**Recommendation: A (spec-kit aligned)** — `prd.md`, `design.md`, `tasks.md`. Familiar to spec-kit refugees, concise, and the PRD already uses "prd" naming in this repo (`docs/specs/consistency-check/prd.md`). The "tasks vs breakdown" semantic gap is a doc-level concern; both terms are used interchangeably in the README.

**Rework cost if changed**: ~50% — file references, validators, examples. Sticky.

### Decision 5: `/consistency-check` input format — STICKY

| Option                                              | Description                                                            | Pro                                    | Con                                     |
| --------------------------------------------------- | ---------------------------------------------------------------------- | -------------------------------------- | --------------------------------------- |
| **A: Slug only** (`/consistency-check <slug>`)      | Resolves to `docs/specs/<slug>/`                                       | Simple; matches persistence convention | Doesn't work for unconventional layouts |
| **B: Directory path** (`/consistency-check <path>`) | Accepts any dir; reads what's there                                    | Flexible                               | More typing; users may pass wrong dir   |
| **C: Both — slug OR path**                          | Auto-detect: if matches `docs/specs/<X>/`, treat as slug; else as path | Convenient                             | Ambiguity; surprising errors            |

**Recommendation: C (both)** — auto-detect behavior: if arg matches an existing entry under `docs/specs/`, treat as slug; otherwise treat as a directory path. Predictable: "if it looks like a slug AND that slug exists, use it; else literal path". Keeps simple case simple, allows escape hatch.

**Rework cost if changed**: ~30% — input parsing only. Borderline sticky → marked sticky for safety.

### Decision 6: Severity assignment per pass — STICKY

| Option                                                                                                     | Description                                 | Pro                                               | Con                                                                 |
| ---------------------------------------------------------------------------------------------------------- | ------------------------------------------- | ------------------------------------------------- | ------------------------------------------------------------------- |
| **A: Fixed per pass** (Coverage=HIGH, Drift=CRITICAL, Ambiguity=MEDIUM, Underspec=LOW, Inconsistency=HIGH) | Each pass has predetermined severity        | Predictable output; users learn pass→severity map | Not all findings within a pass are equally severe                   |
| **B: Per-finding** (analyzer assigns)                                                                      | Each finding gets severity based on context | Nuanced                                           | Requires LLM judgment per finding; not deterministic                |
| **C: User-configurable** (frontmatter)                                                                     | Severity table in skill frontmatter         | Customizable                                      | Configuration burden; encourages noise filtering rather than fixing |

**Recommendation: A (fixed per pass) with single-step override** — base severity per pass, but allow upgrade if finding is unambiguous (e.g., a literal `[NEEDS CLARIFICATION]` token in PRD body is ALWAYS HIGH/CRITICAL, not MEDIUM). Document the pass→severity table prominently in SKILL.md.

Mapping:

- Coverage gap (PRD requirement with no design coverage): **HIGH**
- Drift (design contradicts PRD scope): **CRITICAL**
- Ambiguity (PRD has unresolved tokens): **MEDIUM** (CRITICAL if `[NEEDS CLARIFICATION]` literal present)
- Underspec (design decision lacks rationale/alternatives): **LOW**
- Inconsistency (task references non-existent component): **HIGH**

**Rework cost if changed**: ~20% — severity table + tests. Sticky for predictability, not for technical reasons.

### Decision 7: Self-application as smoke test — STICKY

| Option                                            | Description                                                                                             | Pro                                | Con                                                                                   |
| ------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | ---------------------------------- | ------------------------------------------------------------------------------------- |
| **A: New `tests/test-consistency-check-self.sh`** | Standalone shell script that invokes the skill against `docs/specs/consistency-check/`                  | Isolated test; clear failure scope | Requires bash to invoke a skill (skills run in Claude); not directly executable in CI |
| **B: Validator check (`validate-content.sh`)**    | New check asserts `docs/specs/consistency-check/{prd,design,tasks}.md` all exist with valid frontmatter | Runs in CI; pure structural check  | Doesn't actually run the skill                                                        |
| **C: Both**                                       | Validator enforces presence; self-test script runnable manually                                         | Belt + suspenders                  | More files to maintain                                                                |

**Recommendation: B (validator only)** for v1 — skills cannot be invoked from bash, so a "real" smoke test isn't possible without a CI agent runner (out of scope per PRD). Structural check that the dogfood artifacts exist + parse cleanly is the realistic option. Manual smoke test documented in CONTRIBUTING.md as the second leg.

**Rework cost if changed**: ~15% — one validator function. Borderline sticky.

---

## Semi-Sticky Decisions (decided here, no user re-confirmation needed)

### Decision 3: SKILL_OUTPUT block placement when persisting

**Decision: Both file AND conversation** (Option B). Preserves `/cross-verify` auto-detect (which reads `SKILL_OUTPUT:requirements` from the PRD), and keeps the conversation-only path identical. Persisted file ends with the same block.

### Decision 4: Conflict policy when target file exists

**Decision: Prompt user via AskUserQuestion** (Option A). Three choices: overwrite, write to numbered variant (`prd.v2.md`), or abort. Matches PRD-EARS-3.

### Decision 8: Reference template format

**Decision: Inline in `skills/consistency-check/reference.md`** (Option A) — follows the v2.13+ skill split convention (ADR-009). SKILL.md has summary; reference.md has full output template + examples.

---

## Article 14 EU AI Act Checkpoint

**Applicable**: NO. This is a developer-facing workflow tool, not an AI system targeting EU consumers in a high-risk Annex III category. Skip the 5-capability table per the skill's own scope guidance.

---

## Constraints (from PRD-derived)

- **Backward compatibility invariant** (PRD-EARS-2): All existing skills must behave identically to v2.14.3 when `--persist` is not used. Tests for current behavior must pass unchanged.
- **Read-only analyzer invariant** (PRD-EARS-9): `/consistency-check` `allowed-tools` is `Read, Glob, Grep` only. No Write, no Bash, no Edit. Validator-enforced.
- **Skill ≤800 lines** (existing fitness function): SKILL.md and reference.md each must stay under 800 lines.
- **Hybrid pass evaluation** (Decision 9 — see below): Each pass uses deterministic structural matching when artifacts contain explicit cross-reference IDs (`FR-NNN`, `Decision-N`, `Task #N`). When IDs are absent, passes that require cross-artifact matching (Coverage, Inconsistency) fall back to LLM semantic comparison and emit an explicit "ID linkage absent — using fuzzy match, results approximate" warning at the top of the report. Drift is always semantic. Ambiguity and Underspec are always deterministic.
- **Plugin boundary** (per CLAUDE.md): no enforcement, no gating. Findings are advisory only.

---

## Decision 9 (added post-advisor review): Pass evaluation strategy — STICKY

Resolved an internal contradiction caught by advisor — the original "deterministic only except Drift" claim was inconsistent with how Coverage and Inconsistency actually work without explicit IDs in artifacts.

| Option                 | Approach                                                                                                                        | Pro                                                                                                       | Con                                                                   |
| ---------------------- | ------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| A: **Hybrid (CHOSEN)** | IDs recommended in templates. If present → deterministic Coverage+Inconsistency. If absent → LLM semantic with explicit warning | Best of both; preserves PRD-EARS-2 back-compat for existing PRDs without IDs; gives users an upgrade path | More complex skill; two code paths per pass                           |
| B: ID required         | Bake `FR-NNN` / `Decision-N` / `Task #N` into PRD/design/tasks templates as mandatory                                           | Fully deterministic all 5 passes                                                                          | Workflow change to upstream skills; rejects existing PRDs without IDs |
| C: LLM semantic only   | Relax "deterministic only" claim; accept that 3 of 5 passes are fuzzy                                                           | No template change; ships fastest                                                                         | Non-deterministic; harder to test recall; fuzzy by design             |

**Decision: A (Hybrid)** — confirmed by user 2026-05-03 after advisor surfaced the contradiction. Rationale: preserves PRD-EARS-2 back-compat invariant, doesn't force template rigidity, and gives users an upgrade path. Templates ship with optional ID guidance; users who add IDs get rigor; users who don't get approximate findings with explicit warning.

**Rework cost if changed**: ~40% — pass implementations + template guidance + tests. Sticky.

**Implementation contract**:

- PRD template gains optional `FR-NNN: <text>` markers (recommended, not required)
- design.md template gains optional `Decision-N covers: FR-001, FR-003` cross-refs
- tasks.md template gains optional `Task #N implements: Decision-4 (FR-001)` cross-refs
- `/consistency-check` detects presence/absence of these markers per file and chooses pass strategy accordingly
- Warning emitted ONCE at top of report when ANY artifact lacks ID markers

---

## Verified facts (post-advisor evidence-gathering)

| Claim                                                                                | Verified by | Source                                                                                                                                      |
| ------------------------------------------------------------------------------------ | ----------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| `--persist` flag style is consistent with existing skill convention                  | grep        | `/ai-dev-log` uses `--since/--repo/--out`; `/calibrate` uses `--force`                                                                      |
| Adding `Write` to `/requirements`/`/design`/`/breakdown` is moderate not novel       | grep        | `/calibrate` and `/reflect` SKILL.md already have `"Write"` in `allowed-tools`                                                              |
| Current `argument-hint` for the 3 affected skills is positional (no flag yet)        | grep        | `/requirements`: `"[feature description]"`; `/design`: `"[component or system to design]"`; `/breakdown`: `"[feature or PRD to decompose]"` |
| Current `allowed-tools` for the 3 affected skills is `["Read", "Glob", "Grep"]` only | grep        | All 3 SKILL.md frontmatter                                                                                                                  |

---

## H8 Checkpoint — 4 Dimensions

- **Body (Discipline)**: Validators added; CI-enforceable. ✓
- **Mind (Vision)**: Closes a real failure mode (cross-artifact drift) cited in research brief. Composes cleanly with `/cross-verify` (single-artifact) and future `/constitution` (Option 2 of brief). ✓
- **Heart (Passion)**: Output template designed for human readability; severity bands match `/cross-verify` and `/code-review` for muscle memory. ✓
- **Spirit (Conscience)**: Read-only analyzer, opt-in persistence, no enforcement creep. Boundary-respecting. ✓

[/design] COMPLETE SKILL_OUTPUT:design

<!-- SKILL_OUTPUT:design
decision_count: 9
decisions:
  - "D1: Persistence trigger = --persist <slug> flag (Option B) — flag precedent verified in /ai-dev-log + /calibrate"
  - "D2: File naming = prd.md / design.md / tasks.md (spec-kit aligned, Option A)"
  - "D3: SKILL_OUTPUT placement = both file AND conversation (Option B)"
  - "D4: Conflict policy = AskUserQuestion prompt (Option A); v1 limitation: requires interactive context, falls back to numbered variant otherwise (PRD-EARS-20)"
  - "D5: /consistency-check input = slug OR path auto-detect (Option C)"
  - "D6: Severity = fixed per pass with single-step upgrade (Option A+)"
  - "D7: Self-application = validator only in v1 (Option B); manual smoke documented in CONTRIBUTING.md"
  - "D8: Reference template = reference.md per skill split (Option A, ADR-009)"
  - "D9: Pass evaluation = HYBRID (Option A) — deterministic when ID markers present, LLM semantic + warning when absent"
sticky_decisions:
  - "D1 (trigger mechanism) — ~70% rework cost"
  - "D2 (file naming) — ~50% rework cost"
  - "D5 (input format) — ~30% rework cost"
  - "D6 (severity per pass) — predictability sticky"
  - "D7 (self-application test strategy) — borderline sticky"
  - "D9 (pass evaluation hybrid) — ~40% rework cost"
constraints:
  - "Back-compat invariant (PRD-EARS-2): unchanged behavior without --persist"
  - "Read-only analyzer (PRD-EARS-9): allowed-tools = Read, Glob, Grep only"
  - "Skill ≤800 lines (existing fitness function)"
  - "Hybrid pass evaluation (D9): deterministic when ID markers present, LLM semantic + explicit warning when absent"
  - "Plugin boundary: advisory only, no gating"
  - "v1 limitations documented: dogfood eval is manual not CI; conflict prompt requires interactive context"
adr_references:
  - "ADR-013-spec-persistence-opt-in: persistence opt-in design with 5 alternatives + flag precedent attestation + hybrid pass evaluation"
article_14_applicable: false
article_14_pass: n/a
END_SKILL_OUTPUT -->
