# `/save-spec` — Reference

Canonical artifacts and rationale for `skills/save-spec/SKILL.md`. The SKILL.md Process steps reference this file for verbatim strings (refusal message, error template, skip-sentinels, glob list, template body).

## SPEC.md output template

This is the file body that step 5 of the Process assembles. Substitution markers are in angle brackets (e.g. `<project-name>`). Bracket-content is replaced; literal angle brackets in the placeholders themselves are preserved as Markdown text (they are HTML-escaped by the renderer).

```markdown
# SPEC.md — <project-name> save point

Single-page reference. Read this first when starting a new session.

> **Rule** (per `CLAUDE.md`): every completed task updates §4 (Current state) and §3 (Backlog). Never claim "done" without updating this file.

---

## 1. Architecture (pointer)

<!-- TODO: one paragraph summarizing what this system is + where it runs -->

<§1-bullets — one bullet per confirmed pointer-target file. Empty set → single template-stub bullet from the empty-set example below.>

## 2. Decisions snapshot (pointer)

The N most load-bearing decisions. Each row = one line + canonical source. Keep ≤ 10 rows — if it grows, prune to the most active.

| #   | Decision | Why | Source |
| --- | -------- | --- | ------ |

<§2-rows — one row per parsed decision. Empty set → single template-stub row.>

Per-event history: `CHANGELOG.md`. Root-cause post-mortems: `LESSONS.md`.

## 3. Live backlog

**The only place backlog is maintained.** Stale items are deleted from day 1 — once a §3 item is captured in a changelog entry, ADR, or the §2 decisions snapshot, **delete** it from the backlog the same day.

<§3-bullets — one [ ] bullet per parsed item. Empty set → single [ ] template-stub bullet.>

## 4. Current state — save point

**Read this section first after `/clear` or `/compact`.**

> **Last updated**: <RFC 3339 timestamp with local timezone offset, e.g. 2026-05-17T20:44:23+07:00>
> **Last apply / commit / deploy event**: <!-- TODO: terse note + timestamp of last apply/deploy/commit event -->

### What's happening now

<!-- TODO: specific task/sub-task active right now, with file paths and progress -->

### Stuck / waiting on

nothing

### Next session entry point

\`\`\`bash
cd <repo-root>
cat SPEC.md # this file

# then inspect §4 above for "what changed last"

\`\`\`

<!-- Optional: command sequence to resume the in-flight work, e.g. health check + next step -->
```

### Template-stub rows for empty sets

When the user skips §1 / §2 / §3 seeding, the corresponding section gets a single stub:

