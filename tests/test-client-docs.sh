#!/bin/bash
# Client-first navigation and canonical catalog contracts, including fixtures.
set -euo pipefail
cd "$(dirname "$0")/.."
SELF="$PWD/tests/test-client-docs.sh"

check_docs() {
  local root=$1 failed=0 client guide section s names duplicate foreign code body
  local catalog="$root/docs/skills-reference.md"
  if [ ! -f "$catalog" ]; then
    echo 'FAIL: canonical skill catalog missing'; return 1
  fi
  names=$(awk -F '`' '/^\| `[a-z0-9-]+` \|/ {print $2}' "$catalog")
  duplicate=$(printf '%s\n' "$names" | sort | uniq -d)
  if [ -n "$duplicate" ]; then
    echo "FAIL: catalog lists duplicate skill $duplicate"; failed=1
  fi
  for s in "$root"/skills/*/SKILL.md; do
    [ -f "$s" ] || continue
    s=${s%/SKILL.md}; s=${s##*/}
    if ! printf '%s\n' "$names" | grep -Fxq "$s"; then
      echo "FAIL: catalog missing skill $s"; failed=1
    fi
  done
  if [ -z "$names" ]; then
    echo 'FAIL: empty skill catalog'; failed=1
  fi
  while IFS= read -r s; do
    [ -n "$s" ] || continue
    if [ ! -f "$root/skills/$s/SKILL.md" ]; then
      echo "FAIL: catalog lists unknown skill $s"; failed=1
    fi
  done <<< "$names"
  if ! grep -Fq '(docs/skills-reference.md)' "$root/README.md"; then
    echo 'FAIL: README does not link canonical skill catalog'; failed=1
  fi
  if grep -Eq '^(claude|codex|hermes|openclaw) (plugin|plugins|skills)' "$root/README.md"; then
    echo 'FAIL: README contains client setup commands'; failed=1
  fi
  for client in claude-code codex hermes openclaw; do
    guide="docs/$client-integration.md"
    if ! grep -Fq "($guide)" "$root/README.md" || [ ! -f "$root/$guide" ]; then
      echo "FAIL: README client route missing: $client"; failed=1; continue
    fi
    for section in Install Verify 'First task' 'Daily use' Update Troubleshooting; do
      if ! grep -Fxq "## $section" "$root/$guide"; then
        echo "FAIL: $client guide missing section: $section"; failed=1
      else
        body=$(awk -v heading="## $section" '
          $0 == heading {found=1; next}
          found && /^## / {exit}
          found && /[^[:space:]]/ && !/^#/ && !/^```/ {print; exit}
        ' "$root/$guide")
        if [ -z "$body" ]; then
          echo "FAIL: $client guide empty section: $section"; failed=1
        fi
      fi
    done
    code=$(awk '
      /^```/ {in_code=!in_code; next}
      in_code {sub(/^[[:space:]]+/, ""); sub(/^\$[[:space:]]+/, ""); print}
    ' "$root/$guide")
    case "$client" in
      claude-code) foreign='^(codex|hermes|openclaw) (plugin|plugins|skills)' ;;
      codex) foreign='^(claude|hermes|openclaw) (plugin|plugins|skills)|^/(requirements|review-ai|cross-verify)([[:space:]]|$)' ;;
      hermes) foreign='^(claude|codex|openclaw) (plugin|plugins|skills)' ;;
      openclaw) foreign='^(claude|codex|hermes) (plugin|plugins|skills)' ;;
    esac
    if printf '%s\n' "$code" | grep -Eq "$foreign"; then
      echo "FAIL: $client guide contains foreign client commands"; failed=1
    fi
  done
  [ "$failed" -eq 0 ]
}

if [ "${1:-}" = --check-only ]; then
  check_docs "$2"; exit $?
fi
check_docs "$PWD"
TMP=$(mktemp -d "${TMPDIR:-/tmp}/client-docs.XXXXXX")
trap 'rm -rf "$TMP"' EXIT
fixture() {
  rm -rf "$TMP/repo"; mkdir -p "$TMP/repo/docs" "$TMP/repo/skills/example"
  printf 'example\n' > "$TMP/repo/skills/example/SKILL.md"
  printf '| `example` | Example |\n' > "$TMP/repo/docs/skills-reference.md"
  printf '[Catalog](docs/skills-reference.md)\n' > "$TMP/repo/README.md"
  for client in claude-code codex hermes openclaw; do
    printf '[%s](docs/%s-integration.md)\n' "$client" "$client" >> "$TMP/repo/README.md"
    printf '## Install\nInstallation steps.\n## Verify\nVerification steps.\n## First task\nTask example.\n## Daily use\nDaily guidance.\n## Update\nUpdate steps.\n## Troubleshooting\nTroubleshooting steps.\n' > "$TMP/repo/docs/$client-integration.md"
  done
}
assert_case() {
  local name=$1 expected=$2 diagnostic=$3 rc=0
  bash "$SELF" --check-only "$TMP/repo" > "$TMP/log" 2>&1 || rc=$?
  if [ "$expected" = pass ]; then
    [ "$rc" -eq 0 ] || { echo "FAIL: fixture $name"; return 1; }
  else
    if [ "$rc" -eq 0 ] || ! grep -Fq "$diagnostic" "$TMP/log"; then
      echo "FAIL: fixture $name did not reject for $diagnostic"; return 1
    fi
  fi
  echo "  PASS: client-doc fixture $name"
}
fixture; assert_case valid pass ''
printf '| `missing` | Phantom |\n' >> "$TMP/repo/docs/skills-reference.md"
assert_case phantom fail 'unknown skill missing'
fixture; printf 'no rows\n' > "$TMP/repo/docs/skills-reference.md"
assert_case missing-entry fail 'catalog missing skill example'
fixture; rm "$TMP/repo/docs/codex-integration.md"
assert_case broken-route fail 'client route missing: codex'
fixture; printf '\n```bash\nclaude plugin list\n```\n' >> "$TMP/repo/docs/codex-integration.md"
assert_case foreign-command fail 'foreign client commands'
fixture; printf '\n```bash\n  claude plugin list\n```\n' >> "$TMP/repo/docs/codex-integration.md"
assert_case indented-foreign-command fail 'foreign client commands'
fixture; printf '\n```bash\n$ claude plugin list\n```\n' >> "$TMP/repo/docs/codex-integration.md"
assert_case prompt-prefixed-command fail 'foreign client commands'
fixture; printf '\n```text\n/requirements feature\n```\n' >> "$TMP/repo/docs/codex-integration.md"
assert_case codex-wrong-invocation fail 'foreign client commands'
fixture; printf 'codex plugin add something\n' >> "$TMP/repo/README.md"
assert_case landing-setup fail 'README contains client setup commands'
fixture; printf '# No journey\n' > "$TMP/repo/docs/hermes-integration.md"
assert_case incomplete-guide fail 'hermes guide missing section'
fixture; printf '## Install\n## Verify\n## First task\n## Daily use\n## Update\n## Troubleshooting\n' > "$TMP/repo/docs/hermes-integration.md"
assert_case empty-sections fail 'hermes guide empty section'
fixture; printf '| `example` | Duplicate |\n' >> "$TMP/repo/docs/skills-reference.md"
assert_case duplicate-entry fail 'duplicate skill example'
echo 'RESULT: PASS — client routes, canonical catalog and 12 regression fixtures'
