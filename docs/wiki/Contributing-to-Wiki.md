# Contributing To Wiki

The public wiki is generated from `docs/wiki/` in the repository. Treat wiki changes like code changes: edit source files, validate locally, and open a PR.

## Workflow

1. Create a docs branch.
2. Edit files under `docs/wiki/`.
3. Preserve existing page filenames unless a redirect plan exists.
4. Run validation.
5. Open a PR for review.
6. After merge, verify the wiki sync workflow and inspect the published page.

## Style

- Start every page with a clear H1 and short lead paragraph.
- Prefer precise capability wording over marketing claims.
- Say "guidance" or "workflow discipline" when that is what the plugin provides.
- Do not claim runtime enforcement, cloud automation, legal advice, or compliance certification.
- Keep links wiki-relative for wiki pages, for example `[Installation](Installation)`.
- Use GitHub alert callouts only for important boundaries or warnings.

## Content Boundaries

Do not add:

- secrets, tokens, credentials, customer-sensitive raw data, or private incident evidence,
- platform-specific syntax across all skills without an accepted ADR,
- new behavior claims that are not present in source skills,
- release notes that conflict with `CHANGELOG.md` or GitHub Releases.

## Validation

```bash
git diff --check
bash tests/validate-structure.sh
bash tests/validate-content.sh
```

For link validation, rely on the wiki link-check workflow or run the same tool locally if available.

## PR Checklist

- Existing filenames and major links are preserved.
- No empty links or empty code fences.
- No unbalanced code fences.
- No overclaiming language.
- Operational updates remain visible when relevant.
- The PR states that the change is docs-only if no package behavior changed.

## See Also

- [Architecture](Architecture)
- [Changelog](Changelog)
- [Troubleshooting](Troubleshooting)
