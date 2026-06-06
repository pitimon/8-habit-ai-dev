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
| `docs/data/skills.json` generated catalog | Yes, documentation/export metadata | Yes, documentation/export metadata | Yes, if the platform can read JSON |
| Install/update verification | `claude plugin list` | `codex plugin list` after marketplace refresh | Platform-specific |
| Real behavior proof for releases | Claude installed version + validators + docs links | Codex installed version/cache path + validators + docs links | Concrete load/use evidence from the host platform |
| Durable project memory | External curated memory | External curated memory | External curated memory |
| Runtime enforcement gates | No, use `claude-governance` | No, use adapter or companion tooling | Varies |
| Compliance framework implementation | Redirects/delegates to `claude-governance` | Redirects/delegates to `claude-governance` | Varies |

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

## Runtime and Plugin Comparison

Use this table when deciding where a behavior belongs. The shared product is the markdown skill corpus; each host decides how to load, display, and optionally wrap it.

| Area | Shared plugin core | Claude Code surface | Codex surface | Other-agent surface |
| --- | --- | --- | --- | --- |
| Skill behavior | `skills/*/SKILL.md` prose and Definition of Done | Loaded through Claude plugin skills | Loaded through Codex plugin skills | Loaded manually or through that platform's skill/rules mechanism |
| Skill routing | `skills/RESOLVER.md` and frontmatter descriptions | May also be aided by Claude UX | Codex should read resolver + matching `SKILL.md` | Platform-specific dispatcher or manual selection |
| Entry context | `README.md`, docs, `llms.txt` | `CLAUDE.md` is the primary auto-loaded reference | `AGENTS.md` is the operating protocol | `AGENTS.md` + `llms.txt` |
| Packaging | Portable markdown and manifests | `.claude-plugin/` | `.codex-plugin/plugin.json` + `.agents/plugins/marketplace.json` | Git clone, raw URLs, or platform-specific import |
| Hooks | Not part of the shared skill core | `hooks/` can run in Claude Code | Not executed | Not executed unless a separate adapter implements equivalent behavior |
| Memory | Not internal plugin state | External memory systems may be used by the agent | External memory systems may be used by the agent | External memory systems may be used by the agent |
| Enforcement | Out of scope | Route to `claude-governance` or another companion | Route to `claude-governance` or a future adapter | Platform-specific, outside this plugin |
| Release evidence | Validators, generated catalog freshness, docs links | Add `claude plugin list` evidence when install behavior changes | Add `codex plugin list` and marketplace/cache evidence when install behavior changes | Add concrete host load/use evidence |

## Evidence and Release Proof

Docs and plugin packaging changes should include real behavior proof when they affect what users install, load, or trust. Useful evidence includes:

- validator output from `tests/validate-structure.sh`, `tests/validate-content.sh`, `tests/test-skill-graph.sh`, and `tests/test-verbosity-hook.sh`;
- `node scripts/generate-skill-catalog.js --check` when skill metadata or generated discovery surfaces are touched;
- `claude plugin list` or `codex plugin list` when package manifests, marketplace docs, install instructions, or cache-refresh behavior changes;
- Codex source/marketplace and installed-cache validator output when Codex packaging shape changes, because `plugin -> .` is required before install but may be absent after install;
- exact wiki/docs links for new user-facing pages.

Do not use secrets, customer-sensitive raw data, private incident transcripts, or unverifiable summaries as release evidence.

For product boundaries that should stay visible to users, see the wiki [Limitations](https://github.com/pitimon/8-habit-ai-dev/wiki/Limitations).

## Frontmatter Contract

`skills/*/SKILL.md` frontmatter is a shared compatibility surface. Keep it conservative:

| Field | Claude Code | Codex | Portability note |
| --- | --- | --- | --- |
| `name` | Required | Required | Must match the skill directory. |
| `description` | Required | Required | Trigger/routing prose; not a runtime command. |
| `user-invocable` | Required | Required | Boolean metadata consumed by validators and plugin surfaces. |
| `argument-hint` | Supported as UX hint | Supported as UX hint | Do not encode runtime-only behavior. |
| `allowed-tools` | Documents intended tools | Documents intended tools | Tool names are not a universal cross-runtime permission system. |
| `prev-skill` / `next-skill` | Workflow graph metadata | Workflow graph metadata | Used by docs, validators, and agents reading the skill graph. |
| `disable-model-invocation` | Decorative for current plugin skills per ADR-014 | Must remain ingestible | Current values stay `false`; do not set `true` without a new compatibility decision. |

The generated catalog at `docs/data/skills.json` is derived from this contract. It is an index for discovery, not a runtime dispatcher.

## Host Platform Contract

Repository validators and generators should work on macOS, Linux, and WSL:

- Prefer dependency-free scripts.
- Use `bash` for shell validators and keep compatibility with macOS bash 3.x.
- Avoid `sed | ... | head` file-reading pipelines under `pipefail`; use the documented `awk` pattern in `CONTRIBUTING.md`.
- For JSON generation, prefer a small Node script over hand-built shell string concatenation.
- Do not hardcode macOS-only paths, Linux-only commands such as GNU `timeout`, or WSL-specific filesystem assumptions.

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
