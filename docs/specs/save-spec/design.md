---
feature: save-spec
step: design
created: 2026-05-17T20:55:00+07:00
updated: 2026-05-17T20:55:00+07:00
source-issue: 199
source-skill-version: 2.15.9
---

# Design: `/save-spec` skill — Phase 1 minimum viable

Architecture decisions for the 16 FRs in `prd.md`. Each decision answers HOW for one or more FRs. Sticky decisions are flagged explicitly.

## Existing architecture surveyed

- `guides/spec-digest-pattern.md` (templates, recipe stanza, verification commands) — design must preserve verbatim alignment
- `guides/persistence-convention.md:71-77` (3-part error message format), `:108-109` (user-owned-file frontmatter exemption)
- `docs/adr/ADR-013-spec-persistence-opt-in.md` + 2026-05-17 addendum (`/save-spec` is user-invoked write — outside the rejection scope of Alt-4)
- `skills/security-check/SKILL.md` (standalone skill frontmatter precedent: `prev-skill: any`, `next-skill: any`)
- `skills/reflect/SKILL.md` (user-invoked Write precedent; lesson-write pattern with `AskUserQuestion` flow)
- `skills/requirements/SKILL.md:8` (confirmed `AskUserQuestion` belongs in `allowed-tools` explicitly)

## Scope validation against PRD

- All decisions below stay within PRD `scope_in` (Phase 1 generator-only, project-root only, no SKILL_OUTPUT, no CLAUDE.md modification)
- Success criteria S1–S5 are achievable with the proposed design (S1 verification commands ↔ Decision-7 template; S2 refuse path ↔ Decision-3; S3 `allowed-tools` array ↔ Decision-8; S4 validators ↔ Decision-7 + Decision-10; S5 RESOLVER three rows ↔ deferred to `/breakdown`)
- All three R-risks have explicit mitigations addressed by Decisions 1, 2, and 6

## Article 14 checkpoint

**Skip — not an AI system.** `/save-spec` is a workflow skill that scaffolds a markdown file via deterministic template substitution + user interaction. No model output, no automated decision-making. The 5-capability table does not apply.

## Decisions

### Decision-1: Interactive flow batching strategy

**Decision-1 covers**: FR-005, FR-007, FR-008, R3 (8-prompt heaviness)

**Option A — 8 sequential prompts**: 1 project name + 1 §1 multi-select + 3 §2 free-text + 3 §3 free-text. **Pro**: simplest mental model, one input per question. **Con**: heavy in best case, fails R3 mitigation.

**Option B — 4 prompts with comma-separated free-text**: 1 project name + 1 §1 multi-select + 1 §2 combined (`AskUserQuestion` options: `[skip, provide decisions]`, "Other" free-text takes the comma-separated list) + 1 §3 combined (same shape). **Pro**: matches `AskUserQuestion` API capability; same prompt count in skip and provide cases. **Con**: user must format their answer (commas).

**Option C — 6 prompts with explicit count gate**: 1 project + 1 §1 + 1 "how many §2 decisions? (0/1/2/3)" + up-to-3 follow-ups + 1 "how many §3 items? (0/1/2/3)" + up-to-3 follow-ups. **Pro**: granular control. **Con**: variable prompt count is jarring; the count gate adds friction even in skip case.

**Recommendation**: **Option B — 4 prompts with comma-separated free-text**. R3 mitigation is real, and `AskUserQuestion`'s "Other" field naturally takes free-text. The "comma-separated" parsing instruction goes into the prompt question itself, so the user is not surprised.

**Sticky classification**: **Semi-sticky (~30% rework)** — changing this affects the entire Process section of SKILL.md and the reference.md examples. Cite in tests so structural-check pins this.

### Decision-2: "Skip" detection in free-text input

**Decision-2 covers**: FR-007, FR-008 (mid-decision skip handling)

**Option A — string match "skip" (case-insensitive)** on the free-text input. **Pro**: simple; user types the option literally.

**Option B — explicit `AskUserQuestion` option + free-text fallback**: present options `[skip / provide]` with `multiSelect: false`; if the user picks `skip`, no further parsing; if they pick `provide` they get a follow-up free-text via "Other". **Pro**: idiomatic to the API; explicit affordance for the skip case. **Con**: two-step UX for the provide case.

