# ADR-005: EU AI Act Compliance Toolkit (v2.3.0 Flagship)

**Status**: Superseded
**Date**: 2026-04-08
**Decision makers**: Pitimon (human) + Claude Opus 4.6 (AI)
**Supersedes**: None
**Superseded by**: ADR-012 — EU AI Act Compliance Toolkit Migration Completion (2026-05-02). The toolkit (skill + research + guide + reference) moved to [`pitimon/claude-governance`](https://github.com/pitimon/claude-governance) v3.1.0; this plugin retains a redirect stub at `skills/eu-ai-act-check/SKILL.md`. Original placement here was a plugin-boundary error — see ADR-012 + memory observation #233270.
**Related**: Issue #57, PRs #65/#66/#67/#68; pitimon/claude-governance#21 + ADR-003

---

## Context

EU AI Act enforcement begins **2 August 2026** (~4 months from this ADR). The regulation imposes 9 specific obligations on high-risk AI systems via Articles 9-15 covering risk management, data governance, technical documentation, record-keeping, transparency, human oversight, accuracy, robustness, and cybersecurity.

Sector landscape research (April 2026) confirmed:

- **No peer Claude Code plugin** addresses EU AI Act explicitly (verified vs. addyosmani/agent-skills 8.3K⭐, claude-governance, superpowers 29K⭐)
- **GitHub Spec Kit** (84.7K⭐) covers spec-driven development but not regulatory compliance
- **AI code quality crisis** documented at 1.75x correctness, 1.64x maintainability, 1.57x security issues vs human-authored code (codeintelligently.com 2026)
- The 8-habit-ai-dev plugin's existing values anchor (Covey 8 Habits + Whole Person Model) maps naturally to EU AI Act obligations — particularly H1 (Be Proactive — prevent regulatory crisis) and H8 (Find Voice — Spirit/Conscience)

This is a **blue-ocean opportunity** for first-mover positioning before enforcement.

## Decision

Add an **EU AI Act Compliance Toolkit** to v2.3.0 as the flagship feature, comprising:

1. **`docs/research/eu-ai-act-obligations.md`** — Internal research artifact with verbatim Verified Quotes from primary law text (Regulation (EU) 2024/1689) for all 7 articles
2. **`guides/eu-ai-act-mapping.md`** — User-facing 3-step workflow guide
3. **`skills/eu-ai-act-check/SKILL.md`** — New skill: 9-obligation tier-tagged checklist (25 MUST + 27 SHOULD + 8 COULD = 60 items) with scope pre-flight
4. **`skills/ai-dev-log/SKILL.md`** — New skill: AI-assisted dev log generator (Article 11 evidence)
5. **`scripts/generate-ai-dev-log.sh`** — Executable bash generator (4 modes, single-pass aggregation)
6. **Article 14 checkpoint added to `skills/design/SKILL.md`** as new Step 5 (5-capability table from Art. 14 ¶4(a-e))

## Options Considered

### Alt 1: Skip EU AI Act, focus on US market

**Pros**: Less regulatory complexity, avoid legal advice risk
**Cons**: Misses the only **first-mover blue ocean** in the sector. Aug 2 2026 enforcement is a hard deadline that creates demand. US market lacks comparable enforcement deadline.

**Rejected**: First-mover window too valuable to skip; bilingual Thai/English plugin already targets non-US developers heavily.

### Alt 2: Cover ALL major frameworks (SOC2, ISO 27001, NIST, EU AI Act)

**Pros**: Broader applicability
**Cons**: Each framework needs 60+ items × 4 frameworks = 240+ items. Defeats H3 (First Things First). Would take 6+ months. Most frameworks lack the time-bound urgency of EU AI Act.

**Rejected**: Scope creep. Defer SOC2/ISO/NIST to v2.5.0+ if demand emerges.

### Alt 3: Auto-generate evidence (compliance automation)

**Pros**: More valuable than checklist
**Cons**: Requires runtime telemetry, persistent state, integration with logging systems. The plugin is markdown-only by design (per ADR-001).

**Rejected**: Out of scope for plugin architecture. `/ai-dev-log` script is the limited automation we can offer; full compliance automation belongs in GRC tools (Drata, OneTrust, etc.).

### Alt 4: Article 14 checkpoint as separate skill (not in /design)

**Pros**: Avoids modifying foundational `/design` skill (less scope creep)
**Cons**: Article 14 oversight is a **design-time decision**, not a post-hoc check. Putting it in `/design` reinforces the discipline at the right point in workflow.

**Rejected**: Article 14 belongs in design phase. Trade-off accepted: foundational skill expansion vs. discipline placement correctness.

## Consequences

### Positive

- **Blue-ocean positioning**: First Claude Code plugin with explicit EU AI Act readiness
- **Enforcement window leverage**: 4 months until Aug 2 2026 = strong demand driver
- **Habit framework synergy**: Articles 9, 14, 15 map cleanly to H1, H8 (Spirit), enabling natural integration with existing skills
- **Audit trail capability**: `/ai-dev-log` provides Article 11 evidence for any project using the plugin
- **Three Loops anchor**: Article 14 ¶4(a-e) provides regulatory backing for the existing decision-loop framework
- **Marketing differentiation**: README EU AI Act badge + flagship marketing doc

### Negative

- **Skill convention deviation**: 60-item checklist is heavier than existing 5-8 step pattern. Mitigated by tier system (25 MUST default).
- **Bash dependency added**: First skill in plugin to depend on `git`, `awk`, `sed`. Documented in CLAUDE.md Bash policy line.
- **Foundational skill modified**: `/design` Step count changed from 6 to 7. Backward-compatible (Step 5 only triggers for AI systems with EU scope).
- **NOT LEGAL ADVICE liability**: Plugin must prominently disclaim legal advice in all 3 EU AI Act files. Mitigated by top-of-file disclaimers + ADR documentation.
- **Documentation maintenance**: 715-line research doc + 280-line guide require updates if regulation changes. Mitigated by Verified Quote anchoring (changes detectable).

### Neutral

- Future v2.4.0 features (telemetry, JSON output, cross-verify Agent Teams) build on this foundation
- Sets precedent for compliance-focused skills (SOC2, ISO 27001 deferred)

## Compliance with CLAUDE.md Conventions

| Convention                                        | Compliance | Notes                                                     |
| ------------------------------------------------- | ---------- | --------------------------------------------------------- |
| Skills are read-only guidance                     | ✅         | New skills don't modify files                             |
| Bash only when needed                             | ✅         | Documented in CLAUDE.md +1 line                           |
| `habits/`, `guides/`, `rules/` reference content  | ✅         | New `guides/eu-ai-act-mapping.md` follows pattern         |
| Plugin metadata in plugin.json + marketplace.json | ✅         | Both bumped to 2.3.0 in PR 4                              |
| Session hook ≤300 tokens                          | ✅         | Hook unchanged                                            |
| Version in 3 files                                | ✅         | plugin.json + marketplace.json + README footer all bumped |
| ADR for >3 file changes                           | ✅         | This ADR-005                                              |
| File size <800 lines                              | ✅         | Largest is research doc at 351 lines                      |

## Verification Discipline

Per the cross-verify finding that the original draft had Body dimension at 25%, the implementation includes:

1. **Primary source verification**: Law text fetched via web.archive.org (FLI mirror of OJ text) for all 7 articles
2. **Independent cross-check**: research-verifier agent verified claims against EC AI Act Service Desk
3. **Item-level corrections**: 4 secondary-source items removed (quarterly review, 36-month retention, annual pen test, quarterly retrieval test) — none in actual law
4. **Article paragraph anchors**: 65+ `¶` references throughout
5. **Tier system**: 25 MUST default reduces cognitive load; `--full` for completeness
6. **Three Loops disclosure**: Reframed as "satisfies" (not "backed by") + Endsley/DARPA citation

## Decision Loop Classification

Per the Three Loops governance model:

| Aspect                              | Loop            | Rationale                                            |
| ----------------------------------- | --------------- | ---------------------------------------------------- |
| Add new skills                      | **On-the-Loop** | AI proposes structure, human approves naming + scope |
| Modify foundational `/design` skill | **In-the-Loop** | Touches existing user-facing workflow                |
| EU AI Act interpretation            | **In-the-Loop** | Legal accuracy requires human judgment               |
| Bash script implementation          | **Out-of-Loop** | Technical execution, reviewed by tests               |
| Article paragraph references        | **In-the-Loop** | Each must be verified against primary source         |

## Open Questions / Follow-Ups

1. **60-item checklist refactor** (deferred to v2.3.1): Consider extracting SHOULD/COULD tiers to `guides/eu-ai-act-extended-checklist.md` (similar to cross-verify domain packs)
2. **Lawyer review** before promoting flagship marketing: Currently disclaimed as "not legal advice" but consider engaging EU AI lawyer for v2.3.1
3. **Annex IV automation**: Currently out of scope; revisit when EC publishes simplified SME form
4. **Sector expansion**: If demand emerges, add SOC2/ISO 27001/NIST mappings as separate ADRs

## References

- **Regulation (EU) 2024/1689**: Official EU AI Act text (CELEX:32024R1689)
- **EU AI Act Implementation Timeline**: https://artificialintelligenceact.eu/implementation-timeline/
- **EC AI Act Service Desk**: https://ai-act-service-desk.ec.europa.eu/en/ai-act/
- **Internal research**: `docs/research/eu-ai-act-obligations.md` (verified quotes per article)
- **User guide**: `guides/eu-ai-act-mapping.md`
- **Issue #57**: v2.3.0 flagship S1 EU AI Act compliance toolkit
- **PRs**: #65 (research), #66 (skill), #67 (script), #68 (this ADR + version bump)
- **Sector research brief**: `~/.claude/plans/crispy-herding-cook.md` (April 2026 opportunity scan)

---

**Verified by**: Cross-verify 15/15 (Body 4/4, Mind 6/6, Heart 2/2, Spirit 3/3) — Well-Prepared band
**8-habit-reviewer findings**: Mix of valid (version bump, ADR, README/CLAUDE.md updates) and refuted (BSD date, JSON escaping, NOT LEGAL ADVICE placement — all already implemented). This ADR addresses the 3 valid hard gaps.
