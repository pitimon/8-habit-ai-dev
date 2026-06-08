# Installation

Install `8-habit-ai-dev` through the plugin marketplace for your agent runtime. The package is markdown-only: no dependency install, build step, or application service is required.

> [!NOTE]
> Claude Code and Codex use different package surfaces. Both load the same `skills/` content; Claude hook feature parity is not assumed. If Codex invokes the package `SessionStart` hook, the hook returns Codex-compatible JSON.

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

## What Installs

| Surface | Claude Code | Codex |
| --- | --- | --- |
| 24 markdown skills | Yes | Yes |
| 7-step workflow guidance | Yes | Yes |
| Claude session hook | Yes | No |
| Hook-based verbosity reminder | Yes | No |
| Runtime enforcement | No | No |
| Compliance certification | No | No |

## Next

- [Getting Started](Getting-Started)
- [Workflow Overview](Workflow-Overview)
- [Troubleshooting](Troubleshooting)
