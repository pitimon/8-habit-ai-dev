---
date: 2026-06-27
originating-decision: "ADR-026 external prior-art audit (karpathy-skills + gstack), prompted by a viral post promoting 5 agent-skills repos"
rejected-because: gstack's role *concepts* (CEO/Eng-Mgr/Staff/QA/Release/CSO/Tech-Writer) are already native to existing skills; its genuine differentiator is persona-framing + sequential auto-pipeline orchestration, which is a multi-agent engine — `claude-governance`'s domain, not this plugin's single-human workflow discipline (CLAUDE.md plugin-boundary rule-of-thumb)
---

# We don't ship gstack's persona pipeline — role concepts already native, orchestration is out of charter

`garrytan/gstack` (23 core skills + 8 power tools, ~110k★; <https://github.com/garrytan/gstack>) gives
the agent distinct **persona roles**, each behind a slash command, wired into a sequential pipeline
(Think → Plan → Build → Review → Test → Ship → Reflect) that runs autonomously with human approval gates.
A viral post asked how this should improve `8-habit-ai-dev`. After a primary-source audit
([ADR-026](../adr/ADR-026-external-prior-art-audit-karpathy-gstack.md)): **mostly the role concepts already
exist; the part that doesn't belong here belongs in `claude-governance`.**

## What we already have (role concepts are native)

| gstack role / skill                                | Already in this plugin                                                        |
| -------------------------------------------------- | ----------------------------------------------------------------------------- |
| CEO / `/office-hours` ("find the 10-star product") | `/scrutinize` — questions whether the change should exist before line-by-line |
| Eng Manager / `/plan-eng-review`                   | `/design` + `/breakdown`                                                      |
| Staff Engineer / `/review` + QA Lead / `/qa`       | `/review-ai` + `8-habit-reviewer` agent                                       |
| Release Engineer / `/ship`, `/land-and-deploy`     | `/deploy-guide` (staging-first, rollback ready)                               |
| Chief Security Officer / `/cso` (OWASP + STRIDE)   | `/security-check`                                                             |
| Technical Writer / `/document-*`                   | `/management-talk` (partial — audience reshape)                               |

The 7-step workflow already _is_ a Think→Plan→Build→Review→Ship→Reflect spine
(`/research`→`/requirements`→`/design`→`/breakdown`→`/build-brief`→`/review-ai`→`/deploy-guide`→`/monitor-setup`,
closed by `/reflect`). gstack's contribution is the **persona costume + autonomous orchestration**, not the steps.

## What we reject and why

The differentiator — wrapping each step in a named persona and chaining them into an **autonomous
multi-step pipeline** — is an _orchestration engine_, not workflow _discipline_. Per the CLAUDE.md
plugin-boundary rule-of-thumb:

> "workflow step or discipline practice → here. Runtime hook, compliance framework mapping, enforcement
> gate, or formal decision-authorization model → `claude-governance`." (`CLAUDE.md:54`, verbatim)

Persona-pipeline orchestration (sequential auto-run, role hand-offs, approval-gate sequencing) is a
**runtime + decision-authorization** mechanism — squarely the governance plugin's domain. Shipping it here would duplicate that surface and erode the boundary that
[ADR-005](../adr/ADR-005-eu-ai-act-compliance-toolkit.md) / [ADR-019](../adr/ADR-019-doctrine-only-scope-refinement.md)
protect. We also do **not** ship role/persona agents (PM/QA/Designer) for the same reason — our two agents
(`8-habit-reviewer`, `research-verifier`) are read-only reviewers, not autonomous role personas.

> Boundary basis is the verbatim **CLAUDE.md:54 rule-of-thumb**.
> [ADR-021](../adr/ADR-021-dynamic-workflow-positioning.md) is cited only as _consistent precedent_ for
> the routing move (it used the same rule for the Opus dynamic-workflow engine, `ADR-021:34`), not as the
> controlling decision — gstack is a bag of persona prompt-skills, so the general rule controls here.

## Re-entry conditions

Reconsider only if **either** trigger fires:

1. **Boundary shift** — `claude-governance` declines to own persona-pipeline orchestration AND a
   first-person friction signal shows the 7-step spine is insufficient without explicit role framing.
2. **Capability gap** — a specific gstack role surfaces a capability that has _no_ mapping in the table
   above (a genuinely new discipline, not a renamed existing one).

Until then: the role concepts are mapped onto existing skills, and the persona-pipeline orchestration is
out of scope (→ `claude-governance`).
