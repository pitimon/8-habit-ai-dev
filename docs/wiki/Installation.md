# Installation

Install `8-habit-ai-dev` through the plugin marketplace for your agent runtime. The package is markdown-only: no dependency install, build step, or application service is required.

> [!NOTE]
> Claude Code, Codex, and Hermes each use a different package surface. All three load the same `skills/` content; Claude hook feature parity is not assumed. If Codex invokes the package `SessionStart` hook, the hook returns Codex-compatible JSON. Hermes has no manifest/hook layer at all — it installs skill content only.

## Claude Code

```bash
claude plugin marketplace add pitimon/8-habit-ai-dev
claude plugin install 8-habit-ai-dev@pitimon-8-habit-ai-dev
```

Start a new Claude Code session after installation. The session banner should include `8-Habit AI Dev Active` and a short 7-step workflow reminder.

Verify:

```bash
claude plugin list
```

Update:

```bash
claude plugin update 8-habit-ai-dev@pitimon-8-habit-ai-dev
```

Uninstall:

```bash
claude plugin uninstall 8-habit-ai-dev@pitimon-8-habit-ai-dev
```

## Codex

```bash
codex plugin marketplace add pitimon/8-habit-ai-dev
codex plugin add 8-habit-ai-dev@pitimon-8-habit-ai-dev
```

Verify:

```bash
codex plugin list
```

Codex should use `AGENTS.md` as the operating entrypoint, then route user intent through `skills/RESOLVER.md` to the relevant `skills/<name>/SKILL.md`.

Codex currently has no `codex plugin update` command. Refresh the configured Git marketplace snapshot, then reinstall the plugin from that refreshed snapshot:

```bash
codex plugin marketplace upgrade pitimon-8-habit-ai-dev
codex plugin list
codex plugin remove 8-habit-ai-dev@pitimon-8-habit-ai-dev
codex plugin add 8-habit-ai-dev@pitimon-8-habit-ai-dev
codex plugin list
```

Use `codex plugin marketplace list` if you need to confirm the configured marketplace name.

## Hermes Agent

Hermes has no plugin-manifest layer. It discovers skills through its Skills Hub "tap" mechanism, reading `skills/*/SKILL.md` directly from the repo's default branch — install per skill, not per package:

```bash
hermes skills tap add pitimon/8-habit-ai-dev
hermes skills install pitimon/8-habit-ai-dev/skills/cross-verify
hermes skills install pitimon/8-habit-ai-dev/skills/requirements
```

Repeat `hermes skills install` for each skill you want; there is no single command that installs all 24 at once.

Verify:

```bash
hermes skills list --source hub
```

Update a skill after upstream changes:

```bash
hermes skills check cross-verify
hermes skills update cross-verify
```

Uninstall:

```bash
hermes skills uninstall cross-verify
```

No `AGENTS.md`/`CLAUDE.md` doctrine, session hook, or `SessionStart` reminder travels with a Hermes tap install — only the skill content itself.

## What Installs

| Surface | Claude Code | Codex | Hermes |
| --- | --- | --- | --- |
| 24 markdown skills | Yes | Yes | Yes (installed one at a time) |
| 7-step workflow guidance | Yes | Yes | Yes |
| Claude session hook | Yes | No | No |
| Hook-based verbosity reminder | Yes | No | No |
| Runtime enforcement | No | No | No |
| Compliance certification | No | No | No |

## Next

- [Getting Started](Getting-Started)
- [Workflow Overview](Workflow-Overview)
- [Troubleshooting](Troubleshooting)
