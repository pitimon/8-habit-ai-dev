![Version](https://img.shields.io/badge/latest-v2.19.0-blue)

# Changelog

Release history for `8-habit-ai-dev`. This page summarizes notable changes; the authoritative sources are [`CHANGELOG.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/CHANGELOG.md) (v2.3.0+), the [GitHub releases page](https://github.com/pitimon/8-habit-ai-dev/releases), and the [git tag history](https://github.com/pitimon/8-habit-ai-dev/tags).

> Full detail for v2.3.0 and later lives in the root [`CHANGELOG.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/CHANGELOG.md). This wiki page summarizes recent versions and keeps v2.2.0 and earlier for continuity.

## v2.19.0 — Native Codex Plugin Packaging (May 2026)

Adds first-class Codex packaging while preserving the existing Claude Code package. New files: `.codex-plugin/plugin.json` points Codex at the existing `skills/` directory with interface metadata; `.agents/plugins/marketplace.json` exposes the repo as marketplace `pitimon-8-habit-ai-dev` so users can run `codex plugin marketplace add pitimon/8-habit-ai-dev` followed by `codex plugin add 8-habit-ai-dev@pitimon-8-habit-ai-dev`. The marketplace points to `./plugin`, a symlink back to the repo root, because Codex ignores root-path marketplace entries. [ADR-023](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-023-codex-native-packaging.md) records the packaging decision and boundary: same read-only markdown skills, no runtime enforcement, Claude hooks remain Claude-only. Codex ingestion compatibility sets `/ai-dev-log` and `/save-spec` `disable-model-invocation` to `false` because Codex rejects `true` and ADR-014 already marked it decorative for Claude plugin skills. `tests/validate-structure.sh` now checks Codex packaging presence, required fields, version alignment, and treats Codex packaging paths as consumer-doctrine for bump enforcement. Full detail in root [`CHANGELOG.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/CHANGELOG.md).

## v2.18.9 — Diagnose Worked-Example Polish (May 2026)

Craft follow-up to v2.18.8, closing a Heart-dimension gap a `/whole-person-check` flagged. `/diagnose` Phase 4's independent-source verification step gains a copy-pasteable worked example (`docker run <img>` vs `docker exec <ctr>`, compare-and-flag-divergence) plus a one-line generalization — _read the claim twice from sources that can't share the same mistake, and believe it only when they agree_ — so a first-time user internalizes the technique without leaving the skill. Boundary-safe per [ADR-021](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-021-dynamic-workflow-positioning.md): independence-of-source, zero agent-orchestration vocabulary. Consumer-doctrine bump per [ADR-019](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-019-doctrine-only-scope-refinement.md). Full detail in root [`CHANGELOG.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/CHANGELOG.md).

## v2.18.8 — Independent-Source Verification (May 2026)

Adds the **discipline** the first real fan-out use exposed (follow-up to [#243](https://github.com/pitimon/8-habit-ai-dev/issues/243), built on #241/ADR-021): catching a _confident-but-wrong root cause_ that survives every author-side gate because each gate reuses the same single contaminated observation. Lived case (memforge) — a version read from `docker exec` survived `advisor`, a review pass, a merged PR, and a `/reflect` lesson, until an independent probe (`docker run` on the image) contradicted it and surfaced a bind-mount overriding the image. New canonical [`guides/independent-source-verification.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/guides/independent-source-verification.md) holds the case study + rule (confirm a root cause from an _independent_ source; reconcile contradictions rather than pick) and is cited by six gap edits to `diagnose`, `cross-verify`, `post-mortem`, `reflect`, `orchestration-patterns.md`, and `advisor-pattern.md`. Boundary-safe per [ADR-021](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-021-dynamic-workflow-positioning.md) — discipline here, fan-out engine in `claude-governance`; `8-habit-reviewer` caught one boundary DRIFT (Pattern 4 re-owning the engine) and confirmed CLEAN after reword. Consumer-doctrine bump per [ADR-019](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-019-doctrine-only-scope-refinement.md). Full detail in root [`CHANGELOG.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/CHANGELOG.md).

## v2.18.7 — Dynamic Workflow Positioning (May 2026)

Positions the plugin against Opus 4.8's new **dynamic workflow** capability — a deterministic engine that spawns parallel sub-agents — which collides by name and philosophy with the plugin's human-gated `/workflow` skill. A 4-probe repo audit (issue [#241](https://github.com/pitimon/8-habit-ai-dev/issues/241)) settled the layering: the **engine** (runtime + agent-spawn authorization) belongs to `claude-governance`; the fan-out **discipline** belongs here. [`guides/orchestration-patterns.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/guides/orchestration-patterns.md) gains **Pattern 4: Fan-Out Discipline** — a when/when-not-to-fan-out gate keyed to habits (H6 Synergize reinforces; H1/H3/H5/H8 in tension) plus an Article 14 oversight checklist (preserve Understand / Override / Stop), delegating the _how_ to existing Patterns 1-3. [`docs/adr/ADR-021`](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-021-dynamic-workflow-positioning.md) disambiguates `/workflow` (discipline) from the engine and quotes the CLAUDE.md boundary rule verbatim. Forward guardrail with zero friction signal; sunset 2026-11-24. Consumer-doctrine bump per [ADR-019](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-019-doctrine-only-scope-refinement.md). Full detail in root [`CHANGELOG.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/CHANGELOG.md).

## v2.18.6 — Step 4a awk Made Frontmatter-Aware (May 2026)

Fast-follow fix to v2.18.5 (shipped ~1h earlier) closing issue [#239](https://github.com/pitimon/8-habit-ai-dev/issues/239) — a QA pass on v2.18.5 caught that the step 4a body-measure command (`awk '/^---$/{c++; next} c>=2'`) returned `0` for files without YAML frontmatter, contradicting the release's own ADR-017 ~150-line case study. [`skills/requirements/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/requirements/SKILL.md) step 4a step 2 now uses a frontmatter-aware variant (`awk 'NR==1 && $0=="---"{f=1; next} f && $0=="---"{f=0; next} !f'`) that strips frontmatter only when the file actually starts with `---`; otherwise counts the whole body. Verified: ADR-017 → 152, ADR-018 → 145, `cross-verification.md` → 95, `requirements/SKILL.md` → 131. [`tests/validate-content.sh`](https://github.com/pitimon/8-habit-ai-dev/blob/main/tests/validate-content.sh) Check 22 closes the gap #239 explicitly named (_"`tests/**` was untouched"_) — runs the prescribed awk against 4 representative files and asserts body counts match. Establishes the precedent that future `awk`/`grep`/`jq` snippets in skill prose ship with a paired assertion. Consumer-doctrine bump per [ADR-019](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-019-doctrine-only-scope-refinement.md). Full detail in root [`CHANGELOG.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/CHANGELOG.md).

## v2.18.5 — PRD Calibration Checkpoint (May 2026)

Adds a `4a. Calibrate numeric ceilings against precedent` sub-step to [`skills/requirements/SKILL.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/skills/requirements/SKILL.md) Process. When an EARS criterion sets an upper bound on lines/words/characters of a markdown artifact (ADR, guide, skill), the skill now nudges the author to identify the closest precedent (`docs/adr/ADR-0*.md`, `guides/*.md`, or `skills/*/SKILL.md` by artifact type), measure the body excluding YAML frontmatter (`awk '/^---$/{c++; next} c>=2' <file> | wc -l`), and set the ceiling at `precedent_max × 1.20` — because aspirational round numbers contaminate `/consistency-check` runs once the artifact lands at its actual required size. Opt-out preserved when no precedent exists or the cap is set by a different constraint (hook token budget, validator string limit). Closes [#237](https://github.com/pitimon/8-habit-ai-dev/issues/237) — action item from lesson `~/.claude/lessons/2026-05-24-v218-4-skill-authoring-double-rescue.md` §5 catching FR-007 (ADR-020) PRD-vs-reality drift before merge in v2.18.4. Plugin-boundary respected — no validator extension, no PreToolUse hook (runtime enforcement belongs in [`pitimon/claude-governance`](https://github.com/pitimon/claude-governance) per memory obs #233270). Consumer-doctrine bump per [ADR-019](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-019-doctrine-only-scope-refinement.md). Full detail in root [`CHANGELOG.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/CHANGELOG.md).

## v2.18.4 — Skill Authoring Guide (May 2026)

Adds [`guides/skill-authoring.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/guides/skill-authoring.md) documenting Ben AI's Pre-Building Preparation pattern + canonical SKILL.md skeleton with a dedicated `## Objective` section + authoring lifecycle (`/research` → reference docs → SKILL.md → `/reflect` → SKILL-EFFECTIVENESS feedback). Closes N1 (no discoverable authoring methodology — 23 skills but only structural template in CONTRIBUTING.md) + P2 (Objective conflated with the Check 25 trigger-rubric `description`). Triggered by 2026-05-24 audit of Vibe Coding Thailand's "คู่มือสร้าง Claude Skills ให้เก่งกว่าคนทั่วไป" article. Cross-verify reconciliation: `@8-habit-reviewer` scored the brief's first "ship nothing" draft 12/17 and identified the same selective-strictness pattern that rescued the [ADR-017](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-017-anthropic-skill-patterns-audit.md) draft four days earlier; revised verdict applies [ADR-014](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-014-external-prior-art-audit.md) "ship with zero friction as forward guardrail" precedent consistently. [ADR-020](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-020-skill-authoring-guide.md) records the Tier 1 ship + Forward-Guardrail Sunset 2026-11-24. CONTRIBUTING.md template diff inserts `## Objective` section in the skill skeleton. Consumer-doctrine bump per [ADR-019](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-019-doctrine-only-scope-refinement.md). PR closes [#235](https://github.com/pitimon/8-habit-ai-dev/issues/235). Full detail in root [`CHANGELOG.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/CHANGELOG.md).

## v2.18.3 — Anthropic Engineering Doctrine Audit Guide (May 2026)

Adds [`guides/anthropic-engineering-doctrine-audit.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/guides/anthropic-engineering-doctrine-audit.md) as a defensive citation surface for the [ADR-018](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-018-memory-layer-activation.md) "Earn each line" doctrine. Catalogues 12 already-adopted patterns from Anthropic / Karpathy / Claude Code engineering blog corpus (Table 1) and 7 evaluated patterns (Table 2). N6 (skill description routing audit) reclassified from T1 → T2 after `@8-habit-reviewer` cross-verify flagged cherry-picking — the cited 2026-04-22 lesson records `skills/RESOLVER.md` as proactive feature (issue #135), not friction patch. H8 modeling deposit: apply friction-first to ourselves the same way we apply it to incoming proposals. Complements [ADR-017](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-017-anthropic-skill-patterns-audit.md) (narrower `github.com/anthropics/skills` 5-pattern audit). Consumer-doctrine bump per [ADR-019](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-019-doctrine-only-scope-refinement.md) — `guides/**` is consumer-facing reference content. PR closes [#231](https://github.com/pitimon/8-habit-ai-dev/issues/231). Full detail in root [`CHANGELOG.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/CHANGELOG.md).

## v2.18.2 — ADR-019 Doctrine-Only Scope Refinement + Check 27 (May 2026)

Refines [ADR-017 §C5](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-017-anthropic-skill-patterns-audit.md) doctrine-only rule. [ADR-019](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-019-doctrine-only-scope-refinement.md) splits doctrine-only into **contributor-doctrine** (no bump — `docs/adr/`, `CLAUDE.md`, `CONTRIBUTING.md`, `.github/`, `tests/`, `SELF-CHECK.md`) and **consumer-doctrine** (MUST bump + CHANGELOG — `rules/`, `skills/`, `hooks/`, `habits/`, `guides/`, `agents/`). Closes the silent-shift gap that would have hit `rules/effective-development.md`'s next audit (per [ADR-018](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-018-memory-layer-activation.md) §"Context"). `tests/validate-structure.sh` Check 27 enforces the rule mechanically: detects consumer-doctrine paths changed since last release tag; fails CI if version-4-files unchanged. Bumped electively (PR was contributor-doctrine only) to signal CI behavior change to contributors. Validator state: 358 PASS / 0 FAIL. Forward-Guardrail Sunset 2026-11-24 per ADR-017 convention. Full detail in root [`CHANGELOG.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/CHANGELOG.md).

## v2.18.1 — Anthropic Skills 5-Pattern Audit: Tier 1 P3 Ship + Check 26 (May 2026)

User-prompted Deep+Audit `/research` evaluated 23 skills against [github.com/anthropics/skills](https://github.com/anthropics/skills) (`skills/{pdf,pptx,docx}`) 5 SKILL.md patterns. [ADR-017](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-017-anthropic-skill-patterns-audit.md) records Tier 1 P3 ship (Check 26 warning-only validator + `/scrutinize` Operating Rules MUST/NEVER+Why blocks + `/diagnose` Phase 6 MUST re-verify); Pattern 4 (embedded scripts) out-of-scope per plugin charter; Pattern 5 split (T2 bag drop 2026-11-23 + companion [pitimon/claude-governance#37](https://github.com/pitimon/claude-governance/issues/37) for runtime hook). 8-habit-reviewer cross-verify caught selective-strictness asymmetry vs ADR-014 precedent (4 patterns shipped with zero friction 4 days earlier) and forced reconciliation paragraph before PR. Full detail in root [`CHANGELOG.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/CHANGELOG.md).

## v2.18.0 — `/diagnose` Skill: Friction-Driven External Adoption (May 2026)

Adds `/diagnose` — 6-phase active bug investigation skill — as a **friction-driven** external prior-art adoption from [mattpocock/skills](https://github.com/mattpocock/skills) SHA `b8be62ff`. Closes the gap between `/research` (too broad) and `/post-mortem` (too late). Phase 1 (build feedback loop) is enforced before hypothesis generation. Hands off to `/post-mortem` once the fix lands. Honest framing in [ADR-015](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-015-diagnose-skill-adoption-and-n1-framing.md): n=1 friction signal (lesson `2026-04-12-compression-worker-420-investigation.md` first-person absent-skill admission), below ADR-014's n≥2 preferred bar but unusually strong. Sets precedent for friction-first external prior-art adoption. Plugin total: 23 skills. Full detail in root [`CHANGELOG.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/CHANGELOG.md).

## v2.17.0 — External Prior-Art Audit: mattpocock/skills Patterns (May 2026)

Adopts 4 patterns from [mattpocock/skills](https://github.com/mattpocock/skills) as forward guardrails: P1 AGENT-BRIEF template, P3 `disable-model-invocation` frontmatter, P4-lite `docs/out-of-scope/` catalog, P5 description rubric (validator Checks 24+25). Honest framing in [ADR-014](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-014-external-prior-art-audit.md): all 4 ship without prior friction-signal evidence — future audits must apply friction-first lens. Full detail in root [`CHANGELOG.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/CHANGELOG.md).

## v2.16.5 — Companion Announcement: devsecops `/workflow` → `/security-workflow` (May 2026)

Docs-only patch closing the paired-announcement promise from `devsecops-ai-team` v10.12.0's CHANGELOG. The cross-plugin `/workflow` naming collision has been resolved by devsecops renaming its skill to `/security-workflow`; this plugin's `/workflow` (the 7-step Covey practice) keeps the generic name. `docs/INTEGRATION.md` peg bumped 10.10.0 → 10.12.0+; `skills/workflow/SKILL.md` gains "See Also" footer pointing scan-orchestration seekers to devsecops; README companion-plugins section refreshed. Pattern captured: companion-announcement step is now part of DoD for any cross-plugin slash-command rename.

## v2.16.4 — `/save-spec` Suite-Positioning Honesty Patch (Adopter #2 third-repo dogfood) (May 2026)

Docs-only patch. Adopter #2's third-repo dogfood (operational VA/PT workspace with `claude-mem` active + 284-line `CLAUDE.md`) surfaced two real overlap cases the `/save-spec` docs didn't acknowledge. P1 + P2 ship; P3 explicitly deferred per adopter recommendation. Closes [#207](https://github.com/pitimon/8-habit-ai-dev/issues/207).

**P1 (docs only) — SKILL.md "When to Skip" + memory-MCP-overlap entry**: Memory-MCP active (`claude-mem`/`memforge`) + short `CLAUDE.md` (<150 lines / scannable in <30s) already solves the post-`/clear` save-point problem the skill was designed for. In that combination, §4 is the only net-value section; writing a short `## Current state` into `CLAUDE.md` is the lower-friction path.

**P2 (docs only) — Suite positioning across 3 files**: SKILL.md gains "Suite positioning (not a workflow step)" section framing the skill as a deployment-mode helper orthogonal to the 7-step workflow, alongside `/calibrate` + `/reflect` as state-write skills (NOT alongside assessment skills). README skill-table row + using-8-habits/reference.md row both reclassified.

**P3 (feature — explicitly deferred)**: `--skip-empty-sections` flag deferred per adopter recommendation pending demand signal.

Pattern: **H8 Conscience applied to marketing copy** — the skill's own H8 Checkpoint admitted "the value depends on the user's habit of updating it"; this release extends that honesty to "When to Skip". Arc-close criterion (v2.16.3: "round 6 deferred unless 3rd adopter surfaces friction") validated — condition triggered within ~2 hours of v2.16.3 release. Pattern continues at n=3 evidence base. Adopter's /cross-verify: 13/15 = 86.7%. Maintainer's /cross-verify on implementation posture: 15/15 = 100%. Validator state: validate-structure.sh 268/268 PASS, validate-content.sh 220+ PASS / 0 FAIL / 1 WARN / 0 fitness breaches.

## v2.16.3 — `/save-spec` Round-5 Arc-Close Polish (Adopter #2 closure pass) (May 2026)

Patch release. Adopter #2 closure pass on the 5-round v2.16.x QA arc surfaced 1 MEDIUM bug + 2 LOW items + an arc-close meta. All 3 fixed; arc closed per Adopter #2 recommendation. Closes [#205](https://github.com/pitimon/8-habit-ai-dev/issues/205).

**R5-3 (MEDIUM bug, fixed)**: Scaffolded SPEC.md §2 markdown table rendered broken on every empty-decisions scaffold because reference.md:30 blank line separated alignment row from `<§2-rows>` substitution. Initial fix (delete blank + add HTML-comment assembly directive) failed because the formatter persistently re-wedged blanks around HTML-blocks AND `<...>` markers. Final fix uses table-row-shaped substitution marker (`| §2-rows-ASSEMBLY-DIRECTIVE | ... |`) so the formatter sees it as a real data row. New validate-content.sh Check 12c.1 regression check added with formatter-padding-tolerant regex.

**R5-1 (LOW-MEDIUM doc, fixed)**: Template assembly markers visually identical to F1-class pre-fix placeholders — risked future-contributor confusion. Fixed by consolidating the assembly-directive intent INTO the marker text with explicit `ASSEMBLY-DIRECTIVE` phrase + "NEVER appears in output" language.

**R5-2 (LOW doc, fixed)**: FR-017 error template used write-failure register for pre-flight path-validation. Added new canonical pre-flight error template ("Directory not found: <target-dir>...") with correct register. FR-017 wired to new template; SKILL.md Process step 1 updated.

Pattern: **formatter-vs-substitution-marker arms race resolved via table-row-shaped marker** — when a marker must be adjacent to a formatter-stable construct, make the marker itself look like that construct. DoD-must-execute self-test caught zero bugs this round (previous round caught F3 BSD-awk regression); convergence is the expected pattern when discipline holds. Validator state: validate-structure.sh 268/268 PASS, validate-content.sh 220+ PASS / 0 FAIL / 1 WARN / 0 fitness breaches. **5-round arc closed** per Adopter #2 recommendation; round 6 deferred unless a third independent adopter surfaces friction.

## v2.16.2 — `/save-spec` Round-3 Polish + Guide Check 2 BSD-awk Fix (Adopter #3 dogfood) (May 2026)

Patch release. Adopter #3 dogfood pass on `/save-spec` (first round from real skill execution rather than docs review) surfaced 1 correctness bug + 1 friction enhancement; pre-PR self-test surfaced 1 additional verification-command bug. All 3 fixed in this PR. Closes [#203](https://github.com/pitimon/8-habit-ai-dev/issues/203).

**F1 (MEDIUM bug, fixed)**: Scaffolded SPEC.md shipped with 6 literal angle-bracket placeholder sites contradicting the read-first-context purpose. Fixed via hybrid approach — §2/§3 skip-stub rows use plain prose italic markers (`_no decisions seeded yet — add the first one when it lands_`); §1 narrative + §4 fill-required sites use `<!-- TODO: … -->` HTML comments (invisible at render, visible to editor). `tests/validate-content.sh` Check 12c whitelist extended to `skills/save-spec/`.

**F2 (LOW-MEDIUM enhancement)**: `/save-spec [project-name] [target-dir]` now accepts an optional second positional argument. Multi-repo portfolio adopters no longer need a per-repo session switch. PRD FR-013 scope-clarified; new FR-017 added.

**F3 (MEDIUM bonus, surfaced by pre-PR self-test)**: `guides/spec-digest-pattern.md` Check 2's `awk '/^## 4\. Current state/,/^## /'` collapses to 1 line on BSD awk (macOS default) because the end-regex `^## ` matches the start line. All macOS adopters running the published verification command had a silently-failing Check 2. Replaced with `sed -n '/^## 4\. Current state/,/^## /p'` (consistent cross-platform). Regression introduced in v2.15.9 (#197 N1 fix migrated from `grep -A1` → `awk`).

**W2 (doc softening)**: N2 timestamp warning reframed — Adopter #3 fresh-session scaffold produced correct Bangkok offset; the `+00:00` fallback is the "documented escape-hatch, not expected outcome in normal use."

**Positive verifications from Adopter #3**: W1 N3 free-text affordance works end-to-end, W2 N2 timestamp correct in real use, W3 refusal-path safety guard works.

Validator state: validate-structure.sh 268/268 PASS, validate-content.sh 219+ PASS / 0 FAIL / 1 WARN / 0 fitness breaches. Pattern: **DoD-must-execute principle empirically validated within 24h of being coined** — the same-day /reflect action item caught F3 (a BSD-awk regression no static review would have surfaced). Lesson loop closed in a single day.

## v2.16.1 — `/save-spec` Phase 1 Polish (Adopter #2 dogfood) (May 2026)

Patch release. Adopter #2 dogfood pass on the v2.16.0 `/save-spec` skill surfaced 1 correctness bug + 3 quality items — all four fixed in this single PR. Closes [#201](https://github.com/pitimon/8-habit-ai-dev/issues/201).

**N1 (MEDIUM bug, fixed)**: §1 empty stub previously used `` `<filename>.md` `` which Check 4's backtick-path grep extracted as `<filename>.md` (literal angle brackets), failing `[ -e ]` and emitting `MISS  <filename>.md`. The Definition of Done's claim that "output passes the 5 verification commands" was provably false on the default scaffold. Fixed by changing the stub to plain prose `_§1 is empty — add project-specific pointers as the repo grows._` with no backticked .md path.

**N2 (LOW, documented)**: Timestamp reliability profile documented in reference.md. The skill (no `Bash` in `allowed-tools`) generates the `**Last updated**` value by substituting Claude's session-injected current-time context; when that injection is absent the output may carry `+00:00` or a wrong offset. Adopter guidance added: verify offset after scaffold, edit manually if wrong. Phase 2 may add `Bash` if feedback shows unreliability.

**N3 (LOW UX, fixed)**: Q2 (§1 pointer confirmation) now accepts an "Other (free-text)" affordance for newline-separated project-specific paths. Motivated by ops/infra repos using non-canonical naming (`server-state.md`, `playbooks/change-management.md`, `runbooks/ops-runbook.md`) that have zero overlap with the 5 canonical glob names. SKILL.md Process step 3 + step 4 parse rule extended; reference.md Example F added to show the parse flow.

**N4 (LOW doc drift, fixed)**: PRD FR-003 deduplicated against `reference.md` Decision-3. FR-003 previously included a paraphrased inline version of the refusal message that diverged from the canonical version in reference.md — future-maintainer drift hazard. FR-003 now references reference.md as the single source of truth.

Validator state: `validate-structure.sh` 268/268 PASS, `validate-content.sh` 219+ PASS / 0 FAIL / 1 WARN / 0 fitness breaches. Sibling closure: [#197](https://github.com/pitimon/8-habit-ai-dev/issues/197) is now closeable — all 5 of its items were addressed in v2.16.0 + #198. Pattern: **patch-release dogfood discipline** — the adopter #2 report surfaced N1 in <2 hours after the v2.16.0 release; correctness fix shipped same day; the dogfood feedback loop is faster than the original promotion-criteria gathering.

## v2.16.0 — `/save-spec` Skill — Phase 1 Minimum Viable (May 2026)

Minor version bump (new skill). Promotes the v2.15.9 spec-digest-pattern guide to a user-invocable skill after all three documented promotion criteria were objectively met. Closes [#199](https://github.com/pitimon/8-habit-ai-dev/issues/199).

New `skills/save-spec/SKILL.md` (~180 lines) — Phase 1 minimum viable user-invoked skill that scaffolds a project-root `SPEC.md` digest. Frontmatter: `allowed-tools: [Read, Write, Glob, AskUserQuestion]`, `prev-skill: any`, `next-skill: any` (standalone). Generator-only — refuses to overwrite an existing `SPEC.md` (Phase 2 `--update` deferred). 8-step Process section is the runtime contract pinned by new validator Check 23 (Decision-7 sticky). Hybrid auto-detect globs 5 canonical pointer-target files (`PLAYBOOK.md`, `CONTRACTS.md`, `LESSONS.md`, `CHANGELOG.md`, `README.md`, case-sensitive) and asks the user to confirm §1 inclusion. 4-prompt interactive flow (project name + §1 multi-select + §2 comma-separated free-text + §3 comma-separated free-text) with skip-sentinels (`skip`, `none`, `nothing`, `n/a`, empty). §4 timestamp uses RFC 3339 strict with local timezone offset. Emits CLAUDE.md auto-update recipe stanza to conversation only — does NOT modify your `CLAUDE.md` (FR-014, FR-015 design invariants).

Companion artifacts: `skills/save-spec/reference.md` (~200 lines) with the verbatim refusal message + 3-line error template + skip-sentinels list + glob set + 5 parse examples + rationale links to issue #199 open-question defaults. New `tests/validate-structure.sh` Check 23 with 8 assertions pinning frontmatter array + 8-step Process count + canonical-phrase presence in reference.md. `skills/RESOLVER.md` gets 3 trigger phrases (`"scaffold a SPEC.md"`, `"save-point file for this repo"`, `"set up a project digest"`). `guides/spec-digest-pattern.md` "Promotion to a skill (deferred)" section rewritten to "Promoted to `/save-spec` in v2.16.0" with the explicit scope-resolution statement (the two deployment modes are disjoint in practice; multi-mode repos out of scope for tooling). `docs/adr/ADR-013-spec-persistence-opt-in.md` receives a 2026-05-17 follow-up note inside the existing addendum (user-invoked write stays outside Alt-4 auto-write-hook rejection — no new ADR required).

Dogfood: the PRD/design/tasks for this skill itself were persisted via `--persist save-spec` (the feature-spec convention — cross-mode dogfooding the project-orientation tooling). `/consistency-check save-spec` ran clean (0 CRITICAL, 0 HIGH, 0 MEDIUM, 4 LOW — accepted as informational per Significance profile avoid-documentation-gold-plating stance).

Promotion criteria status (all three met, the deferred-skill criterion-driven ship pattern):

1. **n=2 independent adoption** — `netbox-sit` (the canonical empirical artifact in v2.15.9) + `claude-all/netbird-sit` (Adopter #2 report via [#197](https://github.com/pitimon/8-habit-ai-dev/issues/197))
2. **Scope question resolved in writing** — the two-modes-are-disjoint paragraph in `guides/spec-digest-pattern.md`
3. **Friction lesson captured** — `~/.claude/lessons/2026-05-17-spec-digest-pattern-v2-15-9.md` + #197 adopter friction items 2.1–2.3 + 4

Validator state: validate-structure.sh 266/266 PASS, validate-content.sh 217+ PASS / 0 FAIL / 1 WARN / 0 fitness breaches. Pattern: **promotion via maturity ladder, not aesthetic preference** — the v2.15.9 deferral made the next escalation step falsifiable; v2.16.0 ships only because the criteria were objectively met, with documented evidence per criterion.

## v2.15.9 — Project-Orientation Hub Mode Documentation (May 2026)

Docs-only patch. Closes [#194](https://github.com/pitimon/8-habit-ai-dev/issues/194) via [PR #195](https://github.com/pitimon/8-habit-ai-dev/pull/195).

Documents a second spec-persistence deployment mode (**project-orientation hub**) as complement to v2.15.2's feature-spec mode. No new skill, no hook, no enforcement — pattern documentation only.

New `guides/spec-digest-pattern.md` (~180 lines) documents the project-root `SPEC.md` digest archetype: §1 Architecture (pointer), §2 Decisions snapshot (compact ADR digest table), §3 Live backlog, §4 Current state save point ("Read this section first after `/clear` or `/compact`"). Template paraphrased from a production artifact (`scanopy/netbox-sit/SPEC.md`, 153 lines) that independently arrived at this four-section shape after repeated `/clear`/`/compact` flushing pain. ADR-013 receives an additive 2026-05-17 addendum clarifying its rejections (Alt-1 unified prd+design+tasks merge, Alt-4 always-on auto-write hook, CHANGELOG v2.15.0 `/save-point` skill rejection) cover the **feature-spec mode** specifically; the digest-layer-above-detail-files archetype is a different deployment mode those alternatives did not evaluate. `/save-spec <slug>` skill explicitly deferred pending ≥2 independent project adoption signal per working-with-pitimon "minimal additions, user-demand-driven" stance + PR #111 local-maximum lesson. Cross-links from `guides/persistence-convention.md` (the two modes are complementary) + `README.md` Use Cases row "Survive `/clear` and `/compact`". 8-habit-reviewer pre-commit dispatch caught nested-fence rendering issue (outer ` ```markdown ` collapsed `\`\`\`bash`to literal text); fixed to 4-backtick outer fence. Post-merge CI surfaced`validate-content.sh` Check 12b false-positive: link resolver flagged 8 template-internal placeholder links inside the code block as broken because the regex is not backtick-aware — template rewritten to use backticked filenames (`` `PLAYBOOK.md` ``, `` `CONTRACTS.md` ``, etc) instead of bracket-paren link syntax with a note for the copy-paster. Same fix applied to Decisions table example row. Validator state: validate-structure.sh 256/256 PASS, validate-content.sh 216 PASS / 0 FAIL / 1 WARN / 0 fitness breaches. Pattern: **empirical-evidence-driven discipline addition** — real-world artifact from another session revealed a deployment mode the plugin did not document; plan was revised twice (after reviewer + advisor) to match commitment level to evidence strength; deferred skill criterion makes the next escalation decision data-driven rather than aesthetic.

## v2.15.8 — `/reflect` Auto-Consolidation: One-Command Flow (May 2026)

UX patch. Step 7 of `/reflect` now runs the 4-phase consolidation cycle automatically when `count > 10` — no separate `/reflect consolidate` invocation needed. Closes [#191](https://github.com/pitimon/8-habit-ai-dev/issues/191) via [PR #192](https://github.com/pitimon/8-habit-ai-dev/pull/192).

No merges found → `~/.claude/lessons/INDEX.md` updated automatically + 1-line summary. Deletions proposed → cycle stops for explicit user approval (In-the-Loop per ADR-002 preserved). Explicit `/reflect consolidate` argument retained for verbose output. DoD bullet updated to testable outcome. Pattern: **PC² — H7 applied to H7 itself**. Root cause was threshold 10 that mature repos cross quickly — auto-run is safe for the common case (additive INDEX update), gate preserved for the rare case (irreversible deletions). Validator state: validate-structure.sh 256/256 PASS, validate-content.sh 217 PASS / 0 FAIL / 1 WARN / 0 fitness breaches.

## v2.15.7 — Vendor Portability Discipline for Managed Agent Platforms (May 2026)

Patch release. Doc-only addition responding to the industry move toward managed-agent runtime features (cross-session memory, self-evaluation against outcomes, built-in orchestration) from Claude Managed Agents, OpenAI Assistants, Bedrock Agents. Closes [#188](https://github.com/pitimon/8-habit-ai-dev/issues/188) via [PR #189](https://github.com/pitimon/8-habit-ai-dev/pull/189).

New `guides/vendor-portability.md` (~90 lines) structured around three principles: persist artifacts outside the vendor (repo = source of truth), treat managed memory as cache not source of truth, separate discipline (portable) from runtime (vendor-specific). Selection checklist framed as the `/cross-verify` Q14 "third alternative beyond the obvious options" exercise — managed vs. self-hosted is rarely binary, and hybrid with explicit persistence discipline is often the better answer. Habit mapping: H8 (Voice, architectural autonomy / Spirit) primary anchor, H1 (Proactive, prevent lock-in / Body), H4 (Win-Win, Emotional Bank Account / Heart — canonical framing per `habits/h4-win-win.md`), H7 (Sharpen the Saw, reproducibility = PC over P / Mind) — full Whole Person 4-dimension coverage. `llms.txt` indexed under Philosophy section. Plugin boundary preserved — workflow discipline lives here; enforcement hooks and compliance framework mapping live in `pitimon/claude-governance`. 8-habit-reviewer pre-commit dispatch caught a Commandment #13 violation: initial draft mislabeled Q14 as "External dependencies" but actual text per `guides/cross-verification.md:45` is "third alternative beyond the obvious options" — corrected before merge, demonstrating the integrity discipline applies to its own writing. Pattern: **discipline answer to a runtime trend** — framework responds to vendor convergence not by replicating features but by naming the portability discipline that keeps users vendor-neutral. Validator state: `validate-structure.sh` 256/256 PASS, `validate-content.sh` 217 PASS / 0 FAIL / 1 WARN / 0 fitness breaches.

## v2.15.6 — SKILL_OUTPUT Producer + Consumer Doc Sync (May 2026)

Patch release. Doc-only fix closing a pair of same-shape drift gaps in `guides/structured-output-protocol.md`. Both stemmed from `/design`'s `SKILL_OUTPUT:design` block being added without doc sync. Closes [#153](https://github.com/pitimon/8-habit-ai-dev/issues/153) via [PR #186](https://github.com/pitimon/8-habit-ai-dev/pull/186).

Producer entry: `/design` → `SKILL_OUTPUT:design` inserted between `/requirements` and `/breakdown` (workflow Step 2 placement). Schema matches `skills/design/SKILL.md:128-142` exactly with all 7 keys; concrete example values match existing producer style. Consumer entries: Q14 (`decision_count` → third-alternative flag) + Q16 (`sticky_decisions` → WHY-not-captured flag); Q4 extended with design-block cross-check. All 5 SKILL_OUTPUT-consuming questions from `skills/cross-verify/SKILL.md:35-41` now mirrored in the guide. Pattern: **producer + consumer doc-sync-as-a-pair** — strict-scope producer-only fix would have created the "confusion point" the issue cites (H4 + H1). Minimal scope expansion closes both halves in one PR. Originally surfaced by `8-habit-reviewer` cross-verification of PR #152 (#151 attribution implementation). Validator state: `validate-structure.sh` 256/256 PASS, `validate-content.sh` 217 PASS / 0 FAIL / 0 fitness breaches.

## v2.15.5 — Repo-Wide Link-Check CI Gate + Real Link-Rot Fixes (May 2026)

Patch release. Adds `.github/workflows/link-check.yml` — repo-wide markdown link validation using lychee. Triggers on PR + push to main when any `**/*.md` changes. Closes [#172](https://github.com/pitimon/8-habit-ai-dev/issues/172) via [PR #184](https://github.com/pitimon/8-habit-ai-dev/pull/184).

Scope: external HTTP/HTTPS URLs across all `*.md` outside `docs/wiki/` (wiki covered by separate workflow). Excludes self-referential `pitimon/8-habit-ai-dev/(blob|tree|raw)/main/` URLs (only resolve post-merge) and private cross-repo refs to `pitimon/memforge` + `pitimon/devsecops-ai-team` (workflow `GITHUB_TOKEN` is scoped to this repo only; cannot authenticate against other private repos). `claude-governance` is public and stays in scope. Internal markdown links remain validated by `tests/validate-content.sh` Check 12b — two-layer design (CI for external, shell for internal) covers full surface without duplication.

First CI run on PR #184 caught 3 real link-rot issues: README.md typo `claud-mem-me` → `memforge` (repo doesn't exist under typo'd name), ADR-005:137 dead EU AI Act Service Desk URL (EC restructured path; ADR-005 is Superseded per ADR-012, preserved as historical reference text with note), and `pitimon/devsecops-ai-team/issues/467` 404 due to private-repo CI token scope (added to exclude pattern with rationale). CONTRIBUTING.md gains "Link check (external URLs)" subsection under Testing Conventions documenting both workflows + the two-layer design. Pattern: **CI gate that immediately proves its own value** — link rot was already happening silently; the gate catches it at PR time vs when users report broken navigation. The 8-habit-reviewer recommendation from the 3-plugin integration audit is now enforced. Validator state: `validate-structure.sh` 256/256 PASS, `validate-content.sh` 217 PASS / 0 FAIL / 0 fitness breaches; link-check CI run after fixes: PASS.

## v2.15.4 — Backtick-Aware Ambiguity Pass + Dogfood ID Cleanup (May 2026)

Patch release. First true bug-fix in the v2.15.x line — addresses the CRITICAL false-positive surfaced by v2.15.0's dogfood smoke test 9 days prior. Closes [#167](https://github.com/pitimon/8-habit-ai-dev/issues/167) via [PR #182](https://github.com/pitimon/8-habit-ai-dev/pull/182).

`/consistency-check` Pass 3 (Ambiguity) gains a "Backtick-context filter (required)" subsection — pre-strip backtick-quoted segments from each line before applying the `[NEEDS CLARIFICATION]` / `TBD` / `TODO` / `???` / `XXX` token match. Covers single-backtick inline spans and triple-backtick fenced blocks. Eliminates the `docs/specs/consistency-check/prd.md:45` false-positive where the PRD legitimately mentions the token inside backticks as detection-target documentation. Option A from #167 (backtick-context filter) chosen over Option B (skip-marker comment): fewer escape hatches, principled, generalizes. Aligns analyzer runtime semantics with the validator-side whitelist that already exists for `skills/consistency-check/` content (`tests/validate-content.sh` Check 12c) — the two-tier design (validator whitelist for skill prose + analyzer backtick-filter for spec artifacts) is now internally consistent. Reference.md known-limitation note removed (the limitation was the bug). F2 residual cleaned: `tasks.md:48` `Decision-D5`/`Decision-D9` → canonical `Decision-5`/`Decision-9` per ADR-013, completing PR #169's earlier canonicalization. Validator Check 21 added asserting 3 contract signals — prevents future drift back to plain `grep -nE` semantics. Validator state: `validate-structure.sh` 256/256 PASS, `validate-content.sh` 217 PASS / 0 FAIL / 0 fitness breaches. Pattern: bug fix of a feature shipped 9 days ago — distinct from v2.15.1/2/3 (content additions and convention imports).

## v2.15.3 — Integrity Commandment #13: Grep-Verify Quotes Before Pasting (May 2026)

Patch release. Content-only addition to `guides/integrity-principles.md` closing a verification-discipline gap surfaced during the v2.15.2 reflection. Two consecutive PR reviews (#174, #177) showed habit-attribution drift from gestalt pattern-matching, and a quote misattribution (`"Magic" behavior` at ADR-013 Alt-2 line 87 wrongly cited to Alt-4) propagated through 4 artifacts before reviewer catch. Closes [#179](https://github.com/pitimon/8-habit-ai-dev/issues/179) via [PR #180](https://github.com/pitimon/8-habit-ai-dev/pull/180).

New commandment **#13**: _"Never paste a verbatim quote without grep-verifying its source."_ Scope: ADR citations, habit principle claims (H1-H8 attributions), scare-quoted external phrases, observation IDs, prior-conversation paraphrases presented as direct quotes. Title updated 12→13; mapping table row extended `5-7, 13 (Honesty)` → H8 Find Voice / Spirit (conscience); 3 live cross-references synced (README architecture-tree comment, `/review-ai` load directive). Historical entries (v1.9.0 release line, v2.0.0 CHANGELOG delta, SELF-CHECK v1.9.0 improvements section) intentionally preserved as period record — editing them would itself violate commandment #4 (evidence) and #5 (paths). Dogfooding moment: drafting #13 caught its own meta-violation pre-commit — initial `"magic behavior"` (lowercase) self-corrected to `"Magic" behavior` (capitalized) to match ADR-013:87 exactly. Pattern: **commandment growth driven by reflection-detected internal drift across ≥2 sessions** — distinct from v2.15.1 upstream-import and v2.15.2 community-article convention-import. Validator state: `validate-structure.sh` 256/256 PASS.

## v2.15.2 — Current State Save-Point Convention (May 2026)

Patch release. Convention-only addition to `guides/persistence-convention.md` importing a community-article save-point pattern (Thai-language article _"ผมไม่เคยกลัว /clear กับ /compact"_) as a user-owned 4th file. Closes [#176](https://github.com/pitimon/8-habit-ai-dev/issues/176) via [PR #177](https://github.com/pitimon/8-habit-ai-dev/pull/177).

Three new sections in `guides/persistence-convention.md`: **`## Current State File (Optional, User-Owned)`** (recommends `docs/specs/<slug>/current-state.md` with template doing-now / stuck-at / next / last-updated; user-owned, no plugin skill writes; frontmatter-exempt; `/consistency-check` explicitly excluded), **`## Auto-Update Recipe (User-Side, Optional)`** (CLAUDE.md rule template the user adopts — plugin does NOT enforce per ADR-013 Alt-4: no-build philosophy + unintended file artifacts), and **`## Attribution`** (credits the article + #176).

Solves the resume-after-context-loss problem (`/clear`, `/compact`, session crash) at **task level** — complements `hooks/session-start.sh:83-115`'s step-level artifact-detection nudges (Issue #119, v2.7.0). Habit mapping: H5 + H3 for Current State File; H1 for Auto-Update Recipe. Honors PR #111's local-maximum lesson: no new skill, no new agent, no validator change, no DAG change. Validator state: `validate-structure.sh` 256/256 PASS, `validate-content.sh` 0 fitness breaches. `@8-habit-reviewer` pre-merge: 17/17 PASS + 2 polish items both addressed in-PR. Pattern: **community-article convention-only import** — distinct shape from v2.15.1's upstream-skill extract; the article has no canonical PR/commit to cite, attribution is paraphrased title + issue link.

## v2.15.1 — Doubt-Driven Techniques Imported (May 2026)

Patch release. Single-guide enhancement to `guides/advisor-pattern.md` importing three techniques from [`addyosmani/agent-skills` — `doubt-driven-development`](https://github.com/addyosmani/agent-skills/blob/main/skills/doubt-driven-development/SKILL.md) (MIT, [PR #139](https://github.com/addyosmani/agent-skills/pull/139), upstream 2026-05-07 — **27 days after** our prior addyosmani audit in PR #111). Closes [#173](https://github.com/pitimon/8-habit-ai-dev/issues/173) via [PR #174](https://github.com/pitimon/8-habit-ai-dev/pull/174).

The new `## Disprove-Mode Disciplines` section adds three labeled subsections: **Anti-CLAIM-bias rule (H5)** (pass `ARTIFACT + CONTRACT` only; hold the CLAIM back so the reviewer independently re-derives it), **Iterative review 3-cycle cap (H3 + H7, conditional)** (bounded loop with user escalation; single-shot pattern unchanged), and **Adversarial prompt template (H1 + H5)** (disprove-only output dispatched to a fresh subagent with no named role and read-only tools — not `@8-habit-reviewer`, whose 17-question process is fixed).

Honors PR #111's local-maximum lesson: no new skill, agent, or validator. Quick Reference table gains a second row for the adversarial pattern; See Also cites the MIT upstream. Rejected in-scope candidates explicit in #173 body: new `/doubt-check` skill, `source-driven-development` import, cross-model CLI escalation, agentskills.io frontmatter migration (ADR-007 NO-GO holds). Validator state: `validate-structure.sh` 256/256 PASS, `validate-content.sh` 214/214 PASS pre-release-meta. Pattern: **post-audit delta** — evaluate upstream methodology innovations in isolation when they publish after a periodic audit.

## v2.15.0 — Cross-Artifact Consistency Analyzer + Opt-In Spec Persistence (May 2026)

Minor release adding `/consistency-check` (the 18th skill) and an opt-in `--persist <slug>` argument to `/requirements`, `/design`, `/breakdown`. Inspired by github/spec-kit `/analyze`, adapted to our discipline-not-enforcement philosophy ([#165](https://github.com/pitimon/8-habit-ai-dev/issues/165)).

The new `/consistency-check` skill reads persisted `docs/specs/<slug>/{prd,design,tasks}.md` files and runs 5 detection passes — Coverage, Drift, Ambiguity, Underspec, Inconsistency — emitting severity-graded findings (CRITICAL/HIGH/MEDIUM/LOW) with file:line citations. Hybrid evaluation: deterministic when artifacts include `FR-NNN`/`Decision-N`/`Task #N` ID markers (recommended), LLM semantic with explicit warning when absent. Read-only by design — emits findings, never blocks. Boundary preserved: enforcement on persisted artifacts still belongs in `pitimon/claude-governance`.

The persistence half is fully backward compatible: without `--persist`, all three modified skills behave byte-identically to v2.14.3. With `--persist <slug>`, they additionally write outputs to `docs/specs/<slug>/{prd,design,tasks}.md` with YAML frontmatter, while preserving conversation `SKILL_OUTPUT` blocks (`/cross-verify` auto-detect unaffected). Conflict policy: AskUserQuestion prompt → fallback to numbered variant in non-interactive contexts. Slug validation regex `^[a-z0-9][a-z0-9-]{1,63}$` prevents path traversal.

Self-applied dogfood: this release's own `prd.md`, `design.md`, `tasks.md`, and ADR-013 live in `docs/specs/consistency-check/`. Run `/consistency-check consistency-check` against the dogfood as smoke test (manual procedure documented in CONTRIBUTING.md). Skills count: 17 → 18. See [ADR-013](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-013-spec-persistence-opt-in.md) for design rationale, 5 alternatives considered, flag-style argument convention attestation, and hybrid pass evaluation strategy.

## v2.14.3 — Post-Migration Cleanup + Validator Self-Discipline (May 2026)

Patch release closing [#163](https://github.com/pitimon/8-habit-ai-dev/issues/163) — three small cleanups left in v2.14.2's wake plus applying the validator's own 800-line rule to itself.

- **ADR-012 metadata closure** — `SELF-CHECK.md` reframed two lines describing the deleted EU AI Act research + mapping files as if they still existed; `docs/adr/ADR-012-eu-ai-act-migration-completion.md` status header upgraded with `**Implementation**:` field naming commit `ed65b97` (v2.14.2 release) and the metadata-closure date
- **`.gitignore`** — created with `/deep-project/` and `/.claude/` entries to gate against accidental `git add .` of cross-plugin checkouts and Claude Code session artifacts
- **`tests/validate-content.sh` trim** — 831 → 793 lines via comment consolidation across Check 15 (EU AI Act stub explainer), Check 19 sub-check rationales, F2 + F3 explainers; logic untouched, 10 checks preserved, PASS count = 205

Pattern: validator self-discipline — when a fitness function applies to the rest of the codebase, it applies to the validator too.

## v2.14.2 — EU AI Act Migration Completion (May 2026)

Plugin-boundary correction. The EU AI Act compliance toolkit (skill + reference + research + mapping guide) migrated to [`pitimon/claude-governance`](https://github.com/pitimon/claude-governance) v3.1.0 on 2026-05-02 per memory observation #233270 (2026-04-07): `8-habit-ai-dev` = workflow discipline; `claude-governance` = compliance enforcement + framework mappings. EU AI Act compliance is a framework mapping, not a workflow step. Original placement here was a boundary error.

- **Removed**: `skills/eu-ai-act-check/reference.md`, `docs/research/eu-ai-act-obligations.md`, `guides/eu-ai-act-mapping.md` (now canonical in `claude-governance` v3.1.0)
- **Stub**: `skills/eu-ai-act-check/SKILL.md` rewritten as a redirect to the canonical location with install + invocation examples; preserves NOT LEGAL ADVICE disclaimer; skill name remains valid in the catalog so existing cross-references resolve
- **ADR**: ADR-005 marked Superseded by ADR-012 (this migration completion)
- **Validator**: Check 15 in `tests/validate-content.sh` rewritten to assert post-migration state (stub correctness + deleted-file negative assertions + ADR-012 presence + ADR-005 Superseded marker)
- **Cross-refs**: reframed in RESOLVER, using-8-habits, design Step 5, ai-dev-log, session-start hook, README skill table

Wiki Architecture/FAQ/Home/Installation/Skills-Reference/Workflow-Overview pages and the README "EU AI Act ready" badge are deferred to a follow-up doc-only PR (precedent: `pitimon/claude-governance` PR #25 + #26 — local Markdown formatter rewrites tables on every Edit, producing 140+ lines of unrelated noise).

Coordination: this is the second half of the migration. The first half shipped in [`pitimon/claude-governance` v3.1.0 PR #26](https://github.com/pitimon/claude-governance/pull/26).

## v2.14.1 — README "What's New" Drift Guard (May 2026)

Patch release closing [#157](https://github.com/pitimon/8-habit-ai-dev/issues/157) — external QA found `validate-content.sh` Check 19A was passing on the README badge URL `releases/tag/v2.14.0` instead of asserting the section header `## What's New in v2.14.0`. Same bug class as [#124](https://github.com/pitimon/8-habit-ai-dev/issues/124) (CHANGELOG pointer-fallback) and [#141](https://github.com/pitimon/8-habit-ai-dev/issues/141) (SELF-CHECK.md body drift) — capability-level recurrence on a sibling surface.

- **README.md backfill** — restored missing `## What's New in v2.14.0` block, fixed broken TOC anchor (`#whats-new-in-v220` → `#whats-new-in-v2141`, broken since v2.3.0), backfilled 4 missing skills in the architecture file tree (calibrate, using-8-habits, eu-ai-act-check, ai-dev-log) so the tree matches the declared 17-skill count.
- **`tests/validate-content.sh` Check 19 sub-check G** — anchored grep `^## What's New in v${current_version}` in README.md. Closes the badge-URL false-positive class permanently. Mirrors the sub-checks E + F mechanism from PR #144.
- **Check 20 hardening** — pin literal `Find → Fix → Re-Verify` loop name + assert exactly 5 numbered steps in `skills/review-ai/SKILL.md` Verification Phase. Closes the v2.14.0 self-disclosed follow-up (passes-on-3-string-matches risk).

Pattern: same shape as v2.11.1 and v2.13.1 — QA surfaces drift class on a sibling surface → fix is fitness function, not checklist. Check 19 now covers README + CHANGELOG + wiki + SELF-CHECK + README-section-header — five anchored assertions, all co-located.

Fitness receipts: `validate-structure.sh` 246/0, `validate-content.sh` **206/0/1 WARN** (was 203; +3 new assertions), `test-skill-graph.sh` 57/0, `test-verbosity-hook.sh` 19/0.

External QA report by [@itarunp-apple](https://github.com/itarunp-apple) — ran the plugin's own `8-habit-reviewer` agent against v2.14.0 install per the framework's intended self-discipline workflow.

Closes #157.

---

## v2.14.0 — TOH Framework Inspirations (May 2026)

Minor release closing milestone [#15](https://github.com/pitimon/8-habit-ai-dev/milestone/15) — three workflow-discipline imports from [Toh Framework](https://github.com/Nathanphop/Toh-Framework) (an "AI-Orchestration Driven Development" framework for solo SaaS builders). Cross-pollination filtered through plugin-boundary: workflow discipline here, project-state persistence routed to `claude-governance`.

- **SKILL_OUTPUT attribution lines** ([#151](https://github.com/pitimon/8-habit-ai-dev/issues/151), [PR #152](https://github.com/pitimon/8-habit-ai-dev/pull/152)) — `[/<skill>] COMPLETE SKILL_OUTPUT:<type>` directly above each HTML comment in the 4 emitter skills. Status markers `COMPLETE` / `PARTIAL` / `FAILED` (text-only). New **Check 22** in `validate-structure.sh`; `cross-verify` parser unaffected. Inspired by Toh's Agent Announcement format.
- **Argument-driven smart-routing for `/using-8-habits`** ([#149](https://github.com/pitimon/8-habit-ai-dev/issues/149), [PR #154](https://github.com/pitimon/8-habit-ai-dev/pull/154)) — `/using-8-habits "<intent>"` returns ≤3 ranked skills + reasoning + alternatives + one direct question, instead of the full narrative tree. Reads `~/.claude/habit-profile.md` for verbosity and recent `~/.claude/lessons/` for context. Activates existing `argument-hint` frontmatter — no new skill file. Inspired by Toh's `/toh` Smart Command (reshape: extend rather than wrap).
- **`/review-ai` Verification Phase** ([#150](https://github.com/pitimon/8-habit-ai-dev/issues/150), [PR #155](https://github.com/pitimon/8-habit-ai-dev/pull/155)) — Find → Fix → Re-Verify loop: list CRITICAL/HIGH, apply fix, re-run review, cite evidence per finding, refuse to emit `pass: true` unless all CRITICAL closed. Output ends with a Verification Table. **Plugin boundary**: section header reads "guidance only — NOT a hook"; new **Check 20** in `validate-content.sh` enforces three-anchor boundary qualifier. Inspired by Toh's Test → Fix → Loop adapted as discipline guidance, not automated enforcement.

Pattern: external-framework cross-pollination kept tight by the boundary rule — 3 of 10 Toh ideas imported, 7 rejected with reason (multi-agent builders, "vibe" command, design profiles, component registry, multi-IDE adapters, 7-file project memory). Companion proposal in `claude-governance` ([#24](https://github.com/pitimon/claude-governance/issues/24)) for the persistence layer.

Fitness receipts: `validate-structure.sh` **246/0** (+1), `validate-content.sh` **201/0/1 WARN** (+3), `test-skill-graph.sh` 57/0, `test-verbosity-hook.sh` 19/0.

Closes #149, #150, #151.

---

## v2.13.1 — SELF-CHECK.md Body Freshness (April 2026)

Patch release closing the three-PR arc for [#141](https://github.com/pitimon/8-habit-ai-dev/issues/141) — SELF-CHECK.md body drift (header said v2.13.0 but footer said Previous: 2.7.1 and per-release list ended at v2.8.0, skipping 6 releases).

- **One-time catch-up** ([PR #142](https://github.com/pitimon/8-habit-ai-dev/pull/142)) — SELF-CHECK.md footer updated to `Previous: 2.12.0`; added 6 missing rows (v2.9.0 through v2.13.0). Plugin opens with _"H8 Modeling: Follow the process always, no shortcuts when unwatched"_ — contradicted by 6 consecutive silent releases.
- **Convention correction** ([PR #143](https://github.com/pitimon/8-habit-ai-dev/pull/143)) — CONTRIBUTING.md § Version Bumping "Version lives in **3 files**" → "**4 files**", adds `SELF-CHECK.md` header to the list (convention enforced since [#106](https://github.com/pitimon/8-habit-ai-dev/issues/106) but CONTRIBUTING.md never caught up).
- **CI invariant** ([PR #144](https://github.com/pitimon/8-habit-ai-dev/pull/144)) — `tests/validate-content.sh` Check 19 sub-checks E + F: footer must match `git tag -l "v2.*" | sort -V` predecessor of `plugin.json.version` (E); every v2.x tag must have a matching `^- v<x.y.z>: ` row in SELF-CHECK.md (F). Prevents recurrence of the drift class.
- **`.github/workflows/validate.yml`** — `fetch-tags: true` + `fetch-depth: 0` added to `actions/checkout@v4` so CI can read tag history.

Fitness receipts: `validate-structure.sh` 245/0, `validate-content.sh` **198/0/1 WARN** (was 196 + 2 net new pass-able assertions — same hardening shape as v2.11.1 drift guard), `test-skill-graph.sh` 57/0, `test-verbosity-hook.sh` 19/0.

Closes #141.

---

## v2.13.0 — Cross-Agent Discoverability (April 2026)

Minor release making the plugin discoverable from non-Claude agent platforms — three linked PRs from the 2026-04-22 `/research` session on [`garrytan/gbrain`](https://github.com/garrytan/gbrain). No breaking changes.

- **`skills/RESOLVER.md`** ([#135](https://github.com/pitimon/8-habit-ai-dev/issues/135), [PR #139](https://github.com/pitimon/8-habit-ai-dev/pull/139)) — flat phrase-to-skill dispatcher covering all 17 skills in 3 sections (Workflow / Assessment / Meta), ≤3 triggers each. Fills the phrase→path lookup gap; **Check 20** enforces bidirectional coverage (directory ↔ RESOLVER row).
- **`llms.txt` + `AGENTS.md`** at repo root ([#136](https://github.com/pitimon/8-habit-ai-dev/issues/136), [PR #140](https://github.com/pitimon/8-habit-ai-dev/pull/140)) — cross-agent entry points for Codex / Cursor / Windsurf / Aider / Continue / LLM-based fetchers. `llms.txt` follows [llmstxt.org](https://llmstxt.org) convention; `AGENTS.md` is the non-Claude operating protocol. **Check 21** enforces both files exist + 4× pointer integrity to `skills/RESOLVER.md` and `CLAUDE.md`.
- **README "Design Principle" section** ([#137](https://github.com/pitimon/8-habit-ai-dev/issues/137), [PR #138](https://github.com/pitimon/8-habit-ai-dev/pull/138)) — cites Garry Tan's 2026 essay _"Thin Harness, Fat Skills"_ as external validation of the bounded-hook + fat-skills pattern already enforced by `hooks/session-start.sh` (≤300 tokens).
- **ADR-010** (Flat Skill Dispatcher) and **ADR-011** (Cross-Agent Discoverability) — 6 options considered each; ADR-011 records the design-time empirical finding that `obra/superpowers-skills/.../references/` (cited in #136's issue body) was already HTTP 404 — AGENTS.md cites upstream tool patterns by name only.
- **Pattern extracted**: "Bidirectional Validator for Canonical Cross-References" — forward + reverse coverage invariants as the unit-test analog for documentation integrity. Check 12 / 20 / 21 share this shape.

Fitness receipts: `validate-structure.sh` 245/0, `validate-content.sh` 196/0/1 WARN, `test-skill-graph.sh` 57/0, `test-verbosity-hook.sh` 19/0. End-to-end cross-agent chain: `llms.txt → AGENTS.md → skills/RESOLVER.md → individual SKILL.md`.

Closes #135, #136, #137.

---

## v2.12.0 — Code-Symbol Grep Evidence (April 2026)

Minor release adding a new Evidence Standard obligation to `/research` and clarifying `research-verifier` scope ([#133](https://github.com/pitimon/8-habit-ai-dev/issues/133)). Guidance-only — no automation, no hook.

- **`/research` Evidence Standard** — code-symbol verdicts matching `/remove|dead|unused|transitional|safe to (drop|remove)/i` must cite a grep-check showing consumer usage across source directories; declaration-site citations (e.g. `package.json:6`) do not establish liveness. Closes a false-positive class surfaced by memforge `neo4j-driver` audit (the canonical Bolt client for Memgraph — brand-name mismatch passed Deep-mode with pristine citations).
- **`research-verifier` scope** — `description:` rewritten to "citation-integrity verification agent"; new `## Limit of Verification` section defines in-scope (citation accuracy) vs. out-of-scope (semantic correctness of conclusions). Verifier emits `SEMANTIC-EVIDENCE-MISSING` flag on code-symbol verdict rows lacking liveness evidence but does not perform the grep itself.
- **Trigger regex scope** — `"revisit"` intentionally excluded; over-triggers on follow-up-style verdicts. Hard-removal verdicts are the load-bearing class.

Fitness receipts: `validate-structure.sh`, `validate-content.sh`, `test-skill-graph.sh`, `test-verbosity-hook.sh` all green.

Closes #133.

---

## v2.11.1 — CHANGELOG Drift Guard (April 2026)

Patch release hardening `validate-content.sh` Check 19 against recurring CHANGELOG drift ([#124](https://github.com/pitimon/8-habit-ai-dev/issues/124), [PR #131](https://github.com/pitimon/8-habit-ai-dev/pull/131)). Post-v2.11.0 `/cross-verify` exposed the same drift class slipping CI twice (v2.9.0 + v2.11.0) through a pointer-fallback loophole.

- **3 new FAIL-severity assertions** in Check 19: `CHANGELOG.md ^## v<ver>` present, wiki `^## v<ver>` present (no pointer fallback), wiki badge `latest-v<ver>-blue` match.
- **Backfilled** missing v2.9.0 + v2.11.0 entries in root `CHANGELOG.md` and v2.11.0 in wiki `Changelog.md`.

Fitness receipts: `validate-structure.sh` 243/0, `validate-content.sh` 185/0, `test-skill-graph.sh` 57/0, `test-verbosity-hook.sh` 19/0.

Closes #124.

---

## v2.11.0 — Design Pipeline Completion + Wiki Redesign (April 2026)

Close the final gap in the `/requirements` → `/design` → `/breakdown` → `/review-ai` structured-output-block handoff chain, and upgrade 20 wiki pages to a professional template. Both PRs merged within 3 minutes of each other.

- **`SKILL_OUTPUT:design` structured block** ([#128](https://github.com/pitimon/8-habit-ai-dev/issues/128) / [PR #129](https://github.com/pitimon/8-habit-ai-dev/pull/129)) — closes the last cross-skill handoff gap; `/cross-verify` Q4/Q14/Q16 now auto-populate from the design block.
- **Tech-stack decisions as formal concerns** — `/design` Step 2 + `/research` Step 1 surface language/framework as explicit outputs.
- **Scope validation via `SKILL_OUTPUT:requirements`** — `/design` consumes the requirements block so scope drift between decisions and success criteria is flaggable.
- **H8 Whole Person in `/design` checkpoint** — Body/Mind/Heart/Spirit prompts.
- **Wiki redesign** ([#127](https://github.com/pitimon/8-habit-ai-dev/issues/127) / [PR #130](https://github.com/pitimon/8-habit-ai-dev/pull/130)) — new `Architecture.md` (4-layer plugin design), new `Maturity-Model.md` (4-level adaptive guidance), `Home.md` rewritten as hero landing page, `Skills-Reference.md` expanded 13 → 17 with quick-select matrix, `Workflow-Overview.md` Mermaid diagram, all 8 Step pages with `> [!IMPORTANT]` checkpoints, `_Sidebar.md` reorganized with Concepts section. 18 files, 291 insertions, 53 deletions.

Fitness receipts: `validate-structure.sh` 243/0, `validate-content.sh` 183/0, `test-skill-graph.sh` PASS, `test-verbosity-hook.sh` PASS.

---

## v2.10.0 — Progressive-Disclosure SKILL.md Split (April 2026)

Refactor the 3 largest skills into `SKILL.md + reference.md + examples.md` triads per [ADR-009](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-009-skill-split-convention.md). Creates headroom below the F3 word-budget fitness ceiling so future feature additions don't break the validator. Pattern sourced from external research (`shanraisshan/claude-code-best-practice`), filtered through plugin-boundary audit.

- **ADR-009** — codifies Load-directive mechanism (`${CLAUDE_PLUGIN_ROOT}` inline paths), naming convention, and when-to-apply threshold (SKILL >1500 words). Reuses existing Check 8 for sibling existence — no new fitness function needed for that.
- **F6 (Check 9b)** — soft word-budget warning for `reference.md` / `examples.md` (5000-word soft limit).
- **`using-8-habits`** split: SKILL 1990 → 1094 words; `reference.md` holds the full 17-skill inventory + cross-plugin composition tables; `examples.md` holds the password-reset onboarding walkthrough.
- **`eu-ai-act-check`** split: SKILL 1989 → 908 words; `reference.md` holds the full 9-obligation checklist (25 MUST / 27 SHOULD / 8 COULD items) with article/paragraph references. No `examples.md` (pure-reference skill).
- **`calibrate`** split: SKILL 1774 → 1161 words; `reference.md` holds the scoring rubric + profile-write procedure; `examples.md` holds 4 sample profiles (one per maturity level).
- **Content validator triad-awareness** — Checks 15 and 18 in `tests/validate-content.sh` now search the SKILL + reference + examples triad as a unit, so content moved to sibling files still satisfies anti-drift and tier-count assertions.
- **Rejected from this release** — 27-event hook catalog (referred to [`pitimon/claude-governance#22`](https://github.com/pitimon/claude-governance/issues/22)), Idea B (auto-load `user-invocable: false` habits), Idea D (parallel `/cross-verify` dispatch), F3 WARN→FAIL upgrade. Rejection rationale documented in root `CHANGELOG.md`.

Fitness receipts: `validate-structure.sh` 243/0, `test-skill-graph.sh` PASS, `validate-content.sh` 183/0 with 0 fitness breaches. Release shipped via [Issue #125](https://github.com/pitimon/8-habit-ai-dev/issues/125) / [PR #126](https://github.com/pitimon/8-habit-ai-dev/pull/126) in a single clean forward pass.

---

## v2.9.0 — Deep-Project Inspired Improvements (April 2026)

Three features inspired by comparison research against `piercelamb/deep-project`. Cross-verified (14/17), advisor-reviewed, 8-habit QA passed (13/17 → 15/17).

- **Interview protocol for `/requirements`** ([#118](https://github.com/pitimon/8-habit-ai-dev/issues/118)) — new `guides/templates/interview-protocol.md` gives structured conversation scaffolding (Quick/Standard/Deep depth) for discovering requirements before EARS criteria. Replaces the "ask the user 5 questions" default with a better-shaped discovery flow.
- **Workflow step awareness in session-start hook** ([#119](https://github.com/pitimon/8-habit-ai-dev/issues/119)) — `hooks/session-start.sh` now surfaces a workflow step cue so partial chains can resume across sessions without per-skill rework.
- **Machine-readable structured output blocks** ([#120](https://github.com/pitimon/8-habit-ai-dev/issues/120)) — new `guides/structured-output-protocol.md` defines `<!-- SKILL_OUTPUT:... END_SKILL_OUTPUT -->` HTML comment blocks at the end of `/requirements`, `/breakdown`, and `/review-ai`. Enables `/cross-verify` to auto-check scope alignment (task_count vs ears_count ≤ 3× ratio) and review coverage, reducing manual re-reading of prior-step artifacts.

---

## v2.8.0 — Claude Code Architecture Insights (April 2026)

Production patterns from Anthropic's Claude Code internals (reverse-engineered in ["Claude Code from Source"](https://github.com/alejandrobalderas/claude-code-from-source)) adapted into 4 existing skills as workflow guidance.

- **`/build-brief` context compression awareness** ([#114](https://github.com/pitimon/8-habit-ai-dev/issues/114)) — step 6 "Context survival" for briefs that survive the 4-layer compression pipeline
- **`/design` sticky latch principle** ([#116](https://github.com/pitimon/8-habit-ai-dev/issues/116)) — step 5 "Sticky decisions" with rework-level classification table
- **`/reflect` lesson consolidation** ([#113](https://github.com/pitimon/8-habit-ai-dev/issues/113)) — Step 7 + `/reflect consolidate` argument with 4-phase dream-inspired cycle
- **`/breakdown` fork agent pattern** ([#115](https://github.com/pitimon/8-habit-ai-dev/issues/115)) — step 5 "Token-efficient parallel design" with ~90% cache hit guidance

## v2.7.1 — Review Discipline Refinement (April 2026)

Small post-milestone patch adding two disciplines to `/review-ai` after a cost/benefit audit against `addyosmani/agent-skills` (MIT). Scope deliberately minimal — only one of six candidate mechanics was imported.

- **`/review-ai` Performance axis** ([#110](https://github.com/pitimon/8-habit-ai-dev/issues/110), [PR #111](https://github.com/pitimon/8-habit-ai-dev/pull/111)) — fourth review category flagging N+1 queries, unbounded loops, missing pagination, unindexed queries, and memory leaks; same `file:line` evidence standard as the other axes
- **Review-tests-first directive** — new Process step 2 directs the reviewer to read new/changed tests before judging implementation
- **Rejections preserved in PR #111 body** — `guides/anti-rationalization.md`, `guides/red-flags.md`, `guides/google-engineering-principles.md`, `/cross-verify` Q18, and a cross-plugin hard-gate spec were all evaluated and rejected as duplicative of existing features or out-of-scope

## v2.7.0 — Reader Adoption (April 2026)

Closes the `/calibrate` feature loop by making skills read `~/.claude/habit-profile.md` via a session-start hook.

- **Hook-based verbosity adaptation** ([#96](https://github.com/pitimon/8-habit-ai-dev/issues/96)) — `hooks/session-start.sh` emits a per-level directive into session context; 16 existing skills auto-adapt with zero file changes
- **`guides/verbosity-adaptation.md`** — canonical per-level rules with 5 skill-archetype examples
- **`tests/test-verbosity-hook.sh`** — 12-assertion regression coverage for all 8 hook branches + HABIT_QUIET opt-out + ≤300-token budget check
- **4 validators in CI, 482 total assertions** (up from 3 / 470)
- **Milestone v2.7.0 CLOSED** — Hermes-inspired feature loop (v2.6.0 + v2.7.0) complete

## v2.6.1 — Skill Effectiveness Tracking (April 2026)

- **`/reflect` Q6 Skill Effectiveness signal** ([#92](https://github.com/pitimon/8-habit-ai-dev/issues/92)) — 6th retro question captures "most useful" and "least useful/confusing" skill
- **`SKILL-EFFECTIVENESS.md`** (repo root) — maintainer-curated trend tracker; H7 applied to the plugin itself
- **`guides/templates/lesson-template.md`** — new `## Skill effectiveness` section for consistent Q6 capture
- **Fix**: SIGPIPE flake in `validate-content.sh` F3 extractor — replaced `sed | head` with pipe-safe awk

## v2.6.0 — Hermes-Inspired Improvements (April 2026)

- **`/calibrate` skill + habit-profile schema v1** ([#90](https://github.com/pitimon/8-habit-ai-dev/issues/90), [ADR-008](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-008-user-maturity-calibration-design.md)) — 5-7 question self-assessment writing `~/.claude/habit-profile.md` with dominant-level scoring
- **`guides/habit-profile-schema.md`** — public schema contract (YAML + markdown body, versioned via `schema-version`)
- **Persistent reflection artifacts** ([#88](https://github.com/pitimon/8-habit-ai-dev/issues/88)) — `/reflect` writes lessons to `~/.claude/lessons/`; `/research` and `/build-brief` read them before starting work
- **`guides/habit-nudges.md`** + **ADR-007** — nudge spec (hook delegated to claude-governance) + agentskills.io NO-GO decision
- **Skill count: 16 → 17** (`/calibrate` added)

## v2.5.0 — Testing & Discoverability (April 2026)

- **`tests/test-skill-graph.sh`** — DAG validator for `prev-skill` / `next-skill` chains (#79): cycles, dangling refs, symmetric edges, orphans
- **`hooks/pre-commit.sh.example`** — template running `/review-ai` on staged files (opt-in, not auto-installed)
- **Bidirectional wiki ↔ skills linking** (#81) — each workflow skill has a `## Further Reading` section linking to its wiki page
- CI now runs 3 validators; 443 total assertions

## v2.4.1 — Honest Correction (April 2026)

Same-day correction after comparing `/brainstorm` to `superpowers:brainstorming`.

- **Removed `/brainstorm` skill** (breaking) — superpowers' 500+ line hard-gate discipline suite is a better fit; `/research` now references it for fuzzy problem statements
- **`HABIT_QUIET=1` opt-out** for `hooks/session-start.sh` — users who internalize the workflow can silence the reminder
- **"Core 5" tier** in `/using-8-habits` — 80/20 reality acknowledgment
- [ADR-006](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-006-audience-honesty-and-opt-out.md) — audience-honesty + opt-out + "check peer plugins before building parity" lesson

## v2.4.0 — Workflow Completions (April 2026)

- **`/brainstorm`** (Step 0a, later removed in v2.4.1) — 5 Whys, alternative framings, hidden assumptions
- **EARS-notation in `/requirements`** — 5 structured acceptance criteria templates from Rolls-Royce (Mavin et al. 2009)
- **`/using-8-habits`** — onboarding meta-skill with decision tree and complete walkthrough example
- Validators: +52 assertions, anti-drift check ensures meta-skill references every directory skill
- Fix: `validate-structure.sh` regex allowing digits in skill names

## v2.3.0 — EU AI Act Compliance Toolkit (April 2026)

Flagship blue-ocean feature: first Claude Code plugin with explicit EU AI Act compliance toolkit, shipped ~4 months before 2 August 2026 enforcement.

- **`/eu-ai-act-check`** — 9-obligation tiered checklist (25 MUST + 27 SHOULD + 8 COULD) covering Articles 9-15
- **`/ai-dev-log`** + **`scripts/generate-ai-dev-log.sh`** — AI-assisted development log from `git log` + Co-Authored-By trailers (4 modes: markdown/json/summary/out)
- **`/design` Step 5** — Article 14 human-oversight 5-capability checkpoint (Understand / Automation bias / Interpret / Override / Stop button)
- **`docs/research/eu-ai-act-obligations.md`** — primary-source research with Verified Quotes for all 7 articles
- **[ADR-005](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-005-eu-ai-act-toolkit.md)** + **Plugin Boundary section** in `CLAUDE.md` — documents complementary relationship with [`pitimon/claude-governance`](https://github.com/pitimon/claude-governance)
- Version file convention corrected to **4 files** (added `SELF-CHECK.md`)
- Fix: `validate-structure.sh` SIGPIPE race replaced `sed | head` with awk

## v2.2.0 — April 2026

- README overhauled with a professional 8-Habit aligned template
- Hero tagline reframed around pain-point + benefit
- Quick Start split into install + use blocks
- 7-Step Workflow diagram simplified
- GitHub repo description and topics updated
- Wiki infrastructure introduced (`docs/wiki/`, sync Action, link check) — see [ADR-004](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-004-wiki-as-artifact.md)

## v2.1.0

- Smart QA integration with 8-Habit framework
- README internal link and skill cross-reference validation
- `validate-content.sh` fitness function improvements

## v2.0.0

- Three accepted ADRs drive architecture:
  - [ADR-001 Orchestration Patterns](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-001-orchestration-patterns.md)
  - [ADR-002 Research Modes](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-002-research-modes.md)
  - [ADR-003 Content Validation](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-003-content-validation.md)
- Three architecture fitness functions (skill complexity, content depth, cross-reference integrity)
- `validate-content.sh` added alongside `validate-structure.sh`

## v1.x

- Initial 7-step workflow and 8-habit skill set
- Cross-verify agent (`8-habit-reviewer`)
- External QA review v1.0.0 scored 9.5/10 (EXCELLENT) — [Issue #1](https://github.com/pitimon/8-habit-ai-dev/issues/1)

## Versioning policy

This plugin follows [semantic versioning](https://semver.org/):

- **Major** — breaking change to skill interfaces, skill removal, or workflow restructuring
- **Minor** — new skills, new habits content, backward-compatible additions
- **Patch** — documentation fixes, typo corrections, clarifications

Version is tracked in five files that must bump together (enforced by `tests/validate-structure.sh`):

- `.claude-plugin/plugin.json`
- `.claude-plugin/marketplace.json`
- `.codex-plugin/plugin.json`
- `README.md` (badge + footer)
- `SELF-CHECK.md` header

## Full history

- **Releases**: [github.com/pitimon/8-habit-ai-dev/releases](https://github.com/pitimon/8-habit-ai-dev/releases)
- **Tags**: [github.com/pitimon/8-habit-ai-dev/tags](https://github.com/pitimon/8-habit-ai-dev/tags)
- **Commits**: [github.com/pitimon/8-habit-ai-dev/commits/main](https://github.com/pitimon/8-habit-ai-dev/commits/main)
