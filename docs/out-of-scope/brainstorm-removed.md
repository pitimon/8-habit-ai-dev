---
date: 2026-05-20
originating-decision: ADR-006
rejected-because: Superpowers ships a stronger collaborative brainstorm — duplication hurts both plugins
---

# We don't ship a `/brainstorm` skill — one-line subject: peer plugin already does it better

**Why we won't do it**: The `claude-plugins-official:superpowers` plugin ships a `brainstorming` skill with a hard-gate collaborative design session that produces a committed spec document before any other work. Our v2.3.0 `/brainstorm` skill was a thinner version of the same idea. After comparison (ADR-006, 2026-04-15), we deleted ours and referenced theirs from `/research`.

**What this prevents**:

- Two plugins drifting on the same pattern, forcing users to choose between near-duplicates
- Maintenance cost on a feature where a peer already invests more deeply
- "Audience honesty" debt (cited in ADR-006) — when a peer does something better, the honest move is to reference, not reimplement

**If reconsidering, read these conditions first:**

- Superpowers has dropped or significantly weakened its `brainstorming` skill
- The integration friction between Superpowers and 8-habit becomes severe (e.g., they require a paid tier we don't want users on)
- We have a genuinely different brainstorm pattern — not just a re-skinned version of theirs
- A documented n≥2 friction signal exists where users tried `/research` and couldn't proceed because Superpowers wasn't installed and they had no brainstorm primitive
