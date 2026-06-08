# Limitations

`8-habit-ai-dev` is workflow discipline packaged as markdown skills. It helps agents and humans ask better questions, preserve evidence, review AI-generated work, and hand off decisions. It does not execute work by itself.

> [!IMPORTANT]
> Treat this plugin as guidance, not authority. A skill can remind you to verify, review, stage, or monitor; it cannot make a production action safe on its own.

## Where It Helps

| Situation | Useful Starting Point | Why |
| --- | --- | --- |
| Unclear problem or unfamiliar domain | `/research` | Forces source-backed investigation before requirements |
| Feature planning | `/requirements` | Defines scope, success criteria, and EARS-style behavior before implementation |
| Architecture choices | `/design` | Surfaces trade-offs and human decision points |
| AI-generated implementation | `/review-ai` | Produces a verdict with evidence, severity, and verification expectations |
| Pre-merge or pre-release uncertainty | `/cross-verify` | Checks the work across all 8 habits and Body/Mind/Heart/Spirit dimensions |
| Operational finding or incident closure | `/operational-state`, `/deploy-guide`, `/post-mortem` | Separates observation, action, rollout, and learning |

## What It Does Not Do

| Not Provided | Use Instead |
| --- | --- |
| Runtime policy enforcement | Companion tooling such as `claude-governance` or host-specific gates |
| Irreversible-action authorization | Human approval and the deployment/change-management system you already trust |
| Compliance certification or legal advice | Qualified compliance/legal review and auditable control evidence |
| Cloud, Kubernetes, Docker, or database mutation | Your normal infrastructure tooling, runbooks, and staged rollout process |
| Secret scanning or credential handling | Dedicated security scanners and secret-management systems |
| Dynamic sub-agent orchestration engine | A separate adapter or orchestration product |
| Claude hook feature parity inside Codex | Codex-native adapters or explicit manual checks |

## Platform Boundaries

Claude Code and Codex both receive the same markdown skills. Claude Code may also run Claude-specific hooks from `hooks/`. If Codex invokes this package's `SessionStart` hook, the hook returns JSON additional context rather than raw markdown; broader hook behavior remains host-specific. Other agents can use the repo as markdown instructions when they can load `AGENTS.md`, `skills/RESOLVER.md`, and the relevant `SKILL.md`.

The shared source of truth remains `skills/*/SKILL.md`. Packaging, hooks, banners, and marketplace behavior are host-specific presentation layers.

## Evidence Expectations

When a change affects install behavior, generated discovery metadata, skill routing, docs, or release trust, prove it from the surface the user will touch:

- run the repository validators,
- check generated catalog freshness when metadata changes,
- verify installed plugin state for Claude Code or Codex when packaging changes,
- link the exact docs or wiki page affected,
- state what was not tested.

Do not use secrets, customer-sensitive raw data, or private incident transcripts as proof.

## See Also

- [Architecture](Architecture)
- [Installation](Installation)
- [Troubleshooting](Troubleshooting)
- [Contributing to Wiki](Contributing-to-Wiki)
