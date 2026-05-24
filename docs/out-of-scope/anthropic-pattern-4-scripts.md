---
date: 2026-05-24
originating-decision: ADR-017
rejected-because: Conflicts with plugin charter — skills are read-only guidance, not tooling
---

# We don't embed `scripts/` subfolders in `skills/*/`

**Why we won't do it**: ADR-017 (2026-05-24) audited Anthropic's official `github.com/anthropics/skills` repo and confirmed `skills/pptx/scripts/` exists and is in active use (`__init__.py`, `add_slide.py`, `clean.py`, `thumbnail.py`, plus an `office/` subdir). Anthropic's pptx skill calls these scripts directly to generate slides, extract XML, and render thumbnails. The pattern is a real H7 "Sharpen the Saw" investment for production-capability work.

We don't adopt it because our plugin charter (`CLAUDE.md` §"Architecture") is explicit: **"Skills are read-only guidance — they tell Claude how to approach a task, they do not modify files themselves."** Adding `scripts/` subfolders would mean skills can execute code, which makes them tooling rather than guidance. That's a fundamental shift, not a pattern adoption.

**What this prevents**:

- Charter drift: once one skill ships `scripts/`, the read-only-guidance principle becomes a default of "guidance-only unless you have scripts" — exception language is harder to enforce than a clean rule
- Runtime dependency creep: scripts typically need Python/Node/bash interpreters, breaking the "no build system, no dependencies" design principle from `CLAUDE.md`
- Plugin-boundary erosion: code that mutates state belongs in `claude-governance` per the boundary (memory obs #233270); adding scripts here would replicate enforcement logic
- Token-cost regression: the "load scripts on demand" pattern adds I/O + execution overhead per invocation versus the current "read SKILL.md, generate guidance" flow

**If reconsidering, read these conditions first:**

- An H7 friction case is documented where a skill (`/save-spec`, `/diagnose`, `/research`, etc.) repeatedly re-implements the same script logic across sessions and the absence of an embedded script provably wastes tokens or causes drift across re-implementations
- The repeatable script is genuinely action (e.g., XML extraction, thumbnail render) rather than guidance (e.g., "describe how to do X") — guidance still belongs in SKILL.md prose
- A charter amendment ADR has been drafted arguing that the H7 production-capability benefit > the "guidance-only" simplicity, with concrete examples
- The plugin-boundary question has been re-evaluated: are scripts truly workflow discipline (`8-habit-ai-dev`), or are they runtime enforcement (`claude-governance`)?
- An ADR-016 re-entry trigger has fired (an n=1 friction citation from `/reflect` or post-mortem stating "skill X kept failing because no script-equivalent existed")

When all four conditions are met, the future ADR should consider a **scoped exception** (e.g., `scripts/` allowed for skills that explicitly opt-in via a frontmatter field like `embeds-scripts: true`) rather than a blanket charter amendment. The current 0/23 skills having scripts is information — it suggests scripts/ may not be needed for the current workflow shape.

Reviewer credit: ADR-017 8-habit-reviewer cross-verify (2026-05-24) explicitly tested whether the rejection was charter-defense or work-avoidance. The charter-defense interpretation held: P4 conflicts with a load-bearing design principle, not just with absent friction.
