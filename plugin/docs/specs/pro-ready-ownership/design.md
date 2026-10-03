---
feature: pro-ready-ownership
step: design
created: 2026-10-03T09:10:00+07:00
updated: 2026-10-03T09:10:00+07:00
source-skill-version: 2.21.50
---

# Design: pro-ready entry point + Owner note

**Pass level**: Scan. Text-only changes to one skill, one dispatcher, one guide, one new out-of-scope record. No runtime, persistence, or API surface.

### Decision-1: Entry point shape. Decision-1 covers: FR-001
- **A**: One composite RESOLVER row that cites `review-ai`, `cross-verify`, `deploy-guide`. Pro: no new skill; Check 20 still passes (cited skills exist). Con: a row with three targets breaks the one-skill-per-row pattern.
- **B**: New `pro-ready` skill. Con: duplicates cross-verify; adds a 25th skill to every inventory surface; ceremony freeze.
- **Steelman B**: a named skill is discoverable by slash command. Still loses: discoverability is the RESOLVER's job, and a 25th skill costs more than one dispatcher row.
- **Recommendation**: A, as a new "Composite triggers" section with a numbered list, one cited path per line, so every path is reverse-checked by Check 20.

### Decision-2: Where the ownership check lives. Decision-2 covers: FR-003, FR-004, FR-005
- **A**: `/review-ai` step 7 bullet replacement + Owner note in the Verdict output + one verdict rule. Pro: reviews already end in a verdict; smallest change.
- **B**: cross-verify Q18. Con: changes the 17-question scoring and dimension math (rejected in v2.21.50 too).
- **C**: `/deploy-guide`. Con: too late; merge already happened.
- **Recommendation**: A. Confirmation rule per PRD decision: AI drafts, human confirms, unconfirmed caps at `CONCERNS`.

### Decision-3: statewright record. Decision-3 covers: FR-006, FR-007
- One-sentence corroboration in the guide, pinned commit; a full `docs/out-of-scope/statewright-enforcement.md` modeled on `gstack-persona-pipeline.md`. No ADR: no boundary moves, ADR-021 already decides it.

**Sticky**: none. All three are text and reversible in one patch.

| Load-bearing claim | Label | Evidence | Verify first |
|---|---|---|---|
| Check 20 accepts a row citing three skills | **Refuted** (verified 2026-10-03) | `tests/validate-structure.sh:584` greedy sed returns only `deploy-guide` for a three-path line; the first two links would never be reverse-checked | Done — composite trigger is a numbered list, one cited path per line |
| `review-ai` has ~176 words of headroom below 1950 | Confirmed | `wc -w` = 1774 | No |
| statewright exempts ToolSearch | Confirmed | cloned `2426f75`, `plugins/claude-code/hook.sh:491,524` | No |

<!-- SKILL_OUTPUT:design
pass_level: Scan
decision_count: 3
decisions:
  - "Decision-1: composite RESOLVER row in a new Composite triggers section"
  - "Decision-2: ownership in review-ai step 7 + Owner note + verdict cap"
  - "Decision-3: guide corroboration + out-of-scope record, no ADR"
sticky_decisions: []
constraints:
  - "no new skill, no Q18, no enforcement"
  - "review-ai <= 1950 words"
load_bearing_claims:
  - "Refuted then designed around: Check 20 reads one path per line; Evidence: Direct; Verify first: done"
approval_required:
  - "Blocking: Owner-note confirmation (resolved: AI drafts, human confirms)"
adr_references:
  - "ADR-021"
  - "ADR-026"
article_14_applicable: false
article_14_pass: n/a
END_SKILL_OUTPUT -->
