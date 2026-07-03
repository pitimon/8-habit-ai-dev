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
| `tests/validate-structure.sh`  | Frontmatter, names, version sync, graph fields, packaging surfaces, CLAUDE.md table completeness (Check 32), ci-local lock-step (Check 33) |
| `tests/validate-content.sh`    | Markdown integrity, internal links, ADR shape, doctrine checks, release-surface freshness (Check 19) |
| `tests/test-skill-graph.sh`    | Handoff graph integrity                                            |
| `tests/test-verbosity-hook.sh` | Claude hook output and token budget                                |
| `tests/test-pre-commit-hook.sh` | Fail-closed verdict paths of the opt-in pre-commit example (v2.21.35) |
| `tests/ci-local.sh`            | One-shot runner for the exact CI suite set (lock-step-guarded)     |

CI additionally runs a full-history gitleaks secret scan (`.github/workflows/secret-scan.yml`) with Dependabot bumping the SHA-pinned actions weekly.

## Documentation Surfaces

| Surface      | Role                               |
| ------------ | ---------------------------------- |
| `README.md`  | Repository overview                |
| `AGENTS.md`  | Cross-agent operating protocol     |
| `CLAUDE.md`  | Claude Code architecture reference |
| `docs/wiki/` | Source for GitHub Wiki pages       |
| `llms.txt`   | Flat map for LLM indexing          |
| `docs/adr/`  | Architecture decision records      |

## Repository File Tree

Illustrative layout (skill/ADR counts grow between releases — browse the repo for the authoritative tree):

```
8-habit-ai-dev/
├── .claude-plugin/
│   ├── plugin.json                 # Plugin metadata
│   └── marketplace.json            # Marketplace listing
├── .codex-plugin/
│   └── plugin.json                 # Native Codex plugin metadata (v2.19.0)
├── .agents/plugins/
│   └── marketplace.json            # Native Codex marketplace listing
├── skills/                         # 24 skills (8 workflow + 16 standalone)
│   ├── research/SKILL.md           #   Step 0 → H5 (depth levels + modes)
│   ├── requirements/SKILL.md       #   Step 1 → H2
│   ├── design/SKILL.md             #   Step 2 → H8
│   ├── breakdown/SKILL.md          #   Step 3 → H3 (orchestration classification)
│   ├── build-brief/SKILL.md        #   Step 4 → H5 (context boundaries)
│   ├── review-ai/SKILL.md          #   Step 5 → H4 (4-level verdict)
│   ├── deploy-guide/SKILL.md       #   Step 6 → H1 (staging, rollback, reconciliation)
│   ├── monitor-setup/SKILL.md      #   Step 7 → H7
│   └── ...                         #   + standalone skills (cross-verify, diagnose, scrutinize, …)
├── agents/                         # Read-only reviewers (8-habit-reviewer, research-verifier)
├── hooks/                          # SessionStart workflow reminder
├── habits/                         # h1..h8 reference content (loaded on-demand)
├── guides/                         # Checklists, templates, cross-verify-packs
├── tests/                          # 5 validator suites + ci-local.sh one-shot runner
├── scripts/                        # sync-mirror.sh, generators, windows-preflight.ps1
├── docs/                           # adr/, wiki/, out-of-scope/, compatibility matrix
├── plugin/                         # Codex child-package mirror (kept in sync via sync-mirror.sh)
├── rules/effective-development.md  # Auto-loaded Claude Code rules
├── CLAUDE.md · AGENTS.md · CONTRIBUTING.md · SELF-CHECK.md
└── README.md
```

## See Also

- [Installation](Installation)
- [Skills Reference](Skills-Reference)
- [Contributing to Wiki](Contributing-to-Wiki)
