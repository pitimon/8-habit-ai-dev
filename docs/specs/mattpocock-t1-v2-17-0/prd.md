---
feature: mattpocock-t1-v2-17-0
step: requirements
created: 2026-05-20T09:17:10+00:00
updated: 2026-05-20T09:17:10+00:00
source-skill-version: 2.16.5
research-brief: ~/.claude/plans/deep-https-github-com-mattpocock-skills-glimmering-prism.md
---

# PRD — External Prior-Art Bundle (T1) v2.17.0

## Feature: External Prior-Art Bundle (T1) — mattpocock/skills patterns into 8-habit-ai-dev

**What**: Ship 4 additive patterns from mattpocock/skills as a coherent v2.17.0 minor release: P1 AGENT-BRIEF template, P3 `disable-model-invocation` frontmatter flag, P4-lite `docs/out-of-scope/` catalog, P5 SKILL.md description rigor + validator check.

**Why**: External audit (2026-05-20 research brief) identified 4 patterns that fill real gaps in our discipline (durable issue specs, deterministic skill guarantee, decision-rationale preservation, dispatch-time skill discoverability) without breaching the read-only skill principle or the plugin boundary with `claude-governance`. All four are strictly additive and habit-mapped.

**Who**:

- Primary: plugin maintainer (pitimon) + future skill authors (per CONTRIBUTING.md)
- Secondary: skill consumers (Claude Code users + cross-agent users via AGENTS.md/RESOLVER.md)
- Tertiary: future contributors evaluating "should we add X" — served by `docs/out-of-scope/`

**In scope**:

- 2 SKILL.md frontmatter edits (`/save-spec`, `/ai-dev-log`) — add `disable-model-invocation: true`
- 1 new template (`guides/templates/agent-brief-template.md`)
- 1 new directory + 3 seed entries (`docs/out-of-scope/`)
- `tests/validate-structure.sh` updates (new field recognition + description rubric check)
- `/breakdown` handoff reference to AGENT-BRIEF template
- New ADR-014-external-prior-art-audit
- v2.17.0 version sync across 4 files (plugin.json, marketplace.json, README.md, SELF-CHECK.md)
- CONTRIBUTING.md link to `docs/out-of-scope/`

**Out of scope**:

- P2 LANGUAGE.md guide (deferred to Option B, separate brief)
- P8 two-axis review split (deferred to Option C, needs n≥2 adopter friction)
- P6 inline doc updates (rejected — conflicts with read-only skill principle, ADR-009)
- P7 CONTEXT.md / CONTEXT-MAP.md (rejected — overlaps `/save-spec` §1, risks governance drift)
- P9 lazy file creation (redundant — `/save-spec` already enforces via refusal-to-overwrite)
- Description audit _content_ changes — only the validator rubric is in scope; individual rewrites happen as natural maintenance

**Success criteria**:

1. All 4 validators (`validate-structure.sh`, `validate-content.sh`, `test-skill-graph.sh`, `test-verbosity-hook.sh`) pass on the v2.17.0 commit
2. `docs/out-of-scope/` has ≥3 entries, each ≤200 words, each citing an existing ADR (006/007/012)
3. ADR-014 exists with tier framework, 4 adoption decisions habit-mapped, and 3 rejection decisions explained
4. `tests/validate-structure.sh` Check 4 passes — version 2.17.0 synchronized across plugin.json / marketplace.json / README.md / SELF-CHECK.md
5. SELF-CHECK.md remains at or above 16/17 Pass after re-running `/cross-verify` on the v2.17.0 self-spec

**Definition of Done**:

- [ ] All EARS criteria below verified
- [ ] All 4 validator suites green in CI
- [ ] PR opened with conventional-commits title (`feat: external prior-art bundle (v2.17.0)`)
- [ ] `/reflect` invoked post-merge; lesson file created
- [ ] No regression in existing 19 skills' validation status

## EARS Acceptance Criteria

1. **[Event-driven] FR-001**: When `/save-spec` or `/ai-dev-log` is invoked at v2.17.0+, the SKILL.md frontmatter SHALL declare `disable-model-invocation: true`, signaling harness-aware platforms to suppress LLM improvisation in these deterministic scaffolders.

2. **[Event-driven] FR-002**: When `tests/validate-structure.sh` parses a SKILL.md frontmatter, it SHALL recognize `disable-model-invocation` as a valid boolean key (no false positives in the allowed-fields check).

3. **[Event-driven] FR-003**: When `tests/validate-structure.sh` runs the description-rubric check, it SHALL fail the build if any SKILL.md `description` field (a) exceeds 1024 characters OR (b) lacks at least one trigger phrase from the set `{Use when, Use AFTER, Use BEFORE, Use to, Use for}`.