**Option C — combined**: present options `[skip / provide]` BUT also treat "Other"-typed free-text equal to `skip` (case-insensitive empty / "skip" / "no" / "none") as skip. **Pro**: maximally robust — user can either click `skip` OR type free-text starting with "skip"/"none"/empty. **Con**: slightly more parsing logic in SKILL.md Process.

**Recommendation**: **Option C — combined**. Costs ~3 lines of skip-detection logic in the Process section; saves the user from a frustrating "I clicked Other and typed 'skip' and the skill still asked for content" failure mode.

**Skip sentinels** (exact list to be documented in `reference.md`):

- Literal option selection: `skip`
- Free-text starts with (case-insensitive): `skip`, `none`, `nothing`, `n/a`, empty/whitespace-only string

**Sticky classification**: **Flexible (<10% rework)** — single parsing rule, isolated to one Process step.

### Decision-3: Refuse-on-existing message wording (exact text)

**Decision-3 covers**: FR-003 (refuse on existing SPEC.md)

**Option A — Terse one-liner**: `"SPEC.md exists. Edit manually."`. **Con**: violates H4 (Win-Win — error messages should help the next person, not just deny).

**Option B — Verbose with rationale + next steps + no-modification affirmation**. **Pro**: tells the user WHAT happened, WHY (Phase 1 design intent), WHAT they can do, CONFIRMS nothing changed. Matches the `guides/persistence-convention.md:71-77` 3-part principle.

**Option C — Verbose with link to Phase 2 issue**. Same as B plus a hyperlink to issue #199 / future Phase-2 issue. **Con**: hardcoded issue numbers age poorly.

**Recommendation**: **Option B**. Exact wording (canonical — cite in tests):

```
SPEC.md already exists at <absolute-path>.

Phase 1 of /save-spec is generator-only — it deliberately refuses to overwrite an
existing file. To update SPEC.md:

  1. Edit it directly. The CLAUDE.md auto-update recipe (from
     guides/spec-digest-pattern.md) handles ongoing updates without re-invoking
     this skill.
  2. Wait for the Phase 2 --update flag, which will refresh §4 (Current state)
     in place. Tracked in the project-orientation discussion.

No changes were made.
```

Substitution: `<absolute-path>` becomes the actual full path at runtime.

**Sticky classification**: **Semi-sticky (~20% rework)** — string is cited by test assertions (Decision-10) but appears in exactly one location in SKILL.md Process step 1.

### Decision-4: 3-part Write-failure error message wording (exact text)

**Decision-4 covers**: FR-012 (Write failure handling)

**Option A — One-line concatenated**: `"Tried to create SPEC.md at <path>. Failed: <error>. Next: <action>."`. **Con**: less scannable for ops engineers.

**Option B — 3-line numbered**: matches the spirit of `guides/persistence-convention.md:71-77`. **Pro**: scannable, follows the established plugin convention.

**Recommendation**: **Option B**. Exact template (string for tests):

```
Tried to create SPEC.md at <absolute-path>.

Failed: <error-class> — <error-message>.

Next: <suggested-action>. Typical fixes are: check write permissions on the
parent directory (chmod / ls -la), confirm the working directory is the
intended project root (pwd), or change to a writable directory and re-run
/save-spec.
```

Substitutions:

- `<absolute-path>` — full path that failed
- `<error-class>` — e.g. `EACCES`, `ENOSPC`, `EROFS`
- `<error-message>` — the underlying error string
- `<suggested-action>` — context-specific hint (the Typical fixes line follows always)

**Sticky classification**: **Flexible (<10% rework)** — single template, no cross-file ripple.

### Decision-5: §4 timestamp format

**Decision-5 covers**: FR-009 (§4 Last updated line)

**Option A — UTC only** (`2026-05-17T13:44:23Z`). **Pro**: unambiguous globally. **Con**: requires mental conversion when reading; users post-`/clear` are not in audit context.

**Option B — Local with timezone offset** (`2026-05-17T20:44:23+07:00`). **Pro**: humans reading their own save-point file see their own time; the offset preserves auditability. Netbox-sit's SPEC.md uses this format (verified). **Con**: timezone-dependent — multiple maintainers in different zones see different strings.

**Option C — Both** (UTC line + local line). **Con**: clutter; doubles the timestamp surface area for no clear gain.

**Option D — Date only** (`2026-05-17`). **Con**: loses intra-day granularity; "what changed since my last `/clear` 2h ago?" becomes unanswerable.

