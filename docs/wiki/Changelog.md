# Changelog

Release history for `8-habit-ai-dev`. This page summarizes notable changes; the authoritative source is the [GitHub releases page](https://github.com/pitimon/8-habit-ai-dev/releases) and the [git tag history](https://github.com/pitimon/8-habit-ai-dev/tags).

## v2.2.0 — April 2026

- README overhauled with a professional 8-Habit aligned template
- Hero tagline reframed around pain-point + benefit
- Quick Start split into install + use blocks
- 7-Step Workflow diagram simplified
- GitHub repo description and topics updated
- Wiki infrastructure introduced (`docs/wiki/`, sync Action, link check) — see [ADR-004](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-004-wiki-as-artifact.md)

## v2.1.0

- Smart QA integration with 8-Habit framework
- README internal link and skill cross-reference validation
- `validate-content.sh` fitness function improvements

## v2.0.0

- Three accepted ADRs drive architecture:
  - [ADR-001 Orchestration Patterns](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-001-orchestration-patterns.md)
  - [ADR-002 Research Modes](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-002-research-modes.md)
  - [ADR-003 Content Validation](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-003-content-validation.md)
- Three architecture fitness functions (skill complexity, content depth, cross-reference integrity)
- `validate-content.sh` added alongside `validate-structure.sh`

## v1.x

- Initial 7-step workflow and 8-habit skill set
- Cross-verify agent (`8-habit-reviewer`)
- External QA review v1.0.0 scored 9.5/10 (EXCELLENT) — [Issue #1](https://github.com/pitimon/8-habit-ai-dev/issues/1)

## Versioning policy

This plugin follows [semantic versioning](https://semver.org/):

- **Major** — breaking change to skill interfaces, skill removal, or workflow restructuring
- **Minor** — new skills, new habits content, backward-compatible additions
- **Patch** — documentation fixes, typo corrections, clarifications

Version is tracked in three files that must bump together:

- `.claude-plugin/plugin.json`
- `.claude-plugin/marketplace.json`
- `README.md` footer

## Full history

- **Releases**: [github.com/pitimon/8-habit-ai-dev/releases](https://github.com/pitimon/8-habit-ai-dev/releases)
- **Tags**: [github.com/pitimon/8-habit-ai-dev/tags](https://github.com/pitimon/8-habit-ai-dev/tags)
- **Commits**: [github.com/pitimon/8-habit-ai-dev/commits/main](https://github.com/pitimon/8-habit-ai-dev/commits/main)
