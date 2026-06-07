# TDD Tracer-Bullet Guide

Use this guide when the user asks for TDD, test-first development, red-green-refactor, or a feature whose behavior is clearer than its implementation.

This is workflow guidance only. It does not prescribe a test runner or add runtime enforcement.

## Principle

Tests should verify behavior through public interfaces, not implementation details. A good test describes what the system does and survives internal refactors. A brittle test knows private functions, internal collaborators, or transient data shapes that users cannot observe.

## Avoid Horizontal Test Batches

Do not write every planned test first and then implement everything. That outruns the current understanding and often locks in imagined interfaces.

Use vertical tracer bullets instead:

```text
RED: write one behavior test
GREEN: implement the smallest change that passes
REPEAT: choose the next behavior from what you learned
REFACTOR: only after the suite is green
```

## Before the First Test

- Confirm the public interface or user-visible behavior under test.
- Pick the highest useful seam: API endpoint, CLI command, UI interaction, module interface, or documented workflow.
- Name the behavior in project vocabulary from `CONTEXT.md`, `DOMAIN.md`, or relevant docs when present.
- Respect ADRs in the affected area.
- Choose the first tracer bullet that proves the path works end to end.

## Per-Cycle Checklist

- [ ] The test describes observable behavior.
- [ ] The test uses a public interface or stable seam.
- [ ] The test fails for the expected reason before implementation.
- [ ] The implementation is only enough for this behavior.
- [ ] No speculative future behavior was added.
- [ ] Refactoring waits until tests are green.

## When to Skip

- Pure documentation changes.
- Mechanical formatting.
- Dependency bumps where the real proof is compatibility validation.
- A trivial one-line bug with an already-existing failing regression test.
