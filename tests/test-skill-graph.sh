#!/bin/bash
# 8-Habit AI Dev — Skill Graph DAG Validator
# Validates prev-skill/next-skill chains form a consistent directed acyclic graph.
# Checks: cycles, dangling refs, symmetric edges, chain start/end, orphans.
#
# Compatible with bash 3.x (macOS default) — no associative arrays.
# Usage: bash tests/test-skill-graph.sh
# Called from .github/workflows/validate.yml

set -euo pipefail

ERRORS=0
PASS=0
WARNINGS=0

pass() { PASS=$((PASS + 1)); echo "  PASS: $1"; }
fail() { ERRORS=$((ERRORS + 1)); echo "  FAIL: $1"; }
warn() { WARNINGS=$((WARNINGS + 1)); echo "  WARN: $1"; }

echo "=== Skill Graph DAG Validation ==="
echo ""

# --- Step 1: Extract graph into temp file ---
echo "--- Step 1: Extract skill graph ---"

GRAPH_FILE=$(mktemp)
trap 'rm -f "$GRAPH_FILE"' EXIT

TOTAL=0
for skill_dir in skills/*/; do
  skill_file="${skill_dir}SKILL.md"
  [ ! -f "$skill_file" ] && continue

  name=$(basename "$skill_dir")

  prev=$(sed -n '/^---$/,/^---$/{ s/^prev-skill:[[:space:]]*//p; }' "$skill_file" | head -1 | tr -d '[:space:]')
  next=$(sed -n '/^---$/,/^---$/{ s/^next-skill:[[:space:]]*//p; }' "$skill_file" | head -1 | tr -d '[:space:]')

  if [ -z "$prev" ]; then
    fail "$name: missing prev-skill in frontmatter"
    prev="MISSING"
  fi
  if [ -z "$next" ]; then
    fail "$name: missing next-skill in frontmatter"
    next="MISSING"
  fi

  echo "$name $prev $next" >> "$GRAPH_FILE"
  TOTAL=$((TOTAL + 1))
done

echo "  Found $TOTAL skills"
echo ""

# Helper: lookup prev for a skill
get_prev() { awk -v s="$1" '$1 == s { print $2 }' "$GRAPH_FILE"; }
get_next() { awk -v s="$1" '$1 == s { print $3 }' "$GRAPH_FILE"; }
skill_exists() { awk -v s="$1" '$1 == s { found=1 } END { exit !found }' "$GRAPH_FILE"; }

# --- Step 2: Dangling references ---
echo "--- Step 2: Dangling references ---"

while read -r name prev next; do
  for field_name in prev next; do
    ref=$(eval echo "\$$field_name")
    field_label="${field_name}-skill"
    if [ "$ref" = "none" ] || [ "$ref" = "any" ] || [ "$ref" = "MISSING" ]; then
      [ "$ref" != "MISSING" ] && pass "$name: $field_label '$ref' valid"
    elif skill_exists "$ref"; then
      pass "$name: $field_label '$ref' valid"
    else
      fail "$name: $field_label '$ref' references non-existent skill"
    fi
  done
done < "$GRAPH_FILE"
echo ""

# --- Step 3: Symmetric edges ---
echo "--- Step 3: Symmetric edges ---"

while read -r name prev next; do
  # If A says next-skill: B, then B should say prev-skill: A (or 'any')
  if [ "$next" != "none" ] && [ "$next" != "any" ] && [ "$next" != "MISSING" ]; then
    target_prev=$(get_prev "$next")
    if [ "$target_prev" = "$name" ] || [ "$target_prev" = "any" ]; then
      pass "$name → $next: symmetric (target prev=$target_prev)"
    else
      fail "$name says next-skill: $next, but $next says prev-skill: ${target_prev:-MISSING} (expected '$name' or 'any')"
    fi
  fi

  # If A says prev-skill: B, then B should say next-skill: A (or 'any')
  if [ "$prev" != "none" ] && [ "$prev" != "any" ] && [ "$prev" != "MISSING" ]; then
    target_next=$(get_next "$prev")
    if [ "$target_next" = "$name" ] || [ "$target_next" = "any" ]; then
      pass "$prev → $name: symmetric (source next=$target_next)"
    else
      fail "$name says prev-skill: $prev, but $prev says next-skill: ${target_next:-MISSING} (expected '$name' or 'any')"
    fi
  fi
