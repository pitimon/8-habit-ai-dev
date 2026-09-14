# OpenClaw Integration

`8-habit-ai-dev` is compatible with OpenClaw as a portable Agent Skills bundle. The supported surface is the shared Markdown skill corpus; this repository does not add an OpenClaw runtime module, tools, or enforcement engine.

## Install from Git

OpenClaw recognizes the existing Claude-compatible bundle layout. Install the repository from a pinned tag when reproducibility matters:

```bash
openclaw plugins install git:github.com/pitimon/8-habit-ai-dev@v2.21.49
openclaw skills list
```

OpenClaw can also load the skills without plugin installation by placing or linking the repository's `skills/` directory into a supported skill root, or by configuring `skills.load.extraDirs`:

```json5
{
  skills: {
    load: {
      extraDirs: ["/absolute/path/to/8-habit-ai-dev/skills"]
    }
  }
}
```

For a workspace-local setup, copy the selected skill directories to `<workspace>/skills/`. Do not copy the repository's `plugin/` mirror into a workspace skill root; it is the Codex child package.

## Use Skills

OpenClaw refreshes skills automatically. If an existing session has not picked up the bundle, start a new agent turn or restart the Gateway, then verify availability:

```bash
openclaw skills list
```

Invoke a skill explicitly with `/skill <name>` or reference it in a prompt with `$<name>`:

```text
Use $requirements to define the acceptance criteria for this feature.
Use $review-ai to review the proposed change before commit.
Use $cross-verify to check the release evidence.
```

Skill allowlists are separate from skill installation. If `agents.defaults.skills` or an agent-specific `skills` list is configured, include the selected skill names there; a non-empty agent list replaces the defaults rather than merging with them.

## Portability Contract

- `skills/*/SKILL.md` is the source of truth across Claude Code, Codex, Hermes, and OpenClaw.
- OpenClaw's native tool names and permissions remain the host's responsibility. The `allowed-tools` field documents intent for Claude/Codex and is not an OpenClaw authorization boundary.
- OpenClaw resolves supporting files relative to a loaded skill with `{baseDir}`. The skills that use `${CLAUDE_PLUGIN_ROOT}` carry an OpenClaw note describing the repository URL fallback; use the bundled file when available, otherwise read the cited GitHub URL.
- OpenClaw does not run Claude's `hooks/` lifecycle. The session-start reminder and hook-based verbosity adaptation are therefore not promised on OpenClaw.
- Skills that persist lessons or profiles under `~/.claude/` retain that behavior only for Claude Code. On OpenClaw, treat those paths as unavailable unless the operator intentionally provides a compatible local path; conversation output remains valid without persistence.
- Runtime enforcement, irreversible-action authorization, compliance certification, and dynamic orchestration remain outside this plugin.

## Verification

From the repository root, maintainers run the static OpenClaw compatibility check together with the normal CI-parity suite:

```bash
bash tests/test-openclaw-compatibility.sh
bash tests/ci-local.sh
```

When an OpenClaw installation is available, also run `openclaw skills list` and start a fresh agent turn before claiming live loading evidence. A successful package install alone does not prove that every skill was selected or that Claude-only hooks ran.

## References

- [OpenClaw Skills](https://docs.openclaw.ai/tools/skills)
- [OpenClaw Creating Skills](https://docs.openclaw.ai/tools/creating-skills)
- [OpenClaw Plugin manifest and compatible bundles](https://docs.openclaw.ai/plugins/manifest)
- [Runtime Compatibility Matrix](compatibility-matrix.md)