**Recommendation**: **Option B — Local with timezone offset**. Matches the empirical netbox-sit precedent; readable in context; preserves auditability via offset. Multi-maintainer concern is real but minor — the canonical record lives in CHANGELOG/git log, not the §4 line.

Exact format string (POSIX `date` equivalent): `date +%Y-%m-%dT%H:%M:%S%z` → `2026-05-17T20:44:23+0700`. ISO 8601 strict variant inserts colon: `2026-05-17T20:44:23+07:00`. **Use the strict variant** (RFC 3339 compatible) — emit colon between hours and minutes of the offset.

**Sticky classification**: **Flexible** — single format string in one Process step.

### Decision-6: Glob detection casing + match strategy

**Decision-6 covers**: FR-004, R2 (auto-detect false-positive mitigation)

**Option A — Case-sensitive exact match** for the 5 canonical names (`PLAYBOOK.md`, `CONTRACTS.md`, `LESSONS.md`, `CHANGELOG.md`, `README.md`). **Pro**: predictable; matches conventional uppercase-stem naming; reduces false positives.

**Option B — Case-insensitive** (`readme.md`, `Readme.md`, `README.md` all match). **Pro**: friendlier on macOS / Windows where filesystems are case-insensitive anyway. **Con**: on Linux this opens false positives (a project might intentionally have a separate `Lessons.md` that is not the canonical lessons file).

**Option C — Exact match + common variants** (`README.md` AND `Readme.md` AND `readme.md` as 3 separate checks per name). **Con**: explosion of glob patterns; brittle.

**Recommendation**: **Option A — case-sensitive exact match**. The 5 filenames have established uppercase-stem conventions (project README, CHANGELOG, etc.). Users with non-canonical naming can edit §1 after the skill writes — the file is theirs.

Glob pattern (`Glob` tool): one call per filename, OR if the tool supports brace expansion in patterns, one call with `{PLAYBOOK,CONTRACTS,LESSONS,CHANGELOG,README}.md`. The implementation uses whichever is supported — both produce the same set. **The set of 5 names IS the contract**; the call mechanics are flexible.

**Sticky classification**: **Flexible** — the names are listed in the SKILL.md Process step.

### Decision-7: SKILL.md body structure — Process is the runtime contract

**Decision-7 covers**: All 16 FRs collectively (this IS the runtime — skills are read-only guidance, so the Process section IS the architecture)

**Body pattern** (per `CLAUDE.md` "Skill Authoring Conventions"):

```
1. Habit mapping → 2. Process steps → 3. Handoff → 4. When to Skip
→ 5. Definition of Done → 6. H* Checkpoint → 7. Load directive
```

**Process section structure** (canonical — pins the FR mapping):

```markdown
## Process

1. **Pre-flight** (FR-002, FR-003) — Check whether `SPEC.md` exists at the project root.
   If it does, emit the Decision-3 refusal message and STOP. Do NOT call `Write` in this branch.

2. **Detect pointer-target files** (FR-004) — `Glob` the project root for the 5 canonical
   filenames (Decision-6, case-sensitive): `PLAYBOOK.md`, `CONTRACTS.md`, `LESSONS.md`,
   `CHANGELOG.md`, `README.md`. Collect the set of files that exist.

3. **Gather user input** (FR-005, FR-006, FR-007, FR-008, FR-016) — 4 prompts max
   per Decision-1:
   - Q1 (skip if positional arg supplied): project name (free-text)
   - Q2: §1 multi-select on glob results, default = all
   - Q3: §2 decisions, options `[skip, provide]`, free-text takes comma-separated list
   - Q4: §3 backlog items, options `[skip, provide]`, free-text takes comma-separated list

4. **Parse user input** (Decision-2 skip detection):
   - Project name: literal text
   - §1 selection: list of confirmed filenames
   - §2 / §3 input: skip-sentinels (Decision-2) → empty list; otherwise split free-text on
     `,` or `;`, trim whitespace, take ≤ 3 items.

5. **Construct SPEC.md content** (FR-009, FR-010) — fill the template from `reference.md`:
   - Header gets project name (Decision-6 substitution)
   - §1 = one bullet per confirmed pointer; empty → single template-stub bullet
   - §2 = one row per parsed decision; empty → single template-stub row
   - §3 = one `[ ]` bullet per parsed item; empty → single `[ ] <Active backlog item>` stub
   - §4 = `Last updated: <Decision-5 timestamp>`, "What's happening now" placeholder,
     "Stuck / waiting on: nothing", "Next session entry point" code block

6. **Write SPEC.md** (FR-010, FR-012) — `Write` tool, absolute path `<cwd>/SPEC.md`,
   NO YAML frontmatter (user-owned-file exemption per `persistence-convention.md:108-109`).
   On Write failure, emit the Decision-4 3-part error message and STOP.

7. **Emit CLAUDE.md recipe stanza** (FR-011, FR-014, FR-015) — print the one-line hint
   followed by the recipe stanza from `guides/spec-digest-pattern.md:106-112` in a fenced
   markdown code block. DO NOT invoke `Edit` or `Write` against `CLAUDE.md`.

8. **Confirm completion** — print a single-line summary:
   `Created SPEC.md at <path> with N pointer(s) in §1, M decision(s) in §2, K backlog item(s) in §3.`
```

