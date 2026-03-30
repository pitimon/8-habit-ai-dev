# CLAUDE.md — 8-Habit AI Dev Plugin

**Anti-Vibe-Coding plugin** — 7-step workflow discipline + 8-Habit cross-verification

## Structure

```
skills/           8 actionable workflow skills (Steps 1-7 + Cross-Verify)
habits/           8 habit reference files (loaded on-demand by skills)
guides/           Cross-verification checklist
rules/            Effective development rules (auto-loaded)
agents/           8-habit-reviewer (deep review agent)
hooks/            Session start reminder
```

## Skills → Habits Mapping

| Skill | Step | Habit | Purpose |
|-------|------|-------|---------|
| `/requirements` | 1 | H2 Begin with End | Define done before starting |
| `/design` | 2 | H8 Find Your Voice | Human decides architecture |
| `/breakdown` | 3 | H3 First Things First | Atomic tasks, no scope creep |
| `/build-brief` | 4 | H5 Understand First | Read code before writing |
| `/review-ai` | 5 | H4 Win-Win | Actionable feedback |
| `/deploy-guide` | 6 | H1 Be Proactive | Staging first, rollback ready |
| `/monitor-setup` | 7 | H7 Sharpen the Saw | Invest in observability |
| `/cross-verify` | All | H1-H8 | 17-question checklist |

## Design Principles

- Skills are **empowering, not restrictive** — reminders, not blockers
- Habit content loaded **on-demand** via `Load ${CLAUDE_PLUGIN_ROOT}/habits/h*.md`
- Token budget: session-start hook ≤ 300 tokens
- Existing `habits/`, `guides/`, `rules/` content is **reference only** — never modified by skills
