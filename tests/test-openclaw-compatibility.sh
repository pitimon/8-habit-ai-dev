#!/usr/bin/env bash
# OpenClaw compatibility checks for the portable skill surface.
# Static by design: OpenClaw is optional in maintainer/CI environments.
set -euo pipefail

ERRORS=0
PASS=0
pass() { PASS=$((PASS + 1)); echo "  PASS: $1"; }
fail() { ERRORS=$((ERRORS + 1)); echo "  FAIL: $1"; }

ROOT="$(cd "$(dirname "$0")/.." && pwd -P)"
cd "$ROOT"

for tree in skills plugin/skills; do
  [ -d "$tree" ] || { fail "$tree missing"; continue; }
  while IFS= read -r skill_file; do
    skill_dir=$(dirname "$skill_file")
    dir_name=$(basename "$skill_dir")
    name=$(awk '/^---$/{c++; if(c==2) exit; next} c==1 && sub(/^name:[[:space:]]*/, ""){print; exit}' "$skill_file")
    description=$(awk '/^---$/{c++; if(c==2) exit; next} c==1 && sub(/^description:[[:space:]]*/, ""){print; exit}' "$skill_file")
    if [ "$name" = "$dir_name" ]; then pass "$skill_file name matches directory"; else fail "$skill_file name '$name' does not match '$dir_name'"; fi
    if printf '%s' "$name" | grep -qE '^[a-z0-9]+(-[a-z0-9]+)*$' && [ "${#name}" -le 64 ]; then pass "$skill_file has OpenClaw-safe name"; else fail "$skill_file has invalid OpenClaw name '$name'"; fi
    if [ -n "$description" ] && [ "${#description}" -le 160 ]; then pass "$skill_file has bounded one-line description"; else fail "$skill_file description is missing or exceeds 160 characters"; fi
  done < <(find "$tree" -mindepth 2 -maxdepth 2 -type f -name SKILL.md | sort)
  if grep -R -nE '\]\((\.\./|\.\./\.\./)' "$tree" --include='SKILL.md' >/dev/null 2>&1; then
    fail "$tree contains parent-directory Markdown links"
  else
    pass "$tree has no parent-directory Markdown links"
  fi
done

if diff -qr skills plugin/skills >/dev/null; then
  pass "Root and plugin skill trees are byte-for-byte mirrored"
else
  fail "Root and plugin skill trees diverge"
fi

for tree in skills plugin/skills; do
  if grep -R -n '\${CLAUDE_PLUGIN_ROOT}' "$tree" --include='SKILL.md' | while IFS= read -r line; do
    file=${line%%:*}
    grep -q 'OpenClaw:' "$file" || { printf '%s\n' "$line"; exit 1; }
  done; then
    pass "Every $tree CLAUDE_PLUGIN_ROOT skill carries an OpenClaw note"
  else
    fail "A $tree CLAUDE_PLUGIN_ROOT skill is missing its OpenClaw note"
  fi
done

if [ -f docs/openclaw-integration.md ] && grep -q 'openclaw skills list' docs/openclaw-integration.md; then
  pass "OpenClaw integration guide is present"
else
  fail "OpenClaw integration guide is missing or incomplete"
fi

echo "OpenClaw compatibility: $PASS passed, $ERRORS failed"
[ "$ERRORS" -eq 0 ]
