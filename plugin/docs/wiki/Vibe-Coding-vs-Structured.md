# Vibe Coding Vs Structured Development

Vibe coding is ad hoc AI prompting without clear requirements, design ownership, review, deployment planning, or feedback loops. Structured development keeps those responsibilities visible.

> [!NOTE]
> "ทำเสร็จ ≠ ทำดี" means "done is not done well." The plugin is built around that distinction.

## Comparison

| Area | Vibe coding | Structured development |
| --- | --- | --- |
| Problem definition | Prompt first | `/requirements` first |
| Unknown domain | Guess | `/research` |
| Architecture | Model chooses implicitly | `/design`, human decides |
| Tasks | One large request | `/breakdown` |
| Context | Edits before reading | `/build-brief` |
| Review | "Looks good" | `/review-ai` and focused checks |
| Deployment | Push and hope | `/deploy-guide` with rollback |
| Operations | Close on appearance | `/operational-state` and evidence |
| Learning | Lost after task | `/reflect` and `/post-mortem` |

## Cost

Structured development adds a small amount of up-front process. It pays for itself when review, deployment, incident handling, or future maintenance would otherwise have to reconstruct intent.

## When Lightweight Is Fine

- Throwaway scripts.
- Local experiments.
- Formatting-only changes.
- Edits with no behavioral or operational impact.

Even then, use normal review judgment before committing.

## See Also

- [Getting Started](Getting-Started)
- [Workflow Overview](Workflow-Overview)
- [Skills Reference](Skills-Reference)
