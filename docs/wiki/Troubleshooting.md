# Troubleshooting

Use this page when installation, skill routing, wiki sync, or validation does not behave as expected.

## Installation

### Claude Code Banner Does Not Appear

Checks:

1. Confirm the plugin is installed: `claude plugin list`.
2. Start a new Claude Code session; hooks run at session start.
3. Confirm the plugin package includes `hooks/session-start.sh`.
4. If installed from a local checkout, confirm the hook is executable.

Codex users should not expect the raw markdown banner. If Codex invokes the package `SessionStart` hook, the same reminder is returned as JSON under `hookSpecificOutput.additionalContext`.

### Marketplace Not Found

Add the marketplace before installing:

```bash
claude plugin marketplace add pitimon/8-habit-ai-dev
```

For Codex:

```bash
codex plugin marketplace add pitimon/8-habit-ai-dev
```

For Hermes, there is no marketplace step — add the repo as a tap instead:

```bash
hermes skills tap add pitimon/8-habit-ai-dev
hermes skills install pitimon/8-habit-ai-dev/skills/<name> --category productivity
```

### `hermes skills install` Fails With "Refusing to overwrite category directory"

The skill's name matches a category folder that already holds other skills in your Hermes home (common for `research`). Install into a category instead: `hermes skills install pitimon/8-habit-ai-dev/skills/research --category productivity`. The skill keeps its name, so `/research` still works ([#409](https://github.com/pitimon/8-habit-ai-dev/issues/409)).

### Already Installed Without `--category`

No action needed. Re-running `hermes skills install … --category productivity` on an installed skill reports "already installed" and leaves it in place; `hermes skills update <name>` keeps updating it where it is. Only a skill whose name collides with a category folder (for example `research`) needs `--category` ([#409](https://github.com/pitimon/8-habit-ai-dev/issues/409)).

### `/plugins` Does Not List 8-habit-ai-dev on Hermes

Expected. On Hermes, 8-habit-ai-dev is installed as a skill tap, not a plugin; `/plugins` (`hermes plugins list`) shows only code plugins. Check the tap and skills instead:

```bash
hermes skills tap list          # pitimon/8-habit-ai-dev should be listed
hermes skills list --source hub # the installed skills, e.g. diagnose, research
```

### Old Skill Names Stop Working After Switching to Tap Installs

Hand-made ports often used prefixed names (`8-habit-diagnose`, `research-skill`). Tap installs use the upstream names (`diagnose`, `research`), so `/8-habit-diagnose` returns "Unknown command". Avoid aliasing an old name to a tap skill when the alias name contains the skill's name (`research-skill` → `/research`): on affected Hermes builds that makes the skill silently stop working in the TUI (see the next entry). An alias with an unrelated name was not tested. Update any other skill or config that references the old name.

### Hermes TUI: `/research` Prints "Loading skill" Then Nothing Happens

Symptom: in the modern TUI (`hermes --tui`) a tap-installed skill such as `/research <topic>` shows `⚡ Loading skill: research`, returns to ready, and the model never replies. A plain message in the same session works, and the CLI may load the skill fine.

Likely cause (Hermes TUI, not this repo's skills; per source reading and the simulation below, confirmed live only for `/research`): the TUI resolves a typed command against an exact-match map that omits skills. When no exact entry exists it falls back to prefix/substring matching, so a longer quick-command alias such as `research-skill` (`quick_commands: … type: alias, target: /research`) captures `/research` and sends it down a path that loads the skill without submitting a model turn. It is the skill-missing-from-`canon` defect in [NousResearch/hermes-agent#96972](https://github.com/NousResearch/hermes-agent/issues/96972); the alias-to-skill path is separately tracked in [#106063](https://github.com/NousResearch/hermes-agent/issues/106063) and [#106088](https://github.com/NousResearch/hermes-agent/pull/106088). Reproduced on Hermes v0.21.5 (upstream `71574220`); check those issues for a fix before relying on this workaround.

Workaround — this avoids the trigger; it does not fix Hermes, and any other command whose name contains a skill name can still capture it. Remove the alias, then start a new session (`/reload-skills` does not reload aliases):

```bash
grep -n -B1 -A2 'type: alias' ~/.hermes/config.yaml   # list quick_commands aliases
```

Delete each `quick_commands` alias whose name contains one of this repo's skill names (heuristic: its `target` is that skill, e.g. `research-skill` → `/research`), then invoke the skill by its upstream name; the old name stops working. With no such alias, a simulation of the TUI resolution over all 24 skills matched each skill to its own name; with the maintainer's own hand-made-port aliases (`research-skill`, `8-habit-diagnose`, `workflow-guide`, …), 11 were redirected (`breakdown`, `calibrate`, `deploy-guide`, `design`, `diagnose`, `eu-ai-act-check`, `reflect`, `requirements`, `research`, `security-check`, `workflow`). In a fresh TUI only `/research` was verified end to end; the other skills were checked by that simulation and by backend dispatch, not by a live model turn each.

Note: this is a Hermes runtime issue. Skills content is unchanged, and this plugin does not patch Hermes.

### `hermes skills install` Fails With "Could not fetch ... from any source"

Hermes's Skills Hub fetcher fail-closes an entire skill install if the `SKILL.md` contains a same-directory markdown link starting with `..` (treated as a path-traversal attempt). This was fixed repo-wide in v2.21.44 (#386) by switching every doc cross-reference in `skills/*/SKILL.md` to an absolute `https://github.com/pitimon/8-habit-ai-dev/blob/main/...` URL. If you still see this error, confirm you are on v2.21.44 or later (`hermes skills inspect pitimon/8-habit-ai-dev/skills/<name>` shows the resolved source), and check `hermes doctor` for a GitHub rate-limit warning — set `GITHUB_TOKEN` if unauthenticated requests are exhausted.

### Skills Do Not Appear

Checks:

1. Verify plugin installation with your runtime's plugin list command.
2. Start a fresh session.
3. Invoke a known skill directly, such as `/workflow` or `/requirements`.
4. For Codex, confirm `AGENTS.md` and `skills/RESOLVER.md` are available to the runtime.
5. For Hermes, confirm the skill was actually installed with `hermes skills list --source hub` — Hermes has no top-level "load whole plugin" step, so each skill must be installed individually.

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
