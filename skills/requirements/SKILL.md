---
name: requirements
description: >
  Generate PRD from user intent — define what, why, who, scope, and success criteria.
  Use BEFORE starting any feature. Step 1 of 7-step workflow. Maps to H2 (Begin with End in Mind).
user-invocable: true
argument-hint: "[--persist <slug>] [feature description]"
allowed-tools: ["Read", "Glob", "Grep", "Write", "AskUserQuestion"]
prev-skill: research
next-skill: design
---

# Step 1: Requirements (คิดก่อนทำ)

**Habit**: H2 — Begin with End in Mind | **Anti-pattern**: Starting to code without knowing what "done" looks like

## Process

1. **Discover requirements**: Before writing EARS criteria, follow the Interview Protocol (loaded below) to discover requirements through structured conversation. Use adaptive depth — Quick (3 questions) for small scope, Standard (5) by default, Deep (7+) for complex features.

   Core questions to clarify:
   - What problem are we solving? (not what solution — the problem)
   - Who is affected?
   - What does success look like?
   - What are the boundaries? (in scope / out of scope)
   - What exists already?

2. **Check existing docs**: Read `CLAUDE.md`, `PRD.md`, `DOMAIN.md`, or `README.md` if they exist — don't duplicate what's already defined.

3. **Draft PRD summary** (keep concise — 10-20 lines):

   ```
   ## Feature: [Name]
   **What**: [1-2 sentences]
   **Why**: [Problem it solves]
   **Who**: [Target user]
   **In scope**: [Bullet list]
   **Out of scope**: [Bullet list]
   **Success criteria**: [3-5 verifiable conditions]
   **Definition of Done**: [What must be true before this is "done"]
   ```

4. **Write acceptance criteria in EARS notation** (recommended for features with ≥3 criteria):

   EARS = Easy Approach to Requirements Syntax — 5 templates that eliminate ambiguity in acceptance criteria. Originally from Rolls-Royce (2009), now adopted by GitHub Spec Kit (84.7K⭐).

   Pick one of 5 shapes per criterion:

   | Shape            | Template                                            | Use for                             |
   | ---------------- | --------------------------------------------------- | ----------------------------------- |
   | **Ubiquitous**   | `The <system> shall <response>.`                    | Invariants, always-on behavior      |
   | **Event-driven** | `When <trigger>, the <system> shall <response>.`    | User actions, incoming signals      |
   | **State-driven** | `While <state>, the <system> shall <response>.`     | Continuous behavior in a state      |
   | **Unwanted**     | `If <trigger>, then the <system> shall <response>.` | Error paths, edge cases             |
   | **Optional**     | `Where <feature>, the <system> shall <response>.`   | Feature-gated, plan-tiered behavior |

   Worked example — user login:

   ```markdown
   1. [Event-driven] When the user submits the login form with valid email and
      password, the system shall issue a JWT valid for 24 hours and set it as
      an HttpOnly, Secure, SameSite=Strict cookie.
   2. [Unwanted] If the login attempt fails (invalid credentials, rate limit
      exceeded, account locked), then the system shall return HTTP 401 with a
      generic error message that does not reveal whether the email exists.
   3. [State-driven] While a valid JWT cookie is present and not expired, the
      system shall authenticate subsequent requests without re-prompting.
   4. [Ubiquitous] All login attempts shall be logged with timestamp, user ID,
      source IP, and outcome.
   5. [Optional] Where the user has enabled 2FA, the login flow shall prompt
      for a 6-digit TOTP code before issuing the JWT.
   ```

   Full reference: see `${CLAUDE_PLUGIN_ROOT}/guides/ears-notation.md` for all 5 shapes with multiple examples, complex patterns, and before/after rewrites.

   **EARS opt-out**: Skip EARS for single-line bug fixes, rename refactors, dependency bumps, or any requirement with fewer than 3 acceptance criteria. **Honest skip rule**: if you can test the requirement with one assertion, EARS is overhead. Use it when multiple conditions interact.

5. **H2 Checkpoint**: "Can I describe what success looks like before writing code?"

## Optional Persistence (`--persist <slug>`)

When invoked with `--persist <slug>`, this skill writes its PRD output to `docs/specs/<slug>/prd.md` in addition to emitting the conversation `SKILL_OUTPUT:requirements` block. Without the flag, behavior is byte-identical to v2.14.3 (no file writes).

For the canonical convention (slug regex `^[a-z0-9][a-z0-9-]{1,63}$`, conflict policy, YAML frontmatter format, error message rules, ID-linkage `FR-NNN` guidance), load `${CLAUDE_PLUGIN_ROOT}/guides/persistence-convention.md`.

ID-linkage tip: when persisting, prefix each EARS criterion with `FR-NNN:` (e.g., `1. [Event-driven] FR-001: When user submits...`) to enable deterministic Coverage and Inconsistency passes in `/consistency-check`. IDs are recommended, not required.

## When to Skip

- Single-line bug fixes with obvious root cause
- Formatting or linting changes
- Dependency version bumps

## Handoff

- **Expects from predecessor**: User intent — a feature idea, bug report, or problem statement. If `/research` was run, a research brief with findings, constraints, comparison matrix (if applicable), and recommendation
- **Produces for successor** (`/design`): PRD summary with What/Why/Who/Scope/Success criteria

## Definition of Done

- [ ] PRD summary exists with What/Why/Who/Scope sections filled
- [ ] 3-5 concrete, verifiable success criteria defined
- [ ] Scope boundaries clear — both "in scope" and "out of scope" listed
- [ ] Stakeholder/target user identified

## Structured Output Block

After writing the PRD, append a structured output block for cross-skill handoff. This HTML comment is invisible when rendered but enables `/cross-verify` to auto-check coverage:

```
[/requirements] COMPLETE SKILL_OUTPUT:requirements
<!-- SKILL_OUTPUT:requirements
ears_count: [N]
ears_criteria:
  - "[criterion 1]"
  - "[criterion 2]"
scope_in: "[in-scope description]"
scope_out: "[out-of-scope description]"
primary_user: "[user role]"
risks:
  - "[risk 1]"
success_criteria_count: [N]
END_SKILL_OUTPUT -->
```

Place this at the very end of the PRD output, after all human-readable content.

## Further Reading

See [Step 1 wiki page](../../docs/wiki/Step-1-Requirements.md) for deeper walkthrough, examples, and common pitfalls.

Load `${CLAUDE_PLUGIN_ROOT}/guides/templates/prd-template.md` for the output template.
Load `${CLAUDE_PLUGIN_ROOT}/guides/templates/interview-protocol.md` for the structured discovery protocol.
Load `${CLAUDE_PLUGIN_ROOT}/habits/h2-begin-with-end.md` for the full H2 principle and examples.
Load `${CLAUDE_PLUGIN_ROOT}/guides/structured-output-protocol.md` for the structured output block format specification.
Load `${CLAUDE_PLUGIN_ROOT}/guides/persistence-convention.md` when `--persist <slug>` is used (canonical spec for opt-in persistence to `docs/specs/<slug>/prd.md`).
