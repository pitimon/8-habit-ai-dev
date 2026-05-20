---
feature: mattpocock-t1-v2-17-0
step: design
created: 2026-05-20T09:30:00+00:00
updated: 2026-05-20T09:30:00+00:00
source-skill-version: 2.16.5
prd-reference: ./prd.md
---

# Design — External Prior-Art Bundle v2.17.0

## Scope Alignment

Verified against `prd.md` `SKILL_OUTPUT:requirements.scope_in`:

- All 5 decisions below stay within: P1 AGENT-BRIEF template + P3 disable-model-invocation flag + P4-lite docs/out-of-scope/ catalog + P5 description rubric validator + ADR-014 + v2.17.0 version sync
- All 3 PRD risks (R1 harness compliance, R2 description-rubric false positives, R3 OOS vs ADR drift) addressed below

## Article 14 (EU AI Act) Checkpoint

**N/A**. The system being designed is a Claude Code plugin (workflow guidance tooling) — not an AI system covered by Annex III. The plugin itself is markdown + bash; it does not make autonomous decisions affecting persons. No Article 14 capabilities required.

## Decisions

### Decision-1: Description-rubric validator approach **[STICKY]**

**Covers**: FR-002, FR-003

**Choice**: **A — Pure-bash `grep -E` against frontmatter YAML**, integrated as a new check function in `tests/validate-structure.sh`.

**Why**:

- Preserves the zero-runtime-dependency invariant maintained since v1.0 (currently 2,093 lines bash, 0 npm/pip/yq deps)
- Matches existing validator authoring style (check functions called by main runner)
- Multi-line YAML description blocks (`description: >`) are handled by collapsing whitespace before the rubric pass; if any SKILL.md uses multi-line form, P5 manual sweep normalizes to single-line before FR-003 activates

**Rejected alternatives**:

- B (Python helper) — adds runtime dep; conflicts with no-build philosophy
- C (yq with grep fallback) — adds optional dep + dual codepath; not worth the YAML purity

**Implementation outline**:

1. New function `check_description_rubric()` in `tests/validate-structure.sh`
2. For each `skills/*/SKILL.md`: extract `description:` value (handle single-line and `>` block-scalar variants), check char count (≤1024) and trigger phrase presence (regex `(Use when|Use AFTER|Use BEFORE|Use to|Use for)`)
3. New function `check_allowed_frontmatter_fields()` — adds `disable-model-invocation` to the allowed-keys set
4. Both functions register as new checks (likely Check 24 and Check 25); existing check numbering stays stable

**STICKY**: Reversing this (e.g., switching to Python helper later) requires re-implementing both check functions. >50% rework cost.

**Risk R2 mitigation**: P5 manual sweep of all 19 SKILL.md `description` fields **MUST precede** the activation of `check_description_rubric()` in CI. Order in `/breakdown`: audit-first, validator-on second.

---

### Decision-2: `docs/out-of-scope/` entry format **[SEMI-STICKY]**

**Covers**: FR-004

**Choice**: **B — Lightweight YAML frontmatter + body**.

**Frontmatter schema**:

```yaml
---
date: <ISO 8601 date>
originating-decision: <ADR-NNN ref>
rejected-because: <one-line summary, ≤140 chars>
---
```

**Body structure** (≤200 words total):

```markdown
# <What we won't do> — <one-line subject>

**Why we won't do it**: <2-3 sentence rationale>

**What this prevents**: <re-litigation cost, scope creep, etc.>

**If reconsidering, read these conditions first:**

- <Condition 1 that would change our mind>
- <Condition 2>
- <Condition 3>
```

**Why**:

- Frontmatter enables `grep -l "originating-decision: ADR-006" docs/out-of-scope/` for traceability
- "If reconsidering" section is the durability anchor — future contributors don't re-litigate; they check whether conditions changed
- ≤200-word cap forces clarity over justification

**Rejected alternatives**:

- A (free-form markdown) — no machine-readable metadata; harder to audit
- C (truncated ADR) — risks conceptual blur (ADR = "we decided to do X"; OOS = "we deliberately won't do Y")

**3 seed entries** (per FR-004):
| File | originating-decision | rejected-because |
|---|---|---|
| `brainstorm-removed.md` | ADR-006 | Superpowers ships a stronger collaborative brainstorm — duplication hurts both plugins |
| `agentskills-no-go.md` | ADR-007 | Standard reach is measured by what tools parse, not logo lists — keeping full frontmatter control |
| `eu-ai-act-migrated.md` | ADR-012 | Compliance enforcement belongs in claude-governance; this plugin focuses on workflow discipline |

