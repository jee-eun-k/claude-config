# Tooling Guide: How to Use Your Full Claude Code Setup Effectively

## The 3-Tier Mental Model

```
Tier 1 — NATIVE AGENTS  (fast, direct, everyday coding)
  /plan → /tdd → /code-review → /build-fix
  Use for: 80% of daily work

Tier 2 — BMAD WORKFLOWS  (structured, multi-agent, larger scope)
  ~/Development/_bmad/...  ← v6: no slash commands, reference paths directly
  Use for: new epics, architecture decisions, formal reviews

Tier 3 — MCP TOOLS  (infrastructure, data, external systems)
  infra-gateway · serena · filesystem · notebooklm
  Always available in background — agents call them automatically
```

**Decision rule:** Start at Tier 1. Move to Tier 2 only when the task needs planning artifacts (PRD, epics, stories, arch docs) or team-simulation dialogue. Tier 3 is always available — agents call it automatically.

> **BMAD v6 note:** No slash commands. Invoke by telling Claude: "Run the BMAD workflow at `~/Development/_bmad/<path>`"

### ECC vs BMAD — Plan & Review

| Tool | Scope | When |
|------|-------|------|
| ECC `/plan` | Code-level task breakdown | Task is well-defined |
| BMAD planning workflows | PRD, arch, stories, acceptance criteria | Scope is unclear or multi-session |
| ECC `/code-review` | Code quality, security, maintainability | After every change (quick) |
| BMAD `bmad-code-review` | Did code meet story acceptance criteria? | Before closing a story/PR (deep) |

---

## Task → Tool Cheat Sheet

### 1. Implement a New Feature

**Small feature (1–3 files, clear scope)**
```
1. /plan          → planner agent creates step-by-step plan
2. /tdd           → write tests first, then implement (Red→Green→Refactor)
3. /code-review   → scan for CRITICAL/HIGH issues
4. git commit
```

**Larger feature (unclear scope, multi-session)**
```
1. BMAD quick-flow     → ~/Development/_bmad/bmm/workflows/bmad-quick-flow
2. /tdd → /code-review (per story)
3. BMAD code-review    → ~/Development/_bmad/bmm/workflows/4-implementation/bmad-code-review
```

**New epic (full ceremony)**
```
1. BMAD create-prd          → bmm/workflows/2-plan-workflows/create-prd
2. BMAD create-architecture → bmm/workflows/3-solutioning/bmad-create-architecture
3. BMAD create-story        → bmm/workflows/4-implementation/bmad-create-story
   → /plan → /tdd → /code-review   (per story)
   → BMAD code-review              (before closing story)
```

---

### 2. Fix a Bug

```
1. Tell Claude the bug + stack trace / reproduction steps
2. /tdd           → write a failing test that reproduces the bug FIRST, then fix
3. /code-review   → verify the fix didn't introduce new issues
```

**If build is broken after fix:**
```
/build-fix        → build-error-resolver patches errors incrementally
```

---

### 3. Improve UI/UX

**Visual/interaction changes (existing component)**
```
1. /plan → /tdd → /e2e
```

**Redesign / new UX patterns (multi-screen, new design system)**
```
1. /bmad:bmm:workflows:create-ux-design           → Sally (UX Designer) 14-step discovery
2. /bmad:bmm:workflows:create-excalidraw-wireframe → generate wireframes
3. /plan → /tdd → /code-review
```

**Tip:** Always run `/e2e` after UI changes — catches visual regressions automatically.

---

### 4. Plan/Write Tests

| Need | Command |
|------|---------|
| Missing tests for existing code | `/test-coverage` |
| Tests before implementing (TDD) | `/tdd` |
| Acceptance tests before epic | `/bmad:bmm:workflows:testarch-atdd` |
| Full test strategy for an epic | `/bmad:bmm:workflows:testarch-test-design` |

