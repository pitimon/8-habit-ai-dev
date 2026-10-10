# Adopt 8-Habit AI Dev with your team

This guide is for technical leads and platform owners introducing a shared AI-assisted development process. Developers should use their [client-specific guide](../README.md#quick-start) for installation and daily commands. Adoption recommendations below are not controls enforced by the package.

## Start with a bounded pilot

1. Assign an owner for runtime selection, package version and onboarding. Assign a reviewer independent of the change author.
2. Choose a non-production task with existing tests. Record the team's current review and rework process before the pilot.
3. Use `requirements` to agree on scope, `build-brief` to inspect the codebase, and `review-ai` to check the implementation evidence.
4. Keep branch protection, continuous integration, security scanning, staging and production approval in place.
5. Evaluate whether artifacts made scope, review and handoffs clearer. Record observations rather than assuming productivity gains.
6. Use `reflect` to retain a concise lesson, then decide whether to expand adoption.

## Agree on ownership

| Area | Package contribution | Team responsibility |
| --- | --- | --- |
| Development process | Guidance, templates and handoff prompts | Scope, requirements and architecture decisions |
| Quality | Review structure and evidence prompts | Execute tests, verify findings and approve changes |
| Production | Deployment and rollback planning | Authorize and execute changes through existing controls |
| Data and security | Public security policy and threat model | Runtime/provider review, access controls and sensitive-data handling |
| Updates | Versioned releases and package validation | Record installed versions, test updates and own recovery |
| Support | Public repository documentation and issues | Internal ownership and escalation |

## Review data and tool access

The package has no hosted service, database or tenant-isolation layer. Your agent runtime and model provider determine tool execution, network access, prompt handling and data retention. A plugin install does not establish data residency, compliance certification or production authorization.

Keep credentials, raw customer data and private operational evidence out of shared artifacts. Read [SECURITY.md](../SECURITY.md) and the [threat model](security/threat-model.md) before the pilot. Check the [compatibility matrix](compatibility-matrix.md) when choosing a runtime; shared Markdown content does not imply identical hook, agent or memory behavior.

EU AI Act framework mappings belong to the separate [claude-governance](https://github.com/pitimon/claude-governance) project. This package includes a redirect entry, not a certification process.

## Roll out and update

Record the package version, client version and tested task. Marketplace installations can follow moving snapshots; they are not automatically immutable deployments.

Review release notes, follow the selected client's update instructions, inspect the installed listing and repeat a representative task before expansion. If behavior changes unexpectedly, pause rollout and follow that runtime's supported reinstall or version-selection procedure. Reverting repository source alone does not revert an installed cache.

## Support and evidence

Support is through public [GitHub Issues](https://github.com/pitimon/8-habit-ai-dev/issues), not a contractual service desk. Report versions and sanitized reproduction steps. Security issues use the private disclosure route in SECURITY.md; no response-time guarantee is established by this package.

Repository validation checks content structure, metadata, links, mirrors and selected hook behaviors. It does not prove that every client follows every skill, that generated conclusions are correct, or that your environment is production-ready. Keep runtime and user-journey evidence separate from static validation.

[Back to the overview](../README.md) · [Skill catalog](skills-reference.md)
