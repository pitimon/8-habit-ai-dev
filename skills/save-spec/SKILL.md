---
name: save-spec
description: >
  Scaffold a project-root SPEC.md digest following the spec-digest-pattern archetype.
  User-invoked. Phase 1 minimum viable — generator only; refuses to overwrite an
  existing SPEC.md. Use AFTER deciding the repo fits the project-orientation hub
  deployment mode (not feature-spec mode).
  Maps to H8 (Find Your Voice — pick the deployment mode that fits your repo)
  + H2 (Begin with End in Mind — establish the save point on day 1).
user-invocable: true
argument-hint: "[project-name] [target-dir]"
allowed-tools: ["Read", "Write", "Glob", "AskUserQuestion"]
disable-model-invocation: true
prev-skill: any
next-skill: any
---

# Scaffold Project SPEC.md (`/save-spec`)

**Habits**: H8 (Find Your Voice — pick the deployment mode that fits your repo) + H2 (Begin with End in Mind — establish the save point on day 1) | **Anti-pattern**: Copying the SPEC.md template by hand every time you start a new operational repo, then forgetting to fill the timestamp.

## When to Use

- The repo fits the **project-orientation hub mode** (operational / infra / integration / single-system) — not the per-feature `--persist <slug>` mode.
- You want a one-page digest at the project root that points to project-specific detail files and acts as the read-first save point after `/clear` or `/compact`.
- No `SPEC.md` exists yet at the project root.
- See `guides/spec-digest-pattern.md` for the full pattern. This skill scaffolds the file; the discipline of maintaining it is yours.

## When to Skip

