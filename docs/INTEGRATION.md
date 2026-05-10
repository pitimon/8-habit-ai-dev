# Plugin Integration Guide

> Canonical reference for how `8-habit-ai-dev` composes with companion plugins
> `claude-governance` and `devsecops-ai-team`. This document is the
> Single Source of Truth — companion repos link here.

**Tested versions:**

- `8-habit-ai-dev` 2.15.0
- `claude-governance` 3.3.0
- `devsecops-ai-team` 10.10.0

---

## 1. Layer Map

Each plugin owns a different layer of the SDLC. Composing them produces
defense-in-depth without overlap.

| Plugin              | Layer                                   | Concern                                                            |
| ------------------- | --------------------------------------- | ------------------------------------------------------------------ |
| `8-habit-ai-dev`    | **Workflow method (HOW)**               | 7-step development, Covey habits, cross-verification               |
| `claude-governance` | **Policy / Enforcement (RULES)**        | Fitness functions, ADRs, Three Loops, compliance frameworks        |
| `devsecops-ai-team` | **Operational tooling (SCAN / REPORT)** | SAST/DAST/SCA/Container/IaC + artifact generation (SBOM/AIBOM/VEX) |

Read this as: **HOW** you build (this plugin) → **RULES** you enforce
(governance) → **TOOLS** that produce evidence (devsecops).

---

## 2. Choosing Your Stack — When to Install What

Not every project needs all three. Use this matrix to decide.

| Project type                      | 8-habit | governance |  devsecops  | Note                                                   |
| --------------------------------- | :-----: | :--------: | :---------: | ------------------------------------------------------ |
| Docs / playbooks / infra config   |   ✅    |     ✅     |  optional   | Checklist + fitness functions sufficient               |
| Internal tooling, low compliance  |   ✅    |     ✅     |  optional   | Manual scans on demand                                 |
| Product code (no regulator scope) |   ✅    |     ✅     |   ✅ rec.   | Full pipeline on PR                                    |
| EU CRA / NCSA / PDPA / HIPAA      |   ✅    |     ✅     | ✅ **req.** | Evidence packages from devsecops                       |
| AI / Agentic systems              |   ✅    |     ✅     | ✅ **req.** | `/agentic-scan`, `/ai-redteam`, `/model-security-scan` |

**`8-habit-ai-dev` works fully standalone** — no hard dependency. Workflow
discipline + 17 skills add value even without the other two. Combine
progressively as the matrix suggests.

---

## 3. Integration Points

Where this plugin's skills meet companion plugins.

| `8-habit-ai-dev` skill        | Companion plugin & skill                         | Note                                                                                                                                                                                                        |
| ----------------------------- | ------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `/eu-ai-act-check`            | `claude-governance /eu-ai-act-check` (canonical) | This plugin's version is a **stub redirect** per this plugin's [ADR-012](adr/ADR-012-eu-ai-act-migration-completion.md) (outbound migration, 2026-05-02) and `claude-governance` ADR-003 (inbound receiver) |
| `/security-check` (lens)      | `devsecops /sast-scan, /secret-scan, /sca-scan`  | Checklist + actual tool scans — complementary, not duplicate                                                                                                                                                |
| `/review-ai` (step 5)         | `devsecops /full-pipeline`                       | Step 5 dispatches devsecops scans for evidence                                                                                                                                                              |
| `/design` (step 2)            | `devsecops /threat-model`                        | Design checkpoint includes STRIDE/PASTA threat modeling                                                                                                                                                     |
| `/design` (step 2)            | `claude-governance /create-adr`                  | Architecture decisions captured during design                                                                                                                                                               |
| `/cross-verify`               | `claude-governance /governance-check`            | Habit-based + fitness function gates                                                                                                                                                                        |
| `/requirements`, `/breakdown` | `claude-governance /spec-driven-dev`             | 7-step composes with spec-first                                                                                                                                                                             |
| `/monitor-setup` (step 7)     | `devsecops /siem-export`, `/soar-connect`        | Wire observability into SIEM/SOAR pipelines                                                                                                                                                                 |

---

## 4. Three Loops — Shared Vocabulary with One Asymmetry

Both `claude-governance` and `devsecops-ai-team` adopt the same
**Out-of-Loop / On-the-Loop / In-the-Loop** AI autonomy classification.
Wording verified consistent against `claude-governance/CLAUDE.md` and
`devsecops-ai-team/hooks/session-start.sh`.

**Common spine** (both plugins):

- **Out-of-Loop** — AI executes autonomously (formatting, lint fixes, secret scans, SBOM)
- **On-the-Loop** — AI proposes, human approves (features, new scan rules, severity policy)
- **In-the-Loop** — Human drives, AI assists (architecture, security boundaries, gate overrides)