**Tip:** Use `testarch-atdd` at epic start — locks in acceptance criteria as executable tests before any code.

---

### 5. Run Tests

| Need | Command |
|------|---------|
| E2E tests | `/e2e` |
| Coverage analysis + missing tests | `/test-coverage` |
| Adversarial test quality review | `/bmad:bmm:workflows:testarch-test-review` |

---

### 6. Create Output Files / Documentation

**Architecture diagrams**
```
/bmad:bmm:workflows:create-excalidraw-diagram    → system architecture, ERDs, UML
/bmad:bmm:workflows:create-excalidraw-dataflow   → data flow diagrams
/bmad:bmm:workflows:create-excalidraw-flowchart  → process/pipeline/logic flows
/bmad:bmm:workflows:create-excalidraw-wireframe  → app wireframes
```

**Docs**
```
/update-codemaps  → generates token-lean architecture codemaps (docs/CODEMAPS/)
/update-docs      → syncs README, generates CONTRIB.md and RUNBOOK.md
/bmad:bmm:workflows:generate-project-context    → concise project-context.md for agents
/bmad:bmm:workflows:document-project    → Paige (Tech Writer) documents a brownfield project
```

**Research notes**
```
mcp__notebooklm-mcp__notebook_create  → create a notebook
mcp__notebooklm-mcp__source_add       → add URLs, text, docs
mcp__notebooklm-mcp__studio_create    → generate audio summary, slides, mind maps
```

---

### 7. Code Review

| Scope | Command |
|-------|---------|
| Quick review after writing code | `/code-review` |
| Security-focused review | Ask: "Run security-reviewer on [file/module]" |
| Story-level acceptance validation | BMAD `~/Development/_bmad/bmm/workflows/4-implementation/bmad-code-review` |

---

### 8. Refactor / Clean Up Dead Code

```
/refactor-clean   → runs knip + depcheck + ts-prune, removes dead code safely
```

**Tip:** Run before every major feature merge.

---

### 9. Plan a New Epic (Full BMAD Path)

```
Phase 1 — Analysis
  /bmad:bmm:workflows:create-product-brief
  /bmad:bmm:workflows:research

Phase 2 — Design
  /bmad:bmm:workflows:create-prd
  /bmad:bmm:workflows:create-ux-design

Phase 3 — Solution
  /bmad:bmm:workflows:create-architecture
  /bmad:bmm:workflows:create-epics-and-stories
  /bmad:bmm:workflows:check-implementation-readiness

Phase 4 — Execute (repeat per story)
  /bmad:bmm:workflows:sprint-planning
  /bmad:bmm:workflows:create-story
  /bmad:bmm:workflows:dev-story
  /bmad:bmm:workflows:code-review

Phase 5 — Review
  /bmad:bmm:workflows:retrospective
```

**Quick solo path (skip ceremony):**
```
/bmad:bmm:workflows:create-tech-spec → /bmad:bmm:workflows:quick-dev
```

---

### 10. Sprint Management

```
/bmad:bmm:workflows:sprint-status    → summarize sprint, surface risks
/bmad:bmm:workflows:workflow-status  → "what should I do now?"
```

---

### 11. Git / GitHub Operations

```
/commit (built-in)                              → conventional commits
mcp__infra-gateway__create_pull_request         → create PRs
mcp__infra-gateway__search_code                 → search GitHub code
mcp__infra-gateway__list_issues                 → list issues
mcp__infra-gateway__get_pull_request_reviews    → review status
```

**Tip:** `gh` CLI in Bash is faster for quick ops; `mcp__infra-gateway__*` is richer for complex workflows.

---

### 12. Database Operations

```
mcp__infra-gateway__connect_to_database    → connect to PostgreSQL
mcp__infra-gateway__execute_sql            → read queries
mcp__infra-gateway__execute_unsafe_sql     → write queries (pauses for approval)
mcp__infra-gateway__query_database         → natural language queries
```

