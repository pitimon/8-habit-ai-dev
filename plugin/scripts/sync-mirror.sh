#!/usr/bin/env bash
# sync-mirror.sh — copy the root content into the `plugin/` Codex child package so that
# `tests/validate-structure.sh` Check 28 (byte-for-byte mirror parity) passes.
#
# WHY THIS EXISTS (and what it deliberately does NOT do):
#   `plugin/` is a REAL, git-tracked child directory by design — Codex marketplace install
#   points at `./plugin` as the child source, and the earlier `plugin -> .` symlink failed on
#   Linux Claude Code install (ENOENT). See ADR-023 and docs/out-of-scope/mirror-untracking.md.
#   This script only removes the TOIL of hand-copying each touched file; it does NOT untrack or
#   generate-away the mirror. The doubled tracked surface is required, not incidental.
#
# USAGE: run from anywhere; it cd's to the repo root.
#     bash scripts/sync-mirror.sh
#   Then `git add` the changed plugin/ files and commit alongside your root edits.
#
# The dir + file lists below MUST stay in lock-step with Check 28's sync lists in
# tests/validate-structure.sh (the `for path in ...` and `for file in ...` loops).
set -euo pipefail

cd "$(dirname "$0")/.."

# Mirrored directories (Check 28 enforces `diff -qr <dir> plugin/<dir>`).
DIRS="skills guides habits hooks agents rules scripts docs"
# Mirrored root files (Check 28 enforces `cmp -s <file> plugin/<file>`).
FILES="AGENTS.md CHANGELOG.md CLAUDE.md CONTRIBUTING.md DOMAIN.md LICENSE README.md SELF-CHECK.md SECURITY.md SKILL-EFFECTIVENESS.md SPEC.md llms.txt"

# NOTE: `.codex-plugin/` is intentionally NOT synced — the root and plugin/ Codex manifests are
# distinct files (Check 28 does not diff them), so copying would corrupt the child manifest.

for d in $DIRS; do
  if [ -d "$d" ]; then
    rsync -a --delete "$d/" "plugin/$d/"
  fi
done

for f in $FILES; do
  if [ -f "$f" ]; then
    cp "$f" "plugin/$f"
  fi
done

echo "Mirror synced: $(echo "$DIRS" | wc -w | tr -d ' ') dirs + $(echo "$FILES" | wc -w | tr -d ' ') files → plugin/"
echo "Next: review with 'git status', stage the plugin/ changes, and run tests/validate-structure.sh."
