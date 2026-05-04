#!/usr/bin/env bash
# Unified tool observer: audit logging + execution trace capture
# Called as a PostToolUse hook. Reads hook JSON from stdin.
#
# Kill switches (env vars, default: true):
#   CLAUDE_AUDIT_ENABLED=false  — disable audit logging
#   CLAUDE_TRACE_ENABLED=false  — disable trace capture
#
# Output:
#   $TMPDIR/claude-audit-YYYYMMDD.jsonl  — security events (Write/Edit/Bash only)
#   $TMPDIR/claude-trace-YYYYMMDD.jsonl  — all tool invocations

input=$(cat)

# Kill switches
audit_enabled="${CLAUDE_AUDIT_ENABLED:-true}"
trace_enabled="${CLAUDE_TRACE_ENABLED:-true}"

if [ "$audit_enabled" = "false" ] && [ "$trace_enabled" = "false" ]; then
  echo "$input"
  exit 0
fi

# Extract fields from hook JSON
tool_name=$(echo "$input" | jq -r '.tool_name // .tool // "unknown"')
timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
date_str=$(date +%Y%m%d)

# Extract file_path or command (truncated to 200 chars)
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null)
command=$(echo "$input" | jq -r '.tool_input.command // empty' 2>/dev/null | head -c 200)
exit_code=$(echo "$input" | jq -r '.tool_output.exit_code // .exit_code // "0"' 2>/dev/null)

# Build identifier
if [ -n "$file_path" ]; then
  identifier="$file_path"
elif [ -n "$command" ]; then
  identifier="$command"
else
  identifier=""
fi

# Trace: all tools
if [ "$trace_enabled" = "true" ]; then
  trace_file="${TMPDIR}/claude-trace-${date_str}.jsonl"
  printf '{"ts":"%s","tool":"%s","target":"%s","exit":%s}\n' \
    "$timestamp" "$tool_name" "$identifier" "${exit_code:-0}" >> "$trace_file"
fi

# Audit: security-relevant tools only (Write, Edit, Bash)
if [ "$audit_enabled" = "true" ]; then
  case "$tool_name" in
    Write|Edit|Bash)
      audit_file="${TMPDIR}/claude-audit-${date_str}.jsonl"
      printf '{"ts":"%s","tool":"%s","target":"%s","exit":%s}\n' \
        "$timestamp" "$tool_name" "$identifier" "${exit_code:-0}" >> "$audit_file"
      ;;
  esac
fi

# Pass through input unchanged
echo "$input"
