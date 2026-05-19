# BMAD Sprint

## File Paths

| Artifact | Path |
|----------|------|
| Sprint status (source of truth) | `~/Development/_bmad-output/brs-client/sprint-status.yaml` |
| Story files | `~/Development/_bmad-output/brs-client/stories/` |
| Obsidian dashboard | `~/Library/Mobile Documents/com~apple~CloudDocs/000_obsidian/000_work/dev-notes/sprint-dashboard.md` |
| Skill | `~/Development/claude-config/global/commands/sync-sprint.md` |

## Sprint Command

Run `/sync-sprint` to regenerate the Obsidian dashboard from the current sprint-status.yaml.

## sprint-status.yaml Format

```yaml
last_updated: <ISO timestamp>
project: pmi-platform
project_key: BRS-TEST-AUTO

development_status:
  # Epic N: <Title>
  epic-N: <backlog|in-progress|done>
  N-1-story-name: <backlog|ready-for-dev|in-progress|review|done>
  epic-N-retrospective: <optional|done>
```

## Status Definitions

**Epic:** `backlog` → `in-progress` → `done`

**Story:** `backlog` → `ready-for-dev` → `in-progress` → `review` → `done`

**Retrospective:** `optional` | `done`
