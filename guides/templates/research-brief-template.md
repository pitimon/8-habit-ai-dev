# Research Brief Template

Use this template when producing output from `/research`. All sections marked (optional) can be omitted when not applicable.

```
## Research Brief: [Topic]

**Depth**: [Quick | Standard | Deep]
**Mode**: [General | Compare | Audit]
**Date**: [YYYY-MM-DD]

### Questions Investigated
1. [research question]
2. [research question]

### Findings

| # | Finding | Source | Verified |
|---|---------|--------|----------|
| 1 | [finding] | [file:line or URL] | [Yes/No/Pending] |

### Comparison Matrix (optional — Compare mode)

| Criterion | Option A | Option B | Option C |
|-----------|----------|----------|----------|
| [criterion] | [assessment] | [assessment] | [assessment] |

**Winner**: [option] — [1-sentence rationale]

### Audit Results (optional — Audit mode)

| Claim / Doc says | Code actually does | Match? | File |
|------------------|--------------------|--------|------|
| [documented behavior] | [actual behavior] | [Yes/No/Partial] | [file:line] |

### Constraints Identified
- [constraint] — Source: [regulation, API doc, stakeholder, or other]

### Source Verification Report (optional — Deep mode)

| Source | Type | Status | Notes |
|--------|------|--------|-------|
| [path or URL] | [codebase/web/doc] | [Verified/Dead/Not Found] | [detail] |

### Key Insight
[1-2 sentence finding that shapes requirements]

### Recommendation
[build / reuse / adapt] — [reasoning with cited evidence]
```

## Template Notes

- **Quick mode**: Omit Source Verification Report; Verified column shows "N/A"
- **Standard mode**: Self-verify sources (Glob for files, WebFetch for URLs); no agent dispatch
- **Deep mode**: Dispatch `research-verifier` agent; include full Source Verification Report
- **Compare mode**: Include Comparison Matrix with at least 3 criteria
- **Audit mode**: Include Audit Results table; every row must cite a file:line
- All findings MUST cite their source — uncitable claims marked as "unverified assumption"