- **§1 empty stub** (one bullet):

  ```markdown
  - _§1 is empty — add project-specific pointers (one path per bullet) as the repo grows._
  ```

  > **N1 fix (v2.16.1, [#201](https://github.com/pitimon/8-habit-ai-dev/issues/201))**: the previous stub used `` `<filename>.md` `` which Check 4's backtick-path grep extracted as `<filename>.md` (literal angle brackets), failing `[ -e ]` and emitting `MISS  <filename>.md`. The Definition of Done's claim that "output passes the 5 verification commands" was provably false on the default scaffold. The stub above uses plain prose with no backticked `.md` path, so Check 4 finds no candidate paths to resolve and exits cleanly.

- **§2 empty stub** (one row):

  ```markdown
  | D1 | _no decisions seeded yet — add the first one when it lands_ | — | — |
  ```

- **§3 empty stub** (one bullet):

  ```markdown
  - [ ] _no backlog items yet — add the first when surfaced_
  ```

  > **F1 fix (v2.16.2, [#203](https://github.com/pitimon/8-habit-ai-dev/issues/203))**: §1 narrative + §2 + §3 + §4 placeholder sites previously used literal angle-bracket markers like `<terse statement>` and `<Active backlog item — …>`. Adopter #3 dogfood report showed these shipped unfilled in the scaffolded output, contradicting the read-first-context purpose (a reader picking up the file cold couldn't distinguish defaults-to-keep from placeholder-must-fill). Hybrid fix: §2/§3 skip-stubs now use plain prose self-describing italic markers (`_no decisions seeded yet — add …_`); §1 narrative + §4 fill-required sites use `<!-- TODO: … -->` HTML comments (invisible at render, visible to editor — signals "TODO" without polluting the rendered page). The §4 "Optional: command sequence …" line is also now an HTML comment.

## Canonical refusal message (Decision-3)

Used by Process step 1 when `SPEC.md` already exists at the project root. Substitute `<absolute-path>` with the real path. Print verbatim — `tests/validate-structure.sh` pins the literal first-line phrase `SPEC.md already exists at`.

```
SPEC.md already exists at <absolute-path>.

Phase 1 of /save-spec is generator-only — it deliberately refuses to overwrite an
existing file. To update SPEC.md:

  1. Edit it directly. The CLAUDE.md auto-update recipe (from
     guides/spec-digest-pattern.md) handles ongoing updates without re-invoking
     this skill.
  2. Wait for the Phase 2 --update flag, which will refresh §4 (Current state)
     in place. Tracked in the project-orientation discussion.

No changes were made.
```

## Canonical Write-failure error template (Decision-4)

Used by Process step 6 when the `Write` tool fails. Three substitutions. Print verbatim — `tests/validate-structure.sh` pins the literal first-line phrase `Tried to create SPEC.md at`.

```
Tried to create SPEC.md at <absolute-path>.

Failed: <error-class> — <error-message>.

Next: <suggested-action>. Typical fixes are: check write permissions on the
parent directory (chmod / ls -la), confirm the working directory is the
intended project root (pwd), or change to a writable directory and re-run
/save-spec.
```

Substitution semantics:

- `<absolute-path>` — full path that failed (same value as in step 6 above)
- `<error-class>` — POSIX error class (e.g. `EACCES`, `ENOSPC`, `EROFS`)
- `<error-message>` — the underlying error string surfaced by the `Write` tool
- `<suggested-action>` — context-specific hint (one short imperative sentence; the `Typical fixes` line follows always)

## Skip-sentinels (Decision-2)

Process step 4 treats any of the following as **skip** for §2 and §3 free-text input. Match is case-insensitive after leading-whitespace trim:

Skip-sentinels:

1. The literal `AskUserQuestion` option `skip` (one-click affordance)
2. Free-text starting with `skip`
3. Free-text starting with `none`
4. Free-text starting with `nothing`
5. Free-text starting with `n/a`
6. Empty string or whitespace-only string

Any other free-text is treated as a list of items: split on `,` or `;`, trim each piece, take the first ≤ 3 non-empty items.

## Glob filename set (Decision-6)

Process step 2 globs the project root for exactly these 5 filenames (case-sensitive, exact-stem-and-extension match):

- `PLAYBOOK.md`
- `CONTRACTS.md`
- `LESSONS.md`
- `CHANGELOG.md`
- `README.md`

Implementation flexibility: one `Glob` call per name, or one call with brace-expansion pattern (`{PLAYBOOK,CONTRACTS,LESSONS,CHANGELOG,README}.md`) if the tool supports it. The 5-name set IS the contract; the call mechanics are not.

Non-canonical naming (e.g. `Readme.md`, `playbook.md`, project-specific names like `RUNBOOK.md`) is intentionally **not** auto-detected. Users can edit §1 after the skill writes — the file is theirs.

## Timestamp format (Decision-5)

Process step 5 uses RFC 3339 strict variant for the `**Last updated**` line in §4: local time + colon-separated timezone offset.

Example: `2026-05-17T20:44:23+07:00`

POSIX `date` recipe (the skill itself does not invoke Bash — this is for reference): `date +"%Y-%m-%dT%H:%M:%S%:z"` (Linux); `date +"%Y-%m-%dT%H:%M:%S%z" | sed -E 's/([+-][0-9]{2})([0-9]{2})$/\1:\2/'` (macOS BSD fallback). The skill substitutes the current time at the moment of Process step 5 execution.

Rationale: humans reading their own save-point file see their own time; the offset preserves auditability. The canonical record (CHANGELOG / git log) is the source of truth for global ordering — §4's timestamp is the session-resume hint, not the audit log.

### N2 timestamp limitation (v2.16.1, [#201](https://github.com/pitimon/8-habit-ai-dev/issues/201))

The skill's `allowed-tools` array does NOT include `Bash` — Process step 5 cannot invoke `date(1)` to obtain an authoritative current-time-with-offset string. The timestamp value is instead substituted by Claude using its session-injected current-time context (typically the `<system-reminder>Current: <date> <time> <timezone></system-reminder>` block that Claude Code injects at session start).

**Reliability profile**:

- ✅ When the session has a `<system-reminder>` providing current local time + timezone (the default Claude Code behavior), the substituted timestamp will match the user's local time with the correct offset. **Verified working in v2.16.1 Adopter #3 dogfood** (issue [#203](https://github.com/pitimon/8-habit-ai-dev/issues/203) W2 — fresh-session scaffold in `~/va+pentest` produced `2026-05-17T22:46:06+07:00`, correct Bangkok offset).
- ⚠️ When that injection is absent (custom runtime, non-interactive batch, certain MCP-only contexts), Claude may fall back to a default offset — most likely `+00:00` (UTC) — or, in degenerate cases, a hallucinated offset. The skill cannot detect this failure mode at scaffold time. **This is the documented escape-hatch, not the expected outcome in normal use.**

**Adopter guidance**: after running `/save-spec`, glance at the `**Last updated**` line in §4. If the offset doesn't match your local timezone, edit it manually with the correct value. This is a one-time fix on the freshly scaffolded file — subsequent §4 updates are driven by the CLAUDE.md auto-update recipe (which is also Claude-generated and inherits the same reliability profile).

**Phase 2 consideration**: if adopter feedback shows the LLM-clock substitution is unreliable in practice, Phase 2 may add `Bash` to `allowed-tools` (with a narrowly scoped matcher) and invoke `date +%Y-%m-%dT%H:%M:%S%z` directly. That would require a Decision-10 validator update to allow `Bash` in the pinned array. Not in scope for Phase 1.

The POSIX `date` recipe documented above remains "for reference" — useful when an adopter is correcting a wrong-offset substitution by hand.

## Parse examples (Decision-9)

How free-text user input from Process step 3 → Q3 / Q4 turns into §2 rows or §3 bullets after step 4 parsing.

### Example A — All skip

User input to Q3 and Q4: `skip` (option click)

Result:

- §2: single empty-stub row
- §3: single empty-stub bullet

### Example B — One §2 decision, no §3 items

User input to Q3: `IP address = idempotency key. Vendor names collide.` (provided)
User input to Q4: `none` (skip-sentinel)

Result:

- §2: one row → `| D1 | IP address = idempotency key | Vendor names collide | <file>:<line> |` (placeholder source — user fills in later)
- §3: single empty-stub bullet

### Example C — Three §2 decisions, two §3 items (max-list case)

User input to Q3: `D1: ip-as-key, vendor-collide, see promote.py; D2: dry-run-default, reversibility-cost, see promote.py; D3: hard-fail-REQUIRES_HUMAN_INPUT, signature-theater-prevent, see promote.py`

Parsing: split on `;` → 3 items. Each item further parsed loosely as "decision : statement, rationale, source" if it contains `:` and 3 comma-separated fields, otherwise the whole string becomes the statement.

User input to Q4: `120 SIT-DC apply-blocked records, Phase 3 SNMP enrichment`

Parsing: split on `,` → 2 items. Trim. Each becomes a `[ ]` bullet.

Result:

- §2: three rows, D1/D2/D3 populated (with user's loose parsing where the colon convention was hit)
- §3: two `[ ]` bullets

### Example D — Surplus items truncated

User input to Q3: `a, b, c, d, e` (five items)

Result:

- §2: three rows (D1=a, D2=b, D3=c). Items `d` and `e` silently dropped. The Process step 4 rule caps at 3 — surplus is not an error.

### Example E — Whitespace / mixed delimiters

User input to Q3: ` foo  ;  bar , baz`

Parsing: split on `,` or `;` → `["  foo  ", "  bar ", " baz "]`. Trim → `["foo", "bar", "baz"]`. Take first 3 → all 3.

Result: §2 = 3 rows, content `foo`, `bar`, `baz`.

### Example F — Q2 non-canonical pointer paths via "Other" (v2.16.1, N3)

User input to Q2: multi-select picks `README.md` (canonical match from glob), AND "Other" free-text:

```
netbird-sit/server-state.md
netbird-sit/playbooks/change-management.md
netbird-sit/runbooks/ops-runbook.md
```

Parsing: multi-select list = `["README.md"]`. Other free-text split on newlines, trimmed, non-empty → 3 entries. Deduplicate against multi-select picks (no overlap with `README.md`). Final §1 set = `["README.md", "netbird-sit/server-state.md", "netbird-sit/playbooks/change-management.md", "netbird-sit/runbooks/ops-runbook.md"]`.

Result: §1 = 4 bullets (one path per bullet). The skill does NOT validate that the Other paths exist on disk — Phase 1 cannot Bash. Adopters supplying nonexistent paths get bullets pointing at paths that fail Check 4 verification; the skill writes what was asked.

## Rationale links to issue #199 open-question defaults

The Phase 1 design accepted these 6 open-question defaults from the design-discussion issue (https://github.com/pitimon/8-habit-ai-dev/issues/199):

| Q   | Default                                                       | Implemented by                                   |
| --- | ------------------------------------------------------------- | ------------------------------------------------ |
| Q1  | refuse-on-existing for Phase 1                                | Process step 1 + canonical refusal message above |
| Q2  | hybrid glob + user confirm                                    | Process step 2 + step 3 Q2                       |
| Q3  | ask user for §2 decisions with empty stub default             | Process step 3 Q3 + skip-sentinels               |
| Q4  | emit CLAUDE.md stanza to conversation only                    | Process step 7 + FR-014/FR-015                   |
| Q5  | `skills/save-spec/SKILL.md` + `skills/save-spec/reference.md` | This file pair                                   |
| Q6  | three RESOLVER trigger phrases                                | `skills/RESOLVER.md` (added separately in T4)    |

Phase 2 extensions (deferred — not in scope for v2.16.0):

- `--update` flag for §4 refresh-in-place
- ADR-013 ingestion for §2 auto-population
- Batch / non-interactive mode
