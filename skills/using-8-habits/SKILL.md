---
name: using-8-habits
description: >
  Onboarding meta-skill — explains the 7-step workflow, all 17 skills, and the
  decision tree for "which skill next?". Read this first when starting with
  8-habit-ai-dev. Maps to H5 (Seek First to Understand) + H8 (Empower next person).
user-invocable: true
argument-hint: "[optional: specific scenario, e.g. 'building a new feature']"
allowed-tools: ["Read", "Glob", "Grep"]
prev-skill: none
next-skill: any
---

# Using 8-Habit AI Dev (คู่มือเริ่มต้น)

**Habit**: H5 (Seek First to Understand — read before acting) + H8 (Find Your Voice — empower the next person)

**Purpose**: First skill to invoke when you're new to 8-habit-ai-dev, or when you're unsure which skill fits your current task. Explains the 7-step workflow, all 17 skills, and provides a decision tree for "which skill next?".

## When to Use This Skill

- First time using the plugin — start here
- Unsure which skill to invoke for your current task
- Onboarding a new team member or AI agent to the plugin
- Wanting a refresher on the 7-step workflow
- Deciding whether to skip a step (and needing the honest skip rules)

## When to Skip

- You already know exactly which skill you need → invoke it directly
- You're in the middle of an established workflow (e.g. already did `/requirements`, going to `/design`) — the skill itself will tell you what comes next via the `next-skill` frontmatter field

## The Core 5 (80/20 rule)

**Most tasks only need these 5 skills**:

1. **`/requirements`** — define what "done" looks like before coding (H2)
2. **`/review-ai`** — audit AI-generated code before committing (H4)
3. **`/cross-verify`** — 17-question 8-habit checklist before shipping (H1–H8)
4. **`/research`** — investigate before specifying when the problem is new (H5)
5. **`/reflect`** — 5-question micro-retrospective after completing significant work (H7)

The other 12 skills are **optional depth** for specific situations — compliance (`/eu-ai-act-check`), architecture-heavy work (`/design`), cross-plugin flows, transparency logs (`/ai-dev-log`), onboarding (this skill), etc. Running all 17 skills for every task is theater. Pick what fits.

**Honest framing**: if you're doing a single-line bug fix, rename refactor, or dependency bump — run `/review-ai` and skip the rest. Run more skills as the scope grows.

## The Core Idea

8-habit-ai-dev enforces a **7-step workflow** grounded in Covey's 8 Habits. Each step is a skill. Each skill tells you what it expects from the previous step and what it produces for the next step. The chain prevents "vibe coding" — the anti-pattern of jumping straight to code without thinking.

**Three skill categories**:

1. **Workflow skills** (Steps 0-7) — the 7-step chain, used roughly in order for new features
2. **Assessment skills** — invoke anytime to review quality (cross-verify, whole-person-check, security-check, reflect)
3. **Meta skills** — navigation + transparency (workflow, using-8-habits, ai-dev-log)

## The 7-Step Workflow

Each step maps to a Covey habit. The habit explains WHY the step matters.

| Step | Skill            | Habit                  | What it produces                                    | Skip if...                       |
| ---- | ---------------- | ---------------------- | --------------------------------------------------- | -------------------------------- |
| 0    | `/research`      | H5: Understand First   | Research brief with sources + recommendation        | Requirements already clear       |
| 1    | `/requirements`  | H2: Begin with End     | PRD + EARS acceptance criteria                      | Single-line bug fix              |
| 2    | `/design`        | H8: Find Your Voice    | Architecture decisions (human decides, AI proposes) | No architecture impact           |
| 3    | `/breakdown`     | H3: First Things First | Atomic task list with dependencies                  | Single task, scope clear         |
| 4    | `/build-brief`   | H5: Understand First   | Context brief for each task before coding           | Familiar code, context fresh     |
| 5    | `/review-ai`     | H4: Win-Win            | 4-level verdict (PASS/CONCERNS/REWORK/FAIL)         | **Never skip**                   |
| 6    | `/deploy-guide`  | H1: Be Proactive       | Staging-first deployment plan                       | No deployment involved           |
| 7    | `/monitor-setup` | H7: Sharpen the Saw    | Health checks, alerting, error tracking             | Monitoring already comprehensive |

**When the problem is fuzzy** (before `/research`): use `superpowers:brainstorming` — hard-gate design session that writes a spec doc before implementation. Replaces our removed `/brainstorm` (ADR-006).

**The chain is opt-in, not forced**. Every skill has a `next-skill` field in its frontmatter pointing to the default successor, but you can jump, skip, or loop as needed. The honest skip rule: if you can justify skipping a step out loud, skip it. If you can't, run it.

For the full inventory of all 17 skills organized by category, see the reference file below.

Load `${CLAUDE_PLUGIN_ROOT}/skills/using-8-habits/reference.md` for the full 17-skill inventory and cross-plugin composition tables.

## Decision Tree: Which Skill Next?

Use this tree to pick your starting point. Each leaf maps to an entry skill.

```
What are you doing?
│
├── Starting a new feature from scratch
│   ├── Is the problem statement fuzzy? ─── YES → superpowers:brainstorming
│   └── Is the problem clear?            ─── YES → /research (Step 0)
│
├── Feature already scoped, need to build
│   ├── Is there a PRD?                  ─── NO  → /requirements (Step 1)
│   └── Is there an architecture plan?   ─── NO  → /design (Step 2)
│
├── Architecture done, need to implement
│   ├── Atomic tasks defined?            ─── NO  → /breakdown (Step 3)
│   └── Ready to write code?             ─── YES → /build-brief (Step 4)
│
├── Code written, need to verify
│   ├── Before committing                ─── /review-ai (Step 5) + /security-check
│   └── Before merging                   ─── /cross-verify + /review-ai
│
├── Ready to ship
│   ├── Need deployment plan             ─── /deploy-guide (Step 6)
│   └── Need monitoring                  ─── /monitor-setup (Step 7)
│
├── Something feels wrong but can't pinpoint
│   └──                                  ─── /cross-verify (17-question checklist)
│
├── Just finished a big task
│   └──                                  ─── /reflect (5-question retro)
│
└── New to the plugin or onboarding someone
    └──                                  ─── /using-8-habits (this skill)
```

For a worked end-to-end example (password reset feature, all 11 steps), see the examples file below.

Load `${CLAUDE_PLUGIN_ROOT}/skills/using-8-habits/examples.md` for the full onboarding walkthrough.

## Handoff

- **Expects from predecessor**: Nothing (this is a starting-point skill)
- **Produces for successor**: A recommendation — "invoke `/[skill]` next" — based on your situation and the decision tree

## Definition of Done

- [ ] User understands the 3 skill categories (workflow / assessment / meta)
- [ ] User can name at least 3 workflow skills and their purposes
- [ ] User has picked their next skill based on the decision tree
- [ ] User knows about the honest skip rule: justify skipping out loud, or run the step
- [ ] User knows `/cross-verify` + `/reflect` exist for review and retrospective
