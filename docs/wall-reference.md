> 2-page A4 landscape · 8pt mono · Print double-sided · Full details: `tooling-guide.md` + `bmad-ecc-integration.md`

# PAGE 1 — DECISIONS & WORKFLOW

## SITUATION → ACTION

| I have a...          | Do this                                      |
|----------------------|----------------------------------------------|
| Small feature        | `/plan` → `/tdd` → `/code-review` → commit  |
| Bug fix              | `/tdd` (failing test FIRST) → `/code-review` |
| Build broken         | `/build-fix`                                 |
| UI change            | `/plan` → `/tdd` → `/e2e`                   |
| Unclear scope        | `/brainstorm` → BMAD `quick-flow`            |
| Complex feature      | `/brainstorm` → `/plan` → `/tdd` → `/team`  |
| Parallel reviews     | `/ultrawork` (security + code-review + E2E)  |
| Well-scoped story    | `/autopilot` (all constraints in story AC)   |
| New epic             | BMAD `create-prd` → `create-arch` → stories |
| Security concern     | "Run security-reviewer on [module]"          |
| Before merging       | `/build-fix` → `/refactor-clean` → `/e2e`   |

## WORKFLOW (7 steps)

```
Research → Brainstorm → Plan → TDD → Dev (parallel) → Review → Verification → Commit
```

**Daily:** `sprint-status` → `/plan` → `/tdd` → `/code-review` → commit · **Pre-merge:** `/build-fix` → `/refactor-clean` → `/e2e`
**Quick solo:** BMAD `tech-spec` → `quick-dev` → `/code-review` · **Full epic:** `create-prd` → `create-arch` → stories → `/plan` → `/tdd` → `/code-review`

## EXECUTION MODES — solo dev usage

| Command | Solo Dev Use Case | Caution |
|---------|-------------------|---------|
| `/team` | Multi-file refactors with shared context | — |
| `/ultrawork` | Run security + code-review + E2E in parallel | — |
| `/autopilot` | Well-scoped stories (all constraints in AC) | Use `/brainstorm` first if scope unclear |
| `/brainstorm` | Unclear scope — surfaces hidden constraints | — |

## ERROR RECOVERY

| Problem | Recovery |
|---------|----------|
| Tests keep failing | Read error, fix impl not tests, `/tdd` again |
| 3 fixes fail same bug | STOP — architecture problem, escalate |
| Build broken | `/build-fix` → `/code-review` |
| Works in dev, 404 in prod | `npm run build && node .next/standalone/server.js` |
| Going in circles | `gemini "problem + what tried"` |
| Cross-repo breakage | Check pmi-authorization (auth/menu), pmi-common (DTOs) |

## BMAD ↔ ECC AUTO-CHAINING

| BMAD completes... | ECC auto-runs |
|---|---|
| `dev-story` / `quick-dev` → done | **MUST** `/code-review` + `security-reviewer` if sensitive |
| `code-review` findings | `/plan` (gaps) · `architect` (bad spec) · `security` (patches) |
| `create-story` → ready | SHOULD `/plan` pre-flight |
| `create-architecture` | SHOULD `architect` + `security-reviewer` |

**Reverse:** ECC agents auto-load BMAD artifacts (story AC, PRD, arch) if `_bmad-output/` exists.

## HARD RULES

Iron Law (no code without failing test) · 3-Fix Limit (3 fails = escalate) · Evidence Gate (no "should work") · Prod build before merge · Research first (GitHub → Context7 → Exa) · Immutability · Korean bilingual issues · No hardcoded secrets

---

# PAGE 2 — REFERENCE & LOOKUP

## COMMANDS (15)