**Risk R3 mitigation**: CONTRIBUTING.md gets a paragraph explicitly contrasting ADR ("we DID decide") vs OOS ("we deliberately won't do"). Different verbs make the boundary obvious.

**Semi-sticky**: 3 seed entries follow this schema; changing it later means rewriting them. Acceptable scope for a single later migration if the schema proves wrong.

---

### Decision-3: AGENT-BRIEF template structure **[SEMI-STICKY]**

**Covers**: FR-005

**Choice**: **B — Habit-mapped variant**.

**Structure** (target ≤120 lines per FR-005):

```markdown
# AGENT-BRIEF: <issue title>

## What this issue is about (H2: Begin with End)

<2-3 sentence problem statement — behavioral, not procedural>

## Success criteria

- <Verifiable condition 1>
- <Verifiable condition 2>
- <Verifiable condition 3>

## In scope

- <Bounded list>

## Out of scope (deliberately)

- <Bounded list — important for backlog durability>

## Domain vocabulary

- **<term>**: <definition>
- **<term>**: <definition>

## Why this matters (H8: Find Your Voice)

<1-2 sentence "why we're building this" — survives weeks in backlog when the rationale fades>

## Hard rules — what NOT to write here

1. **No file paths**: `src/users/auth.ts:42` rots fast — codebase will move before pickup
2. **No line numbers**: Same rot reason
3. **No implementation details**: How belongs in the PR; what + why belongs here
4. **No commit hashes**: Use behavioral references ("the existing JWT issuance flow") not git refs
5. **No screenshots tied to current UI**: UI evolves; describe the behavior instead

## Pickup checklist (for the agent/dev who picks this up)

- [ ] Read CLAUDE.md / DOMAIN.md for current context
- [ ] Verify success criteria still apply (issue may be stale)
- [ ] If scope expanded since filing, re-run `/requirements` before building
```

**Why this differs from mattpocock's port**:

- Adds explicit H2 ("Success criteria") and H8 ("Why this matters") sections — fits our voice
- "Hard rules" section is direct paraphrase of mattpocock's behavioral-not-procedural principle
- Pickup checklist is new — operationalizes "is this issue still valid?" at agent dispatch time

**Rejected alternatives**:

- A (direct port) — doesn't carry Habits/Whole Person framing
- C (minimal scaffold) — loses the "hard rules" durability anchor that makes Matt's pattern work

**Semi-sticky**: Template content evolves with usage; structural sections (success criteria, hard rules, pickup checklist) should remain stable across minor versions.

**Citation in template**: Header comment block credits mattpocock/skills/triage/AGENT-BRIEF.md as the originating pattern.

---

### Decision-4: `/breakdown` AGENT-BRIEF reference — narrows FR-006 from event-driven to ubiquitous **[FLEXIBLE]**

**Covers**: FR-006 (narrowed)

**Choice**: **Always link** `guides/templates/agent-brief-template.md` in `/breakdown`'s Handoff section, regardless of backlog classification.

**Why**:

- Simplest implementation: 1-line addition to `skills/breakdown/SKILL.md` Handoff section
- No classification logic = no false-positive risk
- Every task list benefits from the durable-spec discipline as reference, even non-backlog ones

**FR-006 variance from PRD**: PRD framed FR-006 as event-driven (`When /breakdown emits backlog-bound tasks…`). Design narrows to ubiquitous (`The /breakdown handoff SHALL reference…`). This is a deliberate scope narrowing — fewer code paths, broader applicability. `/consistency-check` Coverage pass will surface this drift; resolution is to update the PRD's FR-006 wording in the next `--persist` overwrite. Documented here for transparency.

**Rejected alternative**: B (`--backlog` flag) — adds skill argument + classification logic for marginal precision benefit.

**Flexible**: Easy to make conditional later if false-positives surface. <10% rework cost.

---

### Decision-5: `disable-model-invocation: true` placement on both skills in v2.17.0 **[STICKY]**

**Covers**: FR-001

**Choice**: Apply the flag to **both** `/save-spec` AND `/ai-dev-log` in the same v2.17.0 release.

**Why**:

- Both skills are deterministic by nature (scaffolder + git-history reporter); same blast radius
- ADR-014's audit-narrative anchors on shipping these two together as the FR-001 cohort; staggering would force ADR-014 revision for v2.17.1
- Same harness-honoring risk (R1) applies to both; mitigation (ADR-014 documenting observed behavior) covers both equally

