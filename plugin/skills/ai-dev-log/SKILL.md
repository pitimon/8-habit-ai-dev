---
name: ai-dev-log
description: >
  Generate AI-assisted development log from git history + Co-Authored-By trailers.
  Use for EU AI Act Article 11 (technical documentation) audit trail and AI transparency.
  Maps to H4 (Win-Win — honest disclosure) + H1 (Be Proactive — audit-ready).
user-invocable: true
argument-hint: "[--since YYYY-MM-DD] [--repo path] [--snapshot sha] [--out file]"
allowed-tools: ["Read", "Glob", "Grep", "Bash"]
disable-model-invocation: false
prev-skill: any
next-skill: any
---

# AI Development Log Generator

**Habit**: H4 (Win-Win — honest disclosure to stakeholders) + H1 (Be Proactive — produce audit trail before audit)
**Anti-pattern**: Hiding AI involvement from stakeholders, or scrambling to reconstruct AI usage at audit time

## Why This Exists

EU AI Act Article 11 requires technical documentation kept up-to-date through the system lifecycle. Article 13 (3)(d) requires disclosure of how AI assists the development process. Beyond compliance, transparency about AI involvement is a **deposit in the Emotional Bank Account** — stakeholders trust you more when you're upfront.

This skill generates a chronological dev log showing:

- Which commits had human + AI collaboration
- Which AI model(s) contributed
- Date ranges of AI activity
- Human authors who reviewed/approved

## When to Use

- Before major release for EU-targeted high-risk AI systems (Article 11 evidence)
- Quarterly for projects using AI coding assistants
- During audit preparation (any framework that requires AI disclosure)
- When onboarding new team members (show how AI fits into workflow)

## When to Skip

- Project has no AI-authored commits (no `Co-Authored-By` trailers)
- Project is fully human-authored (no AI assistance in scope)
- Already have a comprehensive AI usage report from another tool

## Quick Run (one command)

```bash
# Default: last 90 days, markdown to stdout
bash ${CLAUDE_PLUGIN_ROOT}/scripts/generate-ai-dev-log.sh

# Save to compliance folder
bash ${CLAUDE_PLUGIN_ROOT}/scripts/generate-ai-dev-log.sh \
  --since 2026-01-01 \
  --out docs/compliance/eu-ai-act/ai-dev-log/2026-Q1.md

# Reproduce a previously generated report from its recorded boundary
bash ${CLAUDE_PLUGIN_ROOT}/scripts/generate-ai-dev-log.sh \
  --since 2026-01-01 \
  --snapshot <sha-from-report>

# JSON for CI ingestion
bash ${CLAUDE_PLUGIN_ROOT}/scripts/generate-ai-dev-log.sh --json

# One-line stats
bash ${CLAUDE_PLUGIN_ROOT}/scripts/generate-ai-dev-log.sh --summary
```

The script handles all 6 process steps below (discover, extract, group, oversight, report, fallback). Read the script source if you want to customize: `scripts/generate-ai-dev-log.sh`

The detailed process and report template live in `reference.md`; load it when you need to explain or customize the generator.

## Process Summary

1. Discover AI co-authors from `Co-Authored-By` trailers, using commit-body trailer lines only as a fallback when Git's trailer parser returns empty.
2. Extract AI-assisted commits for the selected period.
3. Group activity by time period for readability.
4. Add human oversight evidence when PR, review, or test metadata is available.
5. Generate Markdown, JSON, or summary output.
6. Pin the report to the current `HEAD` snapshot and document fallback limitations when trailers are incomplete.

If many commits lack trailers but you know AI was used, keep the report honest: mark the gap as inferred and supplement it with external records such as PR notes, timesheets, IDE telemetry, or project memory.

## Output Modes

| Flag        | Output          | Use case                            |
| ----------- | --------------- | ----------------------------------- |
| (default)   | Markdown report | Audit, quarterly review             |
| `--json`    | Structured JSON | CI integration, dashboard ingestion |
| `--summary` | One-line stats  | Quick check                         |

## Habit Checkpoint (H4 + H1)

> **H4**: "Does this disclosure deposit trust with stakeholders, or hide something they should know?"
> **H1**: "Have I prepared this evidence before someone asks for it?"

## Handoff

- **Expects from predecessor**: A git repo with commit history (and ideally Co-Authored-By trailers from AI tools)
- **Produces for successor**: AI development log file. Used as evidence for `/eu-ai-act-check` Obligation 3 (Technical Documentation) — the canonical skill lives in [`pitimon/claude-governance`](https://github.com/pitimon/claude-governance) v3.1.0+ (migrated 2026-05-02 per ADR-012).

## Definition of Done

- [ ] Time period defined (default: last quarter)
- [ ] AI co-authors discovered from git trailers or valid commit-body trailer fallback
- [ ] Snapshot boundary recorded so later report-maintenance commits do not move the statistics
- [ ] Statistics calculated (total/AI-assisted/percentages)
- [ ] Notable changes annotated with PR/review/test evidence
- [ ] Methodology section discloses limitations honestly
- [ ] Output saved to `docs/compliance/ai-dev-log/`
- [ ] H4 + H1 checkpoint answered

## References

- EU AI Act Article 11 (Technical Documentation) — primary-source verified quotes live in [`pitimon/claude-governance` `docs/research/eu-ai-act-obligations.md`](https://github.com/pitimon/claude-governance/blob/main/docs/research/eu-ai-act-obligations.md) (migrated 2026-05-02 per ADR-012)
- EU AI Act Article 13 ¶3(d) (Disclosure of human oversight measures)
- Habit details: `${CLAUDE_PLUGIN_ROOT}/habits/h4-win-win.md`, `${CLAUDE_PLUGIN_ROOT}/habits/h1-be-proactive.md`

Load `${CLAUDE_PLUGIN_ROOT}/skills/ai-dev-log/reference.md` for the script internals, report template, fallback method, and audit-field examples.

## Privacy Note

This skill reads git commit metadata and, only when Git's trailer parser returns empty, scans commit bodies for `Co-Authored-By:` trailer lines. It does NOT access:

- File contents or diffs
- Author email addresses (uses display names only)

If your project has confidentiality requirements about AI tool usage, pair this skill with explicit allowlist/denylist of which projects can run it.
