# Step 5 · Review AI

**Command**: `/review-ai [files or diff]` · **Habit**: H4 Think Win-Win · **Previous**: [Step 4 · Build Brief](Step-4-Build-Brief) · **Next**: [Step 6 · Deploy Guide](Step-6-Deploy-Guide)

## Purpose

Audit AI-generated code **before** commit. This is the non-negotiable step — never skip it, no matter how small the change feels.

## When to use

- **Always** — after any code generation, before any commit
- Before opening a PR
- Before merging someone else's AI-generated contribution

## When to skip

- **Never.** Every other step has legitimate skip cases. Review does not.

## Process

1. Get the diff: `git diff --name-only HEAD` and `git diff HEAD`
2. Review against the brief from Step 4 — did the implementation match?
3. Check for AI hallucinations: nonexistent APIs, wrong function signatures, fabricated imports
4. Security pass: secrets, injection, auth bypass, unsafe deserialization, SSRF
5. Error handling: null/empty inputs, permission denied, partial failures
6. Scope creep: did Claude add features nobody asked for?
7. Test coverage: are new code paths tested?

## Output

Findings categorized **CRITICAL · HIGH · MEDIUM · LOW** with actionable fixes. Fix all CRITICAL and HIGH before committing.

## Complementary lenses

Run these **in addition** to `/review-ai` for deeper coverage:

- [`/security-check`](Skills-Reference#security-check) — focused OWASP Top 10
- [`/cross-verify`](Skills-Reference#cross-verify) — 17-question 8-Habit checklist
- [`/whole-person-check`](Skills-Reference#whole-person-check) — Body/Mind/Heart/Spirit balance

## Handoff

- **Expects**: Implemented code + brief from `/build-brief`
- **Produces for `/deploy-guide`**: Reviewed, fix-applied code ready to deploy

## H4 Checkpoint

> _"Does this interaction leave the next developer better informed and more capable?"_

## See also

- [Source: `skills/review-ai/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/review-ai/SKILL.md)
- [Habits Reference → H4](Habits-Reference#habit-4-think-win-win)
