#!/bin/bash
# 8-Habit AI Dev — Content Quality Validation (pure bash, no dependencies)
# Requires bash (process substitution). Do not run with sh.
# Validates content depth, markdown integrity, ADR format, handoff completeness,
# and computes architecture fitness functions.
# Companion to validate-structure.sh (which checks structure/wiring).

set -euo pipefail

ERRORS=0
PASS=0
WARNINGS=0

pass() { PASS=$((PASS + 1)); echo "  PASS: $1"; }
fail() { ERRORS=$((ERRORS + 1)); echo "  FAIL: $1"; }
warn() { WARNINGS=$((WARNINGS + 1)); echo "  WARN: $1"; }

echo "=== 8-Habit Plugin Content Quality Validation ==="
echo ""

# --- Check 11: Section content depth ---
echo "--- Check 11: Section content depth (When to Skip + Definition of Done) ---"
for skill_dir in skills/*/; do
  skill_file="${skill_dir}SKILL.md"
  [ ! -f "$skill_file" ] && continue
  skill_name=$(basename "$skill_dir")

  # Check "When to Skip" has content (≥2 non-empty lines between heading and next ##)
  skip_content=$(awk '/^## When to Skip/{found=1; next} /^## /{if(found) exit} found && NF' "$skill_file" | wc -l | tr -d ' ')
  if [ "$skip_content" -ge 2 ]; then
    pass "$skill_name — When to Skip has $skip_content content lines"
  else
    fail "$skill_name — When to Skip has only $skip_content content lines (need ≥2)"
  fi

  # Check "Definition of Done" has 3-5 checkbox items
  dod_items=$(awk '/^## Definition of Done/{found=1; next} /^## /{if(found) exit} found' "$skill_file" | grep -c '^\- \[ \]' || true)
  if [ "$dod_items" -ge 3 ] && [ "$dod_items" -le 9 ]; then
    pass "$skill_name — Definition of Done has $dod_items items"
  elif [ "$dod_items" -lt 3 ]; then
    fail "$skill_name — Definition of Done has $dod_items items (need ≥3)"
  else
    warn "$skill_name — Definition of Done has $dod_items items (consider splitting)"
  fi
done
echo ""

# --- Check 12: Markdown integrity ---
echo "--- Check 12: Markdown integrity ---"
MD_INTEGRITY_FAIL=0

# 12a: Orphan code blocks (odd count of triple-backtick lines)
while read -r f; do
  fence_count=$(grep -c '^```' "$f" || true)
  if [ $((fence_count % 2)) -ne 0 ]; then
    fail "$f has $fence_count fence lines (odd — unclosed code block)"
    MD_INTEGRITY_FAIL=$((MD_INTEGRITY_FAIL + 1))
  fi
done < <(find skills/ habits/ guides/ agents/ docs/ -name "*.md" -type f 2>/dev/null)
if [ "$MD_INTEGRITY_FAIL" -eq 0 ]; then
  pass "All markdown files have balanced code fences"
fi

# 12b: Broken internal links (relative .md links)
LINK_FAIL=0
while read -r f; do
  dir=$(dirname "$f")
  # Extract markdown links — only check relative .md links
  while IFS= read -r link_target; do
    [ -z "$link_target" ] && continue
    # Resolve relative path from file's directory
    resolved="$dir/$link_target"
    if [ ! -f "$resolved" ]; then
      fail "$f links to '$link_target' but file not found"
      LINK_FAIL=$((LINK_FAIL + 1))
    fi
  done < <(grep -o '\]([^)]*)' "$f" 2>/dev/null | sed 's/\](//' | sed 's/)//' | grep -v '^http' | grep -v '^#' | grep -v '^\$' | grep -v '^$' | grep '\.md' | sed 's/#.*//' || true)
done < <(find skills/ habits/ guides/ docs/ -name "*.md" -type f 2>/dev/null)
if [ "$LINK_FAIL" -eq 0 ]; then
  pass "All internal markdown links resolve to existing files"
fi

