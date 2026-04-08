# Contributing to Wiki

The wiki is a **build artifact**. Source of truth lives in [`docs/wiki/`](https://github.com/pitimon/8-habit-ai-dev/tree/main/docs/wiki) in the main repository. Edits made via the GitHub Wiki web UI are **overwritten** on the next sync. This page explains how to contribute correctly.

See [ADR-004](https://github.com/pitimon/8-habit-ai-dev/blob/main/docs/adr/ADR-004-wiki-as-artifact.md) for the rationale.

## TL;DR

```bash
git clone https://github.com/pitimon/8-habit-ai-dev
cd 8-habit-ai-dev
git checkout -b docs/my-wiki-fix
# edit docs/wiki/<page>.md
git add docs/wiki/<page>.md
git commit -m "docs(wiki): fix typo in Getting Started"
git push -u origin docs/my-wiki-fix
gh pr create
```

Merge → GitHub Action syncs → wiki updates automatically.

## Step-by-step

### 1. Fork and clone

```bash
gh repo fork pitimon/8-habit-ai-dev --clone
cd 8-habit-ai-dev
```

### 2. Create a branch

```bash
git checkout -b docs/describe-change
```

Branch naming: use `docs/` prefix for wiki-only changes.

### 3. Edit `docs/wiki/<page>.md`

- Use sentence-case headings
- Keep paragraphs short (3–5 lines)
- Link with wiki-relative names: `[Step 2 · Design](Step-2-Design)` — no `.md` suffix
- Add your page to `_Sidebar.md` if it is brand new
- Do **not** edit `docs/wiki/Habits-Reference.md` — it is auto-generated from [`habits/h*.md`](https://github.com/pitimon/8-habit-ai-dev/tree/main/habits); edit the source instead

### 4. Preview locally

```bash
bash scripts/gen-habits-reference.sh   # if you touched habits/
bash tests/validate-structure.sh        # verifies wiki skeleton
bash tests/validate-content.sh          # fitness functions
```

### 5. Commit with conventional message

```bash
git commit -m "docs(wiki): add troubleshooting section for wiki sync"
```

Types for wiki work: `docs(wiki): ...`.

### 6. Open a PR

```bash
gh pr create --title "docs(wiki): ..." --body "..."
```

The `wiki-linkcheck.yml` Action runs automatically — fix any broken links it flags.

### 7. After merge

The `wiki-sync.yml` Action publishes to `<repo>.wiki.git` within seconds of the merge. Verify at [github.com/pitimon/8-habit-ai-dev/wiki](https://github.com/pitimon/8-habit-ai-dev/wiki).

## Adding a new page

1. Create `docs/wiki/Your-Page.md` with an H1 title
2. Add an entry to `docs/wiki/_Sidebar.md` in the appropriate section
3. Add at least one inbound link from another page (Home, Workflow Overview, etc.)
4. Open the PR as above

## Renaming or deleting a page

- Renaming a page **breaks existing wiki URLs** — avoid if possible, or add a redirect note on the old page
- Deletion: remove the file, remove the sidebar entry, grep for inbound links (`grep -rn "Your-Page" docs/wiki/`) and update them

## Style guide

- **Voice**: direct, helpful, no marketing language
- **Length**: one screenful per page when possible; deep-dives get their own page
- **Code blocks**: fenced with language tag (` ```bash `, ` ```yaml `)
- **Tables**: use sparingly; convert to lists if the table has only 2 columns
- **Emoji**: only if it adds clarity (warning, success, info). Do not put emoji in H1/H2 — they break anchor generation
- **Bilingual**: English only for now; Thai translation is planned as a phase 2

## What not to contribute (yet)

- Per-project tutorials (put those in your own repo)
- Translated pages (Thai EN-bilingual structure is planned — do not start yet)
- Videos or heavy images (keep the wiki git-friendly)

## Questions

[Open an issue](https://github.com/pitimon/8-habit-ai-dev/issues) with the `wiki` label.
