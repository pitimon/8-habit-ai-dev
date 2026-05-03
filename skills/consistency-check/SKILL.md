---
name: consistency-check
description: >
  Cross-artifact consistency analyzer — runs 5 detection passes across persisted spec artifacts
  (PRD ↔ design ↔ tasks) and emits severity-graded findings.
  Use AFTER /requirements, /design, /breakdown have been run with `--persist <slug>`.
  Read-only — reports drift, coverage gaps, contradictions; does NOT modify or block.
  Inspired by github/spec-kit /analyze. Maps to H5 (Understand First — verify your understanding holds across artifacts) + H1 (Be Proactive — catch drift before code).
user-invocable: true
argument-hint: "<slug-or-path-to-spec-dir>"
allowed-tools: ["Read", "Glob", "Grep"]
prev-skill: any
next-skill: any
---

# Cross-Artifact Consistency Check

**Habits**: H5 (Seek First to Understand) + H1 (Be Proactive) | **Anti-pattern**: Implementing from a PRD/design/tasks bundle that quietly contradicts itself.

## When to Use

- After `/requirements`, `/design`, and `/breakdown` have all been run with `--persist <slug>` for the same feature
- Before starting implementation on a multi-artifact feature, especially across sessions
- When auditing whether a design actually covers all stated requirements
- When onboarding a new team member to an in-flight spec
- During PR review when the PR description references a `docs/specs/<slug>/` directory

## When to Skip

- Single-artifact work (no cross-artifact relationship to check)
- Bug fixes with no spec persisted
- Specs that did not opt into `--persist` (this skill requires persisted files — emits a CRITICAL with guidance if directory empty)

## Input Resolution

`/8-habit-ai-dev:consistency-check <arg>` — auto-detect:

1. If `<arg>` matches an existing directory entry under `docs/specs/<arg>/`, treat as **slug** and read from `docs/specs/<arg>/`
2. Otherwise, treat `<arg>` as a **directory path** (relative or absolute) and read from that path
3. If neither resolves to an existing directory containing at least one of `prd.md`, `design.md`, `tasks.md`: emit a single CRITICAL finding `"No persisted artifacts found at <resolved-path> — was '--persist <slug>' used during /requirements/design/breakdown? See guides/persistence-convention.md"` and exit cleanly

## Process

### Step 1: Read artifacts

Glob the resolved directory for `prd.md`, `design.md`, `tasks.md` (and any `*.vN.md` numbered variants — analyze the latest version of each). Read each file fully.

### Step 2: Detect ID linkage

For each artifact, check whether ID markers are present:

- **prd.md**: search for `FR-NNN` patterns (e.g., `FR-001`, `FR-042`)
- **design.md**: search for `Decision-N` patterns (e.g., `Decision-1`, `### Decision-4`)
- **tasks.md**: search for `Task #N` patterns (e.g., `Task #1`, `### Task #15`)

If ANY artifact lacks its expected marker, set `id_linkage = absent` and emit this warning at the TOP of the report (before any findings):

> ⚠️ **ID linkage absent** — using fuzzy match for Coverage and Inconsistency passes; results approximate. See [ADR-013](../../docs/adr/ADR-013-spec-persistence-opt-in.md) for ID guidance.

If all three artifacts have their markers, set `id_linkage = present` and run all passes deterministically.

### Step 3: Run 5 detection passes

Run each pass in order. Cap total findings at 30 (truncate excess with footer `+N more findings; narrow scope or fix highest-severity items first`). For each pass, emit at least one row — use `✓ Pass: 0 findings` if the pass found nothing (silence is forbidden).

| Pass          | What it checks                                                                                 | Severity                                             | When IDs present                              | When IDs absent               |
| ------------- | ---------------------------------------------------------------------------------------------- | ---------------------------------------------------- | --------------------------------------------- | ----------------------------- |
| Coverage      | Every PRD requirement has ≥1 design decision and ≥1 task                                       | HIGH                                                 | Match `FR-NNN` refs across files              | Semantic comparison + warning |
| Drift         | Design decisions don't contradict PRD scope; tasks don't exceed design scope                   | CRITICAL                                             | Always semantic                               | Always semantic               |
| Ambiguity     | PRD has no unresolved tokens                                                                   | MEDIUM (CRITICAL if literal `[NEEDS CLARIFICATION]`) | Token match                                   | Token match                   |
| Underspec     | Every design decision has rationale + at least 2 alternatives                                  | LOW                                                  | Structural: header `### Alternatives` present | Structural: same              |
| Inconsistency | Tasks don't reference design components that don't exist; design doesn't cite missing PRD reqs | HIGH                                                 | Match `Decision-N` / `FR-NNN` refs            | Semantic comparison + warning |

### Step 4: Format output

Emit a severity-graded table with these columns: `severity | pass | location | finding | suggested action`.

- Sort by severity (CRITICAL → HIGH → MEDIUM → LOW)
- `location` cites `<file>:<line>` when applicable, `<file>` when file-level, or `n/a` when cross-file
- `suggested action` is one short imperative sentence (e.g., `"Add design decision for FR-005 or remove from PRD"`)
- Emit `Summary` row at the bottom: `Total: X findings | CRITICAL: A | HIGH: B | MEDIUM: C | LOW: D | (linkage: present|absent)`

For the full output template with column widths, formatting examples, and dimension-summary footer, load `${CLAUDE_PLUGIN_ROOT}/skills/consistency-check/reference.md`.

### Step 5: H5 + H1 Checkpoint

