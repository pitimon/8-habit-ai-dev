# `/diagnose` — Reference (prior art, examples, license)

> Loaded on-demand from `skills/diagnose/SKILL.md`. Contains depth that doesn't fit the F3 ≤2000-word skill budget.

## Source & License Attribution

This skill is **adapted with attribution** from [`mattpocock/skills`](https://github.com/mattpocock/skills) — repo license MIT, ~95.5k★, 14 published skills.

- **Source SHA (pinned)**: [`b8be62ffacb0118fa3eaa29a0923c87c8c11985c`](https://github.com/mattpocock/skills/tree/b8be62ffacb0118fa3eaa29a0923c87c8c11985c) (`main` as of 2026-05-20T08:46:53Z)
- **Source file**: [`skills/engineering/diagnose/SKILL.md`](https://raw.githubusercontent.com/mattpocock/skills/b8be62ffacb0118fa3eaa29a0923c87c8c11985c/skills/engineering/diagnose/SKILL.md)
- **Adaptation strategy** (per [ADR-015](../../docs/adr/ADR-015-diagnose-skill-adoption-and-n1-framing.md), Decision-5 in [design.md](../../docs/specs/diagnose-skill-v2-18-0/design.md)): preserve all 6 phases + key vocabulary (feedback-loop, falsifiable hypotheses, tagged probes, post-green refactor), rewrite in 8-habit voice with explicit habit map (H1 + H5) + skip rule + handoff. Verbatim quote anchor on FR-004 hypothesis template for methodology fidelity.

License terms (MIT): permission granted to use, copy, modify, merge, publish, distribute provided the copyright notice and permission notice are included. Source repo's `LICENSE` file is the canonical text.

## Per-Phase Concrete Examples

### Phase 1 — Feedback Loop Examples

**Web app — failing HTTP probe**:

```bash
# Loop:
while true; do
  curl -sf http://localhost:3000/api/users/42 | jq .role
  sleep 1
done
# Bug: role intermittently returns null instead of "admin"
# Phase 1 done when this loop prints "null" ≥80% of the time.
```

**Node test — failing test**:

```bash
# Loop:
bun test src/services/payment.test.ts --watch --reporter=verbose
# Phase 1 done when a single test name is reliably red.
```

**Python script — fixture diff**:

```bash
# Loop:
./scripts/process.py < tests/fixtures/edge-case.json | diff - tests/fixtures/edge-case.expected.json
# Phase 1 done when diff is non-empty deterministically.
```

**Browser bug — Playwright snippet**:

```bash
# Loop:
playwright test tests/e2e/checkout-flow.spec.ts --grep "should apply discount" --reporter=line --workers=1
```

The pattern: **one command, one signal, fast turnaround**. If your loop takes >60s, it's too slow — find a smaller scope.

### Phase 2 — Reproduction Confirmation

Run the loop ~10 times. Record:

- Pass/fail count (target: ≥8/10 fail = ≥80% reproducibility)
- Exact error/output captured
- Environmental dependencies (DB state, env vars, time-of-day) noted

If reproducibility is intermittent (e.g., 4/10 fail), investigate timing/state contamination BEFORE moving to Phase 3. A flaky reproduction generates flaky hypotheses.

### Phase 3 — Hypothesis Template

Verbatim from source:

> _"If X causes it, then changing Y will make the bug disappear."_

Concrete instance (from the [compression-worker-420 lesson](#false-positive-patterns)):

> _H1: If the worker is genuinely backlogged on 35K items, then archiving 1000 old observations should drop the backlog count by ~1000._

This hypothesis is falsifiable in 30 seconds — archive 1000, recheck the count. If the count doesn't drop, H1 dies. The author wasted 30 minutes on log analysis instead.

### Phase 4 — Probe Tagging Strategy

```javascript
// At the suspected seam:
console.log("[DIAG-A]", {
  input,
  normalized,
  filter_applied: archived_at_filter,
});
// At downstream consumer:
console.log("[DIAG-B]", { count_before_filter, count_after_filter });
```

Cleanup grep (Phase 6):

```bash
grep -rnE '\[DIAG-[A-Z]\]' src/ --exclude-dir=node_modules
# Expected: 0 matches after cleanup.
```

The unique prefix lets you find every probe without scanning all `console.log` calls.

### Phase 5 — Architectural Seam Examples

**Wrong seam (symptom site)**:

```typescript
// api/checkout.ts (where error surfaces):
if (price < 0) throw new Error("invalid"); // local guard
```

**Right seam (cause site)**:

```typescript
// services/pricing/discount-applier.ts (where the negative price is computed):
const finalPrice = Math.max(0, basePrice - discount); // fix the source
```

The regression test belongs as close to the seam as possible — `services/pricing/discount-applier.test.ts`, not `api/checkout.test.ts`. A test too far from the seam will pass for the wrong reason (e.g., a downstream guard catches it) and won't catch future regressions in the actual broken logic.

### Phase 6 — Cleanup Checklist

- [ ] `grep -rnE '\[DIAG-[A-Z]\]'` returns no matches
- [ ] All temporarily-disabled subsystems (from ablation) restored
- [ ] Phase 1 feedback loop runs and is green
- [ ] Full test suite runs (not just the regression test) — catches unrelated breakage
- [ ] Branch is in a state someone else could review

Then invoke `/post-mortem` for the durable engineering record. The post-mortem captures: WHAT broke, WHY, HOW it slipped through, what telemetry/test could have caught it earlier.

## False-Positive Patterns (Friction Evidence)

These are real anti-patterns from `~/.claude/lessons/2026-04-12-compression-worker-420-investigation.md` — the lesson that motivated this skill's adoption per [ADR-015](../../docs/adr/ADR-015-diagnose-skill-adoption-and-n1-framing.md).

### FP-1: Skipping Phase 1, jumping to log analysis

**Symptom in lesson**: 30 minutes of log analysis to find the same answer that 5 minutes of SQL-comparison would have given.

**Why it happens**: Logs feel like "doing investigation" — they're verbose, look like data. But until you've built a deterministic loop that says PASS/FAIL on a single question, you're not investigating; you're browsing.

**Rule**: If your "investigation" doesn't end each minute with a clearer PASS/FAIL state, you're not in Phase 4 — you're still missing Phase 1.

### FP-2: Trusting monitoring numbers without verifying the query

**Symptom in lesson**: A `/workers/status` endpoint reported 35,779 backlogged items. Actual compression queue had 23. The status endpoint's SQL omitted `archived_at IS NULL` that the worker itself applied. **The metric was a false-alarm generator, not a real signal.**

**Reusable pattern**: Any status/dashboard endpoint counting items for a background worker MUST use the same `WHERE` clause as the worker. Extract shared filter logic into one function used by both paths.

**Phase 1 application**: When building the feedback loop on a "worker is slow" bug, your loop should query **the worker's filter**, not a separate dashboard's filter. Otherwise you're optimizing for the wrong signal.

### FP-3: Hypothesis without falsifiable prediction

**Bad**: _"Maybe the OpenRouter API is timing out."_

**Better (Phase 3 shape)**: _"If OpenRouter API timeouts cause the backlog, then forcing `OPENROUTER_TIMEOUT_MS=300000` should reduce backlog by ≥50% in 10 minutes."_

The second form is testable in 10 minutes. The first form is a guess that generates more questions, not answers.

## When NOT to Run This Skill

Echoing the SKILL.md's _When to Skip_ section with more detail:

- **Single-line typo / wrong constant**: read the diff, see the wrong value, fix it. Phase 1 overhead exceeds the fix cost.
- **Stack trace with line number to readable code**: if the trace points to a 5-line function and the bug is visible there, no 6-phase methodology needed.
- **Lint/formatter errors**: tool already tells you what's wrong; no investigation needed.
- **Configuration mismatch with clear error message**: e.g., `DATABASE_URL missing` — set the env var. Don't 6-phase a config issue.
- **Rename refactor or dep bump with passing CI**: there's no bug; review-ai + CI cover it.

If in doubt: **the 6 phases protect against expensive mistakes; the skip rule protects against expensive ceremony for cheap bugs.** Lean toward the skip rule for obvious cases.

## Honest Framing — Why This Skill Exists Despite n=1

Per [ADR-014](../../docs/adr/ADR-014-external-prior-art-audit.md)'s discipline ("future contributors evaluating 'should we add X' should require explicit friction citation"), this skill's friction signal is **n=1**: a single lesson (`2026-04-12-compression-worker-420-investigation.md`) where the lesson author's own retrospective explicitly notes _"Most useful: n/a (no 8-habit skills invoked during the fix session)"_.

This is below ADR-014's preferred n≥2 bar but stronger than ADR-014's own 4 adoptions (which had n=0 friction). The skill ships because:

1. The friction is real (a first-person admission of absent skill)
2. The skill is additive (no breaking change)
3. ADR-015 records the framing transparently

See ADR-015 for full context. If future use surfaces no second-friction instance, this skill is a candidate for review per the `/reflect` SKILL-EFFECTIVENESS feedback loop.

## See Also

- `/post-mortem` — the successor skill in the chain; captures the durable engineering record after `/diagnose` lands a fix
- `/research` — when the problem space (not the bug behavior) is what needs investigating; prefer over `/diagnose` when there's no specific failure to reproduce
- `/scrutinize` — when you want adversarial review of a proposed fix before committing
- `~/.claude/lessons/2026-04-12-compression-worker-420-investigation.md` — the friction citation that motivated this skill
- [`pitimon/claude-governance`](https://github.com/pitimon/claude-governance) Three Loops model — for classifying whether a `/diagnose` session's fix is In-the-Loop (architectural change), On-the-Loop (proposed fix needs review), or Out-of-Loop (trivial)
