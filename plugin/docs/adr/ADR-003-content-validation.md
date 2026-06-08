# ADR-003: Add Content Validation and Architecture Fitness Functions

**Status**: Accepted

**Date**: 2026-04-07

**Decision maker**: Human (itarun.p)

## Context

The plugin's Body (Discipline) dimension has been at Level 2 "Proactive" (score 4) since v1.7.0. The rubric for Level 3 "Significant" requires: _"Quality gates enforce standards automatically, monitoring with alerting, fitness functions track architecture health."_

The existing `validate-structure.sh` (222 lines, 10 checks, 133 assertions) validates that files exist and are wired correctly — but does not check content quality or track architecture health metrics. This is the gap preventing Body from reaching Level 3.

The question: how should content validation and fitness functions be added while maintaining the zero-dependency constraint?

## Options Considered

### Option A: Add npm-based markdown linting (markdownlint-cli)

- **Pro**: Industry-standard tool, comprehensive markdown validation, actively maintained
- **Con**: Breaks the zero-dependency constraint that defines this plugin. Adding `package.json` and `node_modules` to a pure-markdown plugin is architectural mismatch

### Option B: Extend bash validation with content checks + fitness functions (chosen)

- **Pro**: Maintains zero-dependency constraint; splits concerns (structure vs content) into two scripts; fitness functions track measurable metrics over time; CI enforces automatically
- **Con**: Bash regex cannot handle markdown AST-level validation; limited to line-by-line content checks

### Option C: Agent-driven validation at runtime

- **Pro**: Claude can evaluate content semantically, not just syntactically
- **Con**: Not CI-enforceable — agents run interactively, not in GitHub Actions; no deterministic pass/fail; not reproducible

## Decision

**Option B: Extend bash validation with content checks + fitness functions.** A new `validate-content.sh` script handles content quality (section depth, markdown integrity, ADR format, handoff completeness) while the existing `validate-structure.sh` gains checks for allowed-tools values, README cross-references, and agent definitions.

Three architecture fitness functions track health metrics with thresholds:

- **F1 Skill Complexity Budget**: avg/max lines per SKILL.md
- **F2 Validation Coverage Ratio**: assertions / assertable items
- **F3 Convention Consistency**: % of skills following all conventions

This specifically satisfies the Level 3 rubric requirement for "fitness functions track architecture health."

## Consequences

- Two validation scripts: `validate-structure.sh` (~320 lines) + `validate-content.sh` (~250 lines), both well under 800-line limit
- Combined: 17 check categories, ~215 assertions (up from 10 checks / 133 assertions)
- 3 fitness functions with HEALTHY/WARNING/BREACH thresholds
- CI workflow runs both scripts sequentially — content script fails build on fitness breach
- Zero new dependencies — pure bash + standard Unix tools only
- Body dimension rises from Level 2 (score 4) to Level 3 (score 5)
- Minor version bump: 2.1.0 → 2.2.0 (additive, no breaking changes)
