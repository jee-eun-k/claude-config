# BMAD-ECC Auto-Integration

When BMAD workflows complete, automatically chain the appropriate ECC agents.
When ECC agents run, check for BMAD artifacts to enrich context.
See the `tooling-guide` skill (loaded on demand) for tool selection and invocation patterns.

## Security-Sensitive Patterns

A change is **security-sensitive** if it touches: authentication, authorization,
session handling, API endpoints, user input parsing, tokens/secrets, file uploads,
payment/financial logic, or database queries with user-supplied values.

## Forward: BMAD Completion → ECC Agent

### After dev-story completes (story status → "review")

- **MUST** invoke `/code-review` on all files listed in the story's File List section
- If changes are security-sensitive, **MUST** also invoke `security-reviewer`
- Pass the story file path so code-reviewer can validate against acceptance criteria

### After BMAD code-review completes (findings presented)

- If `intent_gap` findings exist → suggest `/plan` to clarify requirements
- If `bad_spec` findings with architecture implications → suggest `architect` review
- If any security-related `patch` findings → **MUST** invoke `security-reviewer`

### After create-story completes (status → "ready-for-dev")

- **SHOULD** invoke `/plan` to pre-create an implementation plan from story AC
- If story is security-sensitive → flag for `security-reviewer` pre-flight check

### After create-architecture completes (status → "complete")

- **SHOULD** invoke `architect` agent to validate decisions against codebase reality
- **SHOULD** invoke `security-reviewer` on security architecture sections

### After quick-dev completes ("Ready to commit")

- **MUST** invoke `/code-review` on all changed files (use git diff)
- If changes are security-sensitive, **MUST** also invoke `security-reviewer`

### After sprint-planning completes

- **SHOULD** invoke `/plan` for high-level cross-story dependency mapping

## Reverse: ECC Agent → BMAD Context Enrichment

When an ECC agent runs, check for and load relevant BMAD artifacts **if they exist**.
Skip silently if artifacts are missing (project may not use BMAD).

| ECC Agent | BMAD Artifact to Check | Use It For |
|-----------|----------------------|------------|
| `code-reviewer` | Active story file (status "review" or "in-progress") | Validate against acceptance criteria |
| `tdd-guide` | Active story file | Derive test cases from acceptance criteria |
| `planner` | `_bmad-output/planning-artifacts/` (PRD, architecture, stories) | Anchor plan to existing requirements |
| `architect` | `_bmad-output/planning-artifacts/architecture.md` | Validate against existing decisions |
| `security-reviewer` | Architecture doc security sections | Check against documented security requirements |
| `e2e-runner` | Active story file | Map acceptance criteria to E2E test scenarios |

## Artifact Discovery

- Planning artifacts: `{project-root}/_bmad-output/planning-artifacts/`
- Implementation artifacts: `{project-root}/_bmad-output/implementation-artifacts/`
- Sprint status: `{project-root}/_bmad-output/implementation-artifacts/sprint-status.yaml`
- Active story: first file in implementation-artifacts with status "in-progress" or "review"
- If `_bmad-output/` does not exist, skip all BMAD context enrichment silently
