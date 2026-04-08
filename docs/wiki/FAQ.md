# FAQ

## Is this a framework or a runnable app?

Neither. It is a **Claude Code plugin** — structured markdown files that Claude Code loads at runtime. There is no build system, no dependencies, nothing to install beyond `claude plugin install`.

## Do I have to run all 7 steps every time?

No. See [Workflow Overview → When to Skip](Workflow-Overview#when-to-skip). Small changes skip most steps; the only step you should **never** skip is `/review-ai` (Step 5).

## Why not just let Claude decide architecture?

Architecture decisions are hard to reverse and often require context that lives in people's heads — org priorities, team skills, operational constraints, past incidents. AI can propose options well, but the judgment call should belong to a human who will live with the consequences. See [H8 Find Your Voice](Habits-Reference#habit-8-find-your-voice-and-inspire-others).

## How is this different from just using `CLAUDE.md`?

`CLAUDE.md` is static guidance. This plugin adds:

- **Skills** — on-demand, step-specific playbooks loaded only when invoked
- **Session hook** — a lean workflow reminder injected at session start
- **Cross-verify agent** — independent 17-question checklist
- **Handoff contracts** — each skill declares what it expects and produces

You can (and should) combine the two: put project-specific context in `CLAUDE.md`, and use this plugin for workflow discipline.

## Does this replace code review by a human?

**No.** `/review-ai` is an AI-driven audit that catches low-hanging issues (hallucinations, missing error handling, scope creep). A human reviewer catches things an AI cannot: intent mismatch, team conventions, strategic alignment. Use both.

## Can I use this in a language that isn't English?

The skills themselves are in English. Bilingual Thai+English is the project's long-term goal — see [Contributing to Wiki](Contributing-to-Wiki) if you want to help translate.

## What's the difference between `/cross-verify` and `/review-ai`?

- `/review-ai` is **code-focused** — audits the diff for bugs, security, scope creep
- `/cross-verify` is **process-focused** — 17 questions spanning all 8 habits, run **before** implementation starts

Run `/cross-verify` on your plan before coding; run `/review-ai` on your code before committing.

## Do I need GitHub, or can I use GitLab/Bitbucket?

The plugin itself is git-host-agnostic. Only the wiki sync (this documentation) depends on GitHub Actions. Everything else works anywhere.

## Can I use this with other Claude Code plugins?

Yes. This plugin is complementary with governance, security, and DevSecOps plugins. There are no hard conflicts — just different scopes.

## How does this interact with `claude-governance`?

They complement each other:

- **8-habit-ai-dev** = workflow discipline (7 steps, 8 habits, cross-verification)
- **claude-governance** = fitness functions and guardrails (secret scanning, commit conventions, ADRs)

Use both for maximum coverage. See the note in [Base Camp](Home) for more.

## Where are the habits actually defined?

In [`habits/h1-...md` through `habits/h8-...md`](https://github.com/pitimon/8-habit-ai-dev/tree/main/habits). The [Habits Reference](Habits-Reference) page in this wiki is auto-generated from those files.

## I found a bug or want to suggest a feature

Open an issue: [github.com/pitimon/8-habit-ai-dev/issues](https://github.com/pitimon/8-habit-ai-dev/issues).

## See also

- **[Troubleshooting](Troubleshooting)**
- **[Contributing to Wiki](Contributing-to-Wiki)**
