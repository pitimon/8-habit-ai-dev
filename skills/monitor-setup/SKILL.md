---
name: monitor-setup
description: >
  Set up error tracking, alerting, and health checks.
  Use AFTER deploy to ensure observability. Step 7 of 7-step workflow. Maps to H7 (Sharpen the Saw).
user-invocable: true
argument-hint: "[project or service to monitor]"
allowed-tools: ["Read", "Glob", "Grep", "Bash"]
---

# Step 7: Monitor (เฝ้าระวัง)

**Habit**: H7 — Sharpen the Saw | **Anti-pattern**: Deploying and forgetting — "it works on my machine"

## Process

1. **Check existing monitoring**: Search for health endpoints, Prometheus configs, Grafana dashboards, alerting rules — don't duplicate what exists.

2. **Verify minimum observability**:
   - [ ] Health endpoint exists (`/health` or `/healthz`)
   - [ ] Error rate is trackable (metrics or logs)
   - [ ] Alerting is configured (email, Slack, PagerDuty)
   - [ ] Logs are accessible (not just stdout)

3. **If monitoring gaps found**, recommend additions:
   - Health endpoint: simple `/health` returning `{"status":"healthy","version":"x.y.z"}`
   - Error tracking: Sentry, Prometheus alert rules, or log aggregation
   - Uptime monitoring: health check ping every 30-60s
   - Disk/memory alerts: warn at 85%, critical at 95%

4. **Infrastructure health** (prevent cascade failures):
   - [ ] Disk space monitoring with alerts before exhaustion
   - [ ] Dependent services checked (DB, cache, queue) — if one dies, what cascades?
   - [ ] Container/process auto-restart configured (Docker restart policy, systemd)
   - [ ] Recovery runbook exists for each critical dependency

5. **Post-deploy monitoring habit**:

   ```
   After every deploy:
   1. Check health endpoint returns correct version
   2. Verify key features work (smoke test)
   3. Watch error rate for 5 minutes
   4. Check no new alerts fired
   5. Record any incidents for future learning
   ```

6. **H7 Checkpoint**: "Am I investing in Production Capability (monitoring), or just grinding out Production (features)?"

## The P/PC Balance

Production (P) = shipping features, fixing bugs
Production Capability (PC) = monitoring, alerting, runbooks, incident playbooks

If you only invest in P and neglect PC, eventually the saw is too dull to cut.

Load `${CLAUDE_PLUGIN_ROOT}/habits/h7-sharpen-saw.md` for the full H7 principle and examples.
