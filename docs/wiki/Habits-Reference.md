# Habits Reference

The plugin adapts Covey's 8 Habits into concrete engineering behaviors for AI-assisted development. The habits explain why each workflow step exists.

## Summary

| Habit | Engineering behavior | Primary skills |
| --- | --- | --- |
| H1 Be Proactive | Prevent incidents before they happen | `/deploy-guide`, `/security-check`, `/operational-state` |
| H2 Begin with End in Mind | Define done before building | `/requirements`, `/save-spec` |
| H3 Put First Things First | Prioritize important work over interesting work | `/breakdown` |
| H4 Think Win-Win | Leave the next person better informed | `/review-ai`, `/management-talk`, `/ai-dev-log` |
| H5 Seek First to Understand | Read, reproduce, and investigate before changing | `/research`, `/build-brief`, `/diagnose`, `/consistency-check` |
| H6 Synergize | Use human judgment and agent execution together | `/management-talk`, review workflows |
| H7 Sharpen the Saw | Improve the system after each cycle | `/monitor-setup`, `/reflect`, `/post-mortem` |
| H8 Find Your Voice | Keep judgment, conscience, and architecture human-led | `/design`, `/whole-person-check`, `/calibrate` |

## Habit 1 · Be Proactive {#habit-1-be-proactive}

Act on what you can control before a problem becomes an incident.

In practice:

- Plan rollback before deploy.
- Verify runtime state before declaring success.
- Classify operational findings before mutation or closure.

## Habit 2 · Begin With End In Mind {#habit-2-begin-with-end-in-mind}

Define the desired outcome and success criteria before asking the model to build.

In practice:

- Write scope and non-scope.
- Make acceptance criteria observable.
- Keep Definition of Done tied to validation.

## Habit 3 · Put First Things First {#habit-3-put-first-things-first}

Sequence work by importance and dependency, not by what is most interesting to generate.

In practice:

- Split tasks small enough to review.
- Make dependencies explicit.
- Remove optional work from the current slice.

## Habit 4 · Think Win-Win {#habit-4-think-win-win}

Make every artifact useful to the next human who reads it.

In practice:

- Lead review comments with concrete findings.
- Explain incident closure with evidence.
- Write status updates for the audience receiving them.

## Habit 5 · Seek First To Understand {#habit-5-seek-first-to-understand}

Investigate before deciding and read before editing.

In practice:

- Inspect the existing code path.
- Reproduce bugs before hypothesizing.
- Confirm claims from evidence, not confidence.

## Habit 6 · Synergize {#habit-6-synergize}

Combine human judgment and AI speed without confusing their responsibilities.

In practice:

- Let agents gather, draft, and check.
- Keep architecture and irreversible decisions human-owned.
- Use independent review when confidence is high but evidence is thin.

## Habit 7 · Sharpen The Saw {#habit-7-sharpen-the-saw}

Invest in the system's future capability, not only the current output.

In practice:

- Add monitoring after deploy.
- Capture lessons after meaningful work.
- Turn repeated failures into runbook or test improvements.

## Habit 8 · Find Your Voice {#habit-8-find-your-voice}

Keep conscience, judgment, and purpose visible in AI-assisted work.

In practice:

- Make architecture decisions explicit.
- Challenge changes that are technically possible but strategically wrong.
- Adjust guidance to the user's maturity and context.

## See Also

- [Workflow Overview](Workflow-Overview)
- [Skills Reference](Skills-Reference)
- [Maturity Model](Maturity-Model)
