# Vendor Portability Discipline

> Architectural autonomy is a Habit 8 question, not a vendor question. When a managed-agent platform offers cross-session memory, self-evaluation, or built-in orchestration, the convenience is real — and so is the lock-in. This guide names the discipline that keeps the framework vendor-agnostic regardless of which runtime you adopt.

## Why this matters (H1 + H8)

Managed agent platforms (e.g. Claude Managed Agents, OpenAI Assistants, Bedrock Agents) are converging on three runtime capabilities:

- **Persistent memory** — the platform reflects on prior sessions and surfaces patterns
- **Self-evaluation** — the platform measures its own output against declared outcomes
- **Built-in orchestration** — the platform dispatches sub-agents and routes work

These features ship faster integration and lower coordination cost. They also create two risks that larger orgs must price in:

1. **Lock-in.** If memory, decisions, and evaluation all live in vendor infrastructure, migration cost grows non-linearly. Switching models becomes rewriting the operational substrate.
2. **Data residency and control.** Managed runtime may conflict with sovereignty requirements (PDPA, GDPR Article 44, sector regulators) that demand data stay on infrastructure you control.

The 8-habit framework is intentionally vendor-neutral — structured markdown that any agent runtime can load. **This document names the discipline that keeps you portable even when you adopt managed features.**

## The three principles

### 1. Persist artifacts outside the vendor

Artifacts from `/requirements`, `/design`, `/breakdown`, `/build-brief`, and `/reflect` belong in your repository, not in vendor-managed memory. The repo is the source of truth; managed memory is a derived view.

- PRDs → committed to `docs/requirements/` or equivalent
- Architecture decisions → ADRs in `docs/adr/`
- Task breakdowns → checked-in plan files or issues
- Lessons → `~/.claude/lessons/YYYY-MM-DD-<slug>.md` (and optionally mirrored to the repo for team-shared lessons)
- Cross-verification reports → attached to PRs or persisted under a known path

If the vendor revokes access, changes pricing, or alters memory semantics, you can rebuild the operational state from your repo.

### 2. Treat managed memory as cache, not source of truth

Vendor-summarized history (cross-session reflection, pattern detection, "what we learned last sprint") is convenient but derived. The original signals — commit messages, lesson files, ADRs, PR reviews — are the canonical record.

- **Cache invalidation rule**: if the managed summary disagrees with the canonical artifact, the artifact wins.
- **Reproducibility test**: could you rebuild the managed view from your committed artifacts? If no, you have a hidden dependency.
- **Audit posture**: regulators (EU AI Act Article 11, internal audit) ask for traceable artifacts, not vendor summaries.

### 3. Separate discipline from runtime

The 8-habit workflow is discipline — it tells you _how to develop well_. Managed agent features are runtime — they execute the work. These are orthogonal.

- **Discipline (portable)**: EARS-format requirements, Definition of Done, 17-question cross-verification, post-task reflection, Whole Person assessment
- **Runtime (vendor-specific)**: Who dispatches sub-agents, where embeddings live, which model evaluates outcomes

Using managed runtime does not require abandoning discipline. Using discipline does not require avoiding managed runtime. Choose runtime per project; keep discipline constant.

## Selection checklist

Before adopting a vendor-managed feature, run through this checklist. This is exactly the "third alternative beyond the obvious options" exercise `/cross-verify` Q14 asks for — managed vs. self-hosted is rarely binary, and a hybrid posture with explicit persistence discipline is often the better answer:

- [ ] **Artifact persistence**: Are the primary artifacts (PRD, design, lessons) stored in our repo, not only in the vendor?
- [ ] **Exit cost**: If we switch vendor in 12 months, what fraction of operational state must be rewritten?
- [ ] **Data residency**: Does managed runtime satisfy our jurisdictional and sectoral requirements?
- [ ] **Reproducibility**: Can we rebuild the managed view from our committed artifacts?
- [ ] **Audit trail**: Do we have non-vendor evidence for regulators and internal review?
- [ ] **Fallback path**: If the vendor feature is unavailable, does the workflow still function (perhaps with more friction)?

A "no" on any item is not an automatic block — it is a flag for explicit decision in `/design` and an ADR entry.

## 8-Habit mapping

| Aspect                                | Habit                                 | Dimension |
| ------------------------------------- | ------------------------------------- | --------- |
| Architectural autonomy                | H8 — Find Your Voice                  | Spirit    |
| Prevent lock-in before it bites       | H1 — Be Proactive                     | Body      |
| Artifacts that inform the next person | H4 — Win-Win (Emotional Bank Account) | Heart     |
| Reproducibility over convenience      | H7 — Sharpen the Saw (PC over P)      | Mind      |

The conscience question (Spirit) is the one that closes the loop: _should we depend on this?_ — distinct from _can we use this?_

## Links to skills and adjacent guides

- `/design` — architectural decisions are where vendor coupling is consciously chosen or rejected
- `/cross-verify` Q14 (third alternative beyond the obvious options) — managed vs. self-hosted is rarely binary; the checklist above is one way to find the third path
- `/reflect` — capture lock-in pain or portability wins as lessons
- `guides/integrity-principles.md` — evidence standards apply equally to vendor-summarized claims
- `guides/persistence-convention.md` — where artifacts live so they survive vendor change

## When to revisit

Re-read this guide when:

- Evaluating a new managed feature from any vendor
- Architecting a system that will outlive its current model choice (>2 years)
- Responding to a data-residency or audit requirement
- Reflecting on a migration that turned out harder than expected
