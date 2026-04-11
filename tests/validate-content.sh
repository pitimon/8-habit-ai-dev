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

# --- Check 15: v2.3.0 EU AI Act Compliance Toolkit content ---
echo "--- Check 15: v2.3.0 EU AI Act compliance toolkit content ---"

# 15a: Research artifact has all 9 obligations + Verified Quotes
EU_RESEARCH="docs/research/eu-ai-act-obligations.md"
if [ -f "$EU_RESEARCH" ]; then
  for art in 9 10 11 12 13 14 15; do
    if grep -q "^## .*Article $art\b\|Art\. $art " "$EU_RESEARCH"; then
      pass "$EU_RESEARCH covers Article $art"
    else
      fail "$EU_RESEARCH missing Article $art coverage"
    fi
  done
  verified_quotes=$(grep -c '^\*\*Verified Quote' "$EU_RESEARCH" || true)
  if [ "$verified_quotes" -ge 7 ]; then
    pass "$EU_RESEARCH has $verified_quotes Verified Quote blocks (≥7 expected)"
  else
    fail "$EU_RESEARCH has only $verified_quotes Verified Quote blocks (need ≥7)"
  fi
  if grep -q "NOT LEGAL ADVICE\|not legal advice" "$EU_RESEARCH"; then
    pass "$EU_RESEARCH has NOT LEGAL ADVICE disclaimer"
  else
    fail "$EU_RESEARCH missing NOT LEGAL ADVICE disclaimer"
  fi
else
  fail "$EU_RESEARCH not found"
fi

# 15b: User-facing mapping guide has bootstrap + disclaimer
EU_GUIDE="guides/eu-ai-act-mapping.md"
if [ -f "$EU_GUIDE" ]; then
  if grep -q "NOT LEGAL ADVICE" "$EU_GUIDE"; then
    pass "$EU_GUIDE has NOT LEGAL ADVICE disclaimer"
  else
    fail "$EU_GUIDE missing NOT LEGAL ADVICE disclaimer"
  fi
  if grep -q "mkdir -p docs/compliance/eu-ai-act" "$EU_GUIDE"; then
    pass "$EU_GUIDE has bootstrap mkdir block"
  else
    fail "$EU_GUIDE missing bootstrap mkdir block"
  fi
else
  fail "$EU_GUIDE not found"
fi

# 15c: /eu-ai-act-check skill — tier counts match Tier Summary table
EU_SKILL="skills/eu-ai-act-check/SKILL.md"
if [ -f "$EU_SKILL" ]; then
  must_count=$(grep -c '^- \[ \] \*\*\[MUST\]\*\*' "$EU_SKILL" || true)
  should_count=$(grep -c '^- \[ \] \*\*\[SHOULD\]\*\*' "$EU_SKILL" || true)
  could_count=$(grep -c '^- \[ \] \*\*\[COULD\]\*\*' "$EU_SKILL" || true)
  total_count=$((must_count + should_count + could_count))

  # Tier Summary table claimed counts (extract from table rows)
  must_claimed=$(awk '/^### Tier Summary/{found=1} found && /\*\*MUST\*\*/{print $4; exit}' "$EU_SKILL" || echo 0)
  should_claimed=$(awk '/^### Tier Summary/{found=1} found && /\*\*SHOULD\*\*/{print $4; exit}' "$EU_SKILL" || echo 0)
  could_claimed=$(awk '/^### Tier Summary/{found=1} found && /\*\*COULD\*\*/{print $4; exit}' "$EU_SKILL" || echo 0)

  if [ "$must_count" -eq "$must_claimed" ]; then
    pass "$EU_SKILL MUST tier: actual=$must_count matches claimed=$must_claimed"
  else
    fail "$EU_SKILL MUST tier mismatch: actual=$must_count vs claimed=$must_claimed in Tier Summary"
  fi
  if [ "$should_count" -eq "$should_claimed" ]; then
    pass "$EU_SKILL SHOULD tier: actual=$should_count matches claimed=$should_claimed"
  else
    fail "$EU_SKILL SHOULD tier mismatch: actual=$should_count vs claimed=$should_claimed"
  fi
  if [ "$could_count" -eq "$could_claimed" ]; then
    pass "$EU_SKILL COULD tier: actual=$could_count matches claimed=$could_claimed"
  else
    fail "$EU_SKILL COULD tier mismatch: actual=$could_count vs claimed=$could_claimed"
  fi

  # Article paragraph references
  para_refs=$(grep -c '¶' "$EU_SKILL" || true)
  if [ "$para_refs" -ge 30 ]; then
    pass "$EU_SKILL has $para_refs paragraph references (≥30 expected)"
  else
    fail "$EU_SKILL has only $para_refs paragraph references (need ≥30)"
  fi

  # Scope pre-flight present
  if grep -q "Step 0.*Scope Pre-Flight\|--scope" "$EU_SKILL"; then
    pass "$EU_SKILL has Step 0 scope pre-flight"
  else
    fail "$EU_SKILL missing scope pre-flight"
  fi
