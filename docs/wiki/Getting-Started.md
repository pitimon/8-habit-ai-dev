# Getting Started

> [!TIP]
> This walkthrough takes **~10 minutes**. Have a small feature from your backlog ready — a real one works best.

Your first structured feature. This walkthrough shows how the 7-step workflow replaces "just ask Claude to build X."

## Before you start

- [Install the plugin](Installation)
- Have a small feature idea in mind (a real one from your backlog is best)

## The walkthrough

### 1 · State your intent

Open Claude Code in your project and describe what you want:

```
/requirements I need to add a rate limiter to our /api/search endpoint
```

Claude produces a PRD summary: **What · Why · Who · In scope · Out of scope · Success criteria · Definition of Done**. Review and correct anything that does not match your intent — this is your first human checkpoint.

> [!TIP]
> If the problem space is unclear, start with `/research` (Step 0) instead.

### 2 · Decide architecture

```
/design
```

Claude presents **at least 2 options with trade-offs** for each key decision (algorithm, storage, failure mode). **You decide** — AI proposes, human disposes. For decisions affecting >3 files or changing public API, an ADR is recorded.

### 3 · Break the work down

```
/breakdown
```

Claude produces an atomic task list: each task is 1 sentence, touches ≤5 files, with explicit dependencies and priority (Covey's Quadrants Q1–Q4). Q4 tasks are eliminated. Parallel-safe tasks are marked.

### 4 · Brief each task before coding

```
/build-brief
```

For each task, Claude **reads existing code first** (H5 — Seek First to Understand), then produces an implementation brief: files to touch, patterns to follow, edge cases to handle. Only now does implementation begin.

### 5 · Review before commit

```
/review-ai
```

Claude audits the generated code for security, completeness, and adherence to the brief. **Never commit without this step** — it is your last chance to catch AI hallucinations, missing error handling, and scope creep.

Optional deeper lenses:

- `/security-check` — focused OWASP Top 10 review
- `/cross-verify` — full 17-question 8-Habit checklist
- `/whole-person-check` — Body/Mind/Heart/Spirit balance

### 6 · Deploy with rollback

```
/deploy-guide
```

Staging first, always. Claude produces a step-by-step deploy plan with verification commands and a rollback procedure ready to paste.

### 7 · Observe after deploy

```
/monitor-setup
```

Set up error tracking, alerts, and health checks. H7 — Sharpen the Saw: invest in observability so you learn from production.

### 8 · Reflect

```
/reflect
```

5 questions, 5 minutes. What worked? What surprised you? What would you do differently? Capture the lesson before the context evaporates.

## When to skip steps

Not every change needs all 7 steps. See [Workflow Overview → When to Skip](Workflow-Overview#when-to-skip). Single-line bug fixes, formatting, and dependency bumps typically skip Steps 0–4 and go straight to `/review-ai`.

## Next

- **[Workflow Overview](Workflow-Overview)** — the full picture
- **[8 Habits Reference](Habits-Reference)** — the principles behind each step
- **[Vibe Coding vs Structured](Vibe-Coding-vs-Structured)** — why this matters
