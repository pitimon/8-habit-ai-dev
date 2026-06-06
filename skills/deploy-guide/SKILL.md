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

2. **Classify the deploy type before planning rollout**:
   - `image build` — artifact/image changes; deploy the new artifact through staging first.
   - `mounted config/template` — runtime reads a file mounted from host/volume; plan config render, sync, service reload/restart, and verification.
   - `Swarm config` — `docker config`/secret object changes; plan config object replacement plus service update.
   - `full stack` — compose/stack topology changes; plan broader blast radius and rollback.
   - `source-of-truth drift` — repo/template says one thing but live runtime reads another; reconcile before deploy.
   - `force-update only` — no artifact/config change, but scheduler needs a controlled restart; still needs health/rollback checks.
   - `production canary / capacity change` — cloud/provider-managed infrastructure change where the operator can pick a canary but the provider may mutate a different resource; plan reconciliation gates.
   - `no deploy` — truly non-runtime work.

3. **Staging first** (ALWAYS when deploy type has runtime impact):

   ```
   Step 1: Build artifacts (images, bundles)
   Step 2: Deploy to staging
   Step 3: QA on staging (health check, feature verify, smoke test)
   Step 4: Deploy to production
   Step 5: QA on production (verify version, health, features)
   ```

4. **Pre-deploy checklist**:
   - [ ] All tests pass
   - [ ] Code review completed
   - [ ] Version bumped (if applicable)
   - [ ] Environment variables validated
   - [ ] Rollback plan documented

5. **Rollback plan** (MUST have before deploying):
   - How to revert to previous version
   - How long rollback takes
   - What data might be affected

6. **Config-only example**: Alertmanager email template mounted into a Swarm service is not a "no deploy" change. If the live container reads `/etc/alertmanager/templates/*.tmpl`, plan template render, config/object replacement or host sync, targeted service update/reload, and a notification smoke test. Avoid a full stack redeploy unless topology changed; it can restart unrelated services and expand blast radius.

7. **Production canary / capacity-change template**: use this for EKS nodegroup, ASG, Kubernetes node, or similar provider-managed scale/replacement work.

   - **Precheck**: confirm identity, context, profile, region, cluster/resource, current desired/min/max, schedulable capacity, unhealthy pods, PDBs, stateful workloads, canary target workload inventory, and rollback/mitigation for pre-scale failure.
   - **Cordon approval gate**: ask before cordoning the canary. Record target node/resource and why it is safe.
   - **Observation gate**: after cordon, verify no unexpected Pending pods, key workloads healthy, events clean or expected, and no unrelated `SchedulingDisabled` nodes.
   - **Drain approval gate**: ask before drain. Do not force-delete non-daemon workloads unless explicitly approved.
   - **Provider-side change approval gate**: ask before nodegroup/ASG/cluster/provider update. State that the provider may select a different eligible target than the canary unless protection/termination policy controls it.
   - **Reconciliation gate**: after provider action, compare planned target vs actual mutated/terminated/replaced resource; verify desired/min/max, Kubernetes schedulable capacity, all nodes Ready, no unintended `SchedulingDisabled` nodes, and whether the original canary needs uncordon or follow-up action.
   - **Postcheck and evidence closure**: distinguish "scale-down/update reached desired size" from "reconciliation complete." Close only after workloads, stateful services, alerts, provider status, and Kubernetes scheduling state align.

   Evidence wording:

   ```
   Production canary result:
   - Intended canary: <node/resource>
   - Provider-selected target: <same | different: resource id>
   - Scale/update status: <desired/min/max/provider state>
   - Reconciliation status: <all nodes Ready; no unintended SchedulingDisabled; original canary uncordoned or classified>
   - Rollback/mitigation readiness: <pre-scale plan tested/available; post-scale mitigation available>
   - Closure: <Resolved only if provider state and cluster scheduling state both align; otherwise Watch/Handoff/Active Incident via /operational-state>
   ```

8. **H1 Checkpoint**: "Do I have a plan for when this fails, not just when it succeeds?"

## Anti-Patterns

- Combining build + deploy in one step (no staging gate)
- Deploying on Friday afternoon
- No rollback procedure documented
- Skipping health check after deploy
- Treating provider scale-down success as canary reconciliation success
- Leaving the original canary node/resource unintentionally cordoned or `SchedulingDisabled`

## Handoff

- **Expects from predecessor** (`/review-ai`): Review verdict PASS — code ready for deployment
- **Produces for successor** (`/monitor-setup`): Deployed service with rollback plan documented

## When to Skip

- Local development environment only — no deployment involved
- CI/CD pipeline already handles the full staging→production flow automatically
- Documentation-only or config-only change with no runtime impact. If a config/template/env change alters live behavior, classify it and plan the runtime update.

## Definition of Done

- [ ] Deploy type classified before rollout plan is chosen
- [ ] Staging deploy verified — health endpoint returns correct version
- [ ] Rollback plan documented with specific steps and time estimate
- [ ] Production canary/capacity changes include provider-target reconciliation and no unintended `SchedulingDisabled` nodes
- [ ] Post-deploy health check confirmed (smoke test passed)
- [ ] Error rate monitored for at least 5 minutes after deploy

## Further Reading

See [Step 6 wiki page](../../docs/wiki/Step-6-Deploy-Guide.md) for deeper walkthrough, examples, and common pitfalls.

Load `${CLAUDE_PLUGIN_ROOT}/habits/h1-be-proactive.md` for the full H1 principle and examples.
