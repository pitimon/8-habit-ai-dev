# agentskills.io Compatibility Evaluation

**Status**: Research brief (v2.6.0) | **Issue**: [#91](https://github.com/pitimon/8-habit-ai-dev/issues/91) | **Related**: ADR pending | **Decision**: NO-GO on full migration (see Recommendation)

## Purpose

Evaluate whether `8-habit-ai-dev` should migrate its skill frontmatter from Claude Code-specific fields (`prev-skill`, `next-skill`, `user-invocable`, `argument-hint`) to the open [agentskills.io](https://agentskills.io) standard to enable cross-agent portability (Cursor, VS Code/Copilot, Gemini CLI, OpenHands, Junie, Roo Code, Goose, and others).

This document is a **research-only evaluation** — not a migration plan. It answers: *should we migrate, and if so, how?*

---

## Research Brief: agentskills.io Compatibility

**Depth**: Deep | **Mode**: Compare | **Date**: 2026-04-11

### Questions Investigated

1. What fields does the agentskills.io specification mandate, and which are optional?
2. Which of our current frontmatter fields are standard, VS Code extensions, or fully custom?
3. Do other tools (Cursor, VS Code, Gemini CLI) parse `metadata.*` sub-fields for workflow chaining, or do they ignore them?
4. Does our DAG validator (`tests/test-skill-graph.sh`) still work if `prev-skill`/`next-skill` move to `metadata:`?
5. How many of our 16 skills would need changes for spec compliance?
6. What would be gained — and lost — by migrating?

### Findings

| # | Finding | Source | Verified |
|---|---------|--------|----------|
| 1 | agentskills.io core spec defines exactly 6 frontmatter fields: `name` (required), `description` (required), `license`, `compatibility`, `metadata`, `allowed-tools` (experimental) | [agentskills.io/specification](https://agentskills.io/specification) — quoted verbatim | Yes |
| 2 | `metadata` is defined as "A map from string keys to string values. Clients can use this to store additional properties not defined by the Agent Skills spec." | agentskills.io/specification §metadata | Yes |
| 3 | `allowed-tools` spec format is a **space-separated string** (e.g. `allowed-tools: Bash(git:*) Bash(jq:*) Read`), NOT a YAML array | agentskills.io/specification §allowed-tools | Yes |
| 4 | VS Code extends the spec with: `argument-hint`, `user-invocable`, `disable-model-invocation`. Its docs do NOT mention custom `metadata` parsing or any workflow chaining mechanism. | [code.visualstudio.com/docs/copilot/customization/agent-skills](https://code.visualstudio.com/docs/copilot/customization/agent-skills) | Yes |
| 5 | Gemini CLI docs: "name (required) and description (required) ... These are the only fields that Gemini CLI reads to determine when the skill gets used" — no chain mechanism, no metadata parsing | [geminicli.com/docs/cli/creating-skills](https://geminicli.com/docs/cli/creating-skills) (via WebSearch) | Yes |
| 6 | Cursor docs unavailable (HTTP 429 rate limit across 3 retries). Inference: Cursor is a VS Code fork, likely inherits VS Code's agentskills.io implementation. | [cursor.com/docs/context/skills](https://cursor.com/docs/context/skills) | **Unverified — marked as inference** |
| 7 | All 16 of our skills use `allowed-tools` as a YAML **array** (e.g. `["Read", "Glob", "Grep"]`), not the spec's space-separated string format | `grep -n "allowed-tools" skills/*/SKILL.md` — 16 matches | Yes |
| 8 | DAG validator extracts chain edges via frontmatter-scoped substitution: `sed -n '/^---$/,/^---$/{ s/^prev-skill:[[:space:]]*//p; }'`. The inner `^prev-skill:` still requires start-of-line, so indented `metadata.prev-skill` under `metadata:` fails to match. | `tests/test-skill-graph.sh:36-37` | Yes |
| 9 | `tests/validate-structure.sh` has 5 check blocks that require top-level `prev-skill`/`next-skill`/`allowed-tools`: Check 1 (line 37), Check 6 (line 115), chain continuity (line 143), standalone detection (line 157), Check 11 `allowed-tools` parsing (line 221) | `grep -n` on validate-structure.sh | Yes |
| 10 | Baseline validator run: **16 skills, 55 PASS, 0 FAIL** — current state passes (memory #74178 and live confirmation) | `bash tests/test-skill-graph.sh` | Yes |
| 11 | Metadata variant test: rewrote `skills/reflect/SKILL.md` with `metadata: { prev-skill: any, next-skill: none }` in a sandbox → **2 FAIL** ("missing prev-skill in frontmatter", "missing next-skill in frontmatter") | Hands-on sandbox run — see §Audit Results | Yes |

### Comparison Matrix — Three Migration Options

| Criterion | A. Keep as-is (status quo) | B. Full migrate to `metadata.*` | C. Hybrid (duplicate in top-level + metadata) |
|---|---|---|---|
| **Cross-agent portability** | ❌ Only Claude Code parses our custom fields | ⚠️ Other tools discover skills via `name`/`description` but ignore chain logic ([Finding #4, #5](#findings)) | ⚠️ Same as B — metadata.* is ignored by other tools ([Finding #4](#findings)) |
| **7-step workflow chain enforcement** | ✅ Full enforcement via DAG validator (55 PASS) | ❌ Requires rewriting 3 validators to parse nested YAML in bash ([Finding #8, #9](#findings)) | ✅ Top-level fields preserved — existing validators unchanged |
| **agentskills.io spec compliance** | ❌ 4 non-compliant fields: `prev-skill`, `next-skill`, `user-invocable`, `argument-hint`; plus `allowed-tools` array-vs-string mismatch ([Finding #3](#findings)) | ✅ Fully compliant (after `allowed-tools` format fix) | ❌ Still non-compliant — custom fields remain at top level |
| **Migration effort** | 0 (none) | HIGH: 16 skills × frontmatter rewrite + 3 validator rewrites + DAG logic re-implementation in bash for nested YAML | MEDIUM: 16 skills × add 2 duplicated lines + `allowed-tools` format decision |
| **Maintenance burden** | LOW (current baseline) | MEDIUM: nested YAML parsing in pure bash is fragile; no existing bash YAML tool in repo | MEDIUM-HIGH: dual-source drift risk — top-level and metadata.* can diverge silently |
| **User value delivered** | Workflow discipline for Claude Code users (full) | Same workflow value for Claude Code users + **individual skills (not chain) discoverable in other tools** | Same as B |
| **Rollback cost if wrong** | N/A | HIGH: 16 files + 3 validators touched | MEDIUM: revert duplicated metadata lines |

**Winner**: **A (Keep as-is)** — Options B and C pay real cost (rewrite, drift risk) for **zero chain-enforcement benefit** in other tools. See Key Insight below.

### Audit Results — Current Frontmatter vs agentskills.io Spec

| Field used in our 16 skills | agentskills.io status | Our value | Spec compliance | File reference |
|---|---|---|---|---|
| `name` | Core, required | e.g. `reflect` | ✅ | `skills/*/SKILL.md:2` |
| `description` | Core, required | multi-line `>` block | ✅ | `skills/*/SKILL.md:3-5` |
| `user-invocable` | VS Code extension — not in core spec | `true` | ⚠️ Partial (VS Code-compatible only) | `skills/*/SKILL.md:6` |
| `argument-hint` | VS Code extension — not in core spec | e.g. `"[task]"` | ⚠️ Partial | `skills/*/SKILL.md:7` |
| `allowed-tools` | Core, experimental — **space-separated string** per spec | YAML array `["Read", "Glob"]` | ❌ Format mismatch (Finding #3, #7) | `skills/*/SKILL.md:8-9` |
| `prev-skill` | **Not in spec** — custom | e.g. `breakdown` / `any` / `none` | ❌ Non-standard | `skills/*/SKILL.md:9-10` |
| `next-skill` | **Not in spec** — custom | e.g. `review-ai` / `any` / `none` | ❌ Non-standard | `skills/*/SKILL.md:10-11` |

**Hands-on test (Finding #11)** — metadata variant sandbox run:

```
$ cp -r skills "$TMPDIR/"
$ cat > "$TMPDIR/skills/reflect/SKILL.md" <<EOF
---
name: reflect
description: test variant
user-invocable: true
allowed-tools: ["Read","Glob","Grep","Write"]
metadata:
  prev-skill: any
  next-skill: none
---
EOF
$ cd "$TMPDIR" && bash test-skill-graph.sh

  FAIL: reflect: missing prev-skill in frontmatter
  FAIL: reflect: missing next-skill in frontmatter
=== Summary ===
Skills: 16
FAIL: 2
RESULT: FAILED (2 errors)
```

The validator's line-anchored regex (`^prev-skill:`) cannot reach indented nested fields under `metadata:`. A migration would require either (a) a bash YAML parser, (b) a Python/Node helper script, or (c) coupling the validator to a specific YAML indent level — all options increase fragility.

### Constraints Identified

- **C1**: The 7-step workflow chain is the plugin's primary value proposition ([CLAUDE.md §"Skills → Habits Mapping"](../CLAUDE.md#skills--habits-mapping)). Any migration that weakens chain enforcement degrades the core value.
- **C2**: The repo intentionally has no build system, no dependencies — "the entire plugin is structured markdown files that Claude Code loads at runtime" ([CLAUDE.md §"What This Is"](../CLAUDE.md#what-this-is)). Adding a YAML parser or Python tool to support nested-metadata validation would violate this constraint.
- **C3**: No tool outside Claude Code currently parses `metadata.*` for workflow chaining ([Finding #4, #5](#findings) — confirmed in VS Code docs and Gemini CLI docs; Cursor inferred). This is the [Key Limitation](https://github.com/pitimon/8-habit-ai-dev/issues/91) already identified in Issue #91's Validation Gate.
- **C4**: `allowed-tools` format incompatibility is a separate spec-compliance issue that applies to *any* option where spec compliance matters — not a reason to pick B or C over A.

### Source Verification Report (Deep Mode)

| Source | Type | Status | Notes |
|---|---|---|---|
| [agentskills.io/specification](https://agentskills.io/specification) | web (official spec) | Verified | Fetched, extracted full frontmatter table + `metadata`/`allowed-tools` rules verbatim |
| [code.visualstudio.com/docs/copilot/customization/agent-skills](https://code.visualstudio.com/docs/copilot/customization/agent-skills) | web (official docs) | Verified | Fetched; confirmed no custom metadata parsing, no chain mechanism |
| [geminicli.com/docs/cli/skills](https://geminicli.com/docs/cli/skills/) | web (official docs) | Partial — page returned a generic skills intro without frontmatter detail | Supplemented via WebSearch to [geminicli.com/docs/cli/creating-skills](https://geminicli.com/docs/cli/creating-skills/) which confirmed name/description are the only parsed fields |
| [cursor.com/docs/context/skills](https://cursor.com/docs/context/skills) | web (official docs) | **Unverified — HTTP 429 on 3 retries** | Inference used: Cursor = VS Code fork, likely same parsing; treat as weak evidence |
| `tests/test-skill-graph.sh` | codebase | Verified (verifier agent adjusted line numbers) | Read in full (193 lines); chain-edge extraction regex at lines 36-37 |
| `tests/validate-structure.sh` | codebase | Verified | Grep'd all checks touching `prev-skill`/`next-skill`/`allowed-tools` — lines 17, 37, 115-131, 143-144, 157-161, 212-241 |
| `tests/validate-content.sh` | codebase | Verified (verifier agent adjusted line numbers) | Grep confirmed lines 466 (prev-skill check), 553-554 (frontmatter comment), 613-615 (user-invocable check) |
| Hands-on sandbox test | empirical | Verified | Sandbox ran to completion; output captured in §Audit Results |
| Memory obs #74178 (443/443 validator checks pass) | memory | Verified | Cross-referenced with live `bash tests/test-skill-graph.sh` run today |

**Unverified items flagged**: Finding #6 (Cursor) is an inference, not verified. The recommendation does not hinge on Cursor-specific details — Cursor's behavior does not change the conclusion because even *if* Cursor supports nested metadata (which would be unusual), VS Code and Gemini CLI confirmed do not, and VS Code has the largest installed base among agentskills.io consumers.

### Key Insight

**Migration would not deliver what it appears to promise.** The stated goal — "cross-agent portability" — is only partially achievable: other tools would discover our individual skills (e.g. `/research`, `/review-ai`) but **would not enforce the 7-step chain** because no tool outside Claude Code parses `metadata.prev-skill`/`metadata.next-skill`. The chain is 8-habit-ai-dev's primary value. Migrating trades a real chain-enforcement mechanism for a convention documented in prose — a net loss.

### Recommendation

**NO-GO on migration** (both Option B full-migrate and Option C hybrid). Keep Option A (status quo) for v2.6.0.

**Rationale**:

1. The core value of 8-habit-ai-dev is workflow **discipline** enforced by the DAG validator. Options B and C degrade that enforcement (B removes it; C duplicates and risks drift).
2. Migration yields no chain-enforcement improvement in any other agent — only individual-skill discoverability, which is a much smaller value than chain enforcement (Finding #4, #5, Constraint C3).
3. Migration violates the repo's "no build system, no dependencies" design principle by forcing a YAML parser into pure-bash validators (Constraint C2).
4. Migration cost is non-trivial: 16 skills + 3 validators + documentation + testing + release coordination. The cost-benefit ratio is unfavorable.
5. The one legitimate spec-compliance concern — `allowed-tools` array-vs-string format — can be addressed **independently** of this decision (see §Future Triggers).

### Future Triggers — When to Revisit This Decision

Revisit this evaluation if **any** of the following occurs:

- ✅ **agentskills.io spec adds native chain/workflow support**: If a future spec version defines `prev-skill`, `next-skill`, `workflow`, or `dependencies` as first-class fields, migration becomes worthwhile. Watch the [agentskills.io/specification](https://agentskills.io/specification) changelog.
- ✅ **An adopting tool parses `metadata.*` for workflow logic**: If Cursor, VS Code, Gemini CLI, or another major tool documents support for `metadata.prev-skill`/`metadata.next-skill` parsing, re-run the cost-benefit analysis. Currently no tool does (Finding #4, #5).
- ✅ **User demand for cross-agent use becomes concrete**: If multiple users request running 8-habit skills in non-Claude-Code environments, consider a **dual-artifact strategy** (separate repo): publish standalone versions of individual skills (no chain) to agentskills.io registries, while keeping this plugin as the chained workflow for Claude Code. This avoids compromising either use case.
- ✅ **The DAG validator is rewritten in a proper language**: If the repo ever introduces a Node/Python/Go validator as part of a larger refactor, the cost of nested-YAML parsing drops to near-zero, which changes the Option B calculation.

### Separately Actionable — `allowed-tools` Format

Independent of the migration decision, our `allowed-tools: ["Read", "Glob", "Grep"]` array format does not match the spec's `allowed-tools: Read Glob Grep` space-separated string format. This is a standalone spec-compliance issue. Recommended handling:

- **Not in scope for #91** (which is migration evaluation, not format cleanup)
- **Open as a separate issue** if spec compliance of individual fields matters to the maintainer
- **Do not fix as a side-effect of #91** — keeping scope tight (H3: Put First Things First)

---

## Definition of Done Checklist

- [x] Research depth level selected and documented (Deep + Compare)
- [x] Research questions defined before searching (6 questions)
- [x] At least 2 sources consulted (4 web + 3 codebase + 1 empirical test)
- [x] Every finding cites its source (11 findings, all with citations)
- [x] All sources verified where possible — 1 flagged as unverified (Cursor due to rate limit)
- [x] Constraints documented with source (C1-C4)
- [x] Comparison matrix with at least 3 criteria (Matrix has 7 criteria × 3 options)
- [x] Audit results with file/line references for every code claim
- [x] Source Verification Report included (Deep mode requirement)
- [x] Hands-on test executed (metadata variant sandbox run)
- [x] Key insight stated in 1-2 sentences
- [x] Go/no-go recommendation with cited rationale
- [x] Future triggers documented (when to revisit)

## H5 Checkpoint

> "Have I understood the problem space before defining what to build?"

**Yes**. The evaluation distinguishes between what migration *appears* to promise (cross-agent portability) and what it actually delivers (individual-skill discoverability without chain enforcement). The key limitation was identified through spec-level reading plus an empirical sandbox test, not assumption.
