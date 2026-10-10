# Use 8-Habit AI Dev with OpenClaw

This guide describes the repository's documented compatible skill-bundle path for OpenClaw. Static compatibility is checked in CI; real-install verification is still open in [#413](https://github.com/pitimon/8-habit-ai-dev/issues/413). Treat the first-task examples as an operator exercise, not a verified live-install receipt.

[Install](#install) · [Verify](#verify) · [First task](#first-task) · [Daily use](#daily-use) · [Update](#update) · [Troubleshooting](#troubleshooting)

## Install

### Install from Git

Install the compatible bundle from a pinned release:

```bash
openclaw plugins install git:github.com/pitimon/8-habit-ai-dev@v2.21.63
```

For workspace loading instead, place selected skill directories under `<workspace>/skills/` or configure `skills.load.extraDirs`:

```json5
{
  skills: {
    load: {
      extraDirs: ["/absolute/path/to/8-habit-ai-dev/skills"]
    }
  }
}
```

Choose one route; do not copy the `plugin/` mirror into a workspace skill root. It is the Codex child package, not a separate skill corpus.

## Verify

Inspect available skills:

```bash
openclaw skills list
```

Confirm that the selected `requirements`, `build-brief` and `review-ai` skills are available. Start a new agent turn if an existing session has not refreshed. A Gateway restart is another documented refresh option, but follow your deployment policy before restarting a shared service.

Check configured skill allowlists separately. A non-empty agent-specific `skills` list replaces defaults rather than merging with them; installation alone does not prove the skill is selected.

## First task

Use a non-production feature such as adding a status filter to an existing list endpoint:

```text
Use $requirements to define allowed status values, defaults and acceptance
criteria for our list endpoint. Do not implement yet.
```

Expected output: scope and testable criteria. Approve that scope before asking for implementation context:

```text
Use $build-brief to inspect the handler, callers and existing tests for the
approved status filter. Prepare a brief; do not implement yet.
```

Ask the agent to implement the approved task and run the project's tests. Then request review:

```text
Use $review-ai to review the status-filter diff and test evidence.
Report defects and verification gaps. Do not commit or push.
```

Verify the cited evidence and resolve blockers before approving a commit. These examples have not been exercised on a real OpenClaw install in this documentation change.

## Daily use

### Use Skills

Use `/skill <name>` or a `$<name>` reference in your request. Select the skill for the task:

| Situation | Skill reference | Expected result |
| --- | --- | --- |
| Define work | `$requirements` | Scope and acceptance criteria |
| Inspect context | `$build-brief` | Implementation brief |
| Review a diff | `$review-ai` | Findings and evidence gaps |
| Assess a release | `$cross-verify` | Readiness assessment |
| Reflect after work | `$reflect` | Short retrospective |

The [catalog](skills-reference.md) describes the shared entries. Read bundled supporting files where available; otherwise follow the skill's OpenClaw repository-URL note. `{baseDir}` is OpenClaw's supporting-file base, not a promise that every repo-root guide was copied into the skill directory.

## Update

For workspace loading, refresh the checkout or copied skill directories through your approved source-update workflow. Record the version or commit, inspect `openclaw skills list`, and repeat a representative task.

The package does not document a verified live updater for the pinned compatible-bundle route here. Use your installed OpenClaw version's supported update/reinstall procedure rather than treating a new Git tag as proof that an existing installation changed. Track this with the real-install evidence in #413.

## Troubleshooting

| Symptom | Check |
| --- | --- |
| Installed skill is not selected | Inspect defaults and agent-specific skill allowlists |
| Existing session uses older guidance | Start a new turn; check refresh and any required Gateway restart under your deployment policy |
| A guide path does not resolve | Use a bundled file if it exists, then the documented repository URL fallback |
| Expected lesson/profile path is under `~/.claude/` | Treat persistence as unavailable unless the operator intentionally provides an appropriate compatible path |
| Install succeeded but workflow behavior is uncertain | Exercise the skill in a fresh turn; installation is not end-to-end runtime proof |

## Portability Contract

The source of truth is `skills/*/SKILL.md`. Tool permissions, model-provider data handling and production authorization remain with your runtime and team. The package does not add runtime enforcement, compliance certification or orchestration engines. Claude hooks and hook-based reminders do not run as part of this OpenClaw integration.

Use the separate [team adoption guide](team-adoption.md) for rollout and security ownership.

## Verification

Maintainers check the static bundle with:

```bash
bash tests/test-openclaw-compatibility.sh
bash tests/ci-local.sh
```

Before claiming live compatibility, also inspect the actual installed skills and exercise a fresh agent turn with a representative task and a rejection/control case. Static green checks do not close #413.

## References

- [OpenClaw Skills](https://docs.openclaw.ai/tools/skills)
- [OpenClaw Creating Skills](https://docs.openclaw.ai/tools/creating-skills)
- [OpenClaw compatible bundles](https://docs.openclaw.ai/plugins/manifest)
- [Runtime Compatibility Matrix](compatibility-matrix.md)
