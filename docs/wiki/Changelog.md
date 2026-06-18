![Latest](https://img.shields.io/badge/latest-v2.21.31-blue)

# Changelog

This page summarizes recent wiki-relevant releases. The authoritative release history remains the repository [`CHANGELOG.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/CHANGELOG.md), GitHub Releases, and git tags.

> [!NOTE]
> Wiki summaries intentionally focus on user-facing documentation changes and workflow boundaries. Use the repository changelog for exact release notes.

## v2.21.31 · Windows Git Bash preflight for Codex validation (#323)

Adds `scripts/windows-preflight.ps1` for PowerShell users who need to validate the Codex plugin on Windows. The script checks `codex`, `git`, `node`, Git Bash, installed plugin listing, and the common bare-`bash` collision with the WSL launcher. The contract stays intentionally narrow: Bash validators remain the single source of truth; Windows uses Git Bash as the compatibility layer rather than a parallel PowerShell validator suite.

## v2.21.30 · Codex hook-config schema purity + doctrine reconcile (#321)

Maintainer's own Codex install surfaced a hook-config parse failure: Codex auto-parses `hooks/hooks.json` at install with a strict schema (top level = `hooks` only) and rejected the top-level `description` field (`unknown field 'description', expected 'hooks'`). Fixed by dropping the field, added validator Check 31 as a forcing function, and reconciled the Codex compatibility docs — which had conflated _parsing_ with _executing_ — to state the real contract: Codex parses `hooks.json` at install and may invoke `SessionStart` via the JSON adapter. No runtime enforcement added; Claude hook parity remains unpromised (ADR-024).

## v2.21.29 · Trap-naming taxonomy lens (#319)

Adds a 4-mode trap failure taxonomy (hidden cost / false economy / scaling failure / premature abstraction) as a 14th integrity commandment in `guides/integrity-principles.md`, wired into `/scrutinize` Step 1 (tag rejected alternatives) and `/cross-verify` Shadow Self-Check (test the recommendation itself). Inspired by [UditAkhourii/adhd](https://github.com/UditAkhourii/adhd)'s evidence that naming traps is the highest-leverage adversarial output. Markdown-only discipline; both skills already load the integrity guide, so no new surface.

## v2.21.28 · Post-release QA polish (#316, #317)

Maintainer Codex-install QA of v2.21.27 surfaced two low-severity doc/validator items, fixed here.

- **#317** — README "What's New" TOC anchor had drifted to v2.21.12 (~15 releases stale); fixed, and a new `validate-content.sh` Check 19 sub-check derives the slug from `plugin.json` so it can't silently drift again.
- **#316** — `/deploy-guide` Definition of Done regrouped from 10 flat items into 3 grouped checkboxes (Decision / Validation / Post-deploy), every gate preserved as a sub-item; clears the density warning.

## v2.21.27 · Invocation-Aware SKILL-EFFECTIVENESS + Usage≠Revocation Principle

Codifies that skill usage history informs **discoverability and footprint only — never revocation** (#314).

- A 3-layer audit (lessons + memforge + 2,534 transcripts across 53 projects) found **5 of the "14 zero-signal" skills had real external invocation** — Q6 never captured Skill-tool, script, or cross-project runs.
- The maintainer protocol gains a transcript-invocation harvest step (with observer-pipeline + dogfooding discount rules) and a per-skill **Skill class index** (`invoked` / `delegated` / `expected-zero`).
- Revocation now explicitly requires supersession, demonstrated harm, or obsolescence — not low usage.

## v2.21.26 · Codebase-Orientation Skill — Out-of-Scope Record

Closes #311 as T3 (reject) — documents the decision instead of shipping a 25th skill.

- The deferred Understand-Anything "Idea A" (a `/understand-onboard`-style orientation skill) is recorded in `docs/out-of-scope/codebase-orientation-skill.md`.
- Rejected: redundant with the installed `claude-mem` suite (pathfinder / learn-codebase / smart-explore) + low predicted-use frequency; H5-discipline angle fits a guide. Reconsideration conditions included.

## v2.21.25 · SKILL-EFFECTIVENESS Tally Harvest + Anti-Dormancy Gap Close

Maintainer-curated report update — closes a 6-release dormancy gap.

- Harvested 3 `/reflect` Q6 lessons: `/cross-verify` 21→24, `/diagnose` missed_skill 0→1 (first non-zero in that column).
- v2.21.19–v2.21.24 had shipped with no pulse note (past the ADR-018 ≥2-cycle reversal threshold); consolidated note added. Tracks #311 (deferred codebase-orientation surface).

## v2.21.24 · Cross-Platform Frontmatter Rule + Disk-Intermediate Orchestration Precedent

Two engineering lessons from `Egonex-AI/Understand-Anything` (58k★), folded into existing guides — no new skill.

- `guides/vendor-portability.md` bans the Claude-only `model: inherit` keyword (opencode rejects it) while preserving documented model pins like the reviewer agents' `model: opus` (#285).
- `guides/orchestration-patterns.md` Pattern 2 adds a disk-intermediate context-economy precedent.

## v2.21.23 · Diagnose Load Path Portability Fix

Fixes the review blocker F1 and its validator gap F2 (issue #308).

- `/diagnose` Load directives now `${CLAUDE_PLUGIN_ROOT}`-relative — reference and habit files load for every installer.
- New Check 8b fails any absolute-path Load directive so the defect class cannot regress.

## v2.21.22 · Fable Model Review Record

Adds the first standalone review record under `docs/reviews/`.

- Full 8-Habit review of v2.21.21 by the Fable model: score 13/17, verdict fix-then-ship, 21 evidence-cited findings.
- Documentation only; no skill, hook, or validator behavior changes.

## v2.21.21 · CI/CD Proof-Scope Discipline

Adds deploy/CD proof-scope discipline to `/deploy-guide`.

- Proof layers are explicit: configuration, workflow, runner identity, runtime, and release validation.
- Tag-triggered CD fixes require a fresh current-main validation tag before closure.
- Self-hosted jobs must record runner identity and relevant connectivity proof.
- Scope remains guidance and validator pins only; no runner automation or issue mutation.

## v2.21.20 · Codex SessionStart PATH Hardening

Fixes Codex startup hook exit 127 in stripped startup environments.

- `hooks/hooks.json` now seeds a minimal system `PATH` and invokes `/bin/bash` explicitly for the 8-Habit `SessionStart` reminder.
- The packaged plugin mirror carries the same hook manifest fix.
- Scope remains hook manifest portability only; no new enforcement or skill behavior change.

## v2.21.19 · AI Dev Log Snapshot and Trailer Fallback

Makes `/ai-dev-log` stable and reproducible for audit reports that depend on `Co-Authored-By` trailers.

Visible user-facing points:

- `/ai-dev-log` now falls back to commit-body `Co-Authored-By:` trailer lines when Git's trailer formatter returns empty.
- Generated reports record the snapshot boundary used for statistics.
- `--snapshot <sha>` reproduces a previously generated report from its recorded boundary.
- `--out` writes a 0-detected report with limitations instead of exiting before file creation.

Boundary: generator behavior only. No new skill, runtime enforcement, policy gate, hook behavior, or diff/file-content inspection.

## v2.21.18 · Epistemic Footer and Shadow Self-Check

Tightens evidence labeling and self-critique in the verification path.

Visible user-facing points:

- `/cross-verify` now requires the `V/I/U` confidence footer for high-stakes reviews and records open unknowns explicitly.
- `/cross-verify` adds a Shadow Self-Check before recommendation: strongest counter-argument and who is harmed if the verdict is wrong.
- Research briefs gain a mandatory Confidence & Open Unknowns block.
- Integrity principle #7 now uses the shared `V/I/U` vocabulary.

Boundary: markdown guidance only. No runtime enforcement, hook behavior change, new skill, orchestration engine, policy gate, or duplicated `/scrutinize` gate.

## v2.21.17 · Software Ecology Guardrail

Adds lightweight guidance for AI acceleration effects around the engineering system.

Visible user-facing points:

- `/research` now checks review load, validation cost, handoff drift, internal contracts, and human attention when AI acceleration is part of the work.
- `/design` labels `software ecology impact` only when acceleration affects boundaries, API contracts, validation, release, or ownership.
- `/review-ai` checks review burden, validator brittleness, generated-content noise, and contract drift.
- Content validation pins short guardrail phrases without freezing long prose.

Boundary: markdown guidance only. No runtime enforcement, hook behavior change, orchestration engine, policy gate, or Claude/Codex hook parity claim.

## v2.21.16 · Requirements Intake Mode Split

Extends the `/design` claim-discipline work upstream into `/requirements`.

Visible user-facing points:

- `Existing-system mode` tells agents to cite source evidence where available and keep unverifiable statements visible.
- `Idea-mode` tells agents to preserve user intent and label assumptions before treating them as constraints.
- Mixed work keeps confirmed system facts separate from proposed behavior before handing off to `/design`.
- Content validation now pins the mode names and evidence/assumption discipline.

Boundary: markdown guidance only. No new skill, runtime enforcement, template suite, `/build-brief` handoff change, or Claude-only behavior.

## v2.21.15 · SessionStart Dead Variable Cleanup

Removes two ShellCheck SC2034 dead variables from the SessionStart hook without changing rendered reminder behavior.

Visible user-facing points:

- `BRIEF` and `PROGRESS` assignments were removed from `hooks/session-start.sh`.
- Workflow artifact markers still render through the existing inline marker expressions.
- Existing SessionStart regression tests continue to guard root fallback, Codex JSON output, version rendering, and workflow hints.

Boundary: cleanup only. No new hook content, runtime enforcement, policy gate, dynamic orchestration, or broad Claude-hook feature parity claim.

## v2.21.14 · Codex SessionStart Version Fallback

Completes the SessionStart root fallback by making the banner version work in Codex package roots that expose `.codex-plugin/plugin.json` but not `.claude-plugin/plugin.json`.

Visible user-facing points:

- `hooks/session-start.sh` now reads `.claude-plugin/plugin.json` first, then `.codex-plugin/plugin.json`.
- Installed Codex cache smoke renders the real package version instead of `vunknown`.
- Regression coverage builds a fake Codex-only package root and executes the registered SessionStart command.

Boundary: version rendering only. No new hook content, runtime enforcement, policy gate, dynamic orchestration, or broad Claude-hook feature parity claim.

## v2.21.13 · SessionStart Root Fallback

Fixes a startup-path regression where a host invoking the package SessionStart hook without `CLAUDE_PLUGIN_ROOT` could expand the command to `/hooks/session-start.sh` and exit 127.

Visible user-facing points:

- SessionStart command path now resolves from `CLAUDE_PLUGIN_ROOT`, then `CODEX_MANAGED_PACKAGE_ROOT`, then package-root cwd.
- Existing reminder content and Codex JSON output behavior are unchanged.
- Regression coverage executes the registered `hooks/hooks.json` command with `CLAUDE_PLUGIN_ROOT` unset.

Boundary: command-path compatibility only. No runtime enforcement, policy gate, dynamic orchestration, or broad Claude-hook feature parity claim.

## v2.21.12 · QA Polish and Design Wiki Example

Completes the post-release QA polish for the `/design` claim-discipline release.

Visible documentation points:

- Step 2 Design now includes a concrete claim-discipline example with pass level, claim labels, evidence strength, `Verify first: Yes/No`, question priority, and Mermaid traceability guidance.
- `/diagnose` and `/research` Definition of Done lists were compacted to remove existing validator warnings while preserving behavior.
- `/ai-dev-log` now uses `reference.md` for script internals and report-template detail, keeping the main skill body concise.

Boundary: polish only. No new skill, runtime enforcement, hook behavior change, or semantic change to `/diagnose`, `/research`, or `/ai-dev-log`.

## v2.21.11 · Design Architecture Claim Discipline

Improves `/design` so architecture work is right-sized and evidence-labeled before decisions become implementation constraints.

Visible workflow points:

- `/design` now selects `Scan`, `Focus`, or `Full` before producing architecture output.
- Load-bearing architecture claims use labels, evidence strength, and `Verify first: Yes/No`.
- Architecture-impacting questions are prioritized as `Blocking`, `Important`, or `Useful`.
- The ADR template can include optional Architecture Claims and Decisions Requiring Approval sections.

Boundary: markdown guidance only. No new senior-architect skill, runtime enforcement, hook behavior, or platform-specific architecture engine.

## v2.21.10 · Linux Claude Code Install Compatibility

Fixes a Linux Claude Code install failure where the installer could fail while materializing the root `plugin -> .` symlink.

Visible packaging points:

- The repository now uses a real `plugin/` child directory instead of a root self-symlink.
- Codex marketplace installs still use the child-source path through `plugin/.codex-plugin/plugin.json`, with `plugin/skills/` included in the installed package.
- The validator now rejects a symlinked `plugin` path and checks the child Codex manifest.

Boundary: packaging compatibility only. No skill behavior change, runtime enforcement, or hook parity change.

## v2.21.9 · Codex Skill Invocation Guidance

Clarifies how to invoke this plugin's skills from Codex without assuming Claude Code slash-command parity.

Visible documentation points:

- README now separates Claude Code slash usage from Codex skill usage.
- Codex users should select skills through `/skills`, mention a skill such as `$cross-verify`, or ask Codex to use the named skill.
- `docs/codex-integration.md` now has a dedicated Codex Command UX section.
- The compatibility matrix now records skill invocation UX as a runtime-specific surface.

Boundary: documentation-only clarification. No Codex custom prompts, runtime dispatcher, hook parity claim, or skill behavior change.

## v2.21.8 · Opus Reviewer Agents

Moves the two read-only Claude Code reviewer agents to Opus for stronger high-stakes review.

Visible documentation points:

- `agents/8-habit-reviewer.md` now uses `model: opus`.
- `agents/research-verifier.md` now uses `model: opus`.
- README and compatibility docs clarify that this is a Claude Code agent-surface choice, not a Codex subagent parity promise.

Boundary: Claude Code agent model selection only. Codex continues to consume the shared markdown skills.

## v2.21.7 · Issue Tracking and Tracer-Bullet Planning

Adds issue-comment discipline, context-aware requirement grilling, vertical-slice breakdown wording, and a TDD tracer-bullet guide.

Visible documentation points:

- `guides/templates/issue-tracking-comments.md` provides pickup, progress/blocker, and completion comment drafts for issue-based work.
- `/requirements` now challenges glossary conflicts, fuzzy terms, scenarios, code contradictions, and ADR conflicts when repo context exists.
- `/breakdown` now prefers backlog-bound tasks that are independently verifiable vertical slices.
- `/build-brief` can load `guides/tdd-tracer-bullet.md` for TDD, red-green-refactor, or test-first work.
- Codex update-flow docs and GitHub Actions/link-check maintenance commits since v2.21.6 are included in this tag.

Boundary: markdown guidance only. No automatic issue mutation, setup engine, test runner, runtime enforcement, or dynamic orchestration.

## v2.21.6 · Codex SessionStart JSON Compatibility

Fixes Codex v0.137.0 startup compatibility for the package `SessionStart` hook.

Visible documentation points:

- `hooks/session-start.sh` returns valid JSON with `hookSpecificOutput.additionalContext` when Codex invokes the hook.
- Claude/default runs still emit the markdown reminder directly.
- `tests/test-verbosity-hook.sh` now includes a Codex JSON parse smoke test.
- Compatibility docs now describe this as a narrow output adapter rather than Claude hook feature parity.

Boundary: hook-output compatibility only. No runtime enforcement, policy authorization, dynamic orchestration, or general Claude hook port to Codex.

## v2.21.5 · Project Context Contract

Adds optional repo-local context guidance so skills can read glossary, issue-tracker, triage-label, domain-doc, and ADR context before reasoning.

Visible documentation points:

- New `guides/project-context-contract.md` defines optional context files such as `CONTEXT.md`, `CONTEXT-MAP.md`, and `docs/agents/*.md`.
- `/requirements`, `/design`, `/build-brief`, `/diagnose`, and `/scrutinize` now check glossary/context files when present.
- `/breakdown` and the AGENT-BRIEF template now classify backlog-bound work as `ready-for-agent`, `ready-for-human`, or `needs-info`.
- `llms.txt` indexes the guide for cross-agent discovery.

Boundary: markdown guidance only. No setup engine, automatic issue mutation, runtime enforcement, marketplace behavior change, or Claude hook port to Codex.

## v2.21.4 · Release Decision Gate

Adds explicit release classification so maintainers choose release now, bundle later, or no release before version files change.

Visible documentation points:

- `/deploy-guide` now includes a plugin release decision gate.
- `CONTRIBUTING.md` mirrors the same three categories in the release checklist.
- `tests/validate-content.sh` pins the gate so the workflow does not drift back into implicit release decisions.

Boundary: markdown workflow guidance and validation only. No runtime enforcement, marketplace behavior change, skill automation, or Claude hook port to Codex.

## v2.21.3 · Codex Project Context Files

Adds concise repo-local context for Codex and other non-Claude agents.

Visible documentation points:

- `DOMAIN.md` captures invariants, safety rules, data boundaries, and validation expectations.
- `SPEC.md` provides a fast project digest and session re-entry context.
- `.codex/README.md` documents repo-local Codex setup and the Claude-hook boundary.
- `docs/adr/README.md` and ADR-025 record the ADR index and project-context decision.
- `AGENTS.md` and `llms.txt` point agents at these context files.

Boundary: documentation and session ergonomics only. No runtime enforcement, marketplace behavior change, skill behavior change, or Claude hook port to Codex.

## v2.21.2 · Codex Installed-Cache Validator Context

Fixes the Codex installed-cache validator context without changing skill behavior.

Visible documentation points:

- `tests/validate-structure.sh` now accepts the installed-cache shape where Codex omits the source-only `plugin` child because the installed root is already the plugin root.
- Source and marketplace snapshots still require a `plugin` child source for publishability, because the Codex marketplace descriptor points at `./plugin`. In v2.21.2 this was a symlink; v2.21.10 replaces it with a real directory.
- `docs/codex-integration.md` explains when to run source/marketplace validation versus installed-cache validation.

Boundary: packaging validation and documentation only. No runtime enforcement, marketplace behavior change, skill behavior change, or Claude hook port to Codex.

## v2.21.1 · Cross-Agent Evidence Discipline

Adds explicit limitations and release-evidence guidance for cross-agent users.

Visible documentation points:

- New [Limitations](Limitations) page explaining where the plugin helps, what it does not enforce, and what evidence belongs in PR/release proof.
- `docs/compatibility-matrix.md` now compares shared markdown skills, Claude Code packaging, Codex packaging, hooks, memory, enforcement, and release evidence.
- `CONTRIBUTING.md` now asks PRs that affect user-facing doctrine, install, release, generated catalog, or runtime-boundary surfaces to include real behavior proof.
- `tests/validate-structure.sh` now keeps the Limitations page in the required wiki skeleton.

Boundary: documentation and release discipline only. No runtime enforcement, package behavior change, marketplace behavior change, or Claude hook port to Codex.

## v2.21.0 · Cross-Agent Discovery and Portability Contract

Adds a generated skill catalog and documents the shared `SKILL.md` frontmatter contract for Claude Code, Codex, and other markdown-capable agents.

Visible documentation points:

- `docs/data/skills.json` is generated from `skills/*/SKILL.md` for cross-agent discovery.
- `CONTRIBUTING.md`, `guides/skill-authoring.md`, and `docs/compatibility-matrix.md` document required, optional, cross-agent, and Codex-ingestible frontmatter fields.
- `docs/codex-integration.md` and `llms.txt` point tools to the generated catalog.
- `guides/structured-output-protocol.md` adds a compact handoff-integrity note pattern.
- `/review-ai`, `/reflect`, and `guides/quick-reference.md` add observable AI-work health signals such as loops, retries, context compaction, audit evidence, and next-session recovery.

Boundary: generated metadata and markdown guidance only. No runtime dispatcher, no Claude hook port to Codex, no budget enforcement, no policy gate, and no agent-to-agent orchestration protocol.

## v2.20.2 · Production Canary Reconciliation Gates

`/deploy-guide` now covers provider-managed production canaries and capacity changes where the requested canary target and the provider-selected target may differ.

Visible documentation points:

- Precheck, cordon, observation, drain, provider-side change, reconciliation, and postcheck phases.
- Planned target vs actual provider-selected target comparison.
- Desired/min/max capacity, readiness, schedulable capacity, and unintended `SchedulingDisabled` checks.
- Unresolved rollout state routes to `/operational-state`.

Boundary: no cloud execution, policy enforcement, Kubernetes automation, ASG automation, or runtime state engine.

## v2.20.1 · Incident/Config Consistency-Lite

`/consistency-check` now includes a lightweight mode for incident and config hotfix work that does not have persisted spec artifacts.

Visible documentation points:

- Checks symptom, evidence, root cause, actual fix, deploy path, live verification, and drift.
- Flags overclaiming PR/changelog text, missing evidence, scope mismatch, deploy drift, and unclassified adjacent operational state.
- Routes unresolved related findings to `/operational-state`.

Boundary: no runtime enforcement, cloud execution, alert mutation, or automatic issue closure.

## v2.20.0 · Operational State Model

Adds `/operational-state`, a read-only classifier for operational findings.

States:

- Watch
- Fix Candidate
- Active Incident
- Resolved
- Handoff
- Known Accepted Issue
- False Positive
- Self-Resolved

The skill maps each state to evidence, allowed and prohibited actions, approval gates, artifacts, escalation criteria, and closure criteria.

Boundary: no runtime state engine, policy enforcement, cloud execution, alert suppression automation, or automatic production write.

## v2.19.2 · Operational Doctrine Patch

Ships doctrine-only improvements to existing skills:

- `/deploy-guide` classifies deploy type before rollout planning.
- `/security-check` covers more infrastructure and configuration surfaces.
- `/reflect` captures more granular skill-effectiveness feedback.
- `/management-talk` includes an operational incident closure example.

Broader operational model work was intentionally deferred until later releases.

## v2.19.1 · Codex Runtime Compatibility Contract

Clarifies that Codex can install the plugin and load the same markdown skills, but does not run Claude hooks or gain runtime enforcement.

Related docs:

- [`docs/compatibility-matrix.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/compatibility-matrix.md)
- [`docs/codex-integration.md`](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/codex-integration.md)

## v2.19.0 · Native Codex Plugin Packaging

Adds Codex packaging through `.codex-plugin/plugin.json` and `.agents/plugins/marketplace.json` while preserving the Claude Code package.

Install path:

```bash
codex plugin marketplace add pitimon/8-habit-ai-dev
codex plugin add 8-habit-ai-dev@pitimon-8-habit-ai-dev
```

Boundary: same read-only markdown skills, no Claude hook parity, and no runtime enforcement.

## Earlier Releases

For earlier versions, use:

- [Repository changelog](https://github.com/pitimon/8-habit-ai-dev/blob/main/CHANGELOG.md)
- [GitHub releases](https://github.com/pitimon/8-habit-ai-dev/releases)
- [Git tags](https://github.com/pitimon/8-habit-ai-dev/tags)

## See Also

- [Home](Home)
- [Skills Reference](Skills-Reference)
- [Architecture](Architecture)
