# Using 8-Habits — Reference

Full 17-skill inventory and cross-plugin composition tables. Loaded from `SKILL.md` when the user needs the complete catalog beyond the 7-step workflow summary.

## All 17 Skills (full inventory)

### Workflow skills (8)

- **`/research`** (Step 0) — Convergent investigation with sources. Depth levels (Quick/Standard/Deep), modes (General/Compare/Audit), verification. Output: research brief. For divergent "explore the problem" thinking BEFORE research, use `superpowers:brainstorming` instead.
- **`/requirements`** (Step 1) — PRD with What/Why/Who/Scope + **EARS-notation** acceptance criteria (5 templates). Output: PRD summary.
- **`/design`** (Step 2) — Architecture decisions with trade-offs. Human decides, AI proposes. Includes Article 14 human-oversight checkpoint for AI systems. Output: ADRs.
- **`/breakdown`** (Step 3) — Decompose into atomic tasks. Orchestration classification (sequential/parallel-safe/parallel-worktree). Output: task list with dependencies.
- **`/build-brief`** (Step 4) — Read existing code BEFORE writing new code. Produces context brief per task. Output: implementation brief.
- **`/review-ai`** (Step 5) — 4-level verdict (PASS/CONCERNS/REWORK/FAIL) with dimension balance check. Output: review report.
- **`/deploy-guide`** (Step 6) — Staging-first deployment with rollback plan. Output: deployment checklist.
- **`/monitor-setup`** (Step 7) — Health checks, alerting, observability. Output: monitoring configuration.

### Assessment skills (6)

- **`/cross-verify`** — 17-question 8-habit checklist covering all 4 Whole Person dimensions (Body/Mind/Heart/Spirit). Band-based verdict. Run after plans, before PRs.
- **`/whole-person-check`** — 4-dimension assessment (1-5 scale) with AI Blind Spot detection. Covers Body (discipline), Mind (vision), Heart (passion), Spirit (conscience).
- **`/security-check`** — Focused OWASP security lens (secrets, injection, auth, deps). Review mode, not a runtime hook.
- **`/reflect`** — 5-question micro-retrospective (5 min max) with action-item tracking. Run after completing significant work.
- **`/calibrate`** — Writes `~/.claude/habit-profile.md` so skills adapt verbosity to user maturity (v2.6.0).
- **`/workflow`** — Guided walkthrough of the 7-step workflow. Prompts at each step to invoke or skip.

### Meta / transparency skills (3)

- **`/using-8-habits`** (this skill) — Onboarding navigation. Explains the 7-step workflow and all 17 skills.
- **`/ai-dev-log`** — Generate AI-assisted development log from git history + Co-Authored-By trailers. Transparency artifact, framework-agnostic.
- **`/eu-ai-act-check`** — EU AI Act 9-obligation compliance checklist (temporary placement; will migrate to `pitimon/claude-governance` in a future release per ADR-005 + ADR-006).

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
