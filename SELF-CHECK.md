# Self-Check: 8-Habit Cross-Verification on This Plugin

**Version**: 2.10.0 | **Date**: 2026-04-16 | **Previous**: 2.8.0 (Body 5, Mind 5, Heart 5, Spirit 5 = 5.0)

Running our own 17-question checklist against the plugin itself. H8 Modeling: "Follow the process always, no shortcuts when unwatched."

## Private Victory (Self-Management)

| #   | Habit            | Dimension   | Question                                    | Result | Evidence                                                                                                                                                            |
| --- | ---------------- | ----------- | ------------------------------------------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | H1: Be Proactive | Body+Spirit | Checked what else this change affects?      | Pass   | Explore agent scanned all 17 skills, 8 habits before any edits. Gap analysis found 3 convention violations, version drift, missing CI                               |
| 2   | H1: Be Proactive | Body        | Considered edge cases?                      | Pass   | validate-structure.sh checks 5 edge cases: missing frontmatter, name mismatch, missing sections, version drift, file size. Previously: Fail (no validation existed) |
| 3   | H1: Be Proactive | Body        | Documentation updated as part of change?    | Pass   | CLAUDE.md, CONTRIBUTING.md, README.md, SELF-CHECK.md all updated alongside code changes                                                                             |
| 4   | H2: End in Mind  | Mind        | 3-5 concrete success criteria?              | Pass   | Every issue has Acceptance Criteria with 3-5 checkboxes. Verification section in plan has 6 specific criteria                                                       |
| 5   | H2: End in Mind  | Mind        | Test plan with verification steps?          | Pass   | `bash tests/validate-structure.sh` as concrete CI verification. Previously: Fail (no tests existed at all)                                                          |
| 6   | H2: End in Mind  | Mind        | Commit messages explain WHY?                | Pass   | Commits reference issue numbers, research basis, and dimension targets                                                                                              |
| 7   | H3: First Things | Mind        | Most important thing, not most interesting? | Pass   | Body (CI) was highest-impact gap, done first. NOT adding markdownlint (interesting but would add npm dependency)                                                    |
| 8   | H3: First Things | Heart       | Resisted scope creep?                       | Pass   | 6 issues for gap fixes, "NOT in scope" section explicitly excludes 4 items                                                                                          |

## Public Victory (Collaboration)

| #   | Habit          | Dimension | Question                               | Result | Evidence                                                                                                          |
| --- | -------------- | --------- | -------------------------------------- | ------ | ----------------------------------------------------------------------------------------------------------------- |
| 9   | H4: Win-Win    | Heart     | Issue closures include rationale?      | Pass   | Each issue maps to a gap finding with acceptance criteria. Commits use Closes #N with context                     |
| 10  | H4: Win-Win    | Heart     | Error messages help next developer?    | N/A    | Plugin is markdown guidance — no runtime error messages. validate-structure.sh has clear PASS/FAIL output         |
| 11  | H5: Understand | Mind      | Read existing code before writing new? | Pass   | All 17 SKILL.md, all 8 habit files, SELF-CHECK, CLAUDE.md read before plan was designed                           |
| 12  | H5: Understand | Mind      | Reproduced bug first?                  | Pass   | Whole Person Assessment reproduced the gap honestly (3.0/5). Exploration confirmed specific missing sections      |
| 13  | H6: Synergize  | Heart     | Independent tasks running in parallel? | Pass   | Phases 1-3 are independent (different files). Research used 3 parallel agents                                     |
| 14  | H6: Synergize  | Mind      | Considered third alternative?          | Pass   | markdownlint rejected (npm dep), Thai expansion deferred (quality concern), external validation deferred (future) |

## Renewal & Significance

| #   | Habit           | Dimension | Question                     | Result | Evidence                                                                                                                                                                   |
| --- | --------------- | --------- | ---------------------------- | ------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 15  | H7: Sharpen Saw | Body      | Captured what was learned?   | Pass   | validate-structure.sh automates convention checks. feedback memories saved (always PR, always issues first)                                                                |
| 16  | H8: Voice       | Spirit    | Understand WHY this matters? | Pass   | WHY: previous self-assessment was dishonest (4.5/5). Heart/Spirit gaps mean the plugin teaches empathy and ethics but doesn't demonstrate them. Fixing this is H8 Modeling |
| 17  | H8: Voice       | Spirit    | Empowers next person?        | Pass   | CI validates structure for contributors. Before/after examples teach concretely. CONTRIBUTING.md + CI = contributor-friendly                                               |

