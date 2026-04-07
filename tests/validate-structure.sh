#!/bin/bash
# 8-Habit AI Dev — Structural Validation (pure bash, no dependencies)
# Requires bash (process substitution). Do not run with sh.
# Validates SKILL.md files, version consistency, and file size limits.

set -euo pipefail

ERRORS=0
PASS=0

pass() { PASS=$((PASS + 1)); echo "  PASS: $1"; }
fail() { ERRORS=$((ERRORS + 1)); echo "  FAIL: $1"; }

echo "=== 8-Habit Plugin Structure Validation ==="
echo ""

# --- Check 1: YAML frontmatter with required fields ---
echo "--- Check 1: YAML frontmatter ---"
for skill_dir in skills/*/; do
  skill_file="${skill_dir}SKILL.md"
  if [ ! -f "$skill_file" ]; then
    fail "$skill_dir — missing SKILL.md"
    continue
  fi

  # Extract frontmatter (between first two --- lines)
  frontmatter=$(sed -n '/^---$/,/^---$/p' "$skill_file" | head -20)

  if [ -z "$frontmatter" ]; then
    fail "$skill_file — no YAML frontmatter found"
    continue
  fi

  # Check required fields
  for field in "name:" "description:" "user-invocable:"; do
    if echo "$frontmatter" | grep -q "$field"; then
      pass "$skill_file has $field"
    else
      fail "$skill_file missing $field"
    fi
  done
done
echo ""

# --- Check 2: name field matches directory ---
echo "--- Check 2: name matches directory ---"
for skill_dir in skills/*/; do
  dir_name=$(basename "$skill_dir")
  skill_file="${skill_dir}SKILL.md"
  [ ! -f "$skill_file" ] && continue

  # Extract name value from frontmatter
  name_value=$(sed -n '/^---$/,/^---$/p' "$skill_file" | grep "^name:" | head -1 | sed 's/^name:[[:space:]]*//')

  if [ "$name_value" = "$dir_name" ]; then
    pass "$skill_file — name '$name_value' matches directory"
  else
    fail "$skill_file — name '$name_value' does not match directory '$dir_name'"
  fi
done
echo ""

# --- Check 3: Required sections ---
echo "--- Check 3: Required sections (When to Skip + Definition of Done) ---"
for skill_dir in skills/*/; do
  skill_file="${skill_dir}SKILL.md"
  [ ! -f "$skill_file" ] && continue

  if grep -q "## When to Skip" "$skill_file"; then
    pass "$skill_file has When to Skip"
  else
    fail "$skill_file missing '## When to Skip'"
  fi

  if grep -q "## Definition of Done" "$skill_file"; then
    pass "$skill_file has Definition of Done"
  else
    fail "$skill_file missing '## Definition of Done'"
  fi
done
echo ""

# --- Check 4: Version consistency ---
echo "--- Check 4: Version consistency across 3 files ---"
v_plugin=$(grep '"version"' .claude-plugin/plugin.json 2>/dev/null | head -1 | sed 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
v_marketplace=$(grep '"version"' .claude-plugin/marketplace.json 2>/dev/null | head -1 | sed 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
v_readme=$(grep 'Version:' README.md 2>/dev/null | head -1 | sed 's/.*Version: \([0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\).*/\1/')

if [ -z "$v_plugin" ] || [ -z "$v_marketplace" ] || [ -z "$v_readme" ]; then
  fail "Could not extract version from one or more files (plugin=$v_plugin, marketplace=$v_marketplace, readme=$v_readme)"
elif [ "$v_plugin" = "$v_marketplace" ] && [ "$v_plugin" = "$v_readme" ]; then
  pass "All 3 files have version $v_plugin"
else
  fail "Version mismatch: plugin.json=$v_plugin, marketplace.json=$v_marketplace, README.md=$v_readme"
fi
echo ""

# --- Check 5: File size limit (800 lines) ---
echo "--- Check 5: File size < 800 lines ---"
SIZE_FAIL=0
while read -r f; do
  lines=$(wc -l < "$f")
  if [ "$lines" -gt 800 ]; then
    fail "$f has $lines lines (limit: 800)"
    SIZE_FAIL=$((SIZE_FAIL + 1))
  fi
done < <(find skills/ habits/ guides/ -name "*.md" -type f)
if [ "$SIZE_FAIL" -eq 0 ]; then
  pass "All markdown files under 800 lines"
fi
echo ""

