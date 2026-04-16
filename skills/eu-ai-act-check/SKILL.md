---
name: eu-ai-act-check
description: >
  EU AI Act compliance checklist for high-risk AI systems — 9 obligations from Articles 9-15.
  Use BEFORE major releases of EU-deployed high-risk AI systems. Maps to H1 (Be Proactive) + H8 (Voice/Conscience).
  Includes scope-check pre-flight to skip if not high-risk or not EU-targeted.
user-invocable: true
argument-hint: "[component to check, or --scope for pre-flight]"
allowed-tools: ["Read", "Glob", "Grep", "Bash"]
prev-skill: any
next-skill: any
---

# EU AI Act Compliance Check (9 Obligations)

**Habit**: H1 (Be Proactive — prevent regulatory crisis) + H8 (Voice — Spirit/Conscience)
**Regulation**: Regulation (EU) 2024/1689, Articles 9-15
**Enforcement**: 2 August 2026 (subject to Digital Omnibus harmonized standards conditionality)
**Anti-pattern**: Discovering compliance gaps after EU deployment instead of during development

> ⚠️ **NOT LEGAL ADVICE.** This skill produces a developer-facing compliance checklist. Consult a qualified EU AI lawyer before relying on it for production EU deployment.

## When to Use

- Before major release of an AI system targeting the **EU market**
- During architecture design of a new high-risk AI feature
- During audit preparation for EU customers/regulators
- After significant changes to data, model, or human-oversight design

## When to Skip

- System is **not high-risk** under Annex III (most internal tools, dev tools, non-safety AI fall outside)
- System is **not deployed in the EU** (no EU users, no EU market)
- Already covered by a recent (<90 day) `/eu-ai-act-check` run with no material changes since

## Process

### Step 0 — Scope Pre-Flight (--scope flag)

Before running the full 9-obligation check, confirm the system is in scope:

```
SCOPE CHECK (Annex III high-risk classification)
─────────────────────────────────────────────────
1. Does the system fall under Annex III categories?
   - [ ] Biometrics (1)
   - [ ] Critical infrastructure (2)
   - [ ] Education/vocational training (3)
   - [ ] Employment/HR (4)
   - [ ] Essential services (credit scoring, public benefits) (5)
   - [ ] Law enforcement (6)
   - [ ] Migration/asylum/border (7)
   - [ ] Justice/democratic processes (8)

2. Is the system deployed/marketed in the EU?
   - [ ] EU users
   - [ ] EU customers
   - [ ] EU data subjects

If BOTH "any Annex III box" AND "any EU box" are checked → IN SCOPE → continue with full check
If either is NO → OUT OF SCOPE → stop here, document decision in `docs/compliance/eu-ai-act/scope-decision.md`
```

### Step 1 — Tiered Obligation Checklist

To prevent checklist fatigue, items are grouped into 3 tiers. **Default mode runs Tier 1 (MUST) only**. Use `--full` to include Tier 2 + 3.

| Tier       | Meaning                                                                                  | Action                 | Default?   |
| ---------- | ---------------------------------------------------------------------------------------- | ---------------------- | ---------- |
| **MUST**   | Blocking — explicit law text, deploy-blocker if missing                                  | Hard fail = NO release | ✅ Default |
| **SHOULD** | Important — explicit law text, secondary requirements                                    | Soft warning           | `--full`   |
| **COULD**  | Conditional/niche — applies only in specific cases (SME, biometric, continuous-learning) | Info only              | `--full`   |

For each item in the 9-obligation checklist, mark Pass / Fail / N/A with 1-line evidence. Items are tagged inline with **[MUST]** / **[SHOULD]** / **[COULD]** so a default-mode runner can filter to MUST only. Each obligation references the linked 8-habit skill that produces the evidence.

**Obligation counts**: 25 MUST items across 9 obligations, 27 SHOULD items, 8 COULD items (60 total). The full checklist — including exact article/paragraph references, evidence file paths, and Three Loops / DSGAI anchors — is in the reference file.

Load `${CLAUDE_PLUGIN_ROOT}/skills/eu-ai-act-check/reference.md` for the full 9-obligation checklist with article references and evidence file paths.

### Step 2 — Generate Report

```
## EU AI Act Compliance Report
**Date**: YYYY-MM-DD
**System**: [name]
**Scope status**: IN SCOPE / OUT OF SCOPE
**Overall**: [X/9 obligations PASS, Y/9 PARTIAL, Z/9 FAIL]

| # | Obligation | Article | Status | Evidence | Gaps |
|---|-----------|---------|--------|----------|------|
| 1 | Risk Management | 9 | PASS | risk-register.md | — |
| 2 | Data Governance | 10 | PARTIAL | data-inventory.md | Bias examination missing |
| ... |

### Critical Gaps
- [list of FAIL items]

### Recommended Next Actions
- [actionable items mapped to other 8-habit skills]
```

Save to `docs/compliance/eu-ai-act/reports/YYYY-MM-DD-<system>.md`

### Step 3 — Habit Checkpoint (H1 + H8)

> **H1**: "Have I prevented a regulatory crisis, or am I waiting to react to one?"
> **H8**: "Do I understand WHY this regulation exists (protect fundamental rights), not just WHAT to comply with?"

## Handoff

- **Expects from predecessor**: A finalized release candidate or design ready for compliance review
- **Produces for successor**: Compliance report + gap list. Failures route back to specific 8-habit skills (e.g., `/security-check` for risk gaps, `/design` for oversight gaps)

## Definition of Done

- [ ] Scope pre-flight completed; OUT OF SCOPE decisions documented
- [ ] All 9 obligations checked with Pass/Fail/N-A + 1-line evidence
- [ ] Critical gaps identified with recommended remediation skill
- [ ] Report saved under `docs/compliance/eu-ai-act/reports/`
- [ ] H1 + H8 checkpoint answered honestly
- [ ] (For production EU deployment) Lawyer review scheduled

## References

- Primary research: `${CLAUDE_PLUGIN_ROOT}/docs/research/eu-ai-act-obligations.md` (verified quotes per article)
- User guide: `${CLAUDE_PLUGIN_ROOT}/guides/eu-ai-act-mapping.md` (workflow + examples)
- Habit details: `${CLAUDE_PLUGIN_ROOT}/habits/h1-be-proactive.md`, `${CLAUDE_PLUGIN_ROOT}/habits/h8-find-voice.md`

> ⚠️ **NOT LEGAL ADVICE.** This skill is a developer reference. The 9-obligation checklist is derived from the regulation text but interpretation is subject to Commission guidance, harmonized standards (pending), and case law. Always consult a qualified EU AI lawyer for production compliance decisions.
