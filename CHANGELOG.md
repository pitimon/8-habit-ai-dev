# Changelog

All notable changes to `8-habit-ai-dev` are documented here.

**Authoritative sources**: [GitHub Releases](https://github.com/pitimon/8-habit-ai-dev/releases) and [git tag history](https://github.com/pitimon/8-habit-ai-dev/tags).

This file summarizes recent versions. For v2.2.0 and earlier, see `docs/wiki/Changelog.md` or the Releases page.

Versioning follows [Semantic Versioning](https://semver.org/).

---

## v2.21.3 — Codex Project Context Files (2026-06-06)

### Documentation

- Add repo-local Codex context files: `DOMAIN.md`, `SPEC.md`, `.codex/README.md`, `docs/adr/README.md`, and ADR-025. These give Codex and other non-Claude agents concise session re-entry context while preserving `CLAUDE.md` as Claude Code's architecture reference.
- Update `AGENTS.md` and `llms.txt` so local and remote agents can discover the new context files.

### Boundary

- Documentation and session ergonomics only. No skill behavior change, runtime enforcement, marketplace behavior change, or Claude hook port to Codex.

## v2.21.2 — Codex Installed-Cache Validator Context (2026-06-06)

### Fixed

- Fix `tests/validate-structure.sh` Check 28 when run from Codex's installed plugin cache. The validator now keeps `plugin -> .` mandatory in source/marketplace snapshots, but treats the missing symlink as expected under `~/.codex/plugins/cache/...`, where Codex has already copied the plugin root. Closes issue #278.

### Documentation

- Clarify the Codex source/marketplace versus installed-cache validation boundary in `docs/codex-integration.md` and `docs/compatibility-matrix.md`.

## v2.21.1 — Cross-Agent Evidence Discipline (2026-06-06)

### Documentation

- Add Headroom-inspired cross-agent evidence discipline docs: a wiki Limitations page, expanded runtime/plugin comparison and release-evidence guidance, and real-behavior-proof contribution/release checklist language. Closes issues #273, #274, and #275 via PR #276.

### Maintenance

- Update `SKILL-EFFECTIVENESS.md` for the release checklist: harvest one previously untallied `/whole-person-check` signal and add the missing `/operational-state` row so the report covers all 24 current skills.

---

## v2.21.0 — Cross-Agent Discovery and Portability Contract (2026-06-06)

Adds a conservative discovery/export layer inspired by `cosmicstack-labs/mercury-agent-skills`, adapted to this plugin's Claude Code + Codex portability boundary. This closes the v2.21.0 milestone scope for issues #267, #268, #269, and #270.

### Shipped

- **Frontmatter compatibility contract** — `CONTRIBUTING.md`, `guides/skill-authoring.md`, and `docs/compatibility-matrix.md` now document required, optional, cross-agent, and Codex-ingestible `SKILL.md` frontmatter fields.
- **Generated skill catalog** — `docs/data/skills.json` is generated from `skills/*/SKILL.md` by `scripts/generate-skill-catalog.js` for cross-agent discovery. `llms.txt` and `docs/codex-integration.md` now point to it.
- **Catalog freshness validation** — `tests/validate-structure.sh` Check 30 runs `node scripts/generate-skill-catalog.js --check` so catalog drift fails CI.
- **Handoff integrity guidance** — `guides/structured-output-protocol.md` adds a compact handoff note pattern for current state, decisions, assumptions, evidence, confidence, next skill, and rejection path.
- **AI-work budget/health checkpoint** — `/review-ai`, `/reflect`, and `guides/quick-reference.md` now surface observable signals such as loops, retries, context compaction, audit evidence, and next-session recoverability.

### Boundary

Markdown guidance and generated documentation metadata only: no runtime dispatcher, no Claude hook port to Codex, no budget enforcement, no policy gate, no compliance certification, and no agent-to-agent orchestration protocol. Scripts and validators are dependency-free and intended to run across macOS, Linux, and WSL.

### Versioning

Minor bump because this adds a new cross-agent discovery artifact and consumer-facing guidance across `guides/`, `skills/`, `docs/`, and validation.

---

## v2.20.2 — Production Canary Reconciliation Gates (2026-06-06)

Extends `/deploy-guide` with a production canary / capacity-change template for provider-managed infrastructure where the operator can pick a canary but the cloud provider may mutate a different eligible target. This closes issue #250.

### Shipped

- **Deploy type classifier** — adds `production canary / capacity change` for EKS nodegroups, ASGs, Kubernetes nodes, and similar provider-managed work.
- **Canary phases** — documents precheck, cordon approval, observation, drain approval, provider-side change approval, reconciliation, and postcheck/evidence closure.
- **Provider reconciliation gate** — compares planned target vs actual provider-selected target; checks desired/min/max, schedulable capacity, all nodes Ready, no unintended `SchedulingDisabled` nodes, and whether the original canary needs uncordon/follow-up.
- **Rollback/mitigation coverage** — requires pre-scale rollback/mitigation readiness and post-scale mitigation evidence.
- **Production ops wording** — adds an evidence snippet that distinguishes scale/update success from reconciliation success and routes unresolved state to `/operational-state`.

### Boundary

Markdown guidance only: no cloud operation execution, no policy enforcement, no Kubernetes/ASG automation, and no runtime state engine were added.

### Versioning

Patch bump because this is a consumer-facing doctrine update to an existing skill without changing plugin inventory.

---

## v2.20.1 — Incident/Config Consistency-Lite (2026-06-06)

Extends `/consistency-check` with a lightweight incident/config hotfix mode for operational PRs and closure notes that do not have persisted `docs/specs/<slug>/` artifacts. This closes issue #253 while keeping the broader production canary workflow (#250) separate.

### Shipped

- **Incident/config hotfix mode** — `/consistency-check` now supports issue, PR, changelog, deploy, alert, and verification material when no persisted PRD/design/tasks bundle exists.
- **Hotfix consistency table** — the mode emits `symptom | evidence | root cause | fix | verification | drift`.
- **Drift labels** — flags missing evidence, overclaiming PR/changelog text, fix-scope mismatch, deploy-path drift, and unclassified adjacent operational state.
- **Operational-state handoff** — unresolved related findings are explicitly classified or routed to `/operational-state` before closure.
- **Worked example** — `skills/consistency-check/reference.md` includes a generic WorkerDown/Alertmanager alert/config hotfix example.

### Boundary

Markdown guidance only: no runtime enforcement, no new skill, no cloud operation execution, and no automatic issue or alert mutation were added.

### Versioning

Patch bump because this is a consumer-facing doctrine update to an existing skill without changing plugin inventory.

---

## v2.20.0 — Operational State Model (2026-06-06)

Adds `/operational-state`, a new read-only skill for classifying operational findings before acting, mutating shared infrastructure, or closing a ticket. This closes issue #251 and keeps #250 (production canary workflow) and #253 (incident/config consistency-lite) as follow-on work that can build on the state vocabulary.

### Shipped

- **`/operational-state`** — classifies findings as `Watch`, `Fix Candidate`, `Active Incident`, `Resolved`, `Handoff`, `Known Accepted Issue`, `False Positive`, or `Self-Resolved`.
- **State matrix reference** — `skills/operational-state/reference.md` maps each state to required evidence, allowed/prohibited actions, approval requirements, artifacts, escalation criteria, and closure criteria.
- **Operational guardrails** — documents that Running is not healthy, recovered is not fixed, source-of-truth drift stays visible, report hygiene is not a production mutation, and adjacent unresolved state must not be hidden.
- **Routing and docs** — updates `skills/RESOLVER.md`, `/using-8-habits`, README, wiki skill catalog, `llms.txt`, and Claude/Codex manifests for 24 skills.

### Boundary

Markdown guidance only: no runtime state engine, policy enforcement, cloud operation execution, alert suppression automation, or automatic production writes were added. Production/shared-infrastructure mutations still require explicit human approval and the appropriate deploy/rollback workflow.

### Versioning

Minor bump because this adds a new consumer-facing skill in `skills/`, per the existing new-skill release convention and ADR-019 consumer-doctrine rule.

---

## v2.19.2 — Operational Doctrine Patch from Open Issues (2026-06-06)

Ships the conservative doctrine-only slice from open issues #252, #254, #255, and #256. This release deliberately does not add a new operational-state skill; #250, #251, and #253 remain deferred for the broader operational model/design pass.

### Shipped

- **`/deploy-guide`** — adds a deploy-type classifier before rollout planning (`image build`, `mounted config/template`, `Swarm config`, `full stack`, `source-of-truth drift`, `force-update only`, `no deploy`) and qualifies the config-only skip rule so runtime-impacting config still gets deploy planning.
- **`/security-check`** — expands its trigger surface to alerting/email templates, SMTP, webhooks, notification links, Docker/Kubernetes/Compose/Swarm config, env/secret interpolation, mounted config, rendered config, and source-of-truth drift.
- **`/reflect`** — preserves the six-question contract while splitting Q6 into `most_useful`, `least_or_confusing`, and `missed_skill`; the lesson template and DoD now preserve missed-skill signals for `SKILL-EFFECTIVENESS.md` review.
- **`/management-talk`** — adds an operational incident closure worked example using generic WorkerDown/Alertmanager source material, rendered for Slack, standup, email, and meeting talking points while stripping file/SHA/command detail.

### Boundary

Markdown doctrine only: no runtime automation, policy enforcement, cloud operation execution, or operational-state engine was added. The plugin remains portable workflow guidance.

### Versioning

Patch bump because this is consumer-facing doctrine in `skills/` and `guides/templates/`, per ADR-019.

---

## v2.19.1 — Codex Runtime Compatibility Contract (2026-05-31)

Clarifies the post-v2.19.0 Codex story: native Codex packaging means Codex can install and use the same markdown skills, not that Claude-specific hooks or runtime behavior now execute inside Codex.

### Shipped

- **`docs/compatibility-matrix.md`** — documents the runtime contract across Claude Code, Codex, and other markdown-capable agents: shared skills and workflow guidance are portable; Claude hooks, hook-based verbosity, and runtime enforcement are not portable runtime behavior.
- **`docs/codex-integration.md`** — gives Codex users the install, verify, routing, release-flow, and optional adapter guidance in one place.
- **`docs/adr/ADR-024-codex-runtime-adapter-boundary.md`** — records the adapter boundary: future Codex automation may route intents, open skills, run validators, reconcile releases, and write curated memory; policy enforcement, compliance execution, irreversible-action authorization, and orchestration engines stay outside the markdown skill core.
- **Validator coverage** — `tests/validate-structure.sh` Check 29 pins the compatibility docs and requires README, `AGENTS.md`, and `llms.txt` to index them.
- **Entrypoint sync** — README, `AGENTS.md`, and `llms.txt` now point Codex users to the same compatibility contract; `llms.txt` also corrects the skill count from 17 to 23.

### Versioning

Patch bump because this tightens the Codex runtime contract and adds validation without changing the 23 skills or adding runtime enforcement.

---

## v2.19.0 — Native Codex Plugin Packaging (2026-05-31)

Adds first-class Codex packaging so the same markdown-only skill system can be installed with Codex's plugin marketplace flow, not only loaded manually via `AGENTS.md`.

### Shipped

- **`.codex-plugin/plugin.json`** — native Codex plugin manifest pointing at the existing `skills/` directory, with Codex `interface` metadata, default prompts, author/repository/license fields, and version aligned to the Claude package.
- **`.agents/plugins/marketplace.json`** — Codex marketplace descriptor named `pitimon-8-habit-ai-dev`, with plugin source path `"./plugin"`. `plugin` is a symlink to the repo root because Codex marketplace discovery ignores root-path entries (`"."` / `"./"`). Install flow: `codex plugin marketplace add pitimon/8-habit-ai-dev` then `codex plugin add 8-habit-ai-dev@pitimon-8-habit-ai-dev`.
- **`docs/adr/ADR-023-codex-native-packaging.md`** — records the packaging decision and keeps the boundary explicit: Codex gets the same read-only markdown skills; Claude-specific hooks remain Claude packaging; no runtime enforcement added.
- **Codex ingestion compatibility** — `disable-model-invocation` on `/ai-dev-log` and `/save-spec` is set to `false`. ADR-014 already marked the previous `true` declarations as decorative for Claude plugin skills; Codex validation rejects `true`, so compatibility wins until both platforms support the field consistently.
- **Validator coverage** — `tests/validate-structure.sh` now checks Codex manifest/marketplace presence, required fields, and version alignment. Check 27 treats `.codex-plugin/**` and `.agents/plugins/marketplace.json` as consumer-doctrine paths requiring a bump.

### Versioning

The release convention expands from 4 to 5 version-bearing files: `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`, `.codex-plugin/plugin.json`, `README.md`, and `SELF-CHECK.md`.

Minor bump because this is a new install surface for a new consumer platform; existing Claude Code behavior is unchanged.

## v2.18.9 — Diagnose Worked-Example Polish (2026-05-30)

Craft follow-up to v2.18.8, closing a Heart-dimension gap a `/whole-person-check` flagged: the independent-source verification step in `/diagnose` Phase 4 told the reader _what_ to do, but the copy-pasteable _how_ lived one click away in the guide.

### Shipped

- **`skills/diagnose` Phase 4** — adds a runnable worked example (`docker run <img>` vs `docker exec <ctr>`, compare-and-flag-divergence) plus a one-line generalization so the technique transfers beyond docker (compile-from-source vs installed package; DB row vs API response; two log vantages): _read the claim twice from sources that can't share the same mistake, and only believe it when they agree._

### Boundary

Independence-of-source stays the rule; the example contains **zero** agent-orchestration vocabulary (no `parallel()`/`spawn`/`orchestrate`), so the ADR-021 engine boundary is intact — fan-out engine stays in `claude-governance`. Diagnose stays under the 2000-word F3 cap (1493 → 1585); Gap 2's AC (#243) is preserved.

### Doctrine

Consumer-doctrine bump per [ADR-019](docs/adr/ADR-019-doctrine-only-scope-refinement.md) (`skills/` edit MUST bump) — patch bump v2.18.8 → v2.18.9 atomic across 4 files.

---

## v2.18.8 — Independent-Source Verification (2026-05-30)

Adds the **discipline** that the first real fan-out use exposed (follow-up to [#243](https://github.com/pitimon/8-habit-ai-dev/issues/243), built on #241/ADR-021): catching a _confident-but-wrong root cause_ that survives every author-side gate because each gate reuses the same single contaminated observation. Lived case (memforge): a version read from `docker exec` ("stale config from buildx cache") survived `advisor`, a review pass, a merged PR, and a written `/reflect` lesson — until an independent probe (`docker run` on the image) contradicted it and surfaced the real cause: a bind-mount overriding the image. Boundary-safe per [ADR-021](docs/adr/ADR-021-dynamic-workflow-positioning.md) — the **discipline** lives here; the fan-out **engine** stays in `claude-governance`.

### Shipped

- **`guides/independent-source-verification.md`** (new, canonical) — the case study + rule: a root cause from a single observation source is unverified; confirm it from an _independent_ source (different tool/command/vantage) and **reconcile** contradictions rather than pick. Carries the reusable tell (`docker run <img>` ≠ `docker exec <container>` → a mount overrides the image) and a second non-docker instance (an OCR misread propagating through 4 artifacts) proving the discipline generalizes. Cited by all six edits below so they share one stable source.
- **Six gap edits** — `skills/diagnose` (Phase 4 independent-source verification + DoD item), `skills/cross-verify` (Q12 extended + a diagnosis-reconciliation callout), `skills/post-mortem` (§7 "overturned root cause" reason), `skills/reflect` (Q2 "did a prior diagnosis prove wrong?" sub-prompt), `guides/orchestration-patterns.md` (Pattern 4 diagnostic-escalation trigger), `guides/advisor-pattern.md` ("is all evidence single-source?" check for the gate that failed here).

### Discipline applied to its own rollout

`8-habit-reviewer` (disprove-mode, single ADR-021 question) caught one **DRIFT** — Pattern 4 text drifting toward owning the fan-out engine, the same #241-class boundary confusion — and confirmed **CLEAN** after reword (independence-of-source is the rule; fan-out is one optional delivery mechanism). Gap 3 was folded into the existing Q12 rather than renumbering the canonical 17-question checklist (avoids cascading into scoring bands, README, and llms.txt). Gap 4 tripped the 2000-word convention-consistency fitness cap on `post-mortem`, so the addition was merged into an adjacent bullet rather than padding the skill — the fitness function working as designed.

### Doctrine

Consumer-doctrine bump per [ADR-019](docs/adr/ADR-019-doctrine-only-scope-refinement.md) (`guides/` + `skills/` edits MUST bump) — patch bump v2.18.7 → v2.18.8 atomic across 4 files. PR closes [#243](https://github.com/pitimon/8-habit-ai-dev/issues/243).

---

## v2.18.7 — Dynamic Workflow Positioning (2026-05-29)

Positions the plugin against Opus 4.8's new **dynamic workflow** capability — a deterministic engine that spawns parallel sub-agents — which collides by name and philosophy with the plugin's human-gated `/workflow` skill. A 4-probe repo audit (issue [#241](https://github.com/pitimon/8-habit-ai-dev/issues/241)) settled the layering: the **engine** belongs to `claude-governance`; the fan-out **discipline** belongs here.

### Shipped

- **`guides/orchestration-patterns.md` Pattern 4: Fan-Out Discipline** — a when/when-not-to-fan-out gate keyed to habits (H6 Synergize reinforces; H1/H3/H5/H8 in tension) + an Article 14 oversight checklist (preserve Understand / Override / Stop under autonomous fan-out). Delegates the _how_ to existing Patterns 1-3 (no duplication); adds a Quick Reference row.
- **`docs/adr/ADR-021-dynamic-workflow-positioning.md`** — disambiguates `/workflow` (discipline) from the Opus 4.8 engine and quotes the CLAUDE.md boundary rule verbatim so the ADR does not over-claim. Engine (runtime + agent-spawn authorization) → `claude-governance`; discipline → here.

### Framing

Forward guardrail with **zero first-person friction signal** — the collision is structural (new upstream capability + same word as `/workflow`), surfaced by audit, not yet by a `/reflect` lesson. Sunset **2026-11-24** with explicit reversal criterion, per the ADR-014/017/020 precedent.

### Doctrine

Consumer-doctrine bump per [ADR-019](docs/adr/ADR-019-doctrine-only-scope-refinement.md) (`guides/` edit MUST bump) — patch bump v2.18.6 → v2.18.7 atomic across 4 files. PR closes [#241](https://github.com/pitimon/8-habit-ai-dev/issues/241).

---

## v2.18.6 — Step 4a awk Made Frontmatter-Aware (2026-05-24)

Fast-follow fix to v2.18.5 (shipped ~1h earlier) closing issue [#239](https://github.com/pitimon/8-habit-ai-dev/issues/239) — a QA pass on v2.18.5 caught that the step 4a body-measure command returned `0` for files without YAML frontmatter (ADRs and guides — 2 of the 3 artifact types the same sub-step names), directly contradicting the release's own case study (ADR-017 ~150 lines).

### Root cause

`skills/requirements/SKILL.md:80` (v2.18.5) prescribed `awk '/^---$/{c++; next} c>=2' <file> | wc -l` which counts lines after the **2nd** `^---$` — correct for YAML-frontmatter files (the two `---` delimit the frontmatter) but broken for files that start with `# Title` or `# ADR-NNN: ...`:

- ADRs: no frontmatter → counted from 2nd stray `---` thematic break onward, usually `0`
- Guides: no frontmatter → same, usually `0`
- Skills: have frontmatter → correct ✓

### Fix

`skills/requirements/SKILL.md:80` now uses a frontmatter-aware variant: `awk 'NR==1 && $0=="---"{f=1; next} f && $0=="---"{f=0; next} !f' <file> | wc -l` — strips frontmatter only when the file actually starts with `---`; otherwise counts the whole body. Mid-body `---` thematic breaks are correctly counted as body.

### Receipts (v2.18.6 tree)

| File                                             | broken v2.18.5 awk | fixed v2.18.6 awk | `wc -l` total |
| ------------------------------------------------ | ------------------ | ----------------- | ------------- |
| `docs/adr/ADR-017-*.md` (case study)             | 0                  | **152** ✓         | 152           |
| `docs/adr/ADR-018-*.md`                          | 2                  | **145** ✓         | 145           |
| `docs/adr/ADR-016-*.md` (≥2 thematic breaks)     | 157                | **205** ✓         | 205           |
| `guides/cross-verification.md`                   | 0                  | **95** ✓          | 95            |
| `skills/requirements/SKILL.md` (has frontmatter) | 131                | **131** ✓         | 142           |

### Regression test — `tests/validate-content.sh` Check 22

Closes the gap #239 explicitly named (_"`tests/**` was untouched, so no validator caught it"_):

- Grep-asserts SKILL.md step 4a carries the new awk variant
- Grep-asserts SKILL.md step 4a is free of the broken v2.18.5 form
- Runs the prescribed awk against 5 representative files spanning all 3 artifact types (ADR ×3, guide ×1, skill ×1) and asserts body counts match expected (ADR-016 → 205, ADR-017 → 152, ADR-018 → 145, `cross-verification.md` → 95, `requirements/SKILL.md` → 131)
- ADR-016 locks in the "mid-body `---` thematic breaks are body" behavior — broken v2.18.5 awk returned 157 by counting from the 2nd thematic break; fix returns 205 (full body)
- Heredoc carries a warning comment: editing any of the 5 receipt files requires re-measuring the expected count

Adds 7 new PASS assertions to the validator suite (282 PASS / 0 FAIL post-fix).

### Lesson and meta-pattern

Prescribed commands embedded in skill prose are **production guidance** and need regression tests, the same way runtime code does. v2.18.5 shipped an advisory `awk` snippet with all 4 validator suites green because no validator was reading the snippet's actual output — the structural validators check shape, not snippet-correctness. Check 22 establishes the precedent that future `awk`/`grep`/`jq` snippets in skill prose ship with a paired assertion.

This is the v2.18.5 ship's own H7 Sharpen-the-Saw beat: invest in the test that would have caught the bug, not just in the bug fix. For the plugin overall, the "tests" surface is structural validators (not pytest-style unit tests), but **every prescribed command in skill prose deserves a paired assertion** — the rule generalizes beyond the awk case.

### Template clarification

`guides/templates/prd-template.md` Success Criteria section gains a one-line note that ADR/guide precedents have no frontmatter (body count = `wc -l`); only skills strip frontmatter. Calibrated example updated to cite ADR-017's exact 152-line measurement instead of the "~150" approximation.

### Consumer-doctrine bump

`skills/**` + `guides/**` touched (consumer-doctrine, MUST bump per [ADR-019](docs/adr/ADR-019-doctrine-only-scope-refinement.md)); `tests/**` is contributor-doctrine (no bump required, but rides the consumer bump in the same PR). Patch grain v2.18.5 → v2.18.6 atomic across `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`, `README.md`, `SELF-CHECK.md`.

### Forward-Guardrail Sunset

Inherits v2.18.5's 2026-11-24 sunset on step 4a itself. If sunset triggers, revert sub-step 4a and Check 22 together.

---

## v2.18.5 — PRD Calibration Checkpoint (2026-05-24)

Adds a `4a. Calibrate numeric ceilings against precedent` sub-step to `skills/requirements/SKILL.md` Process. Closes [#237](https://github.com/pitimon/8-habit-ai-dev/issues/237) — action item from lesson `~/.claude/lessons/2026-05-24-v218-4-skill-authoring-double-rescue.md` §5 catching FR-007 (ADR-020) PRD-vs-reality drift before merge in v2.18.4.

### What ships

- **`skills/requirements/SKILL.md`** — new sub-step 4a (7 lines added) with the 4-step calibration sequence: (1) identify closest precedent by artifact type; (2) measure body excluding YAML frontmatter via `awk '/^---$/{c++; next} c>=2' <file> | wc -l`; (3) set the ceiling at `precedent_max × 1.20`, citing the FR-007 case study; (4) opt-out with a one-line FR comment when no precedent exists or the cap is set by a different constraint (hook token budget, validator string limit).
- **`guides/templates/prd-template.md`** — adds a calibrated-ceiling FR example to the Success Criteria section showing `≤180 lines (+20% from ADR-017 ~150)` versus the uncalibrated `≤50 lines` form that triggered the FR-007 amendment.

### Why this matters

The v2.18.4 ship caught FR-007 (`docs/adr/ADR-020-skill-authoring-guide.md` ceiling) at ≤50 lines body in the persisted PRD when the ADR-017 precedent template (Context, Tier Framework, Options Considered, Honest Framing, Sunset, T2 Bag, OOS, Constraints, Consequences) lands at ~150 lines and ADR-020 itself shipped at ~120 lines. The PRD persisted to `docs/specs/skill-authoring-guide-235/prd.md` would have contaminated future `/consistency-check` runs as a permanent false-drift signal until amended. The `8-habit-reviewer` pre-PR pass caught the drift reactively; this checkpoint moves the catch upstream into the authoring step itself (H1 Be Proactive · H5 Seek First to Understand · H7 Sharpen the Saw).

### Out of scope (per issue #237)

- No automated enforcement (no validator extension, no PreToolUse hook) — runtime enforcement belongs in `pitimon/claude-governance` per plugin boundary (memory obs #233270).
- No retroactive PRD audit — existing PRDs in `docs/specs/` not in scope; only changes the authoring discipline going forward.
- Not extended to non-numeric FR fields — the friction case is specifically numeric ceilings on markdown artifacts.

### Validator state

`tests/validate-structure.sh` green (Check 25 description ≤1024 chars + trigger phrase preserved; Check 26 imperative-with-reason hygiene satisfied via `because` marker; Check 27 consumer-doctrine bump enforced on `skills/` + `guides/` edits; Check 9 word budget — `requirements/SKILL.md` body ~1.0K words, well within 200-2000 range).

### Consumer-doctrine bump

`skills/**` + `guides/**` edits per [ADR-019](docs/adr/ADR-019-doctrine-only-scope-refinement.md). Patch bump v2.18.4 → v2.18.5 atomic across `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`, `README.md` badge + footer, `SELF-CHECK.md` header. Backwards-compatible (additive sub-step, no changed default behavior).

### Forward-Guardrail Sunset 2026-11-24

Per ADR-017 mechanism. Reversal criteria: no `/reflect` lesson cites the checkpoint; no calibrated FR in subsequent persisted PRDs; the FR-007 case remains the only friction signal. If sunset triggers, revert sub-step 4a; the case study + template example remain as authoring lore.

---

## v2.18.4 — Skill Authoring Guide (2026-05-24)

Adds `guides/skill-authoring.md` as a Tier 1 forward guardrail closing two gaps surfaced by a 2026-05-24 audit of Vibe Coding Thailand's _"คู่มือสร้าง Claude Skills ให้เก่งกว่าคนทั่วไป"_ article (a summary of Ben AI's YouTube framework):

- **N1 — Pre-Building Preparation absent.** 23 skills exist; the only authoring artifact was `CONTRIBUTING.md §"Adding a New Skill"` (a structural template, not a methodology). The reference-doc-first habit Ben AI promotes had no home in the project.
- **P2 — Objective conflated with trigger.** Existing skills treat the `description` frontmatter (a trigger phrase enforced by Check 25) and the `**Habit**: H?` annotation (a label) as substitutes for a dedicated Objective.

### Cross-verify reconciliation

The source brief (`~/.claude/plans/https-vibecodingthailand-com-blog-claude-vivid-wave.md`) first draft recommended "ship nothing" on friction-first grounds. The `8-habit-ai-dev:8-habit-reviewer` cross-verify scored that draft **12/17** and identified the same selective-strictness shape that rescued the [ADR-017](docs/adr/ADR-017-anthropic-skill-patterns-audit.md) draft four days earlier (lesson `~/.claude/lessons/2026-05-24-anthropic-5-pattern-audit-adr-017.md:25-26,33`). [ADR-014](docs/adr/ADR-014-external-prior-art-audit.md) (4 patterns) and ADR-017 (P3) both shipped forward guardrails with zero documented friction signal; refusing this one on the same evidence bar would apply a stricter standard than the project's two most recent ADRs. The revised verdict applies the precedent consistently.

This is the **second consecutive 2026-05-24 rescue** from "ship nothing" by 8-habit-reviewer cross-verify, both driven by inconsistent application of ADR-014 precedent.

### What ships

- **`guides/skill-authoring.md`** — ~300 lines covering: (a) Pre-Building Preparation pattern with concrete reference-doc workflow; (b) canonical SKILL.md skeleton including a dedicated `## Objective` section explicitly distinguished from the Check 25 trigger-rubric `description` and the `**Habit**: H?` label; (c) authoring lifecycle wiring `/research` → reference docs → SKILL.md → `/reflect` → SKILL-EFFECTIVENESS feedback loop per [ADR-018](docs/adr/ADR-018-memory-layer-activation.md); (d) cross-references to ADR-009/014/017/018/019 + `guides/advisor-pattern.md` + `guides/anthropic-engineering-doctrine-audit.md` + `guides/ears-notation.md` + `guides/persistence-convention.md` + `CONTRIBUTING.md §"Adding a New Skill"`.
- **`CONTRIBUTING.md` template diff** — inserts `## Objective` section to the skill skeleton (after `**Habit**:` line, before `## Process`) + adds pointer to the new guide at the section head.
- **`docs/adr/ADR-020-skill-authoring-guide.md`** — Tier 1 forward-guardrail ship per ADR-014/017 precedent; T2 deferrals (N2 multi-option HITL ≥5; N4b per-skill `examples.md` extension) with drop date 2026-11-24; T3 rejections (N3 iteration-cycle framing — low-value; N4a self-modifying skills — same charter conflict ADR-017 used for Anthropic Pattern 4). Forward-Guardrail Sunset 2026-11-24 per ADR-017 mechanism (**not** [ADR-016](docs/adr/ADR-016-t2-bag-drop-date-eviction-policy.md) eviction, which scopes only to never-shipped T2 items).
- **`SKILL-EFFECTIVENESS.md`** — v2.18.4 release-pulse note per [ADR-018](docs/adr/ADR-018-memory-layer-activation.md) anti-dormancy forcing function. No false-claim tally bump; release-pulse honors the discipline.
- **`docs/specs/skill-authoring-guide-235/prd.md`** — persisted PRD with 12 FR-NNN EARS criteria for `/consistency-check` future use.
- **README badge URL drift fix** — pre-existing inconsistency (badge text `2.18.3` while URL pointed to `releases/tag/v2.18.2`) corrected to `v2.18.4` → `v2.18.4` as part of this bump.

### Why bump for v2.18.4

`guides/**` is **consumer-doctrine** per [ADR-019](docs/adr/ADR-019-doctrine-only-scope-refinement.md) line 99 — referenced by skills via `Load` directives. Adding a new guide file is consumer-facing per Check 27, so version bump + CHANGELOG are mandatory, not elective. Patch grain (v2.18.3 → v2.18.4) matches: documentation-only addition, no skill behavior change, backwards-compatible.

### Reversal criteria

If by **2026-11-24** none of the following has occurred, consider reversion via separate amendment ADR:

- ≥1 `/reflect` lesson cites the guide as having helped during skill authoring
- ≥1 contributor PR references the guide
- A new skill lands with reference docs drafted before SKILL.md (the pattern operationalized)

PR closes [#235](https://github.com/pitimon/8-habit-ai-dev/issues/235).

---

## v2.18.3 — Anthropic Engineering Doctrine Audit Guide (2026-05-24)

Adds `guides/anthropic-engineering-doctrine-audit.md` as a **defensive citation surface** for the [ADR-018](docs/adr/ADR-018-memory-layer-activation.md) "Earn each line" doctrine. Closes a documented gap: without a catalogue of which Anthropic / Karpathy / Claude Code engineering blog patterns are already adopted vs evaluated-and-deferred, future contributors reading those posts re-propose patterns as new — wasting cycles and risking selective re-adoption under social pressure.

### What ships

- **`guides/anthropic-engineering-doctrine-audit.md`** — Table 1 (12 already-adopted patterns with file/ADR citations) + Table 2 (7 evaluated patterns: N1-N5 from original brief + N6 reclassified to T2 after cross-verify + N7 the guide itself marked T1 Adopted). Maintenance rule, habit mapping (H4 + H5 + H8), self-check.
- **Cross-references**: [ADR-017](docs/adr/ADR-017-anthropic-skill-patterns-audit.md) (narrower `github.com/anthropics/skills` 5-pattern audit) + [ADR-015](docs/adr/ADR-015-diagnose-skill-adoption-and-n1-framing.md) (friction-first doctrine the guide applies) + [ADR-016](docs/adr/ADR-016-t2-bag-drop-date-eviction-policy.md) (T2 drop-date eviction) + [ADR-018](docs/adr/ADR-018-memory-layer-activation.md) (Earn each line — the gap closed) + [ADR-019](docs/adr/ADR-019-doctrine-only-scope-refinement.md) (consumer-doctrine classification this PR honors).

### Why bump for v2.18.3

`guides/**` is **consumer-doctrine** per [ADR-019](docs/adr/ADR-019-doctrine-only-scope-refinement.md) line 99 — referenced by skills via `Load` directives, even when the file itself is reference content. Adding a new guide file is consumer-facing per Check 27, so version bump + CHANGELOG are mandatory, not elective. Patch grain (v2.18.2 → v2.18.3) matches: documentation-only addition, no skill behavior change, backwards-compatible.

### Honest framing — N6 reclassification recorded in the guide

The `/research` Deep+Audit brief (`~/.claude/plans/https-vibecodingthailand-com-blog-anthro-tranquil-rocket.md`) originally proposed N6 (skill description routing audit) as T1 with "weak n=1" evidence — `skills/RESOLVER.md` exists. `@8-habit-reviewer` cross-verify (2026-05-24) flagged this as **cherry-picking**: the 2026-04-22 lesson records `RESOLVER.md` as a proactive discoverability feature (issue #135), not a friction patch. By [ADR-015](docs/adr/ADR-015-diagnose-skill-adoption-and-n1-framing.md)'s standard ("unusually strong... first-person retrospective admission"), the evidence is n=0, not n=1. N6 sits at T2 in the guide with explicit rationale documenting the reclassification — the H8 modeling deposit: we apply friction-first to ourselves the same way we apply it to incoming proposals.

### Cross-verify trail

Reviewer scored 11/17 pass, 1 CRITICAL (N6 cherry-picking) + 2 HIGH (Step 1+2 redundancy + meta anti-pattern) + 3 MEDIUM (commit type, DoD measurability, Option D vs doctrine). All addressed by scope reduction from 3 PRs to 1 PR + N6 reclassification. Original execution plan included CLAUDE.md "Proposed" entries (Step 1) and `/audit-skill-descriptions` skill design (Step 3) — both dropped per reviewer findings.

PR closes issue [#231](https://github.com/pitimon/8-habit-ai-dev/issues/231).

---

## v2.18.2 — ADR-019 Doctrine-Only Scope Refinement + Check 27 (2026-05-24)

Refines [ADR-017 §C5](docs/adr/ADR-017-anthropic-skill-patterns-audit.md) doctrine-only rule. The implicit assumption "doctrine ⇒ contributor-only" was about to break at the next PR — [ADR-018 §"Context"](docs/adr/ADR-018-memory-layer-activation.md) explicitly names `rules/effective-development.md` (~200 lines, auto-loaded into every consumer session) as the next "Earn each line" audit target. Under the original §C5, that audit would have shipped as "doctrine-only" → no bump, no CHANGELOG → silent user-facing behavioral shift.

### What ships

- **[ADR-019](docs/adr/ADR-019-doctrine-only-scope-refinement.md)** — splits doctrine-only into:
  - **Contributor-doctrine** (no bump): `CLAUDE.md`, `CONTRIBUTING.md`, `docs/adr/**`, `docs/out-of-scope/**`, `docs/wiki/**`, `.github/**`, `SELF-CHECK.md`, `AGENTS.md`, `llms.txt`, `tests/**`. Preserves ADR-017 §C5 intent.
  - **Consumer-doctrine** (MUST bump + CHANGELOG, even if "doctrine refinement" in spirit): `rules/**`, `skills/**`, `hooks/**`, `habits/**`, `guides/**`, `agents/**`. Closes the gap.
- **`tests/validate-structure.sh` Check 27** — compares diff against last release tag; if any consumer-doctrine path changed AND version-4-files unchanged → FAIL with ADR-019 citation. Skipped if no tag exists (first-release case). 358 PASS / 0 FAIL.
- **ADR-017 §C5 cross-reference note** — refined, not replaced. Original §C5 text preserved; pointer to ADR-019 added.

### Why bump for v2.18.2

This PR touches only contributor-doctrine paths (`docs/adr/`, `tests/`, `CHANGELOG.md`, version-4-files). Under ADR-019's own classification, no bump is required. **The bump is elective** — introducing a new validator check is a meta-change to CI behavior that contributors should be signalled. Patch grain (v2.18.1 → v2.18.2) matches: doctrine refinement + internal CI enhancement, no skill/runtime change, backwards-compatible.

### Forward-Guardrail Sunset

Per ADR-017 convention, ADR-019 reviewed **2026-11-24**. Reversal criteria: check fires 0 times in 6 months (too conservative), check bypassed without amending the ADR (too rigid), or no consumer-doctrine PR shipped at all (speculation). Non-reversal: ≥1 consumer-doctrine audit shipped with check-driven bump (proves the rule does real work).

### Plugin boundary

Stays in `8-habit-ai-dev` — internal CI / workflow discipline. No runtime hook, no enforcement gate, no claude-governance involvement.

---

## v2.18.1 — Anthropic Skills 5-Pattern Audit: Tier 1 P3 Ship + Check 26 (2026-05-24)

User-prompted Deep+Audit `/research` evaluated 23 skills against [github.com/anthropics/skills](https://github.com/anthropics/skills) (`skills/{pdf,pptx,docx}`) 5 SKILL.md patterns. Decision recorded in [ADR-017](docs/adr/ADR-017-anthropic-skill-patterns-audit.md): Pattern 1 + 2 already shipped (ADR-014 Check 25 + ADR-009); Pattern 3 promoted to Tier 1 as forward guardrail consistent with ADR-014 precedent; Pattern 4 out-of-scope per plugin charter; Pattern 5 split T2 + cross-plugin.

### What ships

- **`tests/validate-structure.sh` Check 26** (warning-only) — flags skills with ≥4 soft-language verbs (`should`/`consider`/`may`/`might`/`could`) and 0 reason markers (`MUST`/`NEVER`/`ALWAYS`/`Why:`/`Rationale:`/`because`). Currently flags `/post-mortem` + `/reflect` informationally (discretion-heavy register; non-blocking). Validator: 357 PASS / 0 FAIL.
- **`/scrutinize` Operating Rules** — 6 MUST/NEVER + Why blocks replacing soft phrasings (e.g., "**NEVER rubber-stamp.** Why: rubber-stamps appear identical to genuine reviews — the reader cannot tell which one happened").
- **`/diagnose` Phase 6** — hardened with MUST re-run Phase 1 feedback loop, citing Anthropic pptx ~line 243 ("Do not declare success until you've completed at least one fix-and-verify cycle"). New Definition of Done checkbox.
- **`docs/out-of-scope/anthropic-pattern-4-scripts.md`** — Pattern 4 (embedded scripts) rejection rationale preserved per ADR-014 P4-lite OOS catalog. Charter conflict: skills are read-only guidance, not tooling.
- **`docs/adr/ADR-017-anthropic-skill-patterns-audit.md`** — full decision record with 3 options considered (A documentation-only, B chosen, C P3+P5 full scope rejected).

### Honest framing

8-habit-reviewer cross-verify pushed back on the original "documentation-only" recommendation: ADR-014 itself shipped 4 patterns 4 days earlier with the same zero-friction score as forward guardrails. Holding Anthropic patterns to a stricter standard would be selective strictness. Reconciliation paragraph in the research brief documents the resolution. All Tier 1 shipments inherit ADR-016 drop date 2026-11-23 — if no friction signal accumulates, Check 26 + skill edits drop per the cost-of-correction asymmetry gate.

### Citation precision

Triggering Thai-language blog cited Anthropic skills under `document-skills/` URL prefix (real path: `skills/`) and 4/7 pptx line numbers off by 40-61 lines (likely older commit). Quoted text is verbatim correct; URL/line precision is not. Recorded for future readers.

### Cross-plugin H6 deposit

Pattern 5 runtime enforcement (PostToolUse hook) belongs in `claude-governance` per plugin boundary. Companion issue: [pitimon/claude-governance#37](https://github.com/pitimon/claude-governance/issues/37). Tracks the cross-plugin half; this release ships only the language-nudge half (and only `/scrutinize` + `/diagnose` — extension to `/security-check` deferred to T2 bag pending n=1 friction).

PR [#219](https://github.com/pitimon/8-habit-ai-dev/pull/219) merged as `8540f9e`. Issue [#218](https://github.com/pitimon/8-habit-ai-dev/issues/218) closed with H4 deposit summary.

---

## v2.18.0 — `/diagnose` Skill: Friction-Driven External Adoption (2026-05-23)

Ships a single new skill — `/diagnose` — as a **friction-driven** external prior-art adoption from [mattpocock/skills](https://github.com/mattpocock/skills) SHA [`b8be62ff`](https://github.com/mattpocock/skills/tree/b8be62ffacb0118fa3eaa29a0923c87c8c11985c). Honest framing recorded in [ADR-015](docs/adr/ADR-015-diagnose-skill-adoption-and-n1-framing.md): the friction signal is **n=1, below ADR-014's preferred n≥2 bar**, but unusually strong — a first-person retrospective in `~/.claude/lessons/2026-04-12-compression-worker-420-investigation.md` explicitly states _"Most useful: n/a (no 8-habit skills invoked during the fix session)"_ and _"Could have been found in 5 minutes [via SQL comparison] vs 30 minutes of log analysis"_.

### New skill — `/diagnose` (H1 + H5)

6-phase active bug investigation methodology — closes the documented gap between `/research` (too broad — investigates solution space) and `/post-mortem` (too late — assumes fix landed).

- **Phase 1 — Build feedback loop**: fast (<10s ideal, <60s max), deterministic pass/fail signal. The critical phase; if a loop cannot be built, skill surfaces blocker and recommends bisect/ablation/telemetry alternatives instead of proceeding to hypothesis generation.
- **Phase 2 — Reproduce**: confirm ≥80% repro rate; flaky bugs return to Phase 1 for loop stabilization.
- **Phase 3 — Hypothesise**: 3–5 ranked falsifiable hypotheses with verbatim template _"If X causes it, then changing Y will make the bug disappear"_ — quoted verbatim from mattpocock source for methodology fidelity.
- **Phase 4 — Instrument**: one variable per probe, uniquely-tagged debug output (`[DIAG-A]`, `[DIAG-B]`...) for mechanical Phase 6 cleanup; debuggers preferred over logs.
- **Phase 5 — Fix + regression test**: regression test written BEFORE the fix, at the correct architectural seam (not the symptom site).
- **Phase 6 — Cleanup + handoff**: grep-clean unique probe tags; restore ablation subsystems; hand off to `/post-mortem` for the durable engineering record.

`prev-skill: any, next-skill: post-mortem`. Bash tool included with read-only scope guardrail (Phase 1 feedback-loop construction: `bun test`, `pytest -x`, `curl`, `playwright test`). Skip rule for single-line typos, stack-trace-obvious bugs, lint/format errors, and rename refactors documented in SKILL.md.

### Adapt-with-attribution strategy ([design.md Decision-5](docs/specs/diagnose-skill-v2-18-0/design.md))

- `skills/diagnose/SKILL.md` (1202 words, well under F3 ≤2000 limit) — 6 phases in 8-habit voice with explicit H1+H5 habit map + checkpoint + skip rule + handoff
- `skills/diagnose/reference.md` — full mattpocock prior-art notes with SHA-pinned source URL, per-phase concrete examples (web app / Node test / Python fixture / Playwright snippets), 3 false-positive patterns from the compression-worker-420 lesson, MIT license attribution

### Honest framing forward — friction-first audit precedent

[ADR-015](docs/adr/ADR-015-diagnose-skill-adoption-and-n1-framing.md) sets a precedent for **friction-first** external prior-art adoption (vs ADR-014's pattern-first inheritance):

- Future external-pattern proposals must cite an explicit n≥1 friction signal in this codebase
- Pattern attractiveness alone is insufficient justification
- ADR-015 enumerates 4 future-reversal conditions: zero recorded uses at 6 months → consider deprecation; n≥2 friction → validates retroactively; user confusion vs `/post-mortem` → revise boundary; upstream SHA churn → re-audit

### Spec chain & research brief

- **Spec chain (persisted)**: `docs/specs/diagnose-skill-v2-18-0/{prd,design,tasks}.md` — PRD has 14 EARS criteria (FR-001..014), design has 5 decisions (3 sticky), tasks lists 8 atomic items with full FR-coverage matrix
- **Research brief (source)**: `~/.claude/plans/deep-mattpocock-skills-second-pass-2026-05-23.md` — Deep-mode `/research`, 12/14 sources verified by `research-verifier` agent, all source URLs SHA-pinned for citation-rot resistance
- **Cross-verify (research)**: 8/11 applicable = 72.7% raw, 90.9% after Body fixes (SHA pinned + brief persisted + lesson capture deferred to post-merge `/reflect`)
- **Cross-verify (PRD)**: 13/13 applicable = 100%, all 4 dimensions at 100%, Body rebounded from 25% (research) to 100%
- **Consistency-check** (PRD ↔ design ↔ tasks): 0 CRITICAL/HIGH/MEDIUM findings, 1 LOW (Decision-5 marker format — fixed before T1)

Plugin total: **23 skills**. H1 (Be Proactive) + H5 (Seek First to Understand).

---

## v2.17.0 — External Prior-Art Audit: 4 mattpocock/skills Patterns as Forward Guardrails (2026-05-20)

A 2026-05-20 Deep-mode audit of [mattpocock/skills](https://github.com/mattpocock/skills) (95.5k★, MIT, 14 published skills) evaluated 10 candidate patterns and shipped 4 as additive guardrails. Honest framing recorded in [ADR-014](docs/adr/ADR-014-external-prior-art-audit.md): all 4 adoptions ship **without prior friction-signal evidence** — they are forward guardrails, not fixes for observed weakness. Future external-pattern audits must apply a friction-first lens per ADR-014's discipline.

### Added

- **`guides/templates/agent-brief-template.md`** (P1) — habit-mapped AGENT-BRIEF template (≤120 lines) for backlog-bound issues. Adds H2 "Success criteria" + H8 "Why this matters" sections; preserves mattpocock's behavioral-not-procedural durability rule. Referenced from `/breakdown` Handoff.
- **`docs/out-of-scope/`** (P4-lite) — new directory with 3 seed entries (brainstorm-removed.md, agentskills-no-go.md, eu-ai-act-migrated.md). Per-decision rejection rationale with YAML frontmatter schema (`date`, `originating-decision`, `rejected-because`). Each ≤200 words with "If reconsidering, read these conditions first" durability anchor.
- **`docs/adr/ADR-014-external-prior-art-audit.md`** — records the audit framework (Tier 1/2/3), 4 adoptions, 3 rejections (P6/P7/P9), 3 deferrals (P2/P8/P10), R1 harness behavior verification, and the honest-framing discipline.
- **`docs/specs/mattpocock-t1-v2-17-0/`** — persisted spec chain (`prd.md`, `design.md`, `tasks.md`) for the bundle.
- **`tests/validate-structure.sh` Check 24** — validates `disable-model-invocation` is a well-formed YAML boolean when declared (FR-002). Field is OPTIONAL.
- **`tests/validate-structure.sh` Check 25** — SKILL.md description rubric: ≤1024 chars + trigger phrase from empirically-grounded set (Use when / Use AFTER / Use BEFORE / Use to / Use for / Use as / Read this first / Assess / migrated). Pre-shipment audit found 0/19 drift (FR-003).
- **`CONTRIBUTING.md` "Adding an Out-of-Scope Entry"** — explains ADR-vs-OOS verb distinction and OOS frontmatter schema. R3 mitigation per ADR-014.

### Changed

- **`skills/save-spec/SKILL.md` frontmatter** (P3, FR-001a) — added `disable-model-invocation: true`. **Honest disclosure**: per [anthropics/claude-code#22345](https://github.com/anthropics/claude-code/issues/22345) (OPEN since 2026-02-01), plugin skills don't currently honor this field — declaration is intent-marking until #22345 closes. Two related regressions (#26251, #43875) verified CLOSED before shipping.
- **`skills/ai-dev-log/SKILL.md` frontmatter** (P3, FR-001b) — same flag added; same harness-honor caveat applies.
- **`skills/breakdown/SKILL.md` Handoff section** (FR-006 narrowed) — added always-link reference to `agent-brief-template.md` for backlog-bound tasks. PRD's event-driven framing narrowed to ubiquitous during /design (Decision-4); narrowing documented in design.md.

### Rejected (Tier 3 — documented in docs/out-of-scope/ or ADR-014)

- **P6 inline doc updates during skill** — conflicts with read-only skill principle (ADR-009).
- **P7 CONTEXT.md / CONTEXT-MAP.md** — overlaps `/save-spec` §1 + `spec-digest-pattern.md`; risks governance drift (ADR-013).
- **P9 lazy file creation** — redundant with `/save-spec` refusal-to-overwrite behavior.

### Deferred (Tier 2)

- **P2 LANGUAGE.md vocabulary** — worth doing eventually; separate research brief if maintainer chooses.
- **P8 two-axis review split** — needs n≥2 adopter friction signal per maturity ladder before promotion.
- **P10 tracer-bullet vocabulary** — `/breakdown` already says "atomic"; marginal value.

### Why

External-source audit as Sharpen-the-Saw (H7) discipline. The advisor pattern review (transcript 2026-05-20) flagged that the original framing was "what novel patterns does mattpocock have?" rather than "what friction do we have?" — ADR-014 records this lesson explicitly and the v2.17.0 release ships forward guardrails with honest disclosure rather than retrofit a friction-first audit.

### Verification

- All 4 validator suites green: `validate-structure.sh` (293 PASS / 0 FAIL), `validate-content.sh`, `test-skill-graph.sh`, `test-verbosity-hook.sh`
- R1 harness verification done before shipping (issue status checked)
- 13/14 citations in source brief verified by `research-verifier` agent (Deep-mode gate)
- Cross-verify dogfooded on the bundle at /requirements stage: 92.8% Well-prepared band

---

## v2.16.5 — Companion Announcement: devsecops `/workflow` → `/security-workflow` (2026-05-20)

Docs-only patch. Closes the paired-announcement promise from `devsecops-ai-team` v10.12.0's CHANGELOG: the cross-plugin `/workflow` naming collision has been resolved by devsecops renaming its skill to `/security-workflow`. This release updates the integration peg, surfaces the rename in this plugin's `/workflow` SKILL.md, and refreshes the README companion-plugin table.

### Changed

- **`docs/INTEGRATION.md` "Tested versions"** — devsecops-ai-team peg bumped 10.10.0 → 10.12.0+ (stale by 2 releases — v10.11.0 `/runner-audit`, v10.11.1 QA patch, v10.12.0 `/workflow` rename, v10.12.1 cross-refs). Inline note explains: in devsecops v10.12.0, `/workflow` was renamed to `/security-workflow` to resolve the collision with this plugin's `/workflow` (the 7-step Covey practice). Legacy `/workflow` in devsecops continues as a deprecation stub through v10.x; removed in v11.0.0 per devsecops ADR-014.
- **`skills/workflow/SKILL.md` "See also" footer (new)** — When user invokes `/workflow` and meant "scan-orchestration workflow" instead of the 7-step development workflow, they're now pointed to devsecops's `/security-workflow` directly from the SKILL.md (not buried in INTEGRATION.md). Reduces user-mental-model mismatch.
- **`README.md` Companion Plugins section** — devsecops-ai-team tested-version peg bumped 10.10.0 → 10.12.0+; added one-line note on the `/security-workflow` rename for users searching by old name.

### Why

`devsecops-ai-team` v10.12.0 (2026-05-20) shipped with a CHANGELOG line: _"A paired note will be published in 8-habit-ai-dev's next release explaining that the cross-plugin conflict is now resolved."_ This release fulfills that commitment. H4 (Win-Win) reciprocity — every interaction is a deposit; closing this promise is a deposit to users who track both plugins.

### Companion release

- **`devsecops-ai-team` v10.12.1** (paired with this release) — adds devsecops's symmetric "Companion Plugins" README section (mentions 8-habit-ai-dev + claude-governance) plus skill-level "See also" callouts in `/eu-ai-act-assess` (points to claude-governance `/eu-ai-act-check` for Article 14) and `/security-workflow` (points back to this plugin's `/workflow`).

### Pattern captured

Companion-announcement step is now part of the Definition of Done for any cross-plugin slash-command rename — not a follow-up task. See post-release `/reflect` lesson `cross-plugin-companion-announcement-pattern` in `~/.claude/lessons/`.

---

## v2.16.4 — `/save-spec` Suite-Positioning Honesty Patch (Adopter #2 third-repo dogfood) (2026-05-18)

Docs-only patch. Adopter #2's third-repo dogfood (operational VA/PT workspace with `claude-mem` active + 284-line `CLAUDE.md`) surfaced two real overlap cases the `/save-spec` docs didn't acknowledge. P1 + P2 ship; P3 explicitly deferred per adopter recommendation. Closes [#207](https://github.com/pitimon/8-habit-ai-dev/issues/207).

### Changed

- **P1 (docs only) — `skills/save-spec/SKILL.md` "When to Skip"**: Added entry acknowledging that **memory-MCP active (`claude-mem`/`memforge`) + short `CLAUDE.md` (<150 lines / scannable in <30s)** combination already solves the post-`/clear` save-point problem `/save-spec` was designed for. In that combination, §4 (Current state) is the only section providing net value over what the adopter already has; writing a short `## Current state` section directly into `CLAUDE.md` is the lower-friction path. The skill's own H8 Checkpoint already admits "the value depends on the user's habit of updating it"; this entry extends that honesty to the upstream question of whether the scaffold is worth maintaining at all.
- **P2 (docs only) — Suite positioning clarification across 3 files**: `skills/save-spec/SKILL.md` gains a new "Suite positioning (not a workflow step)" section explicitly framing the skill as a **deployment-mode helper orthogonal to the 7-step workflow** (`prev-skill: any` / `next-skill: any`), alongside `/calibrate` (writes `~/.claude/habit-profile.md`) + `/reflect` (writes `~/.claude/lessons/`) as **state-write skills run on user demand** — NOT alongside assessment skills like `/cross-verify` or `/whole-person-check` that produce conversation-only output. `README.md` skill-table row + `skills/using-8-habits/reference.md` row both reclassified to lead with this framing. `skills/RESOLVER.md` triggers verified unchanged (user-invocation intent unchanged; only skip-criteria changed).

### Deferred

- **P3 (feature — explicitly deferred)** — adopter proposed a `--skip-empty-sections` flag for the operational-repo case where §2/§3 stay empty post-scaffold. Adopter explicitly recommended NOT shipping this now ("fix the docs first, see if anyone actually requests this"). Defer per adopter recommendation.

### Pattern

**H8 Conscience applied to marketing copy.** The skill's own H8 Checkpoint admitted "the value depends on the user's habit of updating it." The adopter's report extended that honesty to "When to Skip" — over-promising in marketing is the same anti-pattern the H8 checkpoint guards against in operations. Docs that overstate value in the "Use it when" direction need to balance with the "Skip it when" direction.

### Arc-close criterion validation

v2.16.3 said: "Round 6 deferred unless a third independent adopter (outside `netbox-sit` + `netbird-sit`) surfaces real friction." That condition triggered **within ~2 hours** of the v2.16.3 release — Adopter #2 immediately ran the new release in their operational VA/PT workspace (third repo) and filed #207. The arc-close criterion was correct; the timing estimate was over-optimistic. Pattern continues at **n=3 evidence base**.

### Validator state

`validate-structure.sh` 268/268 PASS; `validate-content.sh` 220+ PASS / 0 FAIL / 1 WARN / 0 fitness breaches.

### Convergence

Adopter's own `/cross-verify` on this issue: 13/15 = 86.7% "Mostly ready". Maintainer's `/cross-verify` on the implementation posture (ship P1+P2, defer P3): 15/15 = 100% "Well-prepared". Adopter modest; maintainer agrees. Proceed with confidence.

---

## v2.16.3 — `/save-spec` Round-5 Arc-Close Polish (Adopter #2 closure pass) (2026-05-18)

Patch release. Adopter #2 closure pass on the 5-round v2.16.x QA arc surfaced 1 MEDIUM bug + 2 LOW items + an arc-close meta-recommendation. All 3 fixed; arc closed per Adopter #2 recommendation (defer round 6 unless a third independent adopter surfaces friction). Closes [#205](https://github.com/pitimon/8-habit-ai-dev/issues/205).

### Fixed

- **R5-3 (MEDIUM bug)** — Scaffolded `SPEC.md` §2 markdown table rendered broken on every empty-decisions scaffold. `reference.md:30` blank line separated the alignment row from the `<§2-rows>` substitution marker; GitHub / mdast-based renderers treated this as a degenerate header-only table + a stray-pipe paragraph. Initial fix attempted with standalone HTML-comment assembly directive, but the project formatter (Prettier-class) persistently re-wedged blank lines around both HTML-blocks AND `<...>` markers. Final fix uses a **table-row-shaped substitution marker** (`| §2-rows-ASSEMBLY-DIRECTIVE | ... | ... | ... |`) so the formatter sees it as a real data row and doesn't pad it. Generator replaces this row with actual rows at scaffold time. New `tests/validate-content.sh` Check 12c.1 added as a regression check with a formatter-padding-tolerant alignment-row regex.
- **R5-1 (LOW-MEDIUM doc)** — Template assembly markers at `reference.md` §1/§2/§3 substitution sites previously used `<§N-...>` angle-bracket syntax visually identical to F1-class pre-fix placeholders, risking future-contributor confusion ("didn't we fix these?"). Fixed by consolidating the assembly-directive intent INTO the marker text itself with an explicit `ASSEMBLY-DIRECTIVE` capitalized phrase + "NEVER appears in output — replaced by generator at scaffold time" language. §1/§3 use the angle-bracket form (formatter-tolerant in list contexts); §2 uses the table-row form (formatter-required in table contexts).
- **R5-2 (LOW doc)** — FR-017 (target-dir validation) error template previously reused the Decision-4 Write-failure template ("Tried to create SPEC.md at..."), giving an adopter who typos a target-dir path permission/disk troubleshooting wording instead of "directory not found" guidance. Added a new **Canonical pre-flight error template** section to `reference.md` with the adopter-correct register ("Directory not found: <target-dir>..."). FR-017 wired to point at the new template, NOT Decision-4. SKILL.md Process step 1 updated to emit the pre-flight error before any Glob/Write call.

### Validator state

`validate-structure.sh` 268/268 PASS; `validate-content.sh` 220+ PASS / 0 FAIL / 1 WARN / 0 fitness breaches.

### Pattern

**Formatter-vs-substitution-marker arms race resolved via table-row-shaped marker.** When a template marker must be adjacent to a markdown construct that the formatter treats as stable (like table data rows), make the marker itself look like that construct. The formatter then treats it as a peer of the surrounding structure, not as an HTML-block to pad. The standalone-HTML-comment approach assumed the formatter would respect the comment as a paragraph-class block; the formatter consistently treated it as something to pad. The marker had to assimilate to the surrounding structure to win.

**DoD-must-execute self-test caught zero bugs this round.** The action item from `~/.claude/lessons/2026-05-17-maturity-ladder-dogfood-arc-v2-16-1.md` was executed against synthesized v2.16.3 scaffold output — all 5 verification commands pass, F1 / R5-1 / R5-3 regression checks all pass. The previous round (v2.16.2) the self-test caught F3 (BSD-awk regression); this round it confirmed clean. The system is now systematically preventing what it previously discovered reactively — convergence is the expected pattern when the discipline holds.

### Sibling closure

5-round adopter-maintainer rhythm closed per Adopter #2 recommendation. Rounds 1–5: #197 (closed in v2.16.0), #201 (closed in v2.16.1), #203 (closed in v2.16.2), this issue #205 (closed in v2.16.3). Round 6 deferred unless a third independent adopter (outside `netbox-sit` + `claude-all/netbird-sit`) surfaces real friction.

---

## v2.16.2 — `/save-spec` Round-3 Polish + Guide Check 2 BSD-awk Fix (Adopter #3 dogfood) (2026-05-17)

Patch release. Adopter #3 dogfood pass on `/save-spec` (first round using **real skill execution** rather than docs review) surfaced 1 correctness bug + 1 friction enhancement; pre-PR self-test (per the same-day DoD-must-execute action item from `~/.claude/lessons/2026-05-17-maturity-ladder-dogfood-arc-v2-16-1.md`) surfaced 1 additional verification-command bug. All 3 fixed in this PR. Closes [#203](https://github.com/pitimon/8-habit-ai-dev/issues/203).

### Fixed

- **F1 (MEDIUM bug)** — Scaffolded `SPEC.md` shipped with 6 literal angle-bracket placeholder sites (`<One paragraph summarizing …>`, `<terse statement>`, `<Active backlog item …>`, `<terse note + timestamp>`, `<Specific task/sub-task active right now …>`, `<Optional: command sequence …>`) contradicting the read-first-context purpose of the pattern. Fixed via hybrid approach: §2/§3 skip-stub rows now use plain prose italic markers (`_no decisions seeded yet — add the first one when it lands_`); §1 narrative + §4 fill-required sites use `<!-- TODO: … -->` HTML comments (invisible at render, visible to editor). `tests/validate-content.sh` Check 12c whitelist extended to `skills/save-spec/` with Exception 2 comment.
- **F3 (MEDIUM, surfaced by pre-PR self-test, not by adopter)** — `guides/spec-digest-pattern.md` Check 2's `awk '/^## 4\. Current state/,/^## /'` range collapses to 1 line on BSD awk (macOS default) because the end-regex `^## ` matches the start line `## 4. Current state` too. All macOS adopters running the published verification command had a silently-failing Check 2. Replaced with `sed -n '/^## 4\. Current state/,/^## /p'` which has consistent cross-platform semantics. Backstory: this regression was introduced in v2.15.9 (#197 N1 fix migrated from `grep -A1` → `awk` to fix blank-line-after-heading); the awk fix had its own bug.

### Added

- **F2 (LOW-MEDIUM enhancement)** — `/save-spec [project-name] [target-dir]` now accepts an optional second positional argument for the target directory. Pre-flight check, Glob detection, Write, and summary all operate on `<target-dir>` when supplied (defaults to cwd otherwise). Multi-repo portfolio adopters no longer need a per-repo session switch. PRD FR-013 scope-clarified; new FR-017 added for target-dir semantics.

### Changed

- **W2 (doc softening)** — N2 timestamp section in `skills/save-spec/reference.md` updated with verified-working note. Adopter #3 fresh-session scaffold on `~/va+pentest` produced `2026-05-17T22:46:06+07:00` (correct Bangkok offset, NOT the `+00:00` fallback v2.16.1 warned about). The warning is now framed as "documented escape-hatch, not expected outcome in normal use."

### Positive verifications from Adopter #3 (no changes needed)

- **W1**: N3 free-text affordance (Q2 "Other") works end-to-end in real use
- **W2**: N2 timestamp produced correct local offset
- **W3**: Refusal-path safety guard works (verified via pre-existing SPEC.md test)

### Validator state

`validate-structure.sh` 268/268 PASS; `validate-content.sh` 219+ PASS / 0 FAIL / 1 WARN / 0 fitness breaches.

### Pattern

**DoD-must-execute principle empirically validated within 24h of being coined.** The v2.16.1 `/reflect` lesson (`~/.claude/lessons/2026-05-17-maturity-ladder-dogfood-arc-v2-16-1.md`) Q5 action item said: "literal execution of verification commands before any new-skill PR opens." On this v2.16.2 PR, that pre-PR self-test caught F3 — a BSD-awk regression that no static review (validators, 8-habit-reviewer, manual diff) would have surfaced. Same-day discovery, same-day fix, no waiting for external adopter to hit the bug on macOS shells. The action item caught its own first regression test. **Lesson loop closed in a single day.**

---

## v2.16.1 — `/save-spec` Phase 1 Polish (Adopter #2 dogfood) (2026-05-17)

Patch release. Adopter #2 dogfood pass on the v2.16.0 `/save-spec` skill surfaced 1 correctness bug + 3 quality items — all four fixed in this PR. Closes [#201](https://github.com/pitimon/8-habit-ai-dev/issues/201).

### Fixed

- **N1 (MEDIUM bug)** — `skills/save-spec/reference.md` §1 empty stub previously used `` `<filename>.md` `` which Check 4's backtick-path grep (`grep -oE '\`[^\`]+\.(md|sh|py|yaml|yml|json)\`'`) extracted as the literal string `<filename>.md`. The downstream `[ -e ]`check failed, emitting`MISS <filename>.md`and making the Definition of Done's claim that "output passes the 5 verification commands from`guides/spec-digest-pattern.md`" provably false on the default scaffold. The stub now reads `_§1 is empty — add project-specific pointers (one path per bullet) as the repo grows._`with no backticked`.md` path — Check 4 finds no candidate paths and exits cleanly. DoD claim is now true.
- **N4 (LOW doc drift)** — `docs/specs/save-spec/prd.md` FR-003 previously included an inline paraphrased version of the refusal message that diverged from the canonical version in `skills/save-spec/reference.md`. Future-maintainer drift hazard. FR-003 now references `reference.md` (Decision-3) as the single source of truth.

### Changed

- **N2 (LOW)** — `skills/save-spec/reference.md` Timestamp section now documents the reliability profile of the LLM-generated `**Last updated**` substitution. The skill's `allowed-tools` does not include `Bash`, so Process step 5 cannot invoke `date(1)`; the timestamp value is substituted by Claude from session-injected `<system-reminder>Current:</system-reminder>` context. When that injection is absent (custom runtime / non-interactive batch), output may carry `+00:00` or a wrong offset. Adopter guidance added: verify the offset after scaffold, edit manually if wrong. Phase 2 may add `Bash` if adopter feedback shows unreliability.
- **N3 (LOW UX)** — `skills/save-spec/SKILL.md` Process step 3 Q2 now accepts an "Other (free-text)" affordance for newline-separated project-specific paths. Motivated by ops/infra repos using non-canonical naming (`server-state.md`, `playbooks/change-management.md`, `runbooks/ops-runbook.md`) that have zero overlap with the 5 canonical glob names. Process step 4 parse rule extended to split-on-newlines, trim, dedup against multi-select picks, and append. `reference.md` Example F added.

### Validator state

`validate-structure.sh` 268/268 PASS; `validate-content.sh` 219+ PASS / 0 FAIL / 1 WARN / 0 fitness breaches.

### Pattern

**Patch-release dogfood discipline** — adopter #2 dogfood report (#201) surfaced N1 in under 2 hours after the v2.16.0 release. Correctness fix shipped same day. The dogfood feedback loop is faster than the original promotion-criteria gathering because the skill itself enables more rapid scaffold-and-test iterations. The Phase 2 commitment ladder remains visible — N2 timestamp reliability + N3 UX both have explicit Phase 2 hooks if feedback warrants escalation.

Sibling closure: [#197](https://github.com/pitimon/8-habit-ai-dev/issues/197) is now closeable — all 5 of its items were addressed in v2.16.0 + #198. The /save-spec Adopter #2 dogfood pass (this issue) is the natural continuation, scoped to the new skill rather than the original guide.

---

## v2.16.0 — `/save-spec` Skill — Phase 1 Minimum Viable (2026-05-17)

Minor version bump (new skill). Promotes the v2.15.9 spec-digest-pattern guide to a user-invocable skill after all three documented promotion criteria were met. Closes [#199](https://github.com/pitimon/8-habit-ai-dev/issues/199).

### Added

- **`skills/save-spec/SKILL.md`** (new, ~180 lines) — user-invoked Phase 1 minimum viable skill that scaffolds a project-root `SPEC.md` following the spec-digest-pattern archetype. Frontmatter: `allowed-tools: ["Read", "Write", "Glob", "AskUserQuestion"]`, `prev-skill: any`, `next-skill: any` (standalone). Generator-only — refuses to overwrite an existing `SPEC.md`. 8-step Process section is the runtime contract (Decision-7 sticky).
- **`skills/save-spec/reference.md`** (new, ~200 lines) — canonical artifacts: full SPEC.md output template, Decision-3 refusal message (verbatim), Decision-4 3-line error template (verbatim with substitution markers), Decision-2 skip-sentinels list (`skip`, `none`, `nothing`, `n/a`, empty), Decision-6 5-name glob set (case-sensitive exact match: `PLAYBOOK.md`, `CONTRACTS.md`, `LESSONS.md`, `CHANGELOG.md`, `README.md`), Decision-5 RFC 3339 strict timestamp format, 5 parse examples (skip / single item / max items / surplus truncation / mixed delimiters), rationale links to issue #199 open-question defaults.
- **`tests/validate-structure.sh` Check 23** — pins `/save-spec` canonical contract (8 assertions): frontmatter name + user-invocable + allowed-tools array + prev/next-skill, Process step count = 8, Decision-3 refusal phrase present in reference.md, Decision-4 error phrase present in reference.md, Decision-2 skip-sentinels documentation pin.
- **`skills/RESOLVER.md`** — 3 new trigger phrases for `/save-spec`: `"scaffold a SPEC.md"`, `"save-point file for this repo"`, `"set up a project digest"`.
- **README.md** — `/save-spec` row in Assessment Skills table; `What's New in v2.16.0` section.
- **docs/specs/save-spec/{prd,design,tasks}.md** — dogfooded PRD/design/tasks triad persisted via `--persist save-spec` during the design phase. Persisted artifacts ran through `/consistency-check save-spec` (0 CRITICAL, 0 HIGH, 4 LOW for missing alternatives markers in Decisions 7–10; LOW accepted as informational).

### Changed

- **`guides/spec-digest-pattern.md`** — "Promotion to a skill (deferred)" section rewritten to "Promoted to `/save-spec` in v2.16.0". Adds the explicit scope-resolution statement: the two deployment modes (feature-spec via `--persist <slug>` and project-orientation hub via root `SPEC.md`) are disjoint in practice; multi-mode repos are out of scope for tooling. Closes promotion criterion 2 in writing.
- **`docs/adr/ADR-013-spec-persistence-opt-in.md`** — appends a 2026-05-17 follow-up note inside the existing addendum, recording that `/save-spec` shipped within the existing ADR scope (user-invoked write stays outside Alt-4 auto-write-hook rejection). **No change to the original Decision section.**

### Pattern

**Promotion via maturity ladder, not aesthetic preference.** v2.15.9 documented the spec-digest pattern as a guide + explicit promotion criteria (n=2 adoption / scope resolved / friction lesson). v2.16.0 ships the skill **only after** the criteria were objectively met:

1. ✅ n=2 independent adoption: `netbox-sit` + `claude-all/netbird-sit` (via Adopter #2 report at #197)
2. ✅ Scope resolved in writing: the two-modes-are-disjoint paragraph in `guides/spec-digest-pattern.md`
3. ✅ Friction lesson captured: `~/.claude/lessons/2026-05-17-spec-digest-pattern-v2-15-9.md` + #197 verification command edge cases + doc-blocker hook collision

This is the canonical example of decision-driven, data-backed feature promotion in this plugin. The next escalation (Phase 2 `--update`) is similarly gated on Phase 1 adoption feedback.

### Validator state

`validate-structure.sh` 266/266 PASS (Check 23 adds 8 assertions to the v2.15.9 baseline of 256); `validate-content.sh` 217+ PASS / 0 FAIL / 1 WARN / 0 fitness breaches.

---

## v2.15.9 — Project-Orientation Hub Mode Documentation (2026-05-17)

Docs-only patch. Closes [#194](https://github.com/pitimon/8-habit-ai-dev/issues/194) via [PR #195](https://github.com/pitimon/8-habit-ai-dev/pull/195).

Documents a second spec-persistence deployment mode (project-orientation hub) as complement to v2.15.2's feature-spec mode. No new skill, no hook, no enforcement.

### Added

- **`guides/spec-digest-pattern.md`** (~180 lines) — template + when-to-use + CLAUDE.md auto-update rule snippet + "What this pattern is NOT" section + Decisions-table formatting guidance + deferred-skill promotion criteria + verification commands. Template paraphrased from production artifact `scanopy/netbox-sit/SPEC.md` (153 lines) that independently arrived at the four-section save-point shape after repeated `/clear` and `/compact` flushes.

### Changed

- **`docs/adr/ADR-013-spec-persistence-opt-in.md`** — appended 2026-05-17 addendum clarifying ADR-013's scope. Its rejections (Alt-1 unified prd+design+tasks merge, Alt-4 always-on auto-write hook, CHANGELOG v2.15.0 `/save-point` skill rejection) cover the feature-spec mode specifically; the project-orientation digest layer above existing detail files is a different archetype those alternatives did not evaluate. **No change to the original Decision section.**
- **`guides/persistence-convention.md`** — cross-link note in the "Current State File" section pointing to the new guide and clarifying the two modes are complementary.
- **`README.md`** — one new row in "Use Cases" table: "Survive `/clear` and `/compact`".

### Deferred

- `/save-spec <slug>` skill — explicitly deferred until ≥2 independent project adoptions, per working-with-pitimon "minimal additions, user-demand-driven" stance + PR #111 local-maximum lesson. Promotion criteria documented in the new guide.

### Pattern

**Empirical-evidence-driven discipline addition**. A real-world artifact from another session revealed a deployment mode the plugin did not document. The plan was revised twice (after `8-habit-reviewer` flagged write-vs-read scope, after advisor flagged n=1 commitment level) before settling on the guide-first path that matches the evidence strength. The deferred skill criterion ("watch for ≥2 independent adoptions") makes the next escalation decision data-driven rather than aesthetic.

### Validator state

`validate-structure.sh` 256/256 PASS; `validate-content.sh` 216 PASS / 0 FAIL / 1 WARN / 0 fitness breaches. Post-merge CI surfaced a Check 12b false-positive (link resolver not backtick-aware) — template rewritten to use backticked filenames instead of bracket-paren link syntax with a note for the copy-paster.

---

## v2.15.8 — `/reflect` Auto-Consolidation: One-Command Flow (2026-05-16)

UX patch. Removes the two-step `/reflect` → `/reflect consolidate` friction. Closes [#191](https://github.com/pitimon/8-habit-ai-dev/issues/191) via [PR #192](https://github.com/pitimon/8-habit-ai-dev/pull/192).

### Changed

- **`skills/reflect/SKILL.md` Step 7** — "Consolidation check (periodic)" → "Consolidation (automatic when count > 10)". When `count > 10`, the 4-phase cycle (Orient → Gather → Consolidate → Prune) now runs inline after every `/reflect`, instead of printing a nudge and waiting for a separate invocation.
  - **No merges found**: `~/.claude/lessons/INDEX.md` updated automatically (additive, non-destructive). Prints 1-line summary: `Consolidation: no merges. INDEX.md updated — [N] lessons, [K] new entries.`
  - **Deletions proposed**: cycle stops, presents full merge plan, gates on explicit user approval (In-the-Loop per ADR-002 — deletion is irreversible).
  - **Explicit `/reflect consolidate`** argument still works with verbose Consolidation Report output.
- **Definition of Done bullet 5** — "Consolidation check performed if lesson count > 10" → "Consolidation auto-ran when count > 10: INDEX.md updated (no merges) or merge plan surfaced for approval (deletions proposed)". Now testable with two concrete outcomes.

### Pattern

**PC² — invest in the capability that builds capability.** The reflection loop is the system that captures lessons; reducing friction in that loop is H7 applied to H7 itself. Root cause: threshold 10 that mature repos cross quickly, making the nudge fire every `/reflect`. Fix makes auto-run safe for the common case (additive INDEX update) while preserving the gate for the rare case (irreversible deletions).

### Validator State

- `tests/validate-structure.sh` — 256/256 PASS
- `tests/validate-content.sh` — 217 PASS / 0 FAIL / 1 WARN / 0 fitness breaches

---

## v2.15.7 — Vendor Portability Discipline for Managed Agent Platforms (2026-05-15)

Patch release. Doc-only addition responding to the industry move toward managed-agent runtime features (cross-session memory, self-evaluation against outcomes, built-in orchestration) from Claude Managed Agents, OpenAI Assistants, Bedrock Agents. Closes [#188](https://github.com/pitimon/8-habit-ai-dev/issues/188) via [PR #189](https://github.com/pitimon/8-habit-ai-dev/pull/189).

### Added

- **`guides/vendor-portability.md`** — vendor-neutral discipline guide (~90 lines) structured around three principles:
  1. Persist artifacts outside the vendor (repo = source of truth, managed memory = derived view)
  2. Treat managed memory as cache, not source of truth (regulators ask for traceable artifacts, not vendor summaries)
  3. Separate discipline (portable) from runtime (vendor-specific)
- **Selection checklist** framed as the `/cross-verify` Q14 "third alternative beyond the obvious options" exercise — artifact persistence, exit cost, data residency, reproducibility, audit trail, fallback path.
- **`llms.txt` indexing** under Philosophy section, alongside `integrity-principles.md`.

### Changed

- `README.md` — badge 2.15.6 → 2.15.7; new "What's New in v2.15.7" section; footer date 2026-05-15.
- `SELF-CHECK.md` — version header 2.15.6 → 2.15.7; new v2.15.7 honesty-notes row (Body 5, Mind 5, Heart 5, Spirit 5 = 5.0); footer previous-version pointer 2.15.5 → 2.15.6.

### Habit Mapping

- **H8 (Voice)** — architectural autonomy stays human-owned, Spirit dimension primary anchor
- **H1 (Proactive)** — prevent lock-in before migration pain, Body dimension
- **H4 (Win-Win, Emotional Bank Account)** — artifacts that inform the next person, Heart dimension (canonical framing per `habits/h4-win-win.md`, not a stretch to "audit-ready")
- **H7 (Sharpen the Saw)** — reproducibility = PC investment over P output, Mind dimension

Full Whole Person 4-dimension coverage (Body, Mind, Heart, Spirit).

### Integrity Note

8-habit-reviewer pre-commit dispatch caught a Commandment #13 violation: the initial draft mislabeled `/cross-verify` Q14 as "External dependencies" but the actual question text per `guides/cross-verification.md:45` is "Have I considered a third alternative beyond the obvious options?". The H4 mapping was also reframed from the stretch "audit-ready record" to the canonical "artifacts that inform the next person." Both fixes happened pre-commit, demonstrating the integrity discipline applies to its own writing.

### Pattern

**Discipline answer to a runtime trend.** When platforms add convenience features that create lock-in risk, the framework responds with discipline guidance, not by replicating the feature. Plugin boundary preserved — workflow discipline lives here; enforcement hooks and compliance framework mapping live in `pitimon/claude-governance`.

### Validator State

- `tests/validate-structure.sh` — 256/256 PASS
- `tests/validate-content.sh` — 217 PASS / 0 FAIL / 1 WARN / 0 fitness breaches

---

## v2.15.6 — SKILL_OUTPUT Producer + Consumer Doc Sync (2026-05-13)

Patch release. Doc-only fix closing a pair of same-shape drift gaps in `guides/structured-output-protocol.md`. Both stemmed from `/design`'s `SKILL_OUTPUT:design` block being added without doc sync. Closes [#153](https://github.com/pitimon/8-habit-ai-dev/issues/153) via [PR #186](https://github.com/pitimon/8-habit-ai-dev/pull/186).

### Added

- **`/design` producer entry** in `guides/structured-output-protocol.md` "Producer Skills" section, inserted between `/requirements` and `/breakdown` (workflow Step 2 placement matching skill DAG order). Schema mirrors `skills/design/SKILL.md:128-142` exactly: `decision_count`, `decisions`, `sticky_decisions`, `constraints`, `adr_references`, `article_14_applicable`, `article_14_pass`. Concrete example values match the existing producer style.
- **Q14 and Q16 consumer entries** in the "Consumer Skills" section — Q14 reads `decision_count` to flag third-alternative gaps, Q16 reads `sticky_decisions` to flag missing WHY captures.

### Changed

- `guides/structured-output-protocol.md` Q4 description extended with the design-block cross-check (`decision_count` vs `success_criteria_count`). All 5 SKILL_OUTPUT-consuming questions from `skills/cross-verify/SKILL.md:35-41` are now mirrored in the guide.
- `README.md` — badge 2.15.5 → 2.15.6; new "What's New in v2.15.6" section; footer date 2026-05-13.
- `SELF-CHECK.md` — header version + Previous; per-release row appended for v2.15.6.
- `docs/wiki/Changelog.md` — badge + new v2.15.6 entry.

### Pattern

**Producer + consumer doc-sync-as-a-pair** — adding the producer alone would have shipped half the gap and itself created the "confusion point" the issue cites (H4 + H1). Strict-scope fix would have been incomplete; minimal scope expansion closes both halves in a single PR.

### Source

Originally surfaced by `8-habit-reviewer` cross-verification of PR #152 (the #151 attribution-line implementation) as a pre-existing gap out of scope for #151. Filed as a 5-minute follow-up; held in backlog until 2026-05-13 batch.

### Verification

- `bash tests/validate-structure.sh` → 256 PASS, 0 FAIL.
- `bash tests/validate-content.sh` → 217 PASS, 0 FAIL, 0 fitness breaches.
- Link-check CI PASS (release-tag exclude from v2.15.5 prevents the chicken-and-egg failure on release PRs).

---

## v2.15.5 — Repo-Wide Link-Check CI Gate + Real Link-Rot Fixes (2026-05-12)

Patch release. Adds a new CI gate (lychee link-check workflow) that immediately caught 3 real link-rot issues on its first run. Closes [#172](https://github.com/pitimon/8-habit-ai-dev/issues/172) via [PR #184](https://github.com/pitimon/8-habit-ai-dev/pull/184).

### Added

- **`.github/workflows/link-check.yml`** — repo-wide markdown link validation using [`lychee`](https://github.com/lycheeverse/lychee) (Rust, fast). Triggers on PR + push to main when any `**/*.md` changes. Scope: external HTTP/HTTPS URLs across all `*.md` outside `docs/wiki/` (wiki has its own workflow). Pinned to same lychee-action commit SHA as `wiki-linkcheck.yml` (`8646ba30...` v2) for single-source-of-truth across both workflows.
- **`CONTRIBUTING.md` "Link check (external URLs)" subsection** under Testing Conventions — documents both link-check workflows and the two-layer design (CI for external URLs, shell tests for internal paths).

### Changed

- `README.md:666` — typo `https://github.com/pitimon/claud-mem-me` (repo doesn't exist) → `https://github.com/pitimon/memforge` (correct name). Real bug caught by the first CI run.
- `docs/adr/ADR-005-eu-ai-act-compliance-toolkit.md:137` — dead EU URL `https://ai-act-service-desk.ec.europa.eu/en/ai-act/` (404 as of 2026-05; EC restructured the service desk path). Since ADR-005 is Superseded (per ADR-012), preserved as historical reference text with note explaining the URL state. No canonical replacement available without separate research.
- `README.md` — badge 2.15.4 → 2.15.5; new "What's New in v2.15.5" section.
- `SELF-CHECK.md` — header version + Previous; per-release row appended for v2.15.5.
- `docs/wiki/Changelog.md` — badge + new v2.15.5 entry.

### Design

**Two-layer link validation**:

- **External URLs (CI)**: lychee workflows catch dead HTTP/HTTPS URLs (cross-repo refs, external docs, EC sites, etc.)
- **Internal paths (shell)**: `tests/validate-content.sh` Check 12b catches broken relative `.md` paths

Clean separation, no duplication. Wiki has its own workflow because wiki-style `[text](Home)` links require different resolution rules.

**Excluded URLs**:

- `pitimon/8-habit-ai-dev/(blob|tree|raw)/main/` — self-referential URLs only resolve after PR merges; would otherwise false-positive on every fresh PR.
- `pitimon/(memforge|devsecops-ai-team)` — private repos; workflow's `GITHUB_TOKEN` is scoped to this repo only and cannot authenticate against other private repos. These URLs are author-verified at write time; CI cannot re-verify them.
- `claude-governance` is **public and stays in scope** — caught real cross-repo link rot during development.

### Pattern

**CI gate that immediately proves its own value** — the first run on PR #184 caught 3 real link-rot issues:

1. README.md `claud-mem-me` typo (memforge repo name)
2. ADR-005 dead EC AI Act Service Desk URL
3. `pitimon/devsecops-ai-team/issues/467` 404 due to private-repo CI token scope (added to exclude list)

The 8-habit-reviewer recommendation from the 3-plugin integration audit (PR #171 here, PR #32 in claude-governance, PR #468 in devsecops-ai-team) is now enforced. Link rot was already happening silently; the gate catches it at PR time instead of when users report broken navigation.

### Verification

- `bash tests/validate-structure.sh` → 256 PASS, 0 FAIL.
- `bash tests/validate-content.sh` → 217 PASS, 0 FAIL, 0 fitness breaches.
- Link-check CI on PR #184 → **PASS** (after 3 real fixes applied).

---

## v2.15.4 — Backtick-Aware Ambiguity Pass + Dogfood ID Cleanup (2026-05-12)

Patch release. First true bug-fix in the v2.15.x line — addresses the CRITICAL false-positive surfaced by v2.15.0's dogfood smoke test on 2026-05-03 (#167 filed same day). `/consistency-check` Pass 3 (Ambiguity) now skips tokens inside `` `…` `` inline code spans and triple-backtick fenced blocks. Closes [#167](https://github.com/pitimon/8-habit-ai-dev/issues/167) via [PR #182](https://github.com/pitimon/8-habit-ai-dev/pull/182).

### Added

- **`skills/consistency-check/SKILL.md` Pass 3 "Backtick-context filter (required)" subsection** — pre-strip backtick-quoted segments from each line before applying the `[NEEDS CLARIFICATION]` / `TBD` / `TODO` / `???` / `XXX` token match. Covers single-backtick inline spans + triple-backtick fenced blocks. Rationale: PRDs legitimately mention these tokens as detection-target documentation (e.g., ``"the `[NEEDS CLARIFICATION]` token"``); flagging them as findings would punish writers for documenting the analyzer's own contract.
- **`tests/validate-content.sh` Check 21** — asserts 3 contract signals in SKILL.md Pass 3: "Backtick-context filter" label, "documentation-references" semantic, "pre-strip" workflow. Prevents future drift back to plain `grep -nE` semantics.

### Changed

- `skills/consistency-check/reference.md` — known-limitation note (line 143 in pre-fix state, citing #167) removed. The limitation was the bug; bug is now fixed.
- `docs/specs/consistency-check/tasks.md:48` — `Decision-D5` → `Decision-5`; `Decision-D9` → `Decision-9`. Two stale references missed by PR #169's earlier ID canonicalization pass.
- `README.md` — badge 2.15.3 → 2.15.4; new "What's New in v2.15.4" section.
- `SELF-CHECK.md` — header version + Previous; per-release row appended for v2.15.4.
- `docs/wiki/Changelog.md` — badge + new v2.15.4 entry.

### Design

**Option A (backtick-context filter) chosen over Option B (`<!-- consistency-check: skip -->` marker)** — per #167 recommendation: fewer escape hatches, principled, generalizes. Aligns the analyzer's runtime semantics with the validator-side whitelist that already exists for `skills/consistency-check/` content (`tests/validate-content.sh` Check 12c). The two-tier design (validator whitelist for skill prose + analyzer backtick-filter for spec artifacts) is now internally consistent: tokens inside backticks are documentation-references everywhere.

### Pattern

**Bug fix of a feature shipped 9 days ago** — distinct from v2.15.1/2/3 (content additions and convention imports). This is the first true bug-fix patch in the v2.15.x line. Issue surfaced via dogfood smoke test on the day v2.15.0 shipped; fix deferred because the bug is non-blocking (false-positive, not false-negative) and three intervening reflection-driven content patches had priority.

### Verification

- `bash tests/validate-structure.sh` → 256 PASS, 0 FAIL.
- `bash tests/validate-content.sh` → 217 PASS, 0 FAIL, 1 WARN, 0 fitness breaches.
- Check 21 fires 3 new pass signals when SKILL.md has the contract.
- Manual smoke test (per CONTRIBUTING.md): re-run `/consistency-check consistency-check` after merge to confirm `prd.md:45` no longer flagged. (Analyzer is a Claude-runtime skill, not bash-invokable; verification deferred to next maintainer running the smoke test.)

---

## v2.15.3 — Integrity Commandment #13: Grep-Verify Quotes Before Pasting (2026-05-12)

Patch release. Content-only addition to `guides/integrity-principles.md` closing a verification-discipline gap surfaced during the v2.15.2 reflection (obs #85070, #85071). Two consecutive PR reviews (#174, #177) showed habit-attribution drift from gestalt pattern-matching, and a quote misattribution (`"Magic" behavior` at ADR-013 Alt-2 line 87 wrongly cited to Alt-4) propagated through 4 artifacts before reviewer catch. Closes [#179](https://github.com/pitimon/8-habit-ai-dev/issues/179) via [PR #180](https://github.com/pitimon/8-habit-ai-dev/pull/180).

### Added

- **`guides/integrity-principles.md` commandment #13** — _"Never paste a verbatim quote without grep-verifying its source."_ Added under Honesty & Accuracy section. Covers ADR citations, habit principle claims (H1-H8 attributions), scare-quoted external phrases, observation IDs, and prior-conversation paraphrases presented as direct quotes. Why-statement cites the concrete v2.15.2 incident with line-number evidence; Instead-statement specifies the grep workflow (`Source: docs/adr/ADR-013.md:87`).

### Changed

- `guides/integrity-principles.md` — title "The 12 Commandments" → "The 13 Commandments"; mapping table row extended `5-7 (Honesty)` → `5-7, 13 (Honesty)` mapping to H8 Find Voice / Spirit (conscience).
- `README.md` — badge 2.15.2 → 2.15.3; architecture-tree comment "12 AI Integrity Commandments" → "13"; new "What's New in v2.15.3" section.
- `skills/review-ai/SKILL.md` — load directive "the 12 commandments" → "the 13 commandments".
- `SELF-CHECK.md` — header version + Previous; per-release row appended for v2.15.3.

### Intentionally preserved as historical record (not changed)

- `SELF-CHECK.md` v1.9.0 improvements section (line 140) — records what shipped in v1.9.0.
- `README.md` v1.9.0 release line (line 617) — release-history entry.
- `CHANGELOG.md` v2.0.0 deltas entry (line 464) — release-history entry.

Editing historical records would itself violate commandment #5 (file paths/names) and #4 (verified evidence) — the period record stays accurate.

### Pattern

**Commandment growth driven by reflection-detected internal drift across ≥2 sessions** — distinct from v2.15.1 upstream-import (addyosmani) and v2.15.2 community-article convention-import (Thai save-point article). Trigger is internal cross-session pattern, not external publication.

### Dogfooding moment

Drafting commandment #13 caught its own meta-violation pre-commit: initial text quoted `"magic behavior"` (lowercase, two-word) but ADR-013:87 actually says `"Magic" behavior` (capitalized, scare-quote on single word). Self-corrected, demonstrating the rule applies to its own writing.

### Verification

- `bash tests/validate-structure.sh` → 256 PASS, 0 FAIL.
- Grep-verified `"Magic" behavior` at `docs/adr/ADR-013-spec-persistence-opt-in.md:87` under Alt-2 header at line 85.

---

## v2.15.2 — Current State Save-Point Convention (2026-05-12)

Patch release. Convention-only addition to `guides/persistence-convention.md` importing a community-article save-point pattern (Thai-language article _"ผมไม่เคยกลัว /clear กับ /compact"_) as a user-owned 4th file. Closes [#176](https://github.com/pitimon/8-habit-ai-dev/issues/176) via [PR #177](https://github.com/pitimon/8-habit-ai-dev/pull/177).

### Added

- **`guides/persistence-convention.md` `## Current State File (Optional, User-Owned)` section** (lines 99-132) — documents the recommended 4th file `docs/specs/<slug>/current-state.md` with template (doing-now / stuck-at / next / last-updated), regeneration-safety rationale (why a separate file rather than appending to `tasks.md`), and explicit `/consistency-check` exclusion (informal running state is out of scope for cross-artifact consistency passes). **User-owned, no plugin skill writes to it** — eliminates the ownership conflict that would arise from co-locating hand-edits with a skill-regeneratable file. Frontmatter-exempt (template is free-form Markdown).
- **`guides/persistence-convention.md` `## Auto-Update Recipe (User-Side, Optional)` section** (lines 134-148) — CLAUDE.md rule template users can adopt in their own `~/.claude/CLAUDE.md` or project `CLAUDE.md`. **Plugin does NOT enforce** — preserves [ADR-013 Alternative 4](docs/adr/ADR-013-spec-persistence-opt-in.md) invariant (no-build philosophy: "skills are read-only guidance"; always-writing skills create unintended file artifacts).
- **`guides/persistence-convention.md` `## Attribution` section** (lines 161-165) — credits the community article + #176 issue. Paraphrased title + issue link is the maximum achievable attribution (no canonical URL exists for the article).

### Changed

- `README.md` — badge 2.15.1 → 2.15.2; new "What's New in v2.15.2" section.
- `SELF-CHECK.md` — header version + Previous; per-release row appended for v2.15.2.
- `docs/wiki/Changelog.md` — badge + new v2.15.2 entry.

### Not in scope (explicit, with rationale)

Honors PR #111's local-maximum lesson: no new skill, no new agent, no validator change, no skill-graph DAG change. The one new file (`current-state.md`) is convention-only — user-owned, plugin teaches the pattern, user owns enforcement. Rejected candidates documented in #176 body:

- ❌ **Single-file `spec.md` format** — breaking change to ADR-013's 3-file model; trades `/consistency-check` cross-artifact analysis for resume convenience.
- ❌ **Plugin-side auto-persist hook** — ADR-013 Alt-4 explicitly rejected (no-build philosophy + unintended file artifacts).
- ❌ **Data contracts as new section** — already covered by `/design` Step 4 "Define the contracts".
- ❌ **New `/save-point` or `/resume` skill** — duplicates `/reflect` invocation pattern; user maintains `current-state.md` manually.
- ❌ **Single-file priming command** — `hooks/session-start.sh:83-115` already detects all 3 skill-managed artifacts and nudges next skill (Issue #119, v2.7.0).

### Verification

- `bash tests/validate-structure.sh` — 256/256 PASS
- `bash tests/validate-content.sh` — PASS, 0 FAIL, 0 fitness breaches
- `@8-habit-reviewer` agent dispatched on PR #177 diff pre-merge: 17/17 PASS + 2 polish items, **both addressed in-PR** (F1 ADR-013 Alt-4 quote accuracy — "magic behavior" was actually Alt-2's wording; F2 frontmatter MUST scope ambiguity — explicit exemption added)
- `guides/persistence-convention.md` final size: 167 lines (cap 220; +58 net lines)

### Pattern

**Community-article convention-only import** — distinct shape from v2.15.1's upstream-skill extract (addyosmani PR #139). The article has no canonical PR/commit to cite — attribution is paraphrased title + issue link. Same minimal-scope discipline as the doubt-driven import: identify the one genuine gap, document the convention, reject everything else with rationale.

---

## v2.15.1 — Doubt-Driven Techniques Imported (2026-05-11)

Patch release. Single-guide enhancement to `guides/advisor-pattern.md` importing three techniques from [`addyosmani/agent-skills` — `doubt-driven-development`](https://github.com/addyosmani/agent-skills/blob/main/skills/doubt-driven-development/SKILL.md) (MIT, [PR #139](https://github.com/addyosmani/agent-skills/pull/139), upstream 2026-05-07 — published **27 days after** our prior addyosmani audit in PR #111). Closes [#173](https://github.com/pitimon/8-habit-ai-dev/issues/173) via [PR #174](https://github.com/pitimon/8-habit-ai-dev/pull/174).

### Added

- **`guides/advisor-pattern.md` `## Disprove-Mode Disciplines` section** with three labeled H3 subsections:
  - **Anti-bias: extract artifact + contract, not the claim (H5)** — codifies "Pass `ARTIFACT + CONTRACT` only, hold the CLAIM back" with bad-form vs good-form examples. Prevents the reviewer from validating the author's framing instead of independently re-deriving it.
  - **Iterative review: cap at 3 cycles (H3 + H7)** — explicit conditional. Single-shot pre-action dispatch (the default pattern) is unchanged. Cap applies only when re-dispatching after edits, with stop conditions: 3 cycles → escalate, trivial findings, or user override.
  - **Adversarial prompt template (H1 + H5)** — verbatim-style prompt block instructing reviewer to "Find issues, or state explicitly that you cannot find any. Do NOT validate. Do NOT summarize." **Dispatches a fresh subagent with no named role and read-only tools (`Read`, `Glob`, `Grep`)** — not `@8-habit-reviewer` (whose 17-question process is fixed per `agents/8-habit-reviewer.md:18-24`).
- **Quick Reference table** — second row added for `Adversarial (disprove-only)` pattern. Distinguishes it from the existing `Advisor (workflow)` row by H-mapping (`H1 + H5` vs `H5 + H4 + H1`) and use case (production deploys, schema migrations, public API changes).
- **See Also** — bullet citing MIT upstream + PR #139.

### Changed

- `README.md` — badge 2.15.0 → 2.15.1; new "What's New in v2.15.1" section.
- `SELF-CHECK.md` — header version + Previous; per-release row added for v2.15.1.
- `docs/wiki/Changelog.md` — badge + new v2.15.1 entry.

### Not in scope (explicit, with rationale)

Honors PR #111's local-maximum lesson: no new skill, agent, or validator. Rejected candidates documented in #173 body:

- ❌ **New `/doubt-check` skill** — duplicates `/cross-verify` + existing `@8-habit-reviewer` dispatch pattern.
- ❌ **`source-driven-development` import** — duplicates `/research` Evidence Standard + `/build-brief` "read code before writing".
- ❌ **Cross-model CLI escalation (Gemini/Codex)** — per ADR-006 (Superpowers deferral) and ADR-005 (plugin boundary), out-of-process tool invocation belongs in `claude-governance` or external tooling.
- ❌ **agentskills.io frontmatter migration** — [ADR-007](docs/adr/ADR-007-agentskills-compatibility-decision.md) NO-GO holds (2026-04-11 decision unchanged).

### Verification

- `bash tests/validate-structure.sh` — 256/256 PASS
- `bash tests/validate-content.sh` — 214/214 PASS (pre-bump; release-meta checks added below)
- `@8-habit-reviewer` agent dispatched on PR #174 diff: 14/17 pass + 3 N/A + 0 hard blockers + 3 polish items, **all addressed in-PR** (F1 Quick Reference row, F2 concrete subagent dispatch syntax, F3 missing habit label)

Pattern: **post-audit delta**. When an upstream methodology innovation publishes after a periodic audit, evaluate the delta in isolation rather than triggering a full re-audit. Same shape as v2.7.1's import from this same upstream (1/6 imported then; 3 new techniques imported now, all new since prior audit cutoff).

---

## v2.15.0 — Cross-Artifact Consistency Analyzer + Opt-In Spec Persistence (2026-05-03)

Minor release adding `/consistency-check` (the 18th skill) and an opt-in `--persist <slug>` argument to `/requirements`, `/design`, `/breakdown`. Inspired by github/spec-kit `/analyze` ([#165](https://github.com/pitimon/8-habit-ai-dev/issues/165)). Read-only by design; no gating, no enforcement (boundary preserved with `claude-governance`). Hybrid evaluation: deterministic when artifacts use `FR-NNN`/`Decision-N`/`Task #N` ID markers, LLM semantic with explicit warning when absent. Backward compatible — without `--persist`, all three modified skills behave byte-identically to v2.14.3.

### Added

- **`/consistency-check` skill** — `skills/consistency-check/SKILL.md` (180 lines) + `reference.md` (149 lines). 5 detection passes (Coverage, Drift, Ambiguity, Underspec, Inconsistency). Severity table (CRITICAL/HIGH/MEDIUM/LOW), max 30 findings, file:line citations, `✓ Pass` rows for zero-finding passes (silence forbidden). `allowed-tools: ["Read", "Glob", "Grep"]` only.
- **`--persist <slug>` opt-in flag** added to `/requirements`, `/design`, `/breakdown`. Writes to `docs/specs/<slug>/{prd,design,tasks}.md` with YAML frontmatter (`feature, step, created, updated, source-issue, source-skill-version`). Conflict policy: AskUserQuestion prompt → fallback to numbered variant in non-interactive contexts. Slug validation regex `^[a-z0-9][a-z0-9-]{1,63}$` prevents path traversal.
- **`guides/persistence-convention.md`** — single source of truth for the `--persist` convention; loaded on-demand by the 3 modified skills via `${CLAUDE_PLUGIN_ROOT}` directive.
- **`docs/specs/consistency-check/`** — dogfood directory containing this release's own `prd.md`, `design.md`, `tasks.md` (the analyzer can run against itself for smoke testing).
- **[ADR-013](docs/adr/ADR-013-spec-persistence-opt-in.md)** — persistence opt-in design decision with 5 alternatives considered, flag-style argument convention precedent attestation (`/ai-dev-log`, `/calibrate`), slug validation regex, and hybrid pass evaluation strategy.

### Changed

- **`/requirements`, `/design`, `/breakdown` SKILL.md** — frontmatter `argument-hint` extended with `[--persist <slug>]`; `allowed-tools` adds `Write` and `AskUserQuestion`. New "Optional Persistence" section in body with ID-linkage tip per skill (`FR-NNN`/`Decision-N`/`Task #N`). Behavior unchanged when flag absent.
- **`CLAUDE.md`** — Skills list updated to include `/consistency-check`; new row in Skills→Habits Mapping table; on-demand loading list updated.
- **`README.md`** — Skills badge 17 → 18; version badge 2.14.3 → 2.15.0; new "What's New in v2.15.0" section; structure tree updated.

### Boundary preserved

`/consistency-check` is advisory only — emits findings, never blocks. Enforcement on persisted spec artifacts (e.g., "PRD must have ≥3 EARS criteria to merge") still belongs in `pitimon/claude-governance`. ADR-013 explicitly addresses this in the "Boundary stance" section.

### Verification

- All existing `tests/validate-structure.sh` and `tests/validate-content.sh` checks continue to pass (PRD-EARS-13 invariant)
- New validator checks added for: `/consistency-check` skill structure, `docs/specs/consistency-check/` dogfood artifact presence + valid frontmatter, `--persist` flag documented in all 3 modified skills

Pattern: spec-kit ideas can be adapted without violating plugin boundary if you keep them advisory and respect the "discipline, not enforcement" doctrine. Verified non-overlap with `claude-governance/spec-driven-dev` (single-spec, no cross-artifact pass).

---

## v2.14.3 — Post-Migration Cleanup + Validator Self-Discipline (2026-05-03)

Patch release closing post-v2.14.2 metadata drift surfaced by [#163](https://github.com/pitimon/8-habit-ai-dev/issues/163) and applying the 800-line file-size rule the validator enforces on skills to the validator itself.

### Fixed

- **ADR-012 metadata closure** — `SELF-CHECK.md` lines 103-104 reframed (described deleted files `docs/research/eu-ai-act-obligations.md` + `guides/eu-ai-act-mapping.md` as if still present); `docs/adr/ADR-012-eu-ai-act-migration-completion.md` status header upgraded with `**Implementation**:` field naming commit `ed65b97` (v2.14.2 release) and the metadata-closure date.

### Added

- **`.gitignore`** — created with `/deep-project/` and `/.claude/` entries to gate against accidental `git add .` of third-party plugin clones (e.g. `piercelamb/deep-project` cross-plugin testing checkouts) and Claude Code session artifacts. Working copies preserved locally.

### Changed

- **`tests/validate-content.sh` trim** — 831 → 793 lines via comment consolidation across Check 15 (EU AI Act stub explainer), Check 19 sub-checks B/C/D/E/F/G (drift-guard rationale blocks), F2 validation coverage explainer, and F3 SIGPIPE-fix explainer. Logic untouched; total checks unchanged (10); PASS count preserved (205). Closes the credibility gap where the validator violated the 800-line rule it enforces on skills (Check 5 in `validate-structure.sh`).

Pattern: validator self-discipline — when a fitness function applies to the rest of the codebase, it applies to the validator too. Same shape as v2.14.1's "validator assertion, not checklist" principle.

---

## v2.14.2 — EU AI Act Migration Completion (2026-05-02)

Completes the migration of the EU AI Act compliance toolkit from this plugin to [`pitimon/claude-governance`](https://github.com/pitimon/claude-governance) v3.1.0 per the plugin boundary established in memory observation #233270 (2026-04-07): `8-habit-ai-dev` = workflow discipline; `claude-governance` = compliance enforcement + framework mappings. EU AI Act compliance is a framework mapping, not a workflow step. Original placement here was a boundary error; ADR-005 (the original toolkit ADR) is now marked Superseded by ADR-012 (this migration). See [`pitimon/claude-governance` PR #26](https://github.com/pitimon/claude-governance/pull/26) for the canonical landing.

### Removed

- **`skills/eu-ai-act-check/reference.md`** — full 9-obligation tiered checklist (25 MUST + 27 SHOULD + 8 COULD) now lives in [`pitimon/claude-governance` `skills/eu-ai-act-check/reference.md`](https://github.com/pitimon/claude-governance/blob/main/skills/eu-ai-act-check/reference.md)
- **`docs/research/eu-ai-act-obligations.md`** — primary-source verified Articles 9-15 quotes now live in [`pitimon/claude-governance` `docs/research/eu-ai-act-obligations.md`](https://github.com/pitimon/claude-governance/blob/main/docs/research/eu-ai-act-obligations.md) (verbatim copy)
- **`guides/eu-ai-act-mapping.md`** — Article-to-skill mapping guide rewritten for governance plugin's skill set, now lives in [`pitimon/claude-governance` `docs/compliance/EU-AI-ACT-MAPPING.md`](https://github.com/pitimon/claude-governance/blob/main/docs/compliance/EU-AI-ACT-MAPPING.md)

### Changed

- **`skills/eu-ai-act-check/SKILL.md`** — replaced with a redirect stub that names the canonical location, provides install + invocation examples, preserves the NOT LEGAL ADVICE disclaimer, and links to ADR-012 + governance ADR-003. Skill name `eu-ai-act-check` remains valid in the catalog so existing cross-references (RESOLVER, using-8-habits, design Step 5, ai-dev-log, session-start hook) still resolve.
- **`docs/adr/ADR-005-eu-ai-act-compliance-toolkit.md`** — status updated from Accepted → Superseded by ADR-012 (preserves historical record while flagging as no longer current)
- **`tests/validate-content.sh` Check 15** — replaced content assertions (research file, guide file, tier counts, ¶ refs) with stub-mode checks: stub exists + redirects to canonical location + preserves disclaimer + references ADR-012; deleted files are NOT present (catches accidental restore); ADR-012 exists; ADR-005 marked Superseded
- **Cross-reference reframing** in surface-area files where `/eu-ai-act-check` was mentioned: `skills/RESOLVER.md` skill discovery table, `skills/using-8-habits/SKILL.md` + `reference.md`, `skills/design/SKILL.md` Article 14 checkpoint scope pre-flight pointer, `skills/ai-dev-log/SKILL.md` references + Privacy Note + Handoff section, `hooks/session-start.sh` Compliance line, `README.md` skill table entry

### Added

- **`docs/adr/ADR-012-eu-ai-act-migration-completion.md`** — completion-side ADR. Documents the boundary correction, the redirect-stub pattern (vs. hard delete), the deferred-cosmetic-cleanup decision, and the cross-plugin contract with [`pitimon/claude-governance` ADR-003](https://github.com/pitimon/claude-governance/blob/main/docs/adr/ADR-003-eu-ai-act-compliance-toolkit.md). Establishes a reusable migration pattern for future plugin-boundary corrections.

### Deferred to follow-up doc-only PR

- README "EU AI Act ready" badge update (currently still asserts in-plugin coverage)
- Wiki pages: `Architecture.md` ADR-005 link, `Changelog.md` v2.3.0 retro, `FAQ.md` Q&A, `Home.md` value table, `Installation.md` skills list, `Skills-Reference.md` `/eu-ai-act-check` section, `Workflow-Overview.md` skill list

Rationale for deferral: same precedent as [`pitimon/claude-governance` PR #25 + #26](https://github.com/pitimon/claude-governance/pull/25) — the local Markdown formatter rewrites all tables on every Edit, producing 140+ lines of unrelated noise. Batching cosmetic touches into a separate PR keeps this migration's diff focused on the load-bearing changes (deletion + stub + critical cross-refs + ADR + validator) and minimizes the cross-plugin duplication window.

### Coordination

- This release is the second half of the migration. The first half shipped in [`pitimon/claude-governance` v3.1.0](https://github.com/pitimon/claude-governance/releases/tag/v3.1.0) (PR #26) on 2026-05-02. Hard rule from PR #26: `8-habit-ai-dev` v2.14.2 deletion must NOT merge before `claude-governance` v3.1.0 ships. That hard rule is satisfied — v3.1.0 was tagged before this release.

### Why this matters (H7 + H8)

The migration restores plugin boundary integrity (H8 — Voice/Conscience: each plugin has a clear "what we are and aren't"). The redirect-stub-not-hard-delete decision preserves user discoverability (H4 — Win-Win: the user with only one plugin gets a helpful redirect, not a "skill not found" error). The deferred-cosmetic-cleanup decision follows the formatter-precedent lesson from `pitimon/claude-governance` PR #23 + #25 + #26 (H7 — Sharpen the Saw: the lesson generalized; the same trap doesn't get re-sprung).

---

## v2.14.1 — README "What's New" Drift Guard (2026-05-02)

Patch release closing [#157](https://github.com/pitimon/8-habit-ai-dev/issues/157) — external QA via the plugin's own `8-habit-reviewer` agent found 13/17 score with Spirit (33%) and Body (50%) failures concentrated in one root cause: `validate-content.sh` Check 19A passes on the README badge URL `releases/tag/v2.14.0`, never asserting that `## What's New in v2.14.0` exists as a section header. So the validator was green while the README "What's New" section ended at v2.13.1. Same bug class as [#124](https://github.com/pitimon/8-habit-ai-dev/issues/124) (CHANGELOG pointer-fallback loophole, hardened in v2.11.1) and [#141](https://github.com/pitimon/8-habit-ai-dev/issues/141) (SELF-CHECK.md body drift, hardened in v2.13.1). Capability-level pattern recurrence on a sibling surface — the v2.13.1 sub-checks E + F lesson did not generalize to README.md.

### Fixed

- **`README.md` "What's New" backfill** — `## What's New in v2.14.0` block restored (3-bullet TOH theme summary). The section had stayed at v2.13.1 through the entire v2.14.0 release because the validator was matching the bare version string from the badge URL.
- **`README.md` TOC anchor** — `[What's New](#whats-new-in-v220)` → `[What's New](#whats-new-in-v2141)`. The v2.2.0 anchor has not existed since v2.3.0; the broken link has shipped through 11 releases.
- **`README.md` architecture file tree** — declared "17 skills (8 workflow + 9 standalone)" but enumerated only 13 SKILL.md paths. Backfilled the 4 missing skills (`calibrate`, `using-8-habits`, `eu-ai-act-check`, `ai-dev-log`) so the tree matches the count.

### Added

- **`tests/validate-content.sh` Check 19 sub-check G** — anchored grep `^## What's New in v${current_version}` against `README.md`. Mirrors the sub-checks E + F mechanism from [PR #144](https://github.com/pitimon/8-habit-ai-dev/pull/144) (SELF-CHECK.md body freshness). Closes the badge-URL false-positive class permanently — sub-check A keeps the existing "version mentioned anywhere" check, sub-check G adds the strict header anchor.
- **Check 20 hardening** — pin literal `Find → Fix → Re-Verify` loop name + assert exactly 5 numbered steps in the Verification Phase section of `skills/review-ai/SKILL.md`. Closes the v2.14.0 self-disclosed follow-up (CHANGELOG noted "passes on 3 weak string matches; 5-step loop name + step count not pinned"). Two new assertions; reviewer concern documented and addressed in the same release.

### Pattern

Same shape as v2.11.1 (CHANGELOG drift guard) and v2.13.1 (SELF-CHECK body freshness): when QA surfaces the same drift class on a third surface, the fix is a fitness-function tightening, not a checklist. Check 19 now covers README + CHANGELOG + wiki + SELF-CHECK + README-section-header — five anchored assertions, all co-located.

### Fitness

- `validate-structure.sh` 246/0, `validate-content.sh` **206/0/1 WARN** (was 203 + 3 new pass-able assertions: sub-check G + Check 20 loop name + Check 20 step count), `test-skill-graph.sh` 57/0, `test-verbosity-hook.sh` 19/0.

### Reviewer

External QA report by [@itarunp-apple](https://github.com/itarunp-apple) — ran `8-habit-reviewer` agent against the v2.14.0 install at `~/.claude/plugins/cache/.../8-habit-ai-dev/2.14.0/` per the framework's intended self-discipline workflow. The boundary discipline citation in the issue body ("the H8 framing 'modeling = follow the process always' landing the structural-fix-not-checklist case is exactly the right pressure") frames the patch correctly: this is a deposit, not a withdrawal — the reporter brought rigorous file:line evidence and a sound patch plan.

Closes #157.

---

## v2.14.0 — TOH Framework Inspirations (2026-05-02)

Minor release closing milestone [#15](https://github.com/pitimon/8-habit-ai-dev/milestone/15) — three workflow-discipline imports from Toh Framework (`Nathanphop/Toh-Framework`, now unavailable) (an "AI-Orchestration Driven Development" framework for solo SaaS builders). Cross-pollination filtered through the plugin-boundary rule: workflow discipline lands here; enforcement and project-state persistence routed to `claude-governance` ([pitimon/claude-governance#24](https://github.com/pitimon/claude-governance/issues/24) for 7-file memory system).

### Added

- **`SKILL_OUTPUT` attribution lines** ([#151](https://github.com/pitimon/8-habit-ai-dev/issues/151), [PR #152](https://github.com/pitimon/8-habit-ai-dev/pull/152)) — visible attribution `[/<skill-name>] COMPLETE SKILL_OUTPUT:<type>` directly above each `<!-- SKILL_OUTPUT:` HTML comment in the 4 emitter skills (design, breakdown, requirements, review-ai). Status markers: `COMPLETE` / `PARTIAL` / `FAILED` (text-only per no-emoji rule). No plugin version in attribution — keeps version-bump checklist at 4 files. **Check 22** added to `tests/validate-structure.sh` (BSD-safe via `grep -B1`, no sed/awk per ADR-011). `cross-verify` parser at `skills/cross-verify/SKILL.md:34` unaffected (still scans HTML-comment opener). Inspired by Toh's Agent Announcement format.
- **Argument-driven smart-routing for `/using-8-habits`** ([#149](https://github.com/pitimon/8-habit-ai-dev/issues/149), [PR #154](https://github.com/pitimon/8-habit-ai-dev/pull/154)) — when invoked with intent (`/using-8-habits "I need to verify what we built last week"`), switches from narrative-tree mode to ranked-recommendation mode: ≤3 ranked skills + reasoning + alternatives + a single direct question. Reads `~/.claude/habit-profile.md` for verbosity and `~/.claude/lessons/*.md` for context. **Activates** the existing `argument-hint` frontmatter at `skills/using-8-habits/SKILL.md:8` — no new skill file, no `/8h` shortcut. Reshape decision (extend existing skill rather than wrapper) made during planning per cross-verify + advisor feedback to avoid skill-catalogue bloat. Inspired by Toh's `/toh` Smart Command.
- **`/review-ai` Verification Phase** ([#150](https://github.com/pitimon/8-habit-ai-dev/issues/150), [PR #155](https://github.com/pitimon/8-habit-ai-dev/pull/155)) — new section between Sequence Rule and When to Skip. 5-step Find→Fix→Re-Verify loop: list CRITICAL/HIGH findings → apply fix → re-run review on same scope → cite evidence-of-fix per finding (file:line or deferred issue ref) → **refuse to emit `pass: true` SKILL_OUTPUT unless all CRITICAL closed**. Output ends with Verification Table (Finding | Severity | Fix Evidence | Status). **Plugin-boundary guardrails** with three independent anchors in the implementation: (a) section header reads "guidance only — NOT a hook", (b) blockquote redirects hook-based proposals to `claude-governance` per #58/#60 correction pattern, (c) step 5 closes "guidance to Claude, not a runtime gate". `tests/validate-content.sh` Check 20 enforces all three. Inspired by Toh's Test → Fix → Loop adapted as discipline guidance, not automated enforcement.

### Pattern

External-framework cross-pollination kept tight by the boundary rule. Of 10 candidate ideas surfaced from Toh, 3 imported cleanly, 7 rejected with reason (multi-agent builders, "vibe" full-pipeline command, slash shortcuts, design profiles, component registry, multi-IDE syntax adapters, 7-file project memory system — all out of scope or routed elsewhere). Decision rationale captured in research brief at `~/.claude/plans/toh-framework-idea-inspiration-sunny-forest.md`. Companion proposal in `claude-governance` ([#24](https://github.com/pitimon/claude-governance/issues/24)) for the persistence layer.

### Fitness

- `validate-structure.sh` **246/0** (was 245; +1 Check 22), `validate-content.sh` **201/0/1 WARN** (was 198; +3 Check 20), `test-skill-graph.sh` 57/0, `test-verbosity-hook.sh` 19/0.

### Follow-ups (open)

- [#153](https://github.com/pitimon/8-habit-ai-dev/issues/153) — `/design` producer example missing from `guides/structured-output-protocol.md` (pre-existing gap, surfaced during #151 cross-verify, separate scope).
- Reviewer suggestion (non-blocking): harden Check 20 to pin the 5-step loop name and step count — currently passes on 3 weak string matches.

Closes #149, #150, #151.

---

## v2.13.1 — SELF-CHECK.md Body Freshness (2026-04-25)

Patch release closing a three-PR arc for [#141](https://github.com/pitimon/8-habit-ai-dev/issues/141). `SELF-CHECK.md` had drifted within a single file — header read v2.13.0 while footer said `Previous: 2.7.1` and the per-release score list ended at v2.8.0, silently skipping 6 releases (v2.9.0 through v2.13.0). The plugin opens with _"H8 Modeling: Follow the process always, no shortcuts when unwatched"_ — the 6-release gap contradicted the stated principle. Same bug class as [#106](https://github.com/pitimon/8-habit-ai-dev/issues/106) on a surface not covered by Check 19.

### Fixed

- **`SELF-CHECK.md` body catch-up** ([#142](https://github.com/pitimon/8-habit-ai-dev/pull/142)) — footer updated from `Previous: 2.7.1` to `Previous: 2.12.0`; added 6 missing per-release rows (v2.9.0, v2.10.0, v2.11.0, v2.11.1, v2.12.0, v2.13.0) using the v2.8.0 row format with dimension evidence sourced from this CHANGELOG. All 6 rows scored 5.0 — no genuine regressions observed.
- **`CONTRIBUTING.md` § Version Bumping** ([#143](https://github.com/pitimon/8-habit-ai-dev/pull/143)) — "Version lives in **3 files**" → "**4 files**", adds `SELF-CHECK.md` header (line 3) to the list. The 4-file convention has been enforced by `tests/validate-structure.sh` since [#106](https://github.com/pitimon/8-habit-ai-dev/issues/106) but CONTRIBUTING.md was missed in PR #107.

### Added

- **`tests/validate-content.sh` Check 19 sub-checks E + F** ([#144](https://github.com/pitimon/8-habit-ai-dev/pull/144)) — CI invariant preventing recurrence:
  - **E (footer freshness)**: derives `prev_version` from `git tag -l "v2.*" | sort -V` (tag immediately preceding `plugin.json.version`) and asserts `SELF-CHECK.md` footer reads `Previous: <prev_version>`.
  - **F (no-gaps)**: iterates all v2.x tags; each must have a matching `^- v<x.y.z>: ` row in `SELF-CHECK.md`.
  - Dev-env resilience: if `git tag -l "v2.*"` returns empty (shallow clone without tags), emits WARN and skips E + F — CI sets `fetch-tags: true` + `fetch-depth: 0` so drift is still caught at merge time.
- **`.github/workflows/validate.yml`** — `fetch-tags: true` + `fetch-depth: 0` on `actions/checkout@v4` so CI can read the tag list.

### Pattern

Same shape as v2.11.1 (CHANGELOG Drift Guard, [#124](https://github.com/pitimon/8-habit-ai-dev/issues/124)): when QA surfaces the same drift class across multiple releases, the fix is a validator assertion, not a checklist. Check 19 now covers README + CHANGELOG + wiki + SELF-CHECK freshness — all docs-freshness assertions co-located.

### Fitness

- `validate-structure.sh` 245/0, `validate-content.sh` **198/0/1 WARN** (was 196 + 2 net new pass-able assertions), `test-skill-graph.sh` 57/0, `test-verbosity-hook.sh` 19/0.

### Intentionally not in scope

- Re-computing dimension scores for v2.9.0..v2.13.0 — all defaulted to 5.0 (no regression evidence in CHANGELOG entries).
- Same-PR version-bump policy — check runs on every PR; if version bumps without SELF-CHECK.md update, CI fails, which is the desired outcome.
- Pre-v2.0.0 tag coverage — explicitly excluded; v1.x tags predate the per-release list convention and are documented in `docs/wiki/Changelog.md`.

Closes #141.

---

## v2.13.0 — Cross-Agent Discoverability (2026-04-22)

Minor release completing the cross-agent story — three linked PRs from the 2026-04-22 `/research` session on [`garrytan/gbrain`](https://github.com/garrytan/gbrain) make the plugin discoverable from non-Claude agent platforms (Codex, Cursor, Windsurf, Aider, Continue) and LLM-based repo fetchers. No breaking changes; every addition is opt-in or purely additive.

### Added

- **`skills/RESOLVER.md`** ([#135](https://github.com/pitimon/8-habit-ai-dev/issues/135), [PR #139](https://github.com/pitimon/8-habit-ai-dev/pull/139)) — flat trigger-phrase → skill-path dispatcher for all 17 skills, organized in 3 sections (Workflow / Assessment / Meta), ≤3 triggers per skill. Fills the phrase→path gap left by existing navigation sources (CLAUDE.md indexes by step, frontmatter by skill name, `/using-8-habits` narrative by situation, `prev-skill`/`next-skill` by predecessor). None of those is a flat lookup by user intent.
- **`llms.txt` + `AGENTS.md`** at repo root ([#136](https://github.com/pitimon/8-habit-ai-dev/issues/136), [PR #140](https://github.com/pitimon/8-habit-ai-dev/pull/140)) — [`llmstxt.org`](https://llmstxt.org) convention flat doc-map + non-Claude operating protocol. Gives Codex / Cursor / Windsurf / Aider / Continue / LLM-based repo-fetchers a canonical door into the plugin. `skills/RESOLVER.md` is the shared link target; the chain `llms.txt → AGENTS.md → skills/RESOLVER.md → individual SKILL.md` is now end-to-end discoverable from any agent platform.
- **README "Design Principle" section** ([#137](https://github.com/pitimon/8-habit-ai-dev/issues/137), [PR #138](https://github.com/pitimon/8-habit-ai-dev/pull/138)) — cites Garry Tan's 2026 essay [_"Thin Harness, Fat Skills"_](https://github.com/garrytan/gbrain/blob/master/docs/ethos/THIN_HARNESS_FAT_SKILLS.md) as external validation of the bounded-session-hook + on-demand-skills pattern already enforced by `hooks/session-start.sh` (≤300 tokens per CLAUDE.md).
- **ADR-010** (`docs/adr/ADR-010-flat-skill-dispatcher.md`) and **ADR-011** (`docs/adr/ADR-011-cross-agent-discoverability.md`) — decision records with 6 options considered each (A accepted; B–F rejected with reasons). ADR-011 records the empirical finding that the `obra/superpowers-skills/.../references/` path cited in #136's issue body was already HTTP 404 at design time (caught via `gh api`; AGENTS.md cites upstream tool conventions by name only).
- **`tests/validate-structure.sh` Check 20** (RESOLVER ↔ skills bidirectional cross-reference) and **Check 21** (llms.txt + AGENTS.md existence + 4× pointer integrity) — coverage invariants enforced at merge time. 3 negative-test scenarios captured in each PR body per the evidence-chain convention from v2.11.1 / #134.

### Pattern extracted (lesson file)

**"Bidirectional Validator for Canonical Cross-References"** — when a new canonical artifact (file A references a set in directory B) ships, write a validator check that asserts BOTH directions: forward ("every source-side entry has a target-side row") + reverse ("every target-side citation resolves to a real source-side entry"). Check 12 (README ↔ skills), Check 20 (RESOLVER ↔ skills), Check 21 (llms.txt/AGENTS.md ↔ RESOLVER/CLAUDE) all share this shape. It is the unit-test analog for documentation integrity. See `~/.claude/lessons/2026-04-22-cross-agent-discoverability-batch.md` for the full retrospective.

### Intentionally not in scope

- **No skill frontmatter schema changes** (no `triggers: [array]` field) — would force a 17-skill migration + major version bump; RESOLVER covers the same need with zero breaking impact.
- **No runtime dispatch hook** — enforcement belongs in [`claude-governance`](https://github.com/pitimon/claude-governance), not `8-habit-ai-dev` (plugin boundary per `CLAUDE.md § Plugin Boundary`). RESOLVER is guidance + an invariant test, not a runtime gate.
- **No `llms-full.txt` variant** — gbrain has one, we don't need it at 17 skills yet.
- **No upstream `obra/superpowers-skills` hyperlink** in AGENTS.md — the cited path was 404 at design time; AGENTS.md references per-platform tooling (Codex `skill`, Cursor Rules, etc.) by name only.

### Cost/benefit

~4 hours end-to-end (plan + design + implement + negative tests + merge) across 3 PRs. Adds 473 lines across 10 files with zero deletions. 2 new ADRs, 2 new validator checks (covering invariants that would otherwise silently break on future renames or skill additions).

---

## v2.12.0 — Code-Symbol Grep Evidence (2026-04-17)

Minor release adding a new Evidence Standard obligation to the `/research` skill and clarifying the scope of the `research-verifier` agent ([#133](https://github.com/pitimon/8-habit-ai-dev/issues/133)). Guidance-only — no automation, no hook, no change to verifier execution behavior.

**Motivation**: A real-world Deep-mode `/research` tech-stack audit (memforge v1.10.0, 2026-04-17) produced a findings row verdicting `neo4j-driver` as "dead/transitional". The `research-verifier` agent passed the brief: every file path and line number cited was accurate. A downstream PRD and Design doc were produced recommending removal. A simple grep at the next workflow step revealed 5+ files with active imports — `neo4j-driver` is the canonical Bolt-protocol client for Memgraph (both engines share the same TS/Node client library). Removing it would have broken production graph on first image rebuild. The verdict passed Deep-mode verification on pristine citations while carrying a load-bearing false semantic claim.

### Added

- **`skills/research/SKILL.md` — Evidence Standard bullet**: when an Audit-mode or Findings-table row's verdict matches `/remove|dead|unused|transitional|safe to (drop|remove)/i` on a code symbol (dep, module, function, exported type, file), the row must cite a grep-check across the repo's source directories showing whether consumers exist. Declaration-site citations (e.g. `package.json:6`, import statements) do not establish liveness. Two concrete examples included (dead-verdict and keep-verdict shapes).
- **`skills/research/SKILL.md` — Step 4 scope callout**: one-line note after the Deep-mode dispatch makes explicit that the verifier gates citation integrity, not semantic correctness, and that code-symbol verdicts need separate grep evidence even when Deep-mode passes.
- **`skills/research/SKILL.md` — Definition-of-Done line**: new checklist item so code-symbol verdicts are visible at handoff time.
- **`agents/research-verifier.md` — `description:` frontmatter**: rewritten to "citation-integrity verification agent" with an explicit out-of-scope clause callers see before dispatching.
- **`agents/research-verifier.md` — `## Limit of Verification` section**: defines in-scope (file paths exist, line numbers contain the claimed text, URLs resolve, documents are findable) vs. out-of-scope (semantic correctness of conclusions) and introduces a `SEMANTIC-EVIDENCE-MISSING` flag the verifier emits when a code-symbol verdict row lacks liveness evidence. The verifier does **not** attempt the grep itself — that remains the author's obligation.

### Intentionally not in scope

- Expanding the `research-verifier` agent to semantically check conclusions. Per CONTRIBUTING.md philosophy ("Skills provide guidance, not automation"), this is a documentation change that gives Claude an explicit obligation for a specific verdict shape.
- `"revisit"` is intentionally **excluded** from the obligation trigger. It is a weaker, follow-up-style verdict that would over-trigger the grep requirement on rows that are merely flagged for attention. The hard-removal verdicts (`remove`, `dead`, `unused`, `transitional`, `safe to drop/remove`) are the load-bearing class.

### Cost/benefit

~2 seconds of grep per dead-verdict row. Benefit in the incident above: ~1 hour of downstream workflow (PRD + Design + archive + correction log) saved, plus averted production-graph breakage.

---

## v2.11.1 — CHANGELOG Drift Guard (2026-04-17)

Patch release hardening `validate-content.sh` Check 19 against a recurring documentation-drift pattern ([#124](https://github.com/pitimon/8-habit-ai-dev/issues/124), [PR #131](https://github.com/pitimon/8-habit-ai-dev/pull/131)). Post-v2.11.0 `/cross-verify` exposed that the same drift class slipped through CI twice — at v2.9.0 and v2.11.0 — because Check 19's pointer-fallback logic (`grep -Eq "v${ver}|CHANGELOG\.md"`) passed purely on the literal string "CHANGELOG.md" in the wiki file, not on any actual version entry. Two releases in a row = capability-level pattern; the fix is a fitness-function assertion, not a checklist.

### Added

- **Check 19 hardening** — 3 new **FAIL**-severity assertions (`tests/validate-content.sh` lines 518–567):
  - B. `CHANGELOG.md` contains `^## v<version>` section header
  - C. `docs/wiki/Changelog.md` contains `^## v<version>` section (pointer-to-CHANGELOG.md fallback removed — the stealth loophole)
  - D. `docs/wiki/Changelog.md` badge `latest-v<version>-blue` matches

### Fixed

- **`CHANGELOG.md`** — backfill missing v2.9.0 + v2.11.0 entries (file previously jumped v2.10.0 → v2.8.0).
- **`docs/wiki/Changelog.md`** — backfill missing v2.11.0 entry + bump stale badge `latest-v2.10.0` → `latest-v2.11.0`.

### Fitness

- `validate-structure.sh` 243/0, `validate-content.sh` **185/0** (was 183 + 2 net new pass-able assertions), `test-skill-graph.sh` 57/0, `test-verbosity-hook.sh` 19/0.

Closes [#124](https://github.com/pitimon/8-habit-ai-dev/issues/124). Lesson persisted as H7 capability pattern.

---

## v2.11.0 — Design Pipeline Completion + Wiki Redesign (2026-04-16)

Close the only remaining structured-output-block gap in the `/requirements` → `/design` → `/breakdown` → `/review-ai` handoff chain ([#128](https://github.com/pitimon/8-habit-ai-dev/issues/128), [PR #129](https://github.com/pitimon/8-habit-ai-dev/pull/129)) and upgrade 20 wiki pages to a professional template ([#127](https://github.com/pitimon/8-habit-ai-dev/issues/127), [PR #130](https://github.com/pitimon/8-habit-ai-dev/pull/130)). Both PRs merged within 3 minutes of each other (14:13 and 14:16 UTC).

### Added

- **`SKILL_OUTPUT:design` structured block** ([#128](https://github.com/pitimon/8-habit-ai-dev/issues/128)) — closes the last cross-skill handoff gap. `/cross-verify` Q4, Q14, Q16 now auto-populate (`✓A`) from the design block instead of requiring manual re-reading.
- **Tech-stack decisions as formal concerns** — `/design` Step 2 + `/research` Step 1 now surface language/framework choices as explicit design outputs, not implicit assumptions.
- **Scope validation via `SKILL_OUTPUT:requirements`** — `/design` now consumes the requirements block so the skill can flag scope drift between decisions and success criteria.
- **Decision granularity heuristic** — H3-based guidance for splitting vs grouping design decisions.
- **H8 Whole Person dimensions in `/design` checkpoint** — Body/Mind/Heart/Spirit prompts added alongside the existing pass/fail gate.
- **`docs/wiki/Architecture.md`** (new) — 4-layer plugin design documentation.
- **`docs/wiki/Maturity-Model.md`** (new) — 4-level adaptive guidance system.

### Changed

- **`docs/wiki/Home.md`** — rewritten as a hero landing page (49 → 108 lines).
- **`docs/wiki/Skills-Reference.md`** — expanded from 13 → 17 skills with quick-select matrix.
- **`docs/wiki/Workflow-Overview.md`** — upgraded with a Mermaid diagram and full 17-skill coverage.
- **All 8 Step wiki pages** — upgraded with `> [!IMPORTANT]` checkpoint callouts.
- **`docs/wiki/_Sidebar.md`** — reorganized with a new "Concepts" section.
- **`docs/wiki/FAQ.md`** — 2 new FAQ entries; **`docs/wiki/Getting-Started.md`** + **`docs/wiki/Vibe-Coding-vs-Structured.md`** updated with GitHub Alert boxes.
- **`docs/wiki/Installation.md`** — skills list updated to 17 skills across 4 categories.
- **Wiki redesign totals**: 18 files changed, 291 insertions, 53 deletions.

### Fitness

- `validate-structure.sh` 243/243 PASS, `validate-content.sh` 183/183 PASS, `test-skill-graph.sh` PASS, `test-verbosity-hook.sh` PASS — all green at release.

---

## v2.10.0 — Progressive-Disclosure SKILL.md Split (2026-04-16)

Refactor the 3 largest skills into `SKILL.md + reference.md + examples.md` triads to create headroom below the 2000-word F3 fitness-function ceiling. Pattern sourced from external research (`shanraisshan/claude-code-best-practice`), filtered through plugin-boundary audit — see [ADR-009](docs/adr/ADR-009-skill-split-convention.md).

### Added

- **ADR-009 — Progressive-disclosure SKILL.md split convention** ([#125](https://github.com/pitimon/8-habit-ai-dev/issues/125)) — decides Load-directive mechanism (inline `${CLAUDE_PLUGIN_ROOT}` paths), naming (`SKILL.md` + `reference.md` + `examples.md`), and when to apply (SKILL >1500w). Reuses existing Check 8 for sibling existence — no new fitness function needed for that.
- **F6 — Sibling word-budget soft limit** (`tests/validate-structure.sh` Check 9b) — warns when `skills/*/reference.md` or `skills/*/examples.md` exceeds 5000 words.
- **`skills/using-8-habits/reference.md` + `examples.md`** — split from 1990-word SKILL.md. `reference.md` holds the 17-skill inventory and cross-plugin composition tables; `examples.md` holds the password-reset onboarding walkthrough.
- **`skills/eu-ai-act-check/reference.md`** — split from 1989-word SKILL.md. Full 9-obligation checklist (25 MUST / 27 SHOULD / 8 COULD items) with article/paragraph references. No `examples.md` (pure-reference skill).
- **`skills/calibrate/reference.md` + `examples.md`** — split from 1774-word SKILL.md. Scoring rubric + profile-write procedure + 4 sample profiles (one per maturity level).

### Changed

- **`using-8-habits/SKILL.md`**: 1990 → 1108 words.
- **`eu-ai-act-check/SKILL.md`**: 1989 → 908 words.
- **`calibrate/SKILL.md`**: 1774 → 1161 words.
- **`tests/validate-content.sh` Checks 15 and 18** — search the SKILL + reference + examples triad as a unit for anti-drift, tier-count, and paragraph-reference assertions. Content moved to a sibling still counts. Triad-existence detection uses a safe for-loop (avoids `ls` non-zero exit under `set -euo pipefail`).

### Rejected (from the research brief at `plans/shiny-singing-dove.md`)

- 27-event hook system, PermissionRequest routing, batch processing — plugin-boundary violation; belongs in `pitimon/claude-governance`.
- Auto-load `user-invocable: false` background skills (Idea B), parallel cross-verify dispatch (Idea D) — separate decision cycles, not bundled into v2.10.
- F3 word-budget upgrade from WARN to FAIL — deferred; stays as WARN for this release.

### Fitness

- All 3 validators pass: `validate-structure.sh` 243/0, `test-skill-graph.sh` PASS, `validate-content.sh` 183/0 with 0 fitness breaches.

---

## v2.9.0 — Deep-Project Inspired Improvements (2026-04-13)

Three features inspired by comparison research against [`piercelamb/deep-project`](https://github.com/piercelamb/deep-project). Cross-verified (14/17), advisor-reviewed, 8-habit QA passed (13/17 → 15/17 after fixes). Released via PRs [#121](https://github.com/pitimon/8-habit-ai-dev/pull/121), [#122](https://github.com/pitimon/8-habit-ai-dev/pull/122), [#123](https://github.com/pitimon/8-habit-ai-dev/pull/123).

### Added

- **Interview protocol for `/requirements`** ([#118](https://github.com/pitimon/8-habit-ai-dev/issues/118), [PR #121](https://github.com/pitimon/8-habit-ai-dev/pull/121)) — new `guides/templates/interview-protocol.md` gives structured conversation scaffolding (Quick / Standard / Deep depth) for discovering requirements before EARS criteria. Replaces the "ask the user 5 questions" default with a better-shaped discovery flow.
- **Workflow step awareness in session-start hook** ([#119](https://github.com/pitimon/8-habit-ai-dev/issues/119), [PR #122](https://github.com/pitimon/8-habit-ai-dev/pull/122)) — `hooks/session-start.sh` now surfaces a workflow step cue so partial chains can resume across sessions without per-skill rework. Respects existing `HABIT_QUIET=1` opt-out.
- **Machine-readable structured output blocks** ([#120](https://github.com/pitimon/8-habit-ai-dev/issues/120), [PR #123](https://github.com/pitimon/8-habit-ai-dev/pull/123)) — new `guides/structured-output-protocol.md` defines `<!-- SKILL_OUTPUT:... END_SKILL_OUTPUT -->` HTML comment blocks at the end of `/requirements`, `/breakdown`, and `/review-ai`. Enables `/cross-verify` to auto-populate (`✓A`) answers from producer skills instead of requiring manual re-reading of prior-step artifacts.

### Fixed

- **Scope-alignment threshold in `/cross-verify` Q8** — QA raised the `task_count` vs `ears_count` ratio guard from hardcoded `3×` to a documented `≤ 3×` threshold so the heuristic is auditable and adjustable.

### Fitness

- `validate-structure.sh` 238/238 PASS, `validate-content.sh` 177/177 PASS, `test-skill-graph.sh` 57/57 PASS, `test-verbosity-hook.sh` 19/19 PASS — 491/491 total at release commit `8123b25`.

---

## v2.8.0 — Claude Code Architecture Insights (2026-04-13)

Production patterns from Anthropic's Claude Code internals — reverse-engineered in ["Claude Code from Source"](https://github.com/alejandrobalderas/claude-code-from-source) (Alejandro Balderas, 18-chapter architectural analysis of the March 2026 npm source map leak) — adapted into 4 existing skills as workflow guidance. All changes are skill-level guidance additions; no runtime hooks, no new files, no new dependencies.

### Added

- **`/build-brief` step 6 "Context survival"** ([#114](https://github.com/pitimon/8-habit-ai-dev/issues/114)) — guidance for briefs that survive Claude Code's 4-layer context compression pipeline. Recommends: front-load critical info, keep briefs under ~4,000 tokens, stable-first ordering for prompt cache stability. Inspired by Ch5 (Agent Loop) and Ch17 (Performance).
- **`/design` step 5 "Identify sticky decisions"** ([#116](https://github.com/pitimon/8-habit-ai-dev/issues/116)) — rework-level classification table (Sticky >50% / Semi-sticky 10-50% / Flexible <10%). Decisions marked STICKY require a new `/design` cycle to change. Inspired by Ch17 sticky boolean latches for prompt cache stability. Maps to H2 (Begin with End in Mind).
- **`/reflect` Step 7 "Consolidation check" + `/reflect consolidate` argument** ([#113](https://github.com/pitimon/8-habit-ai-dev/issues/113)) — nudges when lesson files exceed 10; new consolidate mode runs 4-phase cycle (Orient → Gather → Consolidate → Prune) with human approval gate before deletions. Inspired by Ch11 auto-dream memory consolidation. Added Bash to allowed-tools for prune phase.
- **`/breakdown` step 5 "Token-efficient parallel design"** ([#115](https://github.com/pitimon/8-habit-ai-dev/issues/115)) — prompt prefix sharing guidance with efficiency table. Parallel tasks sharing context achieve ~90% input token savings via cache hits. Most valuable for 3+ parallel tasks. Inspired by Ch9 (Fork Agents).

### Research

- Deep research review of "Claude Code from Source" (18 chapters, 7 Parts) produced a [research brief](https://github.com/pitimon/8-habit-ai-dev/milestone/13) scoring the book 8.5/10 with live system cross-verification of Ch11 Memory claims (5/8 confirmed against running Claude Code v2.1.104).
- KAIROS mode and `/dream` command investigated — confirmed as real feature-flagged code (not speculation), but not shipped in external builds as of April 2026.

---

## v2.7.1 — Review Discipline Refinement (2026-04-11)

Small post-milestone patch on top of v2.7.0. Adds two review-time disciplines to `/review-ai` after a cost/benefit audit against Addy Osmani's `agent-skills` repository (MIT). Only one of six candidate mechanics was imported — the other five were explicitly rejected as duplicative of existing plugin features or out-of-scope for the `8-habit-ai-dev` plugin boundary. Scope deliberately minimal to honor the v2.7.0 "local maximum" framing from `~/.claude/lessons/2026-04-11-issue-96-reader-adoption.md`.

### Added

- **`/review-ai` Performance axis** ([#110](https://github.com/pitimon/8-habit-ai-dev/issues/110), [PR #111](https://github.com/pitimon/8-habit-ai-dev/pull/111)) — fourth review category alongside Security / Quality / Completeness, flagging N+1 queries, unbounded loops, missing pagination on list endpoints, unindexed queries on large tables, and memory leaks (unclosed streams, unbounded caches, retained references). Performance findings follow the same `file:line` evidence standard as the other axes.
- **`/review-ai` review-tests-first directive** — new Process step 2 directs the reviewer to open the new or changed test files _before_ judging the implementation. Tests declare the _intended_ behavior; reading them first gives you the specification to review the code against. If new logic has no corresponding test, record it as a Completeness finding.
- **Verdict output table** now lists four category rows (Security / Quality / Performance / Completeness); Definition of Done checkbox references all four categories by name.

### Not Added (deliberately rejected after cost/benefit audit)

The research brief evaluated six agent-skills mechanics; five were rejected. Rejection rationale is archived in PR #111's body and the local plan file `~/.claude/plans/drifting-waddling-pascal.md` so future "research hype" passes don't re-litigate the same ground:

- ❌ `guides/anti-rationalization.md` — already present as 24 anti-patterns in `rules/effective-development.md` + 12 commandments in `guides/integrity-principles.md`, just in different prose form
- ❌ `guides/red-flags.md` — `/reflect` and `/cross-verify` already provide self-detection
- ❌ `guides/google-engineering-principles.md` (Hyrum's Law / Beyoncé Rule / Trunk-Based Development) — cultural flavor over existing substance; no new discipline the plugin lacks
- ❌ `/cross-verify` Q18 "Beyoncé check" — existing questions already probe test coverage gaps
- ❌ Cross-plugin hard-gate progression spec — no user demand signal; runtime enforcement belongs in `claude-governance`, not here

### Fitness functions

- All 4 validators green: `validate-structure.sh` 238/238, `validate-content.sh` 177/177, F1/F2/F3 HEALTHY, `test-verbosity-hook.sh` 11/11
- `skills/review-ai/SKILL.md` word count: 890 → 1025 (F3 ceiling 2000, headroom 975 retained)
- Validator assertion total unchanged — this patch does not add or remove assertions

### Source attribution

- Research source: [`addyosmani/agent-skills`](https://github.com/addyosmani/agent-skills) (MIT)
- No code or text was directly copied; only the _idea_ of a Performance review axis and a tests-first directive were adapted

---

## v2.7.0 — Reader Adoption (2026-04-11)

Closes the reader-adoption half of the `/calibrate` feature loop. v2.6.0 shipped `/calibrate` which **writes** `~/.claude/habit-profile.md`; until this release, the 17 skills did not **read** the profile, so the feature delivered discovery but not adaptation. v2.7.0 closes that gap via a hook-based adaptation directive — zero changes to individual skill files.

### Added

- **Hook-based verbosity adaptation** ([#96](https://github.com/pitimon/8-habit-ai-dev/issues/96)) — `hooks/session-start.sh` now reads `~/.claude/habit-profile.md` at session start and emits a level-specific one-sentence directive into session context. Claude honors the directive when invoking any skill in the session, adapting verbosity automatically from Dependence (full guidance) through Independence, Interdependence, and Significance (minimal prompts).
- **`guides/verbosity-adaptation.md`** (new) — canonical per-level adaptation rules + worked examples across 5 skill archetypes (workflow planning, review/gate, research, implementation, retrospective). Reference material for maintainers and future skill authors. Not auto-loaded at runtime — the hook hardcodes its one-sentence directive per level from these rules.
- **`tests/test-verbosity-hook.sh`** (new) — 11-check regression coverage for all 8 hook branches: missing profile, 4 levels (Dependence/Independence/Interdependence/Significance), 2 overrides (verbose/concise), unknown level with Dependence fallback, plus HABIT_QUIET silence check and ≤300-token budget assertion. Wired into `.github/workflows/validate.yml` alongside the 3 existing validators.
- **`preferences.verbosity-override` precedence in the hook** — `verbose` promotes any level to Dependence; `concise` demotes any level to Significance; `none` or unset uses the profile `level` as-is. Matches the schema v1 contract documented in `guides/habit-profile-schema.md`.

### Architectural constraint honored (why hook-based, not per-skill)

A pre-implementation F3 word-budget audit surfaced two skills with dangerously thin headroom: `/using-8-habits` (1990/2000 words, 10 headroom) and `/eu-ai-act-check` (1989/2000 words, 11 headroom). Any per-skill text addition would have broken F3 fitness on the next edit — even a 15-word preamble like `Load guides/verbosity-adaptation.md` would overflow.

The only viable runtime injection point in a pure-markdown plugin is `hooks/session-start.sh`, which outputs into session context once per session and applies globally to all subsequent skill invocations. The hook approach ships with **zero changes to individual skill files** — F3 preserved, validators untouched, existing skill bodies unchanged. Future skill authors don't need to add level-handling boilerplate; the directive is already in session context when they're invoked.

### Changed

- `hooks/session-start.sh` — expanded from the v2.6.0 static `/calibrate` nudge to a full 8-branch profile reader. Existing behavior preserved: when no profile exists, the v2.6.0 nudge still fires unchanged. Uses the pipe-safe `awk` pattern from v2.6.1's SIGPIPE fix to parse YAML frontmatter.
- `.github/workflows/validate.yml` — now runs 4 validators instead of 3 (added `tests/test-verbosity-hook.sh`).
- `CLAUDE.md` — added a Key Conventions bullet documenting the hook-based verbosity adaptation mechanism.

### Milestone v2.7.0 — CLOSED (1/1)

With this release, [milestone v2.7.0 — Reader Adoption](https://github.com/pitimon/8-habit-ai-dev/milestone/12) is closed. Issue #96 was the sole scope. The #90 user-calibration feature loop is now complete: write (v2.6.0) → read (v2.7.0).

### Migration notes

No breaking changes. Users upgrading from v2.6.1:

- If you have a profile at `~/.claude/habit-profile.md`, the session-start hook will emit your level-specific directive on the next session start. No action needed.
- If you don't yet have a profile, the existing v2.6.0 nudge still fires suggesting `/calibrate`. Behavior unchanged from v2.6.1.
- `HABIT_QUIET=1` continues to silence everything (ADR-006 contract preserved).
- If you want to override your level-default behavior, edit `~/.claude/habit-profile.md` and set `preferences.verbosity-override` to `verbose` (max guidance) or `concise` (minimum). `none` or unset uses the level as-is.

### What's next (beyond v2.7.0)

The Hermes-inspired feature loop (milestones v2.6.0 + v2.7.0) is complete. Further enhancements are either out-of-scope (runtime-dependent features like Honcho passive inference — would violate the pure-markdown constraint) or delegated to companion plugins (`claude-mem`, `pitimon/claude-governance`, `devsecops-ai-team`). The plugin is at a local maximum given its constraints.

Potential v2.8.0+ targets, if user demand emerges:

- Dual-artifact strategy for agentskills.io (publish individual standalone skills to the open registry while keeping the chain-enforcing SKILL.md here) — per ADR-007 §Future Triggers
- Progressive disclosure for skill bodies (split `SKILL.md` into summary + `references/*.md` deep-dives) if token budgets get tight

---

## v2.6.1 — Skill Effectiveness Tracking (2026-04-11)

Closes milestone v2.6.0 by shipping the final P3 issue from the Hermes-Inspired research brief. This is a minor patch release — one question added to `/reflect` plus a new maintainer-curated report file. No breaking changes, no migrations.

### Added

- **`/reflect` Q6 — Skill effectiveness signal** ([#92](https://github.com/pitimon/8-habit-ai-dev/issues/92)) — `/reflect` now asks "which skill was most useful this session, and which was least useful or confusing?" after the 5 standard retro questions. Answer can be `n/a` if no skills were invoked. Feeds periodic maintainer trend analysis.
- **`SKILL-EFFECTIVENESS.md`** (repo root) — maintainer-curated trend tracker aggregating Q6 signals from `~/.claude/lessons/*.md` across time. Ships empty (initial state, awaiting data). Includes explicit update protocol, "what this is NOT" boundaries, and per-skill tally table for all 17 skills. This is **H7 (Sharpen the Saw) applied to the plugin itself** — invest in the capability of the skills, not just their output.
- **`guides/templates/lesson-template.md`** — added `## Skill effectiveness` section to the lesson template body so Q6 answers are captured consistently across user lesson files.

### Changed

- `skills/reflect/SKILL.md` — updated description from "5 questions" to "6 questions" (still fits the "5 minutes" DORA budget — Q6 is a 30-second signal question). Output table, Persist step, and Definition of Done all updated. Word count: 561 → 711 (well under 2000 F3 fitness budget).
- `CLAUDE.md` Skills → Habits table — `/reflect` row now notes the skill-effectiveness signal.

### Architectural constraint honored

`SKILL-EFFECTIVENESS.md` is **maintainer-curated, not auto-generated**. A runtime aggregator that scans `~/.claude/lessons/*.md` across users would need to be a hook (belongs in `pitimon/claude-governance` per plugin boundary) or would violate the "skills are read-only guidance" principle. The chosen design — maintainer reads lessons periodically, updates the report, commits — respects both constraints and matches ADR-008's schema-as-contract pattern (report format is a stable contract between `/reflect` writers and maintainer readers).

### Fixed

- **`tests/validate-content.sh` F3 convention-consistency check** — replaced `sed -n '/^---$/,/^---$/p' "$skill_file" | head -20` with an awk-based frontmatter extractor that exits cleanly at the second `---` marker. The old pattern was flaky under `set -o pipefail` on Linux CI (GNU sed) because `skills/ai-dev-log/SKILL.md` has a body horizontal rule at line 65, causing sed to emit 187 lines from a 239-line file; `head -20` closed early, sed hit SIGPIPE, and CI failed with exit code 4. BSD sed on macOS silently ignores SIGPIPE which masked the bug locally. Fix uses the same awk pattern already documented at `tests/validate-structure.sh:27`. The bug was latent since ai-dev-log gained its body `---` rule and caught PR #99 on its first CI run. No functional change to the F3 check — only the extraction mechanism.

### Milestone v2.6.0 — now CLOSED (5/5)

With this release, all five Hermes-Inspired issues are shipped:

- ✅ #88 Persistent Reflection Artifacts (v2.6.0)
- ✅ #89 Habit Nudge Guidance Document (v2.6.0)
- ✅ #91 agentskills.io Compatibility Evaluation — NO-GO (v2.6.0)
- ✅ #90 User Maturity Calibration — `/calibrate` (v2.6.0)
- ✅ #92 Skill Effectiveness Tracking — `/reflect` Q6 + report (v2.6.1, **this release**)

Follow-up [#96](https://github.com/pitimon/8-habit-ai-dev/issues/96) (16-skill reader adoption for `habit-profile.md`) remains open for v2.7.0.

### Migration notes

No breaking changes. Users upgrading from v2.6.0:

- Next `/reflect` invocation will include Q6. Answer `n/a` if no skills apply.
- Your existing lesson files at `~/.claude/lessons/*.md` are unchanged. New lessons written after upgrade will include the `## Skill effectiveness` section.
- `SKILL-EFFECTIVENESS.md` ships empty — data accumulates as you reflect.

---

## v2.6.0 — Hermes-Inspired Improvements (2026-04-11)

Operationalizes four user-modeling and learning-loop patterns inspired by Hermes Agent (Nous Research), filtered through plugin-boundary discipline and cross-verification. Milestone v2.6.0 scope: P1 + P2 issues shipped (4/5 closed); #92 deferred to v2.6.1 or v2.7.0.

### Added

- **`/calibrate` skill + habit-profile schema v1** ([#90](https://github.com/pitimon/8-habit-ai-dev/issues/90), [ADR-008](docs/adr/ADR-008-user-maturity-calibration-design.md)) — new standalone skill that asks 5-7 questions and writes `~/.claude/habit-profile.md` so other skills can adapt verbosity to the user's maturity level (Dependence → Independence → Interdependence → Significance). Uses dominant-level scoring rubric adapted from `guides/whole-person-rubrics.md`. Writer side only — reader adoption for the 16 existing skills is tracked as [#96](https://github.com/pitimon/8-habit-ai-dev/issues/96) for v2.7.0.
- **`guides/habit-profile-schema.md`** — public schema contract (v1, YAML frontmatter + markdown body, versioned via `schema-version`). Defines the API future reader skills code against; documents reader compatibility expectations and the BSD-vs-GNU date syntax caveat for age calculations.
- **Persistent reflection artifacts** ([#88](https://github.com/pitimon/8-habit-ai-dev/issues/88)) — `/reflect` now persists lessons to `~/.claude/lessons/YYYY-MM-DD-<slug>.md`. `/research` and `/build-brief` search these before starting work. Closes the learning loop: reflect → persist → retrieve → apply.
- **`guides/habit-nudges.md`** ([#89](https://github.com/pitimon/8-habit-ai-dev/issues/89)) — specification document for proactive workflow reminders (hook implementation belongs in `pitimon/claude-governance` per plugin boundary — this is the spec side).
- **`guides/agentskills-compatibility-eval.md`** + **ADR-007** ([#91](https://github.com/pitimon/8-habit-ai-dev/issues/91)) — Deep + Compare research brief evaluating migration to the agentskills.io open standard. Decision: **NO-GO**. Other tools only parse `name`/`description`, not `metadata.*`, so migrating would trade the DAG validator's chain enforcement for a prose convention — a net loss. Hands-on sandbox test included.
- **ADR-008** — User Maturity Calibration design record with 5 interlocking decisions: Alt E hybrid, dominant-level scoring, YAML frontmatter schema, standalone chain position, user-driven re-calibration with age warning.
- **`/calibrate` discovery nudge** in `hooks/session-start.sh` — when `~/.claude/habit-profile.md` is missing, append a one-line 💡 nudge to the Onboarding line. Fully respects existing `HABIT_QUIET=1` opt-out from ADR-006.

### Changed

- Skill count: **16 → 17** (`/calibrate` added). Updated across README badge, CLAUDE.md Skills → Habits table, SELF-CHECK.md, `/using-8-habits` inventory, and `validate-structure.sh` counter.
- `skills/using-8-habits/SKILL.md` — added `/calibrate` entry to the Assessment skills inventory; trimmed existing content to stay under F3 convention-consistency fitness budget (now 1990/2000 words — monitor margin for future edits).
- `hooks/session-start.sh` — Onboarding line now lists `/calibrate` alongside `/using-8-habits`.
- Validators expanded: **443 → 470 PASS** across 3 validators with 17/17 F3 convention-consistency.

### Not Changed (Deferred or Out-of-Scope)

- **Reader adoption for the 16 pre-v2.6.0 skills** — tracked as [#96](https://github.com/pitimon/8-habit-ai-dev/issues/96) for v2.7.0. Reading the profile and adjusting verbosity is a cross-cutting change that deserves its own PR.
- **Issue [#92](https://github.com/pitimon/8-habit-ai-dev/issues/92) Skill Effectiveness Tracking** (P3) — remains open, deferrable to v2.6.1 or v2.7.0.

### Migration notes

No breaking changes. New users installing v2.6.0 for the first time will be nudged to run `/calibrate` on their next session. Existing users can opt in anytime by running `/calibrate` directly. Users who prefer the previous behavior can export `HABIT_QUIET=1` to silence both the session-start reminder and the calibration nudge.

---

## v2.5.0 — Testing & Discoverability (2026-04-09)

### Added

- **`tests/test-skill-graph.sh`** — DAG validator for `prev-skill`/`next-skill` chains (#79). Checks: cycles, dangling refs, symmetric edges, chain anchors, orphans. 55 assertions. Wired into CI.
- **`hooks/pre-commit.sh.example`** — template that runs `/review-ai` on staged files before commit (#80). Copy to `.git/hooks/pre-commit` to opt in. NOT auto-installed.
- **Bidirectional wiki ↔ skills linking** (#81) — each workflow skill (Steps 0-7) now has a `## Further Reading` section linking to its wiki page. Validator Check 15b enforces both directions.
- **Validator Check 15a** — asserts `pre-commit.sh.example` exists and is NOT executable.

### Changed

- CI now runs 3 validators: `validate-structure.sh` + `test-skill-graph.sh` + `validate-content.sh`
- Version bump 2.4.1 → 2.5.0

---

## v2.4.1 — Honest Correction (2026-04-09)

Same-day correction after reading the `claude-plugins-official:superpowers` `brainstorming` source and confirming our `/brainstorm` (shipped in v2.4.0) was a weaker reimplementation of ~60% of its functionality.

### Removed (breaking — install `superpowers` for equivalent)

- **`/brainstorm` skill** — deleted. Superpowers' `brainstorming` ships a 500+ line hard-gate discipline suite with spec doc written to git, visual companion, one-question-at-a-time dialogue, and 143K installs. `/research` now references it for fuzzy problem statements. See ADR-006 for the lesson.

### Added

- **`HABIT_QUIET=1` opt-out** for `hooks/session-start.sh` — reduces religious adherence pressure. Users who internalize the workflow can silence the reminder via env var.
- **"Core 5" tier** in `/using-8-habits` — acknowledges 80/20 reality: most daily work uses `/requirements`, `/review-ai`, `/cross-verify`, `/research`, `/reflect`. The other 11 skills are optional depth.
- **ADR-006** — documents audience honesty + opt-out + "check installed peer plugins before building parity features" lesson.

### Changed

- `hooks/session-start.sh` banner softened: "7-Step Workflow (not Vibe Coding)" → "7-Step Workflow reference — use what fits the task"
- Skills count: 17 → 16 (removed `/brainstorm`)

---

## v2.4.0 — Workflow Completions (2026-04-09)

Three workflow additions closing parity gaps with peer plugins.

### Added

- **`/brainstorm`** (Step 0a) — divergent thinking BEFORE `/research`. 5 Whys, alternative framings, hidden assumptions. Crisp separation from `/research`: brainstorm = divergent (no sources), research = convergent (with sources). Maps to H2 + H5. Closes parity gap with Superpowers plugin (29K⭐, 143K installs).
- **EARS-notation in `/requirements`** — 5 structured acceptance criteria templates (Ubiquitous, Event-driven, State-driven, Unwanted, Optional) from Rolls-Royce (Mavin et al. 2009). New `guides/ears-notation.md` reference (~130 lines). Login worked example. Explicit opt-out rule for small features (<3 criteria). Closes parity gap with GitHub Spec Kit (84.7K⭐) and AWS Kiro.
- **`/using-8-habits`** — onboarding meta-skill with decision tree for "which skill next?" + complete walkthrough example (password reset, 11 skill invocations). Closes parity gap with addyosmani/agent-skills (8.3K⭐) `using-agent-skills`.
- **Check 16/17/18** in `validate-content.sh`: +52 assertions covering new skills with **anti-drift check** — meta-skill must mention every skill in `skills/` directory.

### Changed

- Skills: **15 → 17** (9 workflow + 8 standalone)
- `CLAUDE.md` Skills→Habits Mapping table updated with new rows
- `README.md` Skills badge `15` → `17`, tree "9 workflow + 8 standalone"
- `skills/workflow/SKILL.md` table adds Step 0a row for `/brainstorm`
- `skills/requirements/SKILL.md` gains new Step 4 with EARS template + opt-out rule

### Fixed

- **`validate-structure.sh`** regex `[a-z-]` → `[a-z0-9-]` — latent bug that rejected skill names containing digits (exposed by `using-8-habits`)

### Validation

Total assertions: **376** (up from 302): `validate-structure.sh` 219 + `validate-content.sh` 157.

Pull requests: #72 (brainstorm) · #73 (EARS) · #74 (meta-skill + version bump) · #76 (design Three Loops reference)

---

## v2.3.0 — EU AI Act Compliance Toolkit (2026-04-09)

Flagship blue-ocean feature: first Claude Code plugin with explicit EU AI Act compliance toolkit, shipped ~4 months before 2 August 2026 enforcement.

### Added

- **`/eu-ai-act-check`** — 9-obligation tiered checklist (25 MUST + 27 SHOULD + 8 COULD) covering Articles 9-15. Scope pre-flight (Annex III × EU market matrix). Default mode runs MUST only; `--full` includes SHOULD + COULD. All items anchored to Article paragraph numbers with verbatim quotes.
- **`/ai-dev-log`** + **`scripts/generate-ai-dev-log.sh`** — AI-assisted development log generator from `git log` + Co-Authored-By trailers. 4 modes: markdown (default), `--json`, `--summary`, `--out FILE`. Single-pass awk aggregation (4× faster than naive implementation). `set -euo pipefail`, dependency check, tempfile cleanup trap, macOS BSD + Linux GNU `date` compatible.
- **`/design`** Step 5 — Article 14 human-oversight 5-capability checkpoint (¶4(a-e): Understand / Automation bias / Interpret / Override / Stop button).
- **`docs/research/eu-ai-act-obligations.md`** (~351 lines) — primary-source research with verbatim Verified Quotes for all 7 articles (9-15), fetched via web.archive.org (FLI mirror of OJ text). Cross-verified by `research-verifier` agent against EC AI Act Service Desk.
- **`guides/eu-ai-act-mapping.md`** (~364 lines) — user-facing 3-step workflow with end-to-end medical triage example, bootstrap `mkdir` block, NOT LEGAL ADVICE disclaimer at top.
- **ADR-005** — decision record with 4 alternatives considered + CLAUDE.md convention compliance table.
- **Check 15** in `validate-content.sh` — 24 new assertions with **auto tier-count verification** (prevents "claimed 22 actual 25" bugs).
- **Plugin Boundary section** in `CLAUDE.md` — documents the complementary relationship with [`pitimon/claude-governance`](https://github.com/pitimon/claude-governance) to prevent future scope drift. 8-habit-ai-dev = workflow discipline; claude-governance = compliance enforcement + frameworks.

### Changed

- Version file convention: "Version lives in **4 files**" (was incorrectly documented as "3 files"). `tests/validate-structure.sh` enforces consistency across `plugin.json`, `marketplace.json`, `README.md` (badge + footer), and `SELF-CHECK.md`.
- `CLAUDE.md` Bash tool policy documented explicitly: allowed in `review-ai`, `eu-ai-act-check`, `ai-dev-log`. New skills default to `Read/Glob/Grep` only.

### Fixed

- `tests/validate-structure.sh` intermittent SIGPIPE failure — replaced `sed | head` with awk-only extraction to eliminate broken-pipe race under `set -o pipefail`.
- `SELF-CHECK.md` version drift — CI silently accepted stale version until validator was updated.

### Quality

- Cross-verify: **15/15 Well-Prepared** at ship (plan-level) + **16/16** at Stage A execution.
- 8 bugs caught in self-review before merge.
- Total assertions: **302** (199 structure + 103 content).

### Architectural Note

Post-ship boundary review identified that EU AI Act belongs architecturally in `claude-governance` (alongside existing DSGAI-MAPPING.md). A Path C hybrid migration is tracked in [pitimon/claude-governance#21](https://github.com/pitimon/claude-governance/issues/21) for a future release. v2.3.0 ships the toolkit here temporarily; install both plugins together for maximum coverage.

Pull requests: #65 (research + guide) · #66 (skill + design) · #67 (ai-dev-log) · #68 (version bump + ADR-005) · #69 (Check 15 validation) · #70 (version-files fix + SIGPIPE) · #71 (Plugin Boundary section, Stage A of Path C)

---

## Earlier Versions

See [`docs/wiki/Changelog.md`](docs/wiki/Changelog.md) for v2.2.0 and earlier, or the [GitHub Releases page](https://github.com/pitimon/8-habit-ai-dev/releases) for the authoritative release history.

### Recent Highlights (v2.0–v2.2)

- **v2.2.0** (2026-04-07) — Body Dimension Level-Up: content validation + fitness functions
- **v2.1.0** (2026-04-07) — Multi-Agent Research (Feynman-inspired)
- **v2.0.0** (2026-04-07) — Orchestration-Aware Development (ULW-inspired)