# --- Check 6: prev-skill/next-skill fields exist ---
echo "--- Check 6: prev-skill/next-skill frontmatter ---"
for skill_dir in skills/*/; do
  skill_file="${skill_dir}SKILL.md"
  [ ! -f "$skill_file" ] && continue
  frontmatter=$(sed -n '/^---$/,/^---$/p' "$skill_file")

  if echo "$frontmatter" | grep -q "prev-skill:"; then
    pass "$skill_file has prev-skill"
  else
    fail "$skill_file missing prev-skill"
  fi

  if echo "$frontmatter" | grep -q "next-skill:"; then
    pass "$skill_file has next-skill"
  else
    fail "$skill_file missing next-skill"
  fi
done
echo ""

# --- Check 7: Handoff chain validation ---
echo "--- Check 7: Handoff chain consistency ---"
EXPECTED_CHAIN="research:requirements requirements:design design:breakdown breakdown:build-brief build-brief:review-ai review-ai:deploy-guide deploy-guide:monitor-setup"
CHAIN_FAIL=0
for pair in $EXPECTED_CHAIN; do
  from="${pair%%:*}"
  to="${pair##*:}"
  from_next=$(sed -n '/^---$/,/^---$/p' "skills/$from/SKILL.md" 2>/dev/null | grep "^next-skill:" | head -1 | sed 's/^next-skill:[[:space:]]*//')
  to_prev=$(sed -n '/^---$/,/^---$/p' "skills/$to/SKILL.md" 2>/dev/null | grep "^prev-skill:" | head -1 | sed 's/^prev-skill:[[:space:]]*//')

  if [ "$from_next" = "$to" ] && [ "$to_prev" = "$from" ]; then
    pass "$from → $to chain valid"
  else
    fail "$from → $to chain broken (${from}.next=$from_next, ${to}.prev=$to_prev)"
    CHAIN_FAIL=$((CHAIN_FAIL + 1))
  fi
done
# Standalone skills should use "any" or "none"
for standalone in cross-verify whole-person-check security-check reflect workflow; do
  skill_file="skills/$standalone/SKILL.md"
  [ ! -f "$skill_file" ] && continue
  prev=$(sed -n '/^---$/,/^---$/p' "$skill_file" | grep "^prev-skill:" | head -1 | sed 's/^prev-skill:[[:space:]]*//')
  if [ "$prev" = "any" ] || [ "$prev" = "none" ]; then
    pass "$standalone prev-skill=$prev (standalone OK)"
  else
    fail "$standalone prev-skill=$prev (expected 'any' or 'none')"
  fi
done
echo ""

# --- Check 8: Load directive resolution ---
echo "--- Check 8: Load directives resolve to existing files ---"
LOAD_FAIL=0
while read -r skill_file; do
  while read -r ref_path; do
    if [ ! -f "$ref_path" ]; then
      fail "$skill_file references '$ref_path' but file not found"
      LOAD_FAIL=$((LOAD_FAIL + 1))
    fi
  done < <(grep 'Load `\${CLAUDE_PLUGIN_ROOT}/' "$skill_file" 2>/dev/null | sed 's/.*\${CLAUDE_PLUGIN_ROOT}\///' | sed 's/`.*//')
done < <(find skills/ -name "SKILL.md" -type f)
if [ "$LOAD_FAIL" -eq 0 ]; then
  pass "All Load directives resolve to existing files"
fi
echo ""

# --- Check 9: Word count guardrails (warning only) ---
echo "--- Check 9: Word count guardrails ---"
for skill_dir in skills/*/; do
  skill_file="${skill_dir}SKILL.md"
  [ ! -f "$skill_file" ] && continue
  words=$(wc -w < "$skill_file" | tr -d ' ')
  if [ "$words" -lt 200 ]; then
    echo "  WARN: $skill_file has $words words (consider 200+ for completeness)"
  elif [ "$words" -gt 2000 ]; then
    echo "  WARN: $skill_file has $words words (consider splitting or moving detail to references/)"
  else
    pass "$skill_file word count OK ($words words)"
  fi
done
echo ""

# --- Check 10: SELF-CHECK.md version matches plugin ---
echo "--- Check 10: SELF-CHECK.md version matches plugin ---"
if [ -f "SELF-CHECK.md" ]; then
  v_selfcheck=$(grep 'Version' SELF-CHECK.md 2>/dev/null | head -1 | sed 's/.*Version[^0-9]*\([0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\).*/\1/')
  if [ "$v_selfcheck" = "$v_plugin" ]; then
    pass "SELF-CHECK.md version $v_selfcheck matches plugin"
  else
    fail "SELF-CHECK.md version $v_selfcheck does not match plugin $v_plugin"
  fi
else
  fail "SELF-CHECK.md not found"
fi
echo ""

