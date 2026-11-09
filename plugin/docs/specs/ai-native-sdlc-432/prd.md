---
feature: ai-native-sdlc-432
step: requirements
created: 2026-11-09T04:19:16+07:00
updated: 2026-11-09T04:40:00+07:00
source-issue: 432
source-skill-version: unversioned (Hermes-installed requirements skill; no version field)
---

# PRD: Evidence & Handoff Contract + Behavioral Eval Pilot

Source research: [research.md](./research.md). Status: **owner decisions recorded 2026-11-09; PRD not yet formally approved** — `/design` may start, approval gates remain separate.

## Feature: Evidence & Handoff Contract + Behavioral Eval Pilot

**Intake mode**: Existing-system mode for changes to existing skills/guides; Idea-mode for the eval pilot (no baseline exists yet).

**What**: Define a verifiable handoff format (intent, decisions, evidence, not-verified, next/stop) inside the existing skill/guide structure, plus a small behavioral-eval pilot that checks whether agents follow the skills' discipline.

**Why**: Handoffs and evidence differ per skill, and the validators check structure and content, not agent behavior. [SKILL-EFFECTIVENESS.md](../../../SKILL-EFFECTIVENESS.md) records two cases where a passing score was read as evidence that conclusions were correct.

**Who**: Repo maintainer; Claude Code, Codex and Hermes users who hand work across sessions or agents.

## Scope

**In scope**:

- Handoff contract (5 fields, evidence classes) added to one existing guide and, at most, `/research`, `/build-brief`, `/review-ai`, `/deploy-guide`.
- Doctrine-audit rows for the AI-native SDLC playbook.
- Manual behavioral-eval pilot with 5 scenarios.
- CI enforcement for any new MUST rule, mirror sync, validators.

**Out of scope**:

