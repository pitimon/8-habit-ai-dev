#!/bin/bash
# 8-Habit AI Dev — Structural Validation (pure bash, no dependencies)
# Requires bash (process substitution). Do not run with sh.
# Validates SKILL.md files, version consistency, and file size limits.

set -euo pipefail

ERRORS=0
PASS=0
CODEX_INSTALLED_CACHE=0
case "$(pwd -P)" in
  */.codex/plugins/cache/*)
    CODEX_INSTALLED_CACHE=1
    ;;
esac

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
  # Use awk (not sed|head) to avoid SIGPIPE under set -o pipefail when
  # head closes stdout early on fast exits — caused intermittent CI failures.
  frontmatter=$(awk '/^---$/{c++; print; if(c==2) exit; next} c==1' "$skill_file")

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
  # awk (no pipe) avoids SIGPIPE under set -o pipefail when head closes early — see Check 1 header comment
  name_value=$(awk '/^---$/{c++; if(c==2) exit; next} c==1 && sub(/^name:[[:space:]]*/, ""){print; exit}' "$skill_file")

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
echo "--- Check 4: Version consistency across 5 manifests/docs ---"
v_plugin=$(grep '"version"' .claude-plugin/plugin.json 2>/dev/null | head -1 | sed 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
v_marketplace=$(grep '"version"' .claude-plugin/marketplace.json 2>/dev/null | head -1 | sed 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
v_codex=$(grep '"version"' .codex-plugin/plugin.json 2>/dev/null | head -1 | sed 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
v_codex_child=$(grep '"version"' plugin/.codex-plugin/plugin.json 2>/dev/null | head -1 | sed 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
v_readme=$(grep 'Version:' README.md 2>/dev/null | head -1 | sed 's/.*Version: \([0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\).*/\1/')

if [ -z "$v_codex_child" ] && [ "$CODEX_INSTALLED_CACHE" -eq 1 ]; then
  v_codex_child="$v_codex"
fi

if [ -z "$v_plugin" ] || [ -z "$v_marketplace" ] || [ -z "$v_codex" ] || [ -z "$v_codex_child" ] || [ -z "$v_readme" ]; then
  fail "Could not extract version from one or more files (claude=$v_plugin, marketplace=$v_marketplace, codex=$v_codex, codex_child=$v_codex_child, readme=$v_readme)"
elif [ "$v_plugin" = "$v_marketplace" ] && [ "$v_plugin" = "$v_codex" ] && [ "$v_plugin" = "$v_codex_child" ] && [ "$v_plugin" = "$v_readme" ]; then
  pass "All 5 manifests/docs have version $v_plugin"
else
  fail "Version mismatch: claude plugin.json=$v_plugin, claude marketplace.json=$v_marketplace, codex plugin.json=$v_codex, codex child plugin.json=$v_codex_child, README.md=$v_readme"
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

# --- Check 5b: Bash tooling size limit (1500 lines) — documented exemption (#343 B1) ---
# The 800-line rule (Check 5) is a READABILITY budget for CONTENT files (skills/habits/guides)
# that a reader grasps in one sitting. Bash validators and scripts are LINEAR TOOLING (check
# suites, sync helpers) where that budget does not fit — but they must still be BOUNDED so they
# cannot grow without limit. This is a DOCUMENTED, ENFORCED exemption, not a silent self-exemption
# (closes the enforce-on-others-skip-on-self gap the Fable review + adversarial Spirit pass
# flagged). Supersedes the v2.14.3 (#163) "trim to <800" approach: that trim regressed
# (validate-content 793->1012, validate-structure 605->1164), proving trim-alone is not durable
# as checks accrete. The 1500 cap is an UPPER BOUND that prevents unbounded growth — not a
# maintainability target; four-digit validators are tolerated for tooling, but approaching 1500
# should trigger extracting sourced helpers. Scope: tests/ scripts/ hooks/ (root). The plugin/
# mirrors of hooks/ + scripts/ are byte-identical (Check 28), so they are transitively covered;
# tests/ is intentionally not mirrored. `find` is used instead of `git ls-files` because this
# validator also runs from non-git installed caches.
echo "--- Check 5b: Bash tooling <= 1500 lines (documented exemption from the 800 content limit, #343 B1) ---"
SIZE_FAIL_BASH=0
while read -r f; do
  lines=$(wc -l < "$f")
  if [ "$lines" -gt 1500 ]; then
    fail "$f has $lines lines (bash-tooling limit: 1500 — see Check 5b comment)"
    SIZE_FAIL_BASH=$((SIZE_FAIL_BASH + 1))
  fi
done < <(find tests/ scripts/ hooks/ -name "*.sh" -type f)
if [ "$SIZE_FAIL_BASH" -eq 0 ]; then
  pass "All bash tooling <= 1500 lines (documented exemption from 800 content limit, #343 B1)"
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
  from_next=$(awk '/^---$/{c++; if(c==2) exit; next} c==1 && sub(/^next-skill:[[:space:]]*/, ""){print; exit}' "skills/$from/SKILL.md" 2>/dev/null)
  to_prev=$(awk '/^---$/{c++; if(c==2) exit; next} c==1 && sub(/^prev-skill:[[:space:]]*/, ""){print; exit}' "skills/$to/SKILL.md" 2>/dev/null)

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
  prev=$(awk '/^---$/{c++; if(c==2) exit; next} c==1 && sub(/^prev-skill:[[:space:]]*/, ""){print; exit}' "$skill_file")
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

# Check 8b: Load directive portability (issue #308, review F1/F2).
# A backticked Load target that starts with / or ~ is an absolute path from the
# author's machine — it silently fails to load for every other installer and may
# leak local usernames. Every Load path must be ${CLAUDE_PLUGIN_ROOT}-relative,
# which is also what makes Check 8's existence check above able to see it.
LOAD_ABS_FAIL=0
while read -r skill_file; do
  while read -r abs_line; do
    fail "$skill_file has a non-portable Load directive (absolute path, must use \${CLAUDE_PLUGIN_ROOT}/): $abs_line"
    LOAD_ABS_FAIL=$((LOAD_ABS_FAIL + 1))
  done < <(grep -oE 'Load `(/|~)[^`]*`' "$skill_file" 2>/dev/null)
done < <(find skills/ -name "SKILL.md" -type f)
if [ "$LOAD_ABS_FAIL" -eq 0 ]; then
  pass "All Load directives are \${CLAUDE_PLUGIN_ROOT}-relative (no absolute paths)"
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

# --- Check 9b: Sibling reference/examples soft word budget (F6, ADR-009) ---
# Hard existence check is already covered by Check 8 (Load directive resolution).
# This check warns (not fails) when sibling files grow unbounded.
echo "--- Check 9b: Sibling reference/examples word budget (F6) ---"
SIBLING_SOFT_LIMIT=5000
for sibling in skills/*/reference.md skills/*/examples.md; do
  [ ! -f "$sibling" ] && continue
  words=$(wc -w < "$sibling" | tr -d ' ')
  if [ "$words" -gt "$SIBLING_SOFT_LIMIT" ]; then
    echo "  WARN: $sibling has $words words (soft limit $SIBLING_SOFT_LIMIT — consider further split)"
  else
    pass "$sibling word count OK ($words words)"
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
VALID_TOOLS="Read Glob Grep Bash WebSearch WebFetch Agent Edit Write AskUserQuestion"
TOOLS_FAIL=0
for skill_dir in skills/*/; do
  skill_file="${skill_dir}SKILL.md"
  [ ! -f "$skill_file" ] && continue
  skill_name=$(basename "$skill_dir")

  tools_line=$(awk '/^---$/{c++; if(c==2) exit; next} c==1 && /^allowed-tools:/{print; exit}' "$skill_file")
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
  # Anchor to the first table column (^| `/skill`) — a greedy `.*`\/...` would
  # match the LAST `/skill` reference in a row that mentions several, picking the
  # wrong skill name (Issue #214, surfaced via /diagnose dogfood on PR #213).
  sname=$(echo "$line" | sed -n 's/^| *`\/\([a-z0-9-]*\)`.*/\1/p')
  [ -n "$sname" ] && README_SKILLS="$README_SKILLS $sname"
done < <(grep '| `/[a-z]' README.md 2>/dev/null)
# Deduplicate
README_SKILLS=$(echo "$README_SKILLS" | tr ' ' '\n' | sort -u | tr '\n' ' ')

# Regression fixture for Issue #214: a row mentioning 3 skills must yield the
# FIRST-column skill, not the last. Fails loudly if the greedy regex regresses.
_c12_row='| `/firstskill` | H1 | mentions `/secondskill` and `/thirdskill` |'
_c12_got=$(echo "$_c12_row" | sed -n 's/^| *`\/\([a-z0-9-]*\)`.*/\1/p')
if [ "$_c12_got" = "firstskill" ]; then
  pass "Check 12 regex anchored to first column (Issue #214 regression guard)"
else
  fail "Check 12 regex regressed (#214): picked '$_c12_got' instead of 'firstskill'"
fi

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
    # awk (no pipe) avoids SIGPIPE; bound to 20 content lines to match prior `head -20` cap
    frontmatter=$(awk '/^---$/{c++; print; if(c==2) exit; next} c==1 {print; if(++n>=20) exit}' "$agent_file")

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

# --- Check 14: Wiki skeleton integrity (ADR-004) ---
echo "Check 14: Wiki skeleton (docs/wiki/)"
if [ -d "docs/wiki" ]; then
  REQUIRED_WIKI_PAGES=(
    "Home.md"
    "_Sidebar.md"
    "_Footer.md"
    "Getting-Started.md"
    "Installation.md"
    "Workflow-Overview.md"
    "Step-0-Research.md"
    "Step-1-Requirements.md"
    "Step-2-Design.md"
    "Step-3-Breakdown.md"
    "Step-4-Build-Brief.md"
    "Step-5-Review-AI.md"
    "Step-6-Deploy-Guide.md"
    "Step-7-Monitor-Setup.md"
    "Habits-Reference.md"
    "Skills-Reference.md"
    "Limitations.md"
    "Vibe-Coding-vs-Structured.md"
    "FAQ.md"
    "Troubleshooting.md"
    "Contributing-to-Wiki.md"
    "Changelog.md"
  )
  for page in "${REQUIRED_WIKI_PAGES[@]}"; do
    path="docs/wiki/$page"
    if [ ! -f "$path" ]; then
      fail "Wiki page missing: $path"
      continue
    fi
    case "$page" in
      _Sidebar.md|_Footer.md)
        pass "$path exists"
        ;;
      *)
        if head -n 5 "$path" | grep -qE '^# '; then
          pass "$path exists with H1"
        else
          fail "$path missing top-level H1 heading"
        fi
        ;;
    esac
  done

  # Cross-check every wiki-internal link in every page (wiki-style: [text](Page-Name))
  WIKI_LINK_FAIL=0
  for f in docs/wiki/*.md; do
    [ -f "$f" ] || continue
    while IFS= read -r link; do
      [ -z "$link" ] && continue
      page="${link%%#*}"  # strip anchor fragment
      [ -z "$page" ] && continue
      target="docs/wiki/${page}.md"
      if [ ! -f "$target" ]; then
        fail "$f links to non-existent wiki page: $page"
        WIKI_LINK_FAIL=$((WIKI_LINK_FAIL + 1))
      fi
    done < <(grep -oE '\]\([^)]+\)' "$f" \
              | sed -E 's/^\]\(([^)]+)\)$/\1/' \
              | grep -Ev '^(https?://|mailto:|#)')
  done
  if [ "$WIKI_LINK_FAIL" -eq 0 ]; then
    pass "All wiki-internal links resolve to existing pages"
  fi
else
  fail "docs/wiki/ directory missing"
fi
echo ""

# --- Check 15a: pre-commit.sh.example template ---
echo "--- Check 15a: pre-commit.sh.example ---"
PRECOMMIT="hooks/pre-commit.sh.example"
if [ -f "$PRECOMMIT" ]; then
  pass "$PRECOMMIT exists"
  if [ -x "$PRECOMMIT" ]; then
    fail "$PRECOMMIT should NOT be executable (prevents accidental auto-install)"
  else
    pass "$PRECOMMIT is not executable"
  fi
  if head -1 "$PRECOMMIT" | grep -q '^#!/bin/bash'; then
    pass "$PRECOMMIT has bash shebang"
  else
    fail "$PRECOMMIT missing bash shebang"
  fi
else
  fail "$PRECOMMIT not found"
fi
echo ""

# --- Check 15b: Bidirectional wiki ↔ skills linking ---
echo "--- Check 15: Wiki ↔ Skills bidirectional linking ---"
WIKI_SKILL_MAP="
Step-0-Research:research
Step-1-Requirements:requirements
Step-2-Design:design
Step-3-Breakdown:breakdown
Step-4-Build-Brief:build-brief
Step-5-Review-AI:review-ai
Step-6-Deploy-Guide:deploy-guide
Step-7-Monitor-Setup:monitor-setup
"
for pair in $WIKI_SKILL_MAP; do
  wiki_page=$(echo "$pair" | cut -d: -f1)
  skill_name=$(echo "$pair" | cut -d: -f2)
  wiki_file="docs/wiki/${wiki_page}.md"
  skill_file="skills/${skill_name}/SKILL.md"

  # Wiki → Skill (forward link)
  if [ -f "$wiki_file" ] && [ -f "$skill_file" ]; then
    if grep -q "$skill_name" "$wiki_file"; then
      pass "$wiki_page → $skill_name (wiki links to skill)"
    else
      fail "$wiki_file missing reference to $skill_name"
    fi

    # Skill → Wiki (back-reference via Further Reading)
    if grep -q "$wiki_page" "$skill_file"; then
      pass "$skill_name → $wiki_page (skill links back to wiki)"
    else
      fail "$skill_file missing back-reference to $wiki_page"
    fi
  fi
done
echo ""

# --- Check 20: skills/RESOLVER.md bidirectional cross-reference (ADR-010) ---
echo "--- Check 20: skills/RESOLVER.md ↔ skills/ bidirectional cross-reference ---"
RESOLVER_FILE="skills/RESOLVER.md"
RESOLVER_FAIL=0

if [ ! -f "$RESOLVER_FILE" ]; then
  fail "Check 20 FAIL: skills/RESOLVER.md is required but not found"
  RESOLVER_FAIL=1
else
  # Extract skill names cited in RESOLVER via skills/<name>/SKILL.md pattern.
  # Uses the same sed-based extraction idiom as Check 12 for consistency.
  RESOLVER_SKILLS=""
  while IFS= read -r line; do
    sname=$(echo "$line" | sed -n 's|.*skills/\([a-z0-9-]\{1,\}\)/SKILL\.md.*|\1|p')
    [ -n "$sname" ] && RESOLVER_SKILLS="$RESOLVER_SKILLS $sname"
  done < "$RESOLVER_FILE"
  RESOLVER_SKILLS=$(echo "$RESOLVER_SKILLS" | tr ' ' '\n' | sort -u | tr '\n' ' ')

  # Collect actual skill directories (reuse DIR_SKILLS pattern from Check 12).
  DIR_SKILLS_R=""
  for skill_dir in skills/*/; do
    [ ! -d "$skill_dir" ] && continue
    DIR_SKILLS_R="$DIR_SKILLS_R $(basename "$skill_dir")"
  done

  # Forward: every skill directory must appear in RESOLVER.
  for s in $DIR_SKILLS_R; do
    if ! echo "$RESOLVER_SKILLS" | grep -qw "$s"; then
      fail "Skill '$s' exists as directory but missing from skills/RESOLVER.md"
      RESOLVER_FAIL=$((RESOLVER_FAIL + 1))
    fi
  done

  # Reverse: every RESOLVER-cited path must resolve to an existing skill directory.
  for s in $RESOLVER_SKILLS; do
    if [ ! -f "skills/$s/SKILL.md" ]; then
      fail "skills/RESOLVER.md cites non-existent skill path: skills/$s/SKILL.md"
      RESOLVER_FAIL=$((RESOLVER_FAIL + 1))
    fi
  done

  if [ "$RESOLVER_FAIL" -eq 0 ]; then
    pass "skills/RESOLVER.md matches skills/ directories ($(echo "$DIR_SKILLS_R" | wc -w | tr -d ' ') skills)"
  fi
fi
echo ""

# --- Check 21: Cross-agent discoverability (ADR-011) ---
echo "--- Check 21: llms.txt + AGENTS.md cross-agent discoverability ---"
CROSS_AGENT_FAIL=0

# Existence — both files are required at repo root (EARS #4).
for f in llms.txt AGENTS.md; do
  if [ ! -f "$f" ]; then
    fail "Check 21 FAIL: $f is required at repo root but not found"
    CROSS_AGENT_FAIL=$((CROSS_AGENT_FAIL + 1))
  fi
done

# Pointer integrity — only run if both files exist (avoids cascade noise).
# Uses grep -q (BSD-safe; no sed/awk per ADR-011 portability constraint).
if [ -f AGENTS.md ] && [ -f llms.txt ]; then
  if ! grep -q 'skills/RESOLVER.md' AGENTS.md; then
    fail "AGENTS.md missing pointer to skills/RESOLVER.md"
    CROSS_AGENT_FAIL=$((CROSS_AGENT_FAIL + 1))
  fi
  if ! grep -q 'CLAUDE.md' AGENTS.md; then
    fail "AGENTS.md missing pointer to CLAUDE.md"
    CROSS_AGENT_FAIL=$((CROSS_AGENT_FAIL + 1))
  fi
  if ! grep -q 'AGENTS.md' llms.txt; then
    fail "llms.txt missing pointer to AGENTS.md"
    CROSS_AGENT_FAIL=$((CROSS_AGENT_FAIL + 1))
  fi
  if ! grep -q 'skills/RESOLVER.md' llms.txt; then
    fail "llms.txt missing pointer to skills/RESOLVER.md"
    CROSS_AGENT_FAIL=$((CROSS_AGENT_FAIL + 1))
  fi
  if [ "$CROSS_AGENT_FAIL" -eq 0 ]; then
    pass "llms.txt + AGENTS.md exist with all required pointers intact"
  fi
fi
echo ""

# --- Check 22: SKILL_OUTPUT attribution lines (Issue #151) ---
# Each emitter must have an attribution line directly above its `<!-- SKILL_OUTPUT:` opener
# Format: [/<skill-name>] (COMPLETE|PARTIAL|FAILED) SKILL_OUTPUT:<type>
# Uses grep -B1 only (BSD-safe; no sed/awk per ADR-011 portability constraint)
echo "--- Check 22: SKILL_OUTPUT attribution lines ---"
ATTR_FAIL=0

for entry in "skills/design/SKILL.md:design" \
             "skills/breakdown/SKILL.md:breakdown" \
             "skills/requirements/SKILL.md:requirements" \
             "skills/review-ai/SKILL.md:review"; do
  file="${entry%:*}"
  type="${entry##*:}"
  if [ ! -f "$file" ]; then
    fail "Check 22: emitter file $file not found"
    ATTR_FAIL=$((ATTR_FAIL + 1))
    continue
  fi
  # Get the line directly above the opener via grep -B1; head -1 yields the preceding line
  attr_text=$(grep -B1 "^<!-- SKILL_OUTPUT:${type}\$" "$file" | head -1)
  # If grep returned nothing (empty) or returned the opener itself (no preceding line in file), fail
  if [ -z "$attr_text" ] || [ "$attr_text" = "<!-- SKILL_OUTPUT:${type}" ]; then
    fail "Check 22: $file missing '<!-- SKILL_OUTPUT:${type}' opener or has no preceding line"
    ATTR_FAIL=$((ATTR_FAIL + 1))
    continue
  fi
  # Validate attribution format
  if ! echo "$attr_text" | grep -qE '^\[/[a-z-]+\] (COMPLETE|PARTIAL|FAILED) SKILL_OUTPUT:[a-z-]+$'; then
    fail "Check 22: $file attribution line malformed (got: '$attr_text')"
    ATTR_FAIL=$((ATTR_FAIL + 1))
  fi
done

if [ "$ATTR_FAIL" -eq 0 ]; then
  pass "SKILL_OUTPUT attribution lines present and well-formed (4 emitters)"
fi
echo ""

# --- Check 23: /save-spec skill canonical contract pins ---
# Pin Decision-7 (8-step Process) + Decision-8 (frontmatter array) + canonical-string
# phrases (Decision-3 refusal + Decision-4 error) per docs/specs/save-spec/design.md.
# Drift in any of these requires a new /design cycle (sticky decision).
echo "--- Check 23: /save-spec skill canonical contract pins ---"
SAVE_SPEC="skills/save-spec/SKILL.md"
SAVE_SPEC_REF="skills/save-spec/reference.md"
SAVE_SPEC_FAIL=0

if [ ! -f "$SAVE_SPEC" ]; then
  fail "Check 23: $SAVE_SPEC missing"
  SAVE_SPEC_FAIL=$((SAVE_SPEC_FAIL + 1))
else
  # Frontmatter pins
  if ! grep -q '^name: save-spec$' "$SAVE_SPEC"; then
    fail "Check 23: $SAVE_SPEC frontmatter name != save-spec"
    SAVE_SPEC_FAIL=$((SAVE_SPEC_FAIL + 1))
  fi
  if ! grep -q '^user-invocable: true$' "$SAVE_SPEC"; then
    fail "Check 23: $SAVE_SPEC frontmatter user-invocable != true"
    SAVE_SPEC_FAIL=$((SAVE_SPEC_FAIL + 1))
  fi
  if ! grep -qE '^allowed-tools: \["Read", "Write", "Glob", "AskUserQuestion"\]$' "$SAVE_SPEC"; then
    fail "Check 23: $SAVE_SPEC allowed-tools != [Read, Write, Glob, AskUserQuestion]"
    SAVE_SPEC_FAIL=$((SAVE_SPEC_FAIL + 1))
  fi
  if ! grep -q '^prev-skill: any$' "$SAVE_SPEC"; then
    fail "Check 23: $SAVE_SPEC prev-skill != any"
    SAVE_SPEC_FAIL=$((SAVE_SPEC_FAIL + 1))
  fi
  if ! grep -q '^next-skill: any$' "$SAVE_SPEC"; then
    fail "Check 23: $SAVE_SPEC next-skill != any"
    SAVE_SPEC_FAIL=$((SAVE_SPEC_FAIL + 1))
  fi
  # Decision-7: 8-step Process count
  process_steps=$(awk '/^## Process/,/^## [^P]/' "$SAVE_SPEC" | grep -cE '^[0-9]+\. \*\*' || true)
  if [ "$process_steps" -ne 8 ]; then
    fail "Check 23: $SAVE_SPEC Process section has $process_steps steps (Decision-7 pins 8)"
    SAVE_SPEC_FAIL=$((SAVE_SPEC_FAIL + 1))
  fi
fi

if [ ! -f "$SAVE_SPEC_REF" ]; then
  fail "Check 23: $SAVE_SPEC_REF missing"
  SAVE_SPEC_FAIL=$((SAVE_SPEC_FAIL + 1))
else
  # Decision-3 canonical first-line phrase (refusal — lives in reference.md per design)
  if ! grep -q 'SPEC.md already exists at' "$SAVE_SPEC_REF"; then
    fail "Check 23: $SAVE_SPEC_REF missing Decision-3 refusal phrase 'SPEC.md already exists at'"
    SAVE_SPEC_FAIL=$((SAVE_SPEC_FAIL + 1))
  fi
  # Decision-4 canonical first-line phrase (error — lives in reference.md per design)
  if ! grep -q 'Tried to create SPEC.md at' "$SAVE_SPEC_REF"; then
    fail "Check 23: $SAVE_SPEC_REF missing Decision-4 error phrase 'Tried to create SPEC.md at'"
    SAVE_SPEC_FAIL=$((SAVE_SPEC_FAIL + 1))
  fi
  # Decision-2 documentation pin (skip-sentinels list must be present)
  if ! grep -q '^Skip-sentinels:' "$SAVE_SPEC_REF"; then
    fail "Check 23: $SAVE_SPEC_REF missing 'Skip-sentinels:' pin (Decision-2)"
    SAVE_SPEC_FAIL=$((SAVE_SPEC_FAIL + 1))
  fi
fi

if [ "$SAVE_SPEC_FAIL" -eq 0 ]; then
  pass "/save-spec canonical contract pins intact (frontmatter, 8-step Process, refusal + error phrases, skip-sentinels)"
fi
echo ""

# --- Check 24: disable-model-invocation field value validation (FR-002) ---
# When the disable-model-invocation field is present in a SKILL.md frontmatter,
# its value MUST be a YAML boolean: "true" or "false" (no quotes, lowercase).
# Field is OPTIONAL — skills without it pass; the check only validates value
# when the field IS declared. Per anthropics/claude-code#22345 (OPEN) the field
# is currently honored only for user-defined skills (not plugin skills); declaring
# it stays well-formed for when #22345 closes. See ADR-014.
echo "--- Check 24: disable-model-invocation field value validation ---"
DMI_FAIL=0
for skill_dir in skills/*/; do
  skill_file="${skill_dir}SKILL.md"
  [ ! -f "$skill_file" ] && continue
  skill_name=$(basename "$skill_dir")

  dmi_value=$(awk '/^---$/{c++; if(c==2) exit; next} c==1 && sub(/^disable-model-invocation:[[:space:]]*/, ""){print; exit}' "$skill_file")
  if [ -z "$dmi_value" ]; then
    continue  # field not declared — OK, it's optional
  fi
  if [ "$dmi_value" = "true" ] || [ "$dmi_value" = "false" ]; then
    pass "$skill_name — disable-model-invocation: $dmi_value (valid boolean)"
  else
    fail "$skill_name — disable-model-invocation: '$dmi_value' is not a YAML boolean (true|false)"
    DMI_FAIL=$((DMI_FAIL + 1))
  fi
done
if [ "$DMI_FAIL" -eq 0 ]; then
  pass "all disable-model-invocation declarations are well-formed booleans"
fi
echo ""

# --- Check 25: SKILL.md description rubric (FR-003) ---
# Per skill, the description field MUST satisfy:
#   (a) collapsed length <= 1024 chars (Anthropic SKILL.md description budget)
#   (b) contains at least one trigger phrase from the empirically-grounded set:
#       Use when | Use AFTER | Use BEFORE | Use to | Use for | Use as
#       Read this first | Assess | migrated
# The trigger-phrase set was derived from a 2026-05-20 audit of all 19 skills
# (P5 sweep, Decision-1 in docs/specs/mattpocock-t1-v2-17-0/design.md) — all
# 19 currently pass at activation time. Check activates as a forward guardrail
# against regression, not as a fix for observed weakness (zero drift at start).
echo "--- Check 25: SKILL.md description rubric (≤1024 chars + trigger phrase) ---"
RUBRIC_FAIL=0
for skill_dir in skills/*/; do
  skill_file="${skill_dir}SKILL.md"
  [ ! -f "$skill_file" ] && continue
  skill_name=$(basename "$skill_dir")

  # Extract description — handles both single-line and YAML block-scalar (description: >) form.
  # State machine: enter on description:, accumulate body lines until next top-level key.
  # awk (no pipe) avoids SIGPIPE under set -o pipefail — see Check 1 header comment.
  desc=$(awk '
    /^description:/ {
      sub(/^description:[[:space:]]*>?[[:space:]]*/, "")
      in_desc=1
      buf=$0
      next
    }
    in_desc && /^[a-zA-Z][a-zA-Z0-9_-]*:/ { in_desc=0 }
    in_desc {
      gsub(/^[[:space:]]+/, "")
      buf = buf " " $0
    }
    END { print buf }
  ' "$skill_file" | tr -s ' ' | sed 's/^ //;s/ $//')

  if [ -z "$desc" ]; then
    fail "$skill_name — description field empty or missing"
    RUBRIC_FAIL=$((RUBRIC_FAIL + 1))
    continue
  fi

  # (a) length check
  desc_len=${#desc}
  if [ "$desc_len" -gt 1024 ]; then
    fail "$skill_name — description length $desc_len exceeds 1024 chars (FR-003a)"
    RUBRIC_FAIL=$((RUBRIC_FAIL + 1))
    continue
  fi

  # (b) trigger phrase check
  if ! echo "$desc" | grep -qE "(Use when|Use AFTER|Use BEFORE|Use to|Use for|Use as|Read this first|Assess|migrated)"; then
    fail "$skill_name — description lacks trigger phrase from rubric set (FR-003b)"
    RUBRIC_FAIL=$((RUBRIC_FAIL + 1))
    continue
  fi

  pass "$skill_name — description ${desc_len}c + trigger phrase present"
done
if [ "$RUBRIC_FAIL" -eq 0 ]; then
  pass "all SKILL.md descriptions satisfy rubric (FR-003)"
fi
echo ""

# --- Check 26: Pattern 3 — imperative-with-reason hygiene (WARNING ONLY) ---
# Per ADR-017 (Anthropic Pattern 3 forward guardrail) — skills with heavy
# soft-language usage (should/consider/may/might/could) but no paired reason
# markers (MUST/NEVER/ALWAYS/DO NOT/Why:/Rationale:/because) risk producing
# ambiguous guidance. Anthropic's pptx/SKILL.md models the pattern: hard
# imperatives explain WHY ("NEVER use accent lines — these are a hallmark of
# AI-generated slides; use whitespace instead").
# Warning-only — does NOT fail build. Tracks the partial-coverage reality
# while ADR-016 drop date 2026-11-23 acts as the safety net.
echo "--- Check 26: imperative-with-reason hygiene (WARNING ONLY, ADR-017) ---"
P3_WARN=0
for skill_dir in skills/*/; do
  skill_file="${skill_dir}SKILL.md"
  [ ! -f "$skill_file" ] && continue
  skill_name=$(basename "$skill_dir")

  # Count soft-language verbs (lowercase, word-bounded).
  # grep -c always prints count but exits 1 on zero matches; capture exit
  # via outer || so the var doesn't end up as "0\n0".
  soft_count=$(grep -cwE '(should|consider|may|might|could)' "$skill_file" 2>/dev/null) || soft_count=0
  # Count hard imperatives + reason markers (mixed case).
  hard_count=$(grep -cwE '(MUST|NEVER|ALWAYS|Why:|Rationale:|because)' "$skill_file" 2>/dev/null) || hard_count=0

  # Threshold: 4+ soft verbs without any hard/reason pairing → warn.
  # 4 is empirically derived: skills with ≤3 soft verbs (e.g. /requirements at 0, /workflow at 0)
  # tend to be deterministic-register; 4+ soft verbs with zero pairing signal genuinely loose guidance.
  if [ "$soft_count" -ge 4 ] && [ "$hard_count" -eq 0 ]; then
    echo "  WARN: $skill_name — $soft_count soft verbs, 0 reason markers (consider MUST/NEVER + Why: pairing per ADR-017)"
    P3_WARN=$((P3_WARN + 1))
  else
    pass "$skill_name — soft=$soft_count reason-markers=$hard_count (Check 26 hygiene OK)"
  fi
done
if [ "$P3_WARN" -gt 0 ]; then
  echo "  (Check 26 informational: $P3_WARN skills flagged — non-blocking; ADR-016 drop date 2026-11-23 if no friction signal accumulates)"
fi
echo ""

# --- Check 27: Consumer-doctrine bump enforcement (ADR-019 + ADR-023) ---
# Consumer-doctrine paths (rules/, skills/, hooks/, habits/, guides/, agents/,
# .claude-plugin/, .codex-plugin/, .agents/plugins/marketplace.json) reach
# plugin consumers at runtime. Changes there MUST be accompanied by a version bump in
# the version-bearing files, even if the change is "doctrine refinement" in spirit. Contributor-
# doctrine paths (docs/, CLAUDE.md, CONTRIBUTING.md, .github/, SELF-CHECK.md, tests/)
# do not — they preserve ADR-017 §C5 intent. See ADR-019 for full rationale and tables.
# The `plugin/` mirror is classified by its logical (de-mirrored) path — see the F21 fix below.
echo "--- Check 27: consumer-doctrine bump enforcement (ADR-019 + ADR-023) ---"

LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
if [ -z "$LAST_TAG" ]; then
  # No tag yet — first release in the repo. Skip the check entirely.
  pass "no release tag yet — Check 27 skipped (no baseline to compare)"
else
  DIFF_BASE="$LAST_TAG"
  CHANGED=$(git diff --name-only "$DIFF_BASE"..HEAD 2>/dev/null || echo "")

  if [ -z "$CHANGED" ]; then
    pass "no file changes since $LAST_TAG — Check 27 trivially passes"
  else
    # F21 fix (#329): normalize the leading `plugin/` mirror prefix before classifying, so a
    # contributor-doctrine file (docs/, CONTRIBUTING.md, SELF-CHECK.md, …) does NOT trip
    # consumer-doctrine merely via its mirrored `plugin/` copy. Check 28 guarantees root↔mirror
    # byte-parity, so classifying by logical path is sound. `plugin/.codex-plugin/plugin.json`
    # still normalizes to `.codex-plugin/` → consumer (correct: it is a version manifest).
    CHANGED_LOGICAL=$(echo "$CHANGED" | sed 's#^plugin/##')
    # Match any path under consumer-doctrine top-level dirs plus native Codex packaging.
    # #331: include `.claude-plugin/` (plugin.json non-version fields + marketplace.json) —
    # ADR-019 classifies these as consumer-doctrine. marketplace.json has no `lastUpdated`
    # field, so any non-version edit legitimately requires a bump (no false-positive class).
    CONSUMER_TOUCHED=$(echo "$CHANGED_LOGICAL" | grep -E '^((rules|skills|hooks|habits|guides|agents)/|\.(claude|codex)-plugin/|\.agents/plugins/marketplace\.json$)' | sort -u || true)

    if [ -z "$CONSUMER_TOUCHED" ]; then
      pass "contributor-doctrine only since $LAST_TAG — no bump required (ADR-019)"
    else
      # Consumer-doctrine paths touched — version MUST have bumped since $LAST_TAG.
      LAST_RELEASE_VERSION=$(echo "$LAST_TAG" | sed 's/^v//')
      CURRENT_VERSION=$(grep '"version"' .claude-plugin/plugin.json | head -1 | sed 's/.*"version": *"\([^"]*\)".*/\1/')

      if [ "$CURRENT_VERSION" = "$LAST_RELEASE_VERSION" ]; then
        fail "Check 27: consumer-doctrine paths changed since $LAST_TAG but version not bumped (still $CURRENT_VERSION). Cite ADR-019/ADR-023 (consumer-doctrine PRs require bump + CHANGELOG)."
        echo "  Consumer-doctrine paths touched:"
        echo "$CONSUMER_TOUCHED" | sed 's/^/    - /'
      else
        pass "consumer-doctrine touched + version bumped $LAST_RELEASE_VERSION → $CURRENT_VERSION (ADR-019/ADR-023 satisfied)"
      fi
    fi
  fi
fi
echo ""

# --- Check 28: Native Codex plugin packaging ---
echo "--- Check 28: native Codex plugin packaging (ADR-023) ---"
CODEX_FAIL=0
CODEX_PLUGIN=".codex-plugin/plugin.json"
CODEX_CHILD_PLUGIN="plugin/.codex-plugin/plugin.json"
CODEX_MARKETPLACE=".agents/plugins/marketplace.json"

if [ -f "$CODEX_PLUGIN" ]; then
  pass "$CODEX_PLUGIN exists"
else
  fail "$CODEX_PLUGIN missing"
  CODEX_FAIL=$((CODEX_FAIL + 1))
fi

if [ -f "$CODEX_CHILD_PLUGIN" ]; then
  pass "$CODEX_CHILD_PLUGIN exists"
elif [ "$CODEX_INSTALLED_CACHE" -eq 1 ]; then
  pass "$CODEX_CHILD_PLUGIN omitted in Codex installed cache"
else
  fail "$CODEX_CHILD_PLUGIN missing"
  CODEX_FAIL=$((CODEX_FAIL + 1))
fi

if [ -f "$CODEX_MARKETPLACE" ]; then
  pass "$CODEX_MARKETPLACE exists"
else
  fail "$CODEX_MARKETPLACE missing"
  CODEX_FAIL=$((CODEX_FAIL + 1))
fi

if [ -f "$CODEX_PLUGIN" ]; then
  for field in '"name": "8-habit-ai-dev"' '"skills": "./skills/"' '"interface"' '"defaultPrompt"'; do
    if grep -q "$field" "$CODEX_PLUGIN"; then
      pass "$CODEX_PLUGIN contains $field"
    else
      fail "$CODEX_PLUGIN missing $field"
      CODEX_FAIL=$((CODEX_FAIL + 1))
    fi
  done
fi

if [ -f "$CODEX_CHILD_PLUGIN" ]; then
  for field in '"name": "8-habit-ai-dev"' '"skills": "./skills/"' '"interface"' '"defaultPrompt"'; do
    if grep -q "$field" "$CODEX_CHILD_PLUGIN"; then
      pass "$CODEX_CHILD_PLUGIN contains $field"
    else
      fail "$CODEX_CHILD_PLUGIN missing $field"
      CODEX_FAIL=$((CODEX_FAIL + 1))
    fi
  done
fi

if [ -L "plugin" ]; then
  fail "plugin is a symlink; Codex child source must be a real directory so Claude Code installers do not package a root self-symlink"
  CODEX_FAIL=$((CODEX_FAIL + 1))
elif [ -d "plugin" ]; then
  if [ -f "$CODEX_CHILD_PLUGIN" ]; then
    pass "plugin is a real Codex child source directory"
  else
    fail "plugin directory exists but $CODEX_CHILD_PLUGIN is missing"
    CODEX_FAIL=$((CODEX_FAIL + 1))
  fi
  if [ -d "plugin/skills" ]; then
    pass "plugin/skills exists in Codex child package"
  else
    fail "plugin/skills missing (Codex child package would install without skills)"
    CODEX_FAIL=$((CODEX_FAIL + 1))
  fi
  if [ "$CODEX_INSTALLED_CACHE" -eq 0 ]; then
    SYNC_FAIL=0
    for path in skills guides habits hooks agents rules scripts docs; do
      if diff -qr "$path" "plugin/$path" >/dev/null 2>&1; then
        pass "plugin/$path is in sync with $path"
      else
        fail "plugin/$path drifted from $path; re-sync the Codex child package"
        SYNC_FAIL=$((SYNC_FAIL + 1))
      fi
    done
    for file in AGENTS.md CHANGELOG.md CLAUDE.md CONTRIBUTING.md DOMAIN.md LICENSE README.md SELF-CHECK.md SECURITY.md SKILL-EFFECTIVENESS.md SPEC.md llms.txt; do
      if cmp -s "$file" "plugin/$file"; then
        pass "plugin/$file is in sync with $file"
      else
        fail "plugin/$file drifted from $file; re-sync the Codex child package"
        SYNC_FAIL=$((SYNC_FAIL + 1))
      fi
    done
    if [ "$SYNC_FAIL" -gt 0 ]; then
      CODEX_FAIL=$((CODEX_FAIL + SYNC_FAIL))
    fi
  fi
elif [ "$CODEX_INSTALLED_CACHE" -eq 1 ]; then
  pass "plugin child source omitted in Codex installed cache"
else
  fail "plugin child source directory missing (Codex marketplace needs a child source path)"
  CODEX_FAIL=$((CODEX_FAIL + 1))
fi

if [ -f "$CODEX_MARKETPLACE" ]; then
  for field in '"name": "pitimon-8-habit-ai-dev"' '"path": "./plugin"' '"installation": "AVAILABLE"' '"authentication": "ON_INSTALL"'; do
    if grep -q "$field" "$CODEX_MARKETPLACE"; then
      pass "$CODEX_MARKETPLACE contains $field"
    else
      fail "$CODEX_MARKETPLACE missing $field"
      CODEX_FAIL=$((CODEX_FAIL + 1))
    fi
  done
fi
echo ""

# --- Check 29: Codex runtime compatibility docs ---
echo "--- Check 29: Codex runtime compatibility docs (ADR-024) ---"
CODEX_DOC_FAIL=0
COMPAT_DOC="docs/compatibility-matrix.md"
CODEX_GUIDE="docs/codex-integration.md"
CODEX_ADR="docs/adr/ADR-024-codex-runtime-adapter-boundary.md"

for f in "$COMPAT_DOC" "$CODEX_GUIDE" "$CODEX_ADR"; do
  if [ -f "$f" ]; then
    pass "$f exists"
  else
    fail "$f missing"
    CODEX_DOC_FAIL=$((CODEX_DOC_FAIL + 1))
  fi
done

if [ -f "$COMPAT_DOC" ]; then
  for phrase in "Claude Code" "Codex" "Other agents" "Claude hooks" "Runtime enforcement" "Markdown skills"; do
    if grep -q "$phrase" "$COMPAT_DOC"; then
      pass "$COMPAT_DOC contains '$phrase'"
    else
      fail "$COMPAT_DOC missing '$phrase'"
      CODEX_DOC_FAIL=$((CODEX_DOC_FAIL + 1))
    fi
  done
fi

if [ -f "$CODEX_GUIDE" ]; then
  for phrase in "Codex Runtime Contract" "codex plugin add" "Claude hook" "adapter layer" "AGENTS.md" "skills/RESOLVER.md"; do
    if grep -q "$phrase" "$CODEX_GUIDE"; then
      pass "$CODEX_GUIDE contains '$phrase'"
    else
      fail "$CODEX_GUIDE missing '$phrase'"
      CODEX_DOC_FAIL=$((CODEX_DOC_FAIL + 1))
    fi
  done
fi

if [ -f "$CODEX_ADR" ]; then
  for phrase in "adapter boundary" "runtime enforcement" "ADR-023"; do
    if grep -q "$phrase" "$CODEX_ADR"; then
      pass "$CODEX_ADR contains '$phrase'"
    else
      fail "$CODEX_ADR missing '$phrase'"
      CODEX_DOC_FAIL=$((CODEX_DOC_FAIL + 1))
    fi
  done
fi

if [ -f README.md ] && grep -q "docs/compatibility-matrix.md" README.md && grep -q "docs/codex-integration.md" README.md; then
  pass "README.md links Codex compatibility docs"
else
  fail "README.md missing Codex compatibility doc links"
  CODEX_DOC_FAIL=$((CODEX_DOC_FAIL + 1))
fi

if [ -f AGENTS.md ] && grep -q "docs/compatibility-matrix.md" AGENTS.md && grep -q "docs/codex-integration.md" AGENTS.md; then
  pass "AGENTS.md links Codex compatibility docs"
else
  fail "AGENTS.md missing Codex compatibility doc links"
  CODEX_DOC_FAIL=$((CODEX_DOC_FAIL + 1))
fi

if [ -f llms.txt ] && grep -q "compatibility-matrix.md" llms.txt && grep -q "codex-integration.md" llms.txt; then
  pass "llms.txt indexes Codex compatibility docs"
else
  fail "llms.txt missing Codex compatibility doc links"
  CODEX_DOC_FAIL=$((CODEX_DOC_FAIL + 1))
fi

if [ "$CODEX_DOC_FAIL" -eq 0 ]; then
  pass "Codex runtime compatibility contract documented and indexed"
fi
echo ""

# --- Check 30: generated skill catalog freshness ---
echo "--- Check 30: generated skill catalog freshness ---"
CATALOG_FAIL=0
CATALOG_SCRIPT="scripts/generate-skill-catalog.js"
CATALOG_JSON="docs/data/skills.json"

if [ -f "$CATALOG_SCRIPT" ]; then
  pass "$CATALOG_SCRIPT exists"
else
  fail "$CATALOG_SCRIPT missing"
  CATALOG_FAIL=$((CATALOG_FAIL + 1))
fi

if [ -f "$CATALOG_JSON" ]; then
  pass "$CATALOG_JSON exists"
else
  fail "$CATALOG_JSON missing"
  CATALOG_FAIL=$((CATALOG_FAIL + 1))
fi

if command -v node >/dev/null 2>&1; then
  pass "node available for generated catalog check"
else
  fail "node not found — required for $CATALOG_SCRIPT"
  CATALOG_FAIL=$((CATALOG_FAIL + 1))
fi

if [ "$CATALOG_FAIL" -eq 0 ]; then
  if node "$CATALOG_SCRIPT" --check; then
    pass "$CATALOG_JSON is fresh"
  else
    fail "$CATALOG_JSON is stale; run: node $CATALOG_SCRIPT"
    CATALOG_FAIL=$((CATALOG_FAIL + 1))
  fi
fi
echo ""

# --- Check 31: Codex hook config schema purity (#321) ---
echo "--- Check 31: Codex hook config schema purity (#321, ADR-024) ---"
# Codex auto-discovers and parses hooks/hooks.json at install with a strict
# serde schema that accepts ONLY a top-level "hooks" key. Any sibling key (e.g.
# a "description") makes Codex reject the config: "unknown field `description`,
# expected `hooks`". Claude Code tolerates the extra key; Codex does not. Keep
# the top level schema-pure so the same file installs cleanly in both runtimes.
# Parses the JSON object (node, already required by Check 30) so the check is
# format-independent; falls back to a grep on the canonical 2-space shape if
# node is unavailable.
HOOK_SCHEMA_FAIL=0
for hookcfg in hooks/hooks.json plugin/hooks/hooks.json; do
  [ -f "$hookcfg" ] || continue
  if command -v node >/dev/null 2>&1; then
    EXTRA_KEYS=$(node -e 'const fs=require("fs");const k=Object.keys(JSON.parse(fs.readFileSync(process.argv[1],"utf8")));process.stdout.write(k.filter(x=>x!=="hooks").join(" "));const has=k.includes("hooks");process.exitCode=has?0:2' "$hookcfg" 2>/dev/null)
    NODE_RC=$?
    if [ -n "$EXTRA_KEYS" ]; then
      fail "$hookcfg has non-'hooks' top-level key(s); Codex rejects unknown fields (#321): $EXTRA_KEYS"
      HOOK_SCHEMA_FAIL=$((HOOK_SCHEMA_FAIL + 1))
    elif [ "$NODE_RC" -eq 2 ]; then
      fail "$hookcfg missing top-level 'hooks' key"
      HOOK_SCHEMA_FAIL=$((HOOK_SCHEMA_FAIL + 1))
    elif [ "$NODE_RC" -ne 0 ]; then
      fail "$hookcfg is not valid JSON (Codex would fail to parse it)"
      HOOK_SCHEMA_FAIL=$((HOOK_SCHEMA_FAIL + 1))
    else
      pass "$hookcfg top level is schema-pure (only 'hooks')"
    fi
  else
    # Fallback: grep top-level keys on the canonical pretty-printed (2-space) shape.
    TOP_KEYS=$(grep -E '^  "[^"]+":' "$hookcfg" | sed 's/^  "\([^"]*\)".*/\1/')
    EXTRA_KEYS=$(echo "$TOP_KEYS" | grep -vx 'hooks' || true)
    if [ -n "$EXTRA_KEYS" ]; then
      fail "$hookcfg has non-'hooks' top-level key(s); Codex rejects unknown fields (#321): $(echo "$EXTRA_KEYS" | tr '\n' ' ')"
      HOOK_SCHEMA_FAIL=$((HOOK_SCHEMA_FAIL + 1))
    elif echo "$TOP_KEYS" | grep -qx 'hooks'; then
      pass "$hookcfg top level is schema-pure (only 'hooks')"
    else
      fail "$hookcfg missing top-level 'hooks' key"
      HOOK_SCHEMA_FAIL=$((HOOK_SCHEMA_FAIL + 1))
    fi
  fi
done
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
