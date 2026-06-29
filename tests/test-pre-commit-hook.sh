#!/bin/bash
# 8-Habit AI Dev — Pre-Commit Hook Example Regression Test
#
# Functional regression test for hooks/pre-commit.sh.example (F6 false-success fix,
# Fable review 2026-06-10, issue #343). Stubs the claude CLI and exercises the
# hook's verdict paths against BOTH mirror copies (root + plugin/), asserting
# fail-closed behavior:
#   - PASS / CONCERNS verdict -> exit 0 (proceed)
#   - REWORK / FAIL verdict   -> exit 1 (block)
#   - tool crash (non-zero)   -> exit 1 (block — never swallow into a silent pass)
#   - no verdict line emitted -> exit 1 (block — treat as "review did not run")
#
# A gate that can't check is a gate that fails. This test exists so F6 cannot recur.
# No `set -e`: we deliberately capture non-zero exits from the hook under test.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
HOOK="$REPO_ROOT/hooks/pre-commit.sh.example"
HOOK_MIRROR="$REPO_ROOT/plugin/hooks/pre-commit.sh.example"

PASS_COUNT=0
FAIL_COUNT=0

assert_exit() {
  local desc="$1" expected="$2" actual="$3"
  if [ "$actual" = "$expected" ]; then
    echo "  PASS: $desc (exit=$actual)"
    PASS_COUNT=$((PASS_COUNT + 1))
  else
    echo "  FAIL: $desc (got exit=$actual, expected $expected)"
    FAIL_COUNT=$((FAIL_COUNT + 1))
  fi
}

# Build an isolated git repo with one staged file and a stub claude on PATH.
# Prints the sandbox path. Caller must rm -rf it.
setup_sandbox() {
  local sandbox
  sandbox=$(mktemp -d)
  ( cd "$sandbox" && git init -q && git config user.email t@t.com && git config user.name t )
  printf 'staged content\n' > "$sandbox/f.txt"
  ( cd "$sandbox" && git add f.txt )
  mkdir -p "$sandbox/bin"
  cat > "$sandbox/bin/claude" <<'STUB'
#!/bin/bash
case "${CLAUDE_STUB:-}" in
  pass)      printf '## Review Verdict: PASS\nno findings\n'; exit 0;;
  concerns)  printf '## Review Verdict: CONCERNS\nminor note\n'; exit 0;;
  rework)    printf '## Review Verdict: REWORK\nquality issues\n'; exit 0;;
  fail)      printf '## Review Verdict: FAIL\nsecurity vuln\n'; exit 0;;
  crash)     printf 'auth/network error\n' >&2; exit 2;;
  noverdict) printf 'review ran but emitted no verdict line\n'; exit 0;;
  *)         printf 'unknown stub mode\n' >&2; exit 1;;
esac
STUB
  chmod +x "$sandbox/bin/claude"
  printf '%s' "$sandbox"
}

# Run the hook in the sandbox with the given stub mode; echo its exit code.
run_scenario() {
  local hook="$1" mode="$2" sandbox="$3" rc
  ( cd "$sandbox" && PATH="$sandbox/bin:$PATH" CLAUDE_STUB="$mode" bash "$hook" ) >/dev/null 2>&1
  rc=$?
  printf '%s' "$rc"
}

echo "--- Pre-commit hook F6 regression test ---"

if [ ! -f "$HOOK" ] || [ ! -f "$HOOK_MIRROR" ]; then
  echo "  FAIL: hook example not found at expected paths"
  echo ""
  echo "RESULT: FAILURES DETECTED"
  exit 1
fi

SANDBOX=$(setup_sandbox)
trap 'rm -rf "$SANDBOX"' EXIT

for HOOK_PATH in "$HOOK" "$HOOK_MIRROR"; do
  echo "  [${HOOK_PATH#$REPO_ROOT/}]"
  assert_exit "PASS verdict proceeds"            0 "$(run_scenario "$HOOK_PATH" pass      "$SANDBOX")"
  assert_exit "CONCERNS verdict proceeds"        0 "$(run_scenario "$HOOK_PATH" concerns  "$SANDBOX")"
  assert_exit "REWORK verdict blocks"            1 "$(run_scenario "$HOOK_PATH" rework    "$SANDBOX")"
  assert_exit "FAIL verdict blocks"              1 "$(run_scenario "$HOOK_PATH" fail      "$SANDBOX")"
  assert_exit "tool crash blocks (F6 core)"      1 "$(run_scenario "$HOOK_PATH" crash     "$SANDBOX")"
  assert_exit "no-verdict blocks (fail-closed)"  1 "$(run_scenario "$HOOK_PATH" noverdict "$SANDBOX")"
done

echo ""
echo "--- Static anti-pattern guard (DoD #6: a reintroduced false-success SHAPE must fail this test, not only the behavior scenarios above) ---"
# The behavior scenarios block a reintroduced `|| true` *indirectly* (the no-verdict
# guard catches an empty crash output). A future edit could keep the verdict guards yet
# re-add `REVIEW_OUTPUT=$(...) || true` — restoring the exact F6 smell. This static
# check rejects the shape directly so the regression cannot slip back in.
for HOOK_PATH in "$HOOK" "$HOOK_MIRROR"; do
  _label="${HOOK_PATH#$REPO_ROOT/}"
  if grep -qE '\|\| true|continue-on-error' "$HOOK_PATH"; then
    _matches=$(grep -nE '\|\| true|continue-on-error' "$HOOK_PATH" | tr '\n' ';')
    echo "  FAIL: $_label contains a false-success anti-pattern: $_matches"
    FAIL_COUNT=$((FAIL_COUNT + 1))
  else
    echo "  PASS: $_label has no \`|| true\` / \`continue-on-error\` (F6 stays closed)"
    PASS_COUNT=$((PASS_COUNT + 1))
  fi
done

echo ""
echo "=== Summary ==="
echo "PASS: $PASS_COUNT"
echo "FAIL: $FAIL_COUNT"

if [ "$FAIL_COUNT" -gt 0 ]; then
  echo ""
  echo "RESULT: FAILURES DETECTED"
  exit 1
fi
echo "RESULT: ALL CHECKS PASSED"
