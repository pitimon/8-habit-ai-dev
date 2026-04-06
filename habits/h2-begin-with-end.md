# Habit 2: Begin with the End in Mind

**Define "done" before writing a single line of code.**

AI coding assistants will eagerly start generating code the moment you describe a feature. That speed is a trap if you haven't defined what success looks like. Without clear acceptance criteria, you'll iterate endlessly — not because the AI is bad, but because you never specified the target.

## The Principle

Every meaningful task needs a Definition of Done that is specific enough to verify. "It works" is not a definition. "The API returns 200 with valid JSON, handles missing fields with 400, and rejects unauthenticated requests with 401" — that's a definition.

The best acceptance criteria are **grep-checkable** — you can search the codebase to verify they're met.

## Rules

**1. Plan files MUST have "Success Criteria" and "Definition of Done".**

Before any multi-file change, write down what success looks like. Not a vague description — concrete, verifiable statements:

```markdown
## Success Criteria

- [ ] GET /api/search returns results sorted by relevance score
- [ ] Response time < 200ms for queries under 50 characters
- [ ] Empty queries return 400 with descriptive error message
- [ ] All endpoints require authentication
```

**2. PR body MUST have "Test Plan" with verification steps.**

A PR without a test plan is a PR that "works on my machine." Every PR body should answer: "How can a reviewer verify this works?"

```markdown
## Test Plan

- [ ] Run `curl -H "X-API-Key: test" /api/search?q=hello` — expect 200
- [ ] Run `curl /api/search?q=hello` (no auth) — expect 401
- [ ] Run `curl -H "X-API-Key: test" /api/search` (no query) — expect 400
```

### Before/After: Commit Messages

```
# BEFORE (withdrawal — reader learns nothing):
git commit -m "fix: update parser"

# AFTER (deposit — reader understands WHY):
git commit -m "fix(search): handle relative dates — 'yesterday' queries
returned future dates due to timezone offset in parseRelativeDate()"
```

**3. Before coding: "What does done look like? How will we verify it?"**

Ask this question every time. If you can't answer it, you're not ready to code. This applies doubly with AI assistants — they'll produce something, but without a target, you won't know if it's right.

**4. Commit messages explain WHY, not just WHAT.**

`fix: update parser` tells you nothing. `fix(search): handle relative dates to prevent wrong results for "yesterday" queries` tells the next developer everything they need.

## Anti-Patterns

- **Starting without criteria**: "Build me a search endpoint" -> AI generates code -> endless revision. Better: define inputs, outputs, error cases, and performance bounds first.
- **"It works on my machine" PRs**: No test plan, no verification steps. The reviewer has no way to validate the change without reverse-engineering your intent.
- **Scope creep from undefined boundaries**: Without a Definition of Done, every review comment becomes "while you're at it, could you also..." The scope grows until nothing ships.

## Real Example

On a production AI memory system project, every planning document followed a strict template that included "Success Criteria" and "Definition of Done" sections. When implementing a new search algorithm, the plan specified: "F1 score >= 0.65 on the standard benchmark, response time < 500ms p95, zero regression on existing query types." This made the AI's work measurable. Three iterations of generated code were rejected not because they were bad, but because they didn't meet the pre-defined threshold. The fourth iteration passed — and everyone knew it was done.

## Checkpoint

> "Can I describe what success looks like before writing code?"

If you can't write 3-5 concrete, verifiable success criteria, you're not ready to start. Go back and think about the end.

---

_Next: [Habit 3 — Put First Things First](h3-first-things-first.md)_
