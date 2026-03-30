# 8 Habits of Effective AI-Assisted Development

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Claude Code Plugin](https://img.shields.io/badge/Claude_Code-Plugin-7C3AED)](https://github.com/pitimon/8-habit-ai-dev)
[![Skills](https://img.shields.io/badge/Skills-8-blue)]()
[![Habits](https://img.shields.io/badge/Habits-8-orange)]()

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
/cross-verify       # Before you ship anything
```

Three commands. The plugin loads a session reminder and makes 8 skills available.

---

## The 7-Step Workflow

Each step maps to one of Covey's 8 Habits — the habit explains _why_ the step matters.

```
 Step 1        Step 2       Step 3        Step 4       Step 5       Step 6        Step 7
┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐
│Require-  │→│ Design   │→│Breakdown │→│  Build   │→│ Review   │→│ Deploy   │→│ Monitor  │
│ments     │ │          │ │          │ │  Brief   │ │          │ │  Guide   │ │  Setup   │
│          │ │          │ │          │ │          │ │          │ │          │ │          │
│ H2: End  │ │ H8: Voice│ │ H3: First│ │ H5: Under│ │ H4: Win- │ │ H1: Pro- │ │ H7: Saw  │
│ in Mind  │ │          │ │ Things   │ │ -stand   │ │ Win      │ │ active   │ │          │
└──────────┘ └──────────┘ └──────────┘ └──────────┘ └──────────┘ └──────────┘ └──────────┘
```

### Skills Reference

| Skill            | Step | Habit                        | What It Does                                                |
| ---------------- | ---- | ---------------------------- | ----------------------------------------------------------- |
| `/requirements`  | 1    | H2: Begin with End in Mind   | Draft PRD — what, why, who, scope, success criteria         |
| `/design`        | 2    | H8: Find Your Voice          | Surface architecture decisions for **human** judgment       |
| `/breakdown`     | 3    | H3: Put First Things First   | Decompose into atomic tasks, prioritize by importance       |
| `/build-brief`   | 4    | H5: Seek First to Understand | Read existing code, build context brief before implementing |
| `/review-ai`     | 5    | H4: Think Win-Win            | Audit AI output — security, quality, completeness           |
| `/deploy-guide`  | 6    | H1: Be Proactive             | Staging-first deployment with rollback plan                 |
| `/monitor-setup` | 7    | H7: Sharpen the Saw          | Set up health checks, alerting, error tracking              |
| `/cross-verify`  | All  | H1-H8                        | 17-question checklist across all 8 habits                   |

You don't need to use all 8 skills every time. Start with `/requirements` before building and `/review-ai` before committing — those two alone will eliminate most Vibe Coding problems.

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

The `/cross-verify` skill runs **17 questions** across all 8 habits. Use it after planning and before committing to multi-file changes.

| Category        | Questions   | Habits                                                |
| --------------- | ----------- | ----------------------------------------------------- |
| Private Victory | 8 questions | H1 (scope), H2 (criteria), H3 (priority)              |
| Public Victory  | 6 questions | H4 (feedback), H5 (understanding), H6 (parallel work) |
| Renewal         | 3 questions | H7 (tech debt), H8 (meaning)                          |

Full checklist: [guides/cross-verification.md](guides/cross-verification.md)

---

## Architecture

```
8-habit-ai-dev/
├── .claude-plugin/
│   ├── plugin.json                 # Plugin metadata (v1.0.0)
│   └── marketplace.json            # Marketplace listing
├── skills/                         # 8 actionable workflow skills
│   ├── requirements/SKILL.md       #   Step 1 → H2
│   ├── design/SKILL.md             #   Step 2 → H8
│   ├── breakdown/SKILL.md          #   Step 3 → H3
│   ├── build-brief/SKILL.md        #   Step 4 → H5
│   ├── review-ai/SKILL.md          #   Step 5 → H4
│   ├── deploy-guide/SKILL.md       #   Step 6 → H1
│   ├── monitor-setup/SKILL.md      #   Step 7 → H7
│   └── cross-verify/SKILL.md       #   All habits (17 questions)
├── agents/
│   └── 8-habit-reviewer.md         # Deep cross-verification agent
├── hooks/
│   ├── hooks.json                  # SessionStart hook registration
│   └── session-start.sh            # 7-step workflow reminder
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
│   └── cross-verification.md       # 17-point checklist
├── rules/
│   └── effective-development.md    # Auto-loaded Claude Code rules
├── CLAUDE.md                       # Plugin development guide
└── README.md                       # This file
```

**Design decisions:**

- **Skills are empowering, not restrictive** — reminders and tools, not blocking gates
- **Habit content loaded on-demand** — skills reference `habits/*.md` only when invoked, keeping session context lean
- **Session hook under 300 tokens** — light reminder, not a wall of text
- **Existing content preserved** — `habits/`, `guides/`, `rules/` are reference material, never modified by skills

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

- Add real examples to `habits/*.md` files
- Propose new cross-verification questions in `guides/cross-verification.md`
- Report issues with skills at [GitHub Issues](https://github.com/pitimon/8-habit-ai-dev/issues)

## License

MIT

---

_Version: 1.0.0 | Last updated: 2026-03-31_
