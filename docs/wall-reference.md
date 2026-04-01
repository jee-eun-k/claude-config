> A4 landscape · single page · Full details: `tooling-guide.md` + `bmad-ecc-integration.md`

## SITUATION → ACTION

| I have a...          | Do this                                      |
|----------------------|----------------------------------------------|
| Small feature        | `/plan` → `/tdd` → `/code-review` → commit  |
| Bug fix              | `/tdd` (failing test FIRST) → `/code-review` |
| Build broken         | `/build-fix`                                 |
| UI change            | `/plan` → `/tdd` → `/e2e`                   |
| Unclear scope        | BMAD `quick-flow`                            |
| New epic             | BMAD `create-prd` → `create-arch` → stories |
| Security concern     | "Run security-reviewer on [module]"          |
| Before merging       | `/build-fix` → `/refactor-clean` → `/e2e`   |
| Unfamiliar codebase  | Serena `find_symbol` / BMAD `document-project` |

## WORKFLOW CHAINS

**Daily:** `sprint-status` → `/plan` → `/tdd` → `/code-review` → commit · **Pre-merge:** `/build-fix` → `/refactor-clean` → `/e2e`
**Quick solo:** BMAD `tech-spec` → `quick-dev` → `/code-review` · **Post-feature:** `/update-docs` → `/update-codemaps` → `/refactor-clean` → `/e2e`
**Full epic:** `create-prd` → `create-arch` → `create-stories` → _(per story)_ `/plan` → `/tdd` → `/code-review` → BMAD `code-review` → `retrospective`

## ERROR RECOVERY

| Problem              | Recovery                                     |
|----------------------|----------------------------------------------|
| Tests keep failing   | Read error, fix impl not tests, `/tdd` again |
| Build broken         | `/build-fix` → `/code-review`               |
| CRITICALs in review  | Fix all → `/code-review` again              |
| Going in circles     | `gemini "problem + what tried"`              |
| Lost context         | `/update-codemaps` → re-read architecture    |

## BMAD ↔ ECC AUTO-CHAINING

| BMAD completes...         | ECC auto-runs                                          |
|---------------------------|--------------------------------------------------------|
| `dev-story` → "review"   | **MUST** `/code-review` + security if sensitive        |
| `quick-dev` → commit     | **MUST** `/code-review` + security if sensitive        |
| `code-review` findings   | `/plan` (gaps) · `architect` (bad spec) · `security` (patches) |
| `create-story` → ready   | SHOULD `/plan` pre-flight                              |
| `create-architecture`    | SHOULD `architect` + `security-reviewer`               |
| `sprint-planning`        | SHOULD `/plan` dependency map                          |

**Reverse:** ECC agents auto-load BMAD artifacts (story AC, PRD, arch) if `_bmad-output/` exists.

## RULES ALWAYS ON

Immutability (never mutate) · TDD mandatory (80%+) · No hardcoded secrets · Conventional commits · BMAD-ECC auto-chain · Validate at boundaries · Small files (800 max) · Research before coding (GitHub → Context7 → Exa)

## ESCAPE HATCHES

Complex/stuck: `gemini` · Live docs: `get-library-docs` (Context7) · Symbol lookup: Serena `find_symbol` · Arch question: `architect` agent · Learn: `/learn` · End of epic: BMAD `retrospective`

**Background (auto):** `infra-gateway` · `Serena` · `NotebookLM` · `Context7` — BMAD invoke: "Run the BMAD workflow at `~/_bmad/bmm/workflows/<name>`"

---
*v2026-04-01 · A4 landscape · `~/Development/claude-config/docs/wall-reference.md`*
