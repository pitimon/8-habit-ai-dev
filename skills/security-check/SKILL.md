---
name: security-check
description: >
  Focused security review — secrets, injection, auth, dependencies, OWASP Top 10.
  Use as a dedicated security lens separate from general code review.
  Maps to H1 (Be Proactive — prevent security incidents, don't react to them).
user-invocable: true
argument-hint: "[files, directory, or git diff to check]"
allowed-tools: ["Read", "Glob", "Grep", "Bash"]
prev-skill: any
next-skill: any
---

# Security Check (ตรวจความปลอดภัย)

**Habit**: H1 — Be Proactive | **Anti-pattern**: Bundling security into general code review where it competes for attention

## Why a Separate Skill

Cognitive load research confirms: reviewing for 5 concerns simultaneously degrades all of them. Security deserves its own focused lens — the Security Champions model (Shopify, Atlassian) outperforms bundled review.

## Process

1. **Get the scope**: `git diff --name-only` or the files/directory specified.

2. **Auth & Access Control** (CRITICAL):
   - [ ] New endpoints require auth (unless explicitly public)
   - [ ] Access control uses role/permission checks, not just "is logged in"
   - [ ] No privilege escalation paths (user A accessing user B's data)
   - Verify: search for auth middleware and protect guards in changed files

3. **Secrets & Credentials** (CRITICAL):
   - [ ] No hardcoded keys, tokens, or credentials in source code
   - [ ] Secrets loaded from environment variables
   - [ ] No secrets in comments, logs, or error messages
   - Verify: use Grep tool to search for secret patterns in changed files

4. **Input Handling** (HIGH):
   - [ ] All user input validated (type, length, format)
   - [ ] Database queries use parameterized statements (no string interpolation)
   - [ ] HTML output escaped (XSS prevention)
   - [ ] File uploads validated (type, size, content)
   - Verify: search for innerHTML, dangerouslySetInnerHTML, exec(), eval()

5. **Data Protection** (HIGH):
   - [ ] Sensitive data not logged (credentials, PII)
   - [ ] API responses don't over-expose data (no SELECT \*)
   - [ ] Error messages don't leak internal details or stack traces
   - Verify: search for debug print statements in production code paths

6. **Infrastructure** (MEDIUM):
   - [ ] HTTPS enforced for external communication
   - [ ] CORS configured restrictively (not wildcard)
   - [ ] Rate limiting on auth endpoints
   - [ ] Content security policy headers configured

7. **Dependencies** (MEDIUM):
   - [ ] No known vulnerable dependencies (check lockfiles)
   - [ ] Dependencies pinned to specific versions
   - [ ] No unnecessary dependencies added

## Output

```
## Security Check Report
**Scope**: [files/directory reviewed]
**Verdict**: [CLEAR | WARNINGS | BLOCKED]

| #  | Severity | Category   | File:Line   | Finding          | Fix                   |
|----|----------|------------|-------------|------------------|-----------------------|
| 1  | CRITICAL | [category] | [path:line] | [what is wrong]  | [how to fix + verify] |

**CRITICAL**: [count] | **HIGH**: [count] | **MEDIUM**: [count]
**Action**: [specific next steps]
```

## When to Skip

- Pure documentation or markdown changes
- Changes to test files only (no production code)
- CI/CD config changes with no secret handling

## Definition of Done

- [ ] All 6 categories checked with verification commands run
- [ ] Zero CRITICAL findings remaining
- [ ] Each finding has a specific fix with verification method
- [ ] Verdict rendered (CLEAR/WARNINGS/BLOCKED)

Load `${CLAUDE_PLUGIN_ROOT}/habits/h1-be-proactive.md` for the full H1 principle and examples.
