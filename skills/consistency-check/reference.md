# `/consistency-check` Output Reference

Full output template, worked examples, and column formatting for the cross-artifact consistency analyzer.

**Owning skill**: [`./SKILL.md`](./SKILL.md)
**Owning ADR**: [ADR-013](../../docs/adr/ADR-013-spec-persistence-opt-in.md)

---

## Output Template

```
## Cross-Artifact Consistency Report
**Feature**: <slug>
**Resolved path**: <docs/specs/<slug>/ or absolute path>
**Artifacts read**: <list — e.g., prd.md, design.md, tasks.md>
**ID linkage**: <present | absent>

⚠️ ID linkage absent — using fuzzy match for Coverage and Inconsistency passes; results approximate. See ADR-013 for ID guidance.
[only emit when linkage is absent]

| severity | pass          | location           | finding                                                | suggested action                                              |
| -------- | ------------- | ------------------ | ------------------------------------------------------ | ------------------------------------------------------------- |
| CRITICAL | Drift         | design.md:42       | Decision-3 enables CI gating, but PRD scope_out lists "no enforcement" | Remove Decision-3 or amend PRD scope_out                      |
| CRITICAL | Ambiguity     | prd.md:18          | Literal `[NEEDS CLARIFICATION]` in EARS criterion FR-005 | Resolve placeholder via /requirements clarify pass            |
| HIGH     | Coverage      | prd.md:24          | FR-007 not referenced in any design.md decision         | Add design decision for FR-007 or remove FR-007 from scope    |
| HIGH     | Inconsistency | tasks.md:53        | Task #12 implements: Decision-99 (does not exist)       | Renumber to existing Decision-N or remove task                |
| MEDIUM   | Ambiguity     | prd.md:31          | TBD token in Risks section                              | Resolve TBD before implementation                             |
| LOW      | Underspec     | design.md:67       | Decision-5 has 1 option, no Alternatives section        | Add ≥2 alternatives + rationale per design.md template        |
| ✓ Pass   | (none)        | n/a                | 0 findings                                              | n/a                                                           |

Summary: 6 findings | CRITICAL: 2 | HIGH: 2 | MEDIUM: 1 | LOW: 1 | linkage: absent
```

## Column Definitions

| Column           | Format                                                             | Notes                                                                              |
| ---------------- | ------------------------------------------------------------------ | ---------------------------------------------------------------------------------- |
| severity         | `CRITICAL` / `HIGH` / `MEDIUM` / `LOW` / `✓ Pass`                  | Uppercase for findings; ✓ Pass for zero-finding rows. Sort descending CRITICAL→LOW |
| pass             | `Coverage` / `Drift` / `Ambiguity` / `Underspec` / `Inconsistency` | One of the 5 detection passes. Title case.                                         |
| location         | `<file>:<line>` or `<file>` or `n/a`                               | Cite line when applicable. Use file-only for cross-file findings. n/a for ✓ rows.  |
| finding          | One sentence describing what's wrong                               | Be specific. Name IDs (FR-NNN, Decision-N) when known.                             |
| suggested action | One imperative sentence                                            | Tell the user what to do. Avoid "consider" — be direct.                            |

## Truncation

When findings exceed 30, emit the top 30 by severity (CRITICAL first, then HIGH, etc.) and append:

```
+N more findings; narrow scope or fix highest-severity items first
```

Followed by the Summary row showing the FULL counts (not just the truncated 30).

## Worked Example 1 — With IDs (deterministic)

Suppose `docs/specs/auth-v2/` contains:

- **prd.md** (excerpt): `FR-001: Users SHALL log in with email + password.` ... `FR-002: Sessions SHALL expire after 24 hours.` ... `FR-003: All login attempts SHALL be logged.`
- **design.md** (excerpt): `### Decision-1: Use bcrypt for password hashing` ... `### Decision-2: JWT with 24h expiry (covers FR-002)` ... `### Decision-3: Rate-limit login endpoint`
- **tasks.md** (excerpt): `Task #1 implements: Decision-1 (FR-001)` ... `Task #2 implements: Decision-2 (FR-002)` ... `Task #3 implements: Decision-3`

`/consistency-check auth-v2` output:

```
## Cross-Artifact Consistency Report
**Feature**: auth-v2
**Resolved path**: docs/specs/auth-v2/
**Artifacts read**: prd.md, design.md, tasks.md
**ID linkage**: present

| severity | pass          | location       | finding                                                          | suggested action                                              |
| -------- | ------------- | -------------- | ---------------------------------------------------------------- | ------------------------------------------------------------- |
| HIGH     | Coverage      | prd.md         | FR-003 (login logging) has no design decision and no task        | Add Decision-N for logging or remove FR-003 from PRD          |
| ✓ Pass   | Drift         | n/a            | 0 findings                                                       | n/a                                                           |
| ✓ Pass   | Ambiguity     | n/a            | 0 findings                                                       | n/a                                                           |
| ✓ Pass   | Underspec     | n/a            | 0 findings                                                       | n/a                                                           |
| ✓ Pass   | Inconsistency | n/a            | 0 findings                                                       | n/a                                                           |

Summary: 1 finding | CRITICAL: 0 | HIGH: 1 | MEDIUM: 0 | LOW: 0 | linkage: present
```

