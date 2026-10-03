---
feature: pro-ready-ownership
step: requirements
created: 2026-10-03T09:00:00+07:00
updated: 2026-10-03T09:00:00+07:00
source-skill-version: 2.21.50
target-version: 2.21.51
---

# PRD: Production-ready review entry point + "You Own It" ownership check

**Intake mode**: Mixed. Existing-system mode for the repo boundary (cited files); Idea-mode for the PRO-READY checklist and the statewright evidence-packet idea, which come from outside sources.

## Feature: pro-ready-ownership

**What**: Give users one phrase ("pro-ready", "ready to merge?") that routes to the existing review chain, and add the one PRO-READY check the plugin lacks: the person who merges can explain the change, why, and how to roll it back, without the AI transcript. Record statewright as out of scope, and cite its `ToolSearch` exemption as independent support for the v2.21.50 real-host rule.

**Why**:

- In the 2026-10-03 session, `@pro-ready-review` matched no skill; the agent had to improvise a chain (`skills/RESOLVER.md` has no "production-ready" or "ready to merge" trigger).
- PRO-READY audit: 7 of 8 letters already map to existing skills; **Y — You Own It** has no question. Q16 asks whether the author knows *why the task matters*; Q11 asks whether code was *read*. Neither asks whether the merger can *explain and roll back* the change unaided (`skills/cross-verify/SKILL.md:69,79`).
- Karpathy (via Search Engine Journal): as models do more work, human work "rises into oversight and understanding". Same gap.
- statewright's approval gate ships an **evidence packet** (summary + checklist + hashed artifacts) so a reviewer can decide without the agent's turn history (statewright README §Approval routing). The plugin can adopt the discipline without the engine.
- statewright's hooks exempt `ToolSearch` from allowlist enforcement (`plugins/claude-code/hook.sh:491,524`, `plugins/omx/src/hook.ts:140`, commit `2426f75`). It is independent corroboration of the #399 Case 2 defect.

**Who**: Anyone about to merge or deploy AI-assisted work with this plugin (Claude Code, Codex, Hermes, OpenClaw).

**In scope**:

- `skills/RESOLVER.md`: a Composite Triggers section (numbered list, one cited path per line — see design Decision-1)
- `skills/review-ai/SKILL.md`: ownership check and Owner note, by **replacing** an existing step-7 bullet, not adding a new step
- `guides/cross-verification.md`: PRO-READY mapping table; statewright `ToolSearch` corroboration in § Core-Claim Verification
- `docs/out-of-scope/statewright-enforcement.md`
- Tests, mirror, version 2.21.51, changelogs, SELF-CHECK

**Out of scope**:

- A new PRO-READY skill or 18th checklist question (duplicates cross-verify; conflicts with the 2026-07-28 ceremony-accretion freeze)
- Any statewright integration, state machine, hook, or MCP dependency (ADR-021)
- Video explainers / ElevenLabs (external dependency)
- T2 items: privilege-escalation check, STE-lite meaning-preservation rule, statewright as a listed companion. These are drafted as issues with ADR-016 drop dates; posting needs owner approval.

## Acceptance Criteria (EARS)

