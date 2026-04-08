#!/usr/bin/env bash
# generate-ai-dev-log.sh — Generate AI-assisted development log from git history
#
# Usage:
#   bash scripts/generate-ai-dev-log.sh                    # last 90 days, markdown to stdout
#   bash scripts/generate-ai-dev-log.sh --since 2026-01-01 # custom start date
#   bash scripts/generate-ai-dev-log.sh --out FILE         # write to file
#   bash scripts/generate-ai-dev-log.sh --repo /path/to/dir # custom repo directory
#   bash scripts/generate-ai-dev-log.sh --json             # JSON output
#   bash scripts/generate-ai-dev-log.sh --summary          # one-line stats only
#
# Reads: git log + Co-Authored-By trailers
# Writes: stdout (default) or --out file
# Habit: H4 (Win-Win — honest disclosure) + H1 (Be Proactive — audit-ready)
# Reference: skills/ai-dev-log/SKILL.md

set -euo pipefail

# ─── Dependency check ──────────────────────────────────────────────
for cmd in git awk sort sed wc tr basename mktemp; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "ERROR: Required command not found: $cmd" >&2
    echo "This script needs: git, awk, sort, sed, wc, tr, basename, mktemp" >&2
    exit 2
  fi
done

# ─── Defaults ──────────────────────────────────────────────────────
SINCE="$(date -v-90d +%Y-%m-%d 2>/dev/null || date -d '90 days ago' +%Y-%m-%d 2>/dev/null || echo '')"
if [[ -z "$SINCE" ]]; then
  echo "ERROR: Could not compute default date (need GNU or BSD date). Use --since YYYY-MM-DD" >&2
  exit 2
fi
OUT_FILE=""
FORMAT="markdown"
REPO_DIR="${PWD}"

