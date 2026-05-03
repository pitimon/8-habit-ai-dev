# Contributing to 8-Habit AI Dev

Thank you for helping improve the plugin. This guide covers how to add skills, habits, question packs, and templates.

## Plugin Philosophy

This is a **philosophy-first** plugin. Skills provide guidance, not automation. They tell Claude _how to approach_ a task — they never modify files themselves. Keep this identity when contributing.

## Adding a New Skill

### 1. Create the directory

```
skills/<skill-name>/SKILL.md
```

The directory name must match the `name` field in frontmatter.

### 2. Use this template

```yaml
---
name: <skill-name>
description: >
  This skill should be used when the user asks to [specific trigger phrases].
  [What it does in 1-2 sentences]. Maps to H[N] ([Habit Name]).
user-invocable: true
argument-hint: "[what the user provides]"
allowed-tools: ["Read", "Glob", "Grep"]
prev-skill: <skill-name|none|any>
next-skill: <skill-name|none|any>
---

# [Title] ([Thai translation])

**Habit**: H[N] — [Habit Name] | **Anti-pattern**: [What this skill prevents]

## Process

1. **[Step]**: [Instructions]
2. **[Step]**: [Instructions]

## Handoff

- **Expects from predecessor**: [What input this skill needs]
- **Produces for successor**: [What output this skill creates]

## When to Skip

- [Condition where this skill is genuinely unnecessary]
- [Another honest skip condition]

## Definition of Done

- [ ] [Verifiable checkbox item]
- [ ] [Verifiable checkbox item]
- [ ] [Verifiable checkbox item]

Load `${CLAUDE_PLUGIN_ROOT}/[reference-file].md` for detailed guidance.
```

### 3. Conventions (aligned with Anthropic official standards)

- **Description**: Third-person ("This skill should be used when..."), include specific trigger phrases
- **Word count**: Target 1,500-2,000 words for body, max 5,000
- **Heavy detail**: Route to `references/` subdirectory or `guides/` files
- **Allowed tools**: Minimal — `Read`, `Glob`, `Grep` by default. Add `Bash` only when the skill needs to run commands.
- **Definition of Done**: 3-5 verifiable checkbox items per skill
- **When to Skip**: 3-4 honest conditions — prevent compliance theater

## Adding a Habit File

Create `habits/h[N]-[name].md` with this structure:

- **Title and principle** (1 paragraph)
- **Rules** (specific, actionable)
- **Anti-patterns** (what to avoid)
- **Real Example** (from production experience)
- **Checkpoint** (reflexive question)

## Adding a Cross-Verify Question Pack

Create `guides/cross-verify-packs/<domain>.md`:

- 5 domain-specific questions
- Each tagged with a Dimension (Body/Mind/Heart/Spirit)
- Scored separately from the main 17 questions

## Adding an Output Template

Create `guides/templates/<name>-template.md`:

- Placeholder sections (not just headings)
- Referenced from skills via `Load` directive

## Spec Persistence + Consistency Check (v2.15.0+)

The `--persist <slug>` flag on `/requirements`, `/design`, `/breakdown` writes artifacts to `docs/specs/<slug>/{prd,design,tasks}.md`. The `/consistency-check` skill reads those files to detect cross-artifact drift. Canonical convention: [`guides/persistence-convention.md`](guides/persistence-convention.md). Design rationale: [ADR-013](docs/adr/ADR-013-spec-persistence-opt-in.md).

### Manual smoke test (since skills are not bash-invokable)

After modifying any of `/requirements`, `/design`, `/breakdown`, or `/consistency-check` (or after touching `guides/persistence-convention.md` or its load directives), run this manual smoke test to verify the round trip works:

1. From a Claude Code session in this repo, invoke:
   ```
   /8-habit-ai-dev:consistency-check consistency-check
   ```
   (Auto-detects: matches `docs/specs/consistency-check/` slug, reads our own dogfood artifacts.)
2. **Expected output**: 0 CRITICAL/HIGH findings; 0 or few MEDIUM/LOW; `linkage: present` (this PR ships with `FR-NNN`/`Decision-N`/`Task #N` markers).
3. **If unexpected findings appear**: either the skill's detection logic regressed, OR the dogfood artifacts genuinely drifted (one of `prd.md`/`design.md`/`tasks.md` is out of sync with the others). Check the finding's `suggested action` column.

### Adding ID markers to your own specs

Optional but recommended for deterministic analyzer results. See the OPTIONAL ID linkage callouts at the top of `prd-template.md`, `adr-template.md`, and `task-list-template.md` in `guides/templates/`.

