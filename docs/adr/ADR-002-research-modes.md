# ADR-002: Add Research Modes and Verification Agent to /research

**Status**: Accepted

**Date**: 2026-04-07

**Decision maker**: Human (itarun.p)

## Context

The `/research` skill (Step 0, H5) supports one research mode — general investigation producing a brief. Research into Feynman CLI revealed value in specialized research modes (deep multi-agent research, comparison matrices, code-vs-docs audits) and source verification agents.

The question: how should these capabilities be added?

## Options Considered

### Option A: Create new skills (`/deepresearch`, `/compare`, `/audit`)

- **Pro**: Clean separation; each skill has a focused purpose
- **Con**: Breaks skill count (13→16); fragments Step 0 into 4 entry points; users must choose the right skill before knowing the problem

### Option B: Process variants within `/research` (chosen)

- **Pro**: Follows ADR-001 precedent; single entry point with auto-detection; zero overhead for simple research; backward compatible
- **Con**: SKILL.md grows from 79 to ~200 lines; more complex process routing

### Option C: Only add verification agent, no new modes

- **Pro**: Smallest change; single new file
- **Con**: Misses the comparison and audit patterns that make research more structured

## Decision

**Option B: Process variants within `/research`.** Research modes are not separate workflow steps — they are dimensions of the same research activity. The mode is determined by the user's argument or auto-detected from the research question. This follows ADR-001's principle: integrate into existing skills rather than creating new ones.

A new `research-verifier` agent handles source verification in Deep mode, following the `8-habit-reviewer` pattern (sonnet model, read-only tools).

## Consequences

- `/research` SKILL.md grows from 79 to ~200 lines (well under 800 limit)
- New `research-verifier` agent created (reusable by other skills)
- New `research-brief-template.md` in guides/templates/
- The 7-step workflow chain remains unchanged (research → requirements)
- Backward compatible: `/research [topic]` defaults to Standard/General mode
- Minor version bump: 2.0.0 → 2.1.0 (additive, no breaking changes)
