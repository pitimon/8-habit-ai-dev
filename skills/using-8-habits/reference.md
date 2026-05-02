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
- **`/eu-ai-act-check`** — Redirect stub. Migrated to [`pitimon/claude-governance`](https://github.com/pitimon/claude-governance) v3.1.0 on 2026-05-02 (see ADR-012). Install that plugin alongside this one for the canonical 9-obligation checklist.

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

**EU AI Act compliance flow** (requires `pitimon/claude-governance` v3.1.0+):

```
... 7-step workflow ...  →  /eu-ai-act-check  →  /review-ai  →  /ai-dev-log  →  /deploy-guide
                            (claude-governance)   (8-habit)     (8-habit,       (8-habit)
                                                                 Art. 11 log)
```

The `/eu-ai-act-check` skill lives in `pitimon/claude-governance` (migrated from this plugin on 2026-05-02 per ADR-012). Install both plugins for the full flow.

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

## Smart-routing examples

Five worked examples for the argument-driven mode introduced in #149. Each shows what `/using-8-habits "<intent>"` should return — ranked skills + reasoning, NOT the full decision tree.

### Example 1 — Workflow quadrant

**Intent**: `"I'm starting a new feature from scratch"`

**Recommendation** (ranked):

1. `/research` — your intent says "from scratch", so problem-space investigation comes first (H5 Seek First to Understand). Returns a research brief with depth (Quick/Standard/Deep) and verified sources.
2. `/requirements` — alternative if the problem space is already clear; jump straight to PRD + EARS criteria.
3. `superpowers:brainstorming` — alternative if the intent is still fuzzy and you can't articulate the problem yet (cross-plugin, optional).

**Question**: Is the problem clear, or still fuzzy? If clear → `/research`; if fuzzy → `superpowers:brainstorming`.

### Example 2 — Assessment quadrant

**Intent**: `"something feels off about this plan"`

**Recommendation**:

1. `/cross-verify` — the 17-question 8-habit checklist surfaces what specifically feels off; band-based verdict (PASS/CONCERNS/REWORK/FAIL) anchors the gut feeling in evidence.
2. `/whole-person-check` — alternative if the unease is dimensional (Body/Mind/Heart/Spirit imbalance) rather than habit-by-habit; runs a 4-dimension assessment.
3. `/security-check` — alternative if the unease is specifically about secrets / injection / auth (focused OWASP lens).

**Question**: Is it a general gut check (`/cross-verify`), a balance issue (`/whole-person-check`), or a security concern (`/security-check`)?

### Example 3 — Meta quadrant

**Intent**: `"how do I configure my habit profile?"`

**Recommendation**:

1. `/calibrate` — 5-7 question maturity self-assessment writes `~/.claude/habit-profile.md`; other skills read this for verbosity (v2.7.0 contract).
2. No close alternative — if the user wants narrative onboarding instead, recommend no-arg `/using-8-habits`.

**Question**: Run `/calibrate` now?

### Example 4 — Unclear / multi-skill quadrant

**Intent**: `"the deploy went sideways"`

**Recommendation**:

1. `/cross-verify` — first, anchor what specifically went sideways (deployment-related habits: H1 staging-first, H3 rollback ready). Output gives evidence to pick the next move.
2. `/security-check` — alternative if the deploy issue may be a secret leak or injection regression introduced in the release.
3. `/reflect` — alternative for after-the-fact retrospective once the immediate fire is out (5-question retro persisted to `~/.claude/lessons/`).

**Question**: Is the deploy still failing right now (`/cross-verify` + `/security-check`), or is the dust settled and we want lessons captured (`/reflect`)?

### Example 5 — Edge case (insufficient signal)

**Intent**: `"help"`

**Recommendation**: argument is too short / generic to route confidently. Two fallback paths:

1. **No-arg mode** — invoke `/using-8-habits` without argument for the full narrative decision tree (best for new users).
2. **Guided mode** — invoke `/workflow` for the step-by-step 7-step walkthrough with skip prompts (best when user knows they want structure but not which step).

**Question**: New here, or just need a structured restart?
