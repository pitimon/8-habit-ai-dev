# Using 8-Habits — Examples

Worked examples illustrating the 7-step workflow end-to-end. Loaded from `SKILL.md` when a user needs a concrete walkthrough beyond the decision tree.

## Onboarding Example Walkthrough: Password Reset Feature

A new developer wants to add password reset to an existing auth system. Here's the full 8-habit flow:

1. **`superpowers:brainstorming "password reset"`** — frame the problem (magic links? passwordless?). Refined statement: "secure self-service recovery without contacting support." (Skip if Superpowers isn't installed.)

2. **`/research "password reset security patterns"`** — find OWASP guidance, existing patterns in the codebase (if any), look at how Auth0/Clerk handle it. Output: research brief with 3 verified sources.

3. **`/requirements`** — draft PRD with EARS acceptance criteria (Event-driven, Unwanted, State-driven, Ubiquitous, Optional shapes).

4. **`/design`** — architecture decisions. Token storage (DB vs signed JWT)? Email provider? Rate limiting? Trade-off table + ADR.

5. **`/breakdown`** — atomic tasks: (a) reset token model, (b) reset email template, (c) reset endpoint, (d) token validation endpoint, (e) UI form. 5 tasks, dependencies mapped.

6. **`/build-brief` per task** — for each task, read existing auth code first, produce context brief, then implement.

7. **`/review-ai`** — 4-level verdict before PR. `/security-check` for the token logic specifically.

8. **`/cross-verify`** — 17-question check on the whole PR before merging.

9. **`/deploy-guide`** — staging first, smoke test, then production.

10. **`/monitor-setup`** — alerts for spikes in reset attempts (possible abuse), failed email sends, token validation failures.

11. **`/reflect`** — 5-question retro after the feature ships. What did we learn? What would we do differently?

Each step produces an artifact. The artifacts compose. That's the discipline.

## Key takeaways from this walkthrough

- **Every step is optional except `/review-ai`**. If the feature were simpler (e.g., a minor UI tweak), steps 0, 2, 6, 7, 10 could legitimately be skipped.
- **Skills compose with sibling plugins**. The walkthrough above would gain `/threat-model` (devsecops) between steps 1 and 2 if installed, and `/governance-check` (claude-governance) before step 7.
- **Artifacts are the source of truth, not the conversation**. Each step writes a durable file (research brief, PRD, ADR, task list, review report). Later steps load these files rather than re-deriving context from chat history.
