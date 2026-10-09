#!/bin/bash
# Exercise the real scanner in isolated Git fixtures; no network access.
set -euo pipefail
cd "$(dirname "$0")/.."
SOURCE="$PWD/tests/test-self-link-targets.sh"
TMP=$(mktemp -d "${TMPDIR:-/tmp}/self-link-regression.XXXXXX")
trap 'rm -rf "$TMP"' EXIT
FAIL=0
N=0
BASE=https://raw.githubusercontent.com/pitimon/8-habit-ai-dev/main
fixture() {
  rm -rf "$TMP/repo"
  mkdir -p "$TMP/repo/tests" "$TMP/repo/guides"
  cp "$SOURCE" "$TMP/repo/tests/test-self-link-targets.sh"
  git -C "$TMP/repo" init -q
  printf 'target\n' > "$TMP/repo/guides/target.md"
  printf '[ok](%s/guides/target.md)\n' "$BASE" > "$TMP/repo/llms.txt"
  git -C "$TMP/repo" add guides/target.md llms.txt
}
check() {
  local name=$1 expected=$2 pattern=$3 rc=0
  (cd "$TMP/repo" && PATH="${SCAN_PATH:-$PATH}" bash tests/test-self-link-targets.sh --scan-only) > "$TMP/log" 2>&1 || rc=$?
  N=$((N + 1))
  if { [ "$expected" = pass ] && [ "$rc" -eq 0 ]; } || { [ "$expected" = fail ] && [ "$rc" -ne 0 ]; }; then
    if grep -Fq -- "$pattern" "$TMP/log"; then
      printf '  PASS: regression %s\n' "$name"
      return
    fi
  fi
  printf '  FAIL: regression %s (exit %s, expected %s; missing diagnostic: %s)\n' "$name" "$rc" "$expected" "$pattern"
  while IFS= read -r line; do printf '    %s\n' "$line"; done < "$TMP/log"
  FAIL=1
}
fixture
check tracked-file pass 'RESULT: PASS'
printf '[bad](%s/missing.md)\n' "$BASE" >> "$TMP/repo/llms.txt"
check missing-target fail 'missing.md'
fixture
printf 'not tracked\n' > "$TMP/repo/untracked.md"
printf '[bad](%s/untracked.md)\n' "$BASE" >> "$TMP/repo/llms.txt"
check untracked-target fail 'untracked.md'
fixture
printf '[bad](%s/guides/Target.md)\n' "$BASE" >> "$TMP/repo/llms.txt"
check wrong-case fail 'Target.md'
fixture
mkdir "$TMP/repo/emptydir"
printf '[bad](https://github.com/pitimon/8-habit-ai-dev/tree/main/emptydir)\n' >> "$TMP/repo/llms.txt"
check empty-tree fail 'emptydir'
fixture
printf '[ok](https://github.com/pitimon/8-habit-ai-dev/tree/main/guides)\n' >> "$TMP/repo/llms.txt"
check tracked-tree pass 'RESULT: PASS'
fixture
printf '[bad](https://github.com/pitimon/8-habit-ai-dev/tree/main/Guides)\n' >> "$TMP/repo/llms.txt"
check wrong-case-tree fail 'Guides'
fixture
printf '[bad](%s/guides)\n' "$BASE" >> "$TMP/repo/llms.txt"
check raw-directory fail 'guides'
fixture
rm "$TMP/repo/guides/target.md"
check deleted-working-file fail 'target.md'
fixture
printf 'no links\n' > "$TMP/repo/llms.txt"
check zero-matches fail 'no self-referential URLs'
fixture
printf '`%s/guides/target.md`, [%s/guides/target.md]. %s/guides/target.md,\n' "$BASE" "$BASE" "$BASE" >> "$TMP/repo/llms.txt"
check punctuation pass 'RESULT: PASS'
fixture
printf '[ok](%s/guides/target.md?raw=1#L2)\n' "$BASE" >> "$TMP/repo/llms.txt"
check query-fragment pass 'RESULT: PASS'
fixture
printf '[bad](%s/absent.md)\n' "$BASE" > "$TMP/repo/untracked-source.md"
printf '[bad](%s/absent.md)\n' "$BASE" > "$TMP/repo/unscanned.sh"
mkdir -p "$TMP/repo/docs/wiki" "$TMP/repo/plugin"
printf '[bad](%s/absent.md)\n' "$BASE" > "$TMP/repo/docs/wiki/a.md"
printf '[bad](%s/absent.md)\n' "$BASE" > "$TMP/repo/plugin/a.md"
git -C "$TMP/repo" add unscanned.sh docs/wiki plugin
check source-scope pass 'RESULT: PASS'
fixture
mkdir "$TMP/repo/bin"
printf '#!/bin/sh\nexit 2\n' > "$TMP/repo/bin/grep"
chmod +x "$TMP/repo/bin/grep"
SCAN_PATH="$TMP/repo/bin:$PATH" check grep-error fail 'URL extraction failed'
fixture
rm -rf "$TMP/repo/.git"
check no-git fail 'cannot enumerate tracked'
printf 'Regression matrix: %s cases, failure flag=%s\n' "$N" "$FAIL"
[ "$FAIL" -eq 0 ]
