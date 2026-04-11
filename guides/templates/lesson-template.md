# Lesson Template

Output template for `/reflect` Step 6 (Persist). Lessons are saved to `~/.claude/lessons/` for cross-session retrieval by `/research` and `/build-brief`.

## File Naming

`YYYY-MM-DD-<slug>.md` where `<slug>` is a lowercase, hyphenated summary of the task (max 50 chars).

Example: `2026-04-11-auth-middleware-race-condition.md`

## Template

```markdown
---
date: YYYY-MM-DD
task: "[task or feature name]"
project: "[project name from working directory]"
tags: ["tag1", "tag2", "tag3"]
habit: "H[N]"
---

# Lesson: [task or feature name]

## Went well
[Brief answer from Question 1]

## Surprised
[Brief answer from Question 2]

## Do differently
[Brief answer from Question 3]

## Reusable pattern
[Brief answer from Question 4, or "none this time"]

## Action item
[Specific action] — **Owner**: [who] — **By**: [date]
```

## Field Descriptions

| Field | Required | Description |
|-------|----------|-------------|
| `date` | Yes | Date of reflection (YYYY-MM-DD) |
| `task` | Yes | Name of the task or feature reflected on |
| `project` | Yes | Project name (basename of working directory) |
| `tags` | Yes | 2-5 keywords for search — include domain, technology, and pattern names |
| `habit` | No | Primary habit that applied (e.g., "H1", "H5") — helps track which habits surface most |

## Tagging Guidelines

Good tags enable retrieval. Include:
- **Domain**: `auth`, `api`, `database`, `frontend`, `infra`, `ci`
- **Technology**: `typescript`, `python`, `docker`, `k8s`
- **Pattern**: `race-condition`, `migration`, `error-handling`, `testing`
- **Workflow**: `review`, `deploy`, `refactor`, `security`

Avoid generic tags: `code`, `fix`, `update`, `work`
