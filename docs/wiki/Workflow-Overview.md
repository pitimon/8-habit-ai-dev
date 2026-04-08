# 7-Step Workflow Overview

The antidote to vibe coding. Each step is a Claude Code skill, maps to one of Covey's 8 Habits, and has an explicit handoff contract with the next step.

## The 7 steps (+ Step 0)

```
 0 Research  →  1 Requirements  →  2 Design  →  3 Breakdown
                                                     ↓
 7 Monitor  ←  6 Deploy  ←  5 Review AI  ←  4 Build Brief
```

| Step | Skill                                    | Habit                 | Output                        | Human checkpoint? |
| ---- | ---------------------------------------- | --------------------- | ----------------------------- | ----------------- |
| 0    | [`/research`](Step-0-Research)           | H5 Understand First   | Research brief                | Optional          |
| 1    | [`/requirements`](Step-1-Requirements)   | H2 Begin with End     | PRD summary                   | ✅ Yes            |
| 2    | [`/design`](Step-2-Design)               | H8 Find Your Voice    | Architecture decisions (ADR)  | ✅ **Required**   |
| 3    | [`/breakdown`](Step-3-Breakdown)         | H3 First Things First | Atomic task list              | Optional          |
| 4    | [`/build-brief`](Step-4-Build-Brief)     | H5 Understand First   | Implementation brief per task | Optional          |
| 5    | [`/review-ai`](Step-5-Review-AI)         | H4 Win-Win            | Code review findings          | ✅ **Required**   |
| 6    | [`/deploy-guide`](Step-6-Deploy-Guide)   | H1 Be Proactive       | Deploy plan + rollback        | ✅ **Required**   |
| 7    | [`/monitor-setup`](Step-7-Monitor-Setup) | H7 Sharpen the Saw    | Observability config          | Optional          |

## Handoff contracts

Each skill declares `prev-skill` and `next-skill` in its frontmatter and explicitly documents:

- **Expects from predecessor**: what input the skill needs
- **Produces for successor**: what output the next step will consume

This prevents context loss between steps and makes the workflow composable. Standalone skills (`/cross-verify`, `/whole-person-check`, `/security-check`) use `any` for both and can run at any point.

## When to skip

| Change type                              | Steps to run           |
| ---------------------------------------- | ---------------------- |
| Single-line bug fix (obvious root cause) | 5                      |
| Formatting / linting                     | 5                      |
| Dependency version bump                  | 5, 6                   |
| New feature (small, <3 files)            | 1, 3, 4, 5, 6          |
| New feature (medium)                     | 1, 2, 3, 4, 5, 6, 7    |
| New feature (complex / unclear domain)   | 0, 1, 2, 3, 4, 5, 6, 7 |
| Refactor (no behavior change)            | 2, 3, 4, 5             |
| Architecture change                      | 0, 1, 2, 3, 4, 5, 6, 7 |

**Rule of thumb**: never skip `/review-ai` (Step 5). Every other step has legitimate skip cases; review does not.

## Standalone skills

These complement the pipeline and can run any time:

- [`/cross-verify`](Skills-Reference#cross-verify) — 17-question 8-Habit checklist
- [`/whole-person-check`](Skills-Reference#whole-person-check) — Body/Mind/Heart/Spirit balance
- [`/security-check`](Skills-Reference#security-check) — OWASP Top 10 focused review
- [`/reflect`](Skills-Reference#reflect) — post-task 5-question retrospective
- [`/workflow`](Skills-Reference#workflow) — interactive guided walkthrough

## See also

- **[Skills Catalog](Skills-Reference)**
- **[Habits Reference](Habits-Reference)**
- **[Vibe Coding vs Structured](Vibe-Coding-vs-Structured)**
