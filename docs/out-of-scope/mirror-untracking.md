---
date: 2026-06-20
originating-decision: "Issue #333 (deferred 'mirror generation' item from the scaffolding-diet arc, #329)"
rejected-because: Untracking or generating `plugin/` at release time contradicts ADR-023's requirement that it be a real committed Codex child directory; the symlink alternative already failed on Linux. Only the hand-sync toil is reducible (via scripts/sync-mirror.sh), not the tracked-mirror surface itself.
---

# We don't untrack or auto-generate the `plugin/` mirror — ADR-023 conflict

The over-engineering audit (2026-06-20) correctly named the `plugin/` mirror as the root of the
high ceremony-to-payload ratio: every content change to a mirrored path must be duplicated into
`plugin/`, and Check 28 enforces byte-for-byte parity. The tempting fix — "stop tracking `plugin/`
and generate it only at release" — was evaluated and **rejected**.

## Why the tempting fix is a no-go

[ADR-023](../adr/ADR-023-codex-native-packaging.md) (Accepted; amended by v2.21.10) requires
`plugin/` to be a **real, committed child directory**:

- Codex marketplace install resolves `codex plugin add 8-habit-ai-dev@pitimon-8-habit-ai-dev`
  against `./plugin` as the **child source path** — it must exist in the cloned repo, not be
  produced by a release step the installer never runs.
- The original `plugin -> .` symlink satisfied Codex but **broke Claude Code install on Linux**
  with `ENOENT: no such file or directory, symlink`. v2.21.10 replaced it with a real directory
  precisely to fix that regression. Untracking / generating the mirror would re-open that class.

So the doubled tracked surface is a **requirement of cross-agent packaging**, not incidental waste.
Removing it would require redesigning Codex packaging itself — a far larger, regression-prone change
than the toil it saves.

## What we do instead

- **`scripts/sync-mirror.sh`** (shipped with this decision) removes the _hand-copying_ toil: it
  copies the 8 mirrored dirs + 11 root files into `plugin/` in one command, so Check 28 passes
  without manually `cp`-ing each touched file. The mirror stays tracked; only the keystrokes go away.
- The **cadence default = `Bundle later`** (CONTRIBUTING.md) and the **F21 Check-27 fix** (#329)
  already removed the _other_ half of the "14 files for one sentence" pain — spurious version bumps
  on contributor-doctrine changes. What remains is just the (required) mirror copy.

## If reconsidering, these must all hold

1. Codex packaging gains a supported way to resolve a child source that is generated at install
   (or the marketplace contract changes) such that `./plugin` need not be committed.
2. A Linux Claude Code install is verified end-to-end against the new shape (the exact regression
   ADR-023 v2.21.10 fixed) — with evidence, not assumption.
3. The change is scoped via its own `/research` + `/design`; it is an architecture decision (H8),
   not a tooling tweak.

Until then, the disciplined outcome is this record plus the sync helper — a decision to **not build**
the ambitious version, with the toil reduced rather than the contract broken.
