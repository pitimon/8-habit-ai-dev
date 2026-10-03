# Review Report Template

Output template for `/review-ai` (Step 5).

## Review Verdict: [PASS | CONCERNS | REWORK | FAIL]

**Summary**: [1-2 sentence overall assessment]

**Files reviewed**: [count] | **Findings**: [count]

## Findings

| #   | Severity | Category     | File:Line   | Finding        | Fix                |
| --- | -------- | ------------ | ----------- | -------------- | ------------------ |
| 1   | CRITICAL | Security     | [path:line] | [What's wrong] | [How to fix + WHY] |
| 2   | HIGH     | Quality      | [path:line] | [What's wrong] | [How to fix + WHY] |
| 3   | MEDIUM   | Completeness | [path:line] | [What's wrong] | [How to fix + WHY] |

## Summary by Category

| Category     | Findings | Highest Severity |
| ------------ | -------- | ---------------- |
| Security     | [count]  | [level]          |
| Quality      | [count]  | [level]          |
| Completeness | [count]  | [level]          |

## Dimension Balance

| Dimension           | Assessment    | Note              |
| ------------------- | ------------- | ----------------- |
| Body (Discipline)   | [strong/weak] | [1-line evidence] |
| Mind (Vision)       | [strong/weak] | [1-line evidence] |
| Heart (Passion)     | [strong/weak] | [1-line evidence] |
| Spirit (Conscience) | [strong/weak] | [1-line evidence] |

## Action Required

- [Specific next steps or "none — clear to commit"]

## Owner Note

**Owner note**: Changed: [what] | Why: [issue] | Roll back: [how] | Read first: [files] | Confirmed by: [merger or "unconfirmed"]

Write each field from repository artifacts (diff, tests, PR); mark unsupported fields `[not in artifacts]`. A missing, unconfirmed, or `[not in artifacts]` note caps the final verdict at CONCERNS.
