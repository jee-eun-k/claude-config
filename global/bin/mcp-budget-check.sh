#!/usr/bin/env bash
set -euo pipefail

# MCP Server Budget Check
# Counts MCP servers across all tiers and warns if over budget.
# Budget: Tier 1 (gateway) <= 5, Tier 2 (global) <= 2, Tier 3 (project) <= 5, Total <= 10

CLAUDE_JSON="$HOME/.claude.json"
GLOBAL_SETTINGS="$HOME/.claude/settings.json"

tier1_count=0
tier2_count=0
tier3_count=0

# Tier 1: ~/.claude.json (gateway / inject-mcp servers)
if [ -f "$CLAUDE_JSON" ] && jq -e '.mcpServers' "$CLAUDE_JSON" > /dev/null 2>&1; then
  tier1_count=$(jq '.mcpServers | keys | length' "$CLAUDE_JSON")
fi

# Tier 2: ~/.claude/settings.json (global settings)
if [ -f "$GLOBAL_SETTINGS" ] && jq -e '.mcpServers' "$GLOBAL_SETTINGS" > /dev/null 2>&1; then
  tier2_count=$(jq '.mcpServers | keys | length' "$GLOBAL_SETTINGS")
fi

# Tier 3: project .mcp.json (current directory)
if [ -f ".mcp.json" ] && jq -e '.mcpServers' ".mcp.json" > /dev/null 2>&1; then
  tier3_count=$(jq '.mcpServers | keys | length' ".mcp.json")
fi

total=$((tier1_count + tier2_count + tier3_count))

echo "MCP Server Budget Report"
echo "========================"
echo ""
echo "Tier 1 (gateway ~/.claude.json):      $tier1_count / 5"
echo "Tier 2 (global settings.json):        $tier2_count / 2"
echo "Tier 3 (project .mcp.json):           $tier3_count / 5"
echo "────────────────────────────────────"
echo "Total:                                $total / 10"
echo ""

# Show server names per tier
if [ "$tier1_count" -gt 0 ]; then
  echo "Tier 1 servers:"
  jq -r '.mcpServers | keys[]' "$CLAUDE_JSON" 2>/dev/null | sed 's/^/  - /'
fi
if [ "$tier2_count" -gt 0 ]; then
  echo "Tier 2 servers:"
  jq -r '.mcpServers | keys[]' "$GLOBAL_SETTINGS" 2>/dev/null | sed 's/^/  - /'
fi
if [ "$tier3_count" -gt 0 ]; then
  echo "Tier 3 servers:"
  jq -r '.mcpServers | keys[]' ".mcp.json" 2>/dev/null | sed 's/^/  - /'
fi

echo ""

# Check lazy loading
lazy_load=$(jq -r '.lazyLoadMcpTools // false' "$GLOBAL_SETTINGS" 2>/dev/null)
if [ "$lazy_load" = "true" ]; then
  echo "[ok] lazyLoadMcpTools: enabled"
else
  echo "[warn] lazyLoadMcpTools: DISABLED — enable in settings.json to reduce context usage"
fi

# Warnings
has_warning=false
if [ "$tier1_count" -gt 5 ]; then
  echo "[warn] Tier 1 over budget ($tier1_count > 5)"
  has_warning=true
fi
if [ "$tier2_count" -gt 2 ]; then
  echo "[warn] Tier 2 over budget ($tier2_count > 2)"
  has_warning=true
fi
if [ "$tier3_count" -gt 5 ]; then
  echo "[warn] Tier 3 over budget ($tier3_count > 5)"
  has_warning=true
fi
if [ "$total" -gt 10 ]; then
  echo "[warn] Total MCP servers over budget ($total > 10) — AI tool selection degrades above 10"
  has_warning=true
fi

if [ "$has_warning" = false ]; then
  echo "[ok] All tiers within budget"
fi
