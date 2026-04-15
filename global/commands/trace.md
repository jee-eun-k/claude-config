---
description: View and analyze tool execution traces from the current session
---

# /trace - Execution Trace Viewer

View tool invocation traces captured by the `tool-observer.sh` PostToolUse hook.

## Usage

When the user runs `/trace`, check for today's trace file and present a summary.

## Steps

1. Check if trace file exists: `$TMPDIR/claude-trace-$(date +%Y%m%d).jsonl`
2. If not found, inform user that tracing may be disabled (`CLAUDE_TRACE_ENABLED=false`) or no tools have been used yet
3. If found, present:
   - Total tool invocations
   - Tool usage breakdown (count per tool type)
   - Last 10 invocations
4. Offer filtering options:
   - By tool: `jq 'select(.tool == "Bash")' < $TMPDIR/claude-trace-*.jsonl`
   - By target: `jq 'select(.target | contains("some-file"))' < $TMPDIR/claude-trace-*.jsonl`
   - Errors only: `jq 'select(.exit != 0)' < $TMPDIR/claude-trace-*.jsonl`

## Audit Log

Security audit events (Write/Edit/Bash only) are in a separate file:
`$TMPDIR/claude-audit-$(date +%Y%m%d).jsonl`

## Configuration

- `CLAUDE_TRACE_ENABLED=true/false` — toggle trace capture
- `CLAUDE_AUDIT_ENABLED=true/false` — toggle audit logging
- Both default to `true` when `tool-observer.sh` is registered as a hook