This Process section literally IS the runtime contract. Each step is referenced by FR ID.

**Sticky classification**: **STICKY — >50% rework**. Changing this step structure invalidates the FR mapping, the test assertions, the reference.md examples, and the 8-habit-reviewer scope. Mid-implementation changes require a new `/design` cycle.

### Decision-8: Skill frontmatter

**Decision-8 covers**: FR-001 (allowed-tools); standalone-skill discovery

**Final frontmatter** (commit this as the canonical contract):

```yaml
---
name: save-spec
description: >
  Scaffold a project-root SPEC.md digest following the spec-digest-pattern
  archetype. User-invoked. Phase 1 minimum viable — generator only;
  refuses to overwrite an existing SPEC.md. Use AFTER deciding the repo
  fits the project-orientation hub deployment mode (not feature-spec mode).
  Maps to H8 (Find Your Voice — pick the deployment mode that fits your repo)
  + H2 (Begin with End in Mind — establish the save point on day 1).
user-invocable: true
argument-hint: "[project-name]"
allowed-tools: ["Read", "Write", "Glob", "AskUserQuestion"]
prev-skill: any
next-skill: any
---
```

Justification per field:

- `argument-hint: "[project-name]"` — positional arg only per Decision-1 (no flags in Phase 1)
- `allowed-tools` excludes `Bash` (Decision-5 timestamp can use date stub at template-fill time; no shell invocation needed) and excludes `Edit` (FR-015)
- `allowed-tools` **drops `Grep`** from the PRD draft list — no Process step performs content search. `Glob` covers Decision-6 filename detection; everything else is template substitution or file write. Documented here so the PRD-implementation drift identified by the 8-habit-reviewer doesn't recur on Phase 2 enhancements.
- `prev-skill: any` / `next-skill: any` — standalone (matches `/whole-person-check`, `/security-check`, `/reflect`)

**Sticky classification**: **Semi-sticky (~25% rework)** — adding tools later requires re-justification; removing tools later requires Process step rewrite. But the initial contract is small and well-defined.

### Decision-9: `reference.md` contents

**Decision-9 covers**: All FRs collectively (canonical artifacts used by the runtime + tests)

**Contents** (final):

1. Full SPEC.md output template (verbatim from `guides/spec-digest-pattern.md:39-99`, but with placeholder substitution markers for project name, §1 bullets, §2 rows, §3 bullets, §4 timestamp)
2. Decision-3 refusal message (verbatim text from this design)
3. Decision-4 3-part error message template (verbatim with substitution markers)
4. Skip-sentinels list (from Decision-2)
5. Glob pattern set (from Decision-6)
6. Examples of parsed user inputs → generated §2 rows and §3 bullets (3–5 examples each, including edge cases: 0 items, 1 item, 3+ items truncated to 3, leading/trailing whitespace, comma-vs-semicolon delimiter)
7. Rationale links: cross-reference issue #199 open-question defaults (Q1–Q6 from the design discussion)

**Sticky classification**: **Flexible** — examples evolve as Phase 1 ships; canonical strings (refusal, error) are pinned by Decision-3 and Decision-4.

### Decision-10: Test assertions for `tests/validate-structure.sh`

**Decision-10 covers**: PRD Success criteria S3 + S4 + S5

A new validator Check shall pin the canonical strings + structural invariants of `/save-spec`:

