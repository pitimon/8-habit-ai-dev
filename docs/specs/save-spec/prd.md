---
feature: save-spec
step: requirements
created: 2026-05-17T20:44:23+07:00
updated: 2026-05-17T20:44:23+07:00
source-issue: 199
source-skill-version: 2.15.9
---

# PRD: `/save-spec` skill — Phase 1 minimum viable

## Feature: `/save-spec`

**What**: User-invoked skill that scaffolds a project-root `SPEC.md` following the four-section archetype documented in `guides/spec-digest-pattern.md`. Generator-only — refuses to overwrite an existing file. Hybrid auto-detection: globs common pointer-target filenames, then asks the user to confirm; AskUserQuestion seeds project name and optional §2 / §3 entries; §4 gets a timestamped template-stub.

**Why**: All three promotion criteria from `guides/spec-digest-pattern.md:142-148` are met (n=2 adoption via netbox-sit + netbird-sit; adopter friction documented in #197 + `~/.claude/lessons/2026-05-17-spec-digest-pattern-v2-15-9.md`; scope question resolved by "two modes don't mix in the same repo" — formalized below). The skill removes the manual template-paste step that adopters currently perform, without violating ADR-013's no-auto-write boundary (skill is user-invoked, not hook-triggered).

**Who**: Maintainers and contributors of operational / infra / integration / single-system repos who adopt the **project-orientation hub** deployment mode (`SPEC.md` at root). Explicitly **NOT** users in the **feature-spec** mode (`docs/specs/<slug>/{prd,design,tasks,current-state}.md`) — they use `/requirements --persist`, `/design --persist`, `/breakdown --persist`. The two modes are disjoint per the scope-resolution statement below.

**In scope (Phase 1)**:

- Create `SPEC.md` at project root if absent
- Hybrid glob + user-confirm for §1 pointer-target detection (candidates: `PLAYBOOK.md`, `CONTRACTS.md`, `LESSONS.md`, `CHANGELOG.md`, `README.md`)
- AskUserQuestion to seed project name, ≤ 3 §2 decisions (optional), ≤ 3 §3 backlog items (optional)
- Timestamped `Last updated` line in §4
- Emit the CLAUDE.md auto-update recipe stanza to conversation with a copy-paste hint

**Out of scope (Phase 1)**:

- Updating an existing `SPEC.md` (deferred to Phase 2 `--update`)
- Writing to `docs/specs/<slug>/` (different deployment mode)
- Emitting a `SKILL_OUTPUT:save-spec` block (`SPEC.md` is not a `/cross-verify` or `/consistency-check` input)
- Modifying the project's `CLAUDE.md` (recipe stanza is conversation-only)
- Multi-mode repos (`SPEC.md` + `--persist <slug>` together — see scope-resolution below)
- Auto-detection of `docs/adr/ADR-*.md` for §2 ingestion (deferred — Phase 1 asks user for ≤ 3 free-text decisions)
- `--no-interactive` / batch mode (Phase 1 is interactive only)

**Scope resolution (closes promotion criterion 2)**:

The two deployment modes are **disjoint in practice**: a repo picks one based on archetype and does not mix them. Multi-mode repos (using `--persist <slug>` and a project-root `SPEC.md` together) are **out of scope for tooling** — `/consistency-check` operates on feature-spec artifacts only; `/save-spec` operates on the project-root `SPEC.md` only. Both adopters in the n=2 evidence base used project-orientation mode standalone (no observed need to mix). If a future repo legitimately needs both, the requirement re-opens this scope question — not a Phase 1 problem. Will be reflected in `guides/spec-digest-pattern.md` as part of the implementation phase.

**Success criteria**:

1. Running `/save-spec` in a clean repo (no existing `SPEC.md`) creates a valid `SPEC.md` that passes all five verification commands from `guides/spec-digest-pattern.md` Verification section (four-section header count = 4; save-point hint matched in §4; `Last updated` line present; backtick-path glob resolves with `OK` for matched files; bracket-paren glob is empty/clean).
2. Running `/save-spec` in a repo with an existing `SPEC.md` refuses without modifying any file and emits the documented stop-gap message.
3. The skill's `allowed-tools` array contains exactly `["Read", "Write", "Glob", "AskUserQuestion"]` — verified by `tests/validate-structure.sh` Check 23. (`Grep` was dropped in design — no Process step performs content search; see design Decision-8.)
4. After the skill is added, both validators pass: `validate-structure.sh` 256+ PASS / 0 FAIL and `validate-content.sh` 0 FAIL.
5. RESOLVER.md gains exactly 3 trigger-phrase rows pointing to `skills/save-spec/SKILL.md` per the `≤3 trigger phrases per skill` Check 20 invariant.

**Definition of Done**:

- [ ] `skills/save-spec/SKILL.md` exists with valid frontmatter (`name`, `description`, `user-invocable: true`, `argument-hint`, `allowed-tools`, `prev-skill: any`, `next-skill: any`)
- [ ] `skills/save-spec/reference.md` exists with template generation examples + open-question default rationale
- [ ] RESOLVER.md adds 3 trigger-phrase rows pointing to `skills/save-spec/SKILL.md`
- [ ] README.md skill table includes `/save-spec` row + brief `What's New in v2.16.0` section
- [ ] CHANGELOG.md gains v2.16.0 entry (minor bump — new skill)
- [ ] `guides/spec-digest-pattern.md:142-148` "Promotion to a skill (deferred)" section updated to "Promoted in v2.16.0" with link to the new SKILL.md; the scope-resolution statement is added so promotion criterion 2 is closed in writing
- [ ] `tests/validate-structure.sh` 256+ PASS / 0 FAIL on the branch
- [ ] `tests/validate-content.sh` 0 FAIL on the branch
- [ ] 8-habit-reviewer dispatch on the implementation diff passes (≥ 14/17 pass; no hard blockers)
- [ ] Version bumped to v2.16.0 across the 4 version-tracked files (`plugin.json`, `marketplace.json`, README badge + footer, SELF-CHECK header)

## Acceptance criteria (EARS, with FR-NNN IDs)

1. **[Ubiquitous] FR-001**: The `/save-spec` skill shall be user-invocable only and shall NOT auto-fire from any hook (PreToolUse / PostToolUse / SessionStart / Stop / SubagentStop). The skill's `allowed-tools` array shall declare exactly `["Read", "Write", "Glob", "AskUserQuestion"]`. (`Grep` was dropped during `/design` — no Process step uses content search; see design.md Decision-8.)

2. **[Event-driven] FR-002**: When the user invokes `/save-spec` (with or without a positional project-name argument), the skill shall first check whether `SPEC.md` exists at the current working directory.

3. **[Unwanted] FR-003**: If `SPEC.md` already exists at the project root, then the skill shall refuse to overwrite, emit the message "`SPEC.md` already exists at `<absolute-path>`. Phase 1 of `/save-spec` is generator-only — edit the file directly, or wait for the Phase 2 `--update` flag. No changes were made.", and stop. The skill shall not invoke the `Write` tool in this branch.

4. **[Event-driven] FR-004**: When the user invokes `/save-spec` and `SPEC.md` does not exist, the skill shall use `Glob` to detect the presence of the candidate pointer-target files at the project root: `PLAYBOOK.md`, `CONTRACTS.md`, `LESSONS.md`, `CHANGELOG.md`, `README.md` (case-sensitive).

5. **[Event-driven] FR-005**: When glob detection completes, the skill shall present the matched files (zero or more) via `AskUserQuestion` (multi-select) and ask the user to confirm which to include as §1 pointers. The default selection shall be "all matched". If no candidates matched, the skill shall emit a one-line note and proceed with an empty §1 pointer list.

6. **[Event-driven] FR-006**: When the user provides the project name (via positional argument OR `AskUserQuestion` if no positional argument was supplied), the skill shall substitute it into the `# SPEC.md — <project-name> save point` header and the first-paragraph identifier.

7. **[Event-driven] FR-007**: When scaffolding §2 (Decisions snapshot), the skill shall ask the user via `AskUserQuestion` to provide up to 3 load-bearing decisions (as 3 separate AskUserQuestion questions OR as one multi-input question — implementation choice in `/design`). Each answer of "skip" shall result in that row being omitted. If all three are skipped, §2 shall contain a single template-stub row exactly matching the template in `guides/spec-digest-pattern.md` §2.

8. **[Event-driven] FR-008**: When scaffolding §3 (Live backlog), the skill shall ask the user via `AskUserQuestion` to provide up to 3 initial backlog items. Each answer of "skip" shall omit that row. If all three are skipped, §3 shall contain a single template-stub bullet exactly matching the template in `guides/spec-digest-pattern.md` §3.

9. **[Event-driven] FR-009**: When scaffolding §4 (Current state — save point), the skill shall populate the `**Last updated**` line with the current ISO 8601 datetime including timezone offset, and shall use the template placeholders from `guides/spec-digest-pattern.md` §4 verbatim for the remaining sub-sections (`### What's happening now`, `### Stuck / waiting on` defaulting to `nothing`, `### Next session entry point` with the `cat SPEC.md` block).

10. **[Event-driven] FR-010**: When all sections are populated, the skill shall write the assembled `SPEC.md` to the project root using the `Write` tool. The file shall NOT include YAML frontmatter (per the user-owned-file exemption in `guides/persistence-convention.md:108-109`).

11. **[Event-driven] FR-011**: After a successful `Write`, the skill shall emit (to conversation only, NOT to any file) the CLAUDE.md auto-update recipe stanza from `guides/spec-digest-pattern.md:106-112` enclosed in a Markdown code block, prefixed with the one-line hint: "Copy this into your project's `CLAUDE.md` to auto-update `SPEC.md` after every task. The plugin does NOT modify your `CLAUDE.md` automatically."

12. **[Unwanted] FR-012**: If the `Write` tool fails for any reason (permission denied, disk full, read-only filesystem), then the skill shall emit a 3-part error message conforming to `guides/persistence-convention.md:71-77`: (a) what was attempted ("Tried to create `SPEC.md` at `<absolute-path>`"), (b) what failed and why (the underlying error code and message), (c) what the user can do next (e.g. "Check write permissions on the parent directory or change to a writable working directory and re-run `/save-spec`"). The skill shall stop without retrying.

13. **[Ubiquitous] FR-013**: The skill shall NEVER write `SPEC.md` (or any other file) to a path under `docs/specs/` — it operates strictly on the project root.

14. **[Ubiquitous] FR-014**: The skill shall NOT emit a `SKILL_OUTPUT:save-spec` HTML comment block. `SPEC.md` is not consumed by `/cross-verify` or `/consistency-check`.

15. **[Ubiquitous] FR-015**: The skill shall NOT invoke the `Edit` tool against the project `CLAUDE.md` or any other file outside of the single `Write` call that creates `SPEC.md`. The CLAUDE.md recipe stanza is emitted to conversation only (per FR-011).

16. **[Optional] FR-016**: Where the user supplies a positional project-name argument to `/save-spec`, the skill shall skip the project-name `AskUserQuestion` (FR-006) and use the argument value directly.

## Plugin boundary check

`/save-spec` is workflow discipline (a guided template generator that respects the spec-digest pattern). It does not enforce, hook, or block anything. It belongs in `8-habit-ai-dev`. The runtime concern (PreToolUse hooks against `.md` operations) lives in `pitimon/claude-governance` — already tracked at issue #34.

## References

- Design discussion: #199 (open-question defaults already accepted)
- Promotion criteria source: `guides/spec-digest-pattern.md:142-148`
- Adopter friction: #197 (items 2.1–2.3, 3, 4, 5 closed via #198)
- Lesson: `~/.claude/lessons/2026-05-17-spec-digest-pattern-v2-15-9.md`
- ADR-013 + 2026-05-17 addendum: scope of "auto-write rejection" (does not cover user-invoked writes)
- Persistence convention: `guides/persistence-convention.md` (frontmatter exemption for user-owned files; error-message format)
- Companion claude-governance issue: pitimon/claude-governance#34 (Write vs Edit distinction)

## Risks

- **R1**: Phase 1 `refuse-on-existing` may frustrate adopters who want quick `SPEC.md` regeneration during early authoring. **Mitigation**: clear message in FR-003 tells them to edit manually; Phase 2 `--update` is queued.
- **R2**: Hybrid auto-detect may produce surprising §1 pointer lists in repos with unrelated `LESSONS.md` / `README.md` files. **Mitigation**: hybrid means the user confirms — false positives are user-visible at the AskUserQuestion step before any write.
- **R3**: Three `AskUserQuestion` invocations for §2 + three for §3 = 6 questions plus project name + §1 confirm = up to 8 interactive prompts. May feel heavy. **Mitigation**: each accepts "skip"; Phase 1 design will batch into fewer prompts where AskUserQuestion supports multi-input.

[/requirements] COMPLETE SKILL_OUTPUT:requirements

<!-- SKILL_OUTPUT:requirements
ears_count: 16
ears_criteria:
  - "FR-001: skill is user-invocable only, allowed-tools = [Read, Write, Glob, AskUserQuestion] (Grep dropped in design — no content search)"
  - "FR-002: on invoke, first check SPEC.md existence"
  - "FR-003: if SPEC.md exists, refuse with stop-gap message; do not Write"
  - "FR-004: glob 5 candidate pointer-target files (PLAYBOOK, CONTRACTS, LESSONS, CHANGELOG, README)"
  - "FR-005: AskUserQuestion multi-select on glob matches; default all"
  - "FR-006: substitute project name into §1 header"
  - "FR-007: AskUserQuestion ≤3 §2 decisions; skip allowed; empty-stub fallback"
  - "FR-008: AskUserQuestion ≤3 §3 backlog items; skip allowed; empty-stub fallback"
  - "FR-009: §4 Last updated = current ISO 8601 with timezone; template placeholders for sub-sections"
  - "FR-010: Write SPEC.md to project root; no YAML frontmatter"
  - "FR-011: after successful Write, emit CLAUDE.md recipe stanza to conversation only"
  - "FR-012: on Write failure, emit 3-part error per persistence-convention.md:71-77 and stop"
  - "FR-013: never write under docs/specs/"
  - "FR-014: no SKILL_OUTPUT:save-spec block emitted"
  - "FR-015: no Edit tool calls on CLAUDE.md or any other file"
  - "FR-016: positional project-name arg skips AskUserQuestion for project name"
scope_in: "Project-root SPEC.md scaffold via glob+confirm §1, AskUserQuestion-seeded §2/§3, timestamped §4, conversation-only CLAUDE.md recipe emission"
scope_out: "Updating existing SPEC.md, writing to docs/specs/<slug>/, SKILL_OUTPUT block, CLAUDE.md modification, multi-mode repos, ADR ingestion, batch/non-interactive mode"
primary_user: "Maintainers/contributors of project-orientation-hub-mode repos (operational/infra/integration/single-system); explicitly NOT feature-spec-mode users"
risks:
  - "R1: refuse-on-existing may frustrate during early authoring; mitigation: clear message + Phase 2 queued"
  - "R2: hybrid auto-detect may surprise with unrelated file matches; mitigation: user confirms before any Write"
  - "R3: up to 8 interactive prompts feels heavy; mitigation: skip allowed per item; Phase 1 design may batch"
success_criteria_count: 5
END_SKILL_OUTPUT -->
