# Advisor Pattern — Reviewer Subagent as Pre-Action Check

> Claude Code workflow pattern for dispatching a reviewer subagent before an irreversible or publicly visible action. This is a **workflow-level** discipline — not the Claude API `advisor_20260301` tool. Maps to H5 (Understand First) + H4 (Win-Win) + H1 (Be Proactive).

This plugin does not call the Claude API. The advisor _discipline_ — letting a second pair of eyes audit a proposal before you commit to it — works today using Claude Code's subagent dispatch, with no API feature required. Issue [#87](https://github.com/pitimon/8-habit-ai-dev/issues/87) is the reference note for the API-level strategy; this guide documents the workflow-level form the plugin already supports.

## Problem

Main-agent drafts of irreversible actions carry hidden risk:

- **Context contamination** — release notes, past-session memory, or long conversation history prime the agent to pattern-match rather than verify.
- **Backlog noise cost** — a filed issue, opened PR, or deploy decision that turns out to be wrong (duplicate, out-of-scope, unverified) costs far more to triage and revert than the ~40 seconds a pre-action review would have taken.
- **No natural gate** — nothing stops the main agent from acting on a plausible-but-unverified proposal once the human gives a casual go-ahead.

The main agent is often the _wrong_ auditor of its own proposal: it has already committed to a framing and will rationalize toward it.

## Solution — Two Forms of the Advisor Pattern

| Form                                            | Mechanism                                                                                 | Scope                   | Applicable Here?                              |
| ----------------------------------------------- | ----------------------------------------------------------------------------------------- | ----------------------- | --------------------------------------------- |
| **API-level** (`advisor_20260301`)              | Sonnet/Haiku executor calls Opus as an in-band advisor tool; billed at mixed model rates  | Claude API applications | No — this plugin does not call the Claude API |
| **Workflow-level** (reviewer subagent dispatch) | Main agent dispatches `@8-habit-reviewer` (Read/Glob/Grep only) with evidence + questions | Any Claude Code session | Yes — this is what the plugin provides        |

The two forms serve the same purpose — inject higher-authority review at a decision point — but operate at different layers. Choose based on _where your loop runs_, not based on which one is "newer."

## Decision Checklist — When to Dispatch the Reviewer

Run the checklist against the action you are about to take. Dispatch `@8-habit-reviewer` if **two or more** are true:

1. **Irreversible or publicly visible?** Filing an issue, opening a PR, merging to main, deploying, closing an issue with a definitive rationale.
2. **Contaminated context?** Conversation has > 50k tokens of prior work, release notes, or session-memory snippets that may have primed pattern-matching.
3. **Pattern-matched proposal?** The draft is shaped by "this looks like issue #X" or "past releases did Y" rather than by reading the current code.
4. **Duplicate risk?** The feature may already exist, have been rejected, or have been shipped under a different name.
5. **Public-facing artifact?** Issue title, PR body, commit message, or user-visible docs — wrong framing here is expensive to revert once indexed.

Reversible edits, exploratory work, and internal refactors do **not** need the advisor step. Save the review budget for where it compounds.

## Example — Issue #87 Comment, 2026-04-23

Testing the workflow-level form on the plugin's own governance loop:

**Setup**

- Main agent (Opus 4.7, 1M context) drafted two issue proposals after reading release notes `v1.x → v2.13.0`.
- Dispatched `@8-habit-reviewer` (Sonnet, read-only) with verified evidence and six specific 8-habit questions per proposal.

**Outcome**

| Proposal                     | 8-Habit Score | Verdict             | Reason                                                                             |
| ---------------------------- | ------------- | ------------------- | ---------------------------------------------------------------------------------- |
| A — F7 coverage metric       | 7/17          | **DO NOT FILE**     | H5 failure: assumption from release-note pattern-matching; duplicate of closed #31 |
| B — SELF-CHECK.md body drift | 15/17         | **FILE WITH EDITS** | Matched #108/#106 pattern; H8 Modeling violation with verifiable evidence          |

**Result** — one scoped issue ([#141](https://github.com/pitimon/8-habit-ai-dev/issues/141)) filed instead of two, one of which would have been noise. The plugin's own H5 discipline caught an H5 violation in its maintainer's AI-assisted proposal draft.

## Cost vs Benefit

| Axis                    | Cost of Dispatching Reviewer                | Cost of Skipping                             |
| ----------------------- | ------------------------------------------- | -------------------------------------------- |
| **Wall clock**          | ~40 seconds per dispatch                    | 0 seconds                                    |
| **Tokens**              | One read-only subagent pass                 | 0                                            |
| **Backlog hygiene**     | Noise filtered before it becomes public     | Duplicate / out-of-scope items accumulate    |
| **Reversion cost**      | None — review happens before action         | Minutes to hours to close / revert / re-open |
| **Context-switch cost** | None — reviewer returns before you continue | Future sessions spent triaging bad items     |

The break-even is low: if the reviewer blocks **one bad proposal per ten**, the pattern pays for itself across typical development velocity.

## Boundary Note

- **API-level `advisor_20260301`** belongs in projects that call the Claude API directly (e.g., memforge, custom agent loops). It is out of scope for this plugin per [CLAUDE.md](../CLAUDE.md) and the scope decision in [#87](https://github.com/pitimon/8-habit-ai-dev/issues/87).
- **Workflow-level advisor** (this guide) is pure discipline — no API dependency, no runtime hook, no config. It uses the existing `@8-habit-reviewer` agent and the dispatch mechanism every Claude Code session already has.
- The pattern composes with [`claude-governance`](https://github.com/pitimon/claude-governance): governance enforcement blocks known-bad actions, advisor review catches proposals that look reasonable but fail cross-verification.

## Quick Reference

| Pattern            | Solves                                           | Used Before                                    | H-Mapping    |
| ------------------ | ------------------------------------------------ | ---------------------------------------------- | ------------ |
| Advisor (workflow) | Context-contaminated proposals on public actions | Filing issues, opening PRs, merging, deploying | H5 + H4 + H1 |

## See Also

- [`agents/8-habit-reviewer.md`](../agents/8-habit-reviewer.md) — the reviewer subagent itself
- [`guides/cross-verification.md`](cross-verification.md) — the 17-question checklist the reviewer runs
- [`guides/orchestration-patterns.md`](orchestration-patterns.md) — related multi-agent discipline patterns
- [Issue #87](https://github.com/pitimon/8-habit-ai-dev/issues/87) — original reference note and 2026-04-23 experiential comment
- [`guides/quick-reference.md`](quick-reference.md) — full 8-Habit rule table

---

_Back to [README](../README.md)_
