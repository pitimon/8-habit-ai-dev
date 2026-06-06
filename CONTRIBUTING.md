# Contributing to 8-Habit AI Dev

Thank you for helping improve the plugin. This guide covers how to add skills, habits, question packs, and templates.

## Plugin Philosophy

This is a **philosophy-first** plugin. Skills provide guidance, not automation. They tell Claude _how to approach_ a task — they never modify files themselves. Keep this identity when contributing.

## Adding a New Skill

> Methodology + Pre-Building Preparation pattern: [`guides/skill-authoring.md`](guides/skill-authoring.md). Read it before drafting a new SKILL.md — this section is the structural template; the guide is the rationale + lifecycle.

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

## Objective

[One sentence stating the outcome the user gets from invoking this skill. Distinct from the frontmatter `description` (trigger phrase, enforced by Check 25) and the Habit tag (label). See `guides/skill-authoring.md` §"Why Objective is a section, not a tagline".]

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

### 4. Frontmatter Compatibility Contract

Every `skills/<name>/SKILL.md` frontmatter block must stay valid for both Claude Code and Codex ingestion. The skill body is the portable source of truth; runtime-specific behavior belongs in packaging docs or adapter tooling.

| Field | Required | Cross-agent contract | Notes |
| --- | --- | --- | --- |
| `name` | Yes | Claude Code, Codex, other markdown skill loaders | Must match the directory name exactly. |
| `description` | Yes | Claude Code, Codex | Trigger text, not the skill objective. Keep under 1024 collapsed characters and include concrete trigger phrases. |
| `user-invocable` | Yes | Claude Code, Codex | Boolean flag used by plugin consumers and validators. Current skills use `true`. |
| `argument-hint` | Recommended | Claude Code, Codex | Human/operator hint only. Do not encode runtime semantics here. |
| `allowed-tools` | Yes | Claude Code, Codex-readable | Keep minimal. Tool names document what the skill may need; they are not a universal permission system across runtimes. |
| `prev-skill` | Yes | Claude Code, Codex-readable | Workflow graph metadata. Use a concrete skill, `none`, or `any`. |
| `next-skill` | Yes | Claude Code, Codex-readable | Workflow graph metadata. Use a concrete skill, `none`, or `any`. |
| `disable-model-invocation` | Optional | Must remain Codex-ingestible | Current plugin values are `false` where present. Do not set `true` until Claude Code and Codex support compatible semantics. |

Do not add `category`, `tags`, or third-party registry fields unless there is a documented in-repo consumer and a validator. The generated catalog derives workflow and habit metadata from existing fields/body text instead of expanding the frontmatter surface.

### 5. Generated Skill Catalog

`docs/data/skills.json` is generated from `skills/*/SKILL.md` for cross-agent discovery. Update it whenever skill frontmatter changes:

```bash
node scripts/generate-skill-catalog.js
node scripts/generate-skill-catalog.js --check
```

The catalog is documentation/export metadata only. It must not imply Claude hooks run under Codex, and it must not become a runtime dispatcher or enforcement engine.

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

## Adding an Out-of-Scope Entry (v2.17.0+)

`docs/out-of-scope/` records decisions **not** to ship something. New entries go there when:

- A pattern, skill, or framework was evaluated and explicitly rejected
- We want future contributors (or future-us) to find the rationale before re-proposing
- The decision deserves preservation but isn't an architectural commitment

### ADR vs Out-of-Scope — different verbs, different audiences

| Artifact                      | Verb / framing                                   | Example                                                |
| ----------------------------- | ------------------------------------------------ | ------------------------------------------------------ |
| `docs/adr/ADR-NNN-*.md`       | "We DID decide X" — architectural commitment     | ADR-013 spec-persistence opt-in: this is how it works  |
| `docs/out-of-scope/<name>.md` | "We deliberately WON'T do Y" — rejected proposal | brainstorm-removed: Superpowers already does it better |

If your decision is "we built X and here's why" → ADR.
If your decision is "we considered X and rejected it" → out-of-scope entry.
When in doubt: ADRs are forward-looking commitments; out-of-scope entries are protective fences.

### Format (per ADR-014 / Decision-2)

```yaml
---
date: <ISO 8601 date>
originating-decision: <ADR-NNN ref>
rejected-because: <one-line, ≤140 chars>
---
```

Body (≤200 words): why we won't, what this prevents, **and** an "If reconsidering, read these conditions first" bullet list — the conditions under which we'd re-open. See existing entries in `docs/out-of-scope/` for shape.

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

This catches the "stuck at v2.N-5" scenario at PR time instead of 4 months later when someone notices the README looks ancient. When you bump the version in the Claude manifest, Claude marketplace, Codex manifest, `README.md`, and `SELF-CHECK.md` (the 5-file convention enforced by `validate-structure.sh`), Check 19 verifies you also wrote release notes in the user-facing surfaces. If your release is a pure pointer (e.g., wiki just links back to root `CHANGELOG.md` without its own entry), that satisfies the check — duplication is not required.

