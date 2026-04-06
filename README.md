# 8 Habits of Effective AI-Assisted Development

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Claude Code Plugin](https://img.shields.io/badge/Claude_Code-Plugin-7C3AED)](https://github.com/pitimon/8-habit-ai-dev)
[![Skills](https://img.shields.io/badge/Skills-13-blue)]()
[![Habits](https://img.shields.io/badge/Habits-8-orange)]()
[![Version](https://img.shields.io/badge/Version-1.9.0-brightgreen)](https://github.com/pitimon/8-habit-ai-dev/releases/tag/v1.9.0)

> **"ทำเสร็จ ≠ ทำดี"** — Shipping code is not the same as shipping _good_ code.
>
> This plugin replaces Vibe Coding with structured discipline: **7-step workflow skills** powered by **Covey's 8 Habits**.

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

```bash
# Step 1: Add the marketplace source
claude plugin marketplace add pitimon/8-habit-ai-dev

# Step 2: Install the plugin
claude plugin install 8-habit-ai-dev@pitimon-8-habit-ai-dev

# Step 3: Restart Claude Code, then use any skill:
/requirements       # Before you build anything
/review-ai          # Before you commit anything
/cross-verify       # Before you ship anything
/whole-person-check # Assess Body/Mind/Heart/Spirit balance
```

Three commands. The plugin loads a session reminder and makes 13 skills available.

---

## The 7-Step Workflow

Each step maps to one of Covey's 8 Habits — the habit explains _why_ the step matters.

```
 Step 0        Step 1       Step 2       Step 3        Step 4       Step 5       Step 6        Step 7
┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐
│Research  │→│Require-  │→│ Design   │→│Breakdown │→│  Build   │→│ Review   │→│ Deploy   │→│ Monitor  │
│          │ │ments     │ │          │ │          │ │  Brief   │ │          │ │  Guide   │ │  Setup   │
│          │ │          │ │          │ │          │ │          │ │          │ │          │ │          │
│ H5: Under│ │ H2: End  │ │ H8: Voice│ │ H3: First│ │ H5: Under│ │ H4: Win- │ │ H1: Pro- │ │ H7: Saw  │
│ -stand   │ │ in Mind  │ │          │ │ Things   │ │ -stand   │ │ Win      │ │ active   │ │          │
└──────────┘ └──────────┘ └──────────┘ └──────────┘ └──────────┘ └──────────┘ └──────────┘ └──────────┘
```

### Skills Reference

**7-Step Workflow** (sequential, with handoff contracts between steps):

| Skill            | Step | Habit                        | What It Does                                                     |
| ---------------- | ---- | ---------------------------- | ---------------------------------------------------------------- |
| `/research`      | 0    | H5: Seek First to Understand | Investigate existing solutions and constraints before specifying |
| `/requirements`  | 1    | H2: Begin with End in Mind   | Draft PRD — what, why, who, scope, success criteria              |
| `/design`        | 2    | H8: Find Your Voice          | Surface architecture decisions for **human** judgment            |
| `/breakdown`     | 3    | H3: Put First Things First   | Decompose into atomic tasks, prioritize by importance            |
| `/build-brief`   | 4    | H5: Seek First to Understand | Problem statement gate + context brief before implementing       |
| `/review-ai`     | 5    | H4: Think Win-Win            | 4-level verdict (PASS/CONCERNS/REWORK/FAIL) + dimension balance  |
| `/deploy-guide`  | 6    | H1: Be Proactive             | Staging-first deployment with rollback plan                      |
| `/monitor-setup` | 7    | H7: Sharpen the Saw          | Set up health checks, alerting, error tracking                   |

**Assessment & Verification** (use anytime):

| Skill                 | Habit               | What It Does                                                       |
| --------------------- | ------------------- | ------------------------------------------------------------------ |
| `/cross-verify`       | H1-H8               | 17-question checklist + dimension summary (Body/Mind/Heart/Spirit) |
| `/whole-person-check` | H8: Find Your Voice | 4-dimension assessment (1-5 scale) with AI Blind Spot detection    |
| `/security-check`     | H1: Be Proactive    | Focused OWASP security lens — secrets, injection, auth, deps       |
| `/reflect`            | H7: Sharpen the Saw | 5-question micro-retrospective (5 min max) with action tracking    |
| `/workflow`           | All                 | Guided 7-step walkthrough — invoke or skip each step               |

You don't need all 13 skills every time. Start with `/requirements` before building and `/review-ai` before committing — those two alone will eliminate most Vibe Coding problems. Use `/workflow` for a guided walkthrough if you're new.

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

**Maturity Rubrics** (3 levels per dimension): [guides/whole-person-rubrics.md](guides/whole-person-rubrics.md)

---

## Architecture

```
8-habit-ai-dev/
├── .claude-plugin/
│   ├── plugin.json                 # Plugin metadata (v1.9.0)
│   └── marketplace.json            # Marketplace listing
├── skills/                         # 13 skills (8 workflow + 5 standalone)
│   ├── research/SKILL.md           #   Step 0 → H5 (pre-requirements investigation)
│   ├── requirements/SKILL.md       #   Step 1 → H2
│   ├── design/SKILL.md             #   Step 2 → H8
│   ├── breakdown/SKILL.md          #   Step 3 → H3
│   ├── build-brief/SKILL.md        #   Step 4 → H5 (with research gate)
│   ├── review-ai/SKILL.md          #   Step 5 → H4 (4-level verdict)
│   ├── deploy-guide/SKILL.md       #   Step 6 → H1
│   ├── monitor-setup/SKILL.md      #   Step 7 → H7
│   ├── cross-verify/SKILL.md       #   All habits (17Q + dimension summary)
│   ├── whole-person-check/SKILL.md #   H8: Body/Mind/Heart/Spirit
│   ├── security-check/SKILL.md     #   H1: OWASP security lens
│   ├── reflect/SKILL.md            #   H7: micro-retrospective
│   └── workflow/SKILL.md           #   Guided 7-step walkthrough
├── agents/
│   └── 8-habit-reviewer.md         # Deep cross-verification agent
├── hooks/
│   ├── hooks.json                  # SessionStart hook registration
│   └── session-start.sh            # Workflow reminder + progress indicators
├── habits/                         # Reference content (loaded on-demand)
│   ├── h1-be-proactive.md
│   ├── h2-begin-with-end.md
│   ├── h3-first-things-first.md
│   ├── h4-win-win.md
│   ├── h5-understand-first.md
│   ├── h6-synergize.md
│   ├── h7-sharpen-saw.md
│   └── h8-find-voice.md
├── guides/
│   ├── cross-verification.md       # 17-point checklist
│   ├── whole-person-rubrics.md     # 4-dimension maturity rubrics
│   ├── integrity-principles.md    # 12 AI Integrity Commandments
│   ├── quick-reference.md          # 19 prioritized rules (scannable)
│   ├── situation-map.md            # 15 situations → right habit/skill
│   ├── templates/                  # Output templates
│   │   ├── prd-template.md         #   For /requirements
│   │   ├── adr-template.md         #   For /design
│   │   ├── task-list-template.md   #   For /breakdown
│   │   └── review-report-template.md # For /review-ai
│   └── cross-verify-packs/         # Domain question packs (5 questions each)
│       ├── api.md                  #   API development
│       ├── frontend.md             #   Frontend/UI
│       ├── infra.md                #   Infrastructure
│       ├── ai-ml.md                #   AI/ML systems
│       └── mobile.md               #   Mobile apps
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
- **Output templates** — structured formats for PRD, ADR, task list, review report
- **Dimension mapping** — all 17 cross-verify questions tagged with Body/Mind/Heart/Spirit

---

## What's New in v1.9.0

Inspired by patterns from [getcompanion-ai/feynman](https://github.com/getcompanion-ai/feynman) — an AI research agent that enforces "URL or it didn't happen."

- **`/research`** (Step 0) — investigate existing solutions and constraints _before_ defining requirements
- **Evidence grounding** in `/review-ai` — every finding must cite `file:line`, not just "you should consider..."
- **[12 AI Integrity Commandments](guides/integrity-principles.md)** — "Never claim tested without test output", "Never fabricate file paths"
- **Confidence levels** in `/cross-verify` — mark answers as Verified / Inferred / Unverified for high-stakes reviews
- **Lazy Parallelism Gate** in `/breakdown` — "Can I do this in ≤5 tool calls?" before spawning agents

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

_Version: 1.9.0 | Last updated: 2026-04-07_
