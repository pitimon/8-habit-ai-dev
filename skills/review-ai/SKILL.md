---
name: review-ai
description: >
  Audit AI-generated code for security, quality, and completeness.
  Use AFTER implementation, BEFORE commit. Step 5 of 7-step workflow. Maps to H4 (Think Win-Win).
user-invocable: true
argument-hint: "[files or git diff to review]"
allowed-tools: ["Read", "Glob", "Grep", "Bash"]
prev-skill: build-brief
next-skill: deploy-guide
---

# Step 5: Review (อย่าไว้ใจทาง อย่าวางใจ AI)

**Habit**: H4 — Think Win-Win | **Anti-pattern**: Shipping AI-generated code without reading it

## Process

1. **Get the diff**: `git diff --name-only HEAD` to see what changed.

2. **Read the tests first** — before judging the implementation, open the new or changed test files. Tests declare the _intended_ behavior; reading them first gives you the specification to review the code against. If new logic has no corresponding test, record that as a Completeness finding in step 6.

3. **Security check** (CRITICAL — block if found):
   - Hardcoded secrets (API keys, passwords, tokens)
   - SQL injection (string interpolation in queries)
   - Missing input validation on new endpoints
   - XSS vulnerabilities (unsanitized HTML output)

4. **Quality check** (HIGH):
   - Functions >50 lines → break down
   - Files >800 lines → extract
   - Nesting >4 levels → simplify
   - Missing error handling on external calls
   - `console.log` or `print()` in production code

5. **Performance check** (HIGH):
   - N+1 queries, unbounded loops, or sync blocking in hot paths
   - Missing pagination on list endpoints
   - Unindexed queries on large tables
   - Memory leaks (unclosed streams, unbounded caches, retained references)

   Performance findings follow the same evidence standard as the other axes: cite `file:line` with the measured or obvious-on-inspection cost.

6. **Completeness check** (MEDIUM):
   - Edge cases handled (null, empty, malformed input)
   - Tests written for new functions (cross-check with step 2)
   - Docs updated if API changed

7. **Give actionable feedback** — not just "fix this" but explain WHY and HOW:

   ```
   CRITICAL: Hardcoded API key at line 42
   → Move to environment variable: process.env.API_KEY
   → Why: Keys in code get committed to git history permanently
   ```

8. **Evidence Requirements** (Feynman principle: "line number or it didn't happen"):

   Every finding MUST include specific evidence — no "you should consider..." without pointing to code:
   - **Security**: Exact `file:line` where vulnerability exists
   - **Quality**: Specific function name and line count (e.g., `processOrder() at api.ts:142 — 73 lines`)
   - **Performance**: `file:line` plus the cost (query count, loop bound, or order-of-magnitude estimate)
   - **Completeness**: Missing test file path or untested function name

   Unsupported findings are not findings — they are opinions. Drop or substantiate.

9. **H4 Checkpoint**: "Does this review help the developer (or AI) get better, not just point out flaws?"

## Handoff

- **Expects from predecessor** (`/build-brief`): Implemented code with context brief
- **Produces for successor** (`/deploy-guide`): Review verdict (PASS/CONCERNS/REWORK/FAIL) with findings resolved

## Verdict (Required Output)

Every review MUST end with a structured verdict — not free-form prose.

| Level | Label        | Criteria                                   | Action                               |
| ----- | ------------ | ------------------------------------------ | ------------------------------------ |
| 0     | **PASS**     | No findings, or all informational          | Proceed to commit                    |
| 1     | **CONCERNS** | Non-blocking issues found                  | Merge allowed, author should address |
| 2     | **REWORK**   | Significant quality or completeness issues | Must fix before merge                |
| 3     | **FAIL**     | Security vulnerability or breaking change  | Cannot merge, immediate fix required |

Output format:

```
## Review Verdict: [PASS|CONCERNS|REWORK|FAIL]
**Summary**: [1-2 sentence overall assessment]
| Category     | Findings | Severity |
|--------------|----------|----------|
| Security     | [count]  | [highest] |
| Quality      | [count]  | [highest] |
| Performance  | [count]  | [highest] |
| Completeness | [count]  | [highest] |
**Action required**: [specific next steps or "none — clear to commit"]
```

## Deep Review Mode (Optional)

For thorough reviews, delegate to the `8-habit-reviewer` agent for a second perspective. Trigger when:

- User explicitly requests deep/thorough review
- Initial review verdict is CONCERNS or REWORK
- Change touches >5 files or crosses architectural boundaries

To invoke: Use the Agent tool with `subagent_type: "8-habit-ai-dev:8-habit-reviewer"` passing the files or diff to review. The agent evaluates against all 8 habits and produces a scored report (X/17).

The skill checks **code quality**; the agent checks **habit alignment**. Together they catch what either would miss alone.

## Dimension Balance Check

After rendering the verdict, assess the review through the Whole Person lens. Flag imbalances:

| Dimension | What to Check                                                       | Common AI Blind Spot                          |
| --------- | ------------------------------------------------------------------- | --------------------------------------------- |
| Body      | Tests exist? CI passes? Monitoring configured?                      | AI generates tests well — usually strong      |
| Mind      | Architecture sound? Design documented? Trade-offs considered?       | AI excels here — usually strong               |
| Heart     | Error messages empathetic? Code readable? UX considered?            | AI follows patterns but lacks genuine empathy |
| Spirit    | Security reviewed? Ethical impact considered? Should we build this? | AI checks lists but doesn't question purpose  |

