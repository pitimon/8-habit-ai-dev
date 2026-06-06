# FAQ

This page answers common questions about what `8-habit-ai-dev` does, where its boundaries are, and how to choose the right workflow depth.

## What Is This Plugin?

It is a markdown guidance plugin for AI-assisted development. It provides 24 skills, a 7-step workflow, and review habits for Claude Code and Codex.

## Does It Enforce Policy?

No. It gives prompts, checklists, handoffs, and review structure. Runtime enforcement, irreversible-action authorization, compliance frameworks, and dynamic orchestration engines belong in companion tooling such as `claude-governance`.

## Does Codex Run The Claude Hooks?

No. Codex can install the plugin and load the same markdown skills, but Claude hooks in `hooks/` are Claude Code-specific.

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
