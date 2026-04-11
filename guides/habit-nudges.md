# Habit Nudges — Specification for Proactive Workflow Reminders

**Status**: Specification (v2.6.0) | **Audience**: Maintainers of [`pitimon/claude-governance`](https://github.com/pitimon/claude-governance) | **Related**: Issue #89, Hermes Agent periodic nudges

## Purpose

The 8-habit-ai-dev plugin is **purely reactive** — workflow skills (`/review-ai`, `/reflect`, `/cross-verify`, etc.) only fire when the user explicitly invokes them. This creates a gap between "knowing the habit" and "practicing the habit." Users read the 8 habits, install the plugin, and then forget to run `/review-ai` before committing, or skip `/reflect` at the end of a task.

**Habit nudges** close this gap by gently reminding users at the right moment. Inspired by Hermes Agent's periodic nudges: internal system-level prompts that fire during a session to encourage the agent (or user) to take stock and adjust.

## Plugin Boundary

This document is a **specification**. The runtime hook implementation belongs in [`pitimon/claude-governance`](https://github.com/pitimon/claude-governance) per the `8-habit-ai-dev` ↔ `claude-governance` boundary defined in CLAUDE.md:

> If it's a **runtime hook** (PreToolUse, PostToolUse), **compliance framework mapping**, **enforcement gate** that blocks actions → belongs in `claude-governance`.

**Split of responsibility**:

| Plugin | Contribution |
|--------|-------------|
| **`8-habit-ai-dev`** (this guide) | Nudge catalog, triggers, messages, frequency caps, habit mapping, opt-out behavior |
| **`claude-governance`** (future PR) | Hook implementation (PreToolUse/PostToolUse), trigger detection logic, cooldown tracking, delivery mechanism |

A `claude-governance` maintainer should be able to read this document and implement working hooks without returning here for clarification.

---

## Non-Negotiable Rules

These rules bound every nudge. Violations break the user's trust and defeat the purpose.

### Rule 1: Suggestion-only, never blocking

**Nudges MUST be advisory.** They appear as a message in the session context; the user can ignore them and continue their work. A nudge that blocks a commit, prevents a tool call, or otherwise halts the user's flow is not a nudge — it is a gate, and gates belong elsewhere (see `claude-governance` pre-commit patterns).

### Rule 2: Anti-fatigue via cooldown

Each nudge declares a **cooldown window**. The same nudge MUST NOT fire twice within its window. If the user ignores a nudge, the plugin respects that choice within the cooldown — re-firing is nagging, and nagging destroys trust.

Cooldowns are typically scoped to:
- **Per session**: Fires at most once per Claude Code session
- **Per task cycle**: Fires at most once per declared task (until `/reflect` or commit)
- **Per artifact**: Fires at most once per specific artifact (e.g., one `/cross-verify` suggestion per staged batch)

### Rule 3: Context-aware, not timer-based

Nudges fire based on **work context**, not elapsed time. "You've been working for 30 minutes, take a break" is a wellness nudge, not a habit nudge. Habit nudges fire when specific conditions are met in the work itself: files changed, tools invoked, workflow steps skipped.

### Rule 4: HABIT_QUIET=1 silences everything

Users who have set `export HABIT_QUIET=1` (the opt-out for `hooks/session-start.sh`) shall also have nudges silenced. A user who has opted out of the session banner has already expressed that they do not want unsolicited reminders. Consistency > cleverness.

### Rule 5: Message style

Nudge messages MUST be:
- **Short**: 1-2 sentences, no more
- **Specific**: Cite the triggering condition ("You've edited 8 files")
- **Actionable**: Suggest a specific command ("`/cross-verify`")
- **Justified briefly**: Map to a habit ("H1 Be Proactive")
- **Respectful**: Never scold, never imply the user is doing something wrong

Bad: "You really should be running tests. Good engineers always test their code."
Good: "You've edited 8 files without running `/cross-verify`. Consider it before your next commit. (H1 Be Proactive)"

---

## Nudge Catalog

Six nudges map to the 8 Habits. Each has a unique `id` for cooldown tracking.

### N1: Review Reminder

**ID**: `review-before-commit`
**Habit**: H4 Think Win-Win
**Trigger**: 8+ successful `Edit` or `Write` tool calls since session start, with no `/review-ai` invocation yet
**Cooldown**: Once per session
**Message**:
```
You've made 8+ edits without running /review-ai. Consider reviewing before
your next commit to catch issues early. (H4 Win-Win)
```
**Rationale**: `/review-ai` is the safety net between AI-generated code and committed code. Users who skip it miss the highest-leverage quality gate in the workflow.

---

### N2: Reflect Reminder

**ID**: `reflect-after-task`
**Habit**: H7 Sharpen the Saw
**Trigger**: A commit has been made on the current branch AND the user has not invoked `/reflect` since the branch was created
**Cooldown**: Once per branch (resets on new branch)
**Message**:
```
Task committed. Consider /reflect to capture lessons learned — with v2.6.0
the lesson file persists to ~/.claude/lessons/ for future sessions. (H7)
```
**Rationale**: Lessons evaporate if not captured. With v2.6.0 persistent reflection, the cost of `/reflect` is genuinely low and the compounding value is high.

---

### N3: Cross-Verify Trigger

**ID**: `cross-verify-before-pr`
**Habit**: All 8 habits
**Trigger**: 5+ files changed in the working tree (staged or unstaged) AND no `/cross-verify` invocation in the last 20 tool calls
**Cooldown**: Once per "batch" — reset when files are committed or reverted
**Message**:
```
5+ files changed. Consider /cross-verify — the 17-question checklist catches
blind spots before PR. (All 8 habits)
```
**Rationale**: Large changes are where quality issues compound. Cross-verify is cheap (5-minute checklist) relative to PR-review cost.

---

### N4: Research Prompt

**ID**: `research-before-requirements`
**Habit**: H5 Seek First to Understand
**Trigger**: `/requirements` is about to be invoked with a topic/argument that is fewer than 20 words (heuristic for "fuzzy problem statement")
**Cooldown**: Once per `/requirements` invocation chain
**Message**:
```
Your problem statement is short — consider /research first if the problem
space is unfamiliar. (H5 Understand First)
```
**Rationale**: `/research` exists exactly for fuzzy problem spaces. Users who jump straight to `/requirements` on an unclear problem waste effort defining the wrong thing.

---

### N5: Breakdown Reminder

**ID**: `breakdown-after-design`
**Habit**: H3 Put First Things First
**Trigger**: `/design` completed successfully AND 10+ subsequent tool calls occurred without `/breakdown` being invoked
**Cooldown**: Once per design cycle (resets on next `/design` or new branch)
**Message**:
```
Design is done but no /breakdown yet. Atomic tasks prevent scope creep and
enable parallel work. (H3 First Things First)
```
**Rationale**: Skipping `/breakdown` is a common failure mode — users finish design, feel energized, and jump to coding. Result: scope creep and unclear task boundaries.

---

### N6: Whole-Person Check (pre-release)

**ID**: `whole-person-before-release`
**Habit**: H8 Find Your Voice
**Trigger**: A version bump is detected (edit to `.claude-plugin/plugin.json` `version` field, or a tag matching `v*.*.*` being created) AND no `/whole-person-check` in the last 50 tool calls
**Cooldown**: Once per version bump
**Message**:
```
Version bump detected. Consider /whole-person-check to assess Body, Mind,
Heart, Spirit balance before release. (H8 Find Your Voice)
```
**Rationale**: Releases are the right moment to assess the 4 dimensions. Technical correctness (Body) is often checked via CI, but Heart and Spirit are where AI-assisted work has blind spots.

---

## Implementation Contract

This section is for the `claude-governance` maintainer who implements the hooks.

### Required Data per Trigger

Each nudge trigger needs runtime data. Hook implementations must track (or receive):

| Data | Used by | Source |
|------|---------|--------|
| Tool call log (type + args) since session start | N1, N3, N5 | PostToolUse hook accumulation |
| Git working tree state (staged, unstaged file counts) | N3, N6 | Shell out to `git status --porcelain` |
| Last `/review-ai`, `/reflect`, `/cross-verify`, `/breakdown` invocation | N1, N2, N3, N5 | Track skill invocations (session memory) |
| Current branch name + first commit on branch | N2 | `git branch --show-current`, `git log --reverse` |
| `/requirements` and `/design` invocation history + arguments | N4, N5 | Track skill invocations with arg text |

### Suggested Hook Types

| Nudge | Hook Type | Fires When |
|-------|-----------|-----------|
| N1, N3 | PostToolUse (on Edit/Write) | After any file edit |
| N2 | PostToolUse (on Bash `git commit`) | After commit succeeds |
| N4 | PreToolUse (on Skill invocation of `requirements`) | Before `/requirements` runs |
| N5 | PostToolUse (any tool) with counter | 10 calls after `/design` |
| N6 | PreToolUse (on Edit to `plugin.json`) or PreToolUse (on Bash `git tag`) | Before version bump commit |

### Cooldown Storage

Cooldowns can be tracked in-memory for the session (simplest) or persisted to `~/.claude/habit-nudges-state.json` (survives session restart). In-memory is recommended for v1 — persistence is overkill.

### Delivery Mechanism

Nudges are delivered as **system messages injected into the Claude Code conversation context**. The user sees them as a muted callout from the plugin, not as a modal or notification. Implementation can use the standard hook output-to-context mechanism — same channel as `session-start.sh`.

### Opt-Out Check (mandatory)

Every hook MUST check `HABIT_QUIET=1` as the first line and exit silently if set:

```bash
[[ "${HABIT_QUIET:-}" == "1" ]] && exit 0
```

This matches the pattern in `hooks/session-start.sh`.

### Testing the Hooks

- Unit test each trigger condition in isolation
- Integration test: verify cooldowns prevent re-firing
- Manual test: set `HABIT_QUIET=1` and confirm zero nudges fire
- Manual test: unset `HABIT_QUIET` and verify all 6 nudges fire once each over a realistic session

---

## Out of Scope (for v1)

These ideas are deferred to avoid scope creep. If demand emerges, file new issues.

- **Per-user customization**: Enable/disable individual nudges via config file
- **Custom nudges**: User-defined triggers and messages
- **Nudge history/analytics**: "You've dismissed the /reflect nudge 15 times — want to remap it?"
- **Machine learning on nudge effectiveness**: Which nudges actually change behavior?
- **Wellness nudges**: Take a break, stretch, drink water (wrong plugin)
- **Blocking enforcement**: Belongs in `claude-governance` as a separate `governance-gates` feature

---

## Examples

### Example 1: User ignores N1, proceeds anyway

```
[user edits 10 files over 40 tool calls]
[after 8th edit, N1 fires]

> 8-habit nudge: You've made 8+ edits without running /review-ai. Consider
> reviewing before your next commit to catch issues early. (H4 Win-Win)

[user keeps editing — no more N1 nudges this session, respecting cooldown]
[user commits — N2 fires]

> 8-habit nudge: Task committed. Consider /reflect to capture lessons learned
> — with v2.6.0 the lesson file persists to ~/.claude/lessons/ for future
> sessions. (H7)
```

### Example 2: HABIT_QUIET=1 in shell

```bash
$ export HABIT_QUIET=1
$ claude
[user works for 2 hours, edits 30 files, commits 5 times, version bumps]
[zero nudges fire]
```

### Example 3: Research prompt catches a fuzzy requirement

```
[user invokes /requirements with argument: "auth thing"]
[N4 fires before /requirements runs]

> 8-habit nudge: Your problem statement is short — consider /research first
> if the problem space is unfamiliar. (H5 Understand First)

[user decides /research is appropriate, invokes /research "auth middleware"]
[next /requirements call has proper context]
```

---

## Revision History

| Version | Date | Change |
|---------|------|--------|
| 1.0 | 2026-04-11 | Initial specification (Issue #89, v2.6.0) |

---

## See Also

- [CLAUDE.md Plugin Boundary](../CLAUDE.md) — why nudges belong partially in both plugins
- [rules/effective-development.md](../rules/effective-development.md) — H7 Sharpen the Saw full principle
- [hooks/session-start.sh](../hooks/session-start.sh) — existing opt-out pattern reference
- [hooks/pre-commit.sh.example](../hooks/pre-commit.sh.example) — example of suggestion-vs-gate split
- [Issue #89](https://github.com/pitimon/8-habit-ai-dev/issues/89) — tracking issue
