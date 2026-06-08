---
date: 2026-05-20
originating-decision: ADR-012
rejected-because: Compliance enforcement belongs in claude-governance; this plugin focuses on workflow discipline
---

# We don't ship EU AI Act compliance toolkit here

**Why we won't do it**: ADR-012 (2026-05-02) completed migration of `/eu-ai-act-check` from `8-habit-ai-dev` v2.3.0 to `pitimon/claude-governance` v3.1.0+. The original placement violated the plugin boundary (this plugin = workflow discipline; companion plugin = compliance enforcement and regulatory framework mappings). The stub at `skills/eu-ai-act-check/SKILL.md` redirects users to install `claude-governance` for the canonical implementation.

**What this prevents**:

- Two plugins both maintaining EU AI Act framework mappings (drift, contradiction, double-maintenance)
- Compliance content drifting into 8-habit's discipline-focused voice (regulatory text needs precision; discipline text values brevity)
- Re-litigating "should we ship it here" each time Annex III or Article 14 updates land

**If reconsidering, read these conditions first:**

- `pitimon/claude-governance` is archived or unmaintained
- EU AI Act updates require workflow-level (not enforcement-level) changes — e.g., a new Habit emerges from regulatory pressure
- The companion plugin is unavailable to a meaningful user segment (license, deployment, geographic) and they need workflow-aware regulatory guidance
- A documented n≥2 friction signal where users tried the redirect stub and abandoned the discipline workflow because of installation friction