## Testing Conventions

Test scripts under `tests/` run in GitHub Actions on Linux with `set -o pipefail`. When shelling out, prefer patterns that cannot SIGPIPE.

### Frontmatter extraction — use `awk`, not `sed | grep | head`

**Anti-pattern** (SIGPIPE race under `pipefail`):

```bash
# DON'T — GNU sed exits 4 when head closes stdin mid-stream
name_value=$(sed -n '/^---$/,/^---$/p' "$skill_file" | grep "^name:" | head -1 | sed 's/^name:[[:space:]]*//')
```

**Convention** (zero-pipe, SIGPIPE-safe):

```bash
# DO — single awk, no pipe, bounded by second frontmatter delimiter
name_value=$(awk '/^---$/{c++; if(c==2) exit; next} c==1 && sub(/^name:[[:space:]]*/, ""){print; exit}' "$skill_file")
```

The awk pattern: count `---` delimiters, stop at the second one, inside frontmatter (`c==1`) strip the `field:[[:space:]]*` prefix and print the first match — all in one process, no pipe buffer, no race.

### Why it matters

On Linux CI with GNU sed, if `head` closes stdin before sed finishes writing, sed receives SIGPIPE and exits with code 4 (`couldn't flush stdout: Broken pipe`). Under `set -o pipefail` this propagates as test failure. macOS BSD sed silently ignores SIGPIPE so the anti-pattern passes locally and flakes only in CI — the worst kind of bug class.

The `grep` filter between `sed` and `head` reduces output volume and shrinks the race window, but does not eliminate it. Widen the race by adding body `---` lines to any SKILL / ADR / habit doc and the flake returns.

### Prior art

- **First fix**: [PR #99](https://github.com/pitimon/8-habit-ai-dev/pull/99) (v2.6.1) fixed one flaking instance in `tests/validate-content.sh:614`
- **Full audit**: [PR #103](https://github.com/pitimon/8-habit-ai-dev/pull/103) (closes #101) replaced 8 remaining instances in `tests/validate-structure.sh` and `tests/test-skill-graph.sh`
- **Header comment**: See `tests/validate-structure.sh:27-28` and `tests/validate-content.sh:619-620` for the in-code rationale

### Broader lens

Audit any new shell pipeline for the same shape: any `<file-reader> | <filter> | head` under `pipefail` is suspect. When in doubt, materialize into a variable first (`fm=$(awk ...)`) and then slice — variable expansion + small pipes don't have the file-reading race.

### Docs freshness check

`tests/validate-content.sh` Check 19 enforces **downstream propagation** from the authoritative `CHANGELOG.md` to user-facing doc surfaces:

- **`README.md`** must mention the current version from `.claude-plugin/plugin.json` (typically in the "What's New" section)
- **`docs/wiki/Changelog.md`** must either mention the current version OR contain a relative link to `CHANGELOG.md` (pointer-based design per ADR-004)

This catches the "stuck at v2.N-5" scenario at PR time instead of 4 months later when someone notices the README looks ancient. When you bump the version in `plugin.json` + `marketplace.json` + `README.md` + `SELF-CHECK.md` (the 4-file convention enforced by `validate-structure.sh`), Check 19 verifies you also wrote release notes in the user-facing surfaces. If your release is a pure pointer (e.g., wiki just links back to root `CHANGELOG.md` without its own entry), that satisfies the check — duplication is not required.

See [issue #108](https://github.com/pitimon/8-habit-ai-dev/issues/108) and [issue #106](https://github.com/pitimon/8-habit-ai-dev/issues/106) for the drift incident that motivated this check.

## Version Bumping

Version lives in **4 files** — all must be bumped together:

- `.claude-plugin/plugin.json`
- `.claude-plugin/marketplace.json`
- `README.md` footer
- `SELF-CHECK.md` header (line 3: `**Version**: ... | **Previous**: ...`)

`tests/validate-structure.sh` enforces consistency across all four — CI fails if any drifts. See [issue #106](https://github.com/pitimon/8-habit-ai-dev/issues/106) for the drift incident that motivated the SELF-CHECK.md addition.

## Quality Checklist

Before submitting:

- [ ] Skill has valid YAML frontmatter
- [ ] `name` field matches directory name
- [ ] Definition of Done has 3-5 verifiable items
- [ ] When to Skip has honest conditions
- [ ] Habit mapping is documented
- [ ] No hardcoded secrets or sensitive patterns
- [ ] File under 800 lines
