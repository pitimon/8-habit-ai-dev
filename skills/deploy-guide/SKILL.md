---
name: deploy-guide
description: >
  Step-by-step deployment assistance with rollback planning.
  Use when deploying to staging or production. Step 6 of 7-step workflow. Maps to H1 (Be Proactive).
user-invocable: true
argument-hint: "[staging|production]"
allowed-tools: ["Read", "Glob", "Grep", "Bash"]
prev-skill: review-ai
next-skill: monitor-setup
---

# Step 6: Deploy (ปล่อยของ)

**Habit**: H1 — Be Proactive | **Anti-pattern**: Deploying directly to production without staging

## Process

1. **Check existing deploy infrastructure**: Read deploy scripts, CI/CD configs, docker-compose files, Makefiles — understand what's already automated.

2. **Staging first** (ALWAYS):

   ```
   Step 1: Build artifacts (images, bundles)
   Step 2: Deploy to staging
   Step 3: QA on staging (health check, feature verify, smoke test)
   Step 4: Deploy to production
   Step 5: QA on production (verify version, health, features)
   ```

3. **Pre-deploy checklist**:
   - [ ] All tests pass
   - [ ] Code review completed
   - [ ] Version bumped (if applicable)
   - [ ] Environment variables validated
   - [ ] Rollback plan documented

4. **Rollback plan** (MUST have before deploying):
   - How to revert to previous version
   - How long rollback takes
   - What data might be affected

5. **H1 Checkpoint**: "Do I have a plan for when this fails, not just when it succeeds?"

## Anti-Patterns

- Combining build + deploy in one step (no staging gate)
- Deploying on Friday afternoon
- No rollback procedure documented
- Skipping health check after deploy

## Handoff

- **Expects from predecessor** (`/review-ai`): Review verdict PASS — code ready for deployment
- **Produces for successor** (`/monitor-setup`): Deployed service with rollback plan documented

## When to Skip

- Local development environment only — no deployment involved
- CI/CD pipeline already handles the full staging→production flow automatically
- Documentation-only or config-only change with no runtime impact

## Definition of Done

- [ ] Staging deploy verified — health endpoint returns correct version
- [ ] Rollback plan documented with specific steps and time estimate
- [ ] Post-deploy health check confirmed (smoke test passed)
- [ ] Error rate monitored for at least 5 minutes after deploy

## Further Reading

See [Step 6 wiki page](../../docs/wiki/Step-6-Deploy-Guide.md) for deeper walkthrough, examples, and common pitfalls.

Load `${CLAUDE_PLUGIN_ROOT}/habits/h1-be-proactive.md` for the full H1 principle and examples.
