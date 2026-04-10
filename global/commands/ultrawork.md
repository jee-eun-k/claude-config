---
description: Parallel maximum-throughput execution. Dispatches independent tasks to concurrent workers for fastest completion. From OMC.
---

# Ultrawork Command

This command invokes the **ultrawork** execution mode from oh-my-claudecode for parallel maximum-throughput execution.

## What This Command Does

1. **Parse tasks** - Identify independent work items from the request
2. **Dispatch workers** - Launch parallel agents for each independent task
3. **Monitor** - Track progress across all workers
4. **Integrate** - Merge results and verify no conflicts

## When to Use

Use `/ultrawork` when:
- You have multiple independent tasks that can run concurrently
- Speed is the priority over coordination overhead
- Tasks don't share state or edit the same files
- You want maximum parallelization

## How It Differs from /team

| Aspect | /team | /ultrawork |
|--------|-------|------------|
| Coordination | Shared task pool with claiming | Independent dispatch |
| Pipeline | plan -> prd -> exec -> verify -> fix | Direct parallel dispatch |
| Best for | Coordinated multi-agent work | Maximum throughput on independent tasks |
| Overhead | Higher (coordination) | Lower (fire-and-forget) |

## Key Rules

- Tasks MUST be independent (no shared files, no shared state)
- Each worker runs in isolation
- Verify no conflicts after workers complete
- Run full test suite after integration

## Integration

- Use `/plan` first to identify which tasks are truly independent
- Follow with `/code-review` after all workers complete
- Use `/ultrawork` for investigation tasks (debugging multiple subsystems)

## Source

From [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) execution mode: `ultrawork`