See [issue #108](https://github.com/pitimon/8-habit-ai-dev/issues/108) and [issue #106](https://github.com/pitimon/8-habit-ai-dev/issues/106) for the drift incident that motivated this check.

### Real behavior proof

For user-facing doctrine, packaging, install, release, generated catalog, or cross-agent runtime-boundary changes, include a **Real behavior proof** section in the PR body. Unit tests and source diffs are necessary, but they are not enough by themselves when the user-facing surface is a plugin install, wiki page, or generated discovery artifact.

Good proof for this repo includes:

- exact validator commands and pass summaries,
- `node scripts/generate-skill-catalog.js --check` when skill metadata or discovery docs are touched,
- `claude plugin list` output when Claude plugin install/update behavior changes,
- `codex plugin list` output after `codex plugin marketplace upgrade pitimon-8-habit-ai-dev` when Codex packaging or cache-refresh behavior changes,
- links to the exact README, wiki, compatibility, or integration page changed,
- a short "not tested" note for any host platform you did not verify.

Do not use secrets, tokens, credentials, private customer evidence, raw incident transcripts, or sensitive local memory captures as proof. Redact or summarize operational evidence before it enters GitHub.

This is documentation discipline, not a new enforcement hook. If a future contributor proposes turning this checklist into a runtime gate, route that design to `claude-governance` or a separate adapter first.

### Link check (external URLs)

Two GitHub Actions workflows guard against dead links:

- **`.github/workflows/link-check.yml`** — repo-wide markdown link validation. Runs on PR + push to main when any `*.md` file changes. Uses [`lychee`](https://github.com/lycheeverse/lychee) (Rust, fast). Scope: external HTTP/HTTPS URLs across all `*.md` outside `docs/wiki/`. Excludes self-referential URLs to this repo's `main` branch (they only resolve after merge). Issue #172.
- **`.github/workflows/wiki-linkcheck.yml`** — wiki-specific check. Runs on PR when `docs/wiki/**` changes. Same lychee tool, separate workflow because wiki uses wiki-style `[text](Home)` links that require different resolution rules.

Internal markdown links (relative `.md` paths) are validated by `tests/validate-content.sh` Check 12b — out of scope for the link-check workflows. The two-layer design (CI catches external dead URLs; shell tests catch internal broken paths) covers the full surface without duplication.

## Version Bumping

Version lives in **5 files** — all must be bumped together:

- `.claude-plugin/plugin.json`
- `.claude-plugin/marketplace.json`
- `.codex-plugin/plugin.json`
- `README.md` footer
- `SELF-CHECK.md` header (line 3: `**Version**: ... | **Previous**: ...`)

`tests/validate-structure.sh` enforces consistency across all five — CI fails if any drifts. See [issue #106](https://github.com/pitimon/8-habit-ai-dev/issues/106) for the drift incident that motivated the SELF-CHECK.md addition and [ADR-023](docs/adr/ADR-023-codex-native-packaging.md) for the Codex manifest addition.

## Release Checklist

Before bumping the version files above and tagging a release, run through this list. Each item is a forcing function against drift — skipping any item is how dormancy starts (see ADR-018 §"Context" for the 13-month dormancy precedent that motivated this checklist).

- [ ] Run [`SKILL-EFFECTIVENESS.md`](SKILL-EFFECTIVENESS.md) tally update per its §"Maintainer update protocol" — grep Q6 across new lessons since last tally, increment counters, refresh `Last updated` + `Lessons analyzed`, note any new trends or zero-signal skills. ADR-018 Edge #1, anti-dormancy mechanism per issue [#227](https://github.com/pitimon/8-habit-ai-dev/issues/227).
- [ ] CHANGELOG entry added (or explicitly marked doctrine-only per ADR-017 §C5).
- [ ] Version bumped in all 5 files (see "Version Bumping" above) — `tests/validate-structure.sh` will fail CI if any drifts.
- [ ] `README.md` "What's New" mentions the bumped version (Check 19 enforces this).
- [ ] Real behavior proof captured for changed user surfaces: validators, generated catalog freshness, install/list evidence when packaging changed, and explicit "not tested" notes.

**ADR-018 reversal trigger**: if the SKILL-EFFECTIVENESS tally is not updated for ≥2 release cycles, ADR-018 itself enters reversal review per its Forward-Guardrail Sunset criteria. This checklist's existence is part of the proof-of-life mechanism.

## Quality Checklist

Before submitting:

- [ ] Skill has valid YAML frontmatter
- [ ] `name` field matches directory name
- [ ] Definition of Done has 3-5 verifiable items
- [ ] When to Skip has honest conditions
- [ ] Habit mapping is documented
- [ ] No hardcoded secrets or sensitive patterns
- [ ] File under 800 lines
- [ ] PR includes real behavior proof when the change affects install, release, packaging, generated docs/catalogs, or cross-agent runtime expectations
