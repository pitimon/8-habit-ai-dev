# ADR-012: EU AI Act Compliance Toolkit Migration Completion

**Status**: Accepted
**Implementation**: 2026-05-02 in commit `ed65b97` (v2.14.2 release); metadata closure 2026-05-03 in v2.14.3
**Date**: 2026-05-02
**Decision makers**: Pitimon (human) + Claude Opus 4.7 (AI, 1M context)
**Supersedes**: ADR-005 (EU AI Act Compliance Toolkit, v2.3.0 Flagship)
**Related**: pitimon/claude-governance#21 + [ADR-003](https://github.com/pitimon/claude-governance/blob/main/docs/adr/ADR-003-eu-ai-act-compliance-toolkit.md), memory observation #233270

---

## Context

ADR-005 (2026-04-08) shipped the EU AI Act compliance toolkit in this plugin's v2.3.0 release as a "blue-ocean flagship" feature. At the time, compliance reviews were modeled as an extension of the workflow.

Subsequent boundary review (memory observation #233270, 2026-04-07, "Both Recommended for Maximum Coverage") clarified that this plugin and `pitimon/claude-governance` are complementary by design with distinct responsibilities:

- **`8-habit-ai-dev`** = workflow discipline (HOW to develop well — the 7-step Covey-derived process: research → requirements → design → breakdown → build-brief → review → deploy → monitor; plus `/reflect`, `/calibrate`, `/cross-verify`, `/whole-person-check`)
- **`pitimon/claude-governance`** = compliance enforcement + framework mappings (WHAT standards apply — DSGAI, EU AI Act, fitness functions, ADRs, Three Loops Decision Model with consequence-based gating)

EU AI Act compliance is a **framework mapping** (Articles 9-15 → governance controls), not a workflow step. The original placement in this plugin was a plugin-boundary error. Tracking issue [pitimon/claude-governance#21](https://github.com/pitimon/claude-governance/issues/21) was opened to coordinate the migration.

`pitimon/claude-governance` v3.1.0 shipped on 2026-05-02 (PR [pitimon/claude-governance#26](https://github.com/pitimon/claude-governance/pull/26)) with the migrated toolkit:

- `skills/eu-ai-act-check/SKILL.md` + `reference.md` — 9-obligation tiered checklist, rewritten to route to governance skills
- `docs/research/eu-ai-act-obligations.md` — primary-source verified Articles 9-15 quotes (verbatim from this plugin's v2.3.0)
- `docs/compliance/EU-AI-ACT-MAPPING.md` — Article-to-skill mapping rewritten for governance plugin's skill set
- `docs/adr/ADR-003-eu-ai-act-compliance-toolkit.md` — mirror migration ADR
- Bidirectional cross-references between EU AI Act Article 15 ¶5 and OWASP DSGAI04/DSGAI11 in DSGAI-MAPPING.md
- 8 new structural validation checks in `tests/validate-plugin.sh` (53 → 64)

This ADR records the completion side of that migration in this plugin.

## Decision

Complete the migration by removing duplicated content from this plugin while preserving discoverability for users who only have this plugin installed:

1. **Delete the migrated content files** (now canonical in `pitimon/claude-governance`):
   - `skills/eu-ai-act-check/reference.md`
   - `docs/research/eu-ai-act-obligations.md`
   - `guides/eu-ai-act-mapping.md`

2. **Replace `skills/eu-ai-act-check/SKILL.md` with a redirect stub** that:
   - Names the canonical location (`pitimon/claude-governance` v3.1.0+)
   - Provides install command and invocation example
   - Preserves the NOT LEGAL ADVICE disclaimer (regulatory communication continuity)
   - Links back to this ADR + governance ADR-003 for provenance
   - Keeps the skill name `eu-ai-act-check` valid in the skill catalog so existing cross-references (RESOLVER, using-8-habits, design Step 5, ai-dev-log, session-start hook) still resolve

3. **Mark ADR-005 as Superseded by ADR-012** (this ADR), preserving the historical decision record but flagging it as no longer current.

4. **Update `tests/validate-content.sh` Check 15** to assert the post-migration state:
   - Stub exists + redirects to canonical location
   - Stub preserves NOT LEGAL ADVICE disclaimer
   - Stub references this ADR
   - Deleted files are NOT present (catches accidental restore)
   - ADR-012 exists; ADR-005 status updated to Superseded

5. **Update cross-references** in surface-area files to reframe `/eu-ai-act-check` as a redirect:
   - `skills/RESOLVER.md` — note migration in skill discovery table
   - `skills/using-8-habits/SKILL.md` + `reference.md` — onboarding mentions
   - `skills/design/SKILL.md` Step 5 — Article 14 checkpoint redirects scope pre-flight
   - `skills/ai-dev-log/SKILL.md` — references to research file + downstream Obligation 3 evidence
   - `hooks/session-start.sh` — Compliance line in startup banner
   - `README.md` — skill table entry

6. **Defer wiki updates** (`docs/wiki/Architecture.md`, `Changelog.md`, `FAQ.md`, `Home.md`, `Installation.md`, `Skills-Reference.md`, `Workflow-Overview.md`) and the README "EU AI Act ready" badge to a follow-up doc-only PR. Rationale: wiki pages are GitHub-hosted documentation, not skill behavior; batching them in the same PR would inflate diff size and risk formatter noise (precedent from `pitimon/claude-governance` PR #25 + #26).

## Consequences

### Positive

- Plugin boundary integrity restored — framework mappings live in the framework plugin
- Single source of truth for the canonical 9-obligation checklist
- Users with both plugins installed get full coverage (workflow discipline + compliance enforcement)
- Users with only this plugin installed see a clear redirect to the canonical location, including install command
- Cross-plugin coordination overhead disappears — no more two-place maintenance
- Reusable migration pattern established: move canonical content, leave redirect stub, mark old ADR as Superseded, update validators to assert post-migration state

### Negative

- Users on this plugin alone lose the in-plugin EU AI Act checklist. Mitigated by: (a) the redirect stub is unmissable, (b) `claude-governance` install is one command, (c) NOT LEGAL ADVICE disclaimer continuity preserved
- Some content drift risk in deferred wiki/README files until the follow-up PR. Mitigated by: validator Check 15 enforces stub correctness; deferred work is GitHub-hosted docs only, not behavior
- ADR-005 historical record now reads as "blue-ocean flagship that lasted ~3 weeks" — honest, but a learning artifact about plugin-boundary discipline

### Risks

- **Restore risk**: a future contributor unaware of the migration could try to restore the deleted files or the stub. Mitigated by: validator Check 15 negative assertions (deleted files must NOT exist) + Superseded marker on ADR-005 + cross-references in stub itself
- **Cross-plugin version drift**: if `pitimon/claude-governance` removes the canonical `eu-ai-act-check` skill in a future release, the stub here would point to nothing. Mitigated by: governance ADR-003 documents the migration contract; same maintainer owns both repos

## Options Considered

### Alt 1: Hard delete the entire `skills/eu-ai-act-check/` directory

**Pros**: Cleanest separation. No stub maintenance.
**Cons**: Breaks all cross-references (RESOLVER, using-8-habits, design Step 5, ai-dev-log Privacy Note, session-start hook, README skill table) without a migration signal. Users invoking `/eu-ai-act-check` get a "skill not found" error rather than helpful guidance. Validator-failure cascade across multiple files. Estimated 90+ min vs. ~25 min for stub approach.
**Decision**: Rejected. The redirect stub costs ~50 lines of markdown and zero behavior; the discoverability + cross-reference preservation justify the cost.

### Alt 2: Full cleanup PR — delete content + reframe `/ai-dev-log` + reframe `/design` Step 5 + update all wiki pages + README badge in single PR

**Pros**: Single atomic migration completion. No follow-up work.
**Cons**: Large diff (estimated 90+ min, 10+ files beyond stub). README + wiki touch the same Markdown formatter race that produced 140-line noise diffs in `pitimon/claude-governance` PR #25. Mixes deletion (deterministic) with documentation rewrites (subjective).
**Decision**: Rejected for v2.14.2. The deletion + stub + critical cross-refs + ADR + validator changes are the load-bearing migration completion; wiki/README cosmetic touches batch cleanly into a separate doc-only PR. Smaller PR = lower review burden = faster ship = duplication-window minimized.

### Alt 3: Leave the toolkit in this plugin AND ship duplicate in claude-governance

**Pros**: No in-plugin breaking change; users on either plugin alone get full coverage.
**Cons**: Permanent two-place maintenance. Drift inevitability (governance bumps a tier count, this plugin doesn't, primary-source updates, etc.). Defeats the entire reason for the migration. Users with both plugins installed see two `/eu-ai-act-check` skills and don't know which is canonical.
**Decision**: Rejected. The boundary correction is the point.

## Verification

After this ADR is implemented, verify with:

- `bash tests/validate-content.sh` — Check 15 reports stub-mode pass; deleted-file negative assertions pass; ADR-012 exists; ADR-005 marked Superseded
- `bash tests/validate-structure.sh` — no breaks in skill catalog (stub still has valid frontmatter)
- `grep -rn "eu-ai-act" skills/eu-ai-act-check/` — only one file remains: SKILL.md
- `git log --diff-filter=D --name-only -- 'docs/research/eu-ai-act-obligations.md' 'guides/eu-ai-act-mapping.md' 'skills/eu-ai-act-check/reference.md'` — confirms deletions in this commit

After v2.14.2 ships, confirm cross-plugin contract:

- `pitimon/claude-governance` v3.1.0 release tag exists: https://github.com/pitimon/claude-governance/releases/tag/v3.1.0
- Canonical skill resolves when both plugins installed: `claude --plugin claude-governance@claude-governance -p '/eu-ai-act-check --scope'`

## Provenance

- **Migration tracking**: pitimon/claude-governance#21 (closed 2026-05-02 by PR #26)
- **Canonical files now live in**: pitimon/claude-governance v3.1.0
- **Cross-plugin migration ADR**: pitimon/claude-governance `docs/adr/ADR-003-eu-ai-act-compliance-toolkit.md`
- **Plugin boundary decision**: memory observation #233270 (2026-04-07)
- **This plugin's superseded ADR**: ADR-005 (now marked Superseded by this ADR)

## NOT LEGAL ADVICE

The redirect stub preserves the NOT LEGAL ADVICE disclaimer verbatim. EU AI Act enforcement begins 2 August 2026 (subject to Digital Omnibus harmonized standards conditionality). Users in scope should consult a qualified EU AI lawyer for production compliance decisions, regardless of which plugin provides the skill.
