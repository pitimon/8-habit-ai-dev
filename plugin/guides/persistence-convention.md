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

## Current State File (Optional, User-Owned)

In addition to the 3 skill-managed artifacts above, this convention recommends a **4th file** for capturing **where the work stands right now** (running state, not immutable spec):

```
docs/specs/<slug>/current-state.md
```

**User-owned, manual.** No plugin skill writes to this file — the user creates and maintains it manually. It exists to solve the **resume-after-context-loss** problem: when `/clear`, `/compact`, or a session crash flushes conversation context, this file is the fine-grained task-level anchor the next session reads to continue without re-explanation.

> **Project archetype note**: this convention is the **feature-spec mode** — per-feature persistence under `docs/specs/<slug>/`. For single-system / operational / infrastructure repos where one project-root `SPEC.md` digest pointing to project-specific detail files fits better, see the complementary [`spec-digest-pattern.md`](./spec-digest-pattern.md) (project-orientation hub mode). The two modes can coexist but most projects pick one.

**Frontmatter exemption (explicit)**: unlike the skill-managed artifacts above (`prd.md` / `design.md` / `tasks.md`), `current-state.md` is user-owned and **not** subject to the [YAML frontmatter](#yaml-frontmatter) MUST. The file is free-form Markdown using the template below — no `feature`/`step`/`created`/`updated` fields required (a `Last updated` line in the body is sufficient).

### Template

```markdown
# Current State — <feature name>

**Doing now**: <specific task/sub-task currently active, e.g. "Task #4 — implement GET /users/:id endpoint">
**Blocked on / stuck at**: <what's holding it up, or "nothing" / "waiting for review">
**Next**: <the immediate next action when this completes>
**Last updated**: <ISO 8601 datetime>
```

### Why a separate file rather than a section in `tasks.md`

Re-running `/breakdown --persist <slug>` is legitimate when scope changes and a re-breakdown is needed. The [Conflict policy](#conflict-policy) above triggers and either overwrites `tasks.md` or writes to a numbered variant. A hand-maintained `## Current State` H2 inside `tasks.md` would be at risk either way — overwrite loses it; numbered variant splits user-edited state from skill-regenerated tasks. Isolating Current State in its own user-owned file (no skill writer) eliminates the ownership conflict.

### Granularity vs `hooks/session-start.sh`

`hooks/session-start.sh` already detects which `--persist` artifacts exist and nudges the **next workflow step** (e.g. `prd.md` present → suggest `/design`). That's **step-level** resume awareness.

`current-state.md` is **task-level** resume awareness — which specific task is in flight, what blocker, what immediate next action. The two are complementary; both can be used together.

### `/consistency-check` exclusion (explicit)

`/consistency-check` does **NOT** analyze `current-state.md`. Informal running state is out of scope for cross-artifact consistency passes, which operate on the PRD ↔ design ↔ tasks immutable specs. The exclusion is by design — running state changes constantly and would create noise in drift/coverage analysis.

## Auto-Update Recipe (User-Side, Optional)

To keep `current-state.md` honest without remembering to update it each time, users can adopt a CLAUDE.md rule in their own `~/.claude/CLAUDE.md` or project `CLAUDE.md`:

```markdown
## After completing any task:

1. Update `docs/specs/<slug>/current-state.md` — what's doing now, blockers, next action, last-updated timestamp
2. Update data contracts in `docs/specs/<slug>/design.md` if any interface changed
3. Never claim "done" without updating `current-state.md` first
```

**Plugin does not enforce this.** [ADR-013 Alternative 4](../docs/adr/ADR-013-spec-persistence-opt-in.md) rejected plugin-side auto-persist as violating the no-build philosophy ("skills are read-only guidance"; always-writing skills create unintended file artifacts) — that decision stands. The recipe above is **user-side adoption**: the user opts into the discipline by adding the rule to their own CLAUDE.md. The plugin teaches the pattern; the user owns enforcement.

This split honors the plugin boundary: workflow discipline lives here, runtime enforcement lives in `claude-governance` (or in user CLAUDE.md hooks for self-enforcement).

## Verification

To verify the convention is working:

```bash
# After running e.g. `/requirements --persist add-user-login add user authentication`:
ls docs/specs/add-user-login/
head -10 docs/specs/add-user-login/prd.md  # frontmatter visible
grep "SKILL_OUTPUT:requirements" docs/specs/add-user-login/prd.md  # block present
```

---

## Attribution

The "Current State File" + "Auto-Update Recipe" sections paraphrase a community pattern from the Thai-language article _"ผมไม่เคยกลัว /clear กับ /compact"_, which proposes a single `spec.md` with 4 sections (architecture / done / todo / current state) auto-updated via a CLAUDE.md rule. This plugin imports the **current-state save-point** insight and the **auto-update recipe** template as a 4th user-owned file rather than collapsing onto a single file — the existing 3-file skill-managed model is better suited to `/consistency-check`'s cross-artifact passes (PRD ↔ design ↔ tasks). See [#176](https://github.com/pitimon/8-habit-ai-dev/issues/176).
