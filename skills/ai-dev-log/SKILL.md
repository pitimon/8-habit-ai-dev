---
name: ai-dev-log
description: >
  Generate AI-assisted development log from git history + Co-Authored-By trailers.
  Use for EU AI Act Article 11 (technical documentation) audit trail and AI transparency.
  Maps to H4 (Win-Win — honest disclosure) + H1 (Be Proactive — audit-ready).
user-invocable: true
argument-hint: "[--since YYYY-MM-DD] [--repo path] [--out file]"
allowed-tools: ["Read", "Glob", "Grep", "Bash"]
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

# JSON for CI ingestion
bash ${CLAUDE_PLUGIN_ROOT}/scripts/generate-ai-dev-log.sh --json

# One-line stats
bash ${CLAUDE_PLUGIN_ROOT}/scripts/generate-ai-dev-log.sh --summary
```

The script handles all 6 process steps below (discover → extract → group → oversight → report → fallback). Read the script source if you want to customize: `scripts/generate-ai-dev-log.sh`

The detailed process below is for **understanding** what the script does, not for manual execution.

---

## Process (script reference)

### Step 1 — Discover AI Co-Authors

```bash
# Find all unique AI co-authors in git history
git log --format='%(trailers:key=Co-Authored-By,valueonly)' \
  | grep -iE "claude|gpt|copilot|gemini|cursor|anthropic|openai" \
  | sort -u
```

If empty → skip this skill (no AI involvement detected).

### Step 2 — Extract AI-Assisted Commits

```bash
# All commits with any Co-Authored-By trailer
git log --since="${SINCE:-2024-01-01}" \
  --format='%h|%ad|%an|%s|%(trailers:key=Co-Authored-By,valueonly)' \
  --date=short \
  | awk -F'|' '$5 != ""' \
  > /tmp/ai-commits.txt

wc -l /tmp/ai-commits.txt
```

### Step 3 — Group by Time Period

Aggregate by week/month for readability. Group format:

```
## Period: 2026-Q1 (Jan-Mar)

### Statistics
- Total commits: 47
- AI-assisted commits: 31 (66%)
- Unique human authors: 3
- AI co-authors detected: claude-opus-4.6, claude-sonnet-4.6

### Notable AI-assisted work
- 2026-01-15: feat(auth): add OAuth2 PKCE flow — human: itarun.p, AI: Claude Opus 4.6
- 2026-02-03: refactor(api): split monolith handler — human: itarun.p, AI: Claude Sonnet 4.6
- 2026-03-12: feat(eu-ai-act): compliance toolkit — human: itarun.p, AI: Claude Opus 4.6
```

### Step 4 — Add Human Oversight Evidence

For each AI-assisted commit, document:

- Was it reviewed in PR by another human? (check `gh pr view <pr> --json reviews`)
- Were tests added/updated? (check diff for test files)
- Was it merged via PR (not direct push)? (Article 14 ¶4(d) — override capability)

### Step 5 — Generate Markdown Report

Default output: `docs/compliance/ai-dev-log/YYYY-Q[1-4].md`

Template:

```markdown
# AI-Assisted Development Log

**Period**: [start] to [end]
**Repo**: [name]
**Generated**: YYYY-MM-DD by `/ai-dev-log`

## Summary

- Total commits in period: [N]
- AI-assisted commits: [N] ([%])
- Human authors: [list]
- AI models detected: [list]

## Methodology

This log is generated from `git log` Co-Authored-By trailers per the convention that Claude Code (and similar tools) automatically add when authoring commits. Trailers without explicit Co-Authored-By markers are treated as fully human-authored.

**Limitation**: Pre-tooling commits or commits where AI assisted but no trailer was added will appear as human-only. For audit, supplement this log with:

- Calendar/timesheet records of AI tool usage
- IDE telemetry (if available)
- Memory of "rough month" (subjective)

## Statistics by Month

| Month   | Total commits | AI-assisted | %   | Models used                 |
| ------- | ------------- | ----------- | --- | --------------------------- |
| 2026-01 | 18            | 12          | 67% | Claude Opus 4.6             |
| 2026-02 | 15            | 9           | 60% | Claude Opus 4.6, Sonnet 4.6 |
| 2026-03 | 14            | 10          | 71% | Claude Opus 4.6             |

## Notable AI-Assisted Changes

[Selected commits with significant AI contribution, manually annotated for clarity]

### YYYY-MM-DD: [feature/fix description]

- **Commit**: [hash]
- **Human**: [name]
- **AI**: [model]
- **PR**: #[number] (reviewed by [name])
- **Tests added**: [yes/no]
- **Why notable**: [1-line context]

## Human Oversight Evidence (Article 14 reference)

- All AI-assisted commits went through git history (auditable)
- [N]% were merged via PR (not direct push to main)
- [N]% were reviewed by ≥1 human reviewer in PR
- Test coverage delta: [+/- %]

## Models Used in Period

- **Claude Opus 4.6 (1M context)**: [N] commits, primary use case [coding/review/research]
- **Claude Sonnet 4.6**: [N] commits, primary use case [refactoring/docs]
```

### Step 6 — Fallback for Missing Trailers

If many commits lack Co-Authored-By trailers but you know AI was used:

```bash
# Identify potentially AI-assisted commits by author pattern + commit message style
git log --format='%h|%ad|%an|%s' --date=short --since="$SINCE" \
  | grep -iE "feat|fix|refactor" \
  > /tmp/possibly-ai.txt
```

Document the gap in the report's Methodology section. Honesty about what's measurable and what's inferred is more valuable than fake completeness.

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
- **Produces for successor**: AI development log file. Used as evidence for `/eu-ai-act-check` Obligation 3 (Technical Documentation).

## Definition of Done

- [ ] Time period defined (default: last quarter)
- [ ] AI co-authors discovered from git trailers
- [ ] Statistics calculated (total/AI-assisted/percentages)
- [ ] Notable changes annotated with PR/review/test evidence
- [ ] Methodology section discloses limitations honestly
- [ ] Output saved to `docs/compliance/ai-dev-log/`
- [ ] H4 + H1 checkpoint answered

## References

- EU AI Act Article 11 (Technical Documentation) — `${CLAUDE_PLUGIN_ROOT}/docs/research/eu-ai-act-obligations.md`
- EU AI Act Article 13 ¶3(d) (Disclosure of human oversight measures)
- Habit details: `${CLAUDE_PLUGIN_ROOT}/habits/h4-win-win.md`, `${CLAUDE_PLUGIN_ROOT}/habits/h1-be-proactive.md`

## Privacy Note

This skill reads git commit metadata only. It does NOT access:

- Commit message bodies (only first line/title)
- File contents or diffs
- Author email addresses (uses display names only)

If your project has confidentiality requirements about AI tool usage, pair this skill with explicit allowlist/denylist of which projects can run it.