The Coverage pass deterministically grep'd `FR-003` against design.md and tasks.md, found neither, flagged HIGH. The other passes ran clean — Drift requires semantic check (no contradiction found), Ambiguity scanned for tokens (none), Underspec checked for Alternatives sections (Decision-1, -2, -3 all had rationale via linked ADRs in the example), Inconsistency verified Task references (`Decision-1`, `Decision-2`, `Decision-3` all exist; `FR-001`, `FR-002` referenced by tasks all exist in PRD).

## Worked Example 2 — Without IDs (LLM semantic + warning)

Same feature but artifacts written without ID markers (e.g., `1. Users shall log in...` instead of `FR-001: Users shall...`):

```
## Cross-Artifact Consistency Report
**Feature**: auth-v2
**Resolved path**: docs/specs/auth-v2/
**Artifacts read**: prd.md, design.md, tasks.md
**ID linkage**: absent

⚠️ ID linkage absent — using fuzzy match for Coverage and Inconsistency passes; results approximate. See ADR-013 for ID guidance.

| severity | pass          | location       | finding                                                          | suggested action                                              |
| -------- | ------------- | -------------- | ---------------------------------------------------------------- | ------------------------------------------------------------- |
| HIGH     | Coverage      | prd.md         | "All login attempts shall be logged" appears in PRD but no matching design decision found (semantic match) | Add design decision for login logging or add FR-NNN markers for deterministic check |
| ✓ Pass   | Drift         | n/a            | 0 findings                                                       | n/a                                                           |
| ✓ Pass   | Ambiguity     | n/a            | 0 findings                                                       | n/a                                                           |
| ✓ Pass   | Underspec     | n/a            | 0 findings                                                       | n/a                                                           |
| ✓ Pass   | Inconsistency | n/a            | 0 findings                                                       | n/a                                                           |

Summary: 1 finding | CRITICAL: 0 | HIGH: 1 | MEDIUM: 0 | LOW: 0 | linkage: absent
```

Same finding caught, but the warning at the top makes the user aware that the result is semantic (LLM judgment) and may have lower precision. The suggested action mentions the upgrade path — adding `FR-NNN` markers turns this into a deterministic check.

## ID Marker Reference

| Artifact    | ID format                               | Where it goes                                                                |
| ----------- | --------------------------------------- | ---------------------------------------------------------------------------- |
| `prd.md`    | `FR-NNN:`                               | Prefix each EARS criterion: `1. [Event-driven] FR-001: When user submits...` |
| `design.md` | `Decision-N` or `### Decision-N:`       | Header per decision, OR inline: `### Decision-4: Database choice`            |
| `tasks.md`  | `Task #N implements: Decision-X (FR-Y)` | Sub-header or first line of task body                                        |

Cross-references are tracked by literal token match. Use exact strings — `FR-001` ≠ `FR1` ≠ `FR_001`.

## YAML Frontmatter Schema (for persisted artifacts)

```yaml
---
feature: <slug matching ^[a-z0-9][a-z0-9-]{1,63}$>
step: requirements | design | breakdown
created: <ISO 8601 datetime, e.g. 2026-05-03T17:24:00+07:00>
updated: <ISO 8601 datetime>
source-issue: <issue#> # OPTIONAL
source-skill-version: <plugin version, e.g. 2.15.0>
---
```

`/consistency-check` does NOT validate frontmatter (that is the validator's job — see `tests/validate-structure.sh`). But it DOES read frontmatter to determine the source skill version and warn if persisted artifacts were written by very old plugin versions that may have used different conventions.

## Limitations (v1)

- Drift pass is always semantic (LLM judgment) — no deterministic mode for Drift
- Skill is not bash-invokable — manual smoke test only (see `CONTRIBUTING.md`)
- Single-feature analysis only — no cross-feature comparison (out of scope per PRD)
- No auto-fix or remediation suggestions beyond the `suggested action` column (read-only by design)
- Numbered variants (`prd.v2.md`, etc.) — analyzer reads the latest version of each, but does not compare across versions
- Ambiguity pass cannot distinguish backtick-quoted documentation references from unresolved markers. If you need to mention a token like `[NEEDS CLARIFICATION]` or `TBD` in artifact prose without it firing a finding, write it in plain text (e.g., "the NEEDS-CLARIFICATION marker") rather than inside a code span. The analyzer's own dogfood spec hits this false-positive at `docs/specs/consistency-check/prd.md:45` — tracked in [#167](https://github.com/pitimon/8-habit-ai-dev/issues/167).

## See Also

- [`SKILL.md`](./SKILL.md) — main skill body with process steps
- [ADR-013](../../docs/adr/ADR-013-spec-persistence-opt-in.md) — design rationale, hybrid eval decision, alternatives considered
- [`docs/specs/consistency-check/`](../../docs/specs/consistency-check/) — dogfood: this skill's own PRD, design, tasks (analyze with `/consistency-check consistency-check`)
- [`guides/persistence-convention.md`](../../guides/persistence-convention.md) — `--persist <slug>` opt-in spec
