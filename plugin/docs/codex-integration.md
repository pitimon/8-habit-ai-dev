# Use 8-Habit AI Dev with Codex

Follow this page to install the package, select skills, complete a first reviewed task, and update it in Codex. You need a configured Codex runtime and a project with existing tests. Start with a non-production change.

[Install](#install) · [Verify](#verify) · [First task](#first-task) · [Daily use](#daily-use) · [Update](#update) · [Troubleshooting](#troubleshooting)

## Install

Add the marketplace and install the native plugin:

```bash
codex plugin marketplace add pitimon/8-habit-ai-dev
codex plugin add 8-habit-ai-dev@pitimon-8-habit-ai-dev
```

Start a new Codex session after installation.

## Verify

Inspect the plugin listing:

```bash
codex plugin list
```

Confirm the package's installed/enabled state, not merely that a marketplace entry exists. Then open the skill selector in the session:

```text
/skills
```

Look for the installed `requirements`, `build-brief` and `review-ai` skills. Select the entry from this package if another installed skill has the same name. Plugin skills are not new top-level slash commands.

## First task

Use a feature such as adding a status filter to an existing list endpoint. These prompts are an illustrative exercise, not an executed demo; substitute a real feature in your project.

**1. Define success before editing.** Mention the installed skill:

```text
$requirements Add a status filter to our list endpoint.
Define allowed values, default behavior and testable acceptance criteria.
Do not edit implementation files yet.
```

Expected output: scope, edge cases, acceptance criteria and a definition of done. Review the scope before proceeding.

**2. Prepare the implementation context.** After approving the scope:

```text
$build-brief Prepare a brief for the approved status filter.
Read the handler, callers and tests. Identify what to change and verify.
Do not implement yet.
```

Expected output: an implementation brief grounded in your repository. Then ask Codex to implement the approved change and run the project's actual tests. Skills provide guidance; implementation still needs an explicit task and your normal permission controls.

**3. Review before committing.** Once implementation and tests finish:

```text
$review-ai Review the status-filter diff and test evidence.
List defects and missing verification. Do not commit or push.
```

Expected output: a review verdict and actionable findings. Verify the evidence and resolve blocking findings before approving a commit; the verdict is not production authorization.

If a direct skill mention is unavailable in your Codex surface, use `/skills` to select it or ask by intent: “Use the review-ai skill from 8-habit-ai-dev to review this diff.”

## Daily use

Use the same native skill selector or mention mechanism for each task:

| Situation | Skill mention | Expected result |
| --- | --- | --- |
| Define work | `$requirements` | Scope and acceptance criteria |
| Prepare context | `$build-brief` | Repository-grounded brief |
| Review a diff | `$review-ai` | Findings and evidence gaps |
| Assess readiness | `$cross-verify` | Readiness assessment |
| Capture learning | `$reflect` | Short retrospective |
| Select a next step | `$using-8-habits` | Skill routing |

For other entries, use the [shared catalog](skills-reference.md). A skill's instructions about local persistence are not a universal memory integration; follow your project's configured memory policy.

## Update

Codex currently has no `codex plugin update` command. Updating a Codex plugin is a two-step refresh-and-reinstall flow:

1. Refresh the configured Git marketplace snapshot.
2. Reinstall the plugin if the installed cache still points at an older copy.

Refresh the marketplace snapshot first:

```bash
codex plugin marketplace upgrade pitimon-8-habit-ai-dev
codex plugin list
```

Then reinstall from the refreshed snapshot:

```bash
codex plugin remove 8-habit-ai-dev@pitimon-8-habit-ai-dev
codex plugin add 8-habit-ai-dev@pitimon-8-habit-ai-dev
codex plugin list
```

Use `codex plugin marketplace list` if you need to confirm the configured marketplace name before running `marketplace upgrade`.

## Troubleshooting

| Symptom | Check |
| --- | --- |
| Plugin is absent | Confirm the marketplace name and repeat the install flow |
| Skill is absent from the selector | Inspect the listing and start a new session; confirm which installed package owns the skill |
| Updated source but old installed version | Refresh the marketplace snapshot, then reinstall only if the installed cache is still old |
| A bare skill slash command is rejected | Use `/skills`, a `$skill-name` mention or intent rather than inventing a top-level command |
| Bash validation fails in PowerShell | Read [Windows PowerShell Preflight](#windows-powershell-preflight); Git Bash is needed for repository validators, not for every skill request |

Report package/runtime versions and sanitized reproduction steps through [GitHub Issues](https://github.com/pitimon/8-habit-ai-dev/issues). Use [SECURITY.md](../SECURITY.md) for private vulnerability disclosure.

## Runtime boundaries

This package supplies guidance, not production authorization or a memory integration. Your runtime and model provider own tool permissions and data handling. Use [team adoption](team-adoption.md) for organizational rollout, not as a prerequisite for an individual first task.

## Maintainer reference

The material below concerns packaging, adapters and repository validation. Skip it unless you are maintaining the package or troubleshooting one of those topics. Windows users running Bash-based repository validation should read [Windows PowerShell Preflight](#windows-powershell-preflight).

## Codex Runtime Contract

Codex integration promises:

- Codex can install the plugin through the native marketplace flow.
- Codex can load the same 24 markdown skills from `skills/`.
- Codex can invoke those skills through its native skill surfaces: `/skills`, `$skill-name` mentions, plugin/skill mentions in the app, or natural-language intent.
- Codex should start from `AGENTS.md`, then use `skills/RESOLVER.md` to select a skill.
- Codex and other tools may read `docs/data/skills.json` as generated discovery metadata.
- Codex should treat `CLAUDE.md` as architecture reference, not as automatically loaded runtime state.
- Codex should treat Obsidian or other memory systems as external curated memory, not as the plugin's internal state.

Codex integration does not promise:

- plugin-provided top-level slash commands such as `/research`, `/requirements`, or `/cross-verify`.
- Claude hook feature parity.
- automatic verbosity adaptation as a required Codex runtime feature.
- runtime enforcement gates.
- policy authorization.
- dynamic sub-agent orchestration.
- compliance framework execution.

Those belong in companion tooling or a future adapter layer.

Config-parse note: even though Codex does not run the full Claude hook lifecycle, it **auto-discovers and parses `hooks/hooks.json` at install/cache time** with a strict schema that accepts only a top-level `hooks` key. A sibling metadata field (e.g. `description`) makes Codex reject the config with `unknown field ..., expected hooks` ([#321](https://github.com/pitimon/8-habit-ai-dev/issues/321)). Keep the file schema-pure; `tests/validate-structure.sh` Check 31 enforces this so the same `hooks.json` installs cleanly in both Claude Code and Codex.

Compatibility note: if Codex invokes this package's `SessionStart` hook, `hooks/session-start.sh` emits Codex-compatible JSON with the existing reminder under `hookSpecificOutput.additionalContext`. Claude/default runs still emit the markdown reminder directly. This is a narrow hook-output adapter, not a general runtime enforcement layer.


## Validation Contexts

`tests/validate-structure.sh` is valid in both the source/marketplace checkout and the installed Codex cache, but one packaging invariant is context-specific:

- In source or marketplace snapshots, a real `plugin/` child source directory must exist because `.agents/plugins/marketplace.json` points at `./plugin`.
- In the Codex installed cache under `~/.codex/plugins/cache/...`, the install root is already the plugin root, so Codex may omit the `plugin/` child source directory. The validator treats that as expected installed-cache shape, not as a packaging regression.

Run source/marketplace validation when checking publishability. Run installed-cache validation when checking the shipped user artifact.

## Windows PowerShell Preflight

Windows PowerShell can install and use the Codex plugin, but this repository's
validators and hook smokes remain Bash scripts. Do not port them into parallel
PowerShell implementations unless a future ADR accepts the maintenance cost.

For Windows hosts, use Git Bash as the required compatibility layer:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\windows-preflight.ps1
```

The preflight checks `codex`, `git`, `node`, Git Bash, the installed Codex
plugin listing, and the common `bash` collision where `C:\Windows\System32\bash.exe`
resolves first but no WSL distribution is installed. When Git Bash is available,
it prints copy-pasteable validator commands such as:

```powershell
& "C:\Program Files\Git\bin\bash.exe" -lc "cd /c/Users/User01/.codex/.tmp/marketplaces/pitimon-8-habit-ai-dev && bash tests/validate-structure.sh"
```

Use the absolute Git Bash path in PowerShell automation. A bare `bash` command
may invoke the WSL launcher instead of Git Bash on Windows.

## Codex Command UX

Claude Code users commonly invoke plugin skills as top-level slash commands such as `/requirements`, `/review-ai`, and `/cross-verify`. Codex does not expose installed plugin skills as new top-level slash commands.

Use one of Codex's native skill invocation paths instead:

```text
/skills
```

Then select `requirements`, `review-ai`, `cross-verify`, or another installed skill.

You can also mention a skill directly in the prompt:

```text
$cross-verify ตรวจแผนนี้ก่อน commit
```

Or ask by intent:

```text
Use the cross-verify skill to check this release plan.
```

Avoid documenting `~/.codex/prompts` as this plugin's distribution path. Codex custom prompts are local-only and deprecated for reusable shared workflows; skills are the supported reusable workflow surface.

## Recommended Codex Flow

1. Read `AGENTS.md` for the operating protocol.
2. Read `skills/RESOLVER.md` for intent-to-skill routing.
3. Optionally inspect `docs/data/skills.json` for a machine-readable skill list.
4. Load the cited `skills/<name>/SKILL.md`.
5. Follow the skill's process and Definition of Done.
6. For high-risk work, use Codex's `/skills` selector, `$skill-name` mention, or natural-language request to invoke `cross-verify`, `review-ai`, `security-check`, or `scrutinize` as appropriate.
7. For release work, reconcile GitHub Releases and git tags before updating release docs.

## Optional Adapter Layer

If Codex runtime automation is needed later, keep it outside the markdown skill core. Acceptable adapter responsibilities:

- suggest a skill from user intent,
- open the relevant `SKILL.md`,
- remind the user to run review before commit,
- run repository validators,
- reconcile releases,
- write curated project memory after completed work.

Adapter responsibilities that do not belong in this plugin core:

- policy enforcement,
- secret scanning gates,
- irreversible-action authorization,
- runtime orchestration engines,
- compliance certification checks.

## Source of Truth

| Topic                    | Source of truth                                                    |
| ------------------------ | ------------------------------------------------------------------ |
| Skill behavior           | `skills/*/SKILL.md`                                                |
| Skill routing            | `skills/RESOLVER.md`                                               |
| Generated skill catalog  | `docs/data/skills.json`                                            |
| Cross-agent entrypoint   | `AGENTS.md`                                                        |
| Claude Code architecture | `CLAUDE.md`                                                        |
| Codex packaging          | `.codex-plugin/plugin.json` and `.agents/plugins/marketplace.json` |
| Official releases        | GitHub Releases + git tags                                         |
| Durable project memory   | curated Obsidian notes, if configured                              |

## Related

- [Runtime Compatibility Matrix](compatibility-matrix.md)
- [ADR-023: Native Codex Plugin Packaging](adr/ADR-023-codex-native-packaging.md)
- [ADR-024: Codex Runtime Adapter Boundary](adr/ADR-024-codex-runtime-adapter-boundary.md)
