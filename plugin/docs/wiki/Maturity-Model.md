# Maturity Model

The maturity model controls how much guidance the plugin should provide. It ranges from explicit coaching to concise prompts for experienced users.

## Levels

| Level | User need | Guidance style |
| --- | --- | --- |
| Dependence | Learning the workflow | Full prompts, examples, and reminders |
| Independence | Can run the basics | Short checklists and key decisions |
| Interdependence | Works with team context | Collaboration, handoff, and review emphasis |
| Significance | Experienced operator | Minimal prompts and exception-focused warnings |

## How Calibration Works

`/calibrate` asks a short set of questions and writes a local Claude Code profile at `~/.claude/habit-profile.md`. Skills can use that profile to adjust verbosity.

> [!NOTE]
> Hook-based profile adaptation is Claude Code-specific. Codex can still use the skill content; if Codex invokes the package `SessionStart` hook, the hook returns JSON additional context rather than raw markdown.

## When To Recalibrate

- Guidance feels too verbose.
- Guidance feels too sparse.
- Your role changes from solo implementation to team review or production operations.
- You are onboarding a new team member.

## See Also

- [Skills Reference](Skills-Reference#calibrate)
- [Workflow Overview](Workflow-Overview)
- [Habits Reference](Habits-Reference)
