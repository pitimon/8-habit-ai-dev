# Step 5 · Review AI

`/review-ai` audits AI-generated work before commit. It prioritizes correctness, security, scope control, and whether the implementation matches the brief.

| Field | Value |
| --- | --- |
| Command | `/review-ai [diff or PR]` |
| Habit | H4 Think Win-Win |
| Previous | [Step 4 · Build Brief](Step-4-Build-Brief) |
| Next | [Step 6 · Deploy Guide](Step-6-Deploy-Guide) |

## Use This When

- AI generated code, docs, config, tests, or release material.
- You are preparing a commit or PR.
- You are reviewing another agent's output.

## Skip When

Do not skip this step for AI-generated work. For tiny non-AI edits, use normal human judgment.

## Output

- Findings ordered by severity.
- File and line references where possible.
- Concrete fixes for each blocking issue.
- Residual risks or test gaps.
- Clear pass/fail review posture.

## Complementary Checks

- `/security-check` for auth, input, secrets, dependency, config, or infrastructure risk.
- `/cross-verify` for broader 8-Habit readiness.
- `/scrutinize` when intent and necessity should be challenged.

## Handoff

`/deploy-guide` should receive reviewed changes, validation results, and known residual risks.

## See Also

- [Workflow Overview](Workflow-Overview)
- [Skills Reference](Skills-Reference#review-ai)
- [Habits Reference](Habits-Reference#habit-4-think-win-win)
- [Source skill](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/review-ai/SKILL.md)
