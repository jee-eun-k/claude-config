# GitHub Issue Tracking

## Mandatory Issue Tracking

Every code change MUST be linked to a GitHub Issue — no exceptions except hotfixes.

### Before Writing Code

1. **Find or create a GitHub Issue** for the work
2. **Reference the issue number** in branch name (see [git-workflow.md](./git-workflow.md#branch-naming) for full naming rules)
3. **Reference the issue** in commit messages and PR description

### Exempt from Issue Requirement

- **Hotfixes**: Critical production fixes that need immediate deployment
  - Still create a follow-up issue for tracking after the fix lands
- **Trivial typo fixes**: Single-character or whitespace-only changes

### Issue Creation Rules

When creating issues:
- **Always assign** to the creator (`--assignee @me`)
- **Always include Korean translation** in both title and description body
  - Title format: `English title (한국어 제목)`
  - Body: bilingual descriptions — Korean summary followed by English details
- **Never reference local file paths** — inline the actual content
- **Apply sprint labels**: `sprint:1`, `sprint:2`, `sprint:3`, `backlog:groomed`, `backlog:needs-grooming`, or `defer`
- **Apply type labels** where applicable: `tech-debt`, `bug`, `enhancement`, `documentation`

### Workflow

```
Issue exists? ──No──→ Create issue first
     │
    Yes
     │
     ▼
Create branch from issue
     │
     ▼
Implement (plan → tdd → code-review)
     │
     ▼
PR references issue (#123)
     │
     ▼
Merge closes issue (use "Closes #123" in PR)
```

### BMAD Integration

- **BMAD stories** define acceptance criteria and specs
- **GitHub Issues** track work visibility and status
- For stories managed by BMAD, create a corresponding GitHub Issue that links to or inlines the story's acceptance criteria
- Sprint status lives in `_bmad-output/{project}/sprint-status.yaml` AND GitHub Issue labels
