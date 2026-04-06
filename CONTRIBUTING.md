# Contributing to 8-Habit AI Dev

Thank you for helping improve the plugin. This guide covers how to add skills, habits, question packs, and templates.

## Plugin Philosophy

This is a **philosophy-first** plugin. Skills provide guidance, not automation. They tell Claude _how to approach_ a task — they never modify files themselves. Keep this identity when contributing.

## Adding a New Skill

### 1. Create the directory

```
skills/<skill-name>/SKILL.md
```

The directory name must match the `name` field in frontmatter.

### 2. Use this template

```yaml
---
name: <skill-name>
description: >
  This skill should be used when the user asks to [specific trigger phrases].
  [What it does in 1-2 sentences]. Maps to H[N] ([Habit Name]).
user-invocable: true
argument-hint: "[what the user provides]"
allowed-tools: ["Read", "Glob", "Grep"]
prev-skill: <skill-name|none|any>
next-skill: <skill-name|none|any>
---

# [Title] ([Thai translation])

**Habit**: H[N] — [Habit Name] | **Anti-pattern**: [What this skill prevents]

## Process

1. **[Step]**: [Instructions]
2. **[Step]**: [Instructions]

## Handoff

- **Expects from predecessor**: [What input this skill needs]
- **Produces for successor**: [What output this skill creates]

## When to Skip

- [Condition where this skill is genuinely unnecessary]
- [Another honest skip condition]

## Definition of Done

- [ ] [Verifiable checkbox item]
- [ ] [Verifiable checkbox item]
- [ ] [Verifiable checkbox item]

Load `${CLAUDE_PLUGIN_ROOT}/[reference-file].md` for detailed guidance.
```

### 3. Conventions (aligned with Anthropic official standards)

- **Description**: Third-person ("This skill should be used when..."), include specific trigger phrases
- **Word count**: Target 1,500-2,000 words for body, max 5,000
- **Heavy detail**: Route to `references/` subdirectory or `guides/` files
- **Allowed tools**: Minimal — `Read`, `Glob`, `Grep` by default. Add `Bash` only when the skill needs to run commands.
- **Definition of Done**: 3-5 verifiable checkbox items per skill
- **When to Skip**: 3-4 honest conditions — prevent compliance theater

## Adding a Habit File

Create `habits/h[N]-[name].md` with this structure:

- **Title and principle** (1 paragraph)
- **Rules** (specific, actionable)
- **Anti-patterns** (what to avoid)
- **Real Example** (from production experience)
- **Checkpoint** (reflexive question)

## Adding a Cross-Verify Question Pack

Create `guides/cross-verify-packs/<domain>.md`:

- 5 domain-specific questions
- Each tagged with a Dimension (Body/Mind/Heart/Spirit)
- Scored separately from the main 17 questions

## Adding an Output Template

Create `guides/templates/<name>-template.md`:

- Placeholder sections (not just headings)
- Referenced from skills via `Load` directive

## Version Bumping

Version lives in **3 files** — all must be bumped together:

- `.claude-plugin/plugin.json`
- `.claude-plugin/marketplace.json`
- `README.md` footer

## Quality Checklist

Before submitting:

- [ ] Skill has valid YAML frontmatter
- [ ] `name` field matches directory name
- [ ] Definition of Done has 3-5 verifiable items
- [ ] When to Skip has honest conditions
- [ ] Habit mapping is documented
- [ ] No hardcoded secrets or sensitive patterns
- [ ] File under 800 lines
