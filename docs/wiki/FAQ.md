# FAQ

This page answers common questions about what `8-habit-ai-dev` does, where its boundaries are, and how to choose the right workflow depth.

## What Is This Plugin?

It is a markdown guidance plugin for AI-assisted development. It provides 24 skills, a 7-step workflow, and review habits for Claude Code and Codex, and is also installable per-skill in Hermes Agent via its Skills Hub tap.

## Does It Enforce Policy?

No. It gives prompts, checklists, handoffs, and review structure. Runtime enforcement, irreversible-action authorization, compliance frameworks, and dynamic orchestration engines belong in companion tooling such as `claude-governance`.

## Does Codex Run The Claude Hooks?

Codex should not be treated as having Claude hook feature parity. If Codex invokes this package's `SessionStart` hook, the hook returns Codex-compatible JSON with the reminder in `hookSpecificOutput.additionalContext`; broader hook behavior remains host-specific.

## Can I Use This With Hermes Agent?

Yes, but differently than Claude Code or Codex: Hermes has no plugin manifest, so there is no single "install the plugin" command. Add the repo as a Skills Hub tap and install skills one at a time — see [Installation](Installation#hermes-agent). No `AGENTS.md`/`CLAUDE.md` doctrine, session hook, or `SessionStart` reminder travels with a Hermes install, and `guides/`/`habits/`/`scripts/` references don't auto-resolve on Hermes — but as of v2.21.46, each affected `SKILL.md` carries a one-line note with the exact substitution URL ([#388](https://github.com/pitimon/8-habit-ai-dev/issues/388)), so following that note gets the same reference in one extra step.

## Which Skill Should I Start With?

| Situation | Skill |
| --- | --- |
| New feature | `/requirements` |
| Unclear domain | `/research` |
| Architecture choice | `/design` |
| Before commit | `/review-ai` |
| Production deploy | `/deploy-guide` |
| Operational finding | `/operational-state` |
| Bug investigation | `/diagnose` |

For a guided route, use `/using-8-habits`.

## Do I Need All Seven Steps Every Time?

No. Use the workflow proportionally. Trivial fixes often need only review. Production-impacting changes need deployment planning. Unclear or architectural work should use the full path.

## Is `/review-ai` Optional?

Not for AI-generated work. It is the baseline quality step before commit.

## Is This An EU AI Act Compliance Toolkit?

No. This plugin includes a redirect stub for `/eu-ai-act-check`; the canonical compliance checklist lives in `pitimon/claude-governance`. This plugin can help produce reviewable engineering artifacts, but it does not certify compliance.

## Why Does The Wiki Say It Is Generated?

The published GitHub Wiki is synced from `docs/wiki/`. Edit the repository files and open a PR; web edits to the GitHub Wiki can be overwritten by the sync workflow.

## See Also

- [Installation](Installation)
- [Workflow Overview](Workflow-Overview)
- [Skills Reference](Skills-Reference)
- [Troubleshooting](Troubleshooting)
