# Use the guidance with another agent

Use this route when your agent can read Markdown but has no verified native installation path for this package. There is no package-manager command or hook behavior promised here.

## Select and load a skill

1. Choose a task from the [skill catalog](skills-reference.md).
2. Open the selected `skills/<name>/SKILL.md` from the [source directory](../skills/) or a local repository checkout.
3. Ask your agent to read that file before responding. If its instructions reference supporting guides or habits, provide those files or resolving repository URLs explicitly.
4. Follow the skill's process within your own project's instructions, permissions and approval controls.

If the agent cannot access a referenced file, state that limitation rather than assuming the guidance was loaded. Reading a skill does not activate Claude-specific hooks, reviewer definitions or memory integrations.

## First task

For a bounded feature, load `requirements` to define scope, then `build-brief` to inspect repository context. Ask the coding agent to implement and run the project's existing tests. Load `review-ai` to review the diff and evidence before approving a commit.

Use natural-language requests that name the file you supplied; do not invent native slash commands for an unverified runtime.

## Update and verify

Refresh the local checkout through your approved Git workflow and inspect the exact skill bytes being supplied. If you copy files into another tool, track that copy separately; updating this repository does not necessarily refresh a tool's cache.

The [compatibility matrix](compatibility-matrix.md) describes established boundaries. [AGENTS.md](../AGENTS.md) applies when an agent works on this repository; it is not a substitute for your own project's instructions.

[Back to client selection](../README.md#quick-start)
