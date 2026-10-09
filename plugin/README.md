# 8-Habit AI Dev

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Validation](https://github.com/pitimon/8-habit-ai-dev/actions/workflows/validate.yml/badge.svg)](https://github.com/pitimon/8-habit-ai-dev/actions/workflows/validate.yml)
[![Skills](https://img.shields.io/badge/Skills-24-blue)](skills/RESOLVER.md)
[![Habits](https://img.shields.io/badge/Habits-8-orange)](habits/)
[![Version](https://img.shields.io/badge/Version-2.21.61-brightgreen)](https://github.com/pitimon/8-habit-ai-dev/releases/tag/v2.21.61)
[![Wiki](https://img.shields.io/badge/docs-Wiki-informational)](https://github.com/pitimon/8-habit-ai-dev/wiki)

**A shared development playbook for teams using AI coding agents.** Define success criteria, prepare implementation context, review evidence, and plan deployment before shipping. `8-habit-ai-dev` packages these practices as 24 Markdown skills, grounded in Stephen Covey's 8 Habits.

It installs as a Claude Code or Codex plugin, or as individual Hermes skills. It is an open-source guidance package, **not a hosted or managed service**. Your team retains responsibility for approvals, testing, access control, and production changes.

EU AI Act framework mappings belong to the separate [claude-governance](https://github.com/pitimon/claude-governance) project. This package's `eu-ai-act-check` entry is a redirect, not a compliance assessment or certification.

[Install](#quick-start) · [Team adoption](#team-adoption) · [Runtime boundaries](#runtime-boundaries) · [Skills](#skills-reference) · [Documentation](https://github.com/pitimon/8-habit-ai-dev/wiki) · [Latest release](https://github.com/pitimon/8-habit-ai-dev/releases/latest)

> **ทำเสร็จ ≠ ทำดี**: completing a task is not the same as delivering it with quality.

---

## Table of Contents

- [What your team gets](#the-problem)
- [Install and verify](#quick-start)
- [Runtime boundaries](#runtime-boundaries)
- [Team adoption](#team-adoption)
- [Workflow](#the-7-step-workflow) and [skill catalog](#skills-reference)
- [Use cases](#use-cases-which-skill-when) and [recipes](#end-to-end-recipes)
- [Framework and architecture](#the-8-habits)
- [What's New](#whats-new-in-v22161)
- [Security](#security), [support](#support-and-maintenance), and [contributing](#contributing)
- [FAQ](#faq) and [glossary](#glossary)

---

## The Problem

AI coding agents can produce changes before a team agrees on scope, architecture, or acceptance criteria. This playbook gives developers, reviewers, and technical leads a common process and documented outputs.

Use it to make development decisions inspectable:

| Team need | Skills | Expected output |
| --- | --- | --- |
| Agree on scope before implementation | `research`, `requirements` | Research brief, product requirements, success criteria |
| Keep architecture decisions with people | `design`, `breakdown`, `build-brief` | Decision record, task list, implementation context |
| Review AI-generated work against evidence | `review-ai`, `security-check`, `cross-verify` | Findings, verification status, remaining risks |
| Prepare a controlled release | `deploy-guide`, `monitor-setup` | Deployment and rollback plan, monitoring checklist |
| Preserve learning and communicate outcomes | `post-mortem`, `reflect`, `management-talk` | Root-cause record, lessons, audience-specific update |

These are intended outputs, not automatic guarantees. Skills guide the agent; your repository controls and human review determine whether work can proceed.

---

## Design Principle

The package keeps runtime integration small and loads detailed guidance on demand: **"Thin Harness, Fat Skills"**. Claude Code has a session reminder bounded to 300 tokens; Markdown skills contain the workflow, templates, and handoff instructions.

The repository has no application server or hosted control plane. Consumer skills need no project package installation, but you still need a compatible agent runtime. Repository validation requires Bash, Git, and Node.js.

Read the [runtime compatibility matrix](docs/compatibility-matrix.md) before assuming hooks, agent definitions, or memory behavior transfer between tools.

---

## Quick Start

**Install for Claude Code:**

```bash
claude plugin marketplace add pitimon/8-habit-ai-dev
claude plugin install 8-habit-ai-dev@pitimon-8-habit-ai-dev
```

Verify the package with `claude plugin list`, then restart Claude Code and invoke `/requirements` on a non-production task.

**Install for Codex:**

```bash
codex plugin marketplace add pitimon/8-habit-ai-dev
codex plugin add 8-habit-ai-dev@pitimon-8-habit-ai-dev
```

Verify with `codex plugin list`. Restart Codex, open `/skills`, and select `requirements`. See the [Codex integration guide](docs/codex-integration.md) for update and Windows instructions.

**Install for Hermes Agent** (Hermes tap: individual skills, no plugin manifest layer):

```bash
hermes skills tap add pitimon/8-habit-ai-dev
hermes skills install pitimon/8-habit-ai-dev/skills/cross-verify --category productivity
hermes skills install pitimon/8-habit-ai-dev/skills/requirements --category productivity
# ...repeat per skill you want; see skills/ for the full list.
```

Pass `--category`: Hermes refuses to install a skill whose name matches an existing category folder (for example `research`, if you already have `~/.hermes/skills/research/`).

Hermes installs skills, not a plugin entry in `/plugins`. Follow each installed skill's Hermes substitution note when it references a repository guide.

**Use in Claude Code** (restart Claude Code, then invoke a skill by slash command):

```text
/requirements       # Before you build anything
/review-ai          # Before you commit anything
/cross-verify       # Before you ship anything
/whole-person-check # Assess Body/Mind/Heart/Spirit balance
```

**Use in Codex** (restart Codex after installing; plugin skills are not top-level `/skill` slash commands):

```text
/skills
```

Pick `requirements`, `review-ai`, `cross-verify`, or another installed skill from the selector. You can also mention the skill explicitly in your prompt:

```text
$cross-verify ตรวจแผนนี้ก่อน commit
```

or use plain intent:

```text
Use the cross-verify skill to check this release plan.
```

**Verify Claude Code installation**: After restarting, you should see `## 8-Habit AI Dev Active` in the session banner with the 7-step workflow reminder. For Codex, run `codex plugin list` and confirm `8-habit-ai-dev@pitimon-8-habit-ai-dev` is installed.

**New to the plugin?** Start with `/workflow` for a guided walkthrough, or see [Use Cases](#use-cases-which-skill-when) to find the right skill for your situation.

**Use with OpenClaw:** OpenClaw can load this repository as a compatible skill bundle. Install from a pinned tag, restart the Gateway, and verify the skill snapshot:

```bash
openclaw plugins install git:github.com/pitimon/8-habit-ai-dev@v2.21.61
openclaw gateway restart
openclaw skills list
```

See the [OpenClaw Integration Guide](docs/openclaw-integration.md) for workspace/`extraDirs` loading, allowlists, `{baseDir}` references, and the runtime boundary. OpenClaw does not run this repository's Claude hooks or provide runtime enforcement.

**The Core 5 (recommended starting set)**: `/requirements` · `/review-ai` · `/cross-verify` · `/research` · `/reflect`. This is an onboarding recommendation, not a measured coverage percentage.

### Runtime boundaries

Shared Markdown skills do not mean identical runtime features:

| Runtime | Install and invocation | Boundary |
| --- | --- | --- |
| Claude Code | Plugin; slash commands | Claude-specific session hook and reviewer definitions |
| Codex | Native plugin; `/skills`, `$skill-name`, or intent | No plugin-provided top-level skill slash commands; narrow SessionStart output adapter only if the host invokes it |
| Hermes Agent | Skills Hub tap; individual installed skills | No Claude hooks or installed AGENTS.md/CLAUDE.md doctrine; `${CLAUDE_PLUGIN_ROOT}` does not resolve, so follow the skill's substitution URL |
| OpenClaw | Pinned compatible bundle or workspace loading | No Claude hooks; real-install verification remains open in [#413](https://github.com/pitimon/8-habit-ai-dev/issues/413) |
| Other agents | Read [AGENTS.md](AGENTS.md), then [skills/RESOLVER.md](skills/RESOLVER.md) | Manual guidance loading, not a native integration promise |

Do not create Hermes quick-command aliases named after skills: they can capture exact skill commands. See [Troubleshooting](https://github.com/pitimon/8-habit-ai-dev/wiki/Troubleshooting), the [compatibility matrix](docs/compatibility-matrix.md), and [Limitations](https://github.com/pitimon/8-habit-ai-dev/wiki/Limitations).

### Keeping the plugin updated

This plugin is maintained through regular releases. Check the [GitHub Releases](https://github.com/pitimon/8-habit-ai-dev/releases), the [wiki changelog](https://github.com/pitimon/8-habit-ai-dev/wiki/Changelog), or the "What's New" sections below to see recent changes.

**Claude Code:**

```bash
claude plugin update 8-habit-ai-dev@pitimon-8-habit-ai-dev
```

Restart Claude Code after updating so hook and skill changes are loaded.

**Codex:**

Codex currently has no `codex plugin update` command. Refresh the Git marketplace snapshot, then reinstall the plugin from that refreshed snapshot:

```bash
codex plugin marketplace upgrade pitimon-8-habit-ai-dev
codex plugin list
codex plugin remove 8-habit-ai-dev@pitimon-8-habit-ai-dev
codex plugin add 8-habit-ai-dev@pitimon-8-habit-ai-dev
codex plugin list
```

Use `codex plugin marketplace list` if you need to confirm the configured marketplace name.

---

## Team adoption

Start with a pilot repository and expand after your team has reviewed the resulting artifacts. The steps below are adoption recommendations, not controls enforced by the plugin.

1. **Assign an owner.** A technical lead selects the runtime, skill set, and version. A reviewer evaluates outputs independently of the author.
2. **Choose a bounded task.** Use a non-production feature or maintenance change with existing tests. Record the current process before the pilot.
3. **Define done before implementation.** Use `requirements` for acceptance criteria and `build-brief` for codebase context. Keep architecture decisions with the team.
4. **Apply your existing controls.** Keep branch protection, continuous integration (CI), security scans, staging, and change approval in place. Skill verdicts do not replace them.
5. **Review pilot evidence.** Record whether requirements were clear, findings were actionable, and handoffs preserved context. Track rework and review effort without assuming productivity gains.
6. **Expand deliberately.** Use `reflect` to capture lessons, then update the team's onboarding and change-review process.

### Responsibilities and boundaries

| Area | Package contribution | Team responsibility |
| --- | --- | --- |
| Development process | Reusable instructions, templates, and handoff guidance | Choose task scope, accept requirements, and decide architecture |
| Quality review | Structured findings and evidence prompts | Run tests, verify cited evidence, and approve changes |
| Deployment | Planning, rollback, and monitoring guidance | Authorize and execute production changes through existing controls |
| Security and data | [Security policy](SECURITY.md) and [threat model](docs/security/threat-model.md) | Evaluate agent/provider data handling and access permissions; keep secrets out of artifacts |
| Release management | Versioned Git tags, release notes, and validation workflows | Record the deployed package version and test updates before rollout |
| Support | Public documentation and issue tracking | Provide internal support, ownership, and escalation routes |

**Not included:** a hosted control plane, organization-wide policy enforcement, compliance certification, tenant isolation, or a contractual service-level agreement (SLA). Companion tools are separate products; installing this package does not establish those assurances.

### Rollout and update checks

Record the plugin version and agent runtime version used in the pilot. Marketplace installs can follow moving snapshots; they are not automatically pinned deployments. Review [release notes](https://github.com/pitimon/8-habit-ai-dev/releases) and the [compatibility matrix](docs/compatibility-matrix.md) before updating. Verify the installed listing and run a representative task before expanding the rollout.

If an update changes behavior unexpectedly, pause adoption and follow your runtime's supported reinstall or version-selection procedure. Reverting repository source alone does not revert an installed agent cache. See the [installation guide](https://github.com/pitimon/8-habit-ai-dev/wiki/Installation) and [Codex update guide](docs/codex-integration.md#update).

---

## The 7-Step Workflow

The workflow has seven delivery steps (1–7), preceded by research (Step 0). Each step maps to a habit explaining why it matters. Use only the steps relevant to the task.

```text
Step 0          Step 1          Step 2         Step 3
/research  ───→ /requirements ─→ /design  ────→ /breakdown
H5:Understand   H2:End in Mind   H8:Find Voice  H3:First Things

Step 4          Step 5          Step 6         Step 7
/build-brief ─→ /review-ai ───→ /deploy-guide → /monitor-setup
H5:Understand   H4:Win-Win      H1:Proactive   H7:Sharpen Saw
```

Start with `requirements` before building and `review-ai` before committing. In Claude Code, invoke `/requirements` and `/review-ai`; in Codex, select them through `/skills`, mention `$requirements` / `$review-ai`, or ask by intent. The implementation stage remains your coding agent's work, not a self-executing skill.

---

## Skills Reference

Skill names below use Claude Code slash notation because that is the shortest label for the skill corpus. In Codex, these are installed skills, not plugin-provided top-level slash commands. Use `/skills`, mention the skill such as `$cross-verify`, or ask Codex to use the named skill.

### Workflow Skills (Steps 0-7)

| Skill            | Step | Habit                        | Purpose                                                                                                     |
| ---------------- | ---- | ---------------------------- | ----------------------------------------------------------------------------------------------------------- |
| `/research`      | 0    | H5: Seek First to Understand | Investigate with depth levels (Quick/Standard/Deep), modes (General/Compare/Audit), and source verification |
| `/requirements`  | 1    | H2: Begin with End in Mind   | Draft PRD — what, why, who, scope, success criteria                                                         |
| `/design`        | 2    | H8: Find Your Voice          | Surface architecture decisions for **human** judgment                                                       |
| `/breakdown`     | 3    | H3: Put First Things First   | Decompose into atomic tasks, prioritize by importance                                                       |
| `/build-brief`   | 4    | H5: Seek First to Understand | Problem statement gate + context brief before implementing                                                  |
| `/review-ai`     | 5    | H4: Think Win-Win            | 4-level verdict (PASS/CONCERNS/REWORK/FAIL) + dimension balance                                             |
| `/deploy-guide`  | 6    | H1: Be Proactive             | Staging-first deployment with rollback, plus provider reconciliation gates for production canaries          |
| `/monitor-setup` | 7    | H7: Sharpen the Saw          | Set up health checks, alerting, error tracking                                                              |

### Assessment Skills (Use Anytime)

The full catalog below includes 16 additional entries, including the `eu-ai-act-check` redirect stub. For onboarding, start with the Core 5 above; use `/using-8-habits` or the [resolver](skills/RESOLVER.md) when choosing the next skill.

<details>
<summary>Expand the assessment, investigation, and communication catalog</summary>

| Skill                 | Habit               | Purpose                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| --------------------- | ------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `/cross-verify`       | H1-H8               | 17-question checklist + dimension summary (Body/Mind/Heart/Spirit)                                                                                                                                                                                                                                                                                                                                                                                                                           |
| `/consistency-check`  | H5 + H1             | Cross-artifact analyzer over persisted PRD↔design↔tasks, plus incident/config hotfix mode for symptom↔evidence↔root-cause↔fix↔verification drift (v2.20.1)                                                                                                                                                                                                                                                                                                                                   |
| `/operational-state`  | H1 + H5 + H8        | **Operational finding classifier** — choose Watch, Fix Candidate, Active Incident, Resolved, Handoff, Known Accepted Issue, False Positive, or Self-Resolved before action. Maps evidence, allowed/prohibited actions, approval gates, artifacts, escalation criteria, and closure criteria. Read-only guidance; no runtime state engine or production mutation.                                                                                                                             |
| `/whole-person-check` | H8: Find Your Voice | 4-dimension assessment (1-5 scale) with AI Blind Spot detection                                                                                                                                                                                                                                                                                                                                                                                                                              |
| `/security-check`     | H1: Be Proactive    | Focused OWASP security lens — secrets, injection, auth, deps                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| `/reflect`            | H7: Sharpen the Saw | 5-question micro-retrospective (5 min max) with action tracking                                                                                                                                                                                                                                                                                                                                                                                                                              |
| `/workflow`           | All                 | Guided 7-step walkthrough — invoke or skip each step                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| `/calibrate`          | H8: Find Your Voice | Self-assessment (5-7 questions) → writes `~/.claude/habit-profile.md` so other skills adapt verbosity to your maturity level                                                                                                                                                                                                                                                                                                                                                                 |
| `/using-8-habits`     | H5 + H8             | Onboarding meta-skill — all 24 skills + decision tree for "which skill next?"                                                                                                                                                                                                                                                                                                                                                                                                                |
| `/eu-ai-act-check`    | H1 + H8 (Spirit)    | Redirect stub — migrated to [`pitimon/claude-governance`](https://github.com/pitimon/claude-governance) v3.1.0+ on 2026-05-02 (ADR-012). Install that plugin for the canonical 9-obligation checklist.                                                                                                                                                                                                                                                                                       |
| `/ai-dev-log`         | H4 + H1             | Generate AI-assisted dev log from git history for audit trail                                                                                                                                                                                                                                                                                                                                                                                                                                |
| `/save-spec`          | H8 + H2             | **Deployment-mode helper (not a workflow step)** — scaffold a project-root `SPEC.md` digest when the repo fits the project-orientation hub mode. Generator-only Phase 1 (v2.16.0); refuses to overwrite. **Skip if you already have a memory-MCP + short `CLAUDE.md`** (v2.16.4 — see `/save-spec` "When to Skip" for details)                                                                                                                                                               |
| `/diagnose`           | H1 + H5             | **Active bug investigation** — 6-phase methodology (feedback-loop → reproduce → hypothesise → instrument → fix-with-regression-test → cleanup). Closes the gap between research (too broad) and post-mortem (too late). Phase 1 (feedback-loop-first) enforced before hypothesis generation. Hands off to post-mortem once fix lands. Adapt-with-attribution from [mattpocock/skills](https://github.com/mattpocock/skills) SHA `b8be62ff` (v2.18.0, ADR-015 — n=1 friction-driven adoption) |
| `/post-mortem`        | H4 + H7             | **Engineering RCA writeup** — canonical record of a fixed bug (root cause, mechanism, fix, validation, how it slipped through). Refuses to draft without 4 inputs (reliable repro, known cause, identified fix, validated outcome). Inspired by [9arm-skills](https://github.com/thananon/9arm-skills) (v2.17.0)                                                                                                                                                                             |
| `/scrutinize`         | H5 + H8             | **Outsider-perspective review** — questions whether the change should exist at all (Step 1) before line-by-line review. Pairs with review-ai (scope-question vs diff-local). 4-step workflow: Intent → Trace → Verify → Report. Inspired by [9arm-skills](https://github.com/thananon/9arm-skills) (v2.17.0)                                                                                                                                                                                 |
| `/management-talk`    | H4 + H6             | **Channel-aware audience reshape** — engineer-to-engineer content → leadership channel (JIRA / Slack / standup / email / meeting). Strips function/file/SHA but keeps JIRA keys, PR numbers, workload names. Inspired by [9arm-skills](https://github.com/thananon/9arm-skills) (v2.17.0)                                                                                                                                                                                                    |

---

</details>

## Use Cases: Which Skill When?

Start from **your situation**, not the skill name.

| I want to...                                  | Start with                                                                                                                                                                                                          | Then                                   | Habit                             |
| --------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------- | --------------------------------- |
| Build a new feature from scratch              | `/requirements`                                                                                                                                                                                                     | `/design` → `/breakdown`               | H2: Define done first             |
| Review code before committing                 | `/review-ai`                                                                                                                                                                                                        | `/security-check` if needed            | H4: Never skip review             |
| Understand an unfamiliar codebase             | `/research`                                                                                                                                                                                                         | `/build-brief`                         | H5: Read before writing           |
| Deploy / provider canary                      | `/deploy-guide`                                                                                                                                                                                                     | `/monitor-setup`                       | H1: Stage, rollback, reconcile    |
| Assess overall project health                 | `/cross-verify`                                                                                                                                                                                                     | `/whole-person-check`                  | All 8 habits                      |
| Classify an operational finding               | `/operational-state`                                                                                                                                                                                                | `/deploy-guide` or `/post-mortem`      | H1 + H5 + H8                      |
| Fix a production bug                          | `/diagnose`                                                                                                                                                                                                         | Fix + regression test → `/post-mortem` | H5 + H1: Reproduce before fixing  |
| Investigate a hard bug (no obvious cause)     | `/diagnose`                                                                                                                                                                                                         | `/post-mortem` → `/reflect`            | H1 + H5: Loop before guessing     |
| Question whether a change should exist at all | `/scrutinize`                                                                                                                                                                                                       | `/review-ai` for diff-local            | H5 + H8: Intent before diff       |
| Brief leadership on engineering work          | `/management-talk`                                                                                                                                                                                                  | (channel-aware reshape)                | H4 + H6: Right signal per channel |
| Something feels off about a plan              | `/cross-verify`                                                                                                                                                                                                     | Check dimension scores                 | H1-H8                             |
| Learn the full workflow                       | `/workflow`                                                                                                                                                                                                         | (guided walkthrough)                   | All                               |
| Survive `/clear` and `/compact`               | See [`guides/spec-digest-pattern.md`](guides/spec-digest-pattern.md) (project-orientation hub) or [`current-state.md`](guides/persistence-convention.md#current-state-file-optional-user-owned) (feature-spec mode) | Adopt one based on repo archetype      | H5: Understand first              |

### Recommended Paths

**Starting workflow** — `/requirements` before building + `/review-ai` before committing. Add further steps when the task warrants them.

**Full Workflow** — `/research` through `/monitor-setup` via `/workflow`. For new features or greenfield projects.

**Quality assessment** — `/cross-verify` + `/whole-person-check`. Use before a pull request or release; your team's controls determine approval.

For the full 15-situation map, see [`guides/situation-map.md`](guides/situation-map.md).

---

## End-to-End Recipes

<details>
<summary>Expand six worked sequences for features, reviews, incidents, research, context, and leadership updates</summary>

The table above answers _"which skill?"_. These recipes answer _"how do I actually drive a whole situation?"_ — copy-paste sequences that chain skills (and, where it pays off, the plugin's read-only `8-habit-reviewer` agent — or an independent-model QA pass, if you run one). Names use Claude Code slash notation; in Codex, invoke the same skills via `/skills` or `$skill-name`. Mix, skip, and extend them for your own project — the discipline is the chain (**define → build → verify**), not any single skill.

### R1 — Ship a new feature without vibe-coding

```text
/requirements   → PRD: what / why / who + EARS success criteria
/design         → architecture decisions surfaced for YOUR judgment
/breakdown      → atomic tasks, no scope creep
( build )
/review-ai      → PASS / CONCERNS / REWORK / FAIL verdict before commit
/cross-verify   → 17-question gate across Body / Mind / Heart / Spirit
```

**Expected outcome:** acceptance criteria are defined before implementation and reviewed before commit. For a bounded task, start with `/requirements` and `/review-ai`; they address undefined scope and unreviewed output. — **H2 + H4**

### R2 — Audit AI-generated code before merge (independent gate)

```text
/review-ai          → builder-side self-review of the diff
/security-check     → OWASP lens: secrets, injection, auth, dependencies
8-habit-reviewer    → ask Claude to run this read-only agent — separate eyes on the same diff
```

**You get:** the model that wrote the code isn't the only one grading it — a separate reviewer catches what self-review rationalizes as "probably fine." For an even stronger gate, add an independent-model pass (e.g. an external Codex QA loop — _not_ shipped with this plugin), and always grep any reviewer's cited `file:line` before acting on it. — **H4 + H1**

### R3 — Investigate a hard production bug

```text
/diagnose     → feedback-loop FIRST → reproduce → hypothesise → fix + regression test
/post-mortem  → engineer-audience RCA (refuses to draft without a real repro)
/reflect      → capture the lesson so the whole class of bug is caught earlier next time
```

**You get:** a fix backed by a durable regression test, not a one-off `curl` that proves nothing tomorrow. `/diagnose` refuses to skip the feedback loop — guessing-before-loop is the anti-pattern it exists to prevent. — **H1 + H5 + H7**

### R4 — Decide whether to adopt an external pattern or library

```text
/research deep   (Audit mode)  → does our code ALREADY do this? where is the real gap?
( friction-first gate )        → adopt only with a cited first-person need, not "looks nice"
/cross-verify                  → pressure-test the recommendation before committing
→ if rejected: record it in docs/out-of-scope/ with explicit reversal conditions
```

**You get:** you avoid bolting on attractive-but-redundant machinery, and every _"no"_ is documented so the next person doesn't re-litigate it. _(This repo's own `docs/out-of-scope/grill-with-docs-glossary.md` was produced by exactly this recipe.)_ — **H5 + H7**

### R5 — Survive `/clear` and `/compact` without losing context

```text
/save-spec                       → scaffold a project-root SPEC.md digest (hub mode)
guides/spec-digest-pattern.md    → project-orientation hub, for larger repos
current-state.md                 → lightweight save point for in-flight feature work
```

**You get:** the next session re-orients from a durable file instead of re-deriving everything from scratch. Pick the archetype that fits your repo — don't adopt both. — **H5 + H2**

### R6 — Reshape an engineering update for leadership

```text
/management-talk  → eng-to-eng content → JIRA / Slack / standup / email / meeting
```

**You get:** function/file/SHA noise stripped, but JIRA keys, PR numbers, and workload names kept — the channel-appropriate signal, not a wall of implementation detail. — **H4 + H6**

> Recipes are starting points, not rails. The value is the verification chain, not ceremony — escalate to `/cross-verify` or an independent reviewer when an action is irreversible, and keep it light when it isn't.

</details>

---

## The 8 Habits

Based on Stephen Covey's _The 7 Habits of Highly Effective People_ and _The 8th Habit: From Effectiveness to Greatness_. This package adapts those principles to AI-assisted development; it is not a compliance standard.

<details>
<summary>Expand the habits, maturity model, assessments, reviewers, and architecture</summary>

### Private Victory (Self-Management)

| Habit                                                             | Principle                   | In Practice                                                                            |
| ----------------------------------------------------------------- | --------------------------- | -------------------------------------------------------------------------------------- |
| **H1**: [Be Proactive](habits/h1-be-proactive.md)                 | Act on what you can control | Trace all callers of a bug fix, handle edge cases, update docs _during_ implementation |
| **H2**: [Begin with End in Mind](habits/h2-begin-with-end.md)     | Define done before starting | Write success criteria and test plans _before_ the first prompt                        |
| **H3**: [Put First Things First](habits/h3-first-things-first.md) | Important over interesting  | Tests and CI gates prevent future crises — don't skip them for speed                   |

### Public Victory (Collaboration)

| Habit                                                             | Principle                      | In Practice                                                                         |
| ----------------------------------------------------------------- | ------------------------------ | ----------------------------------------------------------------------------------- |
| **H4**: [Think Win-Win](habits/h4-win-win.md)                     | Every interaction is a deposit | Error messages that help, issue closures with rationale, actionable review feedback |
| **H5**: [Seek First to Understand](habits/h5-understand-first.md) | Read before you write          | Understand existing code and patterns before proposing changes                      |
| **H6**: [Synergize](habits/h6-synergize.md)                       | Together > apart               | Human judgment + AI execution. Parallel agents for independent tasks                |

### Renewal & Significance

| Habit                                               | Principle                     | In Practice                                                          |
| --------------------------------------------------- | ----------------------------- | -------------------------------------------------------------------- |
| **H7**: [Sharpen the Saw](habits/h7-sharpen-saw.md) | Invest in capability          | Monitor production, track tech debt, automate what you learned       |
| **H8**: [Find Your Voice](habits/h8-find-voice.md)  | From effective to significant | Understand _why_ before implementing. Share patterns. Empower others |

### The Maturity Model

```
Dependence → Independence → Interdependence → Significance
```

| Stage           | Mindset              | AI Relationship                         |
| --------------- | -------------------- | --------------------------------------- |
| Dependence      | "AI writes my code"  | Blind acceptance, no review             |
| Independence    | "I use AI as a tool" | Selective adoption, human judgment      |
| Interdependence | "We build together"  | Complementary strengths, shared process |
| Significance    | "We empower others"  | Publishing patterns, raising the bar    |

---

## Cross-Verification

The `/cross-verify` skill runs **17 questions** across all 8 habits, with **dimension mapping** (Body/Mind/Heart/Spirit) and **scoring bands**.

| Category        | Questions   | Dimensions   | Habits                                          |
| --------------- | ----------- | ------------ | ----------------------------------------------- |
| Private Victory | 8 questions | Body, Mind   | H1 (scope), H2 (criteria), H3 (priority)        |
| Public Victory  | 6 questions | Mind, Heart  | H4 (feedback), H5 (understanding), H6 (synergy) |
| Renewal         | 3 questions | Body, Spirit | H7 (learning), H8 (meaning)                     |

**Scoring Bands**: 15-17 (proceed) → 12-14 (address gaps) → 8-11 (revisit plan) → <8 (stop and rethink)

**Confidence Levels** _(v1.9.0)_: For high-stakes reviews, mark each Pass as ✓V (Verified), ✓I (Inferred), or ✓U (Unverified) — inspired by [Feynman's](https://github.com/getcompanion-ai/feynman) honest uncertainty principle.

**Domain Packs**: Optional question sets for [API](guides/cross-verify-packs/api.md), [Frontend](guides/cross-verify-packs/frontend.md), [Infrastructure](guides/cross-verify-packs/infra.md), [AI/ML](guides/cross-verify-packs/ai-ml.md), and [Mobile](guides/cross-verify-packs/mobile.md) work.

Full checklist: [guides/cross-verification.md](guides/cross-verification.md)

---

## Whole Person Assessment

The `/whole-person-check` skill evaluates work across four dimensions. Use the dimensions to ask questions that code-level tests do not address.

| Dimension               | Review focus                                | Team attention      |
| ----------------------- | ------------------------------------------- | ------------------- |
| **Body** (Discipline)   | CI, tests, monitoring, quality checks      | Verify execution and outcomes |
| **Mind** (Vision)       | Architecture, decision records, roadmap    | Evaluate trade-offs and ownership |
| **Heart** (Passion)     | Craft, error messages, user experience      | Review usability and empathy |
| **Spirit** (Conscience) | Security, ethics, compliance considerations | Apply human judgment and applicable controls |

The framework treats Heart and Spirit as areas requiring explicit human attention. The table is a review lens, not a measured benchmark of agent capabilities.

A worked example (a REST-API feature scorecard), the maturity rubrics, and the plugin's own progression chart are in [`docs/wiki/Whole-Person-Assessment.md`](docs/wiki/Whole-Person-Assessment.md).

---

## Agents

The plugin includes two specialized agents — **read-only reviewers** that analyze without modifying your code.

### 8-habit-reviewer

Deep cross-verification reviewer. Evaluates plans, implementations, or PRs against all 8 habits.

- **When it runs**: Invoked by `/cross-verify` or manually via the Agent tool
- **What it produces**: Score out of 17, dimension summary, failed items with `file:line` evidence
- **Tools**: Read, Glob, Grep (read-only)

### research-verifier

Source verification agent _(v2.1.0)_. Validates every citation in a research brief.

- **When it runs**: Automatically during `/research` Deep mode
- **What it produces**: Verification report — Verified / Dead / Not Found / Redirected per source
- **Tools**: Read, Glob, Grep, WebFetch (read-only)
- **Principle**: Feynman standard — _"The first principle is that you must not fool yourself"_

Both Claude Code agent definitions use the `opus` model because they run high-stakes review and citation-integrity gates. This model selection is a Claude Code agent surface; Codex still consumes the shared markdown skills and does not gain Claude subagent model parity from this setting.

---

## Architecture

See an illustrative repository file tree in [`docs/wiki/Architecture.md`](docs/wiki/Architecture.md) — per-skill step/habit mappings are in the [Skills Reference](#skills-reference) table above.

**Design decisions:**

- **Skills are empowering, not restrictive** — reminders and tools, not blocking gates
- **Habit content loaded on-demand** — skills reference `habits/*.md` only when invoked, keeping session context lean
- **Session hook under 300 tokens** — light reminder with progress indicators, not a wall of text
- **Handoff contracts** — each skill declares what it expects from its predecessor and produces for its successor
- **Definition of Done** — every skill has 3-5 verifiable checkbox items
- **When to Skip** — honest conditions prevent compliance theater (H8: contribution over compliance)
- **Output templates** — structured formats for PRD, ADR, task list, review report, research brief
- **Dimension mapping** — all 17 cross-verify questions tagged with Body/Mind/Heart/Spirit
- **No consumer package dependencies** — Markdown skills do not require an npm or pip install in your project. A compatible agent runtime is still required. Contributor validation uses Bash, Git, and Node.js; Windows validation uses Git Bash via `scripts/windows-preflight.ps1`.

---

## Companion Plugins

`8-habit-ai-dev` works **standalone** — no hard dependency. For higher-assurance projects, it composes with two companion plugins (also by pitimon):

| Plugin              | Layer                                                              | When to add                                         |
| ------------------- | ------------------------------------------------------------------ | --------------------------------------------------- |
| `claude-governance` | Policy / Enforcement (fitness functions, ADRs, compliance)         | When you need durable policy + audit trail          |
| `devsecops-ai-team` | Operational tooling (SAST/DAST/SCA/Container/IaC + SBOM/AIBOM/VEX) | When you need automated scans or regulator evidence |

**Single source of truth for integration:** see [`docs/INTEGRATION.md`](docs/INTEGRATION.md) — covers layer map, choosing-your-stack matrix, integration points, Three Loops asymmetry, EU AI Act scope split, and suggested integrated flow.

The repository records an integration baseline of `claude-governance` 3.3.0 and `devsecops-ai-team` 10.12.0+. This is not a current-version compatibility guarantee; verify your installed versions separately.

> **Naming note (v2.16.5)**: in `devsecops-ai-team` v10.12.0, the `/workflow` skill was renamed to `/security-workflow` to resolve a cross-plugin naming collision with this plugin's `/workflow` (the 7-step Covey practice). If you have both plugins installed, type `/workflow` for the 7-step walkthrough or `/security-workflow` for devsecops's scan orchestration. Legacy `/workflow` in devsecops continues as a deprecation stub through v10.x (removed in v11.0.0). See devsecops ADR-014.

</details>

---

## What's New in v2.21.61

**Theme: CI catches dangling same-repo links before merge**

- A network-free validator checks self-referential `/main/` URLs in tracked Markdown and `llms.txt` against exact Git index paths and existing working-tree targets (#423). This closes the link-check exclusion that missed the broken EU AI Act pointer fixed in #419.
- Zero-match scans and Git/grep errors fail closed. An isolated 15-case regression matrix runs in the same CI step; candidate fixtures passed on Bash 3.2.57 and 5.2.21, and the original dead link was rejected.
- Encoded, space-containing and non-ASCII path support remains deferred to [#424](https://github.com/pitimon/8-habit-ai-dev/issues/424). Current literal-path links pass; this is contributor validation, not new runtime enforcement or skill behavior.

---

### Previous releases

Read [CHANGELOG.md](CHANGELOG.md) for the version history or [GitHub Releases](https://github.com/pitimon/8-habit-ai-dev/releases) for published release notes. Earlier summaries are not repeated here.

---

## Not a Checklist

> Checklists create compliance theater — people tick boxes without understanding why.

These are **principles** that change how you think:

- You don't "apply H5" — you develop the instinct to **read before writing**
- You don't "check H3" — you naturally **prioritize tests over gold-plating**
- You don't "follow H8" — you genuinely ask **"does this help someone?"**

The cross-verification exists for planning reviews, not as a gate for every commit.

---

## Origin

The framework originated in work on [MemForge](https://github.com/pitimon/memforge). Its project history motivated practices such as staging before production, review before commit, and validation before deployment. Historical examples are not product performance measurements:

- **H1**: A deploy bypassed staging and went straight to production (now there's a mandatory staging-first rule)
- **H4**: Code reviews were skipped "just this once" — 2 CRITICAL and 3 HIGH issues shipped (now review-before-commit is enforced)
- **H7**: Monitoring was the weakest step across 3 projects — a systematic blind spot we only caught through cross-project analysis
- **H5**: A database password mismatch crashed production because nobody validated the .env file before deploying

Those lessons motivate the guidance; the plugin does not itself enforce the example project's controls.

---

## FAQ

**Q: Do I need to use all 24 skills for every task?**
No. Start with `/requirements` before building and `/review-ai` before committing. Add skills when the task needs them. See [Use Cases](#use-cases-which-skill-when).

**Q: What is "Vibe Coding"?**
Building software by feel — jumping straight to "build me X" without requirements, design, or review. AI tools amplify this tendency because they make coding feel effortless. This plugin provides structure without removing speed.

**Q: How is this different from a linter or CI tool?**
Linters check syntax. CI checks tests. This plugin checks _process_ — did you define success criteria? Did you review before committing? Did you consider security? It operates at the planning and judgment layer, not the code layer.

**Q: What does "ทำเสร็จ ≠ ทำดี" mean?**
Thai: "Done is not done well." Completing a task (ทำเสร็จ) is not the same as completing it with quality (ทำดี). This principle is the plugin's core identity — speed without discipline creates debt.

**Q: Can I use this without Claude Code?**
Yes. v2.19.0 adds native Codex packaging via `.codex-plugin/plugin.json` and `.agents/plugins/marketplace.json`. Other agent platforms can still load `skills/<name>/SKILL.md` manually; start at [AGENTS.md](AGENTS.md).

**Q: What are the "Whole Person dimensions"?**
Covey's model: Body (discipline/quality), Mind (vision/architecture), Heart (craft/empathy), Spirit (conscience/ethics/security). Use these as complementary review perspectives, not a benchmark or certification. See the [Whole Person Assessment guide](docs/wiki/Whole-Person-Assessment.md).

**Q: How do the agents work?**
The [8-habit-reviewer](agents/8-habit-reviewer.md) and [research-verifier](agents/research-verifier.md) are read-only Claude Code agent definitions. They analyze work and produce reports without modifying project files. Other runtimes do not gain these agent definitions merely by loading the Markdown skills.

**Q: Is this plugin opinionated?**
Yes. The package prioritizes requirements, human judgment, evidence-based review, and controlled deployment. These are development recommendations, not claims of measured productivity or universal enforcement. See [Origin](#origin).

---

## Glossary

Key terms — Vibe Coding, Handoff Contract, AI Blind Spot, Whole Person Model, Domain Pack, Fitness Function, and more — are defined in [`docs/wiki/Glossary.md`](docs/wiki/Glossary.md).

---

## Alternative Setup (Without Plugin)

If you prefer not to install the plugin in Claude Code or Codex, you can use the rules file directly:

```bash
# Install rules only (no skills, no hooks)
mkdir -p ~/.claude/rules
curl -sL https://raw.githubusercontent.com/pitimon/8-habit-ai-dev/main/rules/effective-development.md \
  -o ~/.claude/rules/effective-development.md
```

This auto-loads the 8-Habit principles into every Claude Code session without the skills or hooks. For other agents, load [AGENTS.md](AGENTS.md), then use [skills/RESOLVER.md](skills/RESOLVER.md) to pick the right `SKILL.md`.

---

## Security

This package has no hosted service, API, or database. It includes Markdown guidance, Claude-specific shell hooks, and helper scripts. Review the supply-chain risks of skill, hook, rule, and script content, including the opt-in `hooks/pre-commit.sh.example`.

The agent runtime determines which tools execute and how prompts or files reach a model provider. This package does not provide a data-residency guarantee or isolate sensitive project information. Do not put credentials, raw customer data, or private operational evidence in shared artifacts.

- 📄 [**Security Policy**](SECURITY.md) — how to report a vulnerability (private disclosure; please do **not** open a public issue).
- 🛡️ [**Threat Model**](docs/security/threat-model.md) — STRIDE for a markdown-only plugin, trust boundaries, and an honest list of controls not yet present.

---

## Support and maintenance

Use the [wiki](https://github.com/pitimon/8-habit-ai-dev/wiki), [FAQ](https://github.com/pitimon/8-habit-ai-dev/wiki/FAQ), and [troubleshooting guide](https://github.com/pitimon/8-habit-ai-dev/wiki/Troubleshooting) for setup and usage. For reproducible bugs or feature requests, open a [GitHub issue](https://github.com/pitimon/8-habit-ai-dev/issues) with the package version, agent/runtime version, expected behavior, and sanitized reproduction steps.

Support is through the public repository, not a contractual service desk. No response-time or resolution-time commitment is published here. Report vulnerabilities privately using [SECURITY.md](SECURITY.md), not public issues.

## Contributing

Found a habit that worked (or broke) in your AI-assisted development? PRs welcome.

See **[CONTRIBUTING.md](CONTRIBUTING.md)** for the full guide — skill authoring conventions, blank templates, and quality checklist.

Quick options:

- **Add a new skill** — follow the template in CONTRIBUTING.md
- **Add real examples** to `habits/*.md` files
- **Add domain question packs** in `guides/cross-verify-packs/`
- **Report issues** at [GitHub Issues](https://github.com/pitimon/8-habit-ai-dev/issues)

For repository changes, validate from a full Git checkout with tag history. Install Bash, Git, and Node.js, then run:

```bash
bash scripts/sync-mirror.sh
bash tests/ci-local.sh
node scripts/generate-skill-catalog.js --check
```

The local runner tracks the hosted validation suite. Source checks cover structure, mirrors, links, metadata, and selected hook behavior; they do not prove every agent follows the workflow. Consult [AGENTS.md](AGENTS.md) before editing and [CONTRIBUTING.md](CONTRIBUTING.md) for release conventions.

## License

MIT

---

_Version: 2.21.61 | Last updated: 2026-10-09_
