# Structured Output Protocol

## Purpose

Enable cross-skill data handoff via machine-readable blocks embedded in markdown output. Blocks are HTML comments — invisible when rendered, parseable by consuming skills.

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
4. **Placement**: At the END of skill output, after all human-readable content
5. **Optional payload, REQUIRED attribution**: Skills SHOULD emit blocks but output remains valid without payload; if a block is emitted, attribution is required.
6. **Invisible payload, visible attribution**: HTML comment payload doesn't render in markdown viewers — zero visual impact. Attribution line is plain text above the comment, scannable in transcripts.

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

## Consumer Skills

### `/cross-verify` reads all blocks

When `/cross-verify` runs, it should:

1. Search for `<!-- SKILL_OUTPUT:` blocks in recent files (PRD, task list, review report) in the current directory
2. If blocks found, auto-populate evidence for relevant questions:
   - **Q4** (success criteria): Check `ears_count > 0` and `success_criteria_count > 0` from requirements block
   - **Q5** (test plan): Check `test_coverage_checked: true` from review block
   - **Q8** (scope creep): Compare `task_count` from breakdown vs `ears_count` from requirements — flag if `task_count > ears_count * 3` (one requirement typically decomposes into 1-3 tasks)
3. If no blocks found, fall back to manual assessment (current behavior)
4. Report which blocks were found and which were missing

## Adoption

- Blocks are **opt-in** — skills work fine without them
- Consuming skills **degrade gracefully** — missing blocks = manual check
- No Python, no parsing scripts — Claude reads blocks directly as text