- Frontmatter `name == save-spec`
- Frontmatter `user-invocable == true`
- Frontmatter `allowed-tools` array equals exactly `["Read", "Write", "Glob", "AskUserQuestion"]`
- Frontmatter `prev-skill == any` and `next-skill == any`
- Process section contains exactly 8 numbered steps (Decision-7)
- SKILL.md body contains the literal Decision-3 first-line phrase (`SPEC.md already exists at`) — pins the refusal message
- SKILL.md body contains the literal Decision-4 first-line phrase (`Tried to create SPEC.md at`) — pins the error message
- `reference.md` exists and contains at least one occurrence of `Skip-sentinels:` (pins Decision-2 documentation presence)
- `RESOLVER.md` contains exactly 3 trigger phrases pointing to `skills/save-spec/SKILL.md` (Check 20 already enforces bidirectional invariant — new rows must trip the check accordingly)

**Sticky classification**: **Flexible** — implementation detail of the structural validator; can evolve.

## Constraints (non-negotiable)

- C1: `/save-spec` shall NEVER write outside the project root (no `docs/specs/`, no `~/.claude/`, no system paths). Path resolution uses `<cwd>` only.
- C2: `/save-spec` shall NEVER invoke `Edit` (FR-015) — single `Write` only.
- C3: `/save-spec` shall produce a `SPEC.md` that passes the 5 verification commands from `guides/spec-digest-pattern.md:154-176` (Success criterion S1).
- C4: All Decisions above shall be cited verbatim in `reference.md` so future contributors can trace runtime behavior to design intent.

## ADRs

No new ADR required. This skill is Phase 1 of a tracked promotion (issue #199) and operates within ADR-013's already-recorded scope (user-invoked write is outside Alt-4's auto-write rejection). The 2026-05-17 addendum to ADR-013 anticipates this skill explicitly.

If Phase 2 (`--update` flag) requires re-opening the scope question (e.g. for multi-mode repos), THAT phase will produce a new ADR.

## Sticky decisions summary

| Sticky # | Decision                              | Rework cost       | Reason                                                                                                                       |
| -------- | ------------------------------------- | ----------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| S1       | Decision-7: Process section structure | **STICKY** (>50%) | All FRs map to specific Process steps; changing the structure invalidates the FR-test mapping and forces a new /design cycle |

Two Semi-sticky decisions (Decision-1 interactive batching, Decision-3 refusal wording, Decision-8 frontmatter) are flagged in their respective sections; rework is bounded.

[/design] COMPLETE SKILL_OUTPUT:design

<!-- SKILL_OUTPUT:design
decision_count: 10
decisions:
  - "Decision-1: 4-prompt interactive flow with comma-separated free-text (covers FR-005, FR-007, FR-008, R3)"
  - "Decision-2: Skip-sentinels combined approach — explicit option + free-text fallback (FR-007, FR-008)"
  - "Decision-3: Refuse-on-existing message verbose with rationale + next steps + no-modification affirmation (FR-003)"
  - "Decision-4: Write-failure 3-line numbered error matching persistence-convention.md:71-77 spirit (FR-012)"
  - "Decision-5: §4 timestamp local with timezone offset (RFC 3339 strict variant) (FR-009)"
  - "Decision-6: Glob case-sensitive exact match for 5 canonical names (FR-004)"
  - "Decision-7: 8-step Process section IS the runtime contract; pin via Decision-10 validator (all FRs)"
  - "Decision-8: Frontmatter — allowed-tools=[Read,Write,Glob,AskUserQuestion]; argument-hint=[project-name]; prev/next: any"
  - "Decision-9: reference.md contents — template + canonical strings + examples + rationale links"
  - "Decision-10: New validate-structure.sh Check pinning frontmatter array, 8-step Process count, canonical phrases"
sticky_decisions:
  - "Decision-7: 8-step Process structure — STICKY >50% rework, invalidates FR mapping if changed mid-implementation"
constraints:
  - "C1: Never write outside project root"
  - "C2: Never invoke Edit"
  - "C3: Output passes 5 verification commands from spec-digest-pattern.md"
  - "C4: All Decisions cited verbatim in reference.md"
adr_references:
  - "ADR-013 + 2026-05-17 addendum (user-invoked write outside Alt-4 rejection scope)"
article_14_applicable: false
article_14_pass: n/a
END_SKILL_OUTPUT -->
