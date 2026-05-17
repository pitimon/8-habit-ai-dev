# Project SPEC.md Digest Pattern (project-orientation hub mode)

A single-page `SPEC.md` at the project root that points to project-specific detail files, surfaces a compact decision digest, and acts as the read-first save point after `/clear` or `/compact`.

This is **complementary** to the `--persist <slug>` feature-spec mode documented in [`persistence-convention.md`](./persistence-convention.md) — different shape for a different project archetype, not a replacement.

**Plugin enforcement**: none. This guide documents a pattern; users adopt it manually in their own repo. There is no `/save-spec` skill (yet — see [Promotion criteria](#promotion-to-a-skill-deferred) below).

---

## Two deployment modes

| Mode                                          | Shape                                                                                                             | Fits                                                                              | Maintained by                                                                                          |
| --------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| **Feature-spec mode** (v2.15.0+)              | `docs/specs/<slug>/{prd,design,tasks,current-state}.md` per feature                                               | Greenfield features, EARS requirements, multi-feature repos                       | `/requirements --persist`, `/design --persist`, `/breakdown --persist` + user-owned `current-state.md` |
| **Project-orientation hub mode** (this guide) | Single project-root `SPEC.md` + project-specific detail files (`PLAYBOOK.md`, `CONTRACTS.md`, `LESSONS.md`, etc.) | Operational repos, infra pipelines, integration projects, single-system codebases | User-owned, manual (or via CLAUDE.md rule)                                                             |

Both can coexist in the same repo if needed — they don't reference each other. Most projects pick one.

## When to use the digest pattern

Use it when:

- The repo has **one coherent system**, not many independent features
- Detail naturally lives in **project-specific files** (e.g. `PLAYBOOK.md` for ops, `CONTRACTS.md` for data shapes, `CHANGELOG.md` for history) — not in per-feature `prd.md`/`design.md`
- You frequently `/clear` or `/compact` mid-task and re-orient via a single file read
- A new contributor (human or AI) needs **one page** to understand "what is this repo, what's been decided, what's in flight"

Use the feature-spec mode instead when:

- You ship multiple parallel features, each with its own scope
- You want `/consistency-check` to validate PRD ↔ design ↔ tasks drift
- Your work is greenfield specification, not maintenance of a running system

## Template

Copy this into `SPEC.md` at the project root. Fill the four sections. Keep it ≤ 200 lines — if it grows past that, push detail into pointer-targets.

````markdown
# SPEC.md — <project-name> save point

Single-page reference. Read this first when starting a new session.

> **Rule** (per `CLAUDE.md`): every completed task updates §4 (Current state) and §3 (Backlog). Never claim "done" without updating this file.

---

## 1. Architecture (pointer)

<One paragraph summarizing what this system is + where it runs.>

- **Detailed runbook / ops** → `PLAYBOOK.md`
- **Data contracts / API shapes** → `CONTRACTS.md`
- **Lessons & post-mortems** → `LESSONS.md`
- **Per-event history** → `CHANGELOG.md`
- <Add project-specific pointers here. Wrap each filename in Markdown link syntax in your own copy if you want clickable references — kept as plain backticked names here so the template stays portable.>

## 2. Decisions snapshot (pointer)

The N most load-bearing decisions. Each row = one line + canonical source. Keep ≤ 10 rows — if it grows, prune to the most active.

| #   | Decision          | Why               | Source          |
| --- | ----------------- | ----------------- | --------------- |
| D1  | <terse statement> | <terse rationale> | `<file>:<line>` |

Per-event history: `CHANGELOG.md`. Root-cause post-mortems: `LESSONS.md`.

## 3. Live backlog

**The only place backlog is maintained.** Stale items are deleted, not archived.

- [ ] <Active backlog item — what + where + blocker if any>
- [x] ~~<Shipped item, with date + source link>~~

## 4. Current state — save point

**Read this section first after `/clear` or `/compact`.**

> **Last updated**: <ISO 8601 date>
> **Last apply / commit / deploy event**: <terse note + timestamp>

### What's happening now

<Specific task/sub-task active right now, with file paths and progress.>

### Stuck / waiting on

<What blocks progress, or "nothing".>

### Next session entry point

```bash
cd <repo-root>
cat SPEC.md                  # this file
# then inspect §4 above for "what changed last"
```

<Optional: command sequence to resume the in-flight work, e.g. health check + next step.>
````

## CLAUDE.md auto-update rule (user-side)

To keep `SPEC.md` honest without remembering, add this to the project's `CLAUDE.md`:

```markdown
## After completing any task:

1. Update `SPEC.md` §4 (Current state) — what changed, what's next, last-updated timestamp
2. Update `SPEC.md` §3 (Backlog) — check off completed items, add new ones surfaced
3. Update data contracts in the file referenced from `SPEC.md` §1 if any interface changed
4. Never claim "done" without updating `SPEC.md` first
```

**Plugin does not enforce this.** Same boundary as the feature-spec mode auto-update recipe ([`persistence-convention.md`](./persistence-convention.md#auto-update-recipe-user-side-optional)) — the plugin teaches the pattern; the user owns enforcement via their own CLAUDE.md rule.

## What this pattern is NOT

To prevent confusion with rejected alternatives in [ADR-013](../docs/adr/ADR-013-spec-persistence-opt-in.md):

- **Not a replacement for `prd.md` / `design.md` / `tasks.md`** — `SPEC.md` is a **digest layer above** them (when feature-spec mode is also in use), or stands alone (when it isn't). It points; it doesn't subsume.
- **Not auto-written by a skill or hook** — ADR-013 Alternative 4 rejected always-on auto-persist. This pattern relies on user-side discipline + the optional CLAUDE.md rule above.
- **Not a `/consistency-check` input** — that analyzer operates on the 3-file PRD↔design↔tasks artifacts in `docs/specs/<slug>/`. A free-form `SPEC.md` is out of scope by design.
- **Not a `/save-point` or `/resume` skill** — those were rejected as duplicating `/reflect` (see CHANGELOG v2.15.0). The digest is a hand-curated file, not a generated artifact.

## Decisions table — formatting guidance

The Decisions table (§2) is the highest-value section after §4. Treat it as a **compact ADR digest**:

- One row per load-bearing decision — the ones a new contributor would otherwise re-litigate
- Three columns: **Decision** (statement), **Why** (one-line rationale), **Source** (canonical file:line or ADR link)
- Cap at 10 rows — if you exceed, prune the least active (the original ADR lives on; the digest is just the pointer)
- Use `file:line` links for runtime decisions encoded in code; use ADR links for architectural decisions encoded in docs

Example row format (linkify filenames in your own copy if you want clickable refs — backticks here keep the template portable across renderers):

```markdown
| D1 | **IP address = idempotency key** (not name) | Vendor-default names collide ("Proxmox VE" × 20) | `sync/promote.py:100-114` + `LESSONS.md §22` |
```

## Promotion to a skill (deferred)

A user-invoked `/save-spec <slug>` skill that generates/updates this digest from existing files is plausible but **not shipped**. Promotion criteria, per the working-with-pitimon "minimal additions, user-demand-driven" stance:

1. ≥ 2 independent projects adopt the digest pattern from this guide
2. The scope question (project-root `SPEC.md` vs per-slug `current-state.md` in multi-feature repos) has a resolved answer in writing
3. There is at least one captured `/reflect` lesson naming "manually maintaining the digest was tedious" or equivalent friction signal

Until those three signals exist, the guide is the canonical form. Track adoption in [#194](https://github.com/pitimon/8-habit-ai-dev/issues/194) and downstream issues.

## Verification

To verify a `SPEC.md` follows this pattern:

```bash
# All four sections present?
grep -E '^## [1-4]\.' SPEC.md | wc -l   # expect 4

# Save-point hint present in §4?
grep -A1 '## 4. Current state' SPEC.md | grep -i 'clear.*compact'

# Last-updated timestamp present?
grep -E 'Last updated' SPEC.md

# Pointers actually resolve?
grep -oE '\]\([^)]+\.md\)' SPEC.md | sed 's/[])(]//g' | xargs -I{} ls {}
```

---

## Attribution

This pattern is documented from a production artifact (`netbox-sit/SPEC.md`, 153 lines, May 2026) that independently arrived at the four-section shape after the user observed `/clear` and `/compact` repeatedly flushing in-flight context. The same Thai-language community article (_"ผมไม่เคยกลัว /clear กับ /compact"_) inspired both the per-feature `current-state.md` convention ([#176](https://github.com/pitimon/8-habit-ai-dev/issues/176)) and this project-orientation digest pattern ([#194](https://github.com/pitimon/8-habit-ai-dev/issues/194)) — different shapes from the same insight, fitting different repo archetypes.