**Risk R1 mitigation**: ADR-014 will include a "Harness behavior observed" subsection. Initial state: "Unverified — Claude Code harness behavior with this convention is not documented as of v2.17.0. Field is declared per mattpocock convention; honored-or-not is downstream-tool-dependent."

**STICKY**: ADR-014's tier framework and adoption narrative both reference these two skills as the FR-001 cohort. Changing scope (e.g., dropping `/ai-dev-log`) requires ADR-014 rewrite + PRD re-persist. >50% rework cost on the documentation side.

---

## Constraints

- **C1 (Zero-dep invariant)**: All validator changes MUST be pure bash. No Python, no yq, no npm tools.
- **C2 (Validator ordering)**: P5 manual description-sweep MUST land in same PR as FR-003 check activation, ordered: sweep first, check-on second. Otherwise CI fails on first commit.
- **C3 (Version sync atomicity)**: v2.17.0 bump touches 4 files (plugin.json, marketplace.json, README.md badge+footer, SELF-CHECK.md header). All 4 in same commit; Check 4 enforces.
- **C4 (No skill-graph DAG changes)**: This bundle doesn't add or remove skills. `prev-skill`/`next-skill` edges unchanged. `test-skill-graph.sh` should pass without modification.
- **C5 (Hook unchanged)**: `hooks/session-start.sh` not touched. `test-verbosity-hook.sh` sanity-check only.

## Non-Goals

- Migration of any other mattpocock pattern (P2/P6/P7/P8/P9/P10) — explicitly deferred or rejected in PRD
- Refactoring existing SKILL.md descriptions — only the rubric check is in scope; individual rewrites happen as natural maintenance
- Changes to existing ADR template format — ADR-014 uses the canonical template
- Changes to `tests/validate-content.sh` or `tests/test-skill-graph.sh` — only `validate-structure.sh` touched

## ADR References

- **ADR-009** (read-only skill principle) — design respects this; only `/breakdown`'s read-only handoff text changes
- **ADR-013** (spec-persistence opt-in) — this design itself uses `--persist`; OOS catalog is distinct from spec artifacts
- **ADR-014** (new, to be authored in /breakdown task) — documents the external-prior-art audit framework and these 5 decisions

## Coverage Map (FR → Decision)

| FR     | Decision(s)           | Notes                                                      |
| ------ | --------------------- | ---------------------------------------------------------- |
| FR-001 | Decision-5            | Both skills, v2.17.0                                       |
| FR-002 | Decision-1            | `check_allowed_frontmatter_fields()`                       |
| FR-003 | Decision-1            | `check_description_rubric()`, sweep-before-activate per C2 |
| FR-004 | Decision-2            | YAML frontmatter + body, 3 seed entries                    |
| FR-005 | Decision-3            | Habit-mapped variant                                       |
| FR-006 | Decision-4            | Narrowed to ubiquitous (variance flagged)                  |
| FR-007 | (implementation task) | Standard ADR template, anchored by Decisions 1-5           |
| FR-008 | (existing Check 4)    | Just add `2.17.0` to expected versions                     |

All 8 FRs covered.

<!-- SKILL_OUTPUT:design
decision_count: 5
decisions:
  - "Decision-1: Pure-bash grep -E validator for description rubric (FR-002, FR-003)"
  - "Decision-2: Lightweight YAML frontmatter + body for docs/out-of-scope/ entries (FR-004)"
  - "Decision-3: Habit-mapped AGENT-BRIEF template with H2/H8 sections + Hard rules (FR-005)"
  - "Decision-4: Always-link AGENT-BRIEF in /breakdown handoff; narrows FR-006 from event-driven to ubiquitous"
  - "Decision-5: disable-model-invocation: true on both /save-spec AND /ai-dev-log in v2.17.0 (FR-001)"
sticky_decisions:
  - "Decision-1: validator approach (pure-bash) — >50% redo if reversed"
  - "Decision-5: FR-001 cohort scope (both skills) — ADR-014 narrative anchors on this"
constraints:
  - "C1: Zero-dep invariant — all validator changes pure bash"
  - "C2: P5 manual sweep MUST precede FR-003 check activation in same PR"
  - "C3: Version sync atomicity — 4 files in same commit, Check 4 enforces"
  - "C4: No skill-graph DAG changes"
  - "C5: hooks/session-start.sh untouched"
adr_references:
  - "ADR-009: read-only skill principle (existing)"
  - "ADR-013: spec-persistence opt-in (existing)"
  - "ADR-014: external-prior-art audit framework (new, to be authored)"
article_14_applicable: false
article_14_pass: n/a
END_SKILL_OUTPUT -->
