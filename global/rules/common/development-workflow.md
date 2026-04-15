# Development Workflow

> This file extends [common/git-workflow.md](./git-workflow.md) with the full feature development process that happens before git operations.

The Feature Implementation Workflow describes the development pipeline: research, planning, TDD, code review, and then committing to git. For context management between phases, see [context-handoffs.md](./context-handoffs.md).

## Feature Implementation Workflow

0. **Research & Reuse** _(mandatory before any new implementation)_
   - **GitHub code search first:** Run `gh search repos` and `gh search code` to find existing implementations, templates, and patterns before writing anything new.
   - **Library docs second:** Use Context7 or primary vendor docs to confirm API behavior, package usage, and version-specific details before implementing.
   - **Exa only when the first two are insufficient:** Use Exa for broader web research or discovery after GitHub search and primary docs.
   - **Check package registries:** Search npm, PyPI, crates.io, and other registries before writing utility code. Prefer battle-tested libraries over hand-rolled solutions.
   - **Search for adaptable implementations:** Look for open-source projects that solve 80%+ of the problem and can be forked, ported, or wrapped.
   - Prefer adopting or porting a proven approach over writing net-new code when it meets the requirement.

1. **Brainstorm** _(new — from Superpowers)_
   - Use `/brainstorm` for unclear or creative requirements
   - Socratic questioning: one question at a time
   - Propose 2-3 approaches with trade-offs
   - Present design in sections, get approval after each
   - Write design doc and commit before proceeding
   - **Hard gate**: NO implementation until design is user-approved

2. **Plan First**
   - Use **planner** agent to create implementation plan
   - Consult Gemini (`gemini`) and OpenCode (`opencode run "prompt"`) during planning, not after
   - Generate planning docs before coding: PRD, architecture, system_design, tech_doc, task_list
   - Identify dependencies and risks — **including cross-repo dependencies** (e.g., auth changes in pmi-authorization affecting BRS-client)
   - Break down into granular 2-5 minute tasks with exact file paths
   - For complex/vague tasks, use `deep-interview` (OMC) for mathematical ambiguity scoring
   - For consensus planning, use `ralplan` (OMC) for Planner/Architect/Critic validation

3. **TDD Approach**
   - Use **tdd-guide** agent
   - **Iron Law**: NO production code without a failing test first
   - Write tests first (RED)
   - Implement to pass tests (GREEN)
   - Refactor (IMPROVE)
   - Verify 80%+ coverage
   - **3-Fix Limit**: If 3 debugging attempts fail, escalate — it's an architecture problem

4. **Dev (Parallel Agents)** _(new — from OMC + Superpowers)_
   - For independent tasks: use `/team` or `/ultrawork` for parallel execution
   - For autonomous execution: use `/autopilot` (concept to tested code)
   - For subagent-driven development: dispatch implementer per task with two-stage review
   - Each agent gets narrow scope, clear deliverables, isolated context

5. **Code Review**
   - Use **code-reviewer** agent immediately after writing code
   - Follow READ → UNDERSTAND → VERIFY → EVALUATE → RESPOND → IMPLEMENT protocol
   - Address Critical and Important issues
   - Fix Minor issues when possible

6. **Verification** _(new — from Superpowers)_
   - **Evidence before claims, always**
   - Run verification command FRESH before claiming completion
   - No "should pass", "probably works", or "seems correct"
   - For QA cycling: use `ultraqa` (OMC) for automated test/verify/fix loops
   - **Production build gate**: If PR adds new pages, env var usage, npm packages, or Docker changes — run `npm run build && node .next/standalone/server.js` (or equivalent) locally before claiming done. `next dev` is NOT proof — it skips tree-shaking, route exclusion, and build-time env inlining.

7. **Commit & Push**
   - Detailed commit messages
   - Follow conventional commits format
   - See [git-workflow.md](./git-workflow.md) for commit message format and PR process

## Error Recovery

When an error occurs during implementation:
1. **Stop** — do not auto-fix or retry blindly
2. **Analyze** — summarize current state (`git status`, file state, error output)
3. **Report** — explain where and why things went wrong
4. **Propose** — suggest recovery steps and let the user decide

Destructive recovery commands (`git reset`, `git restore`, `rm -rf`) are proposed only — the user executes them manually.
