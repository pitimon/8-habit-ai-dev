# Architecture Decision Records

This directory contains durable architecture decisions for `8-habit-ai-dev`.

## How to use ADRs

- Create an ADR when the project makes a forward-looking commitment about architecture, packaging, runtime boundaries, validation, or plugin scope.
- Use `docs/out-of-scope/` instead when the main value is preserving why a proposal was rejected.
- Keep ADRs factual: context, options, chosen decision, consequences, and validation.
- Use the next `ADR-NNN` number in sequence.
- Prefer relative links to repo files.

## Current decision index

- `ADR-001` through `ADR-024`: historical decisions covering orchestration, research modes, validation, wiki artifacts, EU AI Act migration, cross-agent discoverability, spec persistence, Codex packaging, and Codex runtime adapter boundaries.
- `ADR-025-codex-project-context-files.md`: adds repo-local Codex context files while preserving existing Claude Code guidance.
- `ADR-026-external-prior-art-audit-karpathy-gstack.md`: audits multica-ai/andrej-karpathy-skills + garrytan/gstack (and closes the utarn/engineer-skills thread) under ADR-014's friction-first gate — defers Karpathy simplicity/surgical-edit gaps (T2), rejects gstack's persona pipeline as `claude-governance` territory (T3).

For the full documentation map, see `../../llms.txt`.