4. **[Ubiquitous] FR-004**: The `docs/out-of-scope/` directory SHALL contain at least 3 markdown files at v2.17.0 release: `brainstorm-removed.md` (citing ADR-006), `agentskills-no-go.md` (citing ADR-007), `eu-ai-act-migrated.md` (citing ADR-012). Each entry SHALL be ≤200 words, behavioral (what we won't do) not procedural (how it would have worked), and end with `If reconsidering, read these conditions first:` + bullet list.

5. **[Ubiquitous] FR-005**: The file `guides/templates/agent-brief-template.md` SHALL exist and contain (a) a behavioral issue-spec scaffold mirroring `mattpocock/skills/triage/AGENT-BRIEF.md`, (b) explicit prohibition of file paths and line numbers (rationale: rot fast in backlog), (c) required sections for scope-in/scope-out, success criteria, and domain vocabulary, (d) ≤120 lines total.

6. **[Event-driven] FR-006**: When `/breakdown` emits a task list and any task is classified for backlog (will sit ≥7 days before pickup), the skill's handoff section SHALL link to `guides/templates/agent-brief-template.md` as the recommended issue-spec format.

7. **[Ubiquitous] FR-007**: A new ADR (`docs/adr/ADR-014-external-prior-art-audit.md`) SHALL document (a) the Tier 1/2/3 framework applied to the audit, (b) the 4 adopted patterns each with its habit mapping (H1/H2/H4/H5/H7), (c) the 3 rejected patterns (P6, P7, P9) with rationale referencing ADR-009 (read-only skill principle) and ADR-013 (spec-persistence boundary), (d) a citation to the research brief at `~/.claude/plans/deep-https-github-com-mattpocock-skills-glimmering-prism.md`.

8. **[Unwanted] FR-008**: If the v2.17.0 version bump misses any of the 4 sync files (plugin.json / marketplace.json / README.md badge+footer / SELF-CHECK.md header), then `tests/validate-structure.sh` Check 4 SHALL fail the build with the specific drifted file named in the error message.

## Risks

- **R1**: Claude Code harness may not honor `disable-model-invocation: true` for non-Anthropic plugins (mattpocock convention, not standard yet). _Mitigation_: ADR-014 documents observed behavior; FR-001 framed as "SHALL declare" not "SHALL be honored."
- **R2**: Description-rubric check (FR-003) may flag existing well-tuned descriptions if trigger phrases are missing. _Mitigation_: P5 manual sweep precedes FR-003 activation; rubric tuned during audit before validator enforcement.
- **R3**: `docs/out-of-scope/` may drift in granularity vs ADRs. _Mitigation_: FR-004 enforces "behavioral, not procedural" rule; CONTRIBUTING.md guidance distinguishes ADR ("we decided X") from OOS ("we deliberately won't do Y").

## Cross-References

- **Research brief**: `~/.claude/plans/deep-https-github-com-mattpocock-skills-glimmering-prism.md` (Deep mode, 13/14 sources verified)
- **Source repo audited**: <https://github.com/mattpocock/skills> (MIT, ~95.5k★)
- **Owning ADRs (existing)**: ADR-009 (read-only skill principle), ADR-013 (spec-persistence opt-in)
- **New ADR**: ADR-014-external-prior-art-audit (to be created in /design step)
- **Cross-verify result on this PRD chain**: 92.8% Well-prepared band (Q4 success criteria gap closed by this artifact)

<!-- SKILL_OUTPUT:requirements
ears_count: 8
ears_criteria:
  - "FR-001: When /save-spec or /ai-dev-log is invoked at v2.17.0+, SKILL.md frontmatter SHALL declare disable-model-invocation: true"
  - "FR-002: When validate-structure.sh parses frontmatter, it SHALL recognize disable-model-invocation as valid boolean key"
  - "FR-003: When validate-structure.sh runs description-rubric check, it SHALL fail build if description >1024 chars OR lacks trigger phrase"
  - "FR-004: docs/out-of-scope/ SHALL contain >=3 entries each <=200 words citing ADR-006/007/012"
  - "FR-005: guides/templates/agent-brief-template.md SHALL exist with behavioral scaffold mirroring mattpocock/skills"
  - "FR-006: When /breakdown emits backlog-bound tasks, handoff SHALL link to agent-brief-template.md"
  - "FR-007: New ADR-014-external-prior-art-audit SHALL document tier framework, 4 adoptions, 3 rejections, brief citation"
  - "FR-008: If v2.17.0 version bump misses any of 4 sync files, validate-structure.sh Check 4 SHALL fail with specific file named"
scope_in: "P1 AGENT-BRIEF template + P3 disable-model-invocation flag + P4-lite docs/out-of-scope/ catalog + P5 description rubric validator + ADR-014 + v2.17.0 version sync"
scope_out: "P2 LANGUAGE.md (Option B), P8 two-axis review (Option C, needs n>=2 adopter friction), P6 inline doc updates (rejected per ADR-009), P7 CONTEXT.md (rejected per ADR-013), P9 lazy file creation (redundant), description content rewrites"
primary_user: "plugin maintainer + future skill authors (CONTRIBUTING.md audience)"
risks:
  - "R1: Claude Code harness may not honor disable-model-invocation for non-Anthropic plugins"
  - "R2: Description-rubric check may flag existing well-tuned descriptions"
  - "R3: docs/out-of-scope/ may drift in granularity vs ADRs"
success_criteria_count: 5
END_SKILL_OUTPUT -->