else
  fail "$EU_SKILL not found"
fi

# 15d: /ai-dev-log skill references the generator script
AI_LOG_SKILL="skills/ai-dev-log/SKILL.md"
if [ -f "$AI_LOG_SKILL" ]; then
  if grep -q "scripts/generate-ai-dev-log.sh" "$AI_LOG_SKILL"; then
    pass "$AI_LOG_SKILL references generator script"
  else
    fail "$AI_LOG_SKILL missing reference to generator script"
  fi
  if grep -q "Privacy Note" "$AI_LOG_SKILL"; then
    pass "$AI_LOG_SKILL has Privacy Note section"
  else
    fail "$AI_LOG_SKILL missing Privacy Note"
  fi
else
  fail "$AI_LOG_SKILL not found"
fi

# 15e: generate-ai-dev-log.sh script — strict mode + dependency check + executable
SCRIPT="scripts/generate-ai-dev-log.sh"
if [ -f "$SCRIPT" ]; then
  if [ -x "$SCRIPT" ]; then
    pass "$SCRIPT is executable"
  else
    fail "$SCRIPT is not executable"
  fi
  if grep -q "set -euo pipefail" "$SCRIPT"; then
    pass "$SCRIPT uses strict mode"
  else
    fail "$SCRIPT missing 'set -euo pipefail'"
  fi
  if grep -q "command -v" "$SCRIPT"; then
    pass "$SCRIPT has dependency check"
  else
    fail "$SCRIPT missing dependency check"
  fi
  if grep -q "trap.*EXIT" "$SCRIPT"; then
    pass "$SCRIPT has tempfile cleanup trap"
  else
    fail "$SCRIPT missing cleanup trap"
  fi
else
  fail "$SCRIPT not found"
fi

# 15f: /design Article 14 checkpoint integrated as Step 5
DESIGN_SKILL="skills/design/SKILL.md"
if [ -f "$DESIGN_SKILL" ]; then
  if grep -q "Article 14 Human-Oversight Checkpoint\|¶4(a)\|¶4(e)" "$DESIGN_SKILL"; then
    pass "$DESIGN_SKILL has Article 14 checkpoint"
  else
    fail "$DESIGN_SKILL missing Article 14 checkpoint"
  fi
fi

echo ""

# --- Check 16: v2.4.1 audience honesty (HABIT_QUIET opt-out + Core 5 tier + /brainstorm removal) ---
echo "--- Check 16: v2.4.1 audience honesty (opt-out + Core 5 + brainstorm deletion) ---"
HOOK="hooks/session-start.sh"
if [ -f "$HOOK" ]; then
  if grep -q 'HABIT_QUIET' "$HOOK"; then
    pass "$HOOK references HABIT_QUIET opt-out"
  else
    fail "$HOOK missing HABIT_QUIET opt-out"
  fi
  if grep -qE 'HABIT_QUIET.*==.*1.*exit 0|HABIT_QUIET.*1.*&&.*exit' "$HOOK"; then
    pass "$HOOK honors HABIT_QUIET=1 with early exit"
  else
    fail "$HOOK missing HABIT_QUIET=1 early exit guard"
  fi
  if grep -q "Core 5" "$HOOK"; then
    pass "$HOOK surfaces the Core 5 tier"
  else
    fail "$HOOK missing Core 5 reference"
  fi
  if grep -q "not Vibe Coding" "$HOOK"; then
    fail "$HOOK still has religious 'not Vibe Coding' framing"
  else
    pass "$HOOK framing softened (no 'not Vibe Coding')"
  fi
  if grep -q "/brainstorm" "$HOOK"; then
    fail "$HOOK still references /brainstorm"
  else
    pass "$HOOK no /brainstorm reference"
  fi
else
  fail "$HOOK not found"
fi

# /brainstorm skill must be deleted
if [ -d "skills/brainstorm" ]; then
  fail "skills/brainstorm/ should be removed in v2.4.1"
else
  pass "skills/brainstorm/ deleted (v2.4.1 honest correction)"
fi

# using-8-habits meta-skill surfaces Core 5
META="skills/using-8-habits/SKILL.md"
if [ -f "$META" ]; then
  if grep -q "Core 5" "$META"; then
    pass "$META has Core 5 tier section"
  else
    fail "$META missing Core 5 tier section"
  fi
  if grep -q "superpowers:brainstorming" "$META"; then
    pass "$META references superpowers:brainstorming"
  else
    fail "$META missing superpowers:brainstorming pointer"
  fi
fi

# /research skill points at Superpowers for fuzzy problems
RESEARCH_SKILL="skills/research/SKILL.md"
if [ -f "$RESEARCH_SKILL" ]; then
  if grep -q "superpowers:brainstorming" "$RESEARCH_SKILL"; then
    pass "$RESEARCH_SKILL references superpowers:brainstorming for fuzzy problems"
  else
    fail "$RESEARCH_SKILL missing superpowers:brainstorming pointer"
  fi
