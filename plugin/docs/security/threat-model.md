# Threat Model — `8-habit-ai-dev`

> Companion to [`SECURITY.md`](../../SECURITY.md). Documents _what_ the security
> surface of this plugin actually is — and explicitly what it is not — so
> contributors and reporters reason about real threats instead of
> application-layer ones that do not apply. Created to close the Spirit gap
> flagged by an adversarial
> [`governance-reviewer`](../reviews/2026-06-10-fable-model-review.md) pass and
> tracked under [#343](https://github.com/pitimon/8-habit-ai-dev/issues/343).

## 1. What this plugin is (and isn't)

`8-habit-ai-dev` is a **markdown-only Claude Code / Codex plugin**. It ships:

- **Guidance content** — `skills/`, `habits/`, `guides/`, `rules/`: markdown that
  an LLM agent reads when a user invokes a skill.
- **One hook that executes** — `hooks/session-start.sh`: a bash script that runs
  at every session start (Claude Code `SessionStart`, Codex JSON adapter). It
  reads a version manifest and an optional local profile file, then **prints a
  reminder**. It performs **no** network calls, no `eval`, no `source` of
  untrusted input, and no external command execution (verified: `sed` / `awk` /
  `cat` / `printf` only).
- **One opt-in example** — `hooks/pre-commit.sh.example`: **not auto-installed**.
  A user must deliberately `cp` it into `.git/hooks/`. When active it runs
  `claude --print` (the Claude Code CLI) with the committing user's privileges.

It ships **no** runtime service, **no** HTTP endpoints, **no** database,
**no** authentication, **no** network client, **no** compiled code, and
**no** dependencies. `tests/validate-*.sh` are pure-bash structural validators.

**Consequence**: conventional OWASP application-layer threats (auth bypass,
SQL/NoSQL injection, SSRF, XSS, CSRF, deserialization, service path traversal)
**do not apply** — there is no service. The plugin's own
[`/security-check`](../../skills/security-check/SKILL.md) skill is written for
that application layer (endpoints, DB, auth, input validation); applying it to
this repository yields mostly **N/A**. That mismatch is itself a finding (§4).

## 2. Trust boundaries

```
contributor → pull request → maintainer review → release (tag) → user install (marketplace) → agent runtime (user's machine)
```

The decisive boundary is **maintainer review at PR merge**: everything shipped is
trusted from that point forward. The downstream agent runtime executes with the
**user's** privileges, not the maintainer's.

## 3. STRIDE

| Threat (STRIDE)              | Realized how                                                                                                                                                                                                                                                           | Mitigation / control                                                                                                                                                                                                             | Residual risk                                                                                                                                      |
| ---------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Tampering** (supply chain) | A PR introduces **malicious content** into a skill / habit / guide / rule — e.g. a skill instructing the agent to exfiltrate secrets, `curl` data out, or run destructive commands. The LLM that reads the markdown will faithfully execute well-phrased instructions. | Maintainer PR review; `/review-ai` + `/cross-verify` discipline on incoming content; `tests/validate-*.sh` enforce **structure** (frontmatter, size, links) but **not semantics**.                                               | **Primary** threat. Validators cannot detect semantic malice — a well-formed malicious skill passes structure checks. Human review is the control. |
| **Elevation of privilege**   | `hooks/pre-commit.sh.example`, once copied into `.git/hooks/`, runs `claude --print` as the **committing user**. A malicious pre-commit hook can do anything the user can.                                                                                             | Opt-in `.example` (never auto-installed); documented install steps; **fail-closed** verdict logic (PR [#344](https://github.com/pitimon/8-habit-ai-dev/pull/344), F6 fix) so a tool failure blocks rather than silently passes.  | Low — opt-in, user-controlled, fail-closed.                                                                                                        |
| **Information disclosure**   | A skill could instruct the agent to leak local secrets / PII into its output or a third-party call.                                                                                                                                                                    | Same as Tampering — maintainer review; the plugin _teaches_ secret-discipline (`/security-check`, governance pre-commit fitness functions).                                                                                      | Medium — ultimately bounded by what the user's agent is allowed to do; the plugin cannot enforce it.                                               |
| **Spoofing**                 | A malicious marketplace entry named similarly, or a tampered tag / manifest, installed as "8-habit-ai-dev".                                                                                                                                                            | Canonical install from the official marketplace (`claude plugin marketplace add pitimon/8-habit-ai-dev`); version-pinned install; releases are tag-anchored.                                                                     | Low for users who follow the documented install.                                                                                                   |
| **Repudiation**              | Lack of provenance for a shipped change.                                                                                                                                                                                                                               | Git history; ADRs (`docs/adr/`) record _why_; [`SELF-CHECK.md`](../../SELF-CHECK.md) records release self-assessment.                                                                                                            | Low.                                                                                                                                               |
| **Denial of service**        | N/A — no runtime service to deny.                                                                                                                                                                                                                                      | —                                                                                                                                                                                                                                | None.                                                                                                                                              |
| **CI/CD supply chain**       | A compromised or malicious third-party GitHub Action could inject into releases.                                                                                                                                                                                       | All Actions are **SHA-pinned** (not floating tags); each workflow declares a least-privilege `permissions:` block; only the built-in `GITHUB_TOKEN` is used (no long-lived CI secrets); `lychee` link-checking is config-scoped. | Low. (No Dependabot / Renovate yet — tracked in §5.)                                                                                               |

## 4. Self-audit: `/security-check` applied to this repository

As part of closing the Spirit gap, the plugin's **own** `/security-check`
methodology was applied to the repo — the "enforce-on-others, skip-on-self" fix
([#343](https://github.com/pitimon/8-habit-ai-dev/issues/343)):

| `/security-check` category     | Result on this repo                                                                                                                                                                                    |
| ------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Secrets & credentials          | **Pass** — `git grep` for `sk-`, `ghp_`, `AKIA`, private keys, `api_key=`, `password=` across tracked content returned **no matches** (2026-06-29). No CI secrets beyond the ephemeral `GITHUB_TOKEN`. |
| Auth & access control          | **N/A** — no endpoints, no auth.                                                                                                                                                                       |
| Input handling / injection     | **N/A** — no DB, no string-interpolated queries, no service input.                                                                                                                                     |
| OWASP application Top 10       | **N/A** — no application.                                                                                                                                                                              |
| Supply-chain / plugin-specific | **Not covered by the skill** — see §3 Tampering.                                                                                                                                                       |

**Finding**: `/security-check` is scoped to application code and does **not**
cover this plugin's primary (supply-chain / semantic-content) threats. This
document fills that gap. A future plugin-specific lens for the skill is tracked
in [#343](https://github.com/pitimon/8-habit-ai-dev/issues/343).

## 5. Controls NOT present (honest gaps)

Stated so posture is not overstated:

- **No SLSA / artifact signing** beyond git tags. Releases are tag-anchored, not
  cosign-signed. (Low impact given markdown-only content + SHA-pinned CI.)
- **No Dependabot / Renovate** for the SHA-pinned CI actions → a pinned action
  could age without automated bump alerts.
- **No automated secret scan in CI** — the scan cited in §4 was run manually.
  (GitHub's built-in secret scanning / push protection applies at the repo level
  where enabled.)

These are tracked in [#343](https://github.com/pitimon/8-habit-ai-dev/issues/343)
and revisited per §6.

## 6. Review cadence

Revisit this threat model when any of the following occurs, or annually:

- A new hook that executes is added (beyond `session-start.sh` and
  `hooks/pre-commit.sh.example`).
- The plugin gains any runtime, network, or dependency surface.
- A finding in [#343](https://github.com/pitimon/8-habit-ai-dev/issues/343)
  materially changes the threat surface.
