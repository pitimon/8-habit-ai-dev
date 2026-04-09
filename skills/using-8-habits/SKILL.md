---
name: using-8-habits
description: >
  Onboarding meta-skill — explains the 7-step workflow, all 16 skills, and the
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

**Purpose**: First skill to invoke when you're new to 8-habit-ai-dev, or when you're unsure which skill fits your current task. Explains the 7-step workflow, all 16 skills, and provides a decision tree for "which skill next?".

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

The other 11 skills are **optional depth** for specific situations — compliance (`/eu-ai-act-check`), architecture-heavy work (`/design`), cross-plugin flows, transparency logs (`/ai-dev-log`), onboarding (this skill), etc. Running all 16 skills for every task is theater. Pick what fits.

**Honest framing**: if you're doing a single-line bug fix, rename refactor, or dependency bump — run `/review-ai` and skip the rest. Run more skills as the scope grows.

## The Core Idea

8-habit-ai-dev enforces a **7-step workflow** grounded in Covey's 8 Habits. Each step is a skill. Each skill tells you what it expects from the previous step and what it produces for the next step. The chain prevents "vibe coding" — the anti-pattern of jumping straight to code without thinking.

**Three skill categories**:

1. **Workflow skills** (Steps 0-7) — the 7-step chain, used roughly in order for new features
2. **Assessment skills** — invoke anytime to review quality (cross-verify, whole-person-check, security-check, reflect)
3. **Meta skills** — navigation + transparency (workflow, using-8-habits, ai-dev-log)

## The 7-Step Workflow (Steps 0a, 0-7)

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

**When the problem itself is fuzzy** (before `/research`): use `superpowers:brainstorming` from `claude-plugins-official:superpowers` — it ships a collaborative hard-gate design session that writes a spec doc to git before any implementation. v2.4.1 removed our own `/brainstorm` in favor of that stronger equivalent (see ADR-006).

**The chain is opt-in, not forced**. Every skill has a `next-skill` field in its frontmatter pointing to the default successor, but you can jump, skip, or loop as needed. The honest skip rule: if you can justify skipping a step out loud, skip it. If you can't, run it.

## All 16 Skills (full inventory)

### Workflow skills (8)

- **`/research`** (Step 0) — Convergent investigation with sources. Depth levels (Quick/Standard/Deep), modes (General/Compare/Audit), verification. Output: research brief. For divergent "explore the problem" thinking BEFORE research, use `superpowers:brainstorming` instead.
- **`/requirements`** (Step 1) — PRD with What/Why/Who/Scope + **EARS-notation** acceptance criteria (5 templates). Output: PRD summary.
- **`/design`** (Step 2) — Architecture decisions with trade-offs. Human decides, AI proposes. Includes Article 14 human-oversight checkpoint for AI systems. Output: ADRs.
- **`/breakdown`** (Step 3) — Decompose into atomic tasks. Orchestration classification (sequential/parallel-safe/parallel-worktree). Output: task list with dependencies.
- **`/build-brief`** (Step 4) — Read existing code BEFORE writing new code. Produces context brief per task. Output: implementation brief.
- **`/review-ai`** (Step 5) — 4-level verdict (PASS/CONCERNS/REWORK/FAIL) with dimension balance check. Output: review report.
- **`/deploy-guide`** (Step 6) — Staging-first deployment with rollback plan. Output: deployment checklist.
- **`/monitor-setup`** (Step 7) — Health checks, alerting, observability. Output: monitoring configuration.

### Assessment skills (5)

- **`/cross-verify`** — 17-question 8-habit checklist covering all 4 Whole Person dimensions (Body/Mind/Heart/Spirit). Band-based verdict. Run after plans, before PRs.
- **`/whole-person-check`** — 4-dimension assessment (1-5 scale) with AI Blind Spot detection. Covers Body (discipline), Mind (vision), Heart (passion), Spirit (conscience).
- **`/security-check`** — Focused OWASP security lens (secrets, injection, auth, deps). Review mode, not a runtime hook.
- **`/reflect`** — 5-question micro-retrospective (5 min max) with action-item tracking. Run after completing significant work.
- **`/workflow`** — Guided walkthrough of the 7-step workflow. Prompts at each step to invoke or skip.

### Meta / transparency skills (3)

- **`/using-8-habits`** (this skill) — Onboarding navigation. Explains the 7-step workflow and all 16 skills.
- **`/ai-dev-log`** — Generate AI-assisted development log from git history + Co-Authored-By trailers. Transparency artifact, framework-agnostic.
- **`/eu-ai-act-check`** — EU AI Act 9-obligation compliance checklist (temporary placement; will migrate to `pitimon/claude-governance` in a future release per ADR-005 + ADR-006).

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

## Onboarding Example Walkthrough

A new developer wants to add password reset to an existing auth system. Here's the full 8-habit flow:

1. **`superpowers:brainstorming "password reset"`** — frame the problem (magic links? passwordless?). Refined statement: "secure self-service recovery without contacting support." (Skip if Superpowers isn't installed.)

2. **`/research "password reset security patterns"`** — find OWASP guidance, existing patterns in the codebase (if any), look at how Auth0/Clerk handle it. Output: research brief with 3 verified sources.

3. **`/requirements`** — draft PRD with EARS acceptance criteria (Event-driven, Unwanted, State-driven, Ubiquitous, Optional shapes).

4. **`/design`** — architecture decisions. Token storage (DB vs signed JWT)? Email provider? Rate limiting? Trade-off table + ADR.

5. **`/breakdown`** — atomic tasks: (a) reset token model, (b) reset email template, (c) reset endpoint, (d) token validation endpoint, (e) UI form. 5 tasks, dependencies mapped.

6. **`/build-brief` per task** — for each task, read existing auth code first, produce context brief, then implement.

7. **`/review-ai`** — 4-level verdict before PR. `/security-check` for the token logic specifically.

8. **`/cross-verify`** — 17-question check on the whole PR before merging.

9. **`/deploy-guide`** — staging first, smoke test, then production.

10. **`/monitor-setup`** — alerts for spikes in reset attempts (possible abuse), failed email sends, token validation failures.

11. **`/reflect`** — 5-question retro after the feature ships. What did we learn? What would we do differently?

Each step produces an artifact. The artifacts compose. That's the discipline.

## Handoff

- **Expects from predecessor**: Nothing (this is a starting-point skill)
- **Produces for successor**: A recommendation — "invoke `/[skill]` next" — based on your situation and the decision tree

## Definition of Done

- [ ] User understands the 3 skill categories (workflow / assessment / meta)
- [ ] User can name at least 3 workflow skills and their purposes
- [ ] User has picked their next skill based on the decision tree
- [ ] User knows about the honest skip rule: justify skipping out loud, or run the step
- [ ] User knows `/cross-verify` + `/reflect` exist for review and retrospective

## Composing with Other Plugins (optional)

8-habit-ai-dev is designed to compose cleanly with [`pitimon/claude-governance`](https://github.com/pitimon/claude-governance) and `devsecops-ai-team`. Users who install multiple plugins can thread 8-habit's workflow discipline through governance's compliance gates and devsecops's security probes without conflicts.

### Recommended flows when other plugins are present

**Security-sensitive feature** (thanks to mgmt-pve QA tester for this suggested flow):

```
superpowers:brainstorming  →  /threat-model  →  /research  →  /spec-driven-dev  →  /requirements  →  /design  →  /breakdown  →  ...
(superpowers)                 (devsecops)      (Step 0)       (governance)        (Step 1)         (Step 2)      (Step 3)
```

Rationale: inserting `/threat-model` (devsecops STRIDE/PASTA) between the brainstorming session and research surfaces security threats early; `/spec-driven-dev` (governance) provides formal spec scaffolding before 8-habit's `/requirements` adds EARS criteria.

**Standard feature with governance**:

```
superpowers:brainstorming  →  /research  →  /requirements  →  /design  →  /breakdown  →  ...  →  /governance-check  →  /review-ai
```

`/governance-check` (governance) runs fitness functions + pre-commit checks; 8-habit's `/review-ai` adds the 4-level verdict on top.

**EU AI Act compliance flow**:

```
... 7-step workflow ...  →  /eu-ai-act-check  →  /review-ai  →  /ai-dev-log  →  /deploy-guide
                            (from claude-governance v3.1.0+    (8-habit)       (8-habit, Art. 11 log)
                             after Stage B migration; currently
                             in 8-habit v2.3.0+ per PR #57)
```

### Cross-plugin reference skills

| If you have...                | And you need...                             | Invoke                      |
| ----------------------------- | ------------------------------------------- | --------------------------- |
| `devsecops-ai-team` installed | Threat modeling during early design         | `/threat-model`             |
| `devsecops-ai-team` installed | Security posture check (Mind+Spirit)        | `/posture-scan`             |
| `devsecops-ai-team` installed | Threat intelligence during research         | `/threat-intel`             |
| `claude-governance` installed | Formal spec with fitness functions          | `/spec-driven-dev`          |
| `claude-governance` installed | Pre-commit governance gates                 | `/governance-check`         |
| `claude-governance` installed | Three Loops classification + ADR-002 gating | `governance-reviewer` agent |
| `claude-governance` installed | Write-time secret blocking                  | automatic (hook)            |

If a peer plugin isn't installed, its skill simply isn't available — nothing breaks, you just use 8-habit's lighter-weight equivalent (e.g. `/security-check` instead of `/posture-scan`).

## References

- **Covey's 8 Habits**: the values anchor for the whole plugin (see `habits/` directory)
- **Whole Person Model**: 4-dimension assessment (Body/Mind/Heart/Spirit) — see `/whole-person-check`
- **addyosmani/agent-skills** (8.3K⭐): ships `using-agent-skills` meta-skill; this is the 8-habit-ai-dev equivalent
- **Plugin Boundary**: `8-habit-ai-dev` owns workflow discipline; `pitimon/claude-governance` owns enforcement and compliance frameworks (see `CLAUDE.md` → Plugin Boundary section)
- **Cross-plugin composition**: suggested security flow above contributed by mgmt-pve QA tester in feedback issue #77