# --- Check 11: allowed-tools field validation ---
echo "--- Check 11: allowed-tools values are valid tool names ---"
VALID_TOOLS="Read Glob Grep Bash WebSearch WebFetch Agent Edit Write"
TOOLS_FAIL=0
for skill_dir in skills/*/; do
  skill_file="${skill_dir}SKILL.md"
  [ ! -f "$skill_file" ] && continue
  skill_name=$(basename "$skill_dir")

  tools_line=$(sed -n '/^---$/,/^---$/p' "$skill_file" | grep "^allowed-tools:" | head -1)
  if [ -z "$tools_line" ]; then
    fail "$skill_name — missing allowed-tools field"
    TOOLS_FAIL=$((TOOLS_FAIL + 1))
    continue
  fi

  # Extract tool names from JSON-like array: ["Read", "Glob"] → Read Glob
  tools=$(echo "$tools_line" | sed 's/^allowed-tools:[[:space:]]*//' | tr -d '[]"' | tr ',' ' ')
  all_valid=1
  for tool in $tools; do
    tool=$(echo "$tool" | tr -d ' ')
    [ -z "$tool" ] && continue
    if ! echo "$VALID_TOOLS" | grep -qw "$tool"; then
      fail "$skill_name — unknown tool '$tool' in allowed-tools"
      TOOLS_FAIL=$((TOOLS_FAIL + 1))
      all_valid=0
    fi
  done
  if [ "$all_valid" -eq 1 ]; then
    pass "$skill_name — all allowed-tools valid"
  fi
done
echo ""

# --- Check 12: README skills table cross-reference ---
echo "--- Check 12: README ↔ skills directory cross-reference ---"
# Extract skill directory names
DIR_SKILLS=""
for skill_dir in skills/*/; do
  [ ! -d "$skill_dir" ] && continue
  DIR_SKILLS="$DIR_SKILLS $(basename "$skill_dir")"
done

# Extract skill names from README table rows matching | `/skill-name`
README_SKILLS=""
while IFS= read -r line; do
  sname=$(echo "$line" | sed -n 's/.*`\/\([a-z-]*\)`.*/\1/p')
  [ -n "$sname" ] && README_SKILLS="$README_SKILLS $sname"
done < <(grep '| `/[a-z]' README.md 2>/dev/null)
# Deduplicate
README_SKILLS=$(echo "$README_SKILLS" | tr ' ' '\n' | sort -u | tr '\n' ' ')

XREF_FAIL=0
# Check: every directory skill is in README
for s in $DIR_SKILLS; do
  if ! echo "$README_SKILLS" | grep -qw "$s"; then
    fail "Skill '$s' exists as directory but missing from README"
    XREF_FAIL=$((XREF_FAIL + 1))
  fi
done
# Check: every README skill has a directory
for s in $README_SKILLS; do
  if ! echo "$DIR_SKILLS" | grep -qw "$s"; then
    fail "Skill '$s' listed in README but no skills/$s/ directory"
    XREF_FAIL=$((XREF_FAIL + 1))
  fi
done
if [ "$XREF_FAIL" -eq 0 ]; then
  pass "README skills table matches skills/ directories ($(echo "$DIR_SKILLS" | wc -w | tr -d ' ') skills)"
fi
echo ""

# --- Check 13: Agent definition validation ---
echo "--- Check 13: Agent definition validation ---"
AGENT_FAIL=0
if [ -d "agents" ]; then
  while read -r agent_file; do
    agent_name=$(basename "$agent_file")
    frontmatter=$(sed -n '/^---$/,/^---$/p' "$agent_file" | head -20)

    if [ -z "$frontmatter" ]; then
      fail "$agent_name — no YAML frontmatter"
      AGENT_FAIL=$((AGENT_FAIL + 1))
      continue
    fi

    # Required fields
    for field in "name:" "description:" "model:" "tools:"; do
      if echo "$frontmatter" | grep -q "$field"; then
        pass "$agent_name has $field"
      else
        fail "$agent_name missing $field"
        AGENT_FAIL=$((AGENT_FAIL + 1))
      fi
    done

    # Validate model value
    model_val=$(echo "$frontmatter" | grep "^model:" | head -1 | sed 's/^model:[[:space:]]*//')
    case "$model_val" in
      sonnet|opus|haiku)
        pass "$agent_name model '$model_val' is valid"
        ;;
      *)
        fail "$agent_name model '$model_val' not in [sonnet, opus, haiku]"
        AGENT_FAIL=$((AGENT_FAIL + 1))
        ;;
    esac
  done < <(find agents/ -name "*.md" -type f 2>/dev/null | sort)
fi
echo ""

# --- Summary ---
echo "=== Summary ==="
echo "PASS: $PASS"
echo "FAIL: $ERRORS"
echo ""

# Export pass count for validate-content.sh fitness function F2
echo "$PASS" > /tmp/validate-structure-pass.txt

if [ "$ERRORS" -gt 0 ]; then
  echo "RESULT: FAILED ($ERRORS errors)"
  exit 1
else
  echo "RESULT: ALL CHECKS PASSED"
  exit 0
fi
