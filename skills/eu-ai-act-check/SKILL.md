---
name: eu-ai-act-check
description: EU AI Act compliance — migrated to pitimon/claude-governance v3.1.0. This stub redirects to the canonical implementation. Maps to H1 (Be Proactive — prevent regulatory crisis) + H8 (Voice/Conscience).
user-invocable: true
argument-hint: "(install pitimon/claude-governance for the canonical skill)"
allowed-tools: ["Read", "Bash"]
prev-skill: any
next-skill: any
---

# EU AI Act Compliance Check — Migrated

> ⚠️ **NOT LEGAL ADVICE.** This redirect stub is not a substitute for the canonical implementation or for legal counsel.

## What happened

The EU AI Act compliance toolkit (skill + 9-obligation reference + primary-source research + Article-to-skill mapping guide) **migrated to [`pitimon/claude-governance`](https://github.com/pitimon/claude-governance) v3.1.0** on 2026-05-02.

**Why the migration**: per the plugin boundary established in memory observation #233270 (2026-04-07), the two plugins are complementary by design:

- **`8-habit-ai-dev`** = workflow discipline (HOW to develop well — the 7-step Covey-derived process)
- **`pitimon/claude-governance`** = compliance enforcement + framework mappings (WHAT standards apply — DSGAI, EU AI Act, fitness functions, ADRs, Three Loops)

EU AI Act compliance is a **framework mapping** (Articles 9-15 → governance controls), not a workflow step. Original placement here was a boundary error; v3.1.0 of `claude-governance` corrects it. See `docs/adr/ADR-012-eu-ai-act-migration-completion.md` (this plugin) and [`docs/adr/ADR-003-eu-ai-act-compliance-toolkit.md`](https://github.com/pitimon/claude-governance/blob/main/docs/adr/ADR-003-eu-ai-act-compliance-toolkit.md) (governance plugin) for full provenance.

## How to use the canonical skill

```bash
# 1. Install claude-governance alongside this plugin (one-time)
claude plugin marketplace add pitimon/claude-governance
claude plugin install claude-governance@claude-governance

# 2. Invoke the canonical skill
/eu-ai-act-check --scope        # Annex III + EU deployment pre-flight
/eu-ai-act-check                # Full 9-obligation checklist (Tier 1 MUST only)
/eu-ai-act-check --full         # Tier 1 + 2 + 3 (60 items)
```

The canonical skill in `claude-governance` provides the same 9-obligation tiered checklist (25 MUST + 27 SHOULD + 8 COULD), `--scope` pre-flight, primary-source verified Articles 9-15 quotes, and Article-to-skill mapping — but rewritten to route to governance skills (`/governance-check`, `/spec-driven-dev`, `/create-adr`, `governance-reviewer` agent) rather than 8-habit workflow skills.

## When to Use

- You have `pitimon/claude-governance` v3.1.0+ installed and want to invoke the canonical EU AI Act 9-obligation checklist
- You're discovering this skill via the `8-habit-ai-dev` skill catalog (RESOLVER, session-start hook, README) and need to know where the canonical implementation lives

## When to Skip

- The system is not high-risk under Annex III (most internal tools, dev tools, non-safety AI fall outside)
- The system is not deployed in the EU (no EU users, no EU customers, no EU data subjects)
- A recent (<90 day) `/eu-ai-act-check` run from `claude-governance` is already on file with no material changes since
- You don't have `pitimon/claude-governance` installed and don't intend to install it — install command is in the redirect block above

## What stays in this plugin

The complementary workflow skills remain here and continue to produce evidence as a side effect of the 7-step process:

- `/research`, `/requirements`, `/design`, `/breakdown`, `/build-brief`, `/review-ai`, `/deploy-guide`, `/monitor-setup`
- `/ai-dev-log` — generates AI-assisted development log from git history (covers EU AI Act Article 11 ¶3(d) disclosure)
- `/design` Step 5 — lightweight Article 14 design-time sanity check (5-capability table); for the formal Three Loops Decision Model, see `claude-governance` ADR-002

## Definition of Done

- [ ] `pitimon/claude-governance` v3.1.0+ is installed (`claude plugin install claude-governance@claude-governance`)
- [ ] The canonical `/eu-ai-act-check` skill ran successfully against the system in scope
- [ ] Compliance report from the canonical skill is saved under `docs/compliance/eu-ai-act/reports/` in your project repository
- [ ] (For production EU deployment) Lawyer review scheduled — this redirect stub is not a substitute for legal counsel

## References

- **Canonical skill**: [`pitimon/claude-governance` `/eu-ai-act-check`](https://github.com/pitimon/claude-governance/tree/main/skills/eu-ai-act-check)
- **Canonical mapping guide**: [`pitimon/claude-governance` `docs/compliance/EU-AI-ACT-MAPPING.md`](https://github.com/pitimon/claude-governance/blob/main/docs/compliance/EU-AI-ACT-MAPPING.md)
- **Canonical research**: [`pitimon/claude-governance` `docs/research/eu-ai-act-obligations.md`](https://github.com/pitimon/claude-governance/blob/main/docs/research/eu-ai-act-obligations.md)
- **Migration ADR (this plugin)**: `docs/adr/ADR-012-eu-ai-act-migration-completion.md`
- **Source ADR (this plugin, superseded)**: `docs/adr/ADR-005-eu-ai-act-compliance-toolkit.md`
- **Migration ADR (governance plugin)**: [`pitimon/claude-governance` ADR-003](https://github.com/pitimon/claude-governance/blob/main/docs/adr/ADR-003-eu-ai-act-compliance-toolkit.md)
- **EU AI Act enforcement**: 2 August 2026 (subject to Digital Omnibus harmonized standards conditionality)
- **Regulation**: Regulation (EU) 2024/1689, Articles 9-15