## Score

**Pass: 16/17** | **N/A: 1** | **Adjusted: 16/16 = 100%**

**Band**: Well-prepared

## Dimension Summary

| Dimension         | Questions | Pass | Score |
| ----------------- | --------- | ---- | ----- |
| Body (Discipline) | Q1,2,3,15 | 4/4  | 100%  |

| Mind (Vision) | Q4,5,6,7,11,12,14 | 7/7 | 100% |
| Heart (Passion) | Q8,9,10,13 | 3/3 (+1 N/A) | 100% |
| Spirit (Conscience) | Q1,16,17 | 3/3 | 100% |

## Honesty Notes

v2.7.0 improvements (Reader Adoption — closing the /calibrate feature loop):

- **Hook-based verbosity adaptation** (#96) — `hooks/session-start.sh` reads `~/.claude/habit-profile.md` and emits a level-specific one-sentence directive into session context. Claude honors the directive when invoking any skill. Writer (v2.6.0) + reader (v2.7.0) = complete #90 feature loop.
- **`guides/verbosity-adaptation.md`** — canonical per-level rules + worked examples across 5 skill archetypes. Zero changes to individual skills.
- **`tests/test-verbosity-hook.sh`** — 11 new regression assertions covering 8 hook branches + HABIT_QUIET silence + token budget. Wired into CI as 4th validator. Validators grow 470 → 481.
- **Architectural forcing**: pre-implementation F3 word-budget audit revealed 2 skills with single-digit headroom, ruling out any per-skill approach and forcing the hook-based design. Demonstrates H3 (First Things First) — constraint surfaced before design saved a rework cycle.
- **Milestone v2.7.0 — Reader Adoption: CLOSED 1/1.**

v2.6.1 improvements (Skill Effectiveness Tracking + CI hygiene):

- **`/reflect` Q6 skill-effectiveness signal** (#92) — 6th question added asking "most useful / least useful or confusing skill this session". Feeds maintainer trend review.
- **`SKILL-EFFECTIVENESS.md`** (new, repo root) — maintainer-curated trend tracker with per-skill tally for all 17 skills; ships empty, populated from `/reflect` Q6 over time. H7 applied to the plugin itself.
- **SIGPIPE CI fix** — `tests/validate-content.sh` F3 convention-consistency check switched from `sed|head -20` to pipe-safe awk after PR #99 first CI run flaked on Linux. Root cause: `skills/ai-dev-log/SKILL.md` has a body `---` horizontal rule at line 65 making sed emit 187 lines from a 239-line file, overflowing `head -20`. BSD sed on macOS ignored SIGPIPE; GNU sed on Linux with pipefail exit 4. Same awk pattern as `tests/validate-structure.sh:27`.
- **Milestone v2.6.0 — Hermes-Inspired Improvements: CLOSED 5/5** with this release.

v2.6.0 improvements (Hermes-Inspired Improvements — 4 issues, 2 ADRs):

- **Persistent reflection artifacts** (#88) — `/reflect` now writes `~/.claude/lessons/YYYY-MM-DD-<slug>.md`. `/research` and `/build-brief` retrieve lessons before starting work. Closes the learning loop.
- **Habit nudge guidance document** (#89) — `guides/habit-nudges.md` specifies nudge catalog + trigger + cooldown semantics; runtime hook implementation deferred to `pitimon/claude-governance` per plugin boundary.
- **User Maturity Calibration** (#90) — `/calibrate` skill + `~/.claude/habit-profile.md` (schema v1, YAML frontmatter) + `guides/habit-profile-schema.md` public contract + **ADR-008** (5 interlocking design decisions: Alt E hybrid, dominant-level scoring, YAML frontmatter schema, standalone chain position, user-driven re-calibration).
- **agentskills.io NO-GO** (#91) — Deep + Compare research brief + hands-on sandbox test + **ADR-007**. Key insight: "the reach of a standard is measured by what adopting tools *parse*, not by their logo list."
- Validators grew 443 → 470.

v2.5.0 improvements (Testing & Discoverability):

- **`tests/test-skill-graph.sh`** (#79) — DAG validator for `prev-skill`/`next-skill` chains. 55 assertions. Wired into CI.
- **`hooks/pre-commit.sh.example`** (#80) — opt-in pre-commit template running `/review-ai` on staged files.
- **Bidirectional wiki ↔ skills linking** (#81) — each workflow skill links to its wiki page; validator enforces both directions.
- Validators: 443 total; CI runs 3 scripts.

v2.4.1 improvements (Honest Correction, 2026-04-09):

- **Deleted `/brainstorm`** — shipped prematurely in v2.4.0 without reading `superpowers:brainstorming` source. Same-day correction.
- **`HABIT_QUIET=1` opt-out** for the session-start hook — audience-honest acknowledgment that not every user wants the 7-step workflow reminder every session.
- **Core 5 framing** — `/requirements`, `/review-ai`, `/cross-verify`, `/research`, `/reflect` named as the 80% of daily work; other 11 skills as optional depth.
- **ADR-006**: Audience Honesty + Superpowers Deferral — the "read the peer plugin source before claiming parity" lesson.
- Modeling H5 (Understand first) by correcting a v2.4.0 mistake within 24 hours instead of defending it.

v2.4.0 improvements (/using-8-habits meta-skill):

- **`/using-8-habits`** — onboarding meta-skill explaining the 7-step workflow and decision tree for "which skill next?" Reduces 16-skill overwhelm for new users.
- Validator check 18: meta-skill content assertions (references every skill by name, has decision tree, etc.).

v2.3.0 improvements (EU AI Act Compliance Toolkit — Flagship feature):

- **`/eu-ai-act-check`** — 9-obligation tiered checklist for EU high-risk AI systems (Articles 9-15). Pre-flight scope check skips if not high-risk or not EU-targeted.
- **`docs/research/eu-ai-act-obligations.md`** — verified-quote research brief.
- **`guides/eu-ai-act-mapping.md`** — MUST/SHOULD/COULD tier mapping.
- **`scripts/generate-ai-dev-log.sh`** — Article 11 transparency (AI-assisted dev log from git history).
- **ADR-005**: EU AI Act compliance toolkit scope + plugin-boundary decision (eventually migrating to `claude-governance`).
- Spirit dimension strengthened: compliance depth without enforcement theater.

v2.2.0 improvements (Body dimension level-up):

- **Content validation script**: `validate-content.sh` — 4 new check categories (section depth, markdown integrity, ADR format, handoff content)
- **Architecture fitness functions**: 3 tracked metrics — Skill Complexity Budget, Validation Coverage Ratio, Convention Consistency Score
- **Extended structure validation**: `allowed-tools` field validation, README ↔ skills cross-reference, agent definition checks
- **17 check categories, 215+ assertions** — up from 10/133 in v2.1.0
- **CI enforces both scripts** — fitness function breach fails the build
- **ADR-003**: Documents why bash content validation was chosen over npm linting or agent-driven validation
- **Body reaches Level 3**: Quality gates enforce standards automatically, fitness functions track architecture health

v2.1.0 improvements (Feynman-inspired multi-agent research):

- **Research depth levels**: `/research` now supports Quick/Standard/Deep — auto-detected from the argument or explicit keyword
- **Research modes**: General/Compare/Audit — comparison matrix and code-vs-docs audit output
- **`research-verifier` agent**: Source verification agent validates URLs, file paths, document references
- **Research brief template**: Structured output with optional comparison matrix, audit results, verification report
- **ADR-002**: Documents why modes integrate into `/research` rather than becoming separate skills

v2.0.0 improvements (ULW-inspired orchestration):

- **Orchestration classification**: `/breakdown` now classifies tasks as sequential/parallel-safe/parallel-worktree
- **Context boundaries**: `/build-brief` adds must-know/must-NOT-know/merge-contract per agent
- **Orchestration patterns guide**: 3-pattern catalog (Worktree Isolation, Context Boundaries, Meta-System Mindset)
- **Meta-system mindset**: H7 Rule 5 — "invest in the system that builds the system"
- **ADR-001**: First Architecture Decision Record — documents integrate-vs-new-skill decision
- **Inspiration**: UltraWorkers (ULW) multi-agent orchestration tools (OmC, OmX, clawhip)

v1.9.0 improvements (Feynman-inspired):

- **New skill**: `/research` (Step 0) — investigate before specifying requirements
- **Evidence grounding**: `/review-ai` now requires file:line evidence for every finding
- **Integrity principles**: 12 AI Integrity Commandments guide (Spirit dimension)
- **Confidence levels**: `/cross-verify` optional Verified/Inferred/Unverified marking
- **Lazy parallelism**: `/breakdown` + H6 gate — "Can I do this in ≤5 tool calls?"
- **Inspiration**: Feynman research agent patterns adapted for development workflow

The cross-verify score (16/16) measures **plan discipline**. The Whole Person score measures **plugin maturity**:

- v1.2.0: Body 2, Mind 4, Heart 3, Spirit 3 = **3.0** (inflated to 4.5 — dishonest)
- v1.6.0: Body 3, Mind 4, Heart 4, Spirit 4 = **3.75** (honest)
- v1.7.0: Body 4, Mind 4, Heart 5, Spirit 4 = **4.25**
- v1.8.0: Body 4, Mind 4, Heart 5, Spirit 4 = **4.25** (consolidated — discoverability, same scores)
- v1.9.0: Body 4, Mind 4.5, Heart 5, Spirit 4.5 = **4.5** (evidence grounding + integrity principles)
- v2.0.0: Body 4, Mind 5, Heart 5, Spirit 4.5 = **4.625** (orchestration patterns + meta-system mindset + ADR)
- v2.1.0: Body 4, Mind 5, Heart 5, Spirit 5 = **4.75** (research depth/modes + verification agent + evidence rigor)
- v2.2.0: Body 5, Mind 5, Heart 5, Spirit 5 = **5.0** (content validation + fitness functions + CI enforcement)
- v2.3.0: Body 5, Mind 5, Heart 5, Spirit 5 = **5.0** (EU AI Act compliance toolkit — Spirit depth, ADR-005)
- v2.4.0: Body 5, Mind 5, Heart 5, Spirit 5 = **5.0** (`/using-8-habits` meta-skill + decision tree)
- v2.4.1: Body 5, Mind 5, Heart 5, Spirit 5 = **5.0** (honest correction of /brainstorm ship-delete, HABIT_QUIET opt-out, ADR-006)
- v2.5.0: Body 5, Mind 5, Heart 5, Spirit 5 = **5.0** (DAG validator + pre-commit template + wiki↔skills linking, +55 assertions → 443)
- v2.6.0: Body 5, Mind 5, Heart 5, Spirit 5 = **5.0** (Hermes-inspired arc: #88 persistent reflection, #89 nudge spec, #90 /calibrate + ADR-008, #91 agentskills NO-GO + ADR-007 — 443 → 470 assertions)
- v2.6.1: Body 5, Mind 5, Heart 5, Spirit 5 = **5.0** (#92 /reflect Q6 + SKILL-EFFECTIVENESS.md, SIGPIPE CI fix — milestone v2.6.0 CLOSED 5/5)
- v2.7.0: Body 5, Mind 5, Heart 5, Spirit 5 = **5.0** (#96 hook-based reader adoption — closes #90 feature loop, 470 → 481 assertions, zero per-skill changes)
- v2.7.1: Body 5, Mind 5, Heart 5, Spirit 5 = **5.0** (#110 /review-ai Performance axis + review-tests-first — minimal post-milestone refinement; 5 of 6 agent-skills candidates rejected in cost/benefit audit, honoring v2.7.0 "local maximum" framing)
- v2.8.0: Body 5, Mind 5, Heart 5, Spirit 5 = **5.0** (Claude Code Architecture Insights: #113 /reflect consolidation, #114 /build-brief compression awareness, #115 /breakdown fork agent pattern, #116 /design sticky latches — 4 skills enhanced with production patterns from "Claude Code from Source" analysis)

---

_Updated with each release. Previous: 2.7.1 (Body 5, Mind 5, Heart 5, Spirit 5 = 5.0)_
