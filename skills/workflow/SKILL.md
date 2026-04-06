---
name: workflow
description: >
  Guided walkthrough of the 7-step workflow. Prompts at each step to invoke or skip.
  Use when starting a new feature or when unsure which step comes next.
user-invocable: true
argument-hint: "[feature or task to work through]"
allowed-tools: ["Read", "Glob", "Grep"]
prev-skill: none
next-skill: none
---

# 7-Step Workflow Guide (เดินทีละก้าว)

**All Habits** | **Anti-pattern**: Jumping straight to code without planning, reviewing, or monitoring

## Process

Walk the user through each step. For each step: explain what it does, ask whether to invoke or skip, and track progress.

### The 7 Steps

| Step | Skill          | Purpose                       | Skip if...                                          |
| ---- | -------------- | ----------------------------- | --------------------------------------------------- |
| 0    | /research      | Investigate before specifying | Requirements already clear, well-understood domain  |
| 1    | /requirements  | Define what, why, who         | Single-line fix, formatting change                  |
| 2    | /design        | Architecture decisions        | Bug fix in existing pattern, no architecture impact |
| 3    | /breakdown     | Atomic tasks                  | Single task, scope already clear                    |
| 4    | /build-brief   | Context before coding         | Familiar code, context still fresh                  |
| 5    | /review-ai     | Audit before commit           | Never skip                                          |
| 6    | /deploy-guide  | Staging first                 | No deployment involved                              |
| 7    | /monitor-setup | Observability after deploy    | Monitoring already comprehensive                    |

### For Each Step

1. **Announce**: "Step N: [skill] — [purpose]"
2. **Ask**: "Invoke /[skill], skip (with reason), or stop here?"
3. **If invoke**: Run the skill with the user's feature context
4. **If skip**: Record the reason — honest skipping is fine, lazy skipping is not
5. **Move to next step**

### After All Steps

Produce a completion summary:

```
## Workflow Summary
**Feature**: [name]

| Step | Skill          | Status  | Note                    |
| ---- | -------------- | ------- | ----------------------- |
| 1    | /requirements  | Done    | PRD drafted             |
| 2    | /design        | Skipped | Follows existing ADR    |
| 3    | /breakdown     | Done    | 4 tasks identified      |
| 4    | /build-brief   | Done    | Context brief ready     |
| 5    | /review-ai     | Done    | Verdict: PASS           |
| 6    | /deploy-guide  | Skipped | Local dev only          |
| 7    | /monitor-setup | Skipped | No deployment           |

**Steps completed**: 4/7 | **Skipped with reason**: 3/7
```

## When to Skip

- You already know exactly which step you need (just invoke it directly)
- Continuing a workflow already in progress — pick up where you left off

## Definition of Done

- [ ] Each step was either invoked or skipped with a documented reason
- [ ] Completion summary produced showing all 7 steps
- [ ] No step skipped without justification
