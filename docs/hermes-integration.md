# Use 8-Habit AI Dev with Hermes Agent

This guide covers installing individual skills, selecting them for a task, and keeping them updated in Hermes. You need a configured Hermes runtime and a project with existing tests. The package installs skill content, not a runtime plugin entry.

[Install](#install) · [Verify](#verify) · [First task](#first-task) · [Daily use](#daily-use) · [Update](#update) · [Troubleshooting](#troubleshooting)

## Install

Add the repository as a Skills Hub tap and install the skills needed for the first task:

```bash
hermes skills tap add pitimon/8-habit-ai-dev
hermes skills install pitimon/8-habit-ai-dev/skills/requirements --category productivity
hermes skills install pitimon/8-habit-ai-dev/skills/build-brief --category productivity
hermes skills install pitimon/8-habit-ai-dev/skills/review-ai --category productivity
```

Install other skills individually when you need them. Keep `--category productivity`: names such as `research` can collide with category directories on an existing Hermes home. Review any scanner refusal rather than bypassing it to finish installation.

## Verify

Check the tap and hub-installed skill listings:

```bash
hermes skills tap list
hermes skills list --source hub
```

Confirm that `requirements`, `build-brief` and `review-ai` appear. In a running session, use `/reload-skills` or start a new session after installing. The tap does not appear as an installed package in `/plugins`.

Each skill with a `${CLAUDE_PLUGIN_ROOT}` reference has a Hermes substitution note. That variable does not resolve in Hermes: follow the note's repository URL when loading supporting guides or habits. An installed SKILL.md alone does not guarantee those references were read.

## First task

Use a feature such as adding a status filter to an existing list endpoint. Substitute your own endpoint. These prompts illustrate a workflow; they are not an executed demo.

**1. Define the feature.** Explicitly ask Hermes to load the installed skill:

```text
Load the requirements skill from 8-habit-ai-dev.
Define allowed status-filter values, default behavior and acceptance tests
for our list endpoint. Do not edit implementation files yet.
```

Expected output: scope, edge cases, acceptance criteria and a definition of done. Approve that scope before implementation.

**2. Inspect the implementation context.** Ask for the next installed skill:

```text
Load the build-brief skill from 8-habit-ai-dev.
Read the endpoint, callers and tests. Prepare an implementation brief
for the approved status filter. Do not implement yet.
```

Expected output: a brief citing the real repository. Then ask Hermes to implement the approved change and run the project's tests, within your existing permission controls.

**3. Review the resulting diff.** After implementation and tests:

```text
Load the review-ai skill from 8-habit-ai-dev.
Review the status-filter diff and test evidence. Report defects and
verification gaps. Do not commit or push.
```

Expected output: findings and a review verdict. Check the cited evidence and resolve blockers before approving a commit.

## Daily use

Use the installed skill name explicitly in your request. Before asking for a skill not in the first-task set, install its source-qualified repository path with `--category productivity`.

| Situation | Skill | Expected result |
| --- | --- | --- |
| Define work | `requirements` | Scope and acceptance criteria |
| Prepare implementation | `build-brief` | Repository context and test approach |
| Review code | `review-ai` | Findings and evidence gaps |
| Check readiness | `cross-verify` | Readiness assessment |
| Capture learning | `reflect` | Short retrospective |
| Choose the next step | `using-8-habits` | Skill routing |

The [shared catalog](skills-reference.md) lists all entries. Skills are guidance; they do not provide production authorization or runtime enforcement.

## Update

Check for an upstream update, then update a named hub-installed skill:

```bash
hermes skills check requirements
hermes skills update requirements
hermes skills list --source hub
```

Repeat for the other installed skills. Hermes may skip locally edited skills; inspect the difference before choosing to overwrite changes. Hand-made local ports are not automatically converted into tap-managed installs by updating this repository.

To remove an installed skill:

```bash
hermes skills uninstall requirements
```

## Troubleshooting

| Symptom | Check |
| --- | --- |
| Skill refused with a category-directory collision | Use the documented `--category productivity` installation form |
| Skill absent in the running session | Check the hub listing and active profile, then reload skills or start a new session |
| Tap absent from `/plugins` | This is expected: inspect `hermes skills tap list` and the skill listing instead |
| Exact skill command loads but produces no reply | Check for a quick-command alias named after a skill; remove the collision rather than creating another alias |
| Guide path contains `${CLAUDE_PLUGIN_ROOT}` | Follow the installed skill's substitution note; report unavailable supporting material as a limitation |
| Installer reports a security finding | Inspect the finding and source; do not silently weaken security to make the install pass |

Project instruction files, the session reminder, reviewer definitions, and Claude-local memory behavior are not bundled into an individual tap skill. Hermes can read a project's own instructions separately; that is not the same as inheriting repository doctrine through this install.

See the repository [troubleshooting guide](https://github.com/pitimon/8-habit-ai-dev/wiki/Troubleshooting) and the official [Hermes Skills System documentation](https://hermes-agent.nousresearch.com/docs/user-guide/features/skills). For adoption ownership and provider/data review, use [team adoption](team-adoption.md).
