# Skill catalog

The package contains 24 Markdown entries: eight workflow skills and 16 additional entries, including the EU AI Act redirect. Skill names here are identifiers, not commands. Use your [client guide](../README.md#quick-start) for its invocation syntax.

## Workflow skills

The product's seven delivery steps (1–7) follow research at Step 0. Implementation itself is performed by your coding agent between the brief and review, not by a self-executing skill.

| Skill | Step | Intended output |
| --- | --- | --- |
| `research` | 0 | Research brief, sources, constraints and open questions |
| `requirements` | 1 | Scope, acceptance criteria and definition of done |
| `design` | 2 | Architecture options and decisions for human judgment |
| `breakdown` | 3 | Ordered tasks and handoff boundaries |
| `build-brief` | 4 | Repository-grounded implementation context |
| `review-ai` | 5 | Findings, evidence gaps and review verdict |
| `deploy-guide` | 6 | Staging, deployment, rollback and verification plan |
| `monitor-setup` | 7 | Monitoring, alerts and health-check plan |

## Assessment, investigation and communication

| Skill | Use when | Intended output |
| --- | --- | --- |
| `cross-verify` | Assess readiness before a commitment or release | 17-question review, confidence and open gates |
| `whole-person-check` | Review discipline, vision, craft and conscience together | Body/Mind/Heart/Spirit assessment |
| `security-check` | Review a risk-bearing code or configuration change | Focused security findings |
| `consistency-check` | Reconcile requirements, design, tasks or incident evidence | Cross-artifact inconsistencies |
| `operational-state` | Decide how to handle an operational finding | Evidence-based classification and permitted next actions |
| `diagnose` | Investigate an unclear bug | Reproduction, hypotheses and a verified fix path |
| `post-mortem` | Document a validated fix | Root cause, mechanism, fix and validation record |
| `scrutinize` | Question a proposal before accepting its premise | Intent, trace and evidence review |
| `reflect` | Capture a completed-task lesson | Six-question retrospective and skill-effectiveness signal |
| `management-talk` | Brief a different audience | Channel-appropriate engineering update |
| `ai-dev-log` | Document AI-assisted development activity | History-derived development log |
| `save-spec` | Preserve project orientation in a new digest | SPEC.md scaffold; does not overwrite an existing digest |
| `workflow` | Walk through the development process | Guided skill selection and skip decisions |
| `calibrate` | Assess workflow maturity | Self-assessment; persistence depends on the runtime |
| `using-8-habits` | Choose a skill or learn the package | Onboarding and skill routing |
| `eu-ai-act-check` | Find the canonical EU AI Act mapping toolkit | Redirect to the separate claude-governance project |

## How to select and inspect a skill

Start with `requirements` before implementation and `review-ai` before committing. Add other skills for the risk and uncertainty of the task; the package does not require every step for every change.

For intent-based selection, read the [resolver](../skills/RESOLVER.md). The source of each entry is `skills/<name>/SKILL.md` under the [skills directory](../skills/). The [generated JSON catalog](data/skills.json) provides machine-readable metadata; it is not a runtime dispatcher.

The [expanded wiki reference](https://github.com/pitimon/8-habit-ai-dev/wiki/Skills-Reference) provides per-skill descriptions and workflow links. Runtime invocation and limitations belong in the client guides, not in this shared catalog.
