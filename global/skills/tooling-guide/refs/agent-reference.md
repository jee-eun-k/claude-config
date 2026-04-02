# Agent & Tool Reference

## Tier 1 — Native Agents

| Agent / Command | Best For |
|----------------|---------|
| `planner` / `/plan` | Any task > 3 files, before writing code |
| `tdd-guide` / `/tdd` | Every feature + every bug fix |
| `code-reviewer` / `/code-review` | After every code change |
| `build-error-resolver` / `/build-fix` | Build/TypeScript failures |
| `security-reviewer` | Auth, input handling, API endpoints |
| `e2e-runner` / `/e2e` | Critical user flows, pre-deploy |
| `refactor-cleaner` / `/refactor-clean` | Dead code, before major merges |
| `architect` | Architectural decisions (ad hoc) |
| `doc-updater` / `/update-docs` | After feature completion |

## Tier 2 — BMAD Workflows

| Workflow | Best For |
|----------|---------|
| `create-tech-spec` + `quick-dev` | Medium features, solo path, no ceremony |
| Full BMAD path | New epics, cross-service features |
| `testarch-*` | Test strategy, ATDD, CI scaffolding |

## Tier 3 — MCP Tools

| MCP Server | Best For |
|-----------|---------|
| `infra-gateway` | GitHub, DB, search, fetch |
| `serena` | Codebase exploration, symbol navigation |
| `notebooklm` | Research, study materials, audio summaries |
| `filesystem` | File operations outside project |
| `ticktick` | Task management |
