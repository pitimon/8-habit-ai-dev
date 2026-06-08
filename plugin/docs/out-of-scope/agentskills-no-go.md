---
date: 2026-05-20
originating-decision: ADR-007
rejected-because: Standard reach is measured by what tools parse, not by logo lists — keeping full frontmatter control
---

# We don't migrate to the agentskills.io frontmatter standard

**Why we won't do it**: ADR-007 (2026-04-11) evaluated migrating our SKILL.md frontmatter (description, allowed-tools, prev-skill, next-skill, user-invocable, argument-hint) to the agentskills.io v1 standard. Key finding: the reach of a standard is measured by what adopting tools _parse_, not by their logo list. agentskills.io's parsing surface was thinner than the marketing implied; migrating would have meant losing fields we use (`prev-skill`/`next-skill` for DAG wiring, `argument-hint` for slash-command UX) in exchange for a logo.

**What this prevents**:

- Loss of skill-graph DAG validation (validate-structure.sh Check 8+ depend on prev/next-skill)
- Loss of argument-hint UX in `/skill --help` output
- Re-investigation of the same trade-off each release cycle

**If reconsidering, read these conditions first:**

- agentskills.io standard adds first-class support for skill-graph wiring (prev/next equivalents)
- A major Claude Code release adopts agentskills.io as canonical (today's frontmatter would become non-portable)
- Cross-agent portability friction surfaces — e.g., Codex or Cursor adopters can't load our skills (currently solved by `AGENTS.md` + `RESOLVER.md`)
- An n≥2 friction signal exists from real users blocked by our frontmatter differences
