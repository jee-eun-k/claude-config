---
description: Multi-agent coordination on shared task list. N coordinated agents claim tasks from a shared pool. From OMC.
---

# Team Command

This command invokes the **team** execution mode from oh-my-claudecode for multi-agent coordination on shared tasks.

## What This Command Does

1. **Plan** - Break work into independent tasks
2. **PRD** - Generate product requirements document
3. **Execute** - Dispatch parallel agents to claim and complete tasks
4. **Verify** - Validate all tasks are complete and passing
5. **Fix** - Loop on any failures until all criteria pass

## When to Use

Use `/team` when:
- Multiple independent tasks can be parallelized
- You want N coordinated agents working on a shared task list
- The work involves multiple subsystems that don't share state
- Speed is important and tasks are well-defined

## How It Works

Team mode dispatches multiple agents that:
- Claim tasks from a shared pool (no duplicate work)
- Work in isolation (no context pollution between agents)
- Report results back to the coordinator
- Trigger re-work if verification fails

## Pipeline

```
plan -> prd -> exec -> verify -> fix (loop)
```

## Key Rules

- Tasks must be independent (no shared state between agents)
- Each agent gets narrow scope and clear deliverables
- Verification runs after all agents complete
- Fix loop ensures quality before declaring done

## Integration

- Use `/brainstorm` first if requirements are vague
- Use `/plan` first if tasks need detailed breakdown
- Combine with `/ultrawork` for maximum throughput on independent tasks

## Source

From [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) execution mode: `team`
