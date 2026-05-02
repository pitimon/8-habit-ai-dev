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

# --- Check 15: v2.14.2 EU AI Act stub (post-migration to claude-governance v3.1.0) ---
echo "--- Check 15: v2.14.2 EU AI Act stub (post-migration) ---"

# Per ADR-012 (2026-05-02), the EU AI Act compliance toolkit migrated to
# pitimon/claude-governance v3.1.0. This plugin retains a single redirect
# stub at skills/eu-ai-act-check/SKILL.md. The deleted files (research,
# guide, reference) now live in the governance plugin; their content
# assertions moved there too (governance-side validate-plugin.sh section 6).
#
# The stub-mode checks below verify:
#   - the redirect stub exists
#   - it points users to the canonical location
#   - it preserves the NOT LEGAL ADVICE disclaimer (regulatory communication)
#   - the deleted files are NOT present (catches accidental restore)

EU_STUB="skills/eu-ai-act-check/SKILL.md"
if [ -f "$EU_STUB" ]; then
  pass "$EU_STUB redirect stub exists"
  if grep -q "pitimon/claude-governance" "$EU_STUB"; then
    pass "$EU_STUB redirects to pitimon/claude-governance"
  else
    fail "$EU_STUB missing pitimon/claude-governance redirect"
  fi
  if grep -q "NOT LEGAL ADVICE\|not legal advice" "$EU_STUB"; then
    pass "$EU_STUB preserves NOT LEGAL ADVICE disclaimer"
  else
    fail "$EU_STUB missing NOT LEGAL ADVICE disclaimer"
  fi
  if grep -q "ADR-012" "$EU_STUB"; then
    pass "$EU_STUB references migration ADR-012"
  else
    fail "$EU_STUB missing ADR-012 reference"
  fi
else
  fail "$EU_STUB not found"
fi

# Negative checks: deleted files must not have been restored
for deleted_file in \
  "skills/eu-ai-act-check/reference.md" \
  "docs/research/eu-ai-act-obligations.md" \
  "guides/eu-ai-act-mapping.md"; do
  if [ -f "$deleted_file" ]; then
    fail "$deleted_file was restored — should be deleted post-migration (see ADR-012)"
  else
    pass "$deleted_file correctly absent post-migration"
  fi
done

# ADR-012 itself must exist
if [ -f "docs/adr/ADR-012-eu-ai-act-migration-completion.md" ]; then
  pass "docs/adr/ADR-012 (migration completion) exists"
else
  fail "docs/adr/ADR-012 (migration completion) not found"
fi

