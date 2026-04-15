# Context Window Handoffs

> This file extends [development-workflow.md](./development-workflow.md) with context management protocols between workflow phases.

## Why Context Handoffs Matter

AI context degrades over long sessions. Each workflow phase (Research, Plan, TDD, Dev, Review, Commit) accumulates context that is valuable during that phase but becomes noise in the next. Phase-aware compaction preserves decisions while discarding exploration artifacts.

## Phase Transition Protocol

### When to Compact

Compact at these phase boundaries (not mid-phase):

| From | To | What to Preserve | What to Discard |
|------|----|-----------------|-----------------|
| **Research** | **Plan** | Findings, chosen approach, key URLs | Search results, rejected options, raw docs |
| **Plan** | **TDD** | Task list, file paths, architecture decisions | Planning alternatives, risk analysis details |
| **TDD** | **Dev** | Test file paths, coverage targets, failing test names | Test framework setup, mock boilerplate |
| **Dev** | **Review** | Implementation summary, changed files | Debug logs, intermediate attempts |
| **Review** | **Commit** | Review findings, fix list | Review discussion, minor nits |

### How to Compact

At each boundary:
1. Summarize the phase outcome in 3-5 bullet points
2. Run `/compact` with a custom focus: `/compact "Completed [phase]. Key decisions: [list]. Moving to [next phase]."`
3. If the session is long or complex, write a HANDOFF.md instead (see template below)

### When NOT to Compact

- Mid-implementation (you'll lose variable names, file paths, partial state)
- During active debugging (context is the debugging state)
- When the next phase depends heavily on exploration details from the current phase

## HANDOFF.md Template

For complex tasks or session handoffs, write this to the project root:

```markdown
# Handoff: [Task Name]

## Goal
[One-sentence description of what we're building]

## Decisions Made
- [Decision 1]: [Rationale]
- [Decision 2]: [Rationale]

## Artifacts Produced
- [File path]: [What it contains]
- [File path]: [What it contains]

## Current State
[What phase we're in, what's done, what's next]

## Next Steps
1. [Specific next action with file path]
2. [Specific next action with file path]

## What Didn't Work
- [Approach]: [Why it failed]
```

## Detection Signals

These tool usage patterns suggest a phase transition:

- **Research → Plan**: Shift from Read/Grep/WebSearch to Write/Edit
- **Plan → TDD**: First test file creation
- **TDD → Dev**: Tests passing, shift to production code edits
- **Dev → Review**: Implementation complete, shift to read-only review
- **Review → Commit**: Shift to git commands

The phase-transition hook in hooks.json monitors these patterns and suggests compaction via notification.
