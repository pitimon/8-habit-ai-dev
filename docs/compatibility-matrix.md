# Runtime Compatibility Matrix

This matrix documents what `8-habit-ai-dev` promises across agent runtimes. It is a compatibility contract, not a feature-parity claim.

## Summary

| Capability | Claude Code | Codex | Other agents |
| --- | --- | --- | --- |
| Markdown skills in `skills/*/SKILL.md` | Yes | Yes | Yes, if the platform can load markdown instructions |
| 7-step workflow guidance | Yes | Yes | Yes |
| `AGENTS.md` entrypoint | Useful, but Claude Code starts at `CLAUDE.md` | Primary entrypoint | Primary entrypoint |
| `CLAUDE.md` architecture reference | Primary auto-loaded context | Reference only | Reference only |
| `llms.txt` documentation map | Useful | Useful | Useful |
| `skills/RESOLVER.md` phrase dispatcher | Yes | Yes | Yes |
| Claude Code plugin packaging | Yes | No | No |
| Codex plugin packaging | No | Yes | No |
| Claude hooks in `hooks/` | Yes | No direct runtime compatibility | No direct runtime compatibility |
| Hook-based verbosity adaptation | Claude Code only | Not runtime-integrated | Not runtime-integrated |
| `disable-model-invocation` intent marker | Decorative for current plugin skills per ADR-014 | Must remain Codex-ingestible | Varies |
| Runtime enforcement gates | No, use `claude-governance` | No, use adapter or companion tooling | Varies |
| Compliance framework implementation | Redirects/delegates to `claude-governance` | Redirects/delegates to `claude-governance` | Varies |
| Obsidian project memory | External curated memory | External curated memory | External curated memory |

## Platform Contracts

### Claude Code

Claude Code gets the richest native integration today:

- Reads `CLAUDE.md` automatically.
- Can install the Claude package from `.claude-plugin/`.
- Can run Claude-specific hooks from `hooks/`.
- Uses the same markdown skills as every other platform.

Claude-specific behavior must not be described as universal runtime behavior.

### Codex

Codex gets native packaging and the same markdown skills:

- `.codex-plugin/plugin.json` points at `skills/`.
- `.agents/plugins/marketplace.json` exposes the repo to Codex marketplace flow.
- `AGENTS.md` is the operating entrypoint.
- `skills/RESOLVER.md` tells Codex which skill to read for a user intent.

Codex does not automatically gain Claude hook behavior. Any runtime automation must be an adapter layer, not a rewrite of the core skills.

See [Codex Integration Guide](codex-integration.md).

### Other Agents

Other agent platforms can consume the plugin as structured markdown:

1. Clone the repo.
2. Read `AGENTS.md`.
3. Use `skills/RESOLVER.md` to pick a skill.
4. Load the cited `SKILL.md` through the platform's native instruction mechanism.

The skill content is portable; the runtime packaging is not.

## Boundary Rules

- Do not claim 100% runtime feature parity across Claude Code and Codex.
- Do not move runtime enforcement into `8-habit-ai-dev`.
- Do not add Codex-specific syntax to every skill unless a future ADR explicitly accepts that coupling.
- Do route policy gates, irreversible-action checks, compliance frameworks, and dynamic orchestration engines to `claude-governance` or a separate adapter.
- Do keep `skills/*/SKILL.md` as the shared source of truth.

## Related Decisions

- [ADR-011: Cross-Agent Discoverability](adr/ADR-011-cross-agent-discoverability.md)
- [ADR-021: Dynamic Workflow Positioning](adr/ADR-021-dynamic-workflow-positioning.md)
- [ADR-023: Native Codex Plugin Packaging](adr/ADR-023-codex-native-packaging.md)
- [ADR-024: Codex Runtime Adapter Boundary](adr/ADR-024-codex-runtime-adapter-boundary.md)
