# 8 Habits of Effective AI-Assisted Development

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Claude Code Plugin](https://img.shields.io/badge/Claude_Code-Plugin-7C3AED)](https://github.com/pitimon/8-habit-ai-dev)
[![Skills](https://img.shields.io/badge/Skills-17-blue)]()
[![EU AI Act](https://img.shields.io/badge/EU%20AI%20Act-ready-green)]()
[![Habits](https://img.shields.io/badge/Habits-8-orange)]()
[![Version](https://img.shields.io/badge/Version-2.7.0-brightgreen)](https://github.com/pitimon/8-habit-ai-dev/releases/tag/v2.7.0)
[![Wiki](https://img.shields.io/badge/docs-Wiki-informational)](https://github.com/pitimon/8-habit-ai-dev/wiki)

📖 **Full documentation**: **[Wiki](https://github.com/pitimon/8-habit-ai-dev/wiki)** — deep-dive guides per step, [FAQ](https://github.com/pitimon/8-habit-ai-dev/wiki/FAQ), [Troubleshooting](https://github.com/pitimon/8-habit-ai-dev/wiki/Troubleshooting), and the [8 Habits Reference](https://github.com/pitimon/8-habit-ai-dev/wiki/Habits-Reference).

> **"ทำเสร็จ ≠ ทำดี"** — Shipping code is not the same as shipping _good_ code.
>
> AI coding tools are powerful — but "build me X" without requirements, review, or staging creates fast, fragile code. This plugin adds the discipline AI lacks: **17 skills** across a **7-step workflow**, grounded in **Covey's 8 Habits** of effective development.

---

## Table of Contents

**Get Started**

- [The Problem](#the-problem) — Why this exists
- [Quick Start](#quick-start) — Install in 3 steps, verify in 1

**The Framework**

- [7-Step Workflow](#the-7-step-workflow) — Visual pipeline from research to monitoring
- [Skills Reference](#skills-reference) — All 17 skills with habit mappings
- [Use Cases](#use-cases-which-skill-when) — Common scenarios and recommended paths
- [The 8 Habits](#the-8-habits) — Principles behind the workflow
- [Maturity Model](#the-maturity-model) — Dependence to Significance

**Deep Dives**

- [Cross-Verification](#cross-verification) — 17-question checklist + scoring
- [Whole Person Assessment](#whole-person-assessment) — Body/Mind/Heart/Spirit + worked example
- [Agents](#agents) — Read-only reviewers that analyze your work
- [Architecture](#architecture) — File tree + design decisions

**Reference**

- [What's New](#whats-new-in-v220) — Version history
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

## Quick Start

**Install:**

```bash
claude plugin marketplace add pitimon/8-habit-ai-dev
claude plugin install 8-habit-ai-dev@pitimon-8-habit-ai-dev
```

**Use** (restart Claude Code, then invoke any skill):

```
/requirements       # Before you build anything
/review-ai          # Before you commit anything
/cross-verify       # Before you ship anything
/whole-person-check # Assess Body/Mind/Heart/Spirit balance
```

**Verify installation**: After restarting, you should see `## 8-Habit AI Dev Active` in the session banner with the 7-step workflow reminder.

**New to the plugin?** Start with `/workflow` for a guided walkthrough, or see [Use Cases](#use-cases-which-skill-when) to find the right skill for your situation.

Two commands to install. The plugin loads a session reminder and makes 17 skills available.

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
| `/deploy-guide`  | 6    | H1: Be Proactive             | Staging-first deployment with rollback plan                                                                 |
| `/monitor-setup` | 7    | H7: Sharpen the Saw          | Set up health checks, alerting, error tracking                                                              |

### Assessment Skills (Use Anytime)

| Skill                 | Habit               | Purpose                                                                       |
| --------------------- | ------------------- | ----------------------------------------------------------------------------- |
| `/cross-verify`       | H1-H8               | 17-question checklist + dimension summary (Body/Mind/Heart/Spirit)            |
| `/whole-person-check` | H8: Find Your Voice | 4-dimension assessment (1-5 scale) with AI Blind Spot detection               |
| `/security-check`     | H1: Be Proactive    | Focused OWASP security lens — secrets, injection, auth, deps                  |
| `/reflect`            | H7: Sharpen the Saw | 5-question micro-retrospective (5 min max) with action tracking               |
| `/workflow`           | All                 | Guided 7-step walkthrough — invoke or skip each step                          |
| `/calibrate`          | H8: Find Your Voice | Self-assessment (5-7 questions) → writes `~/.claude/habit-profile.md` so other skills adapt verbosity to your maturity level |
| `/using-8-habits`     | H5 + H8             | Onboarding meta-skill — all 17 skills + decision tree for "which skill next?" |
| `/eu-ai-act-check`    | H1 + H8 (Spirit)    | EU AI Act compliance — 9 obligations × tiered checklist (Art. 9-15)           |
| `/ai-dev-log`         | H4 + H1             | Generate AI-assisted dev log from git history for audit trail                 |

---

## Use Cases: Which Skill When?

Start from **your situation**, not the skill name.

| I want to...                      | Start with      | Then                        | Habit                   |
| --------------------------------- | --------------- | --------------------------- | ----------------------- |
| Build a new feature from scratch  | `/requirements` | `/design` → `/breakdown`    | H2: Define done first   |
| Review code before committing     | `/review-ai`    | `/security-check` if needed | H4: Never skip review   |
| Understand an unfamiliar codebase | `/research`     | `/build-brief`              | H5: Read before writing |
| Deploy to production              | `/deploy-guide` | `/monitor-setup`            | H1: Staging first       |
| Assess overall project health     | `/cross-verify` | `/whole-person-check`       | All 8 habits            |
| Fix a production bug              | `/build-brief`  | Reproduce first             | H5: Understand first    |
| Something feels off about a plan  | `/cross-verify` | Check dimension scores      | H1-H8                   |
| Learn the full workflow           | `/workflow`     | (guided walkthrough)        | All                     |

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
│   ├── plugin.json                 # Plugin metadata (v2.7.0)
│   └── marketplace.json            # Marketplace listing
├── skills/                         # 17 skills (8 workflow + 9 standalone)
│   ├── research/SKILL.md           #   Step 0 → H5 (depth levels + modes)
│   ├── requirements/SKILL.md       #   Step 1 → H2
│   ├── design/SKILL.md             #   Step 2 → H8
│   ├── breakdown/SKILL.md          #   Step 3 → H3 (orchestration classification)
│   ├── build-brief/SKILL.md        #   Step 4 → H5 (context boundaries)
│   ├── review-ai/SKILL.md          #   Step 5 → H4 (4-level verdict)
│   ├── deploy-guide/SKILL.md       #   Step 6 → H1
│   ├── monitor-setup/SKILL.md      #   Step 7 → H7
│   ├── cross-verify/SKILL.md       #   All habits (17Q + dimension summary)
│   ├── whole-person-check/SKILL.md #   H8: Body/Mind/Heart/Spirit
│   ├── security-check/SKILL.md     #   H1: OWASP security lens
│   ├── reflect/SKILL.md            #   H7: micro-retrospective
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
│   ├── integrity-principles.md    # 12 AI Integrity Commandments
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
│   └── adr/                        # Architecture Decision Records
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

This framework was developed while building [MemForge](https://github.com/pitimon/claud-mem-me) — a production AI memory system with 15 services, 154K+ observations, and a 3-node Docker Swarm cluster. Over 910 man-day-equivalents of AI-assisted development, these habits emerged from real mistakes:

- **H1**: A deploy bypassed staging and went straight to production (now there's a mandatory staging-first rule)
- **H4**: Code reviews were skipped "just this once" — 2 CRITICAL and 3 HIGH issues shipped (now review-before-commit is enforced)
- **H7**: Monitoring was the weakest step across 3 projects — a systematic blind spot we only caught through cross-project analysis
- **H5**: A database password mismatch crashed production because nobody validated the .env file before deploying

Every habit in this plugin exists because **skipping it caused real damage**.

---

## FAQ

**Q: Do I need to use all 17 skills for every task?**
No. Start with `/requirements` before building and `/review-ai` before committing. Those two alone eliminate most Vibe Coding problems. Add more skills as they feel natural. See [Use Cases](#use-cases-which-skill-when).

**Q: What is "Vibe Coding"?**
Building software by feel — jumping straight to "build me X" without requirements, design, or review. AI tools amplify this tendency because they make coding feel effortless. This plugin provides structure without removing speed.

**Q: How is this different from a linter or CI tool?**
Linters check syntax. CI checks tests. This plugin checks _process_ — did you define success criteria? Did you review before committing? Did you consider security? It operates at the planning and judgment layer, not the code layer.

**Q: What does "ทำเสร็จ ≠ ทำดี" mean?**
Thai: "Done is not done well." Completing a task (ทำเสร็จ) is not the same as completing it with quality (ทำดี). This principle is the plugin's core identity — speed without discipline creates debt.

**Q: Can I use this without Claude Code?**
The skills require Claude Code's plugin system. However, the underlying principles work with any AI tool. See [Alternative Setup](#alternative-setup-without-plugin) to load just the rules file, or read the `habits/` files as standalone guides.

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

If you prefer not to install the plugin, you can use the rules file directly:

```bash
# Install rules only (no skills, no hooks)
mkdir -p ~/.claude/rules
curl -sL https://raw.githubusercontent.com/pitimon/8-habit-ai-dev/main/rules/effective-development.md \
  -o ~/.claude/rules/effective-development.md
```

This auto-loads the 8-Habit principles into every Claude Code session without the skills or hooks.

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

_Version: 2.7.0 | Last updated: 2026-04-11_
