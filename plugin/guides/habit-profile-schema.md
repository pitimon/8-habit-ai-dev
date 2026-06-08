# Habit Profile Schema — `~/.claude/habit-profile.md`

**Status**: Specification (v2.6.0) | **Schema version**: 1 | **Audience**: Maintainers of `/calibrate` and future readers | **Related**: Issue [#90](https://github.com/pitimon/8-habit-ai-dev/issues/90), [ADR-008](../docs/adr/ADR-008-user-maturity-calibration-design.md)

## Purpose

The Habit Profile is a **user-local** markdown file at `~/.claude/habit-profile.md` that records the user's self-assessed 8-habit maturity level. It is written by the `/calibrate` skill and read by other skills that want to adapt their verbosity to the user's experience.

**Why a standalone schema doc exists**: This file is the **public contract** between the writer (`/calibrate`) and future readers (the 16 existing skills, which will gradually adapt to read the profile in a v2.7.0 follow-up PR). Keeping the schema in its own file — not inlined in the skill — means the skill body can evolve without rewriting every reader, and readers can code against a stable API. Schema versioning is built in via the `schema-version` field.

## Scope

**In scope**:
- YAML frontmatter field definitions (v1)
- Example profile file
- Reader integration guidance (sed idiom for parsing from bash)
- Schema versioning policy

**Out of scope**:
- The question set and scoring rubric (lives in `skills/calibrate/SKILL.md`)
- Runtime enforcement of verbosity (readers are guidance, not gates — ADR-008 §Consequences)
- Per-project profiles (v1 is global; see ADR-008 §Decision)

## File Location and Lifecycle

| Attribute | Value |
|---|---|
| **Path** | `~/.claude/habit-profile.md` |
| **Scope** | Global (per user, not per project) |
| **Created by** | `skills/calibrate/SKILL.md` on first successful run |
| **Updated by** | `skills/calibrate/SKILL.md` on re-invocation (with user confirmation) |
| **Read by** | Future skill readers (v2.7.0+); `hooks/session-start.sh` (existence check + age warning only) |
| **Deleted by** | User only — no skill deletes the profile |
| **Permissions** | 0644 recommended (owner read/write, others read) |

## Schema v1 — Frontmatter Fields

All fields are in YAML frontmatter (between `---` delimiters). The body below the frontmatter is human-readable prose and is NOT parsed by readers.

| Field | Type | Required | Constraint | Description |
|---|---|---|---|---|
| `level` | string enum | ✅ Yes | One of: `Dependence`, `Independence`, `Interdependence`, `Significance` | The user's 8-habit maturity level per `rules/effective-development.md` |
| `calibrated` | string | ✅ Yes | ISO 8601 datetime with timezone | Timestamp when the profile was last written |
| `schema-version` | integer | ✅ Yes | Currently `1` | Schema version for forward-compatible migration |
| `responses` | map (string → string) | ✅ Yes | Keys listed below; values are free-form natural language from the user | Raw answers to the calibration questions, for audit and re-scoring |
| `preferences.verbosity-override` | string enum | ⚠️ Optional | One of: `none`, `verbose`, `concise` | Manual override of level-default verbosity. Readers should respect this over the level inference. |

### `responses` map — canonical keys (v1)

These five keys are mandatory for v1. `/calibrate` may emit additional keys (e.g. `heart-signal`, `spirit-signal`) which readers should ignore if unknown.

| Key | Question (short) | Example value |
|---|---|---|
| `plugin-experience` | How long have you used 8-habit-ai-dev? | `"~3 months"` |
| `ci-experience` | Comfort with CI/testing/review discipline | `"comfortable"` |
| `team-context` | Team/collaboration context | `"solo"` |
| `vocabulary-comfort` | 8-habit vocabulary fluency (H1-H8, Whole Person, Three Loops) | `"mostly clear"` |
| `orientation` | Reactive fixing vs proactive prevention | `"preventive"` |

**Why NL strings, not enums**: The scoring logic lives in `/calibrate`'s rubric. Responses are stored verbatim so a future re-scoring pass (e.g. if the rubric is tightened) can re-interpret the same raw input without asking the user again.

## Full Example Profile File

```markdown
---
level: Independence
calibrated: 2026-04-11T14:05:00+07:00
schema-version: 1
responses:
  plugin-experience: "~3 months"
  ci-experience: comfortable
  team-context: solo
  vocabulary-comfort: mostly clear
  orientation: preventive
preferences:
  verbosity-override: none
---

# Habit Profile — Independence

Calibrated on 2026-04-11. This profile informs how `/requirements`, `/review-ai`,
`/cross-verify`, and other skills adapt their verbosity and checkpoint emphasis
to your experience level.

**Your level — Independence**: You can run the 7-step workflow without hand-holding.
Skills will show key checkpoints only and skip beginner examples. You retain full
verbosity whenever you want by setting `preferences.verbosity-override: verbose`.

**Re-calibrate**: Run `/calibrate` again anytime your practice changes meaningfully.
This profile was self-assessed; re-assess after ~90 days of different work or
after a major workflow change.
```

## Reader Integration

### Parsing the profile from bash (sed idiom)

Readers can reuse the same frontmatter-parsing pattern the plugin's validators use for `SKILL.md` files:

```bash
PROFILE="$HOME/.claude/habit-profile.md"

# Profile existence check
if [ ! -f "$PROFILE" ]; then
  # No profile — use default (verbose) verbosity
  LEVEL="Dependence"
else
  # Extract level field from frontmatter
  LEVEL=$(sed -n '/^---$/,/^---$/{ s/^level:[[:space:]]*//p; }' "$PROFILE" | head -1 | tr -d '[:space:]')
fi

# Extract verbosity override (if set)
OVERRIDE=$(sed -n '/^---$/,/^---$/{ s/^[[:space:]]*verbosity-override:[[:space:]]*//p; }' "$PROFILE" | head -1 | tr -d '[:space:]')
```

Note the indented-pattern for `verbosity-override` — it lives under `preferences:`, so the regex allows leading whitespace.

### Parsing from a skill body (Claude natural-language interpretation)

When a skill body says "read the user's profile and adapt verbosity accordingly", Claude can read the file directly with the `Read` tool and interpret the YAML frontmatter without a shell parser. This is the recommended pattern for skills that adapt at runtime.

### Age warning

Readers that want to surface staleness should compare `calibrated` to today:

```bash
CAL_DATE=$(sed -n '/^---$/,/^---$/{ s/^calibrated:[[:space:]]*//p; }' "$PROFILE" | head -1 | cut -d'T' -f1)
AGE_DAYS=$(( ( $(date +%s) - $(date -j -f "%Y-%m-%d" "$CAL_DATE" +%s) ) / 86400 ))
if [ "$AGE_DAYS" -gt 90 ]; then
  echo "Profile is $AGE_DAYS days old — consider running /calibrate again."
fi
```

The date arithmetic uses BSD `date` syntax (macOS default). Readers targeting Linux should use `date -d` instead.

### Verbosity mapping (reference — readers decide their own specifics)

| Level | Default verbosity | Typical behavior |
|---|---|---|
| **Dependence** | Full guidance | All checkpoints shown, beginner examples inline, every habit linked |
| **Independence** | Key checkpoints only | Skip beginner examples, keep critical checkpoints, link habits on demand |
| **Interdependence** | Team-oriented guidance | Focus on delegation, review, and synergy patterns; terse individual guidance |
| **Significance** | Minimal prompts | Trust user judgment; elide ceremony; surface only non-obvious or high-consequence checkpoints |

**Override precedence**: If `preferences.verbosity-override` is set to `verbose` or `concise`, readers should use the override regardless of the level. `none` means "use level default".

## Schema Versioning Policy

- **v1** (this document): initial schema. Required fields frozen.
- **Bumping to v2** requires: (a) a migration note in this document, (b) a read-path in `/calibrate` that detects `schema-version: 1` and either migrates or refuses with a clear message, (c) an ADR if the change is breaking for existing readers.
- **Field additions within a major version**: OK to add new optional fields without bumping. Readers must gracefully ignore unknown fields.
- **Field removals or renames**: require a major version bump.
- **Value enum additions** (e.g. adding a 5th level): require a major version bump. Readers may hit unknown-level errors otherwise.

## Readers — Compatibility Expectations

Future skills that read this profile MUST:

- Handle the file **not existing** (default to `Dependence` verbosity — safest: more guidance is better than less for unknown users)
- Handle `schema-version` mismatches gracefully (log a note and use defaults; do NOT fail the skill invocation)
- Treat the file as **read-only** — only `/calibrate` writes it
- NOT leak profile contents to external services (this is user-local data)
- Respect `preferences.verbosity-override` over the inferred level

## References

- **Issue #90**: [pitimon/8-habit-ai-dev#90](https://github.com/pitimon/8-habit-ai-dev/issues/90) — User Maturity Calibration
- **ADR-008**: [User Maturity Calibration Design](../docs/adr/ADR-008-user-maturity-calibration-design.md) — 5 locked design decisions
- **Maturity model source**: [`rules/effective-development.md`](../rules/effective-development.md) — Dependence → Independence → Interdependence → Significance
- **Existing rubric pattern**: [`guides/whole-person-rubrics.md`](whole-person-rubrics.md) — dominant-level selection pattern adapted here for user-level classification
- **Writer skill**: [`skills/calibrate/SKILL.md`](../skills/calibrate/SKILL.md) — the `/calibrate` skill that produces profiles matching this schema
