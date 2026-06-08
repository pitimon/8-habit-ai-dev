# Situation Map — Which Habit, When?

**"เจอ situation นี้ ใช้ habit นี้"** — find the right habit in 30 seconds.

Start from YOUR situation, not from the habit name.

## Common Development Situations

| Situation                                | Primary Habit                | Action                                         | Command               |
| ---------------------------------------- | ---------------------------- | ---------------------------------------------- | --------------------- |
| Starting a new feature                   | H2: Begin with End in Mind   | Define PRD with success criteria first         | `/requirements`       |
| Making architecture decisions            | H8: Find Your Voice          | Present options with trade-offs, human decides | `/design`             |
| Feature feels too big to start           | H3: First Things First       | Decompose into atomic tasks, prioritize        | `/breakdown`          |
| About to write code for a task           | H5: Seek First to Understand | Read existing code, build context brief        | `/build-brief`        |
| Code is written, ready to commit         | H4: Think Win-Win            | Review with 4-level verdict before commit      | `/review-ai`          |
| Deploying to staging or production       | H1: Be Proactive             | Staging first, rollback plan ready             | `/deploy-guide`       |
| Service is deployed, what now?           | H7: Sharpen the Saw          | Set up health checks, alerting, monitoring     | `/monitor-setup`      |
| Fixing a production bug                  | H5: Understand First         | Reproduce bug BEFORE fixing. Read the code.    | `/build-brief`        |
| Something feels off about a plan         | H1-H8: All                   | Run 17-question checklist + dimension check    | `/cross-verify`       |
| Want to assess code quality holistically | H8: Find Your Voice          | Score Body/Mind/Heart/Spirit dimensions        | `/whole-person-check` |
| Security concern about changes           | H1: Be Proactive             | Dedicated OWASP security lens                  | `/security-check`     |
| Task complete, want to learn from it     | H7: Sharpen the Saw          | 5-question micro-retro, 5 min max              | `/reflect`            |
| New to plugin, don't know where to start | All                          | Guided 7-step walkthrough                      | `/workflow`           |
| Onboarding new team member               | H8: Find Your Voice          | Share quick-reference + this situation map     | Read `guides/`        |
| Tech debt piling up                      | H7: Sharpen the Saw          | Track explicitly, invest in prevention (Q2)    | `/reflect`            |

## Decision Shortcuts

**"Should I skip a step?"** — check the skill's "When to Skip" section. Every skill has one.

**"Which is most important?"** — see [quick-reference.md](quick-reference.md) for priority-sorted rules.

**"Is my plan ready?"** — run `/cross-verify` (17 questions + dimension summary).

**"Is the code balanced?"** — run `/whole-person-check` (Body/Mind/Heart/Spirit).

## The One Rule

If you only remember one thing:

> **Write → Review → Commit** (H4: Never reverse. "Small change" is not an excuse to skip.)

---

_See [quick-reference.md](quick-reference.md) for prioritized rules. Back to [README](../README.md)_