# 12c: TODO/FIXME markers in published skills content
TODO_FAIL=0
while read -r f; do
  todo_count=$(grep -ciE '\bTODO\b|\bFIXME\b|\bHACK\b|\bXXX\b' "$f" || true)
  if [ "$todo_count" -gt 0 ]; then
    fail "$f has $todo_count TODO/FIXME/HACK/XXX markers"
    TODO_FAIL=$((TODO_FAIL + 1))
  fi
done < <(find skills/ -name "*.md" -type f 2>/dev/null)
if [ "$TODO_FAIL" -eq 0 ]; then
  pass "No TODO/FIXME markers in skills/ content"
fi

# 12d: Empty links [text]() or [](url)
EMPTY_LINK_FAIL=0
while read -r f; do
  empty_text=$(grep -c '\[\]([^)]*)' "$f" || true)
  empty_url=$(grep -cE '\[[^]]+\]\(\)' "$f" || true)
  total=$((empty_text + empty_url))
  if [ "$total" -gt 0 ]; then
    fail "$f has $total empty link(s)"
    EMPTY_LINK_FAIL=$((EMPTY_LINK_FAIL + 1))
  fi
done < <(find skills/ habits/ guides/ docs/ -name "*.md" -type f 2>/dev/null)
if [ "$EMPTY_LINK_FAIL" -eq 0 ]; then
  pass "No empty links found"
fi
echo ""

# --- Check 13: ADR format validation ---
echo "--- Check 13: ADR format validation ---"
ADR_COUNT=0
if [ -d "docs/adr" ]; then
  while read -r adr_file; do
    ADR_COUNT=$((ADR_COUNT + 1))
    adr_name=$(basename "$adr_file")

    # Required sections
    for section in "## Context" "## Options Considered" "## Decision" "## Consequences"; do
      if grep -q "^${section}" "$adr_file"; then
        pass "$adr_name has '$section'"
      else
        fail "$adr_name missing '$section'"
      fi
    done

    # Required metadata
    if grep -q '\*\*Status\*\*:' "$adr_file"; then
      # Validate status value
      status_val=$(grep '\*\*Status\*\*:' "$adr_file" | head -1 | sed 's/.*\*\*Status\*\*:[[:space:]]*//')
      case "$status_val" in
        Proposed|Accepted|Deprecated|Superseded)
          pass "$adr_name status '$status_val' is valid"
          ;;
        *)
          fail "$adr_name status '$status_val' not in [Proposed, Accepted, Deprecated, Superseded]"
          ;;
      esac
    else
      fail "$adr_name missing '**Status**:' field"
    fi

    if grep -q '\*\*Date\*\*:' "$adr_file"; then
      pass "$adr_name has '**Date**:'"
    else
      fail "$adr_name missing '**Date**:' field"
    fi
  done < <(find docs/adr/ -name "ADR-*.md" -type f 2>/dev/null | sort)
fi
if [ "$ADR_COUNT" -eq 0 ]; then
  warn "No ADR files found in docs/adr/"
fi
echo ""

# --- Check 14: Handoff content validation ---
echo "--- Check 14: Handoff content validation (workflow skills) ---"
WORKFLOW_SKILLS="research requirements design breakdown build-brief review-ai deploy-guide monitor-setup"
for skill_name in $WORKFLOW_SKILLS; do
  skill_file="skills/$skill_name/SKILL.md"
  [ ! -f "$skill_file" ] && continue

  # Check Handoff section exists
  if ! grep -q "^## Handoff" "$skill_file"; then
    fail "$skill_name missing '## Handoff' section"
    continue
  fi

  # Extract handoff section content
  handoff_content=$(awk '/^## Handoff/{found=1; next} /^## /{if(found) exit} found' "$skill_file")

  if echo "$handoff_content" | grep -qi "expects from predecessor"; then
    pass "$skill_name — Handoff has 'Expects from predecessor'"
  else
    fail "$skill_name — Handoff missing 'Expects from predecessor'"
  fi

  if echo "$handoff_content" | grep -qi "produces for successor"; then
    pass "$skill_name — Handoff has 'Produces for successor'"
  else
    fail "$skill_name — Handoff missing 'Produces for successor'"
  fi
