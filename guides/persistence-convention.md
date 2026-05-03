# Spec Persistence Convention (`--persist <slug>`)

Canonical spec for the opt-in artifact persistence used by `/requirements`, `/design`, and `/breakdown`.

**Owning ADR**: [ADR-013](../docs/adr/ADR-013-spec-persistence-opt-in.md)
**Issue**: pitimon/8-habit-ai-dev#165

---

## When this applies

- Skill is invoked with the argument `--persist <slug>` (e.g., `/8-habit-ai-dev:requirements --persist add-user-login add user authentication`)
- The flag MAY appear before or after the positional feature description
- When the flag is absent: behavior is byte-identical to the pre-v2.15 skill — no file writes, no errors, no directory access. **Hard back-compat invariant.**

## Slug validation

The `<slug>` value MUST match `^[a-z0-9][a-z0-9-]{1,63}$` (lowercase alphanumeric + hyphen, 2-64 chars, no leading hyphen).

On violation: abort persistence (do NOT abort the skill itself) with this error format:

> Tried to persist as slug `<value>`. Slug failed validation against `^[a-z0-9][a-z0-9-]{1,63}$` (lowercase alphanumeric + hyphen, 2-64 chars, must not start with hyphen). Choose a valid slug like `add-user-login` or omit `--persist` to use conversation-only mode.

## Target path

Each skill writes to a fixed filename in `docs/specs/<slug>/`:

| Skill           | Artifact filename |
| --------------- | ----------------- |
| `/requirements` | `prd.md`          |
| `/design`       | `design.md`       |
| `/breakdown`    | `tasks.md`        |

The directory `docs/specs/<slug>/` is created if absent (idempotent — re-running the same skill on the same slug is safe).

## Conflict policy

If the target file already exists, prompt the user via `AskUserQuestion` with three options:

1. **Overwrite** — replace the existing file
2. **Numbered variant** — write to next available `<artifact>.vN.md` (e.g., `prd.v2.md`, `prd.v3.md`)
3. **Abort** — skip persistence; emit conversation output only

When `AskUserQuestion` is unavailable (non-interactive context, batch invocation): default to numbered variant and emit a single warning naming the variant chosen:

> Existing file `<path>` detected; AskUserQuestion unavailable. Wrote to numbered variant `<variant-path>` instead.

## YAML frontmatter

Every persisted artifact MUST begin with this YAML frontmatter block:

```yaml
---
feature: <slug>
step: requirements | design | breakdown
created: <ISO 8601 datetime, e.g. 2026-05-03T17:24:00+07:00>
updated: <ISO 8601 datetime, same as created on first write; updated on overwrite>
source-issue: <issue#> # OPTIONAL — include if known from arg or context
source-skill-version: <plugin version, e.g. 2.15.0>
---
```

Body: full skill output as you would have emitted to conversation, including the `SKILL_OUTPUT:<step>` HTML-comment block at the end.

## Conversation parity

When persisting, the skill MUST also emit the `SKILL_OUTPUT:<step>` block to conversation (not just to the file). This preserves `/cross-verify` auto-detect, which reads from conversation transcript.

## Error message format

All persistence-related error messages MUST state three things, in order:

- **(a)** What the skill attempted (e.g., "Tried to create `docs/specs/<slug>/`")
- **(b)** What failed and why (e.g., "Permission denied: `EACCES` on parent directory")
- **(c)** What the user can do next (e.g., "Run `chmod u+w docs/specs/` or omit `--persist`")

Generic "error" or "failed" messages are NOT acceptable.

## Directory-create failure (fallback, not abort)

If `docs/specs/<slug>/` cannot be created (read-only filesystem, permission denied, disk full):

1. Emit the 3-part error message above
2. **Fall back to conversation-only output** (do NOT abort the skill — the user still gets their PRD/design/tasks in conversation)
3. Continue normal skill execution

## ID-linkage convention (optional, recommended)

For maximum rigor when running `/consistency-check`, persisted artifacts SHOULD include cross-reference IDs:

| Artifact    | ID format                               | Example                                           |
| ----------- | --------------------------------------- | ------------------------------------------------- |
| `prd.md`    | `FR-NNN` per EARS criterion             | `1. [Event-driven] FR-001: When user submits...`  |
| `design.md` | `Decision-N` per decision               | `### Decision-4: Database choice`                 |
| `tasks.md`  | `Task #N implements: Decision-X (FR-Y)` | `Task #1 implements: Decision-4 (FR-001, FR-003)` |

When IDs are present, `/consistency-check` runs deterministic Coverage and Inconsistency passes. When absent, it falls back to LLM semantic comparison and emits an explicit warning at the top of its report. IDs are RECOMMENDED, not REQUIRED.

## Verification

To verify the convention is working:

```bash
# After running e.g. `/requirements --persist add-user-login add user authentication`:
ls docs/specs/add-user-login/
head -10 docs/specs/add-user-login/prd.md  # frontmatter visible
grep "SKILL_OUTPUT:requirements" docs/specs/add-user-login/prd.md  # block present
```
