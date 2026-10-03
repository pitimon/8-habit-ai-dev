---
feature: guide-only-rules-404
step: eval
created: 2026-10-03
---

# #404 blind evaluation: rules moved from guides into SKILL.md

## Setup

- Arms: **OLD** = `main` SKILL.md (v2.21.53), **NEW** = branch SKILL.md. Each run read only one SKILL.md and one case file, and was not told which arm it had.
- n = 3 per arm per case. The whole-person-check and research arms ran their 3 repetitions inside one subagent, so they are less independent than the cross-verify arms (one subagent per run).
- Metrics were written to `metrics.md` before any run.
- Same model family as the author. The independent cross-family check from the plan (Phase 4) has **not** been run.

## Results

| Case | Metric (pre-registered) | OLD | NEW |
|---|---|---|---|
| cross-verify | M1: ToolSearch allowlist claim (mocks only) is not PASS | 3/3 | 3/3 |
| cross-verify | M2: recommendation is not "proceed" | 3/3 | 3/3 |
| whole-person-check | M1: Body = 3, because the level-4 "monitoring configured" indicator is unmet | 3/3 | 3/3 |
| research | M1: brief has a Confidence & Open Unknowns section | **0/3** | **3/3** |
| research | M2: the 7-month-old lesson is treated as stale or unverified | 3/3 | 3/3 |

Secondary (not pre-registered, reported for completeness): the cross-verify output asks for a **control case** in the real-host check: OLD 0/3, NEW 3/3.

## Reading

- **One rule moved behaviour (research M1: 0/3 → 3/3).** Without the rule in SKILL.md, no run produced the mandatory section that lived only in the template.
- **Four metrics were already at ceiling under OLD.** In those cases the model reached the right verdict without the rule: the mocked-only allowlist was already debt via the v2.21.50 core-claim rules, the monitoring gap was obvious from the case, and the lesson's date clashed visibly with the repo change. These results show no harm. They do not show the rule is needed, because the cases were not hard enough to separate the arms.
- **The real-host rule's measurable effect is the control case (0/3 → 3/3).** The verdict was already right; the check it prescribes is now the one the skill asks for.
- **Limit**: n = 3, one model family, cases written by the author of the change. Treat these as directional evidence, not as proof that the rules generalise.

## Not covered by this PR (follow-up)

Audit rows classed OUTPUT or PROCESS were left in their guides for a separate change:
- the `persistence-convention` conflict policy, frontmatter fields and error message (requirements, design, breakdown);
- the meaning of the `COMPLETE`/`PARTIAL`/`FAILED` status markers (four producer skills);
- the `save-spec` five verification commands and recipe stanza;
- `design`, which has 8 words of headroom.

Audit tables: `~/.hermes/cache/scratch/audit404/group-{A,B,C,D}.md` (scratch only, not committed).
