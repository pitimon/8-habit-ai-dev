# Troubleshooting

Use this page when installation, skill routing, wiki sync, or validation does not behave as expected.

## Installation

### Claude Code Banner Does Not Appear

Checks:

1. Confirm the plugin is installed: `claude plugin list`.
2. Start a new Claude Code session; hooks run at session start.
3. Confirm the plugin package includes `hooks/session-start.sh`.
4. If installed from a local checkout, confirm the hook is executable.

Codex users should not expect this banner because Codex does not run Claude hooks.

### Marketplace Not Found

Add the marketplace before installing:

```bash
claude plugin marketplace add pitimon/8-habit-ai-dev
```

For Codex:

```bash
codex plugin marketplace add pitimon/8-habit-ai-dev
```

### Skills Do Not Appear

Checks:

1. Verify plugin installation with your runtime's plugin list command.
2. Start a fresh session.
3. Invoke a known skill directly, such as `/workflow` or `/requirements`.
4. For Codex, confirm `AGENTS.md` and `skills/RESOLVER.md` are available to the runtime.

## Workflow

### `/review-ai` Reports No Diff

There are no local changes for the skill to inspect. Run it after generating or editing code, or pass the relevant diff or PR context.

### `/design` Gives Only One Option

Ask for alternatives explicitly: "Show at least two viable options with trade-offs and a recommendation." Architecture decisions should not be hidden inside a single path.

### `/breakdown` Produces Large Tasks

Ask it to split the task until each item is independently reviewable and has a clear validation step.

## Operations

### A Finding Recovered By Itself

Use `/operational-state` before closing it. Recovered is not always fixed; the skill helps distinguish self-resolved, false positive, accepted known issue, handoff, and active incident states.

### A Config Hotfix Has No Spec Bundle

Use `/consistency-check` incident/config mode. It checks symptom, evidence, root cause, actual fix, deploy path, and live verification without requiring persisted PRD/design/task artifacts.

### A Provider Canary Changed A Different Target

Use `/deploy-guide` reconciliation gates. Compare planned target, provider-selected target, desired/min/max capacity, readiness, scheduling state, and follow-up action before calling the rollout complete.

## Wiki

### Wiki Edit Disappeared

The wiki is generated from `docs/wiki/`. Edit the repository file and open a PR instead of editing the GitHub Wiki web UI directly.

### Wiki Sync Failed

Confirm the repository wiki is enabled and the sync workflow has permission to push to the wiki repository. Then inspect the failing action log.

### Link Check Failed

Check the link-check workflow output. Fix broken external URLs or update the allowlist only for known flaky URLs.

## Validation

Run local validation from the repository root:

```bash
git diff --check
bash tests/validate-structure.sh
bash tests/validate-content.sh
```

If a validator fails, read the first failure carefully; later failures often cascade.

## See Also

- [Installation](Installation)
- [FAQ](FAQ)
- [Contributing to Wiki](Contributing-to-Wiki)
