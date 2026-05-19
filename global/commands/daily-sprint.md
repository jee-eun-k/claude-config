---
description: Daily sprint update — identify recently-done stories, sync to GitHub issues, refresh Obsidian dashboard, output Korean standup
---

# Daily Sprint Command

Reads `sprint-status.yaml`, identifies stories completed since the last GH sync, closes their GitHub issues, regenerates the Obsidian dashboard, and outputs a Korean standup summary.

## Data Sources

- **Sprint status**: `~/Development/_bmad-output/brs-client/sprint-status.yaml`
- **GitHub repo**: `pm-international-korea/BRS-client`
- **Obsidian dashboard**: `~/Library/Mobile Documents/com~apple~CloudDocs/000_obsidian/000_work/dev-notes/sprint-dashboard.md`

## Execution Steps

### Step 1: Parse Sprint Status

Read `sprint-status.yaml` and parse the `development_status` section. Classify each entry:
- **Epic**: key starts with `epic-` and does NOT end with `-retrospective`
- **Retrospective**: key ends with `-retrospective`
- **Story**: everything else

Extract per story:
- `story_id`: the YAML key (e.g., `hf-1a-signin-server-action-security`)
- `status`: the value (`backlog`, `ready-for-dev`, `in-progress`, `review`, `done`)
- `gh_issue`: parse from the inline YAML comment — match `# GH #(\d+)` and extract the number. Only the first match matters; ignore `PR #NNN` references.
- `display_title`: humanize the story ID — strip all leading numeric/identifier segments, convert remaining kebab-case to Title Case, prepend bracket label
  - `hf-1a-signin-server-action-security` → `[hf.1a] Signin Server Action Security`
  - `6-0-4c-aks-prd-verification` → `[6.0.4c] AKS PRD Verification`
  - `16-3b-ia-execution` → `[16.3b] IA Execution`

### Step 2: Identify Unsynced Done Stories

For each story where `status == done` AND `gh_issue` is set:

```bash
gh issue view <NNN> --repo pm-international-korea/BRS-client --json state,title
```

A story is **unsynced** when `state == "OPEN"` — marked done in the YAML but the GitHub issue is still open.

Build two lists:
- **unsynced_done**: done stories with open GH issues (these are the "yesterday's completions" to close)
- **active**: stories with status `in-progress` or `review`, with their GH issue numbers

If `gh` returns an authentication error, report it and skip Steps 3 and 4 but continue to Steps 5 and 6.

### Step 3: Close GitHub Issues

For each story in `unsynced_done`, close its GitHub issue:

```bash
gh issue close <NNN> \
  --repo pm-international-korea/BRS-client \
  --comment "Story completed: <story_id> — marked done in sprint-status.yaml"
```

Report each result: story ID, display title, issue number, success/failure.

If `unsynced_done` is empty: print "All done stories already synced to GitHub — nothing to close."

### Step 4: Regenerate Obsidian Dashboard

Execute the full `/sync-sprint` workflow (Steps 1–2 from that command):
- Re-parse the `development_status` section
- Write the updated `sprint-dashboard.md` to the Obsidian vault

Report the dashboard path and updated progress counts.

### Step 5: Output Korean Standup Summary

Print this block to the conversation:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 스프린트 스탠드업  (<today's date, Korean format: YYYY년 MM월 DD일>)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

어제 한 일:
<one bullet per unsynced_done story>
- [display_title] (GH #NNN 완료)

오늘 할 일:
<one bullet per active story, ordered: review first, then in-progress>
- [display_title] — <Korean status>  (GH #NNN)

⚠️ 블로커: <none = "없음", otherwise describe the blocking dependency>

진행률: <done_count> / <total_story_count> (<percent>%)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Korean status labels:**
- `review` → `코드 리뷰 중`
- `in-progress` → `진행 중`
- `ready-for-dev` → `시작 예정`

**If no stories were closed in Step 3** (nothing new today), use the 5 most recently listed `done` stories from active epics (epics with status `in-progress`) as the "어제 한 일" list, with a note `(이전 완료)` instead of `(GH #NNN 완료)`.

**Blocker detection:** A blocker exists if any `in-progress` story's YAML comment contains "PENDING", "BLOCKED", or "블로커", or if an active story depends on an external team action (check for "INFRA TEAM", "infra", "DNS", "Cloudflare" keywords in the comment).