If Heart or Spirit scores lag Body/Mind by ≥2 categories, add:

```
⚠️ Dimension imbalance: [Mind: strong, Spirit: weak]
→ Consider: [specific action to address the gap]
```

## Sequence Rule

**Write → Review → Commit** (NEVER reverse. "Small change" is not an excuse to skip.)

## Verification Phase (guidance only — NOT a hook)

> **Plugin boundary**: This phase is SKILL.md prose guidance for Claude (the AI) — it is NOT a `git commit` hook, NOT a PreToolUse gate, NOT automated enforcement. Hook-based "block commit" enforcement belongs in `claude-governance`, not here. If a contributor proposes implementing this phase as a hook, close it as wrong-plugin and re-file in `pitimon/claude-governance` (cf. boundary corrections in issues #58, #60).

After producing findings, do not stop at the verdict. Run a **Find → Fix → Re-Verify** loop for every CRITICAL/HIGH finding before declaring the review complete:

1. **List** each CRITICAL and HIGH finding from the verdict table
2. **Apply fix** — edit the offending file(s) per the actionable feedback
3. **Re-run review on the same scope** — re-Read the changed lines, re-grep for the original pattern, confirm the issue is gone
4. **Cite evidence-of-fix per finding** — `file:line` showing the fix is now in place (with before/after snippets where helpful), OR explicit `deferred — tracked as #N` with the issue number
5. **Refuse to emit `SKILL_OUTPUT:review` with `pass: true`** unless all CRITICAL findings are closed. HIGH findings may be deferred only with an issue ref. Refusal is in prose: state `"review cannot pass — N CRITICAL finding(s) remain open"` and stop. This is guidance to Claude, not a runtime gate.

**Output**: end the review report with a Verification Table replacing the prior flat finding list:

| Finding       | Severity | Fix Evidence                                                     | Status   |
| ------------- | -------- | ---------------------------------------------------------------- | -------- |
| `[summary 1]` | CRITICAL | `path/to/file.ts:42` (was: insecure default, now: parameterized) | RESOLVED |
| `[summary 2]` | HIGH     | deferred — tracked as `#NNN`                                     | DEFERRED |
| `[summary 3]` | CRITICAL | re-grep shows pattern absent in scope                            | RESOLVED |

**Why this exists** (H1 + H7): findings without verification become backlog instead of a gate. The loop forces the proactive fix (H1) and invests in capability rather than just output (H7) — every cited fix evidence is a learned pattern for the next review.

**Evidence Standard alignment** (v2.12.0): code-symbol verdicts in fix evidence (e.g. "removed unused dep") still need grep-check liveness evidence per the Research skill's Evidence Standard. Don't claim "removed and safe" without proof of zero consumers.

## When to Skip

- Auto-generated formatting changes (lint --fix, prettier — no logic change)
- Dependency version bumps with passing CI and no API changes
- Reverting a commit to its exact previous state

## Definition of Done

- [ ] All CRITICAL findings addressed (zero remaining) — proven in the Verification Table, not just claimed
- [ ] Verdict rendered using the 4-level table above
- [ ] Each finding includes actionable feedback (WHY + HOW to fix)
- [ ] Every finding cites specific evidence (file:line, test output, or diff)
- [ ] Summary table shows findings count for all four categories (Security, Quality, Performance, Completeness)
- [ ] Verification Phase complete — Verification Table at end shows fix evidence per finding (RESOLVED with `file:line`, or DEFERRED with issue ref)

## Structured Output Block

After rendering the review verdict, append a structured output block for cross-skill handoff. This HTML comment is invisible when rendered but enables `/cross-verify` to auto-check review coverage:

```
[/review-ai] COMPLETE SKILL_OUTPUT:review
<!-- SKILL_OUTPUT:review
files_reviewed: [N]
findings_critical: [N]
findings_high: [N]
findings_medium: [N]
findings_low: [N]
pass: [true|false]
test_coverage_checked: [true|false]
security_checked: [true|false]
END_SKILL_OUTPUT -->
```

Place this at the very end of the review report, after all human-readable content.

## Further Reading

See [Step 5 wiki page](../../docs/wiki/Step-5-Review-AI.md) for deeper walkthrough, examples, and common pitfalls.

**If `superpowers` is installed**: `superpowers:requesting-code-review` dispatches a multi-agent review with structured feedback. Use it for large PRs or cross-cutting changes. `/review-ai` is lighter-weight — best for single-file or focused reviews before commit.

Load `${CLAUDE_PLUGIN_ROOT}/guides/templates/review-report-template.md` for the output template.
Load `${CLAUDE_PLUGIN_ROOT}/habits/h4-win-win.md` for the full H4 principle and examples.
Load `${CLAUDE_PLUGIN_ROOT}/guides/integrity-principles.md` for evidence standards (the 12 commandments).
Load `${CLAUDE_PLUGIN_ROOT}/guides/structured-output-protocol.md` for the structured output block format specification.
