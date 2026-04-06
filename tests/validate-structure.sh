#!/bin/bash
# 8-Habit AI Dev — Structural Validation (pure bash, no dependencies)
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

# --- Summary ---
echo "=== Summary ==="
echo "PASS: $PASS"
echo "FAIL: $ERRORS"
echo ""

if [ "$ERRORS" -gt 0 ]; then
  echo "RESULT: FAILED ($ERRORS errors)"
  exit 1
else
  echo "RESULT: ALL CHECKS PASSED"
  exit 0
fi
