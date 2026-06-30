# 8 Habits of Effective AI-Assisted Development

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Claude Code Plugin](https://img.shields.io/badge/Claude_Code-Plugin-7C3AED)](https://github.com/pitimon/8-habit-ai-dev)
[![Skills](https://img.shields.io/badge/Skills-24-blue)]()
[![EU AI Act](https://img.shields.io/badge/EU%20AI%20Act-ready-green)]()
[![Habits](https://img.shields.io/badge/Habits-8-orange)]()
[![Version](https://img.shields.io/badge/Version-2.21.35-brightgreen)](https://github.com/pitimon/8-habit-ai-dev/releases/tag/v2.21.35)
[![Wiki](https://img.shields.io/badge/docs-Wiki-informational)](https://github.com/pitimon/8-habit-ai-dev/wiki)

📖 **Full documentation**: **[Wiki](https://github.com/pitimon/8-habit-ai-dev/wiki)** — deep-dive guides per step, [FAQ](https://github.com/pitimon/8-habit-ai-dev/wiki/FAQ), [Troubleshooting](https://github.com/pitimon/8-habit-ai-dev/wiki/Troubleshooting), and the [8 Habits Reference](https://github.com/pitimon/8-habit-ai-dev/wiki/Habits-Reference).

> **"ทำเสร็จ ≠ ทำดี"** — Shipping code is not the same as shipping _good_ code.
>
> AI coding tools are powerful — but "build me X" without requirements, review, or staging creates fast, fragile code. This plugin adds the discipline AI lacks: **24 skills** across a **7-step workflow**, grounded in **Covey's 8 Habits** of effective development.

---

## Table of Contents

**Get Started**

- [The Problem](#the-problem) — Why this exists
- [Quick Start](#quick-start) — Install in 3 steps, verify in 1
- [Not using Claude Code?](AGENTS.md) — Entry point for Codex, Cursor, Windsurf, Aider, etc.

**The Framework**

- [Design Principle](#design-principle) — Thin harness, fat skills
- [7-Step Workflow](#the-7-step-workflow) — Visual pipeline from research to monitoring
- [Skills Reference](#skills-reference) — All 24 skills with habit mappings
- [Use Cases](#use-cases-which-skill-when) — Common scenarios and recommended paths
- [End-to-End Recipes](#end-to-end-recipes) — Copy-paste tool sequences for real situations
- [The 8 Habits](#the-8-habits) — Principles behind the workflow
- [Maturity Model](#the-maturity-model) — Dependence to Significance

**Deep Dives**

- [Cross-Verification](#cross-verification) — 17-question checklist + scoring
- [Whole Person Assessment](#whole-person-assessment) — Body/Mind/Heart/Spirit + worked example
- [Agents](#agents) — Read-only reviewers that analyze your work
- [Architecture](#architecture) — File tree + design decisions
- [Companion Plugins](#companion-plugins) — Working with `claude-governance` + `devsecops-ai-team`

**Reference**

- [What's New](#whats-new-in-v22135) — Version history
- [Not a Checklist](#not-a-checklist) — Principles, not gates
- [Origin](#origin) — Where these habits come from
- [Limitations](https://github.com/pitimon/8-habit-ai-dev/wiki/Limitations) — Runtime boundaries and evidence expectations
- [FAQ](#faq) — Common questions answered
- [Glossary](#glossary) — Key terms defined
- [Alternative Setup](#alternative-setup-without-plugin) | [Security](#security) | [Contributing](#contributing) | [License](#license)

---

## The Problem

AI coding tools (Claude Code, Cursor, Copilot, Codex) are powerful — but they amplify whatever process you bring to them. No process? You get fast, fragile code that works in demo but breaks in production.

The 7 most common mistakes:

1. **No requirements** — jumping straight to "build me X"
2. **No design** — letting AI decide architecture
3. **No task breakdown** — one giant prompt for everything
4. **No context** — AI doesn't know your codebase
5. **No review** — shipping AI output without reading it
6. **No staging** — deploying directly to production
7. **No monitoring** — "it works on my machine" mindset

This plugin provides a **skill for each step** — not as a gate, but as a habit.

---

## Design Principle

We follow the **"Thin Harness, Fat Skills"** pattern — the session hook is bounded (≤300 tokens, enforced in [`hooks/session-start.sh`](hooks/session-start.sh) and documented in `CLAUDE.md`), and the intelligence lives in on-demand markdown skills loaded when you invoke them. The harness gets out of the way; the skills do the work.

The same principle is documented independently by Garry Tan (President & CEO, Y Combinator) in his 2026 essay [_"Thin Harness, Fat Skills"_](https://github.com/garrytan/gbrain/blob/master/docs/ethos/THIN_HARNESS_FAT_SKILLS.md) and shipped in [gbrain](https://github.com/garrytan/gbrain). We arrived at it from workflow discipline; he arrived at it from building a brain — same conclusion.

The same shift is happening industry-wide under the name **Spec-Driven Development (SDD)**: after "vibe coding" entered the vocabulary in early 2025, tools like GitHub spec-kit, AWS Kiro, and Tessl emerged to generate code from specs. Those are spec-first _tooling_ — this plugin is spec-first _discipline_: tool-agnostic guidance that helps any of them (or none of them) produce better specs in the first place. It adds no enforcement and spawns no role-agents — that is the companion [`claude-governance`](https://github.com/pitimon/claude-governance). We arrived here from workflow discipline; they arrived from building codegen tools — same discipline layer, different delivery.

---

## Quick Start

**Install for Claude Code:**

```bash
claude plugin marketplace add pitimon/8-habit-ai-dev
claude plugin install 8-habit-ai-dev@pitimon-8-habit-ai-dev
```

**Install for Codex:**

```bash
codex plugin marketplace add pitimon/8-habit-ai-dev
codex plugin add 8-habit-ai-dev@pitimon-8-habit-ai-dev
```

**Use in Claude Code** (restart Claude Code, then invoke a skill by slash command):

```
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

Two commands to install per platform. Claude Code also loads a session reminder; both platforms make 24 skills available. For exact runtime boundaries, see the [runtime compatibility matrix](docs/compatibility-matrix.md), [Codex integration guide](docs/codex-integration.md), and wiki [Limitations](https://github.com/pitimon/8-habit-ai-dev/wiki/Limitations): Codex gets native packaging, the same markdown skills, and a narrow `SessionStart` JSON adapter if the host invokes the hook; it does not get Claude hook feature parity or runtime enforcement.

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

## The 7-Step Workflow

Each step maps to one of Covey's 8 Habits — the habit explains _why_ the step matters.

```
Step 0          Step 1          Step 2         Step 3
/research  ───→ /requirements ─→ /design  ────→ /breakdown
H5:Understand   H2:End in Mind   H8:Find Voice  H3:First Things

Step 4          Step 5          Step 6         Step 7
/build-brief ─→ /review-ai ───→ /deploy-guide → /monitor-setup
H5:Understand   H4:Win-Win      H1:Proactive   H7:Sharpen Saw
```

You don't need all steps every time. Start with **`requirements` before building** and **`review-ai` before committing** — those two alone eliminate most Vibe Coding problems. In Claude Code that usually means `/requirements` and `/review-ai`; in Codex, select them through `/skills`, mention `$requirements` / `$review-ai`, or ask in natural language.

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

## Use Cases: Which Skill When?

Start from **your situation**, not the skill name.

| I want to...                                  | Start with                                                                                                                                                                                                          | Then                              | Habit                             |
| --------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------- | --------------------------------- |
| Build a new feature from scratch              | `/requirements`                                                                                                                                                                                                     | `/design` → `/breakdown`          | H2: Define done first             |
| Review code before committing                 | `/review-ai`                                                                                                                                                                                                        | `/security-check` if needed       | H4: Never skip review             |
| Understand an unfamiliar codebase             | `/research`                                                                                                                                                                                                         | `/build-brief`                    | H5: Read before writing           |
| Deploy / provider canary                      | `/deploy-guide`                                                                                                                                                                                                     | `/monitor-setup`                  | H1: Stage, rollback, reconcile    |
| Assess overall project health                 | `/cross-verify`                                                                                                                                                                                                     | `/whole-person-check`             | All 8 habits                      |
| Classify an operational finding               | `/operational-state`                                                                                                                                                                                                | `/deploy-guide` or `/post-mortem` | H1 + H5 + H8                      |
| Fix a production bug                          | `/build-brief`                                                                                                                                                                                                      | Reproduce first                   | H5: Understand first              |
| Investigate a hard bug (no obvious cause)     | `/diagnose`                                                                                                                                                                                                         | `/post-mortem` → `/reflect`       | H1 + H5: Loop before guessing     |
| Question whether a change should exist at all | `/scrutinize`                                                                                                                                                                                                       | `/review-ai` for diff-local       | H5 + H8: Intent before diff       |
| Brief leadership on engineering work          | `/management-talk`                                                                                                                                                                                                  | (channel-aware reshape)           | H4 + H6: Right signal per channel |
| Something feels off about a plan              | `/cross-verify`                                                                                                                                                                                                     | Check dimension scores            | H1-H8                             |
| Learn the full workflow                       | `/workflow`                                                                                                                                                                                                         | (guided walkthrough)              | All                               |
| Survive `/clear` and `/compact`               | See [`guides/spec-digest-pattern.md`](guides/spec-digest-pattern.md) (project-orientation hub) or [`current-state.md`](guides/persistence-convention.md#current-state-file-optional-user-owned) (feature-spec mode) | Adopt one based on repo archetype | H5: Understand first              |

### Recommended Paths

**Minimum Viable Discipline** — `/requirements` before building + `/review-ai` before committing. Two skills, biggest impact.

**Full Workflow** — `/research` through `/monitor-setup` via `/workflow`. For new features or greenfield projects.

**Quality Gate** — `/cross-verify` + `/whole-person-check`. For pre-PR or pre-release assessment.

For the full 15-situation map, see [`guides/situation-map.md`](guides/situation-map.md).

---

## End-to-End Recipes

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

**You get:** _done_ is defined before the first prompt and reviewed before the commit. In a hurry? `/requirements` + `/review-ai` alone remove the two most common vibe-coding failure modes — undefined _done_ and unreviewed output. — **H2 + H4**

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

---

## The 8 Habits

Based on Stephen Covey's _The 7 Habits of Highly Effective People_ + Habit 8 (_The 8th Habit: From Effectiveness to Greatness_), adapted for AI-assisted development from real experience building a production system over 910 man-day-equivalents.

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

The `/whole-person-check` skill evaluates work across Covey's 4 dimensions — one of the plugin's **differentiators**, since few engineering tools assess all four.

| Dimension               | What It Measures                            | AI Strength         |
| ----------------------- | ------------------------------------------- | ------------------- |
| **Body** (Discipline)   | CI, tests, monitoring, quality gates        | Strong — AI excels  |
| **Mind** (Vision)       | Architecture, ADRs, roadmap, tech debt      | Strong — AI excels  |
| **Heart** (Passion)     | Craft quality, empathetic errors, UX, DX    | Weak — needs humans |
| **Spirit** (Conscience) | Security-first, ethics, compliance, sharing | Weak — needs humans |

AI-assisted development systematically neglects Heart and Spirit. This assessment makes the gap visible so teams can compensate.

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
- **Zero dependencies** — pure markdown + bash. No npm, no pip, no runtime requirements. Windows PowerShell validator smokes use Git Bash as a compatibility layer; run `scripts/windows-preflight.ps1` first.

---

## Companion Plugins

`8-habit-ai-dev` works **standalone** — no hard dependency. For higher-assurance projects, it composes with two companion plugins (also by pitimon):

| Plugin              | Layer                                                              | When to add                                         |
| ------------------- | ------------------------------------------------------------------ | --------------------------------------------------- |
| `claude-governance` | Policy / Enforcement (fitness functions, ADRs, compliance)         | When you need durable policy + audit trail          |
| `devsecops-ai-team` | Operational tooling (SAST/DAST/SCA/Container/IaC + SBOM/AIBOM/VEX) | When you need automated scans or regulator evidence |

**Single source of truth for integration:** see [`docs/INTEGRATION.md`](docs/INTEGRATION.md) — covers layer map, choosing-your-stack matrix, integration points, Three Loops asymmetry, EU AI Act scope split, and suggested integrated flow.

Tested against `claude-governance` 3.3.0 and `devsecops-ai-team` 10.12.0+.

> **Naming note (v2.16.5)**: in `devsecops-ai-team` v10.12.0, the `/workflow` skill was renamed to `/security-workflow` to resolve a cross-plugin naming collision with this plugin's `/workflow` (the 7-step Covey practice). If you have both plugins installed, type `/workflow` for the 7-step walkthrough or `/security-workflow` for devsecops's scan orchestration. Legacy `/workflow` in devsecops continues as a deprecation stub through v10.x (removed in v11.0.0). See devsecops ADR-014.

---

## What's New in v2.21.35

**Theme: Fail-closed pre-commit example (F6 false-success fix, #343)**

- **The shipped pre-commit example no longer swallows a review-tool crash into a silent "passed."** — `hooks/pre-commit.sh.example` (the optional `/review-ai` pre-commit gate users can copy) was `REVIEW_OUTPUT=$(claude --print …) || true` then grep for REWORK/FAIL, so a CLI crash (auth / network) produced empty output and the hook reported success. It is now **fail-closed**: a non-zero CLI exit, a REWORK/FAIL verdict, and a missing verdict line each block the commit; only an explicit PASS/CONCERNS marker proceeds. New `tests/test-pre-commit-hook.sh` (12 assertions across both mirror copies) guards against recurrence and runs in CI.

> This is the enforce-on-others-skip-on-self gap surfaced by a 2026-06-29 adversarial Spirit pass: the plugin's own `rules/coding-style.md` bans `cmd || true` on checks that must verify something, yet the example users copy shipped exactly that shape (introduced in [#80](https://github.com/pitimon/8-habit-ai-dev/issues/80)). Closes F6 from the [Fable model review](docs/reviews/2026-06-10-fable-model-review.md). Issue [#343](https://github.com/pitimon/8-habit-ai-dev/issues/343) tracks the remaining findings (B1 800-line validator self-exemption, S1 missing SECURITY.md / threat model, F4 frozen SELF-CHECK table, F5 Bash drift).

---

## What's New in v2.21.34

**Theme: Karpathy simplicity + surgical-edit gaps recorded as deferred doctrine (ADR-026 Deliverable B, #339)**

- **Two Karpathy rules logged as deferred candidates** — the `multica-ai/andrej-karpathy-skills` rules #2 (simplicity / YAGNI) and #3 (surgical / minimal-diff edits) are recorded as **N8 + N9 (T2, drop-date 2026-12-27)** in `guides/anthropic-engineering-doctrine-audit.md` Table 2 — the greppable defensive-citation surface a contributor checks before re-proposing a blog-post pattern. They are **deferred, not adopted**: no first-person friction citation exists, and repo popularity is not friction (ADR-014). Rule #3 also carries a recorded tension with H1 (defense-in-depth) that must be reframed before any future ship.

> Follow-up to [ADR-026](docs/adr/ADR-026-external-prior-art-audit-karpathy-gstack.md) (the prior-art audit of the 5 viral-post repos). This is the "Deliverable B" discoverability step: the audit verdict lives in the ADR; this lands the rows where the `How to use this guide` grep-protocol will actually find them. Docs/doctrine only — no skill, rule, or enforcement behavior changed.

---

### Previous releases

For the full version history, see [`CHANGELOG.md`](CHANGELOG.md) (v2.3.0+), [`docs/wiki/Changelog.md`](docs/wiki/Changelog.md) (v2.2.0 and earlier), or [GitHub Releases](https://github.com/pitimon/8-habit-ai-dev/releases).

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

This framework was developed while building [MemForge](https://github.com/pitimon/memforge) — a production AI memory system with 15 services, 154K+ observations, and a 3-node Docker Swarm cluster. Over 910 man-day-equivalents of AI-assisted development, these habits emerged from real mistakes:

- **H1**: A deploy bypassed staging and went straight to production (now there's a mandatory staging-first rule)
- **H4**: Code reviews were skipped "just this once" — 2 CRITICAL and 3 HIGH issues shipped (now review-before-commit is enforced)
- **H7**: Monitoring was the weakest step across 3 projects — a systematic blind spot we only caught through cross-project analysis
- **H5**: A database password mismatch crashed production because nobody validated the .env file before deploying

Every habit in this plugin exists because **skipping it caused real damage**.

---

## FAQ

**Q: Do I need to use all 24 skills for every task?**
No. Start with `/requirements` before building and `/review-ai` before committing. Those two alone eliminate most Vibe Coding problems. Add more skills as they feel natural. See [Use Cases](#use-cases-which-skill-when).

**Q: What is "Vibe Coding"?**
Building software by feel — jumping straight to "build me X" without requirements, design, or review. AI tools amplify this tendency because they make coding feel effortless. This plugin provides structure without removing speed.

**Q: How is this different from a linter or CI tool?**
Linters check syntax. CI checks tests. This plugin checks _process_ — did you define success criteria? Did you review before committing? Did you consider security? It operates at the planning and judgment layer, not the code layer.

**Q: What does "ทำเสร็จ ≠ ทำดี" mean?**
Thai: "Done is not done well." Completing a task (ทำเสร็จ) is not the same as completing it with quality (ทำดี). This principle is the plugin's core identity — speed without discipline creates debt.

**Q: Can I use this without Claude Code?**
Yes. v2.19.0 adds native Codex packaging via `.codex-plugin/plugin.json` and `.agents/plugins/marketplace.json`. Other agent platforms can still load `skills/<name>/SKILL.md` manually; start at [AGENTS.md](AGENTS.md).

**Q: What are the "Whole Person dimensions"?**
Covey's model: Body (discipline/quality), Mind (vision/architecture), Heart (passion/craft/empathy), Spirit (conscience/ethics/security). AI excels at Body and Mind but systematically neglects Heart and Spirit. See [Whole Person Assessment](#whole-person-assessment).

**Q: How do the agents work?**
Agents are read-only reviewers that run inside Claude Code. They analyze your code and produce reports but never modify files. See [Agents](#agents).

**Q: Is this plugin opinionated?**
Yes, deliberately. The opinions come from 910 man-day-equivalents of production AI-assisted development. Every rule exists because skipping it caused real damage. See [Origin](#origin).

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

This plugin ships **markdown guidance only** — no runtime service, endpoints, database, or network client — so the conventional application-layer attack surface does not apply. The real surface is **supply-chain** (integrity of skill / hook / rule content) and the opt-in `hooks/pre-commit.sh.example`.

- 📄 [**Security Policy**](SECURITY.md) — how to report a vulnerability (private disclosure; please do **not** open a public issue).
- 🛡️ [**Threat Model**](docs/security/threat-model.md) — STRIDE for a markdown-only plugin, trust boundaries, and an honest list of controls not yet present.

---

## Contributing

Found a habit that worked (or broke) in your AI-assisted development? PRs welcome.

See **[CONTRIBUTING.md](CONTRIBUTING.md)** for the full guide — skill authoring conventions, blank templates, and quality checklist.

Quick options:

- **Add a new skill** — follow the template in CONTRIBUTING.md
- **Add real examples** to `habits/*.md` files
- **Add domain question packs** in `guides/cross-verify-packs/`
- **Report issues** at [GitHub Issues](https://github.com/pitimon/8-habit-ai-dev/issues)

## License

MIT

---

_Version: 2.21.35 | Last updated: 2026-06-29_