# ─── Parse args ────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case $1 in
    --since)
      [[ $# -lt 2 ]] && { echo "ERROR: --since requires a date" >&2; exit 2; }
      if ! [[ "$2" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        echo "ERROR: --since must be YYYY-MM-DD format, got: $2" >&2
        exit 2
      fi
      SINCE="$2"; shift 2 ;;
    --out)
      [[ $# -lt 2 ]] && { echo "ERROR: --out requires a file path" >&2; exit 2; }
      OUT_FILE="$2"; shift 2 ;;
    --json) FORMAT="json"; shift ;;
    --summary) FORMAT="summary"; shift ;;
    --repo)
      [[ $# -lt 2 ]] && { echo "ERROR: --repo requires a path" >&2; exit 2; }
      REPO_DIR="$2"; shift 2 ;;
    -h|--help) sed -n '2,15p' "$0"; exit 0 ;;
    *) echo "ERROR: Unknown arg: $1 (use -h for help)" >&2; exit 2 ;;
  esac
done

cd "$REPO_DIR" || { echo "ERROR: Cannot cd to $REPO_DIR" >&2; exit 2; }

# Verify git repo
if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "ERROR: Not a git repository: $REPO_DIR" >&2
  exit 2
fi

# ─── Helpers ───────────────────────────────────────────────────────
# JSON string escape: replace \ → \\, " → \", and strip control chars
json_escape() {
  printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' | tr -d '\000-\037'
}

# AI tool name pattern (case-insensitive via [Cc] expansion for portability)
# Note: stored as fixed string passed to grep -E and awk; no shell-special chars
AI_PATTERN='[Cc]laude|[Gg]pt|[Cc]opilot|[Gg]emini|[Cc]ursor|[Aa]nthropic|[Oo]pen[Aa][Ii]'

# ─── Data extraction (single-pass) ─────────────────────────────────
# Single git log call → temp file → reused by all aggregations (avoids N×git log)
TMP_LOG=$(mktemp -t ai-dev-log.XXXXXX)
trap 'rm -f "$TMP_LOG"' EXIT

git log --since="$SINCE" \
  --format='%h|%ad|%an|%s|%(trailers:key=Co-Authored-By,valueonly)' \
  --date=short > "$TMP_LOG"

# Stats (computed from temp file, no further git calls)
TOTAL_COMMITS=$(wc -l < "$TMP_LOG" | tr -d ' ')
AI_COMMITS=$(awk -F'|' -v p="$AI_PATTERN" '$5 ~ p' "$TMP_LOG" | wc -l | tr -d ' ')

if [[ "$TOTAL_COMMITS" -eq 0 ]]; then
  echo "No commits found since $SINCE." >&2
  exit 0
fi

AI_PCT=$(awk "BEGIN { printf \"%.0f\", ($AI_COMMITS / $TOTAL_COMMITS) * 100 }")
UNIQUE_HUMANS=$(awk -F'|' '{print $3}' "$TMP_LOG" | sort -u | wc -l | tr -d ' ')

# AI co-authors (unique, AI-only)
AI_COAUTHORS=$(awk -F'|' -v p="$AI_PATTERN" '$5 ~ p {print $5}' "$TMP_LOG" | sort -u)

if [[ -z "$AI_COAUTHORS" ]]; then
  echo "No AI co-authors detected since $SINCE." >&2
  echo "Either project uses no AI assistance, or commits lack Co-Authored-By trailers." >&2
  exit 0
fi

REPO_NAME=$(basename "$(git rev-parse --show-toplevel)")
GENERATED=$(date +%Y-%m-%d)

# ─── Summary mode ──────────────────────────────────────────────────
if [[ "$FORMAT" == "summary" ]]; then
  echo "Period: $SINCE → $GENERATED | Total: $TOTAL_COMMITS | AI-assisted: $AI_COMMITS ($AI_PCT%) | Humans: $UNIQUE_HUMANS"
  exit 0
fi

# ─── JSON mode ─────────────────────────────────────────────────────
if [[ "$FORMAT" == "json" ]]; then
  printf '{\n'
  printf '  "period": {"since": "%s", "generated": "%s"},\n' "$SINCE" "$GENERATED"
  printf '  "repo": "%s",\n' "$(json_escape "$REPO_NAME")"
  printf '  "stats": {\n'
  printf '    "total_commits": %d,\n' "$TOTAL_COMMITS"
  printf '    "ai_assisted_commits": %d,\n' "$AI_COMMITS"
  printf '    "ai_percentage": %d,\n' "$AI_PCT"
  printf '    "unique_human_authors": %d\n' "$UNIQUE_HUMANS"
  printf '  },\n'
  printf '  "ai_coauthors": [\n'
  first=1
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    if [[ $first -eq 1 ]]; then first=0; else printf ',\n'; fi
    printf '    "%s"' "$(json_escape "$line")"
  done <<< "$AI_COAUTHORS"
  printf '\n  ],\n'
  printf '  "methodology": "Read from git Co-Authored-By trailers; commits without trailers treated as fully human-authored",\n'
  printf '  "limitations": "Pre-tooling commits or commits with missing trailers will appear human-only"\n'
  printf '}\n'
  exit 0
fi

# ─── Markdown mode (default) ───────────────────────────────────────
# Statistics by month — single awk pass instead of N×git log
MONTH_STATS=$(awk -F'|' -v p="$AI_PATTERN" '
  {
    month = substr($2, 1, 7)
    total[month]++
    if ($5 ~ p) ai[month]++
  }
  END {
    n = 0
    for (m in total) months[++n] = m
    # Sort months ascending
    for (i = 1; i <= n; i++)
      for (j = i+1; j <= n; j++)
        if (months[i] > months[j]) { tmp = months[i]; months[i] = months[j]; months[j] = tmp }
    for (i = 1; i <= n; i++) {
      m = months[i]
      a = ai[m] + 0
      t = total[m]
      pct = (t > 0) ? int((a / t) * 100 + 0.5) : 0
      printf "| %s | %d | %d | %d%% |\n", m, t, a, pct
    }
  }
' "$TMP_LOG")

# Notable AI commits (top 30)
NOTABLE=$(awk -F'|' -v p="$AI_PATTERN" '
  $5 ~ p {
    printf "- **%s** `%s` — %s _(human: %s, ai: %s)_\n", $2, $1, $4, $3, $5
  }
' "$TMP_LOG" | head -30)

OVERFLOW_NOTE=""
if [[ "$AI_COMMITS" -gt 30 ]]; then
  # Leading newline keeps spacing tidy when present; avoids blank line when empty
  OVERFLOW_NOTE=$'\n_(showing 30 of '"$AI_COMMITS"' AI-assisted commits — see git log for full history)_'
fi

OUTPUT=$(cat <<EOF
# AI-Assisted Development Log

**Period**: $SINCE to $GENERATED
**Repo**: $REPO_NAME
**Generated**: $GENERATED by \`scripts/generate-ai-dev-log.sh\`

> ⚠️ Reference: \`skills/ai-dev-log/SKILL.md\` (8-habit-ai-dev plugin)
> Methodology limitations apply — read carefully before using as compliance evidence.

## Summary

- **Total commits**: $TOTAL_COMMITS
- **AI-assisted commits**: $AI_COMMITS ($AI_PCT%)
- **Unique human authors**: $UNIQUE_HUMANS
- **AI co-authors detected**:
$(echo "$AI_COAUTHORS" | sed 's/^/  - /')

## Methodology

This log is generated from \`git log\` Co-Authored-By trailers. The convention: Claude Code (and similar tools) automatically add a Co-Authored-By trailer when authoring commits. Commits without explicit Co-Authored-By markers are treated as fully human-authored.

**Limitations** (be honest about gaps):
- Pre-tooling commits or commits where AI assisted but no trailer was added will appear as human-only
- This log captures **metadata only** — it does not analyze commit message bodies, file diffs, or author identities
- For audit completeness, supplement with: calendar/timesheet records of AI tool usage, IDE telemetry (if available)

## Statistics by Month

| Month | Total commits | AI-assisted | % |
|-------|--------------|-------------|---|
$MONTH_STATS

## Notable AI-Assisted Commits

$NOTABLE
$OVERFLOW_NOTE

## Human Oversight Evidence (Article 14 reference)

- All AI-assisted commits go through git history (auditable + reversible)
- Each AI-authored commit can be reviewed via \`git show <hash>\`
- Branch protection + PR review (if enabled) provides Article 14 ¶4(d) override capability

For full Article 14 compliance evidence, run \`/eu-ai-act-check\` and reference Obligation 6.

---

_Generated by 8-habit-ai-dev v2.3.0_
EOF
)

if [[ -n "$OUT_FILE" ]]; then
  mkdir -p "$(dirname "$OUT_FILE")"
  printf '%s\n' "$OUTPUT" > "$OUT_FILE"
  echo "Written to $OUT_FILE" >&2
else
  printf '%s\n' "$OUTPUT"
fi