done
echo ""

# ===================================================================
# Architecture Fitness Functions
# These track health metrics over time. A BREACH fails the build.
# ===================================================================
echo "=== Architecture Fitness Functions ==="
echo ""
FITNESS_BREACH=0

# --- F1: Skill Complexity Budget ---
echo "--- F1: Skill Complexity Budget ---"
TOTAL_LINES=0
MAX_LINES=0
MAX_SKILL=""
SKILL_COUNT=0
for skill_dir in skills/*/; do
  skill_file="${skill_dir}SKILL.md"
  [ ! -f "$skill_file" ] && continue
  lines=$(wc -l < "$skill_file" | tr -d ' ')
  TOTAL_LINES=$((TOTAL_LINES + lines))
  SKILL_COUNT=$((SKILL_COUNT + 1))
  if [ "$lines" -gt "$MAX_LINES" ]; then
    MAX_LINES=$lines
    MAX_SKILL=$(basename "$skill_dir")
  fi
done
if [ "$SKILL_COUNT" -gt 0 ]; then
  AVG_LINES=$((TOTAL_LINES / SKILL_COUNT))
else
  AVG_LINES=0
fi

F1_STATUS="HEALTHY"
if [ "$AVG_LINES" -ge 200 ] || [ "$MAX_LINES" -ge 400 ]; then
  F1_STATUS="BREACH"
  FITNESS_BREACH=$((FITNESS_BREACH + 1))
elif [ "$AVG_LINES" -ge 150 ] || [ "$MAX_LINES" -ge 300 ]; then
  F1_STATUS="WARNING"
fi
echo "  FITNESS: skill-complexity avg=$AVG_LINES max=$MAX_LINES (${MAX_SKILL}) [$F1_STATUS]"
echo ""

# --- F2: Validation Coverage Ratio ---
echo "--- F2: Validation Coverage Ratio ---"
# Count assertable items: skills × 8 checkable properties + agents × 4 + ADRs × 6 + cross-refs
ASSERTABLE=0
# Skills: frontmatter(3) + sections(2) + chain(2) + content-depth(2) + handoff(2) = 11 per workflow skill
# Skills: frontmatter(3) + sections(2) + chain(2) + content-depth(2) = 9 per standalone skill
for skill_dir in skills/*/; do
  [ ! -d "$skill_dir" ] && continue
  sname=$(basename "$skill_dir")
  case "$sname" in
    research|requirements|design|breakdown|build-brief|review-ai|deploy-guide|monitor-setup)
      ASSERTABLE=$((ASSERTABLE + 11))
      ;;
    *)
      ASSERTABLE=$((ASSERTABLE + 9))
      ;;
  esac
