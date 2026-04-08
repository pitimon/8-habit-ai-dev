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

For each item, mark Pass / Fail / N/A with 1-line evidence. Items are tagged inline with **[MUST]** / **[SHOULD]** / **[COULD]** so a default-mode runner can filter to MUST only. Reference the linked 8-habit skill that produces each piece of evidence.

#### Obligation 1: Risk Management (Article 9)

**Mapped skill**: `/security-check`, `/design`

- [ ] **[MUST]** Risk register exists for known and reasonably foreseeable risks (Art. 9 ¶2(a))
- [ ] **[MUST]** Each identified risk has a documented mitigation measure (Art. 9 ¶2(d))
- [ ] **[MUST]** Residual risk judged acceptable per hazard and overall (Art. 9 ¶5)
- [ ] **[MUST]** Testing against pre-defined metrics and probabilistic thresholds (Art. 9 ¶8)
- [ ] **[SHOULD]** Reasonably foreseeable misuse scenarios explicitly considered (Art. 9 ¶2(b))
- [ ] **[SHOULD]** Process for incorporating post-market monitoring findings (Art. 9 ¶2(c))
- [ ] **[COULD]** Adverse impact on persons under 18 + vulnerable groups considered (Art. 9 ¶9)

**Evidence file**: `docs/compliance/eu-ai-act/01-risk-mgmt/risk-register.md`

#### Obligation 2: Data Governance (Article 10)

**Mapped skill**: `/design`, `/requirements`

- [ ] **[MUST]** Bias examination for health/safety/fundamental-rights/discrimination impact (Art. 10 ¶2(f))
- [ ] **[MUST]** Bias detect/prevent/mitigate measures applied (Art. 10 ¶2(g))
- [ ] **[MUST]** Datasets relevant, sufficiently representative, best-effort error-free, complete (Art. 10 ¶3)
- [ ] **[SHOULD]** Data governance practices documented (design, collection, preparation) (Art. 10 ¶2(a)-(c))
- [ ] **[SHOULD]** Data origin and original purpose documented (Art. 10 ¶2(b))
- [ ] **[SHOULD]** Statistical properties appropriate for target population (Art. 10 ¶3)
- [ ] **[COULD]** Geographical/contextual/behavioural setting considered (Art. 10 ¶4)
- [ ] **[COULD]** (Non-ML systems) ¶2-5 apply only to test data sets (Art. 10 ¶6)

**Evidence file**: `docs/compliance/eu-ai-act/02-data-gov/data-inventory.md`

#### Obligation 3: Technical Documentation (Article 11)

**Mapped skill**: `/design`, `/requirements`, `/build-brief`

- [ ] **[MUST]** Technical documentation drawn up before market placement (Art. 11 ¶1)
- [ ] **[MUST]** Documentation contains all elements of Annex IV at minimum (Art. 11 ¶1)
- [ ] **[SHOULD]** Documentation kept up-to-date through lifecycle (Art. 11 ¶1)
- [ ] **[SHOULD]** Documentation written for clarity to authorities + notified bodies (Art. 11 ¶1)
- [ ] **[COULD]** (SME/startup) Simplified Annex IV form may be used (Art. 11 ¶1)

**Evidence file**: `docs/compliance/eu-ai-act/03-tech-docs/annex-iv/`

#### Obligation 4: Record-Keeping (Article 12)

**Mapped skill**: `/monitor-setup`, `/reflect`

- [ ] **[MUST]** System technically allows automatic event recording over lifetime (Art. 12 ¶1)
- [ ] **[SHOULD]** Logs enable identification of risk-presenting situations (Art. 12 ¶2(a))
- [ ] **[SHOULD]** Logs enable post-market monitoring per Art. 72 (Art. 12 ¶2(b))
- [ ] **[COULD]** (Annex III 1(a) systems) Log start/end of use, reference DB, input/match, verifying persons (Art. 12 ¶3)

**Evidence file**: `docs/compliance/eu-ai-act/04-records/logging-config.md`

> ℹ️ Article 12 does NOT specify retention duration, granularity, or immutability. Those are operational best practices but not legal requirements.

#### Obligation 5: Transparency to Deployers (Article 13)

**Mapped skill**: `/requirements`, `/design`

- [ ] **[MUST]** Instructions for use exist, "relevant, accessible, comprehensible" (Art. 13 ¶2)
- [ ] **[MUST]** Accuracy/robustness/cybersecurity levels with metrics declared (Art. 13 ¶3(b)(ii))
- [ ] **[MUST]** Human oversight measures from Art. 14 referenced (Art. 13 ¶3(d))
- [ ] **[SHOULD]** System designed for sufficient transparency to deployers (Art. 13 ¶1)
- [ ] **[SHOULD]** Provider identity + contact details documented (Art. 13 ¶3(a))
- [ ] **[SHOULD]** Intended purpose stated (Art. 13 ¶3(b)(i))
- [ ] **[SHOULD]** Known foreseeable circumstances affecting performance documented (Art. 13 ¶3(b)(iii))
- [ ] **[SHOULD]** Output interpretation guidance provided (Art. 13 ¶3(b)(vii))
- [ ] **[SHOULD]** Predetermined changes documented (Art. 13 ¶3(c))
- [ ] **[SHOULD]** Computational resources, lifetime, maintenance documented (Art. 13 ¶3(e))
- [ ] **[SHOULD]** Log collection/storage/interpretation mechanism per Art. 12 (Art. 13 ¶3(f))

