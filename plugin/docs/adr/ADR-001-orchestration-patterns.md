# ADR-001: Integrate Orchestration Patterns into Existing Skills

**Status**: Accepted

**Date**: 2026-04-07

**Decision maker**: Human (itarun.p)

## Context

8-habit-ai-dev v1.x provides a 7-step workflow for disciplined AI-assisted development, but lacks guidance on multi-agent orchestration — worktree isolation, context boundaries, and meta-system thinking. Research into UltraWorkers (ULW) tools (OmC, OmX, clawhip, OmO) revealed 3 transferable patterns that address this gap.

The question: how should orchestration awareness be added to the plugin?

## Options Considered

### Option A: Create a new `/orchestrate` skill

- **Description**: Add a standalone skill (`skills/orchestrate/SKILL.md`) as Step 3.5 between `/breakdown` and `/build-brief`
- **Pro**: Clean separation of concerns; orchestration gets dedicated attention
- **Con**: Breaks the 7-step workflow numbering (becomes 8 steps); adds a mandatory step even for single-agent work; increases token budget for the skill chain

### Option B: Integrate into existing skills (chosen)

- **Description**: Enhance `/breakdown` with orchestration classification and `/build-brief` with context boundaries. Add a reference guide for the underlying patterns.
- **Pro**: Orchestration is a concern within task decomposition, not a separate phase; no workflow chain changes; zero overhead for single-agent work (sections are marked "skip for sequential")
- **Con**: Skills get longer (~20-25 lines each); patterns split across two skills instead of one location

## Decision

**Option B: Integrate into existing skills.** Orchestration is not a separate workflow step — it's a dimension of task decomposition (in `/breakdown`) and implementation briefing (in `/build-brief`). Creating a standalone skill would add ceremony without adding value for the majority of single-agent use cases.

The reference guide (`guides/orchestration-patterns.md`) serves as the single source of truth for all 3 patterns, while the skills reference it via Load directives.

## Consequences

- `/breakdown` now produces orchestration classification (sequential/parallel-safe/parallel-worktree) per task
- `/build-brief` now includes context boundaries (must-know/must-not-know/merge-contract) for parallel work
- `habits/h7-sharpen-saw.md` gains a meta-system mindset rule
- The 7-step workflow chain remains unchanged (Steps 0-7)
- This is a major version bump (2.0.0) because it changes the expected output format of two core skills