done < "$GRAPH_FILE"
echo ""

# --- Step 4: Chain anchors ---
echo "--- Step 4: Chain anchors ---"

HAS_START=false
HAS_END=false

while read -r name prev next; do
  [ "$prev" = "none" ] && [ "$next" != "none" ] && [ "$next" != "any" ] && HAS_START=true
  [ "$next" = "none" ] && [ "$prev" != "none" ] && [ "$prev" != "any" ] && HAS_END=true
done < "$GRAPH_FILE"

if $HAS_START; then
  pass "At least one chain-start skill exists (prev-skill: none + concrete next)"
else
  fail "No chain-start skill found"
fi

if $HAS_END; then
  pass "At least one chain-end skill exists (next-skill: none + concrete prev)"
else
  fail "No chain-end skill found"
fi
echo ""

# --- Step 5: Cycle detection (walk each chain from start nodes) ---
echo "--- Step 5: Cycle detection ---"

CYCLE_FOUND=false
VISITED_FILE=$(mktemp)
trap 'rm -f "$GRAPH_FILE" "$VISITED_FILE"' EXIT

# Walk forward from each skill following next-skill edges
while read -r start_name _ _; do
  : > "$VISITED_FILE"
  current="$start_name"
  while [ -n "$current" ] && [ "$current" != "none" ] && [ "$current" != "any" ] && [ "$current" != "MISSING" ]; do
    if grep -qx "$current" "$VISITED_FILE" 2>/dev/null; then
      fail "Cycle detected: chain from $start_name revisits $current"
      CYCLE_FOUND=true
      break
    fi
    echo "$current" >> "$VISITED_FILE"
    current=$(get_next "$current")
  done
done < "$GRAPH_FILE"

if ! $CYCLE_FOUND; then
  pass "No cycles detected in skill graph"
fi
echo ""

# --- Step 6: Orphan detection ---
echo "--- Step 6: Orphan detection ---"

while read -r name prev next; do
  if [ "$prev" = "none" ] && [ "$next" = "none" ]; then
    # Check if any other skill references this one
    if grep -qE "^[^ ]+ $name | $name$" "$GRAPH_FILE" 2>/dev/null && \
       [ "$(grep -cE " $name( |$)" "$GRAPH_FILE")" -gt 0 ]; then
      # Exclude self-references
      refs=$(awk -v s="$name" '$1 != s && ($2 == s || $3 == s)' "$GRAPH_FILE" | wc -l | tr -d ' ')
      if [ "$refs" -gt 0 ]; then
        warn "$name: prev=none, next=none but referenced by other skills"
      else
        pass "$name: standalone (prev=none, next=none, unreferenced)"
      fi
    else
      pass "$name: standalone (prev=none, next=none, unreferenced)"
    fi
  elif [ "$prev" = "any" ] && [ "$next" = "any" ]; then
    pass "$name: standalone assessment skill (any/any)"
  fi
done < "$GRAPH_FILE"
echo ""

# --- Summary ---
echo "=== Summary ==="
echo "Skills: $TOTAL"
echo "PASS: $PASS"
echo "FAIL: $ERRORS"
echo "WARN: $WARNINGS"
echo ""

if [ "$ERRORS" -gt 0 ]; then
  echo "RESULT: FAILED ($ERRORS errors)"
  exit 1
else
  echo "RESULT: ALL CHECKS PASSED"
  exit 0
fi
