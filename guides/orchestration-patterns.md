# Orchestration Patterns — Multi-Agent Development

> "The scarce resource is no longer typing speed but architectural clarity, task decomposition, judgment, taste, and conviction about what's worth building."

Patterns for effective multi-agent orchestration in AI-assisted development. Inspired by UltraWorkers (ULW) tools: OmC (oh-my-claudecode), OmX (oh-my-codex), and clawhip.

## Pattern 1: Worktree Isolation

**Problem**: Parallel agents editing shared files create merge conflicts and race conditions. Two agents modifying the same config file simultaneously produces corrupted output.

**Solution**: Classify each task's isolation needs before dispatching agents:

| Type                | When to Use                                    | How                                   | Example                                                 |
| ------------------- | ---------------------------------------------- | ------------------------------------- | ------------------------------------------------------- |
| `sequential`        | Task depends on prior task's output            | Run after dependency completes        | Database migration → seed data                          |
| `parallel-safe`     | Tasks touch completely different files         | Run in same repo simultaneously       | New module A + new module B                             |
| `parallel-worktree` | Tasks touch overlapping files or shared config | Each agent gets isolated git worktree | Feature X (touches utils/) + Feature Y (touches utils/) |

**Decision checklist**:

1. List files each task touches
2. If file sets overlap → `parallel-worktree`
3. If file sets disjoint → `parallel-safe`
4. If output of A feeds input of B → `sequential`

**When to use**: Any `/breakdown` that produces 3+ tasks with parallel opportunities.

**Example**:

```
T1: Add auth middleware     → touches: src/middleware/, src/config/
T2: Add logging middleware  → touches: src/middleware/, src/config/
T3: Add API endpoint        → touches: src/routes/, src/types/

T1 ∩ T2 = src/middleware/, src/config/ → parallel-worktree
T1 ∩ T3 = ∅ → parallel-safe
T2 ∩ T3 = ∅ → parallel-safe
```

