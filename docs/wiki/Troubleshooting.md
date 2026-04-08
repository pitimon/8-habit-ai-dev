# Troubleshooting

Common issues and fixes. If your problem is not listed, [open an issue](https://github.com/pitimon/8-habit-ai-dev/issues).

## Installation

### The session-start banner does not appear

**Symptom**: No `## 8-Habit AI Dev Active` block at the top of the conversation.

**Checks**:

1. Confirm installation: `claude plugin list` should show `8-habit-ai-dev@pitimon-8-habit-ai-dev`
2. Restart Claude Code — the session hook runs at session start, not mid-session
3. Check `hooks/hooks.json` is loaded — if you cloned the plugin manually, ensure the `hooks/` directory is intact
4. Verify `hooks/session-start.sh` is executable: `chmod +x hooks/session-start.sh`

### `plugin install` fails with "marketplace not found"

Run `claude plugin marketplace add pitimon/8-habit-ai-dev` **first**, then `claude plugin install ...`. See [Installation](Installation).

### Skills do not appear when I type `/`

- Restart Claude Code after installation
- Confirm the plugin is enabled: `claude plugin list`
- The skills autoload on first invocation — try typing `/workflow` directly

## Workflow

### `/review-ai` says "no diff to review"

You have no staged or unstaged changes. Run it **after** writing code, not before.

### `/design` only gives me one option

The skill requires **at least 2 options with trade-offs**. If Claude produced only one, re-prompt: _"Show me at least 2 alternatives with pros and cons for each decision."_ See [Step 2 · Design](Step-2-Design).

### `/breakdown` produces tasks that touch >5 files

Tasks are too big. Re-prompt: _"Break task N down further — each task must touch at most 5 files."_

### I keep skipping `/review-ai`

Add a git pre-commit hook or CI gate that blocks commits without a recorded review. The rule is **never skip review**, no matter how small.

## Cross-verify

### `/cross-verify` fails with "no plan to verify"

`/cross-verify` expects an implementation plan or a draft commit. Run it **after** `/breakdown` and **before** committing, or pass the file path explicitly.

### The 17-question checklist feels like overkill for a 3-line fix

It is. Skip `/cross-verify` for trivial fixes; use it for anything touching >3 files or affecting architecture.

## Wiki

### My wiki edit disappeared

You edited via the GitHub Wiki web UI. **The wiki is a build artifact** — source lives in `docs/wiki/` and web edits are overwritten on the next sync. See [Contributing to Wiki](Contributing-to-Wiki) for the correct workflow.

### Wiki sync Action failed with "wiki not found"

Enable the wiki on the repository first: **Settings → Features → Wikis** → check. Then seed a stub `Home` page via the web UI once. After that, the Action takes over.

### `lychee` link-check fails on a new PR

A link in `docs/wiki/**/*.md` is broken. Check the Action log for the specific URL. Fix the link or add it to a `lychee.toml` allowlist if it is a known flaky external URL.

## Validation scripts

### `tests/validate-structure.sh` fails after adding a new skill

The script expects every skill to have: `SKILL.md` with valid frontmatter, matching directory name, and allowed `allowed-tools` values. Run the script output — it points at the exact file and line.

### `tests/validate-content.sh` fails on fitness functions

The three fitness functions enforce limits on skill complexity, content depth, and cross-reference integrity. See [ADR-003](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-003-content-validation.md) for details and thresholds.

## Still stuck?

- **FAQ**: [FAQ](FAQ)
- **Open an issue**: [github.com/pitimon/8-habit-ai-dev/issues](https://github.com/pitimon/8-habit-ai-dev/issues)
- **Source**: [github.com/pitimon/8-habit-ai-dev](https://github.com/pitimon/8-habit-ai-dev)