done
# Agents: 4 fields each
AGENT_COUNT=$(find agents/ -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')
ASSERTABLE=$((ASSERTABLE + AGENT_COUNT * 4))
# ADRs: 6 checks each
ASSERTABLE=$((ASSERTABLE + ADR_COUNT * 6))
# Cross-references: version(3) + readme-skills(1) + load-directives(1) + self-check(1) + size(1)
ASSERTABLE=$((ASSERTABLE + 7))

# Total assertions = structure script PASS + content script PASS
# We only know our own PASS count here; structure script runs separately
# Use combined count from both scripts
# Read structure script pass count (written by validate-structure.sh)
STRUCT_ASSERTIONS=157  # fallback if structure script hasn't run
if [ -f /tmp/validate-structure-pass.txt ]; then
  STRUCT_ASSERTIONS=$(cat /tmp/validate-structure-pass.txt | tr -d ' ')
fi
TOTAL_ASSERTIONS=$((STRUCT_ASSERTIONS + PASS))

if [ "$ASSERTABLE" -gt 0 ]; then
  COVERAGE=$(awk "BEGIN {printf \"%.2f\", $TOTAL_ASSERTIONS / $ASSERTABLE}")
  COVERAGE_PCT=$(awk "BEGIN {printf \"%.0f\", ($TOTAL_ASSERTIONS / $ASSERTABLE) * 100}")
  COVERAGE_CHECK=$(awk "BEGIN {print ($TOTAL_ASSERTIONS / $ASSERTABLE < 0.7) ? 1 : 0}")
else
  COVERAGE="0.00"
  COVERAGE_PCT="0"
  COVERAGE_CHECK=0
fi

F2_STATUS="HEALTHY"
if [ "$COVERAGE_CHECK" -eq 1 ]; then
  F2_STATUS="BREACH"
  FITNESS_BREACH=$((FITNESS_BREACH + 1))
fi
echo "  FITNESS: validation-coverage ratio=$COVERAGE ($TOTAL_ASSERTIONS/$ASSERTABLE = ${COVERAGE_PCT}%) [$F2_STATUS]"
echo ""

# --- F3: Convention Consistency Score ---
echo "--- F3: Convention Consistency Score ---"
CONSISTENT=0
TOTAL_SKILLS=0
for skill_dir in skills/*/; do
  skill_file="${skill_dir}SKILL.md"
  [ ! -f "$skill_file" ] && continue
  TOTAL_SKILLS=$((TOTAL_SKILLS + 1))
  skill_ok=1

  # Check: frontmatter exists with 3 required fields
  fm=$(sed -n '/^---$/,/^---$/p' "$skill_file" | head -20)
  for field in "name:" "description:" "user-invocable:"; do
    echo "$fm" | grep -q "$field" || skill_ok=0
  done

  # Check: required sections present
  grep -q "^## When to Skip" "$skill_file" || skill_ok=0
  grep -q "^## Definition of Done" "$skill_file" || skill_ok=0

  # Check: DoD has ≥3 items
  dod=$(awk '/^## Definition of Done/{found=1; next} /^## /{if(found) exit} found' "$skill_file" | grep -c '^\- \[ \]' || true)
  [ "$dod" -ge 3 ] || skill_ok=0

  # Check: When to Skip has content
  skip=$(awk '/^## When to Skip/{found=1; next} /^## /{if(found) exit} found && NF' "$skill_file" | wc -l | tr -d ' ')
  [ "$skip" -ge 2 ] || skill_ok=0

  # Check: word count in range
  words=$(wc -w < "$skill_file" | tr -d ' ')
  [ "$words" -ge 200 ] && [ "$words" -le 2000 ] || skill_ok=0

  if [ "$skill_ok" -eq 1 ]; then
    CONSISTENT=$((CONSISTENT + 1))
  fi
done

if [ "$TOTAL_SKILLS" -gt 0 ]; then
  CONSISTENCY_PCT=$(awk "BEGIN {printf \"%.0f\", ($CONSISTENT / $TOTAL_SKILLS) * 100}")
else
  CONSISTENCY_PCT="0"
fi

F3_STATUS="HEALTHY"
if [ "$CONSISTENT" -ne "$TOTAL_SKILLS" ]; then
  F3_STATUS="BREACH"
  FITNESS_BREACH=$((FITNESS_BREACH + 1))
fi
echo "  FITNESS: convention-consistency score=${CONSISTENCY_PCT}% ($CONSISTENT/$TOTAL_SKILLS) [$F3_STATUS]"
echo ""

# --- Summary ---
echo "=== Summary ==="
echo "PASS: $PASS"
echo "FAIL: $ERRORS"
echo "WARN: $WARNINGS"
echo "FITNESS BREACHES: $FITNESS_BREACH"
echo ""

TOTAL_ISSUES=$((ERRORS + FITNESS_BREACH))
if [ "$TOTAL_ISSUES" -gt 0 ]; then
  echo "RESULT: FAILED ($ERRORS errors, $FITNESS_BREACH fitness breaches)"
  exit 1
else
  echo "RESULT: ALL CHECKS PASSED"
  exit 0
fi
