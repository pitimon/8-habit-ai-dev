![Version](https://img.shields.io/badge/version-2.10.0-blue) ![Skills](https://img.shields.io/badge/skills-17-green) ![License](https://img.shields.io/badge/license-MIT-brightgreen) ![Dependencies](https://img.shields.io/badge/dependencies-0-orange) ![Review](https://img.shields.io/badge/external_review-9.5%2F10-gold)

# 8-Habit AI Dev

> [!IMPORTANT]
> **Anti-Vibe-Coding plugin for Claude Code.**
> A 7-step workflow discipline and 8-Habit cross-verification framework that replaces ad-hoc AI prompting with structured, reviewable, governable development.
>
> _"ทำเสร็จ ≠ ทำดี"_ — _Done_ is not _Done well_.

## Why This Exists

AI-assisted coding is fast but often undisciplined: missing requirements, skipped reviews, no rollback plans, accumulating tech debt. This plugin enforces the habits that separate effective developers from vibe coders — based on Stephen Covey's _7 Habits_ + _The 8th Habit_, adapted for the AI era.

## At a Glance

|                       |                                                                                                           |
| --------------------- | --------------------------------------------------------------------------------------------------------- |
| **17 skills**         | 7 workflow + 5 assessment + 2 meta + 2 compliance + 1 orchestrator                                        |
| **8 Habits**          | Covey's 7 + The 8th, adapted for AI-assisted development                                                  |
| **9 ADRs**            | Every non-trivial decision documented                                                                     |
| **4 maturity levels** | [Dependence → Independence → Interdependence → Significance](Maturity-Model)                              |
| **Zero dependencies** | Pure markdown — no npm, no build step                                                                     |
| **EU AI Act ready**   | First Claude Code plugin with [compliance toolkit](Skills-Reference#compliance--audit-skills)             |
| **External review**   | Scored **9.5/10** (EXCELLENT) on [first formal audit](https://github.com/pitimon/8-habit-ai-dev/issues/1) |

> [!TIP]
> **New here?** Start with [Installation](Installation) then [Getting Started](Getting-Started).
> Already installed? Jump to [Workflow Overview](Workflow-Overview) or type `/using-8-habits` in Claude Code.

## The 7-Step Workflow

```
Legend:  [O] optional   [H] human checkpoint   [!] NEVER SKIP

   [O] 0 · /research        H5 Understand    investigate before specifying
        │
        ▼
   [H] 1 · /requirements    H2 End in Mind   define what, why, who
        │
        ▼
   [H] 2 · /design          H8 Voice         architecture (human-led)
        │
        ▼
   [O] 3 · /breakdown       H3 First Things  atomic tasks, no scope creep
        │
        ▼
   [O] 4 · /build-brief     H5 Understand    context before coding
        │
        ▼
   [!] 5 · /review-ai       H4 Win-Win       audit before commit
        │
        ▼
   [H] 6 · /deploy-guide    H1 Proactive     staging first, rollback ready
        │
        ▼
   [O] 7 · /monitor-setup   H7 Sharpen Saw   observe after deploy
```

| Step | Command                                  | Habit | Purpose                            |
| ---- | ---------------------------------------- | ----- | ---------------------------------- |
| 0    | [`/research`](Step-0-Research)           | H5    | Investigate before specifying      |
| 1    | [`/requirements`](Step-1-Requirements)   | H2    | Define what, why, who              |
| 2    | [`/design`](Step-2-Design)               | H8    | Architecture decisions (human-led) |
| 3    | [`/breakdown`](Step-3-Breakdown)         | H3    | Atomic tasks, no scope creep       |
| 4    | [`/build-brief`](Step-4-Build-Brief)     | H5    | Context before coding              |
| 5    | [`/review-ai`](Step-5-Review-AI)         | H4    | Audit before commit                |
| 6    | [`/deploy-guide`](Step-6-Deploy-Guide)   | H1    | Staging first, rollback ready      |
| 7    | [`/monitor-setup`](Step-7-Monitor-Setup) | H7    | Observe after deploy               |

## Beyond the Workflow

**Assessment** — run at any point for deeper analysis:

| Skill                                                        | Purpose                                         |
| ------------------------------------------------------------ | ----------------------------------------------- |
| [`/cross-verify`](Skills-Reference#cross-verify)             | 17-question 8-Habit checklist                   |
| [`/whole-person-check`](Skills-Reference#whole-person-check) | Body/Mind/Heart/Spirit balance                  |
| [`/security-check`](Skills-Reference#security-check)         | OWASP Top 10 focused review                     |
| [`/reflect`](Skills-Reference#reflect)                       | Post-task retrospective with lesson persistence |
| [`/workflow`](Skills-Reference#workflow)                     | Interactive guided walkthrough                  |

**Meta & Onboarding** — learn and adapt:

| Skill                                                | Purpose                                        |
| ---------------------------------------------------- | ---------------------------------------------- |
| [`/using-8-habits`](Skills-Reference#using-8-habits) | Onboarding decision tree — which skill when?   |
| [`/calibrate`](Skills-Reference#calibrate)           | Self-assess maturity, adapt guidance verbosity |

**Compliance & Audit** — governance and transparency:

| Skill                                                  | Purpose                                          |
| ------------------------------------------------------ | ------------------------------------------------ |
| [`/eu-ai-act-check`](Skills-Reference#eu-ai-act-check) | EU AI Act 9-obligation checklist (Articles 9-15) |
| [`/ai-dev-log`](Skills-Reference#ai-dev-log)           | AI-assisted development log from git history     |

## Principles

> [!NOTE]
> Skills are **read-only guidance** — they tell Claude how to approach a task. They never edit files themselves.

- **Human-in-the-loop** for architecture and irreversible decisions
- **Zero dependencies**: pure markdown + bash validation
- **PR-first**: every change goes through review, even documentation
- **Complementary**: pairs with [`claude-governance`](https://github.com/pitimon/claude-governance) for enforcement + compliance

## Reference

- **[8 Habits](Habits-Reference)** — the full playbook
- **[Skills Catalog](Skills-Reference)** — all 17 skills, when to use each
- **[Architecture](Architecture)** — how the plugin works internally
- **[Maturity Model](Maturity-Model)** — adaptive guidance levels
- **[Vibe Coding vs Structured](Vibe-Coding-vs-Structured)** — side-by-side comparison
- **[FAQ](FAQ)** · **[Troubleshooting](Troubleshooting)**

## Contributing

See [Contributing to Wiki](Contributing-to-Wiki). The wiki is a build artifact — edit `docs/wiki/<page>.md` and open a PR.