fi

# ADR-006 exists
ADR006="docs/adr/ADR-006-audience-honesty-and-superpowers-deferral.md"
if [ -f "$ADR006" ]; then
  pass "$ADR006 exists"
else
  fail "$ADR006 not found"
fi

echo ""

# --- Check 17: EARS-notation in /requirements skill + guide ---
echo "--- Check 17: EARS-notation in /requirements ---"
REQ_SKILL="skills/requirements/SKILL.md"
EARS_GUIDE="guides/ears-notation.md"
if [ -f "$REQ_SKILL" ]; then
  if grep -q "EARS" "$REQ_SKILL"; then
    pass "$REQ_SKILL mentions EARS"
  else
    fail "$REQ_SKILL missing EARS reference"
  fi
  # All 5 EARS shape keywords present in skill
  for shape in "Ubiquitous" "Event-driven" "State-driven" "Unwanted" "Optional"; do
    if grep -q "$shape" "$REQ_SKILL"; then
      pass "$REQ_SKILL mentions EARS shape '$shape'"
    else
      fail "$REQ_SKILL missing EARS shape '$shape'"
    fi
  done
  # Opt-out rule for small features
  if grep -qi "opt.?out\|skip EARS\|fewer than 3\|<3" "$REQ_SKILL"; then
    pass "$REQ_SKILL documents EARS opt-out rule"
  else
    fail "$REQ_SKILL missing EARS opt-out rule"
  fi
else
  fail "$REQ_SKILL not found"
fi

if [ -f "$EARS_GUIDE" ]; then
  pass "$EARS_GUIDE exists"
  # All 5 EARS shapes in guide
  for shape in "Ubiquitous" "Event-driven" "State-driven" "Unwanted" "Optional"; do
    if grep -q "### .*$shape" "$EARS_GUIDE"; then
      pass "$EARS_GUIDE has section for '$shape' shape"
    else
      fail "$EARS_GUIDE missing section for '$shape' shape"
    fi
  done
  # Worked login example (both before and after)
  if grep -qi "login" "$EARS_GUIDE"; then
    pass "$EARS_GUIDE has login worked example"
  else
    fail "$EARS_GUIDE missing worked example"
  fi
else
  fail "$EARS_GUIDE not found"
fi

echo ""

# --- Check 18: /using-8-habits meta-skill (onboarding) ---
echo "--- Check 18: /using-8-habits meta-skill ---"
META_SKILL="skills/using-8-habits/SKILL.md"
if [ -f "$META_SKILL" ]; then
  pass "$META_SKILL exists"
  # Frontmatter: meta-skill is a starting point
  if grep -qE '^prev-skill:\s*none' "$META_SKILL"; then
    pass "$META_SKILL prev-skill is 'none'"
  else
    fail "$META_SKILL prev-skill should be 'none'"
  fi
  # Content: explains workflow + decision tree + all skills
  for keyword in "7-step workflow" "decision tree" "workflow skill" "assessment skill" "Covey" "Whole Person"; do
    if grep -qi "$keyword" "$META_SKILL"; then
      pass "$META_SKILL mentions '$keyword'"
    else
      fail "$META_SKILL missing '$keyword'"
    fi
  done
  # Must mention every current skill (anti-drift assertion)
  # Use /skill-name pattern to anchor (skill names preceded by slash)
  for skill_dir in skills/*/; do
    skill_name=$(basename "$skill_dir")
    # Skip the meta-skill referencing itself
    [ "$skill_name" = "using-8-habits" ] && continue
    if grep -q "/$skill_name\b" "$META_SKILL"; then
      pass "$META_SKILL mentions /$skill_name"
    else
      fail "$META_SKILL missing mention of /$skill_name (anti-drift assertion)"
    fi
  done
  # Cross-linked from README + CLAUDE.md
  if grep -q "/using-8-habits" README.md; then
    pass "README.md cross-links to /using-8-habits"
  else
    fail "README.md missing /using-8-habits cross-link"
  fi
  if grep -q "/using-8-habits" CLAUDE.md; then
    pass "CLAUDE.md cross-links to /using-8-habits"
  else
    fail "CLAUDE.md missing /using-8-habits cross-link"
  fi
else
  fail "$META_SKILL not found"
fi

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
  # Use awk (not sed|head) to avoid SIGPIPE under set -o pipefail when
  # head closes stdout early — same fix pattern as validate-structure.sh:27.
  # Triggered by skills/ai-dev-log/SKILL.md body `---` horizontal rule at
  # line 65 which makes `sed -n '/^---$/,/^---$/p'` emit 187 lines (12
  # frontmatter + 175 body-past-rule), overflowing head -20 and causing
  # GNU sed exit 4 "couldn't flush stdout: Broken pipe" on Linux CI while
  # BSD sed on macOS silently ignores SIGPIPE → intermittent CI failure.
  fm=$(awk '/^---$/{c++; print; if(c==2) exit; next} c==1' "$skill_file")
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
