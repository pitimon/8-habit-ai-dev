# 8 Habits of Effective AI-Assisted Development

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Claude Code Plugin](https://img.shields.io/badge/Claude_Code-Plugin-7C3AED)](https://github.com/pitimon/8-habit-ai-dev)
[![Skills](https://img.shields.io/badge/Skills-24-blue)]()
[![EU AI Act](https://img.shields.io/badge/EU%20AI%20Act-ready-green)]()
[![Habits](https://img.shields.io/badge/Habits-8-orange)]()
[![Version](https://img.shields.io/badge/Version-2.20.2-brightgreen)](https://github.com/pitimon/8-habit-ai-dev/releases/tag/v2.20.2)
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
- [The 8 Habits](#the-8-habits) — Principles behind the workflow
- [Maturity Model](#the-maturity-model) — Dependence to Significance

**Deep Dives**

- [Cross-Verification](#cross-verification) — 17-question checklist + scoring
- [Whole Person Assessment](#whole-person-assessment) — Body/Mind/Heart/Spirit + worked example
- [Agents](#agents) — Read-only reviewers that analyze your work
- [Architecture](#architecture) — File tree + design decisions
- [Companion Plugins](#companion-plugins) — Working with `claude-governance` + `devsecops-ai-team`

**Reference**

- [What's New](#whats-new-in-v2202) — Version history
- [Not a Checklist](#not-a-checklist) — Principles, not gates
- [Origin](#origin) — Where these habits come from
- [FAQ](#faq) — Common questions answered
- [Glossary](#glossary) — Key terms defined
- [Alternative Setup](#alternative-setup-without-plugin) | [Contributing](#contributing) | [License](#license)

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

**Use** (restart your agent, then invoke any skill by name or matching intent):

```
/requirements       # Before you build anything
/review-ai          # Before you commit anything
/cross-verify       # Before you ship anything
/whole-person-check # Assess Body/Mind/Heart/Spirit balance
```

**Verify Claude Code installation**: After restarting, you should see `## 8-Habit AI Dev Active` in the session banner with the 7-step workflow reminder. For Codex, run `codex plugin list` and confirm `8-habit-ai-dev@pitimon-8-habit-ai-dev` is installed.

**New to the plugin?** Start with `/workflow` for a guided walkthrough, or see [Use Cases](#use-cases-which-skill-when) to find the right skill for your situation.

Two commands to install per platform. Claude Code also loads a session reminder; both platforms make 24 skills available. For exact runtime boundaries, see the [runtime compatibility matrix](docs/compatibility-matrix.md) and [Codex integration guide](docs/codex-integration.md): Codex gets native packaging and the same markdown skills, not Claude hook execution or runtime enforcement.

### Keeping the plugin updated

This plugin is maintained through regular releases. Check the [GitHub Releases](https://github.com/pitimon/8-habit-ai-dev/releases), the [wiki changelog](https://github.com/pitimon/8-habit-ai-dev/wiki/Changelog), or the "What's New" sections below to see recent changes.

**Claude Code:**

```bash
claude plugin update 8-habit-ai-dev@pitimon-8-habit-ai-dev
```

Restart Claude Code after updating so hook and skill changes are loaded.

**Codex:**

```bash
codex plugin marketplace upgrade pitimon-8-habit-ai-dev
codex plugin list
```

Codex installs from a marketplace snapshot. Refresh the marketplace snapshot first, then verify the installed plugin is still present. If a local cache ever looks stale, remove and add the plugin again:

```bash
codex plugin remove 8-habit-ai-dev@pitimon-8-habit-ai-dev
codex plugin add 8-habit-ai-dev@pitimon-8-habit-ai-dev
```

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

You don't need all steps every time. Start with **`/requirements` before building** and **`/review-ai` before committing** — those two alone eliminate most Vibe Coding problems.

---

## Skills Reference

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
| `/consistency-check`  | H5 + H1             | Cross-artifact analyzer over persisted PRD↔design↔tasks, plus incident/config hotfix mode for symptom↔evidence↔root-cause↔fix↔verification drift (v2.20.1)                                                                                                                                                                                                                                                                                                                                    |
| `/operational-state`  | H1 + H5 + H8        | **Operational finding classifier** — choose Watch, Fix Candidate, Active Incident, Resolved, Handoff, Known Accepted Issue, False Positive, or Self-Resolved before action. Maps evidence, allowed/prohibited actions, approval gates, artifacts, escalation criteria, and closure criteria. Read-only guidance; no runtime state engine or production mutation.                                                                                                                                   |
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

| I want to...                      | Start with                                                                                                                                                                                                          | Then                              | Habit                   |
| --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------- | ----------------------- |
| Build a new feature from scratch  | `/requirements`                                                                                                                                                                                                     | `/design` → `/breakdown`          | H2: Define done first   |
| Review code before committing     | `/review-ai`                                                                                                                                                                                                        | `/security-check` if needed       | H4: Never skip review   |
| Understand an unfamiliar codebase | `/research`                                                                                                                                                                                                         | `/build-brief`                    | H5: Read before writing |
| Deploy / provider canary        | `/deploy-guide`                                                                                                                                                                                                     | `/monitor-setup`                  | H1: Stage, rollback, reconcile |
| Assess overall project health     | `/cross-verify`                                                                                                                                                                                                     | `/whole-person-check`             | All 8 habits            |
| Classify an operational finding   | `/operational-state`                                                                                                                                                                                                | `/deploy-guide` or `/post-mortem` | H1 + H5 + H8            |
| Fix a production bug              | `/build-brief`                                                                                                                                                                                                      | Reproduce first                   | H5: Understand first    |
| Something feels off about a plan  | `/cross-verify`                                                                                                                                                                                                     | Check dimension scores            | H1-H8                   |
| Learn the full workflow           | `/workflow`                                                                                                                                                                                                         | (guided walkthrough)              | All                     |
| Survive `/clear` and `/compact`   | See [`guides/spec-digest-pattern.md`](guides/spec-digest-pattern.md) (project-orientation hub) or [`current-state.md`](guides/persistence-convention.md#current-state-file-optional-user-owned) (feature-spec mode) | Adopt one based on repo archetype | H5: Understand first    |

### Recommended Paths

**Minimum Viable Discipline** — `/requirements` before building + `/review-ai` before committing. Two skills, biggest impact.

**Full Workflow** — `/research` through `/monitor-setup` via `/workflow`. For new features or greenfield projects.

**Quality Gate** — `/cross-verify` + `/whole-person-check`. For pre-PR or pre-release assessment.

For the full 15-situation map, see [`guides/situation-map.md`](guides/situation-map.md).

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

The `/whole-person-check` skill evaluates work across Covey's 4 dimensions — the plugin's **unique differentiator**. No other engineering tool covers all four.

| Dimension               | What It Measures                            | AI Strength         |
| ----------------------- | ------------------------------------------- | ------------------- |
| **Body** (Discipline)   | CI, tests, monitoring, quality gates        | Strong — AI excels  |
| **Mind** (Vision)       | Architecture, ADRs, roadmap, tech debt      | Strong — AI excels  |
| **Heart** (Passion)     | Craft quality, empathetic errors, UX, DX    | Weak — needs humans |
| **Spirit** (Conscience) | Security-first, ethics, compliance, sharing | Weak — needs humans |

AI-assisted development systematically neglects Heart and Spirit. This assessment makes the gap visible so teams can compensate.

### Worked Example: A REST API Feature

After building a user authentication API, `/whole-person-check` might produce:

| Dimension | Score | Finding                                                     |
| --------- | ----- | ----------------------------------------------------------- |
| Body      | 4/5   | CI green, 85% coverage, but no load test                    |
| Mind      | 5/5   | ADR documented, JWT vs session decision recorded            |
| Heart     | 2/5   | Error messages return raw 500s, no onboarding guide         |
| Spirit    | 3/5   | Input validation present, but no rate limiting or audit log |

**AI Blind Spot visible**: Body and Mind scored high (AI's strength). Heart and Spirit scored low (needs human attention).

**Action**: Before shipping, add user-friendly error messages (Heart) and rate limiting with audit logging (Spirit). These are the gaps AI won't catch on its own.

### Maturity Rubrics

3 levels per dimension (Reactive → Proactive → Significant): [guides/whole-person-rubrics.md](guides/whole-person-rubrics.md)

### Plugin's Own Progression

```
v1.2.0  ████████████░░░░░░░░  3.0   (honest reassessment after inflated 4.5)
v1.9.0  ██████████████████░░  4.5   (evidence grounding + integrity)
v2.0.0  ██████████████████░░  4.625 (orchestration + meta-system)
v2.1.0  ███████████████████░  4.75  (verification agent + research rigor)
v2.2.0  ████████████████████  5.0   (content validation + fitness functions)
```

Full self-assessment: [SELF-CHECK.md](SELF-CHECK.md)

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

Both agents use the `sonnet` model for fast, focused analysis.

---

## Architecture

```
8-habit-ai-dev/
├── .claude-plugin/
│   ├── plugin.json                 # Plugin metadata (v2.15.0)
│   └── marketplace.json            # Marketplace listing
├── .codex-plugin/
│   └── plugin.json                 # Native Codex plugin metadata (v2.19.0)
├── .agents/plugins/
│   └── marketplace.json            # Native Codex marketplace listing
├── skills/                         # 24 skills (8 workflow + 16 standalone)
│   ├── research/SKILL.md           #   Step 0 → H5 (depth levels + modes)
│   ├── requirements/SKILL.md       #   Step 1 → H2
│   ├── design/SKILL.md             #   Step 2 → H8
│   ├── breakdown/SKILL.md          #   Step 3 → H3 (orchestration classification)
│   ├── build-brief/SKILL.md        #   Step 4 → H5 (context boundaries)
│   ├── review-ai/SKILL.md          #   Step 5 → H4 (4-level verdict)
│   ├── deploy-guide/SKILL.md       #   Step 6 → H1 (staging, rollback, reconciliation)
│   ├── monitor-setup/SKILL.md      #   Step 7 → H7
│   ├── cross-verify/SKILL.md       #   All habits (17Q + dimension summary)
│   ├── consistency-check/SKILL.md  #   H5+H1: spec + incident/config consistency (v2.20.1)
│   ├── operational-state/SKILL.md  #   H1+H5+H8: operational state classifier (v2.20.0)
│   ├── whole-person-check/SKILL.md #   H8: Body/Mind/Heart/Spirit
│   ├── security-check/SKILL.md     #   H1: OWASP security lens
│   ├── reflect/SKILL.md            #   H7: micro-retrospective + lesson persistence
│   ├── calibrate/SKILL.md          #   H8: maturity self-assessment → habit-profile.md
│   ├── using-8-habits/SKILL.md     #   H5+H8: onboarding + smart-routing mode (v2.14.0)
│   ├── eu-ai-act-check/SKILL.md    #   H1+H8: EU AI Act 9-obligation checklist
│   ├── ai-dev-log/SKILL.md         #   H4+H1: AI dev log from git history (Art. 11)
│   └── workflow/SKILL.md           #   Guided 7-step walkthrough
├── agents/
│   ├── 8-habit-reviewer.md         # Deep cross-verification agent
│   └── research-verifier.md        # Source verification agent (v2.1.0)
├── hooks/
│   ├── hooks.json                  # SessionStart hook registration
│   └── session-start.sh            # Workflow reminder + progress indicators
├── habits/                         # Reference content (loaded on-demand)
│   ├── h1-be-proactive.md          #   through h8-find-voice.md
│   └── ...                         #   (8 files, one per habit)
├── guides/
│   ├── cross-verification.md       # 17-point checklist detail
│   ├── whole-person-rubrics.md     # 4-dimension maturity rubrics
│   ├── integrity-principles.md    # 13 AI Integrity Commandments
│   ├── quick-reference.md          # 19 prioritized rules (scannable)
│   ├── situation-map.md            # 15 situations → right habit/skill
│   ├── orchestration-patterns.md   # Multi-agent orchestration (v2.0.0)
│   ├── templates/                  # Output templates
│   │   ├── prd-template.md         #   For /requirements
│   │   ├── adr-template.md         #   For /design
│   │   ├── task-list-template.md   #   For /breakdown
│   │   ├── review-report-template.md # For /review-ai
│   │   └── research-brief-template.md # For /research (v2.1.0)
│   └── cross-verify-packs/         # Domain question packs (5 questions each)
│       ├── api.md                  #   API development
│       ├── frontend.md             #   Frontend/UI
│       ├── infra.md                #   Infrastructure
│       ├── ai-ml.md                #   AI/ML systems
│       └── mobile.md               #   Mobile apps
├── tests/
│   ├── validate-structure.sh       # Structure validation (13 checks, pure bash)
│   └── validate-content.sh         # Content validation + fitness functions (v2.2.0)
├── docs/
│   ├── INTEGRATION.md              # Canonical plugin-integration guide (companion plugins)
│   └── adr/                        # Architecture Decision Records (ADR-001 .. ADR-013)
│       ├── ADR-001-orchestration-patterns.md
│       ├── ADR-002-research-modes.md
│       └── ADR-003-content-validation.md
├── rules/
│   └── effective-development.md    # Auto-loaded Claude Code rules
├── CLAUDE.md                       # Plugin development guide
├── CONTRIBUTING.md                 # Skill authoring guide
├── SELF-CHECK.md                   # Meta cross-verification
└── README.md                       # This file
```

**Design decisions:**

- **Skills are empowering, not restrictive** — reminders and tools, not blocking gates
- **Habit content loaded on-demand** — skills reference `habits/*.md` only when invoked, keeping session context lean
- **Session hook under 300 tokens** — light reminder with progress indicators, not a wall of text
- **Handoff contracts** — each skill declares what it expects from its predecessor and produces for its successor
- **Definition of Done** — every skill has 3-5 verifiable checkbox items
- **When to Skip** — honest conditions prevent compliance theater (H8: contribution over compliance)
- **Output templates** — structured formats for PRD, ADR, task list, review report, research brief
- **Dimension mapping** — all 17 cross-verify questions tagged with Body/Mind/Heart/Spirit
- **Zero dependencies** — pure markdown + bash. No npm, no pip, no runtime requirements

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

## What's New in v2.21.0

**Theme: cross-agent discovery and portability contract**

v2.21.0 adds a conservative discovery/export layer inspired by Mercury Skills while preserving the plugin boundary: the same markdown skill corpus works in Claude Code and Codex, and host-side tooling should stay portable across macOS, Linux, and WSL.

- **Frontmatter contract** — `CONTRIBUTING.md`, `guides/skill-authoring.md`, and `docs/compatibility-matrix.md` now define required, optional, cross-agent, and Codex-ingestible `SKILL.md` fields.
- **Generated skill catalog** — `docs/data/skills.json` is generated from `skills/*/SKILL.md` by `scripts/generate-skill-catalog.js` for cross-agent discovery.
- **Freshness check** — `tests/validate-structure.sh` Check 30 verifies the generated catalog is current.
- **Handoff integrity** — `guides/structured-output-protocol.md` adds a compact handoff note pattern for state, decisions, assumptions, evidence, confidence, next skill, and rejection path.
- **AI-work health** — `/review-ai`, `/reflect`, and `guides/quick-reference.md` add observable loop/retry/compaction/audit-trail signals without adding runtime metering or enforcement.
- **Boundary** — markdown guidance and generated metadata only: no runtime dispatcher, no Claude-hook port to Codex, no budget enforcement, and no policy gate.

## What's New in v2.20.2

**Theme: production canary reconciliation gates** ([#250](https://github.com/pitimon/8-habit-ai-dev/issues/250))

Extends `/deploy-guide` with a production canary / capacity-change template for provider-managed infrastructure where a human can choose a canary but the cloud provider may mutate a different eligible resource.

- **Deploy type classifier** — adds `production canary / capacity change` for EKS nodegroups, ASGs, Kubernetes nodes, and similar provider-managed work.
- **Approval gates** — separates cordon, observation, drain, provider-side change, reconciliation, and postcheck gates.
- **Provider reconciliation** — compares planned target vs actual provider-selected target and checks desired/min/max, schedulable capacity, all nodes Ready, and no unintended `SchedulingDisabled` nodes.
- **Closure discipline** — distinguishes provider scale/update success from canary reconciliation success.
- **Evidence wording** — adds a production ops closure snippet for intended canary, provider-selected target, reconciliation state, mitigation readiness, and `/operational-state` handoff.

## What's New in v2.20.1

**Theme: incident/config consistency-lite for operational hotfix PRs** ([#253](https://github.com/pitimon/8-habit-ai-dev/issues/253))

Extends `/consistency-check` with a lightweight incident/config hotfix mode for cases that do not have persisted PRD/design/tasks artifacts. The mode checks that an operational PR or closure note does not hide drift between symptom, evidence, root cause, actual fix, deploy path, and live verification.

- **No new skill** — keeps the check inside `/consistency-check` to avoid operational skill sprawl after `/operational-state`.
- **Hotfix output table** — emits `symptom | evidence | root cause | fix | verification | drift`.
- **Overclaim guard** — flags PR/changelog text that says more than the live verification proves.
- **Operational state handoff** — unresolved adjacent state is classified or handed to `/operational-state` instead of being hidden.
- **Worked example** — adds a generic WorkerDown/Alertmanager-style alert/config hotfix example.

## What's New in v2.20.0

**Theme: operational state model for incident and daily-fix work** ([#251](https://github.com/pitimon/8-habit-ai-dev/issues/251))

Adds `/operational-state`, a read-only skill for classifying operational findings before acting or closing them. It keeps production users out of the false binary of "fix now" vs "done" by naming explicit states and evidence thresholds.

- **`/operational-state`** — classifies findings as `Watch`, `Fix Candidate`, `Active Incident`, `Resolved`, `Handoff`, `Known Accepted Issue`, `False Positive`, or `Self-Resolved`.
- **State-to-action mapping** — each state names required evidence, allowed/prohibited actions, approval gates, artifacts, escalation criteria, and closure criteria.
- **Operational guardrails** — "Running is not healthy", "recovered is not fixed", source-of-truth drift stays visible, and report hygiene is separated from production mutations.
- **Boundary** — markdown guidance only: no runtime state engine, policy enforcement, cloud execution, or automatic production writes.

## What's New in v2.19.2

**Theme: operational doctrine patch from open issues**

v2.19.2 tightens four existing skills for operational incidents without adding runtime automation or a new operational-state skill. It ships the low-risk doctrine from issues #252, #254, #255, and #256 while leaving the broader operational model issues for a separate design pass.

- **`/deploy-guide`** — adds a deploy-type classifier before rollout planning and clarifies that config/template changes with runtime impact still need deploy planning.
- **`/security-check`** — expands the trigger surface to alerting/email templates, SMTP, webhooks, container/orchestrator config, env interpolation, mounted config, rendered config, and source-of-truth drift.
- **`/reflect`** — keeps the six-question contract while splitting Q6 into `most_useful`, `least_or_confusing`, and `missed_skill` so missed-skill signals survive lesson consolidation.
- **`/management-talk`** — adds an operational incident closure example rendered as Slack, standup, email, and meeting talking points.

## What's New in v2.19.1

**Theme: Codex runtime compatibility contract** ([ADR-024](docs/adr/ADR-024-codex-runtime-adapter-boundary.md))

v2.19.0 made Codex installation native. v2.19.1 makes the runtime promise explicit: this plugin is complete as a cross-agent markdown workflow-discipline system, but it does not claim Claude runtime feature parity inside Codex.

- **Compatibility matrix** — [`docs/compatibility-matrix.md`](docs/compatibility-matrix.md) documents what works in Claude Code, Codex, and other markdown-capable agents.
- **Codex integration guide** — [`docs/codex-integration.md`](docs/codex-integration.md) gives the Codex install, verify, routing, and release-flow contract.
- **ADR-024** — defines the future adapter boundary: routing, validation, release reconciliation, and curated memory deposit are acceptable adapter responsibilities; policy enforcement, compliance execution, irreversible-action auth, and orchestration engines stay outside the markdown skill core.
- **Validator coverage** — `tests/validate-structure.sh` Check 29 pins the compatibility docs and entrypoint links so the boundary cannot silently drift.
- **Entrypoint sync** — README, `AGENTS.md`, and `llms.txt` now point Codex users to the same compatibility contract.

## What's New in v2.19.0

**Theme: native Codex plugin packaging** ([ADR-023](docs/adr/ADR-023-codex-native-packaging.md))

The same markdown-only workflow discipline now installs natively in Codex. This release adds Codex packaging without rewriting the skills or adding runtime enforcement.

- **Codex manifest** — `.codex-plugin/plugin.json` exposes the existing `skills/` directory with Codex interface metadata.
- **Codex marketplace** — `.agents/plugins/marketplace.json` lets users install from the Git repo with `codex plugin marketplace add pitimon/8-habit-ai-dev` then `codex plugin add 8-habit-ai-dev@pitimon-8-habit-ai-dev`. It points to `./plugin`, a symlink back to the repo root, because Codex ignores root-path marketplace entries.
- **Codex ingestion compatibility** — `/ai-dev-log` and `/save-spec` now declare `disable-model-invocation: false`; ADR-014 already recorded the previous `true` flag as decorative for Claude plugin skills, while Codex rejects `true` during validation.
- **Validator coverage** — `tests/validate-structure.sh` now checks Codex packaging exists, keeps `.codex-plugin/plugin.json` version-aligned with the Claude package, and treats Codex packaging as consumer-doctrine for bump enforcement.
- **Version convention** — release version now lives in 5 files: Claude manifest, Claude marketplace, Codex manifest, README, and SELF-CHECK.

## What's New in v2.18.9

**Theme: a copy-pasteable worked example for `/diagnose`'s independent-source check** ([guide](guides/independent-source-verification.md))

A craft follow-up to v2.18.8. The independent-source verification step shipped in v2.18.8 told the reader _what_ to do; v2.18.9 adds a worked one-liner showing _how_ — so a first-time `/diagnose` user internalizes the technique without leaving the skill.

- **`skills/diagnose` Phase 4** — gains a runnable example (`docker run <img>` vs `docker exec <ctr>`, compare-and-flag-divergence) plus a one-line generalization (compile-from-source vs installed package; DB row vs API response): _read the claim twice from sources that can't share the same mistake, and only believe it when they agree._ Boundary-safe per [ADR-021](docs/adr/ADR-021-dynamic-workflow-positioning.md) — independence-of-source, not agent orchestration.
- **Consumer-doctrine bump** — `skills/` edit per [ADR-019](docs/adr/ADR-019-doctrine-only-scope-refinement.md); patch bump v2.18.8 → v2.18.9 atomic across 4 files.

For the v2.18.8 discipline this builds on, see [CHANGELOG.md](CHANGELOG.md). PR closes the `/whole-person-check` Heart-dimension follow-up.

## What's New in v2.18.6

**Theme: v2.18.5 fast-follow fix — body-measure `awk` made frontmatter-aware so ADRs and guides count correctly** ([skill](skills/requirements/SKILL.md), [test](tests/validate-content.sh))

QA on v2.18.5 (issue [#239](https://github.com/pitimon/8-habit-ai-dev/issues/239)) caught a correctness defect in the freshly-shipped step 4a body-measure command: `awk '/^---$/{c++; next} c>=2'` returned `0` for files without YAML frontmatter (ADRs, guides) — 2 of the 3 artifact types the same sub-step names. A contributor following 4a literally on an ADR precedent (the case study's own example) would measure `0` instead of ~150 → set the FR ceiling at `0 × 1.20 = 0`, defeating the calibration the sub-step exists to enforce.

- **Awk fix** — `skills/requirements/SKILL.md:80` now uses `awk 'NR==1 && $0=="---"{f=1; next} f && $0=="---"{f=0; next} !f'` which strips frontmatter only when the file actually starts with `---`. Verified: ADR-017 → 152, ADR-018 → 145, `cross-verification.md` → 95, `requirements/SKILL.md` → 131 (frontmatter correctly stripped, mid-body `---` thematic breaks correctly counted as body).
- **Regression test** — `tests/validate-content.sh` Check 22 closes the gap explicitly named in #239 (_"tests/\*\* was untouched, so no validator caught it"_): runs the prescribed awk against 4 representative files spanning all 3 artifact types and asserts body counts match expected; also grep-checks that SKILL.md carries the new variant and is free of the broken v2.18.5 form.
- **Template note** — `guides/templates/prd-template.md` clarifies that ADR/guide precedents have no frontmatter (body count = `wc -l`), only skills strip; cites #239 for the rationale.
- **Consumer-doctrine bump** — `skills/**` edit per [ADR-019](docs/adr/ADR-019-doctrine-only-scope-refinement.md); patch bump v2.18.5 → v2.18.6 atomic across 4 files; Check 27 passes.
- **Lesson** — prescribed commands embedded in skill prose are production guidance and need regression tests, the same way runtime code does. The plugin's "tests" surface is structural validators, not unit tests in the pytest sense; Check 22 establishes the precedent that future `awk`/`grep`/`jq` snippets in skill prose ship with a paired assertion.

PR closes [#239](https://github.com/pitimon/8-habit-ai-dev/issues/239).

## What's New in v2.18.5

**Theme: PRD calibration checkpoint — measure precedent before setting numeric ceilings on markdown artifacts** ([skill](skills/requirements/SKILL.md), [template](guides/templates/prd-template.md))

Adds a `4a. Calibrate numeric ceilings against precedent` step to `/requirements` Process. When an EARS criterion sets an upper bound on lines/words/characters of a markdown artifact (ADR, guide, skill), the skill now nudges the author to identify the closest precedent (`docs/adr/ADR-0*.md` for ADR ceilings, `guides/*.md` for guide ceilings, `skills/*/SKILL.md` for skill ceilings), measure the body excluding YAML frontmatter (`awk '/^---$/{c++; next} c>=2' <file> | wc -l`), and set the ceiling at `precedent_max × 1.20` — because aspirational round numbers contaminate `/consistency-check` runs once the artifact lands at its actual required size.

- **Case study** — FR-007 in `docs/specs/skill-authoring-guide-235/prd.md` shipped at ≤50 lines body against an ADR-017 precedent of ~150 lines and required pre-merge amendment to ≤150. The `8-habit-reviewer` cross-verify caught it as PRD-vs-reality drift; future runs will contaminate `/consistency-check` signal until amended (lesson `~/.claude/lessons/2026-05-24-v218-4-skill-authoring-double-rescue.md` §5).
- **Opt-out** preserved — when no precedent exists (genuinely novel artifact type), or when the cap is set by a different constraint (hook token budget, validator string limit), declare the rationale in a one-line FR comment instead of measuring.
- **Template example** — `guides/templates/prd-template.md` Success Criteria section now shows a calibrated vs. uncalibrated FR-007 example side by side.
- **Plugin-boundary respected** — no validator extension, no PreToolUse hook (runtime enforcement belongs in `pitimon/claude-governance`); this ship is authoring-discipline only.
- **Consumer-doctrine bump** — `skills/**` and `guides/**` edits per [ADR-019](docs/adr/ADR-019-doctrine-only-scope-refinement.md); patch bump v2.18.4 → v2.18.5 atomic across 4 files; Check 27 passes.

PR closes [#237](https://github.com/pitimon/8-habit-ai-dev/issues/237).

## What's New in v2.18.4

**Theme: Skill authoring guide — close N1+P2 gaps from Vibe Coding Thailand audit** ([guide](guides/skill-authoring.md), [ADR-020](docs/adr/ADR-020-skill-authoring-guide.md))

Adds `guides/skill-authoring.md` documenting (a) Ben AI's Pre-Building Preparation pattern (draft reference docs collaboratively before opening SKILL.md), (b) the canonical SKILL.md skeleton including a dedicated `## Objective` section (distinct from the trigger-rubric `description` enforced by Check 25 and the `**Habit**: H?` label), (c) the authoring lifecycle wiring `/research` → reference docs → SKILL.md → `/reflect` → SKILL-EFFECTIVENESS feedback. Triggered by a 2026-05-24 audit of Vibe Coding Thailand's "คู่มือสร้าง Claude Skills ให้เก่งกว่าคนทั่วไป" article.

- **N1 (Pre-Building Preparation)** — closed via the new guide. 23 skills exist but no discoverable authoring methodology existed; `CONTRIBUTING.md` template was structural-only.
- **P2 (Objective conflated with trigger)** — closed via `CONTRIBUTING.md` template diff (new `## Objective` section in the skill skeleton) + matching skeleton in the guide.
- **Cross-verify reconciliation** — the source brief's first draft recommended "ship nothing" on friction-first grounds. `@8-habit-reviewer` scored it 12/17 and identified the same selective-strictness pattern that rescued the ADR-017 draft four days earlier. Revised verdict applies [ADR-014](docs/adr/ADR-014-external-prior-art-audit.md) / [ADR-017](docs/adr/ADR-017-anthropic-skill-patterns-audit.md) "ship with zero friction as forward guardrail" precedent consistently.
- **Sunset 2026-11-24** — per ADR-020 §"Forward-Guardrail Sunset" (ADR-017 mechanism, not ADR-016 eviction). Reversal criteria: no `/reflect` cite, no contributor PR reference, no new skill using the Pre-Building Preparation pattern.
- **Consumer-doctrine bump** — `guides/**` edit per [ADR-019](docs/adr/ADR-019-doctrine-only-scope-refinement.md); patch bump v2.18.3 → v2.18.4 atomic across 4 files; Check 27 passes.

PR closes [#235](https://github.com/pitimon/8-habit-ai-dev/issues/235).

## What's New in v2.18.3

**Theme: Anthropic engineering doctrine audit guide — defensive citation surface for ADR-018 "Earn each line"** ([guide](guides/anthropic-engineering-doctrine-audit.md))

Adds `guides/anthropic-engineering-doctrine-audit.md` cataloguing which Anthropic / Karpathy / Claude Code engineering blog patterns are **already operational** in the plugin (Table 1: 12 rows) vs **evaluated and deferred** (Table 2: 7 rows). Closes a documented [ADR-018](docs/adr/ADR-018-memory-layer-activation.md) gap: without the catalogue, future blog-reading contributors re-propose adopted patterns. Complements [ADR-017](docs/adr/ADR-017-anthropic-skill-patterns-audit.md) (narrower `github.com/anthropics/skills` 5-pattern audit).

- **N6 reclassification** — original `/research` brief proposed "skill description routing audit" as T1 with "weak n=1". `@8-habit-reviewer` cross-verify flagged cherry-picking: the cited 2026-04-22 lesson records `skills/RESOLVER.md` as a proactive discoverability feature (issue #135), not a friction patch. N6 sits at T2 in the guide with explicit rationale — H8 modeling deposit (apply friction-first to ourselves the same way we apply it to incoming proposals).
- **Consumer-doctrine bump** — `guides/**` is consumer-doctrine per [ADR-019](docs/adr/ADR-019-doctrine-only-scope-refinement.md), so v2.18.3 patch bump + CHANGELOG are mandatory (not elective). Validator Check 27 confirmed pre-push.
- **Scope reduction** — original execution plan included CLAUDE.md "Proposed" entries and `/audit-skill-descriptions` skill design; both dropped per reviewer findings (HIGH redundancy + CRITICAL cherry-picking). Single-PR scope ships.

PR closes [#231](https://github.com/pitimon/8-habit-ai-dev/issues/231).

## What's New in v2.18.2

**Theme: ADR-019 doctrine-only scope refinement — split contributor vs consumer doctrine** ([ADR-019](docs/adr/ADR-019-doctrine-only-scope-refinement.md))

Refines [ADR-017 §C5](docs/adr/ADR-017-anthropic-skill-patterns-audit.md). The original rule "doctrine-only commits don't need version bump" carried an implicit assumption — **doctrine ⇒ contributor-only audience** — that was about to break at the next PR: [ADR-018 §"Context"](docs/adr/ADR-018-memory-layer-activation.md) explicitly names `rules/effective-development.md` (~200 lines, auto-loaded into every consumer session) as the next "Earn each line" audit target. Under the original §C5, that audit would have shipped as "doctrine-only" → silent user-facing behavioral shift.

- **Contributor-doctrine** (no bump, preserves §C5 intent): `CLAUDE.md`, `CONTRIBUTING.md`, `docs/adr/**`, `docs/out-of-scope/**`, `docs/wiki/**`, `.github/**`, `SELF-CHECK.md`, `AGENTS.md`, `llms.txt`, `tests/**`
- **Consumer-doctrine** (MUST bump + CHANGELOG, even if "doctrine refinement"): `rules/**`, `skills/**`, `hooks/**`, `habits/**`, `guides/**`, `agents/**`
- **`tests/validate-structure.sh` Check 27** — compares diff against last release tag; if any consumer-doctrine path touched AND version-4-files unchanged → FAIL with citation to ADR-019. Skipped on first-release case. 358 PASS / 0 FAIL.
- **Elective bump rationale**: this PR touches only contributor-doctrine. Bump is meta-signal that CI behavior changed (new validator added) — contributors should know. Patch grain since no skill/runtime change.

Forward-Guardrail Sunset 2026-11-24 per ADR-017 convention. Stays in `8-habit-ai-dev` (workflow discipline, not enforcement — claude-governance owns runtime hooks).

## What's New in v2.18.1

**Theme: Anthropic skills 5-pattern audit — Tier 1 P3 ship, P4 OOS, P5 T2** ([ADR-017](docs/adr/ADR-017-anthropic-skill-patterns-audit.md))

A user-prompted Deep+Audit `/research` evaluated 23 skills against [github.com/anthropics/skills](https://github.com/anthropics/skills) (specifically `skills/{pdf,pptx,docx}`) 5 SKILL.md patterns. Pattern 1 + 2 already shipped via ADR-014 Check 25 and ADR-009 split convention. Pattern 3 (NEVER/MUST + reason) promoted to Tier 1 as a forward guardrail consistent with ADR-014 precedent. Pattern 4 (embedded `scripts/`) out-of-scope per plugin charter. Pattern 5 (fix-verify loop) split: language-nudge half deferred to T2 bag with drop date 2026-11-23 per ADR-016, runtime-hook half filed as companion [pitimon/claude-governance#37](https://github.com/pitimon/claude-governance/issues/37).

- **`tests/validate-structure.sh` Check 26** (warning-only) — flags skills with ≥4 soft-language verbs (`should`/`consider`/`may`/`might`/`could`) and 0 reason markers (`MUST`/`NEVER`/`ALWAYS`/`Why:`/`Rationale:`/`because`). Currently flags `/post-mortem` + `/reflect` as informational (discretion-heavy register; non-blocking). Validator suite: 357 PASS / 0 FAIL.
- **`/scrutinize` Operating Rules** — 6 MUST/NEVER + Why blocks added, replacing soft phrasings. Rationale per each rule (e.g., "**NEVER rubber-stamp.** Why: rubber-stamps appear identical to genuine "I traced everything" — the reader cannot tell which one happened").
- **`/diagnose` Phase 6 cleanup** — hardened with MUST re-run Phase 1 feedback loop, citing Anthropic pptx ~line 243 ("Do not declare success until you've completed at least one fix-and-verify cycle"). New Definition of Done checkbox.
- **`docs/out-of-scope/anthropic-pattern-4-scripts.md`** — preserves Pattern 4 (embedded scripts) rejection rationale per plugin charter ("Skills are read-only guidance — they tell Claude how to approach a task, they do not modify files themselves").

**Honest framing**: 8-habit-reviewer cross-verify pushed back on the original "documentation-only" recommendation, surfacing that ADR-014 itself shipped 4 patterns 4 days earlier with the same zero-friction score as forward guardrails. Holding Anthropic patterns to a stricter standard would be selective strictness (H8/Spirit work-avoidance). The reconciliation paragraph in the research brief documents the resolution. All Tier 1 shipments inherit ADR-016 drop date 2026-11-23 — if no friction signal accumulates by then, Check 26 + skill edits drop per the cost-of-correction asymmetry gate.

**Citation precision** (recorded for future readers): the triggering Thai-language blog cited Anthropic skills under a `document-skills/` URL prefix (real path: `skills/`) and 4/7 pptx line numbers off by 40-61 lines. Quoted text is verbatim correct; URL/line precision is not.

PR [#219](https://github.com/pitimon/8-habit-ai-dev/pull/219) merged as `8540f9e`. Companion issue [pitimon/claude-governance#37](https://github.com/pitimon/claude-governance/issues/37) tracks the cross-plugin H6 deposit.

---

## What's New in v2.18.0

**Theme: `/diagnose` skill — friction-driven external adoption** ([ADR-015](docs/adr/ADR-015-diagnose-skill-adoption-and-n1-framing.md))

A second-pass Deep `/research` audit of [mattpocock/skills](https://github.com/mattpocock/skills) (SHA [`b8be62ff`](https://github.com/mattpocock/skills/tree/b8be62ffacb0118fa3eaa29a0923c87c8c11985c)) identified `engineering/diagnose` as a candidate **not covered by ADR-014's P1–P10 grid** — and unlike the v2.17.0 bundle, this candidate has a **first-person friction citation**: `~/.claude/lessons/2026-04-12-compression-worker-420-investigation.md` explicitly states _"Most useful: n/a (no 8-habit skills invoked during the fix session)"_ and _"Could have been found in 5 minutes by comparing the two SQL queries side-by-side instead of 30 minutes of log analysis."_

- **`/diagnose`** (H1 + H5) — 6-phase active bug investigation: feedback-loop → reproduce → hypothesise → instrument → fix-with-regression-test → cleanup. Closes the documented gap between `/research` (too broad — investigates solution space) and `/post-mortem` (too late — assumes fix landed). Hands off to `/post-mortem` once the fix lands and the Phase 1 loop passes. Adapt-with-attribution from mattpocock SHA `b8be62ff` per [design.md Decision-5](docs/specs/diagnose-skill-v2-18-0/design.md).

**Honest framing** ([ADR-015](docs/adr/ADR-015-diagnose-skill-adoption-and-n1-framing.md)): the friction signal is **n=1, below ADR-014's preferred n≥2 bar** but unusually strong — a first-person retrospective admission of an absent-skill gap, not third-party pattern attractiveness. ADR-015 records the framing transparently and enumerates 4 future-reversal conditions (zero recorded uses at 6 months → consider deprecation; n≥2 friction → validates retroactively; user confusion vs `/post-mortem` → revise boundary; upstream SHA churn → re-audit).

**Spec chain** (persisted): `docs/specs/diagnose-skill-v2-18-0/{prd,design,tasks}.md`. **Research brief** (source): `~/.claude/plans/deep-mattpocock-skills-second-pass-2026-05-23.md` (Deep mode, 12/14 sources verified, SHA-pinned for citation-rot resistance).

Plugin total: **23 skills**. H1 (Be Proactive — prevent recurrence, not just patch the symptom) + H5 (Seek First to Understand — reproduce before fixing). Sets precedent for friction-first external prior-art adoption.

---

## What's New in v2.17.0

**Theme: External prior-art audit — 4 patterns adopted from mattpocock/skills as forward guardrails** ([ADR-014](docs/adr/ADR-014-external-prior-art-audit.md))

A 2026-05-20 Deep-mode audit of [mattpocock/skills](https://github.com/mattpocock/skills) (95.5k★, MIT) evaluated 10 candidate patterns. Four ship as additive guardrails; three explicitly deferred; three rejected and catalogued in the new `docs/out-of-scope/`. Honest framing: all 4 adoptions ship without prior friction-signal evidence — they are **forward guardrails, not fixes for observed weakness**. ADR-014 records this discipline for future audits.

- **P1 AGENT-BRIEF template** — new `guides/templates/agent-brief-template.md` (habit-mapped, ≤120 lines): durable issue spec for backlog-bound work; behavioral-not-procedural rule preserved. Referenced from `/breakdown` Handoff.
- **P3 `disable-model-invocation: true`** — applied to `/save-spec` and `/ai-dev-log` (deterministic scaffolders). **Honest disclosure**: per [anthropics/claude-code#22345](https://github.com/anthropics/claude-code/issues/22345) (OPEN), plugin skills don't currently honor this field — declaration is intent-marking until #22345 closes.
- **P4-lite `docs/out-of-scope/`** — new directory with 3 seed entries (brainstorm-removal, agentskills no-go, EU AI Act migration). Per-decision rejection rationale; distinct from ADRs (verbs: "we DID decide X" vs "we deliberately WON'T do Y"). CONTRIBUTING.md explains the distinction.
- **P5 description rubric** — new validator Check 25 in `tests/validate-structure.sh`: SKILL.md `description` ≤1024 chars + trigger phrase from empirically-grounded set (Use when / Use AFTER / Use BEFORE / Use to / Use for / Use as / Read this first / Assess / migrated). Activates as forward guardrail; pre-shipment audit found 0/19 drift.
- **Validator additions**: Check 24 (`disable-model-invocation` value validation), Check 25 (description rubric). Pure bash; zero new dependencies.

**Spec chain** (persisted): `docs/specs/mattpocock-t1-v2-17-0/{prd,design,tasks}.md`. **Research brief** (source): `~/.claude/plans/deep-https-github-com-mattpocock-skills-glimmering-prism.md` (13/14 sources verified by `research-verifier` agent).

H5 (Understand First) + H7 (Sharpen Saw) — external audit as renewal discipline.

### Companion bundle — 3 discipline-skill ports from [thananon/9arm-skills](https://github.com/thananon/9arm-skills)

A 2026-05-20 Deep-mode research pass evaluated 4 candidate skills from `9arm-skills` (700★, no LICENSE — patterns adapted, not copied). Three ship as new standalone skills filling gaps the 7-step workflow doesn't address; one (`/debug-mantra`) filtered out (ceremony-heavy "recite verbatim" pattern conflicts with Significance profile + `rules/effective-development.md` H1 anti-pattern guidance).

- **`/post-mortem`** (H4 + H7) — canonical engineering RCA writeup. Refuses to draft without 4 inputs (reliable repro, known root cause, identified fix, validated outcome). Engineer-audience artifact; code identifiers welcome. Pairs with `/reflect` — that captures 5-min micro-retro signal; this captures canonical bug record for grep-back-in-6-months future-you.
- **`/scrutinize`** (H5 + H8) — outsider-perspective end-to-end review. Step 1 (Intent) mandates a simpler-alternative pass before line-by-line review; Steps 2–4 trace the actual call graph not just the diff. Pairs with `/review-ai` — that catches security/quality/perf on the diff; this asks whether the change should exist at all.
- **`/management-talk`** (H4 + H6) — channel-aware audience reshape. Same engineering content → JIRA / Slack / standup / email / meeting. Strips function/file/SHA, keeps JIRA keys / PR numbers / workload identifiers. Pairs after `/post-mortem` (engineering record → leadership reframe) or `/reflect` (retro → status update).

All 3 standalone (`prev/next-skill: any`), invoked on demand, never block the 7-step chain. Plugin total: **22 skills**.

**Research brief** (source): `~/.claude/plans/deep-https-github-com-thananon-9arm-skil-misty-taco.md` (Deep mode, `research-verifier` agent confirmed citation integrity + 3 inaccuracies corrected).

H5 (Understand First) — outsider audit found patterns 8-habit could absorb. H6 (Synergize) — adapt-not-copy fuses 9arm discipline patterns with 8-habit conventions (`prev-skill`/`next-skill` handoff, Habit map, bilingual title).

---

## What's New in v2.16.5

**Theme: Companion announcement — devsecops `/workflow` → `/security-workflow`** (paired release)

Docs-only patch. Closes the paired-announcement promise from `devsecops-ai-team` v10.12.0's CHANGELOG. The cross-plugin `/workflow` naming collision has been resolved by devsecops renaming its skill to `/security-workflow`.

- **`docs/INTEGRATION.md`** — devsecops peg bumped 10.10.0 → 10.12.0+ with inline rename note
- **`skills/workflow/SKILL.md`** — new "See Also (Cross-Plugin)" footer pointing users who meant scan-orchestration to devsecops's `/security-workflow`
- **`README.md` Companion Plugins** — updated tested-version peg + naming-note callout
- Companion PR `devsecops-ai-team` v10.12.1 (paired) adds devsecops's symmetric "Companion Plugins" README section + skill-level "See also" callouts in `/eu-ai-act-assess` and `/security-workflow`

Pattern captured: companion-announcement step is now part of Definition of Done for any cross-plugin slash-command rename. See post-release lesson `cross-plugin-companion-announcement-pattern` in `~/.claude/lessons/`.

H4 (Win-Win) reciprocity — every interaction is a deposit; closing this promise is a deposit to users tracking both plugins.

---

## What's New in v2.16.4

**Theme: `/save-spec` suite-positioning honesty patch (Adopter #2 third-repo dogfood)** ([#207](https://github.com/pitimon/8-habit-ai-dev/issues/207))

Docs-only patch. Adopter #2's third-repo dogfood (operational VA/PT workspace with `claude-mem` active + 284-line `CLAUDE.md`) surfaced two real overlap cases the docs didn't acknowledge. P1 + P2 ship; P3 explicitly deferred per adopter recommendation.

- **P1 (docs only)** — `skills/save-spec/SKILL.md` "When to Skip" gains a memory-MCP-overlap entry: skip if you already have `claude-mem`/`memforge` active AND a short `CLAUDE.md` (<150 lines), because §4 (Current state) becomes the only net-value section over what you already have.
- **P2 (docs only)** — Suite-positioning clarification across SKILL.md + README + using-8-habits/reference.md: `/save-spec` is a **deployment-mode helper orthogonal to the 7-step workflow**, alongside `/calibrate` + `/reflect` as state-write skills run on user demand (NOT alongside assessment skills).
- **P3 (defer)** — `--skip-empty-sections` flag explicitly deferred per adopter recommendation pending demand signal.

Pattern: **H8 Conscience applied to marketing copy** — the SKILL.md's own H8 Checkpoint admitted "the value depends on the user's habit of updating it"; this release extends that honesty to "When to Skip".

**Arc-close criterion validated**: v2.16.3 said "round 6 deferred unless 3rd adopter surfaces friction" — that condition triggered within ~2 hours of v2.16.3 release. Pattern continues at n=3 evidence base. Adopter's `/cross-verify` on the issue: 13/15 = 86.7%. Maintainer's `/cross-verify` on implementation posture: 15/15 = 100%.

## What's New in v2.16.3

**Theme: `/save-spec` Round-5 arc-close polish (Adopter #2 closure pass)** ([#205](https://github.com/pitimon/8-habit-ai-dev/issues/205))

Patch release. Adopter #2 closure pass on the 5-round v2.16.x QA arc surfaced 1 MEDIUM bug + 2 LOW items + an arc-close meta. All 3 fixed; arc closed per Adopter #2 recommendation.

- **R5-3 (MEDIUM bug, fixed)** — Scaffolded `SPEC.md` §2 markdown table rendered broken on every empty-decisions scaffold (`reference.md:30` blank line separated alignment row from substitution marker). Final fix uses table-row-shaped substitution marker because the formatter persistently re-wedged blanks around HTML-blocks AND `<...>` markers. New validator Check 12c.1 regression check added.
- **R5-1 (LOW-MEDIUM doc, fixed)** — Template assembly markers consolidated to explicit `ASSEMBLY-DIRECTIVE` phrasing + "NEVER appears in output" language; visually distinct from F1-class pre-fix placeholders.
- **R5-2 (LOW doc, fixed)** — FR-017 target-dir validation now uses a separate pre-flight error template ("Directory not found: …") with correct register, not the Decision-4 Write-failure wording.

Pattern: **formatter-vs-substitution-marker arms race resolved via table-row-shaped marker.** When a marker must be adjacent to a formatter-stable construct, make the marker itself look like that construct. DoD-must-execute self-test caught **zero bugs this round** — convergence is the expected pattern when discipline holds.

**5-round arc closed** per Adopter #2 recommendation. Rounds 1–5: #197 → v2.16.0; #201 → v2.16.1; #203 → v2.16.2; #205 → v2.16.3. Round 6 deferred unless a third independent adopter surfaces friction.

## What's New in v2.16.2

**Theme: `/save-spec` Round-3 polish + Guide Check 2 BSD-awk fix (Adopter #3 dogfood)** ([#203](https://github.com/pitimon/8-habit-ai-dev/issues/203))

Patch release. Adopter #3 dogfood pass on `/save-spec` (first round from **real skill execution**, not docs review) surfaced 1 correctness bug + 1 friction enhancement; the pre-PR self-test (DoD-must-execute action item from same-day /reflect lesson) surfaced 1 additional verification-command bug. All 3 fixed.

- **F1 (MEDIUM bug, fixed)** — Scaffolded `SPEC.md` shipped 6 literal angle-bracket placeholder sites contradicting the read-first-context purpose. Hybrid fix: §2/§3 skip-stubs use plain prose italic markers; §1 narrative + §4 fill-required sites use `<!-- TODO: ... -->` HTML comments (invisible at render, visible to editor).
- **F2 (LOW-MEDIUM enhancement)** — `/save-spec [project-name] [target-dir]` accepts optional second positional argument. Multi-repo portfolio adopters no longer need a per-repo session switch.
- **F3 (MEDIUM bonus, surfaced by pre-PR self-test)** — Guide's Check 2 awk range collapsed to 1 line on BSD awk (macOS default) because the end-regex matched the start line. Replaced with `sed -n` (consistent cross-platform). All macOS adopters silently affected since v2.15.9.
- **W2 (doc softening)** — N2 timestamp warning reframed; Adopter #3 verified correct Bangkok offset in real use.

Pattern: **DoD-must-execute principle empirically validated within 24h of being coined.** The v2.16.1 /reflect action item caught F3 — a BSD-awk regression no static review would have surfaced. Lesson loop closed same day.

## What's New in v2.16.1

**Theme: `/save-spec` Phase 1 polish — Adopter #2 dogfood fixes** ([#201](https://github.com/pitimon/8-habit-ai-dev/issues/201))

Patch release. Adopter #2 dogfood pass on the v2.16.0 `/save-spec` skill surfaced 1 correctness bug + 3 quality items — all four fixed in this single PR.

- **N1 (MEDIUM bug, fixed)** — §1 empty stub previously used `` `<filename>.md` `` which Check 4's backtick-path grep extracted as `<filename>.md` (literal angle brackets), making the Definition of Done's "passes 5 verification commands" claim provably false on the default scaffold. Stub now reads `_§1 is empty — add project-specific pointers as the repo grows._` with no backticked .md path. DoD claim is now true.
- **N2 (LOW, documented)** — Timestamp reliability profile documented. The skill (no `Bash`) substitutes the `**Last updated**` value from Claude's session-injected current-time context; when absent, output may carry `+00:00` or a wrong offset. Adopters: verify offset after scaffold, edit manually if wrong. Phase 2 hook for adding `Bash` if feedback warrants.
- **N3 (LOW UX, fixed)** — Q2 (§1 pointer confirmation) now accepts an "Other (free-text)" affordance for newline-separated project-specific paths. Motivated by ops/infra repos with non-canonical naming (`server-state.md`, `playbooks/change-management.md`, `runbooks/ops-runbook.md`).
- **N4 (LOW doc, fixed)** — PRD FR-003 deduplicated against reference.md Decision-3. Single source of truth.

Pattern: **patch-release dogfood discipline** — the adopter report surfaced N1 in <2 hours after v2.16.0; same-day correctness fix. Sibling closure: [#197](https://github.com/pitimon/8-habit-ai-dev/issues/197) now closeable — all 5 of its items addressed in v2.16.0 + #198.

## What's New in v2.16.0

**Theme: `/save-spec` skill — project-orientation hub mode promoted from guide to skill** ([#199](https://github.com/pitimon/8-habit-ai-dev/issues/199))

Minor version bump (new skill). All three v2.15.9 promotion criteria met after Adopter #2 report ([#197](https://github.com/pitimon/8-habit-ai-dev/issues/197)):

- **`/save-spec`** (new, Phase 1 minimum viable) — user-invoked skill that scaffolds a project-root `SPEC.md` following the spec-digest-pattern archetype. Hybrid auto-detect: globs for `PLAYBOOK.md`, `CONTRACTS.md`, `LESSONS.md`, `CHANGELOG.md`, `README.md` and asks the user to confirm §1 pointers. AskUserQuestion seeds project name, up to 3 §2 decisions, up to 3 §3 backlog items. §4 gets a timestamped template-stub. Refuses to overwrite an existing `SPEC.md` (Phase 2 `--update` deferred). Emits the CLAUDE.md auto-update recipe stanza to conversation only — does NOT modify your `CLAUDE.md`.
- **Scope question closed in writing** — `guides/spec-digest-pattern.md` now states explicitly that feature-spec mode (`--persist <slug>`) and project-orientation hub mode (root `SPEC.md`) are disjoint in practice; multi-mode repos are out of scope for tooling. Both n=2 adopters used project-orientation mode standalone.
- **ADR-013 follow-up addendum** — clarifies that the v2.16.0 `/save-spec` promotion stays within the existing ADR scope (user-invoked write is outside Alt-4's auto-write-hook rejection). No new ADR required.
- **`tests/validate-structure.sh` Check 23** — pins the canonical contract for `/save-spec`: frontmatter array, 8-step Process count (Decision-7 sticky), Decision-3 refusal phrase, Decision-4 error phrase, Decision-2 skip-sentinels documentation. Drift requires a new `/design` cycle.

Pattern: **promotion via maturity ladder, not aesthetic preference.** v2.15.9 documented the pattern + deferred the skill with explicit promotion criteria; v2.16.0 ships the skill only after the criteria were objectively met (n=2 adoption + scope resolved + friction lesson captured). Decision-driven, data-backed.

Dogfood: the PRD/design/tasks for this skill itself were persisted via `--persist save-spec` (the convention `/save-spec` does NOT use — feature-spec mode dogfooding project-orientation tooling), then `/consistency-check save-spec` ran clean (0 CRITICAL, 0 HIGH, 4 LOW for missing alternatives markers in 4 design decisions — accepted as informational).

## What's New in v2.15.9

**Theme: Project-Orientation Hub Mode Documentation** ([#194](https://github.com/pitimon/8-habit-ai-dev/issues/194), [PR #195](https://github.com/pitimon/8-habit-ai-dev/pull/195))

Docs-only patch. Documents a second spec-persistence deployment mode as complement to v2.15.2's feature-spec mode. No new skill, no hook, no enforcement.

- **`guides/spec-digest-pattern.md`** (new, ~180 lines) — project-root `SPEC.md` digest with §1 Architecture (pointer), §2 Decisions snapshot (compact ADR digest table), §3 Live backlog, §4 Current state save point ("Read this section first after `/clear` or `/compact`"). Template paraphrased from a production artifact (`scanopy/netbox-sit/SPEC.md`, 153 lines) that independently arrived at this four-section shape after repeated `/clear`/`/compact` flushing pain.
- **ADR-013 addendum** — additive 2026-05-17 note clarifying ADR-013's rejections (Alt-1 unified spec.md merge, Alt-4 always-on auto-write hook, CHANGELOG v2.15.0 `/save-point` skill rejection) cover the feature-spec mode specifically. The digest-layer-above-detail-files archetype is a different deployment mode those alternatives did not evaluate. **No change to the original Decision section.**
- **Cross-links** — `guides/persistence-convention.md` notes the two modes are complementary; `README.md` Use Cases table gets a "Survive `/clear` and `/compact`" row.
- **`/save-spec <slug>` skill** — explicitly deferred until ≥2 independent project adoptions, per working-with-pitimon "minimal additions, user-demand-driven" stance + PR #111 local-maximum lesson. Promotion criteria documented in the new guide.

Pattern: **empirical-evidence-driven discipline addition**. A real-world artifact from another session revealed a deployment mode the plugin did not document. The plan was revised twice (after `8-habit-reviewer` flagged write-vs-read scope, after advisor flagged n=1 commitment level) before settling on guide-first as the right commitment for the available evidence.

## What's New in v2.15.8

**Theme: `/reflect` Auto-Consolidation — One-Command Flow** ([#191](https://github.com/pitimon/8-habit-ai-dev/issues/191), [PR #192](https://github.com/pitimon/8-habit-ai-dev/pull/192))

UX patch removing the two-step friction in the reflection loop. Step 7 of `/reflect` now runs the 4-phase consolidation cycle automatically after saving each lesson file, instead of printing a nudge and waiting for a separate `/reflect consolidate` invocation.

- **Auto-run when `count > 10`** — Orient → Gather → Consolidate runs inline. No merges found → `~/.claude/lessons/INDEX.md` updated automatically + 1-line summary printed. Done in a single command.
- **Human-approval gate preserved** — If genuine duplicates are detected (merges/deletions proposed), the cycle stops and presents a plan for explicit approval before writing or deleting anything. In-the-Loop per ADR-002 — deletion is irreversible.
- **Explicit `/reflect consolidate` still works** — Same 4-phase cycle with verbose Consolidation Report output (Before/After/Merged/Pruned/Kept), for manual runs when full detail is needed.
- **Definition of Done updated** — "Consolidation auto-ran" replaces "Consolidation check performed" — the new bullet is testable with two concrete outcomes.

Pattern: **PC² — invest in the capability that builds capability.** The reflection loop is the system that captures lessons; reducing friction in that loop is H7 applied to H7 itself. Root cause was a threshold (10) that mature repos cross quickly — the fix makes auto-run safe for the common case (INDEX update, non-destructive) while keeping the gate for the rare case (deletions).

## What's New in v2.15.7

**Theme: Vendor Portability Discipline for Managed Agent Platforms** ([#188](https://github.com/pitimon/8-habit-ai-dev/issues/188), [PR #189](https://github.com/pitimon/8-habit-ai-dev/pull/189))

Doc-only patch responding to the industry move toward managed-agent runtime features (cross-session memory, self-evaluation against outcomes, built-in orchestration) — Claude Managed Agents, OpenAI Assistants, Bedrock Agents. Names the discipline that keeps users portable when adopting these features.

- **New `guides/vendor-portability.md`** — vendor-neutral guide structured around three principles: persist artifacts outside the vendor (repo = source of truth), treat managed memory as cache not source of truth, separate discipline (portable) from runtime (vendor-specific). Selection checklist framed as the `/cross-verify` Q14 "third alternative" exercise — managed vs. self-hosted is rarely binary, and hybrid with explicit persistence discipline is often the better answer.
- **`llms.txt` indexing** under Philosophy section, alongside `integrity-principles.md`.
- **Habit mapping** — H8 (Voice — architectural autonomy stays human-owned), H1 (Proactive — prevent lock-in before migration pain), H4 (Win-Win Emotional Bank Account — artifacts that inform the next person, canonical framing per `habits/h4-win-win.md`), H7 (Sharpen the Saw — reproducibility = PC over P).

Pattern: **discipline answer to a runtime trend** — 8-habit framework is intentionally vendor-neutral markdown. When platforms add convenience features that create lock-in, the framework responds with discipline guidance, not by replicating the feature. Plugin boundary preserved: this is workflow discipline, not enforcement (which belongs in `claude-governance`). 8-habit-reviewer pre-commit pass caught a Commandment #13 violation (Q14 mislabeled as "External dependencies" — actual text is "third alternative beyond the obvious options") — corrected before merge, demonstrating the integrity discipline applies to its own writing.

## What's New in v2.15.6

**Theme: SKILL_OUTPUT Producer + Consumer Doc Sync** ([#153](https://github.com/pitimon/8-habit-ai-dev/issues/153), [PR #186](https://github.com/pitimon/8-habit-ai-dev/pull/186))

Doc-only patch closing a pair of same-shape drift gaps in `guides/structured-output-protocol.md`. Both stemmed from `/design`'s `SKILL_OUTPUT:design` block being added without doc sync.

- **Producer entry added** — `/design` → `SKILL_OUTPUT:design` now documented between `/requirements` and `/breakdown` (workflow Step 2 placement). Schema matches `skills/design/SKILL.md:128-142` exactly: `decision_count`, `decisions`, `sticky_decisions`, `constraints`, `adr_references`, `article_14_applicable`, `article_14_pass`. Concrete example values match the existing producer style.
- **Consumer entries added** — Q14 (`decision_count` → third-alternative flag) and Q16 (`sticky_decisions` → WHY-not-captured flag) now documented in the Consumer Skills section. Q4 extended with the design-block cross-check (`decision_count` vs `success_criteria_count`). All 5 SKILL_OUTPUT-consuming questions from `skills/cross-verify/SKILL.md:35-41` are now mirrored in the guide.

Pattern: **producer + consumer doc-sync-as-a-pair** — adding a producer without documenting where its keys are consumed creates the same "confusion point" the issue cites. Strict-scope fix would have shipped half the gap; H4 + H1 closure fixes both halves in one PR.

## What's New in v2.15.5

**Theme: Repo-Wide Link-Check CI Gate** ([#172](https://github.com/pitimon/8-habit-ai-dev/issues/172), [PR #184](https://github.com/pitimon/8-habit-ai-dev/pull/184))

CI gate addition + 2 real link-rot fixes surfaced by the new gate on its first run.

- **`.github/workflows/link-check.yml`** — new GitHub Actions workflow using [lychee](https://github.com/lycheeverse/lychee) (Rust, fast). Triggers on PR + push to main when any `**/*.md` changes. Scope: external HTTP/HTTPS URLs across all `*.md` outside `docs/wiki/` (wiki has its own workflow). Internal markdown links remain covered by `tests/validate-content.sh` Check 12b — two-layer design covers full surface without duplication.
- **Self-referential + private cross-repo URLs excluded** — `pitimon/8-habit-ai-dev/(blob|tree|raw)/main/` (only resolves post-merge), `pitimon/(memforge|devsecops-ai-team)` (private repos; workflow's GITHUB_TOKEN is scoped to this repo only and cannot authenticate against other private repos). `claude-governance` is public and stays in scope.
- **README.md typo fix** — `https://github.com/pitimon/claud-mem-me` (missing 'e', repo doesn't exist) → `https://github.com/pitimon/memforge` (correct name). Real bug caught by the first CI run.
- **ADR-005:137 dead URL fix** — `https://ai-act-service-desk.ec.europa.eu/en/ai-act/` returns 404 (EC restructured the service desk path). Since ADR-005 is Superseded (per ADR-012), preserved as historical reference text with note explaining the URL state.
- **CONTRIBUTING.md "Link check (external URLs)" subsection** under Testing Conventions documenting both link-check workflows and the two-layer design.

Pattern: **CI gate that immediately proves its own value** — the first run on PR #184 caught 3 real link-rot issues (1 typo, 1 EC URL change, 1 private-repo CI-token scope constraint). Demonstrates that link rot was already happening silently; the new gate catches it at PR time instead of when users report broken navigation. The 8-habit-reviewer recommendation from the 3-plugin integration audit is now enforced.

## What's New in v2.15.4

**Theme: Backtick-Aware Ambiguity Pass + Dogfood ID Cleanup** ([#167](https://github.com/pitimon/8-habit-ai-dev/issues/167), [PR #182](https://github.com/pitimon/8-habit-ai-dev/pull/182))

First true bug-fix patch in the v2.15.x line — addresses the CRITICAL false-positive surfaced by v2.15.0's dogfood smoke test 9 days ago. `/consistency-check` Pass 3 (Ambiguity) now skips tokens inside `` `…` `` inline code spans and triple-backtick fenced blocks, aligning the analyzer's runtime semantics with the validator-side whitelist that already exists for `skills/consistency-check/` content (Check 12c).

- **Pass 3 backtick-context filter** (Option A from #167) — pre-strip backtick-quoted segments from each line before applying the `[NEEDS CLARIFICATION]` / `TBD` / `TODO` / `???` / `XXX` token match. Eliminates the `docs/specs/consistency-check/prd.md:45` false-positive where the PRD legitimately mentions the token inside backticks as detection-target documentation. Fewer escape hatches, principled, generalizes — no per-file whitelisting needed.
- **Known-limitation note removed** from `skills/consistency-check/reference.md` (the limitation was the bug; bug is now fixed).
- **Dogfood ID residual cleaned** — `tasks.md:48` had two stale `Decision-D5` / `Decision-D9` references missed by PR #169's earlier canonicalization. Aligned to `Decision-N` (no D prefix) per ADR-013.
- **Validator Check 21 added** (`tests/validate-content.sh`) — asserts 3 contract signals: "Backtick-context filter" label, "documentation-references" semantic, "pre-strip" workflow. Prevents future drift back to plain `grep -nE` semantics.

Pattern: **bug fix of a feature shipped 9 days ago** — distinct shape from v2.15.1/2/3 (content additions and convention imports). Issue surfaced via dogfood smoke test the day v2.15.0 shipped (#167 filed 2026-05-03); fix deferred because the bug is non-blocking (false-positive, not false-negative) and three intervening reflection-driven content patches had priority. The two-tier consistency design (validator whitelist for skill prose + analyzer backtick-filter for spec artifacts) is now internally consistent: tokens inside backticks are documentation-references everywhere.

## What's New in v2.15.3

**Theme: Integrity Commandment #13 — Grep-Verify Quotes Before Pasting** ([#179](https://github.com/pitimon/8-habit-ai-dev/issues/179), [PR #180](https://github.com/pitimon/8-habit-ai-dev/pull/180))

Content-only addition to `guides/integrity-principles.md` closing a verification-discipline gap surfaced during the v2.15.2 reflection. Two consecutive PR reviews (#174, #177) showed the same error shape — habit-attribution drift from gestalt pattern-matching — and a separate quote misattribution (`"Magic" behavior` at ADR-013 Alt-2 line 87 wrongly cited to Alt-4) propagated through 4 artifacts before reviewer catch. Both errors are preventable with a single grep step before pasting external text.

- **Commandment #13** under Honesty & Accuracy — covers ADR citations, habit principle claims, scare-quoted external phrases, observation IDs, prior-conversation paraphrases presented as direct quotes. Pattern: `Source: docs/adr/ADR-013.md:87` beats "I recall it says…"
- Mapping table extended: `5-7, 13 (Honesty)` → H8 Find Voice / Spirit (conscience)
- 3 live cross-references synced: title `12 → 13`, README architecture-tree comment, `/review-ai` load directive. Historical entries (v1.9.0 release line, v2.0.0 CHANGELOG delta, SELF-CHECK v1.9.0 improvements section) intentionally preserved as period record.

Dogfooding moment: drafting #13 caught its own meta-violation — initial text quoted `"magic behavior"` (lowercase, two-word) but ADR-013:87 actually says `"Magic" behavior` (capitalized, scare-quote on single word). Self-corrected before commit, demonstrating the rule applies to its own writing.

Pattern: **commandment growth driven by reflection-detected pattern** — distinct from upstream-import (v2.15.1) and community-article convention-import (v2.15.2). The trigger is internal drift detection across ≥2 sessions, not external publication.

## What's New in v2.15.2

**Theme: Current State Save-Point Convention** ([#176](https://github.com/pitimon/8-habit-ai-dev/issues/176), [PR #177](https://github.com/pitimon/8-habit-ai-dev/pull/177))

Convention-only addition to `guides/persistence-convention.md` importing a community-article save-point pattern (Thai-language article _"ผมไม่เคยกลัว /clear กับ /compact"_) as a user-owned 4th file. No new skill, no new agent, no validator change, no DAG change.

- **`## Current State File (Optional, User-Owned)`** — recommends `docs/specs/<slug>/current-state.md` with template (doing-now / stuck-at / next / last-updated). User-owned (no plugin skill writes), frontmatter-exempt, `/consistency-check` explicitly excluded. Solves resume-after-context-loss (`/clear`, `/compact`, crash) at **task level** — complements `hooks/session-start.sh`'s step-level artifact-detection nudges. Habit mapping: H5 + H3.
- **`## Auto-Update Recipe (User-Side, Optional)`** — CLAUDE.md rule template users can adopt in their own `~/.claude/CLAUDE.md` or project `CLAUDE.md`. **Plugin does not enforce** — preserves [ADR-013 Alt-4](docs/adr/ADR-013-spec-persistence-opt-in.md) invariant (no-build philosophy: skills are read-only guidance). Habit mapping: H1.
- **`## Attribution`** — credits the community article + `#176` for traceability.

Rejected in-scope candidates explicit in #176 body: single-file `spec.md` format (breaking change), plugin-side auto-persist (ADR-013 Alt-4), data contracts as new section (already covered by `/design` Step 4), new `/save-point` skill (duplicates `/reflect`), single-file priming command (`session-start.sh:83-115` already detects 3-file model).

Pattern: **community-article convention-only import** — distinct shape from v2.15.1's upstream-skill extract (addyosmani PR #139). Article has no canonical PR/commit to cite; paraphrased title + issue link is the maximum achievable attribution.

## What's New in v2.15.1

**Theme: Post-Audit Delta — Doubt-Driven Techniques Imported** ([#173](https://github.com/pitimon/8-habit-ai-dev/issues/173), [PR #174](https://github.com/pitimon/8-habit-ai-dev/pull/174))

Single-guide enhancement importing three techniques from [`addyosmani/agent-skills` — `doubt-driven-development`](https://github.com/addyosmani/agent-skills/blob/main/skills/doubt-driven-development/SKILL.md) (MIT, [PR #139](https://github.com/addyosmani/agent-skills/pull/139), upstream 2026-05-07 — published **27 days after** our prior addyosmani audit in PR #111). `guides/advisor-pattern.md` gains a new "Disprove-Mode Disciplines" section with:

- **Anti-CLAIM-bias rule (H5)** — pass `ARTIFACT + CONTRACT` only; hold the CLAIM back so the reviewer independently re-derives it instead of validating your framing.
- **Iterative-review 3-cycle cap (H3 + H7, conditional)** — bounded loop with user escalation; single-shot pattern is unchanged.
- **Adversarial prompt template (H1 + H5)** — disprove-only output for irreversible decisions. Dispatches a fresh subagent with **no named role** and read-only tools, **not** `@8-habit-reviewer` (whose 17-question process is fixed).

Honors PR #111's local-maximum lesson: no new skill, agent, or validator. Quick Reference table gains a second row for the adversarial pattern; See Also cites the MIT upstream. Rejected in-scope candidates explicit in #173: new `/doubt-check` skill, `source-driven-development` import, cross-model CLI escalation, agentskills.io frontmatter migration ([ADR-007](docs/adr/ADR-007-agentskills-compatibility-decision.md) NO-GO holds).

Pattern: post-audit delta. When an upstream methodology publishes after a periodic audit, evaluate the delta in isolation rather than triggering a full re-audit.

## What's New in v2.15.0

**Theme: spec-kit `/analyze` Inspiration — Cross-Artifact Consistency + Opt-In Spec Persistence** ([#165](https://github.com/pitimon/8-habit-ai-dev/issues/165))

Inspired by github/spec-kit's `/analyze` pattern, adapted to our discipline-not-enforcement philosophy. Three workflow skills (`/requirements`, `/design`, `/breakdown`) gain an opt-in `--persist <slug>` flag that writes their output to `docs/specs/<slug>/{prd,design,tasks}.md` while preserving conversation `SKILL_OUTPUT` blocks (back-compat invariant). The new `/consistency-check` skill reads those files and runs 5 detection passes — Coverage, Drift, Ambiguity, Underspec, Inconsistency — emitting severity-graded findings with file:line citations.

- **Hybrid evaluation** — deterministic when artifacts include `FR-NNN`/`Decision-N`/`Task #N` ID markers (recommended), LLM semantic with explicit warning when absent. PRD-EARS-2 back-compat preserved.
- **Read-only analyzer** — `allowed-tools: ["Read", "Glob", "Grep"]`. No gating, no enforcement (per plugin boundary doctrine — enforcement still belongs in `claude-governance`).
- **Self-applied dogfood** — this release's own PRD/design/tasks/ADR live in `docs/specs/consistency-check/`. Run `/consistency-check consistency-check` to verify.
- **5 alternatives considered** — see [ADR-013](docs/adr/ADR-013-spec-persistence-opt-in.md) for design rationale, flag-style argument convention attestation (`/ai-dev-log`, `/calibrate` precedents), and slug validation regex.

Skills count: 17 → 18. Closes #165.

## What's New in v2.14.3

**Theme: Post-Migration Cleanup + Validator Self-Discipline** ([#163](https://github.com/pitimon/8-habit-ai-dev/issues/163))

Patch release closing post-v2.14.2 metadata drift and applying the 800-line file-size rule the validator enforces on skills to the validator itself.

- **ADR-012 metadata closure** — `SELF-CHECK.md` lines 103-104 reframed (described deleted files as if still present); ADR-012 status header upgraded with `Implementation:` field naming commit `ed65b97` (v2.14.2) and metadata-closure date.
- **`.gitignore` hardening** — created with `/deep-project/` and `/.claude/` entries to gate against accidental `git add .` of third-party plugin clones and Claude Code session artifacts. Working copies preserved locally.
- **`tests/validate-content.sh` trim** — 831 → 793 lines via comment consolidation across Check 15, Check 19 sub-checks B/C/D/E/F/G, and F2/F3 sections. Logic untouched, total checks unchanged (10), PASS count preserved (205). Closes the credibility gap where the validator violated the 800-line rule it enforces.

Pattern: validator self-discipline — when a fitness function applies to the rest of the codebase, it applies to the validator too. Same shape as v2.14.1's "validator assertion, not checklist" principle.

---

## What's New in v2.14.2

**Theme: EU AI Act Migration Completion** (cross-plugin coordination with [`pitimon/claude-governance`](https://github.com/pitimon/claude-governance))

Plugin-boundary correction. The EU AI Act compliance toolkit migrated to `pitimon/claude-governance` v3.1.0 ([PR #26](https://github.com/pitimon/claude-governance/pull/26)) per memory observation #233270 (2026-04-07): `8-habit-ai-dev` = workflow discipline; `claude-governance` = compliance enforcement + framework mappings. EU AI Act compliance is a framework mapping, not a workflow step.

- **Removed** — `skills/eu-ai-act-check/reference.md`, `docs/research/eu-ai-act-obligations.md`, `guides/eu-ai-act-mapping.md` (now canonical in `pitimon/claude-governance` v3.1.0+)
- **Stub** — `skills/eu-ai-act-check/SKILL.md` rewritten as a redirect that names the canonical location, provides install + invocation examples, preserves NOT LEGAL ADVICE disclaimer, and links to ADR-012. Skill name remains valid in the catalog so existing cross-references resolve.
- **ADR-012** — completion-side migration ADR. ADR-005 marked Superseded. Establishes a reusable migration pattern.
- **Validator** — Check 15 in `tests/validate-content.sh` rewritten as stub-mode + negative-restore assertions.
- **Cross-refs reframed** — RESOLVER, using-8-habits, design Step 5, ai-dev-log, session-start hook, README skill table.

Pattern: smaller atomic deletion + stub + validator + ADR PR; cosmetic wiki/README badge cleanup deferred to a follow-up doc-only PR (precedent: `pitimon/claude-governance` PR #25 + #26 — local Markdown formatter rewrites tables on every Edit, producing 140+ lines of unrelated noise).

---

## What's New in v2.14.1

**Theme: README "What's New" Drift Guard** ([#157](https://github.com/pitimon/8-habit-ai-dev/issues/157))

Patch release closing an external QA finding — same bug class as #124 (CHANGELOG pointer-fallback) and #141 (SELF-CHECK.md body drift) recurring on a sibling surface (README.md "What's New" section).

- **README.md backfill** — `## What's New in v2.14.0` block restored (was missing — Check 19A passed silently because `grep -q "v${current_version}"` matched the badge URL `releases/tag/v2.14.0` instead of asserting the section header). Architecture file tree backfilled with 4 missing skills (calibrate, using-8-habits, eu-ai-act-check, ai-dev-log) so it matches the declared 17-skill count. TOC anchor fixed (`#whats-new-in-v220` → `#whats-new-in-v2141`) — broken since at least v2.3.0.
- **`tests/validate-content.sh` Check 19 sub-check G** — anchored grep `^## What's New in v${current_version}` in README.md. Mirrors sub-checks E + F mechanism from #144 (SELF-CHECK.md body freshness). Prevents the badge-URL false-positive class permanently.
- **Check 20 hardening** — `Find → Fix → Re-Verify` literal name pinned + assert exactly 5 numbered steps (1-5) in `skills/review-ai/SKILL.md` Verification Phase. Closes the v2.14.0 self-disclosed follow-up.

Pattern: validator assertion, not checklist — when QA surfaces the same drift class across multiple releases, the fix is a fitness function. Same shape as v2.11.1 (CHANGELOG drift guard) and v2.13.1 (SELF-CHECK body freshness).

## What's New in v2.14.0

**Theme: TOH Framework Inspirations** ([milestone #15](https://github.com/pitimon/8-habit-ai-dev/milestone/15))

Three workflow-discipline imports from Toh Framework (`Nathanphop/Toh-Framework`, now unavailable) (an "AI-Orchestration Driven Development" framework for solo SaaS builders), filtered through plugin-boundary rule (3/10 candidates imported, 7 rejected with route-elsewhere reasoning).

- **`SKILL_OUTPUT` attribution lines** ([#151](https://github.com/pitimon/8-habit-ai-dev/issues/151), [PR #152](https://github.com/pitimon/8-habit-ai-dev/pull/152)) — visible `[/<skill>] COMPLETE SKILL_OUTPUT:<type>` directly above each HTML comment in 4 emitter skills (design, breakdown, requirements, review-ai). Status markers `COMPLETE` / `PARTIAL` / `FAILED` (text-only, no emoji). New `validate-structure.sh` Check 22 enforces format (BSD-safe via `grep -B1`). `cross-verify` parser unaffected. Inspired by Toh's Agent Announcement format.
- **Argument-driven smart-routing for `/using-8-habits`** ([#149](https://github.com/pitimon/8-habit-ai-dev/issues/149), [PR #154](https://github.com/pitimon/8-habit-ai-dev/pull/154)) — `/using-8-habits "<intent>"` returns ≤3 ranked skills + reasoning + alternatives + a single direct question instead of the full narrative tree. Reads `~/.claude/habit-profile.md` for verbosity tier (dependence → independence → interdependence → significance) and recent `~/.claude/lessons/` for context. **Activates** existing `argument-hint` frontmatter — no new skill file. Inspired by Toh's `/toh` Smart Command (reshape: extend rather than wrap).
- **`/review-ai` Verification Phase** ([#150](https://github.com/pitimon/8-habit-ai-dev/issues/150), [PR #155](https://github.com/pitimon/8-habit-ai-dev/pull/155)) — Find → Fix → Re-Verify loop ending in a Verification Table (Finding | Severity | Fix Evidence | Status). **Plugin boundary**: section header reads "guidance only — NOT a hook"; three independent anchors (header + blockquote + step-5 prose) prevent future enforcement creep. New `validate-content.sh` Check 20 enforces all three anchors. Inspired by Toh's Test → Fix → Loop adapted as discipline guidance, not automated enforcement.

Companion proposal: [pitimon/claude-governance#24](https://github.com/pitimon/claude-governance/issues/24) for the 7-file project memory persistence layer (out-of-boundary for this plugin).

## What's New in v2.13.1

**Theme: SELF-CHECK.md Body Freshness** ([#141](https://github.com/pitimon/8-habit-ai-dev/issues/141))

- **SELF-CHECK.md body drift fixed** ([#142](https://github.com/pitimon/8-habit-ai-dev/pull/142)) — footer updated from `Previous: 2.7.1` to `Previous: 2.12.0` and 6 missing per-release rows added (v2.9.0 through v2.13.0). Plugin opens with _"H8 Modeling: Follow the process always, no shortcuts when unwatched"_ — the 6-release silent gap contradicted the stated principle.
- **CONTRIBUTING.md § Version Bumping corrected** ([#143](https://github.com/pitimon/8-habit-ai-dev/pull/143)) — "Version lives in **3 files**" → "**4 files**" and adds `SELF-CHECK.md` header to the list. The 4-file convention has been enforced by `tests/validate-structure.sh` since #106, but CONTRIBUTING.md never caught up.
- **`tests/validate-content.sh` Check 19 sub-checks E + F** ([#144](https://github.com/pitimon/8-habit-ai-dev/pull/144)) — CI invariant against SELF-CHECK.md body drift. Sub-check E asserts the footer references the tag immediately preceding `plugin.json.version` (derived from `git tag -l "v2.*" | sort -V`). Sub-check F asserts every v2.x tag has a matching `^- v<x.y.z>: ` row — no gaps. Prevents recurrence of the #141 drift class.
- **`.github/workflows/validate.yml`** — `fetch-tags: true` + `fetch-depth: 0` added to `actions/checkout@v4` so CI can read the tag list for sub-checks E + F.

## What's New in v2.13.0

**Theme: Cross-Agent Discoverability** ([#137](https://github.com/pitimon/8-habit-ai-dev/issues/137) + [#135](https://github.com/pitimon/8-habit-ai-dev/issues/135) + [#136](https://github.com/pitimon/8-habit-ai-dev/issues/136))

- **`skills/RESOLVER.md`** — flat phrase-to-skill dispatcher so new users and non-Claude agents can find the right skill without knowing slash-command names. All 17 skills in 3 sections (Workflow / Assessment / Meta), ≤3 triggers each. Bidirectional coverage enforced by Check 20 in `tests/validate-structure.sh`.
- **`llms.txt` + `AGENTS.md` at repo root** — Codex, Cursor, Windsurf, Aider, Continue, and LLM-based repo fetchers now have canonical entry points. `llms.txt` follows the [llmstxt.org](https://llmstxt.org) convention (flat doc-map with `raw.githubusercontent.com` URLs); `AGENTS.md` is the non-Claude operating protocol. Check 21 enforces both files exist and point to `skills/RESOLVER.md` + `CLAUDE.md`.
- **"Design Principle" section** — cites Garry Tan's 2026 essay [_"Thin Harness, Fat Skills"_](https://github.com/garrytan/gbrain/blob/master/docs/ethos/THIN_HARNESS_FAT_SKILLS.md) as external validation of the bounded-hook + fat-skills pattern the plugin has always enforced (≤300 token session hook).
- **ADR-010** (Flat Skill Dispatcher) and **ADR-011** (Cross-Agent Discoverability) — decision records with 6 options considered each.
- **Pattern extracted**: "Bidirectional Validator for Canonical Cross-References" — when a new canonical artifact ships, its validator check should assert both directions (source→target AND target→source). See `CHANGELOG.md` v2.13.0 or `~/.claude/lessons/2026-04-22-cross-agent-discoverability-batch.md`.

## What's New in v2.12.0

**Theme: Code-Symbol Grep Evidence** ([#133](https://github.com/pitimon/8-habit-ai-dev/issues/133))

- **`/research` Evidence Standard — code-symbol verdicts require grep evidence** — when an Audit-mode or Findings-table row's verdict matches `/remove|dead|unused|transitional|safe to (drop|remove)/i` on a code symbol (dep, module, function, exported type, file), the row must cite a grep-check showing consumers across the repo's source directories. Declaration-site citations (e.g. `package.json:6`) do not establish liveness. Closes a false-positive class where plausible-sounding "brand names differ, must be unrelated" reasoning passed Deep-mode verification with pristine citations (real-world: memforge `neo4j-driver` audit — `neo4j-driver` is the canonical Bolt client for Memgraph; would have broken production graph on first rebuild).
- **`/research` Step 4 clarification** — one-line callout after the Deep-mode dispatch makes the verifier's scope explicit inline: citation integrity, not semantic correctness.
- **`research-verifier` agent scope clarified** — `description:` frontmatter rewritten to say "citation-integrity verification agent" and to spell out what is out of scope. New `## Limit of Verification` section inside the agent body defines in-scope vs. out-of-scope, and introduces a `SEMANTIC-EVIDENCE-MISSING` flag the verifier emits (without performing the grep itself) when a code-symbol verdict row lacks liveness evidence. The agent's execution behavior is unchanged — this is a documentation change preventing authors from over-trusting a passing Deep-mode gate.

## What's New in v2.11.1

**Theme: CHANGELOG Drift Guard** ([#124](https://github.com/pitimon/8-habit-ai-dev/issues/124), [#131](https://github.com/pitimon/8-habit-ai-dev/pull/131))

- **`tests/validate-content.sh` Check 19 strengthened** — 3 new FAIL-severity assertions close the pointer-fallback loophole that let v2.9.0 and v2.11.0 ship with stale changelogs despite 491/491 validators passing. Now asserts: root `CHANGELOG.md` contains `^## v<version>` entry, wiki `Changelog.md` contains `^## v<version>` entry (no pointer-to-CHANGELOG.md fallback), wiki badge `latest-v<version>-blue` match.
- **Backfill v2.9.0 + v2.11.0** in root `CHANGELOG.md` (was jumping v2.10.0 → v2.8.0) and v2.11.0 in wiki `Changelog.md` + badge bump.
- **Lesson persisted** (`~/.claude/lessons/2026-04-17-v2.11.0-changelog-drift-recurrence.md`) as H7 capability pattern: when a QA surfaces the same drift class across 2+ releases, the fix is a validator assertion, not a checklist.

## What's New in v2.11.0

**Theme: Design Skill Pipeline Completion + Wiki Professional Redesign** ([#128](https://github.com/pitimon/8-habit-ai-dev/issues/128), [#127](https://github.com/pitimon/8-habit-ai-dev/issues/127))

- **`/design` structured output block** ([#128](https://github.com/pitimon/8-habit-ai-dev/issues/128)) — adds `SKILL_OUTPUT:design` block, closing the only gap in the `/requirements` → `/design` → `/breakdown` → `/review-ai` cross-skill handoff chain. `/cross-verify` can now auto-check design decisions (Q4, Q14, Q16).
- **`/design` tech stack + Whole Person** — decision list now includes language/runtime and framework selection. H8 Checkpoint expanded with Body/Mind/Heart/Spirit dimensions.
- **`/design` scope validation** — new step 1b consumes `SKILL_OUTPUT:requirements` to verify design doesn't expand beyond agreed scope.
- **`/design` decision heuristic** — H3-based guidance: split decisions affecting >3 layers, group decisions sharing trade-offs.
- **`/research` tech stack questions** — Step 1 research questions now include technology evaluation and ecosystem trade-offs.
- **Wiki professional redesign** ([#127](https://github.com/pitimon/8-habit-ai-dev/issues/127)) — 20 pages upgraded: hero Home page, new Architecture and Maturity-Model pages, Skills-Reference expanded to 17 skills with quick-select matrix, Workflow-Overview with Mermaid diagram, all Step pages with `> [!IMPORTANT]` checkpoints.

## What's New in v2.10.0

**Theme: Progressive-Disclosure SKILL.md Split** ([#125](https://github.com/pitimon/8-habit-ai-dev/issues/125), [ADR-009](docs/adr/ADR-009-skill-split-convention.md)) — refactor the 3 largest skills into SKILL.md + reference.md + examples.md triads, creating headroom for future features without breaking the F3 word-budget fitness function.

- **`using-8-habits` split** — SKILL 1990w → 1108w; `reference.md` (17-skill inventory + cross-plugin composition tables); `examples.md` (password-reset onboarding walkthrough).
- **`eu-ai-act-check` split** — SKILL 1989w → 908w; `reference.md` (full 9-obligation checklist with 60 tier-tagged items and paragraph references).
- **`calibrate` split** — SKILL 1774w → 1161w; `reference.md` (scoring rubric + profile-write procedure); `examples.md` (4 sample profiles, one per maturity level).
- **ADR-009 codifies the convention** — inline `Load ${CLAUDE_PLUGIN_ROOT}/skills/<name>/<file>.md` directives enforce lazy loading. Check 8 (structure validator) already hard-fails on broken sibling references — no new existence check needed.
- **F6 sibling word-budget soft limit** — new Check 9b warns (not fails) when `reference.md` or `examples.md` exceeds 5000 words, preventing unbounded growth without blocking legitimate reference material.
- **Content validator triad-awareness** — Checks 15 and 18 now search the triad as a unit, so content moved to sibling files still satisfies anti-drift and tier-count assertions.

## What's New in v2.9.0

**Theme: Claude Code Architecture Insights** — production patterns from Anthropic's Claude Code internals (reverse-engineered by [Alejandro Balderas](https://github.com/alejandrobalderas/claude-code-from-source)) adapted into plugin workflow guidance.

- **`/build-brief` context compression awareness** ([#114](https://github.com/pitimon/8-habit-ai-dev/issues/114)) — new step 6 "Context survival" guides users to front-load critical info, keep briefs under ~4,000 tokens, and order stable content before volatile content. Based on Claude Code's 4-layer context compression pipeline (Ch5) and prompt cache stability pattern (Ch17).
- **`/design` sticky latch principle** ([#116](https://github.com/pitimon/8-habit-ai-dev/issues/116)) — new step 5 "Identify sticky decisions" with rework-level classification table. Decisions marked STICKY (>50% rework to reverse) require a new `/design` cycle to change, preventing costly mid-session pivots. Inspired by Claude Code's sticky boolean latches for prompt cache stability.
- **`/reflect` lesson consolidation** ([#113](https://github.com/pitimon/8-habit-ai-dev/issues/113)) — new Step 7 "Consolidation check" nudges when lesson files exceed 10. New `/reflect consolidate` argument runs a 4-phase cycle (Orient → Gather → Consolidate → Prune) inspired by Claude Code's auto-dream memory consolidation. Human approval gate before any deletions.
- **`/breakdown` fork agent pattern** ([#115](https://github.com/pitimon/8-habit-ai-dev/issues/115)) — new step 5 "Token-efficient parallel design" with prompt prefix sharing guidance. Parallel tasks sharing context achieve ~90% input token savings via cache hits. Most valuable for 3+ parallel tasks.

## What's New in v2.7.1

**Theme: Review Discipline Refinement** — small post-milestone patch on top of v2.7.0, adding two review-time disciplines to `/review-ai` after a cost/benefit audit against `addyosmani/agent-skills` (MIT). Only the one genuine gap was imported; five other candidates were evaluated and rejected as duplicative or out-of-scope.

- **`/review-ai` Performance axis** ([#110](https://github.com/pitimon/8-habit-ai-dev/issues/110), [PR #111](https://github.com/pitimon/8-habit-ai-dev/pull/111)) — fourth review category alongside Security/Quality/Completeness. Flags N+1 queries, unbounded loops, missing pagination, unindexed queries, and memory leaks. Same `file:line` evidence standard as other axes.
- **`/review-ai` review-tests-first directive** — new Process step 2 directs the reviewer to open the new or changed test files before judging the implementation. Tests declare intent; reading them first gives the specification to review against.
- **Rejections preserved in PR** — `guides/anti-rationalization.md`, `guides/red-flags.md`, `guides/google-engineering-principles.md`, `/cross-verify` Q18, and a cross-plugin hard-gate spec were all evaluated and rejected. Rationale archived in the PR #111 body so future "research hype" passes don't re-litigate them.

## What's New in v2.7.0

**Theme: Reader Adoption** — closes the `/calibrate` feature loop (v2.6.0 wrote the profile, v2.7.0 makes the other 16 skills read it).

- **Hook-based verbosity adaptation** ([#96](https://github.com/pitimon/8-habit-ai-dev/issues/96)) — `hooks/session-start.sh` reads `~/.claude/habit-profile.md` at session start and emits a level-specific directive into context. Skills auto-adapt from Dependence (full guidance) through Significance (minimal prompts) with **zero changes to individual skill files** — F3 word budget preserved
- **`guides/verbosity-adaptation.md`** — canonical per-level adaptation rules with worked examples across 5 skill archetypes
- **`tests/test-verbosity-hook.sh`** — 12-assertion regression coverage for all 8 hook branches plus HABIT_QUIET opt-out and ≤300-token budget check
- **`preferences.verbosity-override`** in habit-profile schema — `verbose` promotes any level to Dependence, `concise` demotes to Significance
- **4 validators in CI** (up from 3) — total **482 assertions** across validate-structure, test-skill-graph, validate-content, test-verbosity-hook
- **Milestone v2.7.0 CLOSED** — Hermes-inspired feature loop (v2.6.0 + v2.7.0) complete; plugin at a local maximum given pure-markdown constraints

## What's New in v2.6.0 / v2.6.1

**Theme: Hermes-Inspired Improvements** — user-modeling + learning-loop patterns filtered through plugin-boundary discipline.

- **`/calibrate` skill + habit-profile schema v1** ([#90](https://github.com/pitimon/8-habit-ai-dev/issues/90), [ADR-008](docs/adr/ADR-008-user-maturity-calibration-design.md)) — 5-7 question self-assessment that writes `~/.claude/habit-profile.md` for other skills to adapt to. Dominant-level scoring across Dependence → Independence → Interdependence → Significance
- **`guides/habit-profile-schema.md`** — public schema contract (YAML + markdown, `schema-version: 1`) defining the writer-reader API future skills code against
- **Persistent reflection artifacts** ([#88](https://github.com/pitimon/8-habit-ai-dev/issues/88)) — `/reflect` persists lessons to `~/.claude/lessons/YYYY-MM-DD-<slug>.md`; `/research` and `/build-brief` search these before starting work. Closes the loop: reflect → persist → retrieve → apply
- **`/reflect` Q6 Skill Effectiveness signal** ([#92](https://github.com/pitimon/8-habit-ai-dev/issues/92)) — new 6th retro question naming "most useful" and "least useful/confusing" skill this session. Feeds maintainer-curated `SKILL-EFFECTIVENESS.md` trend tracker — **H7 applied to the plugin itself**
- **`guides/habit-nudges.md`** + **ADR-007** — nudge specification (hook implementation delegated to `claude-governance` per plugin boundary) + agentskills.io NO-GO decision record
- **Skill count: 16 → 17** (`/calibrate` added)

### Earlier Versions

- **v2.5.0** (2026-04-09) — Testing & Discoverability: `test-skill-graph.sh` DAG validator, `pre-commit.sh.example` template, bidirectional wiki ↔ skills linking
- **v2.4.1** (2026-04-09) — Honest Correction: removed `/brainstorm` after finding `superpowers:brainstorming` is a better implementation; added `HABIT_QUIET=1` opt-out; introduced "Core 5" tier (ADR-006)
- **v2.4.0** (2026-04-09) — Workflow Completions: `/brainstorm` (later removed), EARS-notation in `/requirements`, `/using-8-habits` onboarding meta-skill
- **v2.3.0** (2026-04-09) — EU AI Act Compliance Toolkit (flagship): `/eu-ai-act-check` 9-obligation tiered checklist, `/ai-dev-log` AI transparency, `/design` Article 14 human-oversight checkpoint, `docs/research/eu-ai-act-obligations.md` primary-source research, [ADR-005](docs/adr/ADR-005-eu-ai-act-toolkit.md), Plugin Boundary section
- **v2.2.0** (2026-04-07) — Body Dimension Level-Up: content validation (`validate-content.sh`), 3 architecture fitness functions, [ADR-003](docs/adr/ADR-003-content-validation.md)
- **v2.1.0** (2026-04-07) — Multi-Agent Research (Feynman-inspired): research depth levels, research modes, `research-verifier` agent, [ADR-002](docs/adr/ADR-002-research-modes.md)
- **v2.0.0** (2026-04-07) — Orchestration-Aware Development (ULW-inspired): task classification in `/breakdown`, context boundaries in `/build-brief`, [ADR-001](docs/adr/ADR-001-orchestration-patterns.md)
- **v1.9.0** — Feynman-inspired: `/research` skill, evidence grounding, [12 AI Integrity Commandments](guides/integrity-principles.md), confidence levels, lazy parallelism gate

Full release history: [`CHANGELOG.md`](CHANGELOG.md) (v2.3.0+) · [`docs/wiki/Changelog.md`](docs/wiki/Changelog.md) (v2.2.0 and earlier) · [GitHub Releases](https://github.com/pitimon/8-habit-ai-dev/releases)

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

| Term                   | Definition                                                                                              |
| ---------------------- | ------------------------------------------------------------------------------------------------------- |
| **Vibe Coding**        | Building software by feel without structured process. The anti-pattern this plugin addresses.           |
| **Handoff Contract**   | What a skill expects from its predecessor and produces for its successor. Ensures workflow continuity.  |
| **AI Blind Spot**      | The systematic tendency of AI tools to excel at Body/Mind dimensions while neglecting Heart/Spirit.     |
| **Whole Person Model** | Covey's 4-dimension framework: Body (discipline), Mind (vision), Heart (passion), Spirit (conscience).  |
| **Cross-Verification** | 17-question checklist covering all 8 habits with dimension mapping and scoring bands.                   |
| **Confidence Level**   | Marking a cross-verify answer as Verified (V), Inferred (I), or Unverified (U). From Feynman principle. |
| **Domain Pack**        | Optional 5-question set for specific domains (API, Frontend, Infra, AI/ML, Mobile). Scored separately.  |
| **Definition of Done** | 3-5 verifiable checkbox items that define when a skill's output is complete.                            |
| **When to Skip**       | Honest conditions under which a skill is genuinely unnecessary. Prevents compliance theater.            |
| **Orchestration**      | Multi-agent task dispatch patterns: sequential, parallel-safe, parallel-worktree _(v2.0.0)_.            |
| **Fitness Function**   | Automated metric tracking architecture health. Breach fails the CI build _(v2.2.0)_.                    |
| **Maturity Model**     | Progression: Dependence → Independence → Interdependence → Significance.                                |
| **Private Victory**    | Habits 1-3: self-management (proactive, end-in-mind, first-things-first).                               |
| **Public Victory**     | Habits 4-6: collaboration (win-win, understand-first, synergize).                                       |
| **ทำเสร็จ ≠ ทำดี**     | Thai: "Done is not done well." The plugin's core philosophy.                                            |

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

_Version: 2.21.0 | Last updated: 2026-06-06_