**Source**: OmX (oh-my-codex) by Yeachan Heo — each worker runs in isolated git worktree by default since v0.11.12. [github.com/Yeachan-Heo/oh-my-codex](https://github.com/Yeachan-Heo/oh-my-codex)

---

## Pattern 2: Context Boundaries

**Problem**: Agents sharing a session contaminate each other's context windows. Agent A's 500-line diff pollutes Agent B's reasoning about an unrelated module. This is the #1 engineering challenge in multi-agent orchestration.

**Solution**: Define explicit boundaries for each agent before dispatching:

| Boundary           | Purpose                                                   | Example                                                                     |
| ------------------ | --------------------------------------------------------- | --------------------------------------------------------------------------- |
| **Must know**      | Files and domain context needed to complete the task      | "Read src/auth/middleware.ts, understand JWT validation pattern"            |
| **Must NOT know**  | Information that would pollute context or cause confusion | "Do not read src/billing/ — unrelated module, wastes context"               |
| **Merge contract** | What the agent produces and where results merge           | "Output: modified middleware.ts. Merge point: PR branch after T1 completes" |

**Decision checklist**:

1. For each task, list the minimum files needed (not the entire codebase)
2. Explicitly exclude areas that would add noise
3. Define output format so merge is predictable

**When to use**: Any `/build-brief` for work that will be executed by parallel agents or subagents.

**Example**:

```
## Agent: Auth Middleware
Must know: src/auth/, src/config/auth.ts, DOMAIN.md (User entity)
Must NOT know: src/billing/, src/analytics/, test fixtures for other modules
Merge contract: Modified src/auth/middleware.ts + new test file. Merge to feature branch after review.
```

**Source**: clawhip by Yeachan Heo — event-to-channel notification router that prevents context pollution between agent sessions. [github.com/Yeachan-Heo/clawhip](https://github.com/Yeachan-Heo/clawhip)

---

## Pattern 3: Meta-System Mindset

**Problem**: Teams optimize the code they produce but neglect the system that produces it. Plugins, workflows, CI pipelines, and agent configurations are treated as fixed infrastructure rather than evolving capabilities.

**Solution**: Periodically invest in Production Capability (PC), not just Production (P):

| Level                 | What to Optimize                    | Example Investment                                             |
| --------------------- | ----------------------------------- | -------------------------------------------------------------- |
| **Code** (P)          | The application being built         | Add feature, fix bug, refactor                                 |
| **Workflow** (PC)     | The process that builds the code    | Improve /breakdown decomposition, add CI checks                |
| **Meta-system** (PC²) | The system that shapes the workflow | Enhance plugin skills, create new guides, update habit content |

**Decision checklist**:

1. After completing a feature: "What pattern did we repeat that could be systematized?"
2. After a failed review: "What check could have caught this earlier?"
3. After parallel work: "What coordination overhead could be eliminated?"

**When to use**: During `/reflect` (post-task retrospective) or when the same problem recurs across sessions.

**Example**:

```
# Before (optimizing P only):
Ship feature → ship feature → ship feature → slow down → wonder why

# After (investing in PC²):
Ship feature → notice orchestration friction → enhance /breakdown with worktree classification
→ next feature ships with less coordination overhead → compound returns
```

**Source**: UltraWorkers philosophy — "If you're only looking at the files created in this repository, you're looking at the wrong layer. The rewrite is a byproduct. What you should study is the system that built it." [github.com/ultraworkers/claw-code](https://github.com/ultraworkers/claw-code)

---

## Pattern 4: Fan-Out Discipline — When to Invoke a Dynamic Workflow

**Problem**: A harness-level **dynamic workflow engine** (e.g. Opus 4.8's Workflow tool — deterministic scripts that spawn `parallel()` / `pipeline()` sub-agents) makes autonomous fan-out cheap. Cheap is not the same as appropriate. Spinning up a dozen agents on work that needed one focused pass trades architectural clarity for throughput — and that trade is invisible until the merge.

> **Disambiguation**: This plugin's `/workflow` skill is a _human-gated discipline_ (7 steps, each Announce → Ask → record). Opus 4.8's _dynamic workflow_ is an _execution engine_. They are different layers. The engine itself — runtime coordination + which agent is authorized to spawn what — is a `claude-governance` concern, not an `8-habit-ai-dev` one (CLAUDE.md rule of thumb: "runtime hook … formal decision-authorization model → `claude-governance`"). What lives **here** is only the _discipline_ of deciding when fan-out serves the work. Full positioning: [ADR-021](../docs/adr/ADR-021-dynamic-workflow-positioning.md).

**Solution**: Before invoking the engine, run the work through the habit lens. Fan-out **reinforces** H6 (Synergize — "use parallel agents for independent tasks") but is in **tension** with four habits; let those decide whether to fan out or stay single-threaded:

| Habit                     | Fan-out effect | Gate before fanning out                                                                                |
| ------------------------- | -------------- | ------------------------------------------------------------------------------------------------------ |
| **H6 Synergize**          | ✅ Reinforces  | Tasks are genuinely independent (disjoint file sets per Pattern 1) — fan-out is the canonical win      |
| **H1 Be Proactive**       | ⚠️ Tension     | Cross-cutting effects ("trace ALL callers") are mapped first — each agent sees only its slice          |
| **H3 First Things First** | ⚠️ Tension     | You are finishing N things, not starting N half-things — bounded count, defined merge contract         |
| **H5 Understand First**   | ⚠️ Tension     | Shared understanding exists _before_ parallel writing — agents read context (Pattern 2) before editing |
| **H8 Find Your Voice**    | ⚠️ Tension     | Architecture/scope stays human-owned — fan-out executes a decided plan, it does not _make_ the plan    |

**Decision checklist**:

1. Is the work decomposable into independent slices (Pattern 1 `parallel-safe` / `parallel-worktree`)? If not → single-threaded.
2. Have cross-cutting effects been traced once, centrally, before splitting (H1)? If not → trace first.
3. Is the count bounded and each agent's merge contract defined (H3 + Pattern 2)? If not → scope first.
4. Is the architecture already decided by a human (H8)? Fan-out runs a plan; it does not author one. If not → `/design` first.

**Oversight under fan-out (Article 14 oversight _principle_ — Understand / Override / Stop)**:

This is the discipline cue, not the compliance obligation. The EU AI Act Article 14 compliance checklist and its enforcement live in `claude-governance` (`skills/eu-ai-act-check/`, per [ADR-012](../docs/adr/ADR-012-eu-ai-act-migration-completion.md)); here we only borrow the _principle_ to keep human control intact while fanning out. Autonomous fan-out makes the "stop button" and human comprehension harder — keep all three intact:

| Capability     | How to preserve under fan-out                                                                 |
| -------------- | --------------------------------------------------------------------------------------------- |
| **Understand** | Log what each agent is doing (label + phase); a summary the human can read, not a black box   |
| **Override**   | Findings/outputs are proposals to review, not auto-merged work — human confirms before commit |
| **Stop**       | The run is interruptible; a runaway fan-out has a bound (count cap, budget) the human set     |

**When to use**: Any `/breakdown` that tempts you toward "just fan out everything," or before authoring a dynamic-workflow script. Patterns 1-3 cover _how_ to orchestrate once you have decided to; Pattern 4 is the _whether/when_ gate.

**Example**:

```
# Appropriate fan-out (H6 reinforced, gates pass):
4 independent doc files to lint → disjoint sets, no cross-cutting logic,
architecture N/A, outputs reviewed → parallel() over 4 agents.

# Inappropriate fan-out (H1/H3 fail):
"Refactor the auth flow across 8 files" → shared call graph, cross-cutting
effects unmapped → trace callers in ONE pass first; do not split blind.
```

**Source**: Repo audit 2026-05-29 (4-probe scan of skills / ADRs / plugin boundary / habit rules), [issue #241](https://github.com/pitimon/8-habit-ai-dev/issues/241). Engine-vs-discipline boundary: [ADR-021](../docs/adr/ADR-021-dynamic-workflow-positioning.md).

---

## Quick Reference

| Pattern             | Solves                                    | Used In               | H-Mapping         |
| ------------------- | ----------------------------------------- | --------------------- | ----------------- |
| Worktree Isolation  | Merge conflicts in parallel work          | `/breakdown`          | H3 + H6           |
| Context Boundaries  | Context pollution between agents          | `/build-brief`        | H5                |
| Meta-System Mindset | Neglecting workflow improvement           | `/reflect`            | H7                |
| Fan-Out Discipline  | Fanning out when one focused pass was due | `/breakdown` / script | H6 vs H1·H3·H5·H8 |

## Attribution

These patterns are inspired by the UltraWorkers (ULW) group, a Canada-based organization of Korean developers who built orchestration tools for AI-assisted development. Their work demonstrates that at scale, the system that builds the code matters more than the code itself.

- **OmC** (oh-my-claudecode): 19 agents, 36 skills, teams-first orchestration — [Yeachan Heo](https://github.com/Yeachan-Heo/oh-my-claudecode)
- **OmX** (oh-my-codex): Worktree isolation per worker, incremental merge tracking — [Yeachan Heo](https://github.com/Yeachan-Heo/oh-my-codex)
- **clawhip**: Event routing without context pollution — [Yeachan Heo](https://github.com/Yeachan-Heo/clawhip)
- **OmO** (oh-my-openagent): Multi-model orchestration with 11+ agents — [code-yeongyu](https://github.com/code-yeongyu/oh-my-openagent)
- **claw-code**: Clean-room Claude Code rewrite, 168K+ stars — [UltraWorkers](https://github.com/ultraworkers/claw-code)

---

_See [quick-reference.md](quick-reference.md) for the full 8-Habit rule table. Back to [README](../README.md)_
