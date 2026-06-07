# Project Context Contract

Optional per-repo context files for agents using this plugin. The goal is to make the repo's vocabulary, issue workflow, and decision records discoverable before a skill starts reasoning.

This is markdown guidance, not runtime automation. Skills may read these files when they exist; they must not assume they exist, and they must not create or overwrite them unless the user explicitly asks.

## Why This Exists

Most bad agent sessions do not fail because the model lacks a process. They fail because the model enters the repo without the local language: what the team calls things, where work is tracked, which labels mean ready, and which ADRs should not be re-litigated.

This contract imports the useful part of `mattpocock/skills` setup pattern: a small, repo-local context layer that other skills can consume. It deliberately does not import a setup engine or runtime hook.

## Files

Use any subset that fits the repo:

| File | Purpose | Consumer skills |
| --- | --- | --- |
| `DOMAIN.md` | Project invariants, entities, safety boundaries, validation expectations | `/research`, `/requirements`, `/design`, `/build-brief`, `/scrutinize` |
| `SPEC.md` | Project digest and current-state save point | `/research`, `/requirements`, `/build-brief`, `/consistency-check` |
| `CONTEXT.md` | Domain glossary: canonical terms and terms to avoid | `/requirements`, `/design`, `/breakdown`, `/build-brief`, `/diagnose` |
| `CONTEXT-MAP.md` | Map of multiple context files in a monorepo | Same as `CONTEXT.md` consumers |
| `docs/agents/issue-tracker.md` | Where durable work is tracked and how to create/update items | `/breakdown`, `/management-talk` |
| `docs/agents/triage-labels.md` | Mapping from canonical readiness states to real labels | `/breakdown`, `/operational-state`, `/management-talk` |
| `docs/agents/domain.md` | Which context and ADR files agents should read for this repo | `/research`, `/design`, `/build-brief`, `/scrutinize` |
| `docs/adr/` | Durable architecture and boundary decisions | `/research`, `/design`, `/scrutinize`, `/consistency-check` |

`DOMAIN.md` and `SPEC.md` are already part of this plugin repo's own context surface. Downstream projects may use only those two if they do not need issue-tracker or glossary files.

## Glossary Rules

When `CONTEXT.md` exists, treat it as a glossary only:

```md
# Context Name

One or two sentences describing this context.

## Language

**Order**:
A customer request that moves through fulfillment and billing.
_Avoid_: purchase, transaction

**Customer**:
The person or organization that receives the product or service.
_Avoid_: account, buyer
```

Rules:

- Keep definitions to one or two sentences.
- Include project-specific concepts, not generic programming terms.
- List overloaded or rejected names under `_Avoid_`.
- Do not store implementation details, TODOs, specs, secrets, or customer data in the glossary.
- In a monorepo, use `CONTEXT-MAP.md` to point to per-domain `CONTEXT.md` files instead of forcing one global vocabulary.

## Issue Tracker Contract

`docs/agents/issue-tracker.md` should answer:

- Where work lives: GitHub Issues, GitLab, Jira, Linear, local markdown, or another tracker.
- Which command or manual workflow creates an issue.
- Whether agents may comment, label, close, or only draft text for a human.
- Which tracker URL or repo owns the work.

Keep this file procedural enough to prevent wrong writes, but not so detailed that it becomes a stale runbook.

## Triage Label Contract

Use canonical readiness states even when the actual tracker labels differ:

| Canonical state | Meaning |
| --- | --- |
| `needs-triage` | Maintainer must evaluate before action |
| `needs-info` | Waiting on reporter or owner input |
| `ready-for-agent` | Fully specified; an agent can pick it up without extra human context |
| `ready-for-human` | Needs human judgment, access, or implementation |
| `wontfix` | Deliberately not actioned |

`docs/agents/triage-labels.md` maps these states to the real strings:

```md
# Triage Labels

| Canonical state | Tracker label |
| --- | --- |
| `needs-triage` | `needs-triage` |
| `needs-info` | `needs-info` |
| `ready-for-agent` | `ready-for-agent` |
| `ready-for-human` | `ready-for-human` |
| `wontfix` | `wontfix` |
```

If the tracker has no labels, use the canonical state names in issue text instead of inventing labels.

## Skill Usage

Skills should use this contract conservatively:

- First read explicit user-provided artifacts.
- Then read repo-root context files when they exist.
- Then read `docs/agents/*.md` when issue-tracker, label, or domain-doc routing matters.
- If files are absent, proceed normally and say which assumption you made only when it affects the outcome.
- If glossary language conflicts with code or user wording, surface the conflict before building on it.
- If an ADR conflicts with a proposed path, treat the ADR as current unless the user explicitly wants to revisit it.

This keeps the context layer useful without turning it into a required installation step.

## Boundary

Allowed here:

- Markdown context docs.
- Optional skill guidance to read those docs.
- Human-approved updates to project context files.

Not allowed here:

- Runtime hooks that force agents to read or write these files.
- Policy enforcement, compliance certification, or irreversible-action gates.
- Automatic issue mutation without user approval.
- Secrets, tokens, customer-sensitive raw data, or private operational evidence.

Runtime adapters may later help route or validate this contract, but the markdown skill core stays portable.

## Attribution

Inspired by the per-repo setup pattern in [`mattpocock/skills`](https://github.com/mattpocock/skills), especially its `setup-matt-pocock-skills`, `grill-with-docs`, and `triage` skills. Adapted to this plugin's markdown-first, guidance-only boundary.