| Command | What | When |
|---------|------|------|
| `/plan` | Requirements → risks → plan. Waits for confirm. | Before feature work |
| `/tdd` | Tests FIRST → impl → 80%+ coverage | Every feature/bug |
| `/code-review` | Quality + security review | After writing code |
| `/build-fix` | Fix build/type errors | Build breaks |
| `/e2e` | Playwright E2E with artifacts | Critical flows |
| `/brainstorm` | Socratic Q&A → design doc | Unclear scope |
| `/team` | Coordinated multi-agent pool | Multi-file refactors |
| `/ultrawork` | Parallel dispatch (fastest) | Parallel reviews |
| `/autopilot` | Autonomous end-to-end | Full-AC stories |
| `/refactor-clean` | Dead code, dedup | Post-feature |
| `/test-coverage` | Coverage report | Before PR |
| `/update-docs` `/update-codemaps` | Sync docs, regen maps | After changes |
| `/learn` | Extract patterns | End of session |
| `/sync-sprint` | BMAD → TickTick + Obsidian | Daily standup |

## AGENTS

**Custom (Layer 4 — always win):** `planner` · `architect` · `tdd-guide` · `code-reviewer` · `security-reviewer` · `build-error-resolver` · `e2e-runner` · `refactor-cleaner` · `doc-updater`

**OMC (Layer 2 — 15 unique):** `analyst` · `critic` · `debugger` · `designer` · `executor` · `explore` · `git-master` · `qa-tester` · `scientist` · `tracer` · `verifier` · `writer` · `code-simplifier` · `document-specialist` · `test-engineer`

## SKILLS (cherry-picked, Layer 3)

**Superpowers:** `brainstorming` · `subagent-driven-development` · `dispatching-parallel-agents` · `using-git-worktrees` · `verification-before-completion` · `receiving-code-review` · `writing-skills`

**OMC:** `deep-interview` (ambiguity scoring ≤20%) · `ralplan` (Planner/Architect/Critic) · `ultraqa` (5-iteration QA) · `visual-verdict` (screenshot diff)

## BMAD WORKFLOWS — `~/Development/_bmad/bmm/workflows/`

| Phase | Workflows |
|-------|-----------|
| Analysis | `bmad-quick-flow` · `research` |
| Planning | `create-prd` · `bmad-create-ux-design` |
| Solutioning | `bmad-create-architecture` · `bmad-create-epics-and-stories` |
| Implementation | `bmad-sprint-planning` · `bmad-create-story` · `bmad-dev-story` · `bmad-code-review` · `bmad-sprint-status` · `bmad-retrospective` |

Invoke: `"Run the BMAD workflow at ~/Development/_bmad/bmm/workflows/<path>"`

## EXTERNAL TOOLS

| Tool | Command | Use |
|------|---------|-----|
| Gemini | `gemini` | Complex issues, plan review |
| OpenCode | `opencode run "prompt"` | Alt plan (never without `run`) |
| Context7 | `get-library-docs` | Live API docs |
| Serena | `find_symbol` | Code navigation |
| NotebookLM | `notebook_query` (MCP) | Knowledge base |
| infra-gateway | `search_code` `execute_sql` (MCP) | GitHub, DB |

## CROSS-REPO MAP

`pmi-workspace` (BRS frontend) · `pmi-authorization` (SSO, RBAC, Keycloak) · `pmi-microservice` (gateway, services) · `pmi-common` (shared DTOs) · `pmi-infra-repo` (Helm, Argo CD) · `pmi-backoffice` (compliance) · `pmi-web` (legacy)

## PLUGIN STACK

```
Layer 4 (WIN): User Custom — 9 agents, 15 commands, 12 rules
Layer 3:       Cherry-Picked — 7 SP skills, 4 OMC skills
Layer 2:       Plugins — ECC + OMC (15 agents) + Superpowers
Layer 1:       Claude Defaults
```

**Keys:** `Option+T` thinking · `Ctrl+O` verbose · `Esc` cancel · `/fast` toggle fast mode

---
*v2026-04-10 · 2-page A4 landscape · `~/Development/claude-config/docs/wall-reference.md`*
