---
name: review-ai
description: >
  Audit AI-generated code for security, quality, and completeness.
  Use AFTER implementation, BEFORE commit. Step 5 of 7-step workflow. Maps to H4 (Think Win-Win).
user-invocable: true
argument-hint: "[files or git diff to review]"
allowed-tools: ["Read", "Glob", "Grep", "Bash"]
---

# Step 5: Review (อย่าไว้ใจทาง อย่าวางใจ AI)

**Habit**: H4 — Think Win-Win | **Anti-pattern**: Shipping AI-generated code without reading it

## Process

1. **Get the diff**: `git diff --name-only HEAD` to see what changed.

2. **Security check** (CRITICAL — block if found):
   - Hardcoded secrets (API keys, passwords, tokens)
   - SQL injection (string interpolation in queries)
   - Missing input validation on new endpoints
   - XSS vulnerabilities (unsanitized HTML output)

3. **Quality check** (HIGH):
   - Functions >50 lines → break down
   - Files >800 lines → extract
   - Nesting >4 levels → simplify
   - Missing error handling on external calls
   - `console.log` or `print()` in production code

4. **Completeness check** (MEDIUM):
   - Edge cases handled (null, empty, malformed input)
   - Tests written for new functions
   - Docs updated if API changed

5. **Give actionable feedback** — not just "fix this" but explain WHY and HOW:

   ```
   CRITICAL: Hardcoded API key at line 42
   → Move to environment variable: process.env.API_KEY
   → Why: Keys in code get committed to git history permanently
   ```

6. **H4 Checkpoint**: "Does this review help the developer (or AI) get better, not just point out flaws?"

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
| Completeness | [count]  | [highest] |
**Action required**: [specific next steps or "none — clear to commit"]
```

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

## Definition of Done

- [ ] All CRITICAL findings addressed (zero remaining)
- [ ] Verdict rendered using the 4-level table above
- [ ] Each finding includes actionable feedback (WHY + HOW to fix)
- [ ] Summary table shows findings count per category

Load `${CLAUDE_PLUGIN_ROOT}/habits/h4-win-win.md` for the full H4 principle and examples.
