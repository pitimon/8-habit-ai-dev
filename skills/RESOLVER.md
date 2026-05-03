# Skill Resolver — Trigger-Phrase Dispatcher

This is a flat lookup. **Given these words → which SKILL.md to read.** It does not replace the narrative decision tree in [`/using-8-habits`](using-8-habits/SKILL.md) — use that for _why_ and _when_. Use this for _which file_.

**Constraints**:

- ≤3 trigger phrases per skill (keeps the file scannable)
- Every row cites `skills/<name>/SKILL.md` — enforced bidirectionally by Check 20 in `tests/validate-structure.sh`
- Pattern: quoted user phrase or short action description → skill path → one-line purpose

Pick the row whose trigger matches the user intent, then read the cited SKILL.md before acting. If two rows could match, read both — skills chain (e.g., `/research` → `/requirements` → `/design`).

---

## Workflow Skills (Steps 0–7)

| Trigger                                                                              | Skill                                                     | Purpose                                                                               |
| ------------------------------------------------------------------------------------ | --------------------------------------------------------- | ------------------------------------------------------------------------------------- |
| `"investigate"`, `"research before specifying"`, starting with an unclear problem    | [`skills/research/SKILL.md`](research/SKILL.md)           | Step 0 — investigate prior art, sources, constraints before writing requirements (H5) |
| `"define done"`, `"write a PRD"`, `"plan this feature"`                              | [`skills/requirements/SKILL.md`](requirements/SKILL.md)   | Step 1 — PRD summary + EARS acceptance criteria (H2)                                  |
| `"architecture decisions"`, `"design the system"`, choosing DB / auth / API shape    | [`skills/design/SKILL.md`](design/SKILL.md)               | Step 2 — surface decisions with trade-offs, human decides (H8)                        |
| `"split into tasks"`, `"atomic tasks"`, decomposing a feature for parallel agents    | [`skills/breakdown/SKILL.md`](breakdown/SKILL.md)         | Step 3 — atomic tasks, 1 task per agent (H3)                                          |
| `"context before coding"`, `"brief me on this task"`, starting an atomic task        | [`skills/build-brief/SKILL.md`](build-brief/SKILL.md)     | Step 4 — context-rich implementation brief per task (H5)                              |
| `"audit AI code"`, `"review before commit"`, after AI writes code and before staging | [`skills/review-ai/SKILL.md`](review-ai/SKILL.md)         | Step 5 — audit AI-generated code for security, quality, completeness (H4)             |
| `"deploy to staging"`, `"ship this safely"`, production deploy planning              | [`skills/deploy-guide/SKILL.md`](deploy-guide/SKILL.md)   | Step 6 — staging-first deploy with rollback plan (H1)                                 |
| `"set up monitoring"`, `"error tracking"`, observability after deploy                | [`skills/monitor-setup/SKILL.md`](monitor-setup/SKILL.md) | Step 7 — error tracking, alerting, health checks (H7)                                 |

## Assessment Skills

| Trigger                                                                               | Skill                                                                         | Purpose                                                                                                                                                                     |
| ------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `"cross-verify the plan"`, `"something feels off"`, 17-question checklist before ship | [`skills/cross-verify/SKILL.md`](cross-verify/SKILL.md)                       | 17-question 8-habit checklist with dimension summary                                                                                                                        |
| `"check spec consistency"`, `"PRD vs design vs tasks drift"`, `"spec-kit /analyze"`   | [`skills/consistency-check/SKILL.md`](consistency-check/SKILL.md)             | Cross-artifact analyzer — 5 detection passes (Coverage, Drift, Ambiguity, Underspec, Inconsistency) over persisted `docs/specs/<slug>/` (v2.15.0, ADR-013)                  |
| `"balance check"`, `"Body/Mind/Heart/Spirit"`, `"is this well-rounded?"`              | [`skills/whole-person-check/SKILL.md`](whole-person-check/SKILL.md)           | 4-dimension assessment — discipline/vision/passion/conscience                                                                                                               |
| `"security review"`, `"OWASP Top 10"`, `"check for secrets / injection"`              | [`skills/security-check/SKILL.md`](security-check/SKILL.md)                   | Focused security lens — secrets, injection, auth, OWASP Top 10                                                                                                              |
| `"EU AI Act compliance"`, `"high-risk AI checklist"`, Articles 9–15 obligations       | [`skills/eu-ai-act-check/SKILL.md`](eu-ai-act-check/SKILL.md) (redirect stub) | Migrated to [`pitimon/claude-governance`](https://github.com/pitimon/claude-governance) v3.1.0 — install that plugin for the canonical 9-obligation checklist. See ADR-012. |
| `"AI dev log"`, `"Article 11 audit trail"`, generate AI disclosure from git           | [`skills/ai-dev-log/SKILL.md`](ai-dev-log/SKILL.md)                           | AI-assisted dev log from git history + Co-Authored-By trailers                                                                                                              |
| `"retrospective"`, `"what did we learn"`, `"post-task reflection"`                    | [`skills/reflect/SKILL.md`](reflect/SKILL.md)                                 | 6-question micro-retrospective + persistent lesson file                                                                                                                     |

## Meta / Onboarding

| Trigger                                                               | Skill                                                       | Purpose                                                                      |
| --------------------------------------------------------------------- | ----------------------------------------------------------- | ---------------------------------------------------------------------------- |
| `"new to the plugin"`, `"which skill should I use?"`, `"onboard me"`  | [`skills/using-8-habits/SKILL.md`](using-8-habits/SKILL.md) | Onboarding meta-skill — 7-step workflow + 17-skill inventory + decision tree |
| `"what's my habit maturity"`, `"assess my level"`, `"set my profile"` | [`skills/calibrate/SKILL.md`](calibrate/SKILL.md)           | 5–7 question maturity assessment → persists `~/.claude/habit-profile.md`     |
| `"walk me through the 7 steps"`, `"guided workflow"`, starting fresh  | [`skills/workflow/SKILL.md`](workflow/SKILL.md)             | Guided 7-step walkthrough with skip prompts per step                         |

---

## Related

- **Why** each skill exists and the decision tree for picking one: [`/using-8-habits`](using-8-habits/SKILL.md) (narrative)
- **How** skills chain (prev/next): each skill's frontmatter `prev-skill` / `next-skill` fields, validated by `tests/test-skill-graph.sh`
- **When** to use which step: [README § 7-Step Workflow](../README.md#the-7-step-workflow) (indexed by step)
- **For non-Claude agents** (Codex, Cursor, Windsurf): see `llms.txt` + `AGENTS.md` at repo root (tracked in Issue #136)