# ADR-005 must be marked as Superseded
if [ -f "docs/adr/ADR-005-eu-ai-act-compliance-toolkit.md" ]; then
  if grep -qE 'Status.*:.*Superseded' "docs/adr/ADR-005-eu-ai-act-compliance-toolkit.md"; then
    pass "ADR-005 status updated to Superseded"
  else
    fail "ADR-005 still marked Accepted — should be Superseded by ADR-012"
  fi
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
# ADR-009: search triad (SKILL + reference + examples) as a unit for content assertions
META_TRIAD="skills/using-8-habits/SKILL.md skills/using-8-habits/reference.md skills/using-8-habits/examples.md"
META_TRIAD_EXISTING=""
for f in $META_TRIAD; do [ -f "$f" ] && META_TRIAD_EXISTING="$META_TRIAD_EXISTING $f"; done
if [ -f "$META_SKILL" ]; then
  pass "$META_SKILL exists"
  # Frontmatter: meta-skill is a starting point (SKILL.md only — frontmatter lives there)
  if grep -qE '^prev-skill:\s*none' "$META_SKILL"; then
    pass "$META_SKILL prev-skill is 'none'"
  else
    fail "$META_SKILL prev-skill should be 'none'"
  fi
  # Content: explains workflow + decision tree + all skills (across triad per ADR-009)
  for keyword in "7-step workflow" "decision tree" "workflow skill" "assessment skill" "Covey" "Whole Person"; do
    if grep -qi "$keyword" $META_TRIAD_EXISTING 2>/dev/null; then
      pass "using-8-habits triad mentions '$keyword'"
    else
      fail "using-8-habits triad missing '$keyword'"
    fi
  done
  # Must mention every current skill (anti-drift assertion, searches triad)
  for skill_dir in skills/*/; do
    skill_name=$(basename "$skill_dir")
    [ "$skill_name" = "using-8-habits" ] && continue
    if grep -q "/$skill_name\b" $META_TRIAD_EXISTING 2>/dev/null; then
      pass "using-8-habits triad mentions /$skill_name"
    else
      fail "using-8-habits triad missing mention of /$skill_name (anti-drift assertion)"
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
  # Issue #149: Smart-routing mode (argument-driven) — section header + reference examples
  if grep -q "^## Smart-routing mode" "$META_SKILL"; then
    pass "$META_SKILL has '## Smart-routing mode' section (Issue #149)"
  else
    fail "$META_SKILL missing '## Smart-routing mode' section (Issue #149)"
  fi
  if grep -q "^## Smart-routing examples" skills/using-8-habits/reference.md 2>/dev/null; then
    pass "using-8-habits/reference.md has '## Smart-routing examples' section (Issue #149)"
  else
    fail "using-8-habits/reference.md missing '## Smart-routing examples' section (Issue #149)"
  fi
else
  fail "$META_SKILL not found"
fi

echo ""

# --- Check 20: /review-ai Verification Phase (Issue #150) ---
echo "--- Check 20: /review-ai Verification Phase ---"
REVIEW_AI="skills/review-ai/SKILL.md"
VERIFY_FAIL=0
if [ -f "$REVIEW_AI" ]; then
  # Section header present
  if grep -q "^## Verification Phase" "$REVIEW_AI"; then
    pass "$REVIEW_AI has '## Verification Phase' section"
  else
    fail "$REVIEW_AI missing '## Verification Phase' section (Issue #150)"
    VERIFY_FAIL=$((VERIFY_FAIL + 1))
  fi
  # Plugin-boundary qualifier in the section: must say "guidance only" AND "NOT a hook"
  # Boundary discipline — prevents future contributors from implementing as a git hook
  if grep -q "guidance only" "$REVIEW_AI" && grep -q "NOT a hook" "$REVIEW_AI"; then
    pass "$REVIEW_AI Verification Phase has plugin-boundary qualifier (guidance only, NOT a hook)"
  else
    fail "$REVIEW_AI Verification Phase missing plugin-boundary qualifier (need both 'guidance only' AND 'NOT a hook')"
    VERIFY_FAIL=$((VERIFY_FAIL + 1))
  fi
  # Verification Table headers present (Finding | Severity | Fix Evidence | Status)
  if grep -q "Fix Evidence" "$REVIEW_AI" && grep -q "RESOLVED" "$REVIEW_AI"; then
    pass "$REVIEW_AI has Verification Table with Fix Evidence + RESOLVED status"
  else
    fail "$REVIEW_AI Verification Phase missing Verification Table example (need 'Fix Evidence' + 'RESOLVED')"
    VERIFY_FAIL=$((VERIFY_FAIL + 1))
  fi
  # Find → Fix → Re-Verify literal loop name pinned (Issue #157 hardening — was
  # self-disclosed weak in v2.14.0 CHANGELOG follow-up; passes-on-3-string-matches risk)
  if grep -q "Find → Fix → Re-Verify" "$REVIEW_AI"; then
    pass "$REVIEW_AI Verification Phase pins 'Find → Fix → Re-Verify' loop name"
  else
    fail "$REVIEW_AI Verification Phase missing 'Find → Fix → Re-Verify' literal loop name (Issue #157 hardening)"
    VERIFY_FAIL=$((VERIFY_FAIL + 1))
  fi
  # Exactly 5 numbered steps (1.-5.) in the Verification Phase section
  # awk extracts the section content between '## Verification Phase' and the next '## ',
  # then grep counts numbered-step lines like "1. **List**" / "2. **Apply fix**" / etc.
  verify_steps=$(awk '/^## Verification Phase/{found=1; next} /^## /{if(found) exit} found' "$REVIEW_AI" | grep -cE '^[1-5]\. \*\*')
  if [ "$verify_steps" = "5" ]; then
    pass "$REVIEW_AI Verification Phase has exactly 5 numbered steps"
  else
    fail "$REVIEW_AI Verification Phase has $verify_steps numbered steps (expected exactly 5 — Issue #157 hardening pins the loop count)"
    VERIFY_FAIL=$((VERIFY_FAIL + 1))
  fi
else
  fail "$REVIEW_AI not found"
  VERIFY_FAIL=$((VERIFY_FAIL + 1))
fi
echo ""

# --- Check 19: Docs freshness vs plugin.json version ---
# Enforces downstream propagation from plugin.json across all changelog surfaces.
# Prevents the "stuck at v2.N-5" drift scenario (see issue #106, fix in PR #107).
# Tightened 2026-04-17 per issue #124 F1+F2 after v2.9.0 + v2.11.0 recurrence:
# pointer-to-CHANGELOG.md fallback removed (the wiki was passing just by containing
# the string "CHANGELOG.md" even when the actual entry was missing).
# See CONTRIBUTING.md § Testing Conventions for rationale.
echo "--- Check 19: Docs freshness vs plugin.json version ---"

# Extract current version from plugin.json — no pipe, SIGPIPE-safe (see CONTRIBUTING.md)
current_version=$(awk -F'"' '/"version"/{print $4; exit}' .claude-plugin/plugin.json)

if [ -z "$current_version" ]; then
  fail "could not extract version from .claude-plugin/plugin.json"
else
  # A. README.md must mention the current version somewhere (typically in "What's New")
  if grep -q "v${current_version}" README.md; then
    pass "README.md mentions current version v${current_version}"
  else
    fail "README.md does not mention v${current_version} — CHANGELOG.md likely updated but downstream propagation was skipped. See CONTRIBUTING.md § Testing Conventions."
  fi

  # B. CHANGELOG.md must contain a version section header (^## v<version>)
  # Added 2026-04-17: v2.9.0 (issue #124 F1) and v2.11.0 both shipped without this
  # entry because nothing asserted it. Root CHANGELOG is authoritative per ADR-004.
  if grep -q "^## v${current_version}" CHANGELOG.md; then
    pass "CHANGELOG.md contains v${current_version} entry"
  else
    fail "CHANGELOG.md missing '## v${current_version}' section header — backfill before release. See issue #124 F1."
  fi

  # C. docs/wiki/Changelog.md must contain a version section header — pointer-to-CHANGELOG.md
  # is no longer sufficient (the pointer existed in both v2.9.0 and v2.11.0 misses,
  # and the old assertion passed purely on the literal string "CHANGELOG.md").
  if grep -q "^## v${current_version}" docs/wiki/Changelog.md; then
    pass "docs/wiki/Changelog.md contains v${current_version} entry"
  else
    fail "docs/wiki/Changelog.md missing '## v${current_version}' section — pointer-to-CHANGELOG.md no longer sufficient. See issue #124 F2."
  fi

  # D. docs/wiki/Changelog.md badge must match the current version
  # Added 2026-04-17: v2.11.0 shipped with a stale latest-v2.10.0 badge.
  if grep -q "badge/latest-v${current_version}-blue" docs/wiki/Changelog.md; then
    pass "docs/wiki/Changelog.md badge matches v${current_version}"
  else
    fail "docs/wiki/Changelog.md badge stale — bump 'latest-v…' to v${current_version}."
  fi

  # E + F. SELF-CHECK.md body freshness vs git tag history
  # Added 2026-04-25 per issue #141: header was v2.13.0 but footer said Previous: 2.7.1
  # and per-release score list ended at v2.8.0 — 6 releases shipped silently.
  # Source of truth: git tag -l "v2.*" (v2.x release line; v2.0.0 onwards per #141 decision).
  # Older v1.x tags predate the SELF-CHECK.md per-release list convention and are
  # documented elsewhere (see CHANGELOG.md note "For v2.2.0 and earlier, see docs/wiki/Changelog.md").
  # Dev-env resilience: if no tags available (shallow clone without fetch-tags),
  # emit WARN and skip — CI has tags (.github/workflows/validate.yml sets fetch-tags: true)
  # so drift is still caught at merge time.
  all_tags=$(git tag -l "v2.*" 2>/dev/null | sort -V)
  if [ -z "$all_tags" ]; then
    warn "git tag history unavailable — skipping SELF-CHECK.md body freshness (sub-checks E + F). CI sets fetch-tags: true."
  else
    # E. Footer Previous: version must match the tag preceding current_version.
    # Two shapes are valid:
    #   1. Post-release (current_version is tagged): previous = tag before current in sorted list
    #   2. Pre-release (plugin.json bumped but tag not yet pushed): previous = last tag in sorted list
    if echo "$all_tags" | grep -qx "v${current_version}"; then
      prev_version=$(echo "$all_tags" | awk -v cur="v${current_version}" '
        $0 == cur { print prev; exit }
        { prev = $0 }
      ' | sed 's/^v//')
    else
      prev_version=$(echo "$all_tags" | tail -1 | sed 's/^v//')
    fi

    if [ -z "$prev_version" ]; then
      warn "could not derive previous version for v${current_version} from git tags — is this the first release?"
    elif grep -Eq "Previous: ${prev_version}\b" SELF-CHECK.md; then
      pass "SELF-CHECK.md footer references Previous: ${prev_version}"
    else
      fail "SELF-CHECK.md footer stale — expected 'Previous: ${prev_version}' (derived from git tags); update the last line of the file."
    fi

    # F. Per-release score list must have one row per tagged version — no gaps.
    # Plus: row for current_version must exist even if tag not yet pushed (release-in-progress).
    missing=()
    while IFS= read -r tag; do
      ver="${tag#v}"
      if ! grep -Eq "^- v${ver}: " SELF-CHECK.md; then
        missing+=("v${ver}")
      fi
    done <<< "$all_tags"

    if ! grep -Eq "^- v${current_version}: " SELF-CHECK.md; then
      missing+=("v${current_version}")
    fi

    if [ ${#missing[@]} -eq 0 ]; then
      pass "SELF-CHECK.md per-release list covers all tagged versions + current ($(echo "$all_tags" | wc -l | tr -d ' ') tags + v${current_version})"
    else
      fail "SELF-CHECK.md per-release list missing ${#missing[@]} version(s): ${missing[*]} — add a '- v<x.y.z>: Body N, Mind N, Heart N, Spirit N = **N.N** (…)' row per tagged release."
    fi
  fi

  # G. README.md "What's New in v<current_version>" section header anchored.
  # Added 2026-05-02 per issue #157: sub-check A (line 578) only checks bare
  # version mention, which the badge URL "releases/tag/v<x.y.z>" satisfies even
  # when the section header is missing. Same bug class as #124 pointer-fallback
  # loophole — tighter assertion required so README "What's New" cannot drift
  # like SELF-CHECK.md did before sub-checks E + F (#141/#144).
  if grep -q "^## What's New in v${current_version}" README.md; then
    pass "README.md contains '## What's New in v${current_version}' section header"
  else
    fail "README.md missing '## What's New in v${current_version}' section header — sub-check A passed on badge URL but the user-facing upgrade-discovery surface is stale. Add the section between the existing 'Zero dependencies' block and the previous '## What's New in v...' entry. See issue #157."
  fi
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
