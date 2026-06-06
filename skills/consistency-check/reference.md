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

## Incident/Config Hotfix Mode

Use this mode when there is no persisted `docs/specs/<slug>/` bundle, but the work still needs consistency across an operational symptom, evidence, root cause, change text, deploy path, and live verification.

### Inputs

- Reported symptom or alert text
- Reproduced evidence, alert history, logs, metrics, or rendered config
- Root-cause evidence from an independent source where possible
- PR/change summary and actual diff/change description
- Changelog, release note, or issue closure text when present
- Deploy path and live verification after rollout
- Related operational state classification when a separate issue remains

### Checks

| Check | Drift to flag |
| ----- | ------------- |
| Symptom matches evidence | Alert/issue text describes a symptom that was not reproduced or is only inferred |
| Root cause verified | Cause is asserted from one source only, or evidence proves correlation but not cause |
| PR/change text matches actual fix | PR claims a broad fix while the diff only changes wording, routing, config, or restart behavior |
| Changelog/release notes do not overclaim | Release text says "resolved" when verification only proves "alert quiet" or "one path fixed" |
| Deploy notes match actual path | Notes say image deploy while actual rollout was mounted config, Swarm config, restart, or no deploy |
| Live verification proves original symptom resolved | Verification checks a secondary health signal but not the original alert/user-facing symptom |
| Related state is classified | Separate operational state is hidden instead of named as Watch, Handoff, Known Accepted Issue, or Active Incident |

### Output Template

```
## Incident/Config Consistency Report
**Subject**: <issue/PR/incident/config>
**Mode**: incident/config hotfix
**Artifacts read**: <issue, PR, changelog, deploy note, alert, live check>

| symptom | evidence | root cause | fix | verification | drift |
| ------- | -------- | ---------- | --- | ------------ | ----- |
| <reported symptom> | <reproduced or alert evidence> | <verified cause> | <actual PR/change> | <live proof> | <CLEAN | MISSING_EVIDENCE | OVERCLAIM | SCOPE_MISMATCH | DEPLOY_DRIFT | ADJACENT_STATE_UNCLASSIFIED> |

Summary: <CLEAN or N drift findings> | unresolved related state: <none | state + owner>
```

### Drift Labels

| Label | Meaning |
| ----- | ------- |
| `CLEAN` | Claims, fix, deploy path, and verification align |
| `MISSING_EVIDENCE` | A symptom, cause, or verification claim lacks direct evidence |
| `OVERCLAIM` | PR/changelog/closure text claims more than evidence proves |
| `SCOPE_MISMATCH` | Fix addresses a narrower or different issue than the symptom/root cause |
| `DEPLOY_DRIFT` | Claimed deploy path differs from the actual runtime change path |
| `ADJACENT_STATE_UNCLASSIFIED` | Related operational state remains but is not classified or handed off |

### Worked Example 3 — WorkerDown / Alertmanager Hotfix

Scenario: an operator receives repeated `WorkerDown` notifications. The PR says "fix WorkerDown alert noise", the changelog says "WorkerDown resolved", and the deploy note says "released worker image". Actual evidence shows a stale Alertmanager template rendered the wrong notification link while a staging worker was also stopped.

```
## Incident/Config Consistency Report
**Subject**: WorkerDown notification/config hotfix
**Mode**: incident/config hotfix
**Artifacts read**: issue, PR body, changelog entry, deploy note, Alertmanager rendered config, live worker check

| symptom | evidence | root cause | fix | verification | drift |
| ------- | -------- | ---------- | --- | ------------ | ----- |
| WorkerDown email points responders to the wrong investigation path | Alertmanager rendered config shows stale notification link; alert history shows WorkerDown firing | Notification template drift in live Alertmanager config; separate staging worker is stopped | PR updates template source and deploy note restarts Alertmanager config; staging worker restart tracked separately | Test notification renders the corrected link; production Alertmanager config checksum matches source | CLEAN for notification fix; ADJACENT_STATE_UNCLASSIFIED until staging worker state is classified |
| Staging worker is not running | Service check shows missing/stopped worker | Worker process not scheduled/running in staging | Not fixed by the template PR | No healthy staging worker verification in this PR | SCOPE_MISMATCH if changelog says all WorkerDown causes resolved |

Summary: 2 drift findings | unresolved related state: classify staging worker via /operational-state before closure
```

Good closure text says the notification/config drift is fixed and separately classifies the staging worker state. Bad closure text says "WorkerDown resolved" without proving the worker symptom itself is gone.

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

## See Also

- [`SKILL.md`](./SKILL.md) — main skill body with process steps
- [ADR-013](../../docs/adr/ADR-013-spec-persistence-opt-in.md) — design rationale, hybrid eval decision, alternatives considered
- [`docs/specs/consistency-check/`](../../docs/specs/consistency-check/) — dogfood: this skill's own PRD, design, tasks (analyze with `/consistency-check consistency-check`)
- [`guides/persistence-convention.md`](../../guides/persistence-convention.md) — `--persist <slug>` opt-in spec
