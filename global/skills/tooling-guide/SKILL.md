---
description: "Tooling guide for Claude Code setup — agents, workflows, BMAD integration, MCP tools, and daily workflow reference"
---

# Tooling Guide: How to Use Your Full Claude Code Setup

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

**Decision rule:** Start at Tier 1. Move to Tier 2 only when the task needs planning artifacts (PRD, epics, stories, arch docs) or team-simulation dialogue. Tier 3 is always available.

> **BMAD v6 note:** No slash commands. Invoke by telling Claude: "Run the BMAD workflow at `~/Development/_bmad/<path>`"

### ECC vs BMAD — Plan & Review

| Tool | Scope | When |
|------|-------|------|
| ECC `/plan` | Code-level task breakdown | Task is well-defined |
| BMAD planning workflows | PRD, arch, stories, acceptance criteria | Scope is unclear or multi-session |
| ECC `/code-review` | Code quality, security, maintainability | After every change (quick) |
| BMAD `bmad-code-review` | Did code meet story acceptance criteria? | Before closing a story/PR (deep) |

## Quick Start by Task Type

| Task | Workflow |
|------|----------|
| Small feature (1-3 files) | `/plan` → `/tdd` → `/code-review` → commit |
| Larger feature (unclear scope) | BMAD quick-flow → `/tdd` → `/code-review` → commit |
| New epic (full ceremony) | BMAD create-prd → create-architecture → create-story → per-story dev |
| Bug fix | Reproduce → `/tdd` (failing test first) → `/code-review` |
| Build broken | `/build-fix` |
| UI changes | `/plan` → `/tdd` → `/e2e` |
| Refactor / dead code | `/refactor-clean` |
| Code review | `/code-review` (quick) or BMAD code-review (story-level) |

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
| BMAD workflows | 2 | Epics, cross-service features, formal reviews |
| MCP tools | 3 | GitHub, DB, search, fetch, codebase exploration |

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
  BMAD retrospective

Whenever you learn something reusable:
  /learn → extracts pattern to ~/.claude/skills/learned/
```

## Detailed References

For comprehensive task-by-task instructions, see:

- [Task Cheatsheet](refs/task-cheatsheet.md) — detailed workflows for 15 task types
- [Agent Reference](refs/agent-reference.md) — all agents with descriptions and usage
- [Output Locations](refs/output-locations.md) — where artifacts are stored
