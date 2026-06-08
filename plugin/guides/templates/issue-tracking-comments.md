# Issue Tracking Comment Templates

Use these templates when an agent or developer works from a durable issue. The goal is to leave enough evidence for the next person to understand pickup, progress, and closure without replaying the whole session.

These are comment drafts, not automation. Post, label, close, or edit an issue only when the user or repo tracker contract explicitly allows it. If `docs/agents/issue-tracker.md` exists, follow that file first.

## When to Comment

- The issue will outlive the current session.
- The assignee or agent may change.
- The work changes scope, hits a blocker, or needs human input.
- The issue is being closed or marked ready with verification evidence.

Skip comments for same-session trivial fixes unless the user asks for issue tracking.

## Pickup Comment

```markdown
## Pickup

I am picking this up.

**Scope I understand:**
- <one or two bullets describing the intended outcome>

**Context checked:**
- <issue body / comments / linked PRD / ADR / relevant docs>

**Initial plan:**
1. <first action>
2. <second action>
3. <verification action>

**Current readiness:** `ready-for-agent` | `ready-for-human` | `needs-info`

I will comment again if scope changes, I hit a blocker, or I finish with verification evidence.
```

Use `ready-for-agent` only when success criteria, scope boundaries, and required context are clear enough to proceed without asking the filer.

## Progress or Blocker Comment

```markdown
## Progress Update

**What changed since pickup:**
- <short factual update>

**Evidence:**
- <command, test, doc, issue, PR, or source checked>

**Blocker / decision needed:**
- <specific question or decision, or "None">

**Next step:**
- <next concrete action>
```

Questions must be specific and actionable. Avoid "please provide more info" without naming exactly what is missing.

## Completion Comment

```markdown
## Completion

**What was fixed or delivered:**
- <behavioral summary, not implementation trivia>

**Evidence:**
- Commit: <hash or PR link, if available>
- Tests/checks: <commands run and result>
- Release/tag: <version or "not released", with reason>

**Residual risk / follow-up:**
- <remaining risk, follow-up issue, or "None known">

**Issue state recommendation:** close | keep open | needs-info | ready-for-human
```

For release work, include the version/tag only after it exists. Do not claim a release, deployment, or closure before verifying it from the tracker or release surface.

## Hard Boundaries

- Do not auto-close, auto-label, or auto-post without explicit approval or an issue-tracker contract that allows it.
- Do not paste secrets, tokens, private keys, customer-sensitive raw data, or private operational evidence.
- Do not include long logs. Link or summarize the relevant line instead.
- Do not make closure sound stronger than the evidence. If tests were not run, say so.
