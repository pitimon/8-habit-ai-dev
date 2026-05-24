# ADR-019: Refine ADR-017 §C5 Doctrine-Only Scope — Split Contributor-Doctrine vs Consumer-Doctrine

**Status**: Accepted
**Date**: 2026-05-24
**Decision makers**: Pitimon (human) + Claude Opus 4.7 (AI, 1M context)
**Related**: [ADR-017 §C5](./ADR-017-anthropic-skill-patterns-audit.md) (amended via cross-reference), [ADR-018](./ADR-018-memory-layer-activation.md) (provides next-PR friction signal), [ADR-015](./ADR-015-diagnose-skill-adoption-and-n1-framing.md) (friction-first doctrine — satisfied), [ADR-016](./ADR-016-t2-bag-drop-date-eviction-policy.md) (eviction convention applied to T2 + Sunset)
**Source**: [Issue #229](https://github.com/pitimon/8-habit-ai-dev/issues/229) + advisor consult 2026-05-24 (post PR #228 merge)

---

## Context

[ADR-017 §C5](./ADR-017-anthropic-skill-patterns-audit.md) introduced the rule that "doctrine-only commits don't require version bump or CHANGELOG entry." The rule's purpose was to avoid version-bump theater when only ADR/CONTRIBUTING/internal-doc files changed — those don't affect plugin consumers.

The rule carries an **implicit assumption: doctrine ⇒ contributor-only audience**. A 2026-05-24 audit immediately after PR #228 (ADR-018 follow-up bundle, doctrine-only per §C5) confirmed the assumption holds for that PR's specific changes:

| Path changed                       | Audience                                                      | §C5 holds? |
| ---------------------------------- | ------------------------------------------------------------- | ---------- |
| `CLAUDE.md`                        | Contributors only (auto-loaded only when `cd` INTO this repo) | ✓          |
| `CONTRIBUTING.md`                  | Contributors only (repo-internal)                             | ✓          |
| `.github/PULL_REQUEST_TEMPLATE.md` | Contributors only (fires only on PRs to this repo)            | ✓          |
| `docs/adr/ADR-018-*.md`            | Contributors / curious users (historical record)              | ✓          |

**But the assumption is about to break.** [ADR-018 §"Context"](./ADR-018-memory-layer-activation.md) explicitly names `rules/effective-development.md` (~200 lines, **auto-loaded into every Claude Code session of every plugin consumer**) as the next "Earn each line" audit target after `CLAUDE.md`. When that audit ships, the current §C5 rule would classify it as "doctrine-only" — producing a **silent user-facing behavioral shift** with no version bump, no CHANGELOG entry, and no signal to consumers.

The gap isn't ceremony-missing on PR #228 (consumer-impact = 0 there, audit-confirmed). The gap is that **"doctrine-only" is too coarse a category** — it conflates:

- **Contributor-doctrine**: changes that only reach people working in or contributing to the repo. No signal needed; ceremony is overhead.
- **Consumer-doctrine**: changes that reach plugin consumers via runtime loading even when the change _style_ is "doctrine refinement." Signal IS needed.

The current §C5 rule treats both as the same category. ADR-019 splits them.

## Tier Framework Applied (ADR-014)

| Tier   | Criterion                                                                                                    | Action                                      |
| ------ | ------------------------------------------------------------------------------------------------------------ | ------------------------------------------- |
| **T1** | Real gap + fits doctrine refinement scope + plugin boundary clean + clear habit map (H1 + H4)                | **Ship** in this release (v2.18.2)          |
| **T2** | Edge case — `scripts/**` classification deferred until first user-facing script ships                        | **Defer** with ADR-016 drop date 2026-11-24 |
| **T3** | Retroactive CHANGELOG for PR #228 (consumer-impact = 0); cross-plugin enforcement (claude-governance domain) | **Reject**                                  |

## Options Considered

### Option A — Wait for friction (ADR-015 default)

- **Description**: Defer until first time a `rules/`-touching PR is incorrectly tagged doctrine-only, then refine.
- **Pro**: Zero proactive work. Aligns with ADR-015 friction-first doctrine literally.
- **Con**: ADR-018 §"Context" already names `rules/effective-development.md` as the next audit target — friction signal **already exists**, just hasn't fired as a bug yet. Letting a silent user-facing shift slip through has higher cost than the fix. ADR-015 requires n≥1 friction signal but doesn't require that signal to be a bug — recognition of a structural gap is signal.

### Option B — Shadow CHANGELOG (entry for every commit including doctrine)

- **Description**: Remove §C5 exception. Every commit, including pure ADR/CONTRIBUTING changes, gets a CHANGELOG entry.
- **Pro**: Catches everything mechanically.
- **Con**: Ceremony heavy. Bloats CHANGELOG with noise (e.g., typo fixes). Destroys signal-to-noise ratio of CHANGELOG itself. Directly contradicts the "earn each line" doctrine just ratified in ADR-018.

### Option C — Semantic-only refine (per-PR judgment, no validator)

- **Description**: Document the contributor-doctrine vs consumer-doctrine distinction; require maintainer judgment per PR.
- **Pro**: Matches the actual conceptual distinction; minimal infrastructure.
- **Con**: Inconsistent over time as maintainer/contributors change context. No enforcement = doctrine drifts back to original §C5 behavior under pressure.

### Option D — File-path-only refine (mechanical only, no ADR explanation)

- **Description**: Add validator check on file paths; skip the semantic ADR.
- **Pro**: Validator-enforceable; no per-PR judgment required.
- **Con**: No semantic framework for edge cases. Future maintainer sees the validator rule but doesn't understand WHY — leads to bypass-by-confusion or misclassification.

### Option E — Hybrid: semantic ADR + file-path validator (recommended)

- **Description**: ADR-019 establishes the semantic distinction (contributor-doctrine vs consumer-doctrine) with explicit file-path mapping. `tests/validate-structure.sh` gains a mechanical check that enforces the file-path mapping by default.
- **Pro**: Matches the existing pattern (`version lives in 4 files` = semantic rule + `validate-structure.sh` enforcement). Both layers explicit. Validator catches unambiguous cases automatically; semantic ADR provides framework for edge cases. Refines, doesn't replace, §C5.
- **Con**: Slightly more work than Option D alone. Path lists may need refinement as edge cases surface (mitigated by 2026-11-24 sunset review).

## Decision

**Choose Option E.** Ship semantic ADR + file-path validator in v2.18.2.

### Categorization

**Contributor-doctrine** (no bump, no CHANGELOG — preserves ADR-017 §C5):

| Path                                                                      | Why contributor-only                                                  |
| ------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| `CLAUDE.md`, `AGENTS.md`, `llms.txt`                                      | Auto-loaded only when `cd` INTO this repo; plugin consumers don't see |
| `CONTRIBUTING.md`                                                         | Repo-internal                                                         |
| `docs/adr/**`, `docs/out-of-scope/**`, `docs/wiki/**`                     | Historical record / reference docs                                    |
| `.github/**`                                                              | PR templates, CI workflows — fire only on PRs to this repo            |
| `SELF-CHECK.md`                                                           | Status doc, not loaded at runtime                                     |
| `tests/**`                                                                | Validation scripts; contributor-tooling, run in CI                    |
| `.claude-plugin/marketplace.json` (when only `lastUpdated` field changes) | Metadata drift, not behavior                                          |

**Consumer-doctrine** (MUST bump + CHANGELOG, even if change style is "doctrine refinement"):

| Path                                                                 | Why consumer-facing                                                      |
| -------------------------------------------------------------------- | ------------------------------------------------------------------------ |
| `rules/**`                                                           | Auto-loaded into every Claude Code session via Claude's rules system     |
| `skills/**`                                                          | Loaded on-demand when consumer invokes `/skill-name`                     |
| `hooks/**`                                                           | Run at SessionStart for every consumer                                   |
| `habits/**`                                                          | Loaded by skills via `Load ${CLAUDE_PLUGIN_ROOT}/habits/h*.md` directive |
| `guides/**`                                                          | Referenced by skills via `Load` directive                                |
| `agents/**`                                                          | Available to consumers as subagent definitions                           |
| `.claude-plugin/plugin.json` (any field besides version-bump itself) | Plugin behavior config                                                   |

### Mechanical Enforcement

Extend `tests/validate-structure.sh` with a new check (Check 34 or next available):

```bash
# Detect changes since last release tag (fallback: last commit on main)
LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
DIFF_BASE=${LAST_TAG:-$(git merge-base HEAD main 2>/dev/null || echo HEAD~1)}
CHANGED=$(git diff --name-only "$DIFF_BASE"..HEAD 2>/dev/null || echo "")

CONSUMER_DOCTRINE_REGEX='^(rules|skills|hooks|habits|guides|agents)/'
TOUCHED_CONSUMER=$(echo "$CHANGED" | grep -E "$CONSUMER_DOCTRINE_REGEX" || true)

if [ -n "$TOUCHED_CONSUMER" ]; then
  # Consumer-doctrine paths changed — version-4-files MUST bump
  CURRENT_VERSION=$(grep '"version"' .claude-plugin/plugin.json | head -1 | sed 's/.*"version": "\(.*\)".*/\1/')
  LAST_RELEASE_VERSION=$(echo "$LAST_TAG" | sed 's/^v//')
  if [ "$CURRENT_VERSION" = "$LAST_RELEASE_VERSION" ]; then
    echo "FAIL: consumer-doctrine paths changed since $LAST_TAG but version not bumped"
    echo "      Changed: $(echo "$TOUCHED_CONSUMER" | tr '\n' ' ')"
    echo "      Cite: ADR-019 (consumer-doctrine PRs require version bump + CHANGELOG)"
    exit 1
  fi
fi
```

If only contributor-doctrine paths changed → check passes regardless of version state (preserves §C5 intent).

### Self-test for THIS PR

This PR touches:

- `docs/adr/ADR-019-*.md` (contributor-doctrine)
- `tests/validate-structure.sh` (contributor-doctrine — tooling)
- `docs/adr/ADR-017-*.md` (contributor-doctrine — cross-reference note)
- `CHANGELOG.md` (contributor-doctrine — release notes)
- `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`, `README.md`, `SELF-CHECK.md` (version-4-files bump)

**Validator outcome**: PASS (no consumer-doctrine paths touched → no bump required by ADR-019). Version bump in this PR is **elective**, not enforced by ADR-019.

**Why bump electively**: introducing a new validator check is a meta-change to CI behavior — contributors should be signalled that "the rules of the game changed." Patch bump (v2.18.1 → v2.18.2) is the right grain: doctrine refinement + internal CI enhancement, no skill behavior change, backwards-compatible for existing PRs that don't touch consumer-doctrine paths.

### Out of Scope (T3)

- **Retroactive fix for PR #228** — audit confirmed consumer-impact = 0 (CLAUDE.md/CONTRIBUTING.md/PR template/ADR-018 all contributor-doctrine under the new classification). No action needed.
- **Cross-plugin enforcement** — claude-governance owns runtime hooks; this ADR is workflow discipline only.
- **Automated CHANGELOG generation** — separate concern; current manual entries are sufficient.

### Deferred (T2) — drop date 2026-11-24

- **`scripts/**`classification** — currently no consumer-facing scripts ship in the plugin (only`scripts/gen-habits-reference.sh`+`scripts/generate-ai-dev-log.sh`, both maintainer-tooling). Revisit when the first user-facing script appears. Drop date 2026-11-24 per ADR-016: if no user-facing script ships by then, the deferral is moot and the question can be dropped.

## Consequences

### Habit Mapping

- **H1 (Be Proactive)** — primary. Close the structural gap before the next PR fires it as a silent shift.
- **H4 (Win-Win, deposit)** — consumers receive signal when behavior changes (CHANGELOG entry + version bump). Eliminates "why did my session behave differently after `claude plugin update`?" mystery.

### What changes

- ADR-017 §C5 gains a cross-reference note pointing to ADR-019 (additive; the §C5 rule itself is preserved, scope is refined).
- `tests/validate-structure.sh` gains 1 check.
- Future PRs touching `rules/`/`skills/`/`hooks/`/`habits/`/`guides/`/`agents/` without bumping the 4 version files → CI fail with citation to ADR-019.
- v2.18.2 ships with this ADR + validator addition.

### What doesn't change

- ADR-017 §C5 itself (intent preserved; refined, not replaced).
- Existing doctrine-only PRs (no retroactive action — PR #228 stays as merged).
- Plugin boundary with `claude-governance` (no runtime hook added here; this is contributor-side CI).
- The "version lives in 4 files" rule from CLAUDE.md (this ADR adds a trigger condition, doesn't change the bump mechanic).

### Risks

- **Path lists may miss edge cases** — e.g., a future `.claude-plugin/plugin.json` field that affects consumer experience but isn't behavior-changing in spirit. Mitigated by 2026-11-24 sunset review with explicit reversal criteria.
- **"Doctrine-only" semantic still requires per-PR judgment for borderline cases** — e.g., a `docs/wiki/` change that someone might argue affects consumers via website. Validator catches unambiguous cases; maintainer judgment for the rest. Documented in this ADR's categorization tables.
- **Validator drift** — if `tests/validate-structure.sh` is itself modified in a way that disables the check, the rule silently dies. Mitigated by including the check in the same test suite that CI runs.

## Validation

### Shipped in this ADR's PR

- [ ] `docs/adr/ADR-019-doctrine-only-scope-refinement.md` exists with Status: Accepted.
- [ ] `tests/validate-structure.sh` includes the new consumer-doctrine bump check.
- [ ] Self-test: `bash tests/validate-structure.sh` PASSES on this PR (contributor-doctrine only + version bumped electively).
- [ ] ADR-017 §C5 has a cross-reference note added pointing to ADR-019.
- [ ] CHANGELOG entry for v2.18.2 added.
- [ ] Version bumped to 2.18.2 in all 4 files.

### Validation deferred to future PRs

- [ ] At least 1 consumer-doctrine PR (e.g., when `rules/effective-development.md` audit ships) successfully blocked by the check if version isn't bumped (proves the check works in production).
- [ ] At least 1 contributor-doctrine PR (e.g., next ADR-only commit) successfully passes the check without bumping (proves no false positives).

## Forward-Guardrail Sunset (per ADR-017 convention)

This ADR's T1 shipment is subject to review by **2026-11-24**.

### Reversal criteria

- New check fires **0 times** in 6 months → rule may be too conservative; reconsider scope or drop.
- New check fires but maintainer **bypasses ≥1×** without amending the ADR → too rigid; refine path lists.
- No consumer-doctrine PR has shipped at all in 6 months → rule was speculation, drop.

### Non-reversal criteria (any one)

- ≥1 `rules/effective-development.md` (or similar consumer-doctrine) audit PR shipped with bump+CHANGELOG due to this check firing or being cited.
- ≥1 consumer-doctrine PR caught and corrected by this check before merge (CI fail → contributor adds bump → PR proceeds).
- Maintainer explicitly cites ADR-019 in a PR description as the reason for bumping when they otherwise wouldn't have.

External re-evaluation (any of: new audit corpus, updated semver guidance for Claude Code plugins, an upstream marketplace mechanism that subsumes this) overrides the local sunset.

---

**Audit conversation reference**: post-PR-#228 advisor consult 2026-05-24, framed via the falsifiability pattern from `~/.claude/lessons/2026-05-24-notebooklm-corpus-completeness-falsifiability-frame.md` ("what specific finding, if true, would change the decision?"). Applied to ADR-017 §C5: "a doctrine-only PR that silently changes consumer behavior" — recognized as one PR away (ADR-018 §"Context" names `rules/effective-development.md` as next audit target). Decision: refine §C5 scope proactively rather than wait for the bug.
