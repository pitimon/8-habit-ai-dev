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

## Sequence Rule

**Write → Review → Commit** (NEVER reverse. "Small change" is not an excuse to skip.)

Load `${CLAUDE_PLUGIN_ROOT}/habits/h4-win-win.md` for the full H4 principle and examples.
