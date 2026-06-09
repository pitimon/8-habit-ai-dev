# AI Development Log Reference

Detailed process reference for `/ai-dev-log`. The main `SKILL.md` keeps the invocation path short; this file explains the script internals and output shape for audits or customization.

## Process Details

### Step 1 — Discover AI Co-Authors

```bash
# Find all unique AI co-authors in git history.
# The generator uses Git's trailer parser first and falls back to commit-body
# Co-Authored-By lines only when the parser returns empty for a commit.
git log --format='%(trailers:key=Co-Authored-By,valueonly)' \
  | grep -iE "claude|gpt|copilot|gemini|cursor|anthropic|openai" \
  | sort -u
```

If empty, skip this skill because no AI involvement was detected from trailers.

### Step 2 — Extract AI-Assisted Commits

```bash
# All commits with any Co-Authored-By trailer at a pinned snapshot boundary
SNAPSHOT_SHA="${SNAPSHOT:-$(git rev-parse HEAD)}"
git log "$SNAPSHOT_SHA" --since="${SINCE:-2024-01-01}" \
  --format='%h|%ad|%an|%s|%(trailers:key=Co-Authored-By,valueonly)' \
  --date=short \
  | awk -F'|' '$5 != ""' \
  > /tmp/ai-commits.txt

wc -l /tmp/ai-commits.txt
```

### Step 3 — Group by Time Period

Aggregate by week or month for readability. Example group format:

```markdown
## Period: 2026-Q1 (Jan-Mar)

### Statistics

- Total commits: 47
- AI-assisted commits: 31 (66%)
- Unique human authors: 3
- AI co-authors detected: claude-opus-4.6, claude-sonnet-4.6

### Notable AI-assisted work

- 2026-01-15: feat(auth): add OAuth2 PKCE flow -- human: itarun.p, AI: Claude Opus 4.6
- 2026-02-03: refactor(api): split monolith handler -- human: itarun.p, AI: Claude Sonnet 4.6
- 2026-03-12: feat(eu-ai-act): compliance toolkit -- human: itarun.p, AI: Claude Opus 4.6
```

### Step 4 — Add Human Oversight Evidence

For each AI-assisted commit, document:

- Was it reviewed in PR by another human? Check `gh pr view <pr> --json reviews`.
- Were tests added or updated? Check the diff for test files.
- Was it merged via PR rather than direct push? This supports Article 14 oversight evidence.

### Step 5 — Generate Markdown Report

Default output: `docs/compliance/ai-dev-log/YYYY-Q[1-4].md`

```markdown
# AI-Assisted Development Log

**Period**: [start] to [end]
**Repo**: [name]
**Generated**: YYYY-MM-DD by `/ai-dev-log`
**Snapshot boundary**: [HEAD sha used for this report]

## Summary

- Total commits in period: [N]
- AI-assisted commits: [N] ([%])
- Human authors: [list]
- AI models detected: [list]

## Methodology

This log is generated from `git log` Co-Authored-By trailers at a pinned snapshot boundary per the convention that Claude Code and similar tools use when authoring commits. The generator uses Git's trailer parser first, then scans commit bodies only for valid `Co-Authored-By:` lines when the parser returns empty. Commits without explicit Co-Authored-By markers are treated as fully human-authored.

**Limitation**: Pre-tooling commits or commits where AI assisted but no trailer was added will appear as human-only. For audit, supplement this log with calendar records, timesheets, IDE telemetry if available, and project memory.

## Statistics by Month

| Month | Total commits | AI-assisted | % | Models used |
| ----- | ------------- | ----------- | - | ----------- |
| 2026-01 | 18 | 12 | 67% | Claude Opus 4.6 |
| 2026-02 | 15 | 9 | 60% | Claude Opus 4.6, Sonnet 4.6 |
| 2026-03 | 14 | 10 | 71% | Claude Opus 4.6 |

## Notable AI-Assisted Changes

### YYYY-MM-DD: [feature/fix description]

- **Commit**: [hash]
- **Human**: [name]
- **AI**: [model]
- **PR**: #[number] (reviewed by [name])
- **Tests added**: [yes/no]
- **Why notable**: [1-line context]

## Human Oversight Evidence

- All AI-assisted commits went through git history.
- [N]% were merged via PR.
- [N]% were reviewed by at least one human reviewer in PR.
- Test coverage delta: [+/- %]

## Models Used in Period

- **Claude Opus 4.6**: [N] commits, primary use case [coding/review/research]
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

Document the gap in the report's Methodology section. Honesty about what is measurable and what is inferred is more valuable than fake completeness.
