# Habit 7: Sharpen the Saw

**Invest in Production Capability, not just Production output.**

AI assistants make it dangerously easy to keep producing — shipping features, fixing bugs, writing more code. But a saw that never gets sharpened eventually can't cut. The same applies to your development process, infrastructure, and knowledge.

## The Principle

Covey's P/PC Balance: **P** is Production (output), **PC** is Production Capability (the ability to produce). If you focus only on P, PC degrades until you can't produce at all.

In AI-assisted development, PC includes: your CI pipeline, your test suite, your deployment process, your monitoring, your understanding of the codebase, and the AI's ability to work effectively within your system.

## Rules

**1. Track tech debt explicitly — don't let it accumulate silently.**

Every "TODO: fix later" should be a tracked issue with a severity tag. AI assistants generate TODOs liberally. If you don't track them, they become invisible rot.

**2. After completing a task: "What did we learn? What could be automated?"**

Every session produces knowledge. If you fixed a deployment issue, write down what went wrong and how to prevent it. If you repeated the same 5 steps, write a script. If the AI made a mistake, add a guardrail.

**3. Periodic review: frameworks, dependencies, security posture.**

Schedule time to update dependencies, review security advisories, and assess whether your tools are still the right choice. This is Q2 work (Habit 3) that prevents Q1 crises.

**4. Invest in AI collaboration infrastructure.**

The more context your AI assistant has (project docs, coding standards, architectural decisions), the better its output. Maintaining a clear CLAUDE.md, keeping docs current, and writing good commit messages are all PC investments — they make every future AI session more productive.

**5. Invest in the meta-system — the system that builds the system.**

When AI agents can rebuild a codebase in hours, the bottleneck shifts from coding speed to orchestration quality. The plugin you configure, the workflow you follow, the decomposition patterns you use — these are the meta-system. Improving the meta-system compounds: every future task benefits from better orchestration, clearer boundaries, and smarter decomposition.

> "If you're only looking at the files created in this repository, you're looking at the wrong layer. What you should study is the system that built it." — UltraWorkers philosophy

### Before/After: All Output vs Capability Investment

```bash
# BEFORE — manual deploy every time (P only, no PC):
ssh server "cd /app && git pull && npm install && pm2 restart"
# 60 min per deploy, error-prone, no rollback, repeated every release

# AFTER — invested in CI/CD (10 min PC investment, 2 min deploys forever):
git push origin main
# GitHub Actions: build → test → staging → health check → production
# Rollback: git revert + push. Total: 2 min. Repeatable. Safe.
```

## Anti-Patterns

- **All output, no capability**: Shipping features every sprint but never improving the build process that takes 20 minutes. Eventually the slow build costs more than all the features combined.
- **"It works" tech debt denial**: Ignoring known issues because the system runs. Until the day it doesn't, and the accumulated debt demands payment all at once.
- **No post-task reflection**: Completing a task and immediately starting the next one. The lessons learned evaporate, and the same mistakes recur.

## Real Example

After running a retrieval benchmark on an AI memory system, the team could have just recorded the scores and moved on. Instead, they invested time in building reusable benchmark infrastructure — data loaders, automated scoring, comparison reports. This was pure PC investment with no immediate production value. But when optimization required 7 benchmark runs over 3 weeks, the infrastructure turned each run from a half-day manual effort into a 15-minute automated process. The PC investment saved 10x its cost within the same project.

## Quick Reference

| Do                                                            | Don't                                                     | Why                                                         |
| ------------------------------------------------------------- | --------------------------------------------------------- | ----------------------------------------------------------- |
| Track tech debt explicitly                                    | "It works, don't touch it"                                | Accumulated debt demands payment all at once                |
| After each task: "what did I learn?"                          | Complete task, immediately start next                     | Lessons evaporate, same mistakes recur                      |
| Invest in CI/CD, monitoring, automation (PC)                  | Only ship features (P)                                    | Eventually the saw is too dull to cut                       |
| Periodically review frameworks and dependencies               | Assume tools are still the right choice                   | Security advisories and better alternatives emerge          |
| Maintain CLAUDE.md and commit messages                        | Let AI context degrade over time                          | Better context = better AI output every session             |
| Invest in the meta-system (plugins, workflows, decomposition) | Only optimize the code, never the process that creates it | Better orchestration compounds — every future task benefits |

## Checkpoint

> "Am I investing in future capability, or just grinding out output?"

If you can't remember the last time you improved your process (not your product), it's time to sharpen the saw.

---

_Next: [Habit 8 — Find Your Voice](h8-find-voice.md)_
