# Architecture

`8-habit-ai-dev` is a markdown-first plugin. The stable core is the `skills/` directory; runtime-specific files only package or present those skills to Claude Code, Codex, and other markdown-capable agents.

> [!NOTE]
> This page describes how the documentation and plugin surfaces fit together. It is not required reading for everyday use.

## Core Boundary

The plugin owns workflow discipline:

- skill routing and markdown guidance,
- human checkpoints,
- review and verification prompts,
- release and operational documentation discipline,
- validation scripts for the plugin content itself.

The plugin does not own runtime enforcement, irreversible-action authorization, cloud automation, compliance certification, or dynamic orchestration engines.

## Loading Model

| Layer            | Claude Code          | Codex                                                                                                                 |
| ---------------- | -------------------- | --------------------------------------------------------------------------------------------------------------------- |
| Entry point      | `CLAUDE.md`          | `AGENTS.md`                                                                                                           |
| Skills           | `skills/*/SKILL.md`  | `skills/*/SKILL.md`                                                                                                   |
| Resolver         | `skills/RESOLVER.md` | `skills/RESOLVER.md`                                                                                                  |
| Session hooks    | `hooks/`             | `hooks/hooks.json` parsed at install (schema-pure, top level = `hooks` only); `SessionStart` may run via JSON adapter |
| Package manifest | `.claude-plugin/`    | `.codex-plugin/` and `.agents/plugins/marketplace.json`                                                               |

## Skill Shape

Each skill is a markdown file with YAML frontmatter and a consistent body:

```yaml
---
name: <skill-name>
description: >
  When to use this skill
user-invocable: true
prev-skill: <predecessor|any|none>
next-skill: <successor|any|none>
---
```

Workflow skills also define what they expect from the previous step and what they produce for the next step.

## Workflow Graph

```text
/research -> /requirements -> /design -> /breakdown
    -> /build-brief -> /review-ai -> /deploy-guide -> /monitor-setup
```

The graph is validated by repository tests so skill references do not silently drift.

## Validation

| Script                         | Purpose                                                            |
| ------------------------------ | ------------------------------------------------------------------ |
| `tests/validate-structure.sh`  | Frontmatter, names, version sync, graph fields, packaging surfaces |
| `tests/validate-content.sh`    | Markdown integrity, internal links, ADR shape, doctrine checks     |
| `tests/test-skill-graph.sh`    | Handoff graph integrity                                            |
| `tests/test-verbosity-hook.sh` | Claude hook output and token budget                                |

## Documentation Surfaces

| Surface      | Role                               |
| ------------ | ---------------------------------- |
| `README.md`  | Repository overview                |
| `AGENTS.md`  | Cross-agent operating protocol     |
| `CLAUDE.md`  | Claude Code architecture reference |
| `docs/wiki/` | Source for GitHub Wiki pages       |
| `llms.txt`   | Flat map for LLM indexing          |
| `docs/adr/`  | Architecture decision records      |

## See Also

- [Installation](Installation)
- [Skills Reference](Skills-Reference)
- [Contributing to Wiki](Contributing-to-Wiki)