- Runtime hooks or enforcement (issue #432 P3/P4); they belong to companion tooling per [DOMAIN.md](../../../DOMAIN.md).
- Learning/memory pipeline (P1/P2) and ECC domain skills (P5).
- Mandatory `intent.md` / `plan.md`; any new skill.
- Paid CI eval, pass-rate gate, editing or commenting on issue #432.

## Success Criteria

1. A reader can separate verified from unverified claims in one pass of a handoff.
2. No skill writes a file without an explicit save request (ADR-013 invariant unchanged).
3. The pilot yields at least one reproducible baseline run with model/runtime/version recorded.
4. No text claims a skill enforces approval or that hooks behave the same on every runtime.

## Acceptance Criteria (EARS)

### Handoff contract

1. [Ubiquitous] FR-001: The handoff contract shall define five fields: Intent/source, Decisions (with decider), Evidence (check, method, result), Not verified, Next action/stop.
2. [Unwanted] FR-001N: If a handoff lists a claim without a method and result under Evidence or Not verified, then the guide shall classify it as unverified rather than verified.
3. [Ubiquitous] FR-002: The contract shall classify evidence as Static, Executed test, Runtime, or Not verified, and shall state that a static or test result does not establish runtime behavior.
4. [Unwanted] FR-002N: If only static evidence exists for a runtime claim, then the output shall report runtime as Not verified.
5. [Ubiquitous] FR-003: The contract shall be usable conversation-only and shall not require creating `intent.md`, `plan.md`, or any file.
6. [Unwanted] FR-003N: If `/requirements`, `/design`, or `/breakdown` run without `--persist` or an explicit save request, then the skill shall write no file.
7. [Optional] FR-004: Where an artifact (PRD, design, tasks, issue, PR) exists, the handoff shall link to it and name which source is normative.
8. [Unwanted] FR-004N: If two sources conflict, then the handoff shall name the conflict instead of choosing silently.
9. [Ubiquitous] FR-005: The contract shall state that a loaded skill or handoff is not authorization for commits, deploys, or other external actions.
10. [Unwanted] FR-005N: If the owner has not recorded an approval, then the handoff shall mark the action as awaiting approval.
11. [Ubiquitous] FR-006: Adoption shall add the contract to one existing guide plus at most `/research`, `/build-brief`, `/review-ai` and `/deploy-guide`, without a new skill.
12. [Unwanted] FR-006N: If a touched `SKILL.md` exceeds 2000 words by `wc -w`, then the change shall not ship.
13. [Ubiquitous] FR-007: Any new MUST-level convention shall ship its CI enforcement in the same PR, pinned in `tests/test-guide-rule-anchors.sh` where it changes a verdict or required output.
14. [Unwanted] FR-007N: If a rule appears only in a guide and not in the owning `SKILL.md`, then the anchor test shall fail.

### Doctrine audit

15. [Event-driven] FR-008: When the contract is adopted, the doctrine-audit guide shall record the AI-native SDLC playbook rows as adopted, adapt, defer or out-of-scope, each with a citation.
16. [Unwanted] FR-008N: If a row claims the playbook supports instincts, memory vaults or hook intensity profiles, then the audit shall reject it, because the article does not mention them.

### Behavioral eval pilot

17. [Ubiquitous] FR-009: The pilot shall define five scenarios: no-persist writes nothing; deploy without approval stops; static-only runtime claim stays unverified; debug with unclear root cause routes to an investigative workflow; Hermes/Codex are not described as running Claude hooks.
18. [Unwanted] FR-009N: If a scenario has no case that must not pass, then it shall not count toward the five.
19. [Ubiquitous] FR-010: Each scenario shall separate deterministic checks from human-reviewed judgments and record model, runtime, version and date with its result.
20. [Unwanted] FR-010N: If a result lacks model, runtime or version, then it shall not be used as a baseline.
21. [Ubiquitous] FR-011: The pilot shall run manually with no mandatory paid API step in CI and no pass-rate gate until a baseline exists.
22. [Unwanted] FR-011N: If a pass threshold is proposed before a recorded baseline, then it shall be marked unapproved.
23. [Ubiquitous] FR-012: Pilot results shall report unverified areas and runtime variance, not only passes.
24. [Unwanted] FR-012N: If a scenario passes once, then it shall not be reported as proving the skill is safe.

### Release hygiene

25. [Event-driven] FR-013: When skills, guides or docs change, the work shall run `bash scripts/sync-mirror.sh`, `bash tests/ci-local.sh`, and `node scripts/generate-skill-catalog.js --check` if frontmatter changed.
26. [Unwanted] FR-013N: If any validator fails, then the change shall not be reported as complete.

## Conflict Precedence

If FR-003 (conversation-only default) conflicts with a traceability need, FR-003 wins. Ambiguous input defaults to ask or fail safe, not guess.

## Definition of Done

- [ ] Every FR has recorded evidence (command output or cited file:line).
- [ ] Mirror synced; `tests/ci-local.sh` passes.
- [ ] Touched `SKILL.md` files are under 2000 words by `wc -w`.
- [ ] No text implies a skill enforces approval or runtime parity across hosts.
- [ ] Owner has approved this PRD before `/design` starts.

## Constraints

- Markdown-first, dependency-free for consumers; skills are guidance, not enforcement ([DOMAIN.md](../../../DOMAIN.md), [AGENTS.md](../../../AGENTS.md)).
- Cross-references inside `skills/*/SKILL.md` use absolute `blob/main` URLs (Hermes contract, #386).
- Version-bearing files and mirror stay in sync if a release is cut.

## Risks

- Contract grows past 5 fields and adds context cost to skills.
- Overlap with `/review-ai`, `/cross-verify`, `/consistency-check`; design must show which gap each change fills.
- Eval results vary by model and runtime; one pass proves little.
- Handoff wording on Hermes/OpenClaw needs the substitution note where `${CLAUDE_PLUGIN_ROOT}` loads are added.

## Owner Decisions (2026-11-09)

| # | Question | Owner decision | Effect |
| --- | --- | --- | --- |
| 1 | Eval scenario format | "ทำเป็นเอกสาร" — manual documents under `docs/`, not scripts in `tests/` | FR-009–FR-012 satisfied by documents; no model-calling script |
| 2 | Skills to touch | "แก้ 4" — `/research`, `/build-brief`, `/review-ai`, `/deploy-guide` | FR-006 ceiling of four skills is the plan, not a maximum to trim |
| 3 | Issue #432 persistence wording | "แก้ข้อความให้ถูกต้อง" — correct the wording | Drafted for owner review; **not posted or edited** until the owner confirms the exact text and method (comment vs body edit) |

Acceptance of these decisions does not authorize merging, releasing, paid eval runs or editing the issue.

## Open Questions

None blocking `/design`. Design gates: which existing guide hosts the contract; exact anchor phrases per skill within word budgets.

<!-- SKILL_OUTPUT:requirements
ears_count: 26
ears_criteria:
  - "FR-001 handoff contract defines five fields"
  - "FR-001N unverified when claim lacks method and result"
  - "FR-002 evidence classes; static/test does not establish runtime"
  - "FR-002N static-only runtime claim reported Not verified"
  - "FR-003 conversation-only usable, no required files"
  - "FR-003N no file write without --persist or explicit save"
  - "FR-004 link artifact and name normative source"
  - "FR-004N conflicting sources named, not silently chosen"
  - "FR-005 skill/handoff is not authorization"
  - "FR-005N unrecorded approval marked awaiting approval"
  - "FR-006 reuse existing guide and at most four skills, no new skill"
  - "FR-006N SKILL.md over 2000 words does not ship"
  - "FR-007 new MUST ships CI enforcement in same PR"
  - "FR-007N guide-only rule fails anchor test"
  - "FR-008 doctrine-audit rows with citations"
  - "FR-008N reject claims playbook supports instincts/vaults/profiles"
  - "FR-009 five pilot scenarios"
  - "FR-009N scenario without must-not-pass case not counted"
  - "FR-010 separate deterministic and human-reviewed checks; record model/runtime/version/date"
  - "FR-010N result without model/runtime/version not a baseline"
  - "FR-011 manual pilot, no paid CI step, no gate before baseline"
  - "FR-011N threshold before baseline marked unapproved"
  - "FR-012 report unverified areas and variance"
  - "FR-012N single pass not reported as proof of safety"
  - "FR-013 run sync-mirror, ci-local, catalog check"
  - "FR-013N failing validator means not complete"
scope_in: "Handoff contract in one guide and at most four skills; doctrine-audit rows; manual 5-scenario eval pilot; CI enforcement for new MUST rules"
scope_out: "Runtime hooks/enforcement, learning/memory pipeline, ECC domain skills, mandatory intent.md/plan.md, new skill, paid CI eval, pass-rate gate, issue #432 edits"
primary_user: "Repo maintainer; Claude Code/Codex/Hermes users handing work across sessions"
risks:
  - "Contract grows and adds context cost"
  - "Overlap with review-ai, cross-verify, consistency-check"
  - "Eval variance across models and runtimes"
  - "Hermes/OpenClaw substitution notes for CLAUDE_PLUGIN_ROOT loads"
success_criteria_count: 4
END_SKILL_OUTPUT -->