**Evidence file**: `docs/compliance/eu-ai-act/05-transparency/instructions-for-use.md`

#### Obligation 6: Human Oversight (Article 14) ⭐ Three Loops Anchor

**Mapped skill**: `/design` (Article 14 checkpoint — see Issue #59 for Three Loops table)

- [ ] **[MUST]** Overseers can disregard, override, reverse output (Art. 14 ¶4(d))
- [ ] **[MUST]** Overseers can intervene OR trigger 'stop' button for safe halt (Art. 14 ¶4(e))
- [ ] **[MUST]** Overseers can understand capacities + limitations + detect anomalies (Art. 14 ¶4(a))
- [ ] **[SHOULD]** Oversight measures designed to prevent/minimise risk to fundamental rights (Art. 14 ¶1)
- [ ] **[SHOULD]** Measures commensurate with risk, autonomy level, context (Art. 14 ¶3)
- [ ] **[SHOULD]** Oversight built into system before market placement OR identified for deployer implementation (Art. 14 ¶3(a)-(b))
- [ ] **[SHOULD]** Overseers aware of automation bias risk (Art. 14 ¶4(b))
- [ ] **[SHOULD]** Overseers can correctly interpret output (Art. 14 ¶4(c))
- [ ] **[COULD]** (Annex III 1(a) biometric) Identification verified by ≥2 natural persons (Art. 14 ¶5)

**Evidence file**: `docs/compliance/eu-ai-act/06-oversight/oversight-design.md`

> 🔗 The Three Loops design pattern (Out/On/In-the-Loop) is one valid way to satisfy Article 14 ¶4(a-e). Three Loops terminology is from human-autonomy teaming literature (Endsley 1999, DARPA), NOT EU law. Cite Article 14 ¶ refs in audit, not Three Loops labels.

#### Obligation 7: Accuracy (Article 15 ¶1-3)

**Mapped skill**: `/review-ai`, `/monitor-setup`

- [ ] **[MUST]** Accuracy level appropriate to intended purpose (Art. 15 ¶1)
- [ ] **[MUST]** Accuracy metrics declared in instructions for use (Art. 15 ¶3)
- [ ] **[SHOULD]** Performs consistently throughout lifecycle (Art. 15 ¶1)
- [ ] **[SHOULD]** Uses benchmarks/measurement methodologies as available (Art. 15 ¶2)

**Evidence file**: `docs/compliance/eu-ai-act/07-accuracy/baselines.md`

#### Obligation 8: Robustness (Article 15 ¶4)

**Mapped skill**: `/security-check`, `/review-ai`

- [ ] **[MUST]** System resilient to errors/faults/inconsistencies (Art. 15 ¶4)
- [ ] **[SHOULD]** Resilience to interaction with natural persons + other systems (Art. 15 ¶4)
- [ ] **[SHOULD]** Technical AND organisational measures for resilience (Art. 15 ¶4)
- [ ] **[COULD]** (If applicable) Redundancy/backup/fail-safe plans (Art. 15 ¶4)
- [ ] **[COULD]** (Continuous-learning systems) Feedback loop mitigation for biased outputs (Art. 15 ¶4)

**Evidence file**: `docs/compliance/eu-ai-act/08-robustness/resilience-design.md`

#### Obligation 9: Cybersecurity (Article 15 ¶5) ⭐ DSGAI Anchor

**Mapped skill**: `/security-check` (DSGAI 11-control mapping — Issue #60)

- [ ] **[MUST]** System resilient to unauthorized alteration of use/outputs/performance (Art. 15 ¶5)
- [ ] **[MUST]** Data poisoning prevent/detect/respond capability (Art. 15 ¶5)
- [ ] **[MUST]** Model poisoning prevent/detect/respond capability (Art. 15 ¶5)
- [ ] **[MUST]** Adversarial examples / model evasion prevent/detect/respond capability (Art. 15 ¶5)
- [ ] **[MUST]** Confidentiality attacks mitigation (Art. 15 ¶5)
- [ ] **[MUST]** Model flaws mitigation (Art. 15 ¶5)
- [ ] **[SHOULD]** Cybersecurity measures appropriate to risks (Art. 15 ¶5)

**Evidence file**: `docs/compliance/eu-ai-act/09-cybersecurity/threat-model.md`

> 🔗 Article 15 ¶5 names exactly 5 attack categories. OWASP DSGAI 11 controls operationalize each category with concrete checks. Use `/security-check --dsgai` (when Issue #60 ships) to generate the underlying control list.

### Tier Summary (for default-mode runners)

| Tier       | Item count | Default behavior                                                                      |
| ---------- | ---------- | ------------------------------------------------------------------------------------- |
| **MUST**   | 25         | Always run; any FAIL = release blocker                                                |
| **SHOULD** | 27         | Run with `--full`; FAIL = warning                                                     |
| **COULD**  | 8          | Run with `--full` only if context applies (SME, biometric, continuous-learning, etc.) |
| **Total**  | 60         | —                                                                                     |

> **Verify counts**: `grep -c '^- \[ \] \*\*\[MUST\]\*\*' skills/eu-ai-act-check/SKILL.md`

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
