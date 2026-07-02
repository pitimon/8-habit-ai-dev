# Release Surface — every file a version bump touches

**Status**: Canonical reference (v2.21.37) | **Consumers**: maintainers bumping the version; agents preparing a release PR | **Origin**: lesson 2026-06-20 action item ("enumerate every file a bump touches"), overdue since v2.21.33; shipped in [#360](https://github.com/pitimon/8-habit-ai-dev/issues/360)

**Habit**: H2 (Begin with the End in Mind — the release checklist exists before the release) + H1 (Be Proactive — Check 19/27 failures are prevented, not debugged).

## The rule that triggers all of this

**Check 27** (`tests/validate-structure.sh`): any PR that changes a consumer-doctrine path since the last git tag must carry the version bump **in the same PR** — "Bundle later" defers the _tag_, never the _bump_ (lesson 2026-06-28). Once the version differs from the latest tag, follow-up PRs in the same bundle need no further bump; they extend the same version's notes instead.

## Version-bearing files (Check: `validate-structure.sh` version-consistency)

| #   | File                               | What to change                                                              |
| --- | ---------------------------------- | --------------------------------------------------------------------------- |
| 1   | `.claude-plugin/plugin.json`       | `"version"`                                                                 |
| 2   | `.claude-plugin/marketplace.json`  | `"version"`                                                                 |
| 3   | `.codex-plugin/plugin.json`        | `"version"`                                                                 |
| 4   | `plugin/.codex-plugin/plugin.json` | `"version"` (distinct file — NOT synced by `sync-mirror.sh`; edit directly) |
| 5   | `README.md`                        | Version badge (line ~8) **and** footer `_Version: X                         | Last updated: date_` |
| 6   | `SELF-CHECK.md`                    | Header line 3 `**Version**: X                                               | **Date**: …          | **Previous**: Y (…)` |

## Release-notes surfaces (Check 19, `validate-content.sh`)

| Surface                  | What Check 19 verifies                                                                                                                                                          |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `CHANGELOG.md`           | Entry for the new version exists                                                                                                                                                |
| `README.md` "What's New" | Heading `## What's New in vX` + TOC anchor `#whats-new-in-vX` (no dots)                                                                                                         |
| `docs/wiki/Changelog.md` | Badge `latest-vX` + entry (or pointer to CHANGELOG.md)                                                                                                                          |
| `SELF-CHECK.md`          | New scoring entry in the living per-release list + footer `Previous: <prior> (<prior scores>)` — the footer is derived from **git tags**, so it names the last _tagged_ version |

## Always after editing any of the above

```bash
bash scripts/sync-mirror.sh     # README/SELF-CHECK/CHANGELOG/CLAUDE.md/etc. have plugin/ twins
bash tests/ci-local.sh          # all 5 CI suites, not just validate-structure
```

## Honesty constraints on the notes themselves

- Notes must match what is **on main at tag time** — not what is planned. Pre-tag QA caught stale/overclaiming notes **two releases in a row** (v2.21.35: 2 blockers; v2.21.36: "10 scripts" vs actual 12). Grep every count/claim in the notes against the artifact before tagging.
- For a multi-PR bundle, write the entry to cover the shipped batch and extend it in each subsequent PR — never describe unshipped batches in past tense.
- Release checklist (decision gate, SKILL-EFFECTIVENESS harvest rule): `CONTRIBUTING.md` §"Release Checklist". Creating the tag is not the end: `gh release create` is a separate, required step, and the decision to tag is **human-only**.