- **H5**: "Did this surface drift I would have missed by reading each artifact in isolation?"
- **H1**: "Are the highest-severity findings worth fixing BEFORE implementation, not AFTER?"

If the report has 0 CRITICAL/HIGH findings, the bundle is ready for `/build-brief`. If ≥1 CRITICAL or ≥3 HIGH findings, recommend looping back to the originating skill (`/requirements`, `/design`, or `/breakdown`) to remediate before implementation.

## Pass Details

### Pass 1: Coverage

**Purpose**: Every PRD requirement (`FR-NNN`) should have at least one design decision covering it AND at least one task implementing it.

**With IDs**:

- Extract all `FR-NNN` from `prd.md`
- For each `FR-NNN`, grep `design.md` for the literal token and `tasks.md` for the literal token
- Flag HIGH for each `FR-NNN` not found in BOTH downstream files

**Without IDs (semantic)**: Compare each PRD requirement (per EARS criterion or numbered list) against design decisions and task descriptions semantically. Flag HIGH for each requirement that appears unaddressed in either downstream artifact. Emit warning at top of report.

### Pass 2: Drift

**Purpose**: Design decisions and tasks must not exceed the PRD's stated scope.

**Always semantic**: Compare PRD `scope_in` and `scope_out` against design decision titles and task descriptions. Flag CRITICAL for any design decision or task that addresses something explicitly listed in `scope_out`, or anything not covered by `scope_in`.

### Pass 3: Ambiguity

**Purpose**: PRD must not contain unresolved placeholders.

**Token match (deterministic, regardless of ID linkage)**:

- `[NEEDS CLARIFICATION]` literal → CRITICAL
- `TBD`, `TODO`, `???`, `XXX` → MEDIUM
- `<placeholder>` patterns (e.g., `<insert here>`) → MEDIUM

### Pass 4: Underspec

**Purpose**: Every design decision should have rationale + at least 2 alternatives considered.

**Structural (deterministic)**:

- For each `Decision-N` block (or each `### Decision: <topic>` block when IDs absent), check that the immediately following content includes either:
  - A markdown table with ≥2 rows of options, OR
  - At least 2 `**Option [A-Z]**:` markers, OR
  - A linked ADR file (the ADR is the source of truth — accept this as evidence of alternatives considered)
- Flag LOW for each decision lacking this structure

### Pass 5: Inconsistency

**Purpose**: Tasks must reference design components that exist; design must not cite PRD requirements that don't exist.

**With IDs**:

- For each `Task #N implements: Decision-X (FR-Y)` reference, verify `Decision-X` exists in design.md AND `FR-Y` exists in prd.md
- For each `Decision-N covers: FR-X` reference, verify `FR-X` exists in prd.md
- Flag HIGH for each broken reference

**Without IDs (semantic)**: Compare task descriptions to design decision titles and PRD requirement statements semantically. Flag HIGH for tasks that reference design components by name not found in design, or design that references requirements by name not found in PRD. Emit warning at top of report.

## Hybrid Evaluation Decision

The hybrid (deterministic-when-IDs-present, semantic-when-absent) approach was chosen in [ADR-013](../../docs/adr/ADR-013-spec-persistence-opt-in.md) and [Decision 9 of consistency-check design](../../docs/specs/consistency-check/design.md). It preserves backward compatibility with PRDs that don't use IDs (PRD-EARS-2 invariant) while rewarding teams that adopt IDs with deterministic, reproducible analyzer results.

## Severity Bands and Action Recommendations

| Severity | Action                                                                            |
| -------- | --------------------------------------------------------------------------------- |
| CRITICAL | Fix before any implementation work begins. Re-run originating skill to remediate. |
| HIGH     | Fix before /build-brief. Acceptable to track 1-2 as known issues if accepted.     |
| MEDIUM   | Address in same PR as implementation; not a blocker.                              |
| LOW      | Address in next iteration; informational.                                         |

## Handoff

- **Expects from predecessor (any of `/requirements`, `/design`, `/breakdown`)**: a populated `docs/specs/<slug>/` directory with at least one of `prd.md`, `design.md`, `tasks.md`. Best results when all three are present AND ID-linked.
- **Produces for successor (`/build-brief` or any)**: a severity-graded findings report. The user decides whether to proceed, remediate, or revisit. This skill never blocks.

## Definition of Done

- [ ] Input resolved to a directory containing ≥1 expected artifact OR a single CRITICAL emitted with guidance
- [ ] ID-linkage state detected and warning emitted at top if any artifact lacks markers
- [ ] All 5 passes run; each pass emits ≥1 row (✓ Pass: 0 findings if nothing found)
- [ ] Findings sorted by severity, capped at 30 with truncation footer if exceeded
- [ ] Each finding cites `<file>:<line>` or `<file>` in the location column
- [ ] Each finding has a one-sentence imperative `suggested action`
- [ ] Summary row at bottom with total + per-severity counts + linkage state
- [ ] Read-only behavior preserved (no Write, no Bash, no Edit invocations)

## Further Reading

Load `${CLAUDE_PLUGIN_ROOT}/skills/consistency-check/reference.md` for the full output template, worked examples (with-IDs and without-IDs), and column formatting reference.
Load `${CLAUDE_PLUGIN_ROOT}/guides/persistence-convention.md` for the canonical artifact convention and ID marker formats.
Load `${CLAUDE_PLUGIN_ROOT}/habits/h5-understand-first.md` for the H5 principle (verify understanding across sources).
Load `${CLAUDE_PLUGIN_ROOT}/habits/h1-be-proactive.md` for the H1 principle (catch drift before it becomes a bug).
