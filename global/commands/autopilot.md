---
description: Autonomous end-to-end execution from concept to tested code. Full lifecycle with QA validation. From OMC.
---

# Autopilot Command

This command invokes the **autopilot** execution mode from oh-my-claudecode for autonomous end-to-end development.

## What This Command Does

1. **Phase 0 - Expand** - Expand vague input into concrete requirements
2. **Phase 1 - Plan** - Create implementation plan with file paths and steps
3. **Phase 2 - Execute** - Implement via parallel agents (Ralph + Ultrawork)
4. **Phase 3 - QA** - Run QA cycling until tests pass
5. **Phase 4 - Validate** - Multi-perspective validation
6. **Phase 5 - Cleanup** - Final cleanup and commit

## When to Use

Use `/autopilot` when:
- The task has **complete constraints up front** (all AC in the BMAD story, no unknowns)
- You want fully autonomous development from concept to deployment
- You trust the pipeline to handle planning, implementation, and QA

## When NOT to Use

- Requirements are evolving or you expect to add constraints mid-flight — use `/brainstorm` first
- Task touches multiple repos (e.g., auth changes spanning pmi-authorization + BRS-client)
- Security-sensitive changes that need human review at each step

## How It Differs from Other Modes

| Mode | Human Involvement | Best For |
|------|------------------|----------|
| `/autopilot` | Minimal (set and forget) | Well-defined features |
| `/team` | Moderate (task claiming) | Coordinated multi-agent work |
| `/ultrawork` | Minimal (parallel dispatch) | Independent parallel tasks |
| `/plan` + `/tdd` | High (step-by-step) | Complex or risky changes |

## Recommended Pipeline

For maximum quality on vague requests:
```
/brainstorm -> /autopilot
```

Or the full 3-stage pipeline:
```
deep-interview -> ralplan -> autopilot
```

## Key Rules

- Autopilot includes QA cycling (up to 5 iterations)
- Multi-perspective validation catches issues humans might miss
- If input is too vague, autopilot may redirect to deep-interview
- Always review the output before pushing to remote

## Context Reset Between Phases

Autopilot spans multiple workflow phases (Expand → Plan → Execute → QA → Validate → Cleanup). Between each phase transition, compact context to preserve decisions while discarding exploration artifacts. See [context-handoffs.md](../rules/common/context-handoffs.md) for the phase transition protocol.

For parallel execution in Phase 2, use `isolation: "worktree"` per agent to prevent file conflicts.

## Integration

- Use `/brainstorm` first if requirements are unclear
- Use `deep-interview` for mathematically-validated requirement clarity
- Autopilot can receive specs from deep-interview or ralplan

## Source

From [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) execution mode: `autopilot`
