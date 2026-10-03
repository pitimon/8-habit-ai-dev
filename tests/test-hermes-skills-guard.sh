#!/bin/bash
# test-hermes-skills-guard.sh — keep every skill installable through the Hermes Skills Hub.
#
# WHY: `hermes skills install pitimon/8-habit-ai-dev/skills/<name>` runs Hermes's
# static security scanner (tools/skills_guard.py) over the skill directory.
# Community-sourced skills with a high finding are blocked (CAUTION -> needs
# --force); with a critical finding they are refused outright (DANGEROUS, even
# with --force). The scanner matches wording, not behaviour, so innocent prose
# can block a whole skill. v2.21.52 shipped `save-spec` as DANGEROUS and
# `breakdown` as CAUTION; neither repo validator noticed.
#
# Two layers:
#   1. Static (always, CI-safe): the HTML-comment pattern copied verbatim from
#      skills_guard.py `html_comment_injection`. save-spec uses <!-- TODO -->
#      scaffold comments, so one stray keyword re-breaks the install.
#   2. Real scanner (when a Hermes checkout is available locally): runs
#      skills_guard.scan_skill on every skills/<name>/ and fails on any verdict
#      other than "safe". CI has no Hermes install, so CI runs layer 1 only;
#      run this script locally before a release to get layer 2.
#      Override the checkout with HERMES_AGENT_DIR=/path/to/hermes-agent.
#
# USAGE: bash tests/test-hermes-skills-guard.sh
set -euo pipefail

cd "$(dirname "$0")/.."
REPO="$PWD"

FAIL=0

# Layer 1 — verbatim from skills_guard.py html_comment_injection.
HTML_RE='<!--[^>]*(ignore|override|system|secret|hidden)[^>]*-->'
for dir in skills plugin/skills; do
  if hits=$(grep -rnEi --include='*.md' "$HTML_RE" "$dir" 2>/dev/null); then
    echo "FAIL: HTML comment containing ignore/override/system/secret/hidden in $dir/"
    echo "      Hermes skills_guard flags this as html_comment_injection (high) and blocks install."
    echo "$hits" | sed 's/^/      /'
    FAIL=1
  fi
done
[ "$FAIL" -eq 0 ] && echo "PASS: no Hermes-flagged HTML comments in skills/ or plugin/skills/"

# Layer 2 — real scanner, local only.
HA="${HERMES_AGENT_DIR:-$HOME/.hermes/hermes-agent}"
PY="$HA/venv/bin/python"
if [ -x "$PY" ] && [ -f "$HA/tools/skills_guard.py" ]; then
  if ! out=$(cd "$HA" && "$PY" - "$REPO/skills" <<'EOF'
import sys
from pathlib import Path
sys.path.insert(0, ".")
import tools.skills_guard as g
root = Path(sys.argv[1])
bad = 0
for d in sorted(p for p in root.iterdir() if p.is_dir() and (p / "SKILL.md").exists()):
    r = g.scan_skill(d, source="community")
    if r.verdict != "safe":
        bad += 1
        print(f"FAIL: {d.name}: verdict={r.verdict}")
        for f in r.findings:
            if f.severity in ("critical", "high"):
                print(f"      {f.severity} {f.pattern_id} {f.file}:{f.line} {f.match[:70]!r}")
n = sum(1 for p in root.iterdir() if (p / "SKILL.md").exists())
if n == 0:
    print(f"FAIL: no skills found under {root}"); sys.exit(1)
print(f"scanned={n} not_safe={bad}")
sys.exit(1 if bad else 0)
EOF
  ); then
    echo "$out"
    FAIL=1
  else
    echo "PASS: Hermes skills_guard verdict is safe for every skill ($(echo "$out" | tail -1))"
  fi
else
  echo "SKIP: Hermes checkout not found at $HA — real-scanner layer not run (CI runs layer 1 only)"
fi

if [ "$FAIL" -ne 0 ]; then
  echo ""
  echo "RESULT: FAILED"
  exit 1
fi
echo "RESULT: PASS"
