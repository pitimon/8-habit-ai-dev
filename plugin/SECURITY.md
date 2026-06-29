# Security Policy

## Reporting a Vulnerability

**Do NOT open a public GitHub issue for security vulnerabilities.**

Report suspected vulnerabilities **privately**, in order of preference:

1. **GitHub Private Security Advisories** (preferred) —
   [Report a vulnerability](https://github.com/pitimon/8-habit-ai-dev/security/advisories/new).
   This keeps the report encrypted and private to the maintainer, and supports
   coordinated disclosure + CVE requests.
2. **Email** — `pitimon@thaicloud.ai`.

Please include:

- A description of the issue and its potential impact
- Steps to reproduce (proof of concept)
- The affected file(s) and version (check the `Version` badge in [`README.md`](README.md), or `.claude-plugin/plugin.json` / `.codex-plugin/plugin.json` depending on which packaging you installed)
- Any suggested remediation

See [`docs/security/threat-model.md`](docs/security/threat-model.md) for the full
threat model, trust boundaries, and what is — and is not — in scope.

## What Is in Scope

This repository ships the **`8-habit-ai-dev`** Claude Code / Codex plugin:
structured **markdown guidance** (skills, habits, guides, rules), the
`hooks/session-start.sh` session reminder, and the opt-in
`hooks/pre-commit.sh.example`. The plugin ships **no runtime service, no
endpoints, no database, no authentication, and no network client.**

In scope:

- **Malicious or unsafe content** in a skill / habit / guide / rule (e.g. a skill
  that instructs the agent to exfiltrate data or run destructive commands).
- Unsafe behavior in **`hooks/session-start.sh`** (runs at every session start).
- The opt-in **`hooks/pre-commit.sh.example`** (executes `claude --print` with the
  committing user's privileges when installed).
- **Supply-chain integrity** of the install path (marketplace spoofing, tag /
  manifest tampering).

Out of scope:

- **OWASP application-layer issues** that presuppose a running service (auth
  bypass, SQL injection, SSRF, XSS, …). There is no service to attack.
- Vulnerabilities in **your own project** that you run this plugin against. The
  plugin emits guidance; what your agent does with it is your responsibility.

## Supported Versions

Only the **latest** release receives security updates (see the `Version` badge in
`README.md` or the [releases page](https://github.com/pitimon/8-habit-ai-dev/releases)).
Update before reporting — **Claude Code**: `claude plugin update 8-habit-ai-dev@pitimon-8-habit-ai-dev`; **Codex**: remove and re-add. See [Keeping the plugin updated](README.md#keeping-the-plugin-updated) for both flows.

## Response Expectations

This is a **solo-maintained** open-source project. The targets below are
**targets, not guarantees** — they are stated so reporters know what to expect,
not to overstate capability:

| Severity                                                        | Acknowledge | Update / Fix target |
| --------------------------------------------------------------- | ----------- | ------------------- |
| Critical (e.g. malicious skill content, RCE via a shipped hook) | ≤ 72 hours  | ≤ 7 days            |
| High (safe-by-violation, privilege confusion)                   | ≤ 72 hours  | ≤ 30 days           |
| Medium / Low / documentation                                    | ≤ 72 hours  | best-effort         |

If a fix is not feasible, the maintainer will publish an advisory describing the
risk and any mitigation or workaround.

## No PGP

Reports are accepted over plain email; there is **no PGP key** for this project.
If you require end-to-end confidentiality, use GitHub Private Security Advisories
(encrypted in transit, not exposed in email).

## Coordinated Disclosure

Please do not publish details publicly until a fix is available (or **90 days**,
whichever is sooner), and give the maintainer reasonable notice before any
public write-up. Credit will be given unless you prefer to remain anonymous.