- Repo uses the **feature-spec mode** (`docs/specs/<slug>/{prd,design,tasks,current-state}.md`). Use `/requirements --persist`, `/design --persist`, `/breakdown --persist` instead.
- `SPEC.md` already exists at the project root — Phase 1 is generator-only; edit it manually or wait for Phase 2 `--update`.
- One-off scripts / single-file repos where a digest adds no value.
- **Memory-MCP already active** (`claude-mem`, `memforge`, or equivalent with SessionStart context injection) AND your existing `CLAUDE.md` is short enough to scan in <30 seconds (a ~150-line threshold is a reasonable rule of thumb). In that combination, §1 (architecture) is already covered by `CLAUDE.md`'s top section and §4 (Current state save-point) is already covered by the memory-MCP's chronological injection — more faithfully than a human-curated §4, because the memory layer captures what _actually happened_ in the last session, not what the operator remembered to write down. §4 is the only section providing net value over what you already have; consider writing a short `## Current state` section directly into `CLAUDE.md` instead of scaffolding a separate file. (Surfaced by Adopter #2's third-repo dogfood — issue [#207](https://github.com/pitimon/8-habit-ai-dev/issues/207). The skill's H8 Checkpoint already acknowledges "the value depends on the user's habit of updating it" — this skip entry extends that honesty to the upstream question of whether the scaffold is worth maintaining at all.)

### Suite positioning (not a workflow step)

`/save-spec` is a **deployment-mode helper** — orthogonal to the 7-step workflow (`/research` → `/requirements` → `/design` → `/breakdown` → `/build-brief` → `/review-ai` → `/deploy-guide` → `/monitor-setup`). It does not chain in/out of any workflow step (`prev-skill: any`, `next-skill: any`). Pick it when you've decided the repo fits the project-orientation hub deployment mode (see `guides/spec-digest-pattern.md`), independent of where you are in any feature-work cycle.

Skill-category-wise, it sits with `/calibrate` (writes `~/.claude/habit-profile.md`) and `/reflect` (writes `~/.claude/lessons/`) as a **state-write skill that runs on user demand**, NOT with assessment skills like `/cross-verify` or `/whole-person-check` that produce conversation-only output. (Suite-positioning clarification from Adopter #2's third-repo cross-verify — [#207](https://github.com/pitimon/8-habit-ai-dev/issues/207).)

## Process

The 8 steps below are the runtime contract — each step maps to specific FRs from `docs/specs/save-spec/prd.md`. Execute in order.

1. **Pre-flight** (FR-002, FR-003, FR-017) — Resolve the **target directory**: if the user supplied a second positional argument, that path is the target directory; otherwise the target is the current working directory. The target directory IS the "project root" for the rest of the Process (F2 — issue [#203](https://github.com/pitimon/8-habit-ai-dev/issues/203)).
   - **If a `[target-dir]` was supplied but the path does not exist or is not a directory** (FR-017): emit the **pre-flight error template** from `reference.md` (verbatim, substituting `<target-dir>` with the user's literal input) and **STOP**. Do **NOT** call `Write` or `Glob` in this branch. (Distinct register from the Decision-4 Write-failure template — R5-2 fix per issue [#205](https://github.com/pitimon/8-habit-ai-dev/issues/205).)
   - Check whether `SPEC.md` exists at `<target-dir>/SPEC.md`. If it exists: emit the **refusal message** from `reference.md` (verbatim, substituting `<absolute-path>` with the resolved `<target-dir>/SPEC.md`) and **STOP**. Do **NOT** call `Write` in this branch.
   - If `<target-dir>` is valid AND `SPEC.md` does not exist: proceed to step 2.

2. **Detect pointer-target files** (FR-004) — Use `Glob` on `<target-dir>` for the 5 canonical filenames (case-sensitive exact match): `PLAYBOOK.md`, `CONTRACTS.md`, `LESSONS.md`, `CHANGELOG.md`, `README.md`. Collect the set of files that exist. Empty match set is acceptable — proceed.

3. **Gather user input** (FR-005, FR-006, FR-007, FR-008, FR-016) — Ask the user **at most 4 questions** via `AskUserQuestion`:
   - **Q1 (skip if positional argument supplied to the skill)**: project name — free-text via the "Other" affordance, with two preset options (`current directory name`, `manual entry`)
   - **Q2**: §1 pointer confirmation — multi-select over the glob matches from step 2; default selection = all matches. Also accepts the "Other" free-text affordance with a newline-separated list of project-specific paths for repos using non-canonical naming (e.g. ops/infra repos with `server-state.md`, `runbooks/ops-runbook.md`, `playbooks/change-management.md`). If step 2 found nothing AND the user provides no Other entries, skip Q2 silently. (N3 — issue [#201](https://github.com/pitimon/8-habit-ai-dev/issues/201).)
   - **Q3**: §2 decisions to seed — options `[skip, provide]`. If the user picks `provide` they supply a comma-separated list via "Other" free-text (≤3 decisions; surplus truncated).
   - **Q4**: §3 backlog items to seed — same shape as Q3.

4. **Parse user input** — Apply these rules:
   - Project name: literal text from Q1 (or positional argument if supplied).
   - §1 selection: the list of confirmed filenames from Q2's multi-select. If Q2 also received "Other" free-text, split that text on newlines, trim each line, drop empty lines, and append each non-empty entry to the §1 list as a project-specific path (no `[ -e ]` runtime check — the skill cannot Bash; trust the adopter's input). Deduplicate against the multi-select picks (case-sensitive path match).
   - §2 / §3 input: treat as **skip** if the answer matches any skip-sentinel from `reference.md` (`skip`, `none`, `nothing`, `n/a`, empty/whitespace-only). Otherwise split free-text on `,` or `;`, trim each piece, take the first ≤3 non-empty items.

5. **Construct SPEC.md content** — Fill the template from `reference.md`:
   - Header `# SPEC.md — <project-name> save point` with the project name substituted.
   - §1 = one bullet per confirmed pointer (one path per bullet — required for the verification grep). Empty set → single template-stub bullet from `reference.md`.
   - §2 = one row per parsed decision, formatted as `| D<N> | <statement> | <rationale> | <source> |` with placeholder text where the user supplied a single string. Empty set → single template-stub row.
   - §3 = one `[ ] <item>` bullet per parsed item. Empty set → single template-stub bullet.
   - §4 = `**Last updated**: <ISO 8601 datetime with timezone offset>` (RFC 3339 strict, e.g. `2026-05-17T20:44:23+07:00`); `**Last apply / commit / deploy event**:` followed by an HTML-comment TODO marker; "What's happening now" body is an HTML-comment TODO marker; "Stuck / waiting on: nothing" default; "Next session entry point" code block with `cat SPEC.md` + comment; the trailing "Optional command sequence" line is an HTML comment. **No literal angle-bracket placeholders in the rendered output** (F1 fix — issue [#203](https://github.com/pitimon/8-habit-ai-dev/issues/203)). See `reference.md` template for exact wording.

6. **Write SPEC.md** (FR-010, FR-012) — Call `Write` with the absolute path `<target-dir>/SPEC.md` (per step 1's resolution; `<cwd>/SPEC.md` if no `[target-dir]` was supplied) and the assembled content. **Do NOT include YAML frontmatter** — `SPEC.md` is a user-owned file per `guides/persistence-convention.md:108-109` and is exempt from the frontmatter requirement.
   - If the `Write` fails: emit the **3-part error message** from `reference.md` (verbatim, with `<absolute-path>`, `<error-class>`, `<error-message>`, `<suggested-action>` substituted) and **STOP**. Do not retry.

7. **Emit CLAUDE.md recipe stanza** (FR-011, FR-014, FR-015) — After a successful `Write`, print to conversation (NOT to any file):
   - A one-line hint: "Copy this into your project's `CLAUDE.md` to auto-update `SPEC.md` after every task. The plugin does NOT modify your `CLAUDE.md` automatically."
   - The recipe stanza in a fenced markdown code block, copied verbatim from `guides/spec-digest-pattern.md` (the "CLAUDE.md auto-update rule (user-side)" section).
   - **Do NOT invoke `Edit` or `Write` against `CLAUDE.md`** — emission is conversation-only.

8. **Confirm completion** — Print exactly one summary line in this shape: `Created SPEC.md at <absolute-path> with N pointer(s) in §1, M decision(s) in §2, K backlog item(s) in §3.` `<absolute-path>` is the resolved write target from step 6 (target-dir or cwd). Use the actual counts. End the skill.

## Definition of Done

- [ ] `SPEC.md` exists at the project root with all four sections (§1 Architecture, §2 Decisions snapshot, §3 Live backlog, §4 Current state)
- [ ] §4 has a timestamped `Last updated` line in RFC 3339 format with timezone offset
- [ ] The output passes the 5 verification commands from `guides/spec-digest-pattern.md` (Verification section)
- [ ] No file other than `SPEC.md` was modified (CLAUDE.md, ADRs, detail files all untouched)
- [ ] The CLAUDE.md auto-update recipe stanza was emitted to conversation with the one-line hint
- [ ] If `SPEC.md` already existed at invocation: refusal message was emitted and no `Write` was attempted

## Handoff

- **Expects from predecessor**: A repo that has been judged to fit the project-orientation hub deployment mode (see `guides/spec-digest-pattern.md` "When to use the digest pattern"). The judgement itself is human — this skill does not assess archetype fit.
- **Produces for successor**: A bootstrapped `SPEC.md` ready for ongoing manual maintenance via the CLAUDE.md auto-update recipe. Standalone — no specific next-skill chain.

## H8 Checkpoint

"Did the user choose the deployment mode (project-orientation hub) consciously, not because the skill exists?" — `/save-spec` does not advocate for project-orientation mode; it only scaffolds when the user has decided that mode fits.

"Is the save point information the next session actually needs, or template noise?" — §4 lives or dies by user discipline. The scaffold gets the structure right; the value depends on the user's habit of updating it.

## Further Reading

Load `${CLAUDE_PLUGIN_ROOT}/skills/save-spec/reference.md` for the SPEC.md output template, canonical refusal and error messages, skip-sentinels list, glob filename set, parse examples, and rationale links to issue #199.
Load `${CLAUDE_PLUGIN_ROOT}/guides/spec-digest-pattern.md` for the full pattern documentation, including the CLAUDE.md auto-update recipe stanza that this skill emits in step 7.
Load `${CLAUDE_PLUGIN_ROOT}/habits/h8-find-voice.md` for the full H8 principle (deployment-mode choice is human; tools follow).