**Asymmetry to know:**
`claude-governance` extends the spine via **[ADR-002: Consequence-Based Authorization](https://github.com/pitimon/claude-governance/blob/main/docs/adr/ADR-002-consequence-based-authorization.md)**,
adding a 4-level blast-radius dimension (the ADR refers to this as the
"Consequence Override" rule):

| Consequence  | Description                                           |
| ------------ | ----------------------------------------------------- |
| Reversible   | Can be auto-reverted; no lasting impact               |
| Contained    | Affects a single service, user, or scope              |
| Broad        | Affects multiple services or data stores              |
| Irreversible | Production deploy, data deletion, credential rotation |

`devsecops-ai-team` does **not** mirror this extension — its In-the-Loop
list is domain-specific (gate override, IR escalation, vuln suppression,
DAST target approval).

**When both plugins are installed**, governance's ADR-002 takes precedence
for authorization decisions. DevSecOps examples remain illustrative for
security-ops context.

---

## 5. EU AI Act — Scope Split (Important)

Three similarly-named skills exist across the plugins. They are **not**
duplicates — they cover different scopes.

| Skill               | Plugin                          | Scope                                                                                                                        |
| ------------------- | ------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| `/eu-ai-act-check`  | `claude-governance` (canonical) | **All 9 obligations** (Articles 9-15)                                                                                        |
| `/eu-ai-act-check`  | `8-habit-ai-dev` (stub)         | **Redirects to governance** per this plugin's [ADR-012](adr/ADR-012-eu-ai-act-migration-completion.md) (migrated 2026-05-02) |
| `/eu-ai-act-assess` | `devsecops-ai-team`             | **Article 10 only** — training data governance (DG-1 to DG-6)                                                                |

When auditing for EU AI Act compliance:

1. Run `claude-governance /eu-ai-act-check` for the **full** Articles 9-15 picture.
2. Run `devsecops-ai-team /eu-ai-act-assess` for the **deep** Article 10
   training-data evidence package.

---

## 6. Suggested Integrated Flow

A reference pipeline showing where each plugin's skills fit.

```text
/research                                          [8-habit]
  ↓
/requirements                                      [8-habit]
  ↓
/design + /threat-model + /create-adr              [8-habit + devsecops + governance]
  ↓
/breakdown                                         [8-habit]
  ↓
/build-brief → code                                [8-habit]
  ↓
/sast-scan + /secret-scan                          [devsecops]
  ↓
/review-ai                                         [8-habit]
  ↓
/governance-check                                  [governance]
  ↓
/commit-push-pr                                    [8-habit / user workflow]
  ↓
/full-pipeline + /security-gate (on PR)            [devsecops]
  ↓
/deploy-guide                                      [8-habit]
  ↓
/monitor-setup + /siem-export                      [8-habit + devsecops]
```

Skip steps that don't apply to your project type (see section 2).

---

## 7. Standalone Usability

`8-habit-ai-dev` is designed to work **without** the other two plugins:

- All 17 skills function fully standalone.
- `/security-check` provides a lens-based checklist when no scanner is available.
- `/eu-ai-act-check` redirects to `claude-governance` **only if installed**;
  otherwise it surfaces a friendly install hint.
- Cross-verification, whole-person assessment, and maturity profile do not
  require external tools.

For higher-assurance projects, the recommended order to add plugins is:

1. Start with **`8-habit-ai-dev`** (workflow discipline).
2. Add **`claude-governance`** when you need durable policy (fitness
   functions, ADRs, compliance mappings).
3. Add **`devsecops-ai-team`** when you need automated scanning, evidence
   artifacts, or regulator-grade reports.

---

## Related References

- `claude-governance` [ADR-002: Consequence-Based Authorization](https://github.com/pitimon/claude-governance/blob/main/docs/adr/ADR-002-consequence-based-authorization.md) — extends Three Loops
- `8-habit-ai-dev` [ADR-012: EU AI Act Migration Completion](adr/ADR-012-eu-ai-act-migration-completion.md) — outbound migration from this plugin (2026-05-02)
- `claude-governance` [ADR-003: EU AI Act Compliance Toolkit Migration from 8-habit-ai-dev](https://github.com/pitimon/claude-governance/blob/main/docs/adr/ADR-003-eu-ai-act-compliance-toolkit.md) — inbound receiver in governance
- `8-habit-ai-dev` issue [#170](https://github.com/pitimon/8-habit-ai-dev/issues/170) — this canonical document
- `claude-governance` issue [#31](https://github.com/pitimon/claude-governance/issues/31) — stub + reciprocal link
- `devsecops-ai-team` issue [#467](https://github.com/pitimon/devsecops-ai-team/issues/467) — stub + reciprocal link
