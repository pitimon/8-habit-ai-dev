# Structured Output Protocol

## Purpose

Enable cross-skill data handoff via machine-readable blocks embedded in a **persisted artifact file**. Blocks are HTML comments — parseable by consuming skills, and invisible when rendered *by a Markdown viewer that hides comments*.

> **Renderer note (v2.21.39, [#375](https://github.com/pitimon/8-habit-ai-dev/issues/375))**: "invisible" is renderer-specific. Claude Code hides HTML comments; **Codex and some other runtimes render the comment payload verbatim**, so an emitted block becomes visible noise there. The block therefore lives **only in a persisted artifact file** the consumer reads — never appended to the conversation response. A skill run that writes no file emits no block. This keeps the human-facing response concise on every runtime while `/cross-verify` still gets structured evidence from the files it globs.

## Emission gate (when to emit)

Emit a `SKILL_OUTPUT` block **only when the skill's output is being written to a file a consumer reads** — the block is a property of that file, not of the conversation:

- `/requirements`, `/design`, `/breakdown`: emit into `docs/specs/<slug>/{prd,design,tasks}.md` when invoked with `--persist <slug>` (see [`persistence-convention.md`](./persistence-convention.md)). No `--persist` → no block.
- `/review-ai`: emit into the review report **only when that report is saved to a `*-review.md` file**. A conversation-only review emits no block; `/cross-verify` Q5 falls back to manual assessment.
- Persistence aborted or the file write fails → **no block** (no file means no consumer to reach; a conversation block would be pure Codex noise).

The fenced example blocks in the producer SKILL.md files below are the **file templates**, not an instruction to print the block to conversation.

## Completion signal (plain-text, all runtimes)

Separately from the (file-only) `SKILL_OUTPUT` block, a producer skill SHOULD end its **conversation** output with a single plain-text completion line so the human and the next skill get a visible "done" marker:

```
[/<skill-name>] complete
```

e.g. `[/requirements] complete`. When persisting, append the artifact path: `[/requirements] complete → docs/specs/<slug>/prd.md`.

- **Plain text, no HTML comment** — renders cleanly in every runtime (no Codex noise); this is the visible half of the old attribution line, kept after the block itself moved to file-only (v2.21.42, [#375](https://github.com/pitimon/8-habit-ai-dev/issues/375) follow-up).
- It does **not** reference or imply a `SKILL_OUTPUT` block — the block is file-only and may be absent.
- Lowercase `complete` distinguishes it from the block's `COMPLETE|PARTIAL|FAILED` attribution marker (which lives only inside the persisted file's template).

## Format

```
[/<skill-name>] <STATUS-MARKER> SKILL_OUTPUT:<type>
<!-- SKILL_OUTPUT:<type>
key: value
list_key:
  - "item 1"
  - "item 2"
END_SKILL_OUTPUT -->
```

### Rules

1. **Attribution line** (visible, REQUIRED): `[/<skill-name>] <STATUS-MARKER> SKILL_OUTPUT:<type>` directly above the HTML comment opener.
   - Status markers: `COMPLETE` (default emit), `PARTIAL` (degraded run, missing optional fields), `FAILED` (skill could not produce required fields)
   - Skill-name in brackets is the slash-command name without the leading slash escaped — e.g. `[/requirements]`, `[/review-ai]`
   - Text-only markers (no emoji) per `~/.claude/CLAUDE.md` no-emoji rule
   - No plugin version in attribution — keeps version-bump checklist at 4 files instead of 4+N
2. **Block delimiters**: `<!-- SKILL_OUTPUT:<type>` opens, `END_SKILL_OUTPUT -->` closes
3. **Content format**: YAML-like key-value pairs (human-readable, not strict YAML)
4. **Placement**: At the END of the **persisted artifact file**, after all human-readable content — never appended to the conversation response (see §"Emission gate").
5. **Consumer-gated payload, REQUIRED attribution when emitted**: emit a block only when it is written to a file a consumer reads (§"Emission gate"); output remains valid without one. If a block is emitted, the attribution line is required directly above it.
6. **Payload lives in the file, not the conversation**: the block is machine-readable evidence for the consumer that globs the artifact file. It is not printed to the human-facing response — do not rely on "the viewer hides HTML comments," because Codex does not (see the Renderer note).

### Parser-impact statement

The `/cross-verify` parser at `skills/cross-verify/SKILL.md:34` scans for `<!-- SKILL_OUTPUT:` (HTML-comment opener) — the attribution line ABOVE the comment is unaffected. Attribution adds visibility for human readers and downstream skills without breaking existing payload parsers.

## Producer Skills

### `/requirements` → `SKILL_OUTPUT:requirements`

```
[/requirements] COMPLETE SKILL_OUTPUT:requirements
<!-- SKILL_OUTPUT:requirements
ears_count: 5
ears_criteria:
  - "When user submits login form, system shall validate credentials"
  - "While session is active, system shall refresh token every 15min"
scope_in: "Authentication with email/password"
scope_out: "RBAC, OAuth, SSO"
primary_user: "End user"
risks:
  - "Token expiry during long operations"
  - "Concurrent session handling"
success_criteria_count: 3
END_SKILL_OUTPUT -->
```

### `/design` → `SKILL_OUTPUT:design`

```
[/design] COMPLETE SKILL_OUTPUT:design
<!-- SKILL_OUTPUT:design
decision_count: 4
decisions:
  - "PostgreSQL for persistence"
  - "REST API with versioned endpoints"
  - "JWT for authentication"
  - "Redis for session cache"
sticky_decisions:
  - "PostgreSQL — >50% rework to change"
constraints:
  - "Must support 10k concurrent users"
adr_references:
  - "ADR-007: Database choice"
article_14_applicable: false
article_14_pass: n/a
END_SKILL_OUTPUT -->
```

### `/breakdown` → `SKILL_OUTPUT:breakdown`

```
[/breakdown] COMPLETE SKILL_OUTPUT:breakdown
<!-- SKILL_OUTPUT:breakdown
task_count: 5
tasks:
  - "01: Create auth middleware"
  - "02: Add input validation"
  - "03: Implement token refresh"
  - "04: Write unit tests"
  - "05: Update API docs"
dependencies:
  - "03 depends on 01"
estimated_complexity: "medium"
END_SKILL_OUTPUT -->
```

### `/review-ai` → `SKILL_OUTPUT:review`

```
[/review-ai] COMPLETE SKILL_OUTPUT:review
<!-- SKILL_OUTPUT:review
files_reviewed: 4
findings_critical: 0
findings_high: 1
findings_medium: 3
findings_low: 2
pass: true
test_coverage_checked: true
security_checked: true
END_SKILL_OUTPUT -->
```

## Handoff Integrity

For long-running work, compacted sessions, or multi-skill chains, include a small human-readable handoff note before the structured block. This is guidance, not an agent-to-agent runtime protocol.

Recommended fields:

| Field | Purpose |
| --- | --- |
| `current_state` | What is complete, in progress, or blocked. |
| `decisions_made` | Sticky choices the next skill should not reopen casually. |
| `assumptions` | Unverified premises that could change the next step. |
| `evidence` | Files, commands, test output, URLs, issue/PR links. |
| `confidence` | `high`, `medium`, or `low`, with a short reason. |
| `next_skill` | Which skill should read this handoff first. |
| `rejection_path` | When the receiver should stop and ask for clarification. |

Example:

```markdown
## Handoff Integrity
current_state: requirements and design accepted; task split pending
decisions_made: generated catalog is docs/export metadata only
assumptions: Node is available in CI and local dev shells
evidence: docs/compatibility-matrix.md, scripts/generate-skill-catalog.js
confidence: medium — generator validated locally, CI still pending
next_skill: /breakdown
rejection_path: stop if catalog fields imply Claude hook parity in Codex
```

## Consumer Skills

### `/cross-verify` reads all blocks

When `/cross-verify` runs, it should:

1. Search for `<!-- SKILL_OUTPUT:` blocks in the persisted artifact files — glob **`docs/specs/*/prd.md`, `docs/specs/*/design.md`, `docs/specs/*/tasks.md`** (plus their `*.vN.md` conflict variants) for the persist-based skills, and **`*-review.md`** in the working directory for a saved review report. (These canonical `docs/specs/<slug>/…` paths are where `--persist` writes; a bare `*-prd.md` glob in the current directory would miss them.)
2. If blocks found, auto-populate evidence for relevant questions:
   - **Q4** (success criteria): Check `ears_count > 0` and `success_criteria_count > 0` from requirements block; cross-check `decision_count` from design block against `success_criteria_count` — flag if decisions don't cover all criteria
   - **Q5** (test plan): Check `test_coverage_checked: true` from review block
   - **Q8** (scope creep): Compare `task_count` from breakdown vs `ears_count` from requirements — flag if `task_count > ears_count * 3` (one requirement typically decomposes into 1-3 tasks)
   - **Q14** (third alternative): Extract `decision_count` from design block — flag if only 1 option was presented (no third alternative considered)
   - **Q16** (sticky decisions): Extract `sticky_decisions` from design block — flag if 0 sticky decisions in a design with >3 decisions (WHY not captured)
   - **Q17** (next-person empowerment): If a handoff note exists, check that it names current state, evidence, and next skill
3. If no blocks found, fall back to manual assessment (current behavior)
4. Report which blocks were found and which were missing

## Adoption

- Blocks are **opt-in** — skills work fine without them
- Consuming skills **degrade gracefully** — missing blocks = manual check
- No Python, no parsing scripts — Claude reads blocks directly as text
