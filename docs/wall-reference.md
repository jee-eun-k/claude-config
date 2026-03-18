# Claude Dev Environment — Wall Reference

> A3 / 11x17 landscape. 3-column layout. Full details: `tooling-guide.md`

<!--
  PRINT LAYOUT (landscape):
  ┌─────────────────────┬──────────────────────┬────────────────────┐
  │  COLUMN 1           │  COLUMN 2            │  COLUMN 3          │
  │  WHAT DO I DO?      │  WORKFLOW CHAINS      │  REFERENCE         │
  │  + ERROR RECOVERY   │  + POST-FEATURE       │  + ESCAPE HATCHES  │
  └─────────────────────┴──────────────────────┴────────────────────┘
-->

---

## WHAT DO I DO?

### Start Here — Situation -> Action

| I have a...                  | Do this                                              |
|------------------------------|------------------------------------------------------|
| **Small feature** (1-3 files)| `/plan` -> `/tdd` -> `/code-review` -> commit        |
| **Bug fix**                  | Describe bug -> `/tdd` (failing test FIRST) -> `/code-review` |
| **Build broken**             | `/build-fix`                                         |
| **UI change**                | `/plan` -> `/tdd` -> `/e2e`                          |
| **Unclear scope**            | BMAD `quick-flow`                                    |
| **New epic**                 | BMAD `create-prd` -> `create-architecture` -> stories|
| **Security concern**         | "Run security-reviewer on [module]"                  |
| **Unfamiliar codebase**      | Serena: `find_symbol` / `get_symbols_overview`       |
| **Before merging**           | `/build-fix` -> `/refactor-clean` -> `/e2e`          |
| **New repo onboarding**      | BMAD `document-project`                              |

### When Things Go Wrong

| Problem                        | Recovery                                           |
|--------------------------------|----------------------------------------------------|
| Tests keep failing             | Read error, fix impl (not tests), `/tdd` again     |
| Build broken after changes     | `/build-fix` -> `/code-review`                     |
| Code review found CRITICALs    | Fix ALL critical issues -> `/code-review` again    |
| Going in circles               | `gemini "describe problem + what you tried"`       |
| Lost context / big codebase    | `/update-codemaps` -> re-read architecture         |

---

## WORKFLOW CHAINS

### Daily Coding

```
MORNING     BMAD sprint-status -> pick a story

CODING      /plan -> /tdd -> /code-review -> commit
            (repeat per story)

PRE-MERGE   /build-fix (if needed) -> /refactor-clean -> /e2e
```

### Epic Path (scope unclear or multi-session)

**Quick solo path:**
```
BMAD tech-spec -> BMAD quick-dev -> /tdd -> /code-review
```

**Full ceremony:**
```
create-prd
  -> create-architecture
    -> create-epics-and-stories
      -> (per story) /plan -> /tdd -> /code-review -> BMAD code-review
        -> retrospective
```

### Post-Feature Checklist

```
1. /update-docs          Sync README, CONTRIB, RUNBOOK
2. /update-codemaps      Regenerate architecture maps
3. /refactor-clean       Remove dead code
4. /e2e                  Verify critical user flows
5. commit & push
```

---

## REFERENCE

### Rules Always On

| Rule                                        | Enforced By                     |
|---------------------------------------------|---------------------------------|
| Immutability — never mutate, always copy    | `/code-review`                  |
| TDD mandatory — test first, 80%+ coverage  | `/tdd` RED-GREEN-REFACTOR       |
| No hardcoded secrets                        | Security reviewer + hooks       |
| Conventional commits (`feat:`, `fix:`, ...) | Git workflow rules              |
| Validate at system boundaries               | `/code-review`                  |
| Small files (200-400 lines, 800 max)        | `/code-review` + `/refactor-clean` |
| Research before coding                      | GitHub -> Context7 docs -> Exa  |

### Escape Hatches

| When                    | Use                                    |
|-------------------------|----------------------------------------|
| Complex problem / stuck | `gemini "describe the problem"`        |
| Need live library docs  | Ask for `get-library-docs` (Context7)  |
| Symbol/reference lookup | Serena `find_symbol`, `find_referencing_symbols` |
| Architecture question   | "Run architect on [decision]"          |
| Learn from this session | `/learn` -> saves to `~/.claude/skills/learned/` |
| End of epic             | BMAD `retrospective`                   |

### Background Tools (auto, no action needed)

`infra-gateway` (GitHub, DB, search) · `Serena` (code nav) · `NotebookLM` (research) · `Context7` (docs)

---

BMAD invoke: "Run the BMAD workflow at `~/_bmad/bmm/workflows/<name>`"

*v2025-03-18 — source: `~/Development/claude-config/docs/wall-reference.md`*