1. [Event-driven] FR-001: When a user asks for a "pro-ready" review, "is this production-ready?", or "ready to merge?", `skills/RESOLVER.md` shall route to `/review-ai` → `/cross-verify` → `/deploy-guide` in that order, in one Composite Triggers entry that takes precedence over single rows, with no new skill.
2. [Ubiquitous] FR-002: `guides/cross-verification.md` shall map each PRO-READY letter to the existing skill or question that covers it, mark Y as covered by `/review-ai`'s ownership check, and label the PRO-READY source as an unverified community checklist, not doctrine.
3. [Ubiquitous] FR-003: `/review-ai` step 7 shall ask whether the person who merges can explain what changed, why, and how to roll it back without the AI transcript, replacing the existing "enough audit evidence to explain what changed and why" bullet. Net new SKILL.md words ≤ 110 (revised from ≤ 60 after independent review: the cap must also be wired into the Verdict table, Definition of Done, and `SKILL_OUTPUT` `pass` rule, or PASS stays reachable without a note).
4. [Ubiquitous] FR-004: The `/review-ai` output shall end with a one-line **Owner note** of five fields — what changed, why, how to roll back, files to read first, confirmed by — written so a reviewer can decide without the conversation.
5. [Unwanted] FR-005: If the Owner note is missing, has a field marked `[not in artifacts]`, or the human merger has not confirmed it, then the final verdict shall not be `PASS` — in the Verdict table, Definition of Done, report template, and `SKILL_OUTPUT` `pass` field alike.
6. [Ubiquitous] FR-006: § Core-Claim Verification shall cite statewright's `ToolSearch` exemption (pinned commit `2426f75`) as independent evidence that mocked-host allowlist tests miss host behavior.
7. [Ubiquitous] FR-007: `docs/out-of-scope/statewright-enforcement.md` shall record what statewright is, what is already native, what was adopted (evidence packet → Owner note), and why the engine is out of charter (ADR-021), including the FSL-1.1 and patent-pledge licensing note.
8. [Ubiquitous] FR-008: `tests/test-cross-verify-release-gates.sh` (or a sibling test) shall pin FR-001–FR-006 strings; the new assertions shall fail on `b1f45b5` and pass after.
9. [Ubiquitous] FR-009: `skills/review-ai/SKILL.md` shall stay ≤ 1950 words by `wc -w` (below the Check 9 WARN line).

## Success Criteria

1. Typing "pro-ready review" (or "ready to merge?") resolves to the three-skill chain through RESOLVER alone.
2. Replaying the v2.21.50 release review (done by independent agent, 2026-10-03): Changed/Why/Read-first came from PR #400 artifacts; **Roll back** was not stated in any artifact, so that note is `[not in artifacts]` and the review caps at `CONCERNS`. The rule surfaces exactly the gap it targets.
3. **Dogfood**: `/cross-verify` is run on this change with the v2.21.50 core-claims rules before merge; its report is attached to the PR.
4. `bash tests/ci-local.sh`, OpenClaw compatibility, and the catalog check pass; mirror in sync; six version files read 2.21.50 → 2.21.51.

## Definition of Done

- [ ] FR-001–009 pass; new assertions observed failing before the change
- [ ] Owner note demonstrated on this PR itself
- [ ] T2 issue drafts saved for owner review (not posted)
- [ ] CHANGELOG, wiki changelog, README What's New, SELF-CHECK updated

## Decision (resolved 2026-10-03, owner)

- **Who confirms the Owner note?** The AI drafts the note from repository artifacts only; the human merger confirms it in one line before merge. An unconfirmed note caps the verdict at `CONCERNS`. Owner accepted the recommendation ("ทำต่อครับ").

## Risks

- R1: Ceremony accretion. Mitigated by replacing a bullet, ≤ 60 net words, and a ≤ 5-line note.
- R2: Owner note turns into a rubber stamp. Mitigated by requiring the rollback line and repository-only sources (FR-005).
- R3: PRO-READY has no verified origin. Mitigated by labeling it a community checklist mapped onto existing doctrine (FR-002).

<!-- SKILL_OUTPUT:requirements
ears_count: 9
ears_criteria:
  - "FR-001: RESOLVER composite row for pro-ready / ready to merge -> review-ai -> cross-verify -> deploy-guide"
  - "FR-002: PRO-READY mapping table in cross-verification guide; source labeled unverified"
  - "FR-003: review-ai step 7 ownership question replaces existing bullet; <=60 net words"
  - "FR-004: review-ai Owner note <=5 lines (what, why, rollback, files)"
  - "FR-005: Owner note not writable from repo artifacts or unconfirmed -> verdict not PASS"
  - "FR-006: statewright ToolSearch exemption cited in Core-Claim Verification"
  - "FR-007: out-of-scope record for statewright enforcement"
  - "FR-008: tests pin FR-001-006; fail before, pass after"
  - "FR-009: review-ai SKILL.md <=1950 words"
scope_in: "RESOLVER row + review-ai ownership check/Owner note + guide mapping and ToolSearch corroboration + out-of-scope record + tests + release surface"
scope_out: "no new skill or Q18; no statewright integration; no video; T2 items drafted as issues only"
primary_user: "anyone merging or deploying AI-assisted work with this plugin"
risks:
  - "R1: ceremony accretion"
  - "R2: Owner note rubber stamp"
  - "R3: PRO-READY unverified origin"
success_criteria_count: 4
END_SKILL_OUTPUT -->
