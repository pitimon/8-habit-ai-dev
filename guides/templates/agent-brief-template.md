# AGENT-BRIEF Template

Durable issue-spec template for backlog-bound work — survives weeks of context drift between filing and pickup.

> **Pattern origin**: Adapted from [mattpocock/skills](https://github.com/mattpocock/skills) `skills/engineering/triage/AGENT-BRIEF.md` (MIT licensed). Habit-mapped variant adds H2 (Success criteria) and H8 (Why this matters) sections; preserves the behavioral-not-procedural durability discipline. See [ADR-014](../../docs/adr/ADR-014-external-prior-art-audit.md).

## When to attach an AGENT-BRIEF

- Issue will sit in backlog ≥7 days before pickup
- Filer and picker are different people (or different agent sessions)
- The "why" matters as much as the "what" — without it, the picker rebuilds context from scratch
- For trivial / same-day fixes, AGENT-BRIEF is overhead — use a regular issue body

## Template (copy below; ≤120 lines as filled)

```markdown
# AGENT-BRIEF: <one-line title — what's the desired outcome?>

## What this issue is about (H2: Begin with End in Mind)

<2-3 sentence problem statement — behavioral, not procedural. Describe the symptom, the gap, or the desired capability, NOT how to implement it.>

## Success criteria

- <Verifiable condition 1 — something a reader can check>
- <Verifiable condition 2>
- <Verifiable condition 3 — 3 to 5 criteria typical>

## In scope

- <Bounded list of what counts as "this issue">

## Out of scope (deliberately)

- <Bounded list of what does NOT count — important for backlog durability so scope doesn't drift over weeks>

## Domain vocabulary

- **<term>**: <one-sentence definition>
- **<term>**: <one-sentence definition>

If `CONTEXT.md`, `CONTEXT-MAP.md`, or `docs/agents/domain.md` exists, pull vocabulary from those files instead of inventing new terms.

## Delegation readiness

**State**: `ready-for-agent` | `ready-for-human` | `needs-info`

Use `ready-for-agent` only when the issue has enough context, success criteria, and scope boundaries for pickup without more filer input. If `docs/agents/triage-labels.md` exists, map this state to the repo's real tracker label.

## Why this matters (H8: Find Your Voice)

<1-2 sentence "why we're building this" — survives weeks in backlog when the rationale fades from team memory. Cite an ADR, lesson, or issue if a deeper record exists.>

## Hard rules — what NOT to write here

1. **No file paths**: `src/users/auth.ts:42` rots fast — the codebase will move before pickup.
2. **No line numbers**: Same rot reason.
3. **No implementation details**: How belongs in the PR; what + why belong here.
4. **No commit hashes**: Use behavioral references ("the existing JWT issuance flow"), not git refs.
5. **No screenshots tied to current UI**: UI evolves; describe the behavior instead.

## Pickup checklist (for the agent/dev who picks this up)

- [ ] Read `CLAUDE.md` / `DOMAIN.md` for current context
- [ ] Read `CONTEXT.md`, `CONTEXT-MAP.md`, or `docs/agents/domain.md` if present
- [ ] Verify success criteria still apply (issue may be stale — scope can shift in weeks)
- [ ] If scope expanded since filing, re-run `/8-habit-ai-dev:requirements` before building
- [ ] If domain vocabulary is unfamiliar, search lessons (`~/.claude/lessons/`) for prior work on the same terms
```

## Why these rules exist

**No file paths / no line numbers**: A backlog item that says "fix the bug at `api/users.ts:127`" becomes useless within 1-2 weeks. The file gets reorganized, lines shift, the symptom moves. Behavioral descriptions ("the user-login endpoint returns 500 when password contains unicode") survive refactors.

**No implementation details in the brief**: When the picker reads "use a Redis cache here", they lose the freedom to find a better solution. Briefs are the **what + why**, not the **how**.

**Why-this-matters is mandatory**: A backlog item with no rationale rots into "I think we said we'd do this?" within a month. The rationale is the anchor.

## Relation to other artifacts

- **AGENT-BRIEF vs PRD**: PRD is for active feature work (`/requirements`). AGENT-BRIEF is for backlog issues — smaller, denser, designed for durability over precision.
- **AGENT-BRIEF vs ADR**: ADR records "we decided X" (architectural). AGENT-BRIEF describes "here is work to do" (operational). Different verbs, different audiences.
- **AGENT-BRIEF vs `docs/out-of-scope/` entry**: OOS = "we deliberately won't do Y". AGENT-BRIEF = "here's work we will do".

## Linking from `/breakdown`

When `/breakdown` produces a task list, the Handoff section recommends filing any non-immediate task as a GitHub issue using this template. The template URL is referenced unconditionally — picking it up is the filer's discretion based on whether the issue is backlog-bound.

## H5 + H4 framing

- **H5 (Seek First to Understand)** — the picker reads CLAUDE.md and verifies the brief is still valid before building.
- **H4 (Win-Win)** — every brief is a deposit in the next person's emotional bank account. A clear, durable brief saves them an hour of archaeology.