---

### 13. Web Search / Research

```
mcp__infra-gateway__search           → general web search (DuckDuckGo)
mcp__infra-gateway__fetch_content    → read any URL as markdown
mcp__infra-gateway__get-library-docs → current framework docs (React, Next.js, etc.)
```

**Tip:** Use `get-library-docs` (context7) for framework APIs — fetches CURRENT version docs, not training data.

---

### 14. Explore an Unfamiliar Codebase

```
mcp__serena__get_symbols_overview      → all classes/functions in a file
mcp__serena__find_symbol               → find a specific class/function by name
mcp__serena__find_referencing_symbols  → see everything that calls a function
mcp__serena__search_for_pattern        → regex search across codebase
```

**Tip:** Run `/bmad:bmm:workflows:document-project` when onboarding to a new repo — generates a reference doc that makes all future work 3× faster.

---

### 15. Creative / Strategic Thinking

```
/bmad:cis:workflows:brainstorming        → facilitated ideation
/bmad:cis:workflows:design-thinking     → Empathize→Define→Ideate→Prototype→Test
/bmad:cis:workflows:problem-solving     → TRIZ / TOC / Systems Thinking
/bmad:cis:workflows:innovation-strategy → business model innovation
/bmad:core:workflows:party-mode         → multi-agent group discussion
```

---

## Agent Quick-Reference

| Agent / Command | Tier | Best For |
|----------------|------|---------|
| `planner` / `/plan` | 1 | Any task > 3 files, before writing code |
| `tdd-guide` / `/tdd` | 1 | Every feature + every bug fix |
| `code-reviewer` / `/code-review` | 1 | After every code change |
| `build-error-resolver` / `/build-fix` | 1 | Build/TypeScript failures |
| `security-reviewer` | 1 | Auth, input handling, API endpoints |
| `e2e-runner` / `/e2e` | 1 | Critical user flows, pre-deploy |
| `refactor-cleaner` / `/refactor-clean` | 1 | Dead code, before major merges |
| `architect` | 1 | Architectural decisions (ad hoc) |
| `doc-updater` / `/update-docs` | 1 | After feature completion |
| `create-tech-spec` + `quick-dev` | 2 | Medium features, solo path, no ceremony |
| Full BMAD path | 2 | New epics, cross-service features |
| `testarch-*` | 2 | Test strategy, ATDD, CI scaffolding |
| `infra-gateway` MCP | 3 | GitHub, DB, search, fetch |
| `serena` MCP | 3 | Codebase exploration, symbol navigation |
| `notebooklm` MCP | 3 | Research, study materials, audio summaries |

---

## Recommended Daily Workflow

```
Morning:
  BMAD sprint-status  → ~/Development/_bmad/bmm/workflows/4-implementation/bmad-sprint-status

Feature work (well-defined):
  /plan → /tdd → /code-review → commit

Feature work (unclear scope):
  BMAD quick-flow → /tdd → /code-review → BMAD code-review → commit

Before merging:
  /build-fix (if needed) → /refactor-clean → /e2e

End of epic:
  BMAD retrospective  → ~/Development/_bmad/bmm/workflows/4-implementation/bmad-retrospective

Whenever you learn something reusable:
  /learn              → extracts pattern to ~/.claude/skills/learned/
```

---

## Output File Location Reference

| Artifact | Default Path |
|----------|-------------|
| BMAD planning docs | `~/Development/_bmad-output/planning-artifacts/` |
| BMAD implementation artifacts | `~/Development/_bmad-output/implementation-artifacts/` |
| Sprint status | `~/Development/_bmad-output/implementation-artifacts/sprint-status.yaml` |
| Retrospectives | `~/Development/_bmad-output/implementation-artifacts/epic-N-retro-DATE.md` |
| Learned skills | `~/.claude/skills/learned/` |
| Codemaps | `docs/CODEMAPS/` (per-project) |
