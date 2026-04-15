#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GLOBAL_DIR="$HOME/.claude"
WORKSPACE_DIR="$HOME/Development/.claude"
BMAD_DIR="$HOME/Development/_bmad"
EVERYTHING_CC_DIR="$HOME/Development/everything-claude-code"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# ─── helpers ──────────────────────────────────────────────────────────────────

log()  { echo "  $*"; }
ok()   { echo "  [ok] $*"; }
warn() { echo "  [warn] $*" >&2; }

# Back up a file or directory, then replace it with a symlink
# Usage: make_symlink <real_path> <link_target>
make_symlink() {
  local real_path="$1"   # path that should become (or already is) a symlink
  local link_target="$2" # what the symlink should point to

  if [ -L "$real_path" ]; then
    local current_target
    current_target="$(readlink "$real_path")"
    if [ "$current_target" = "$link_target" ]; then
      ok "Already linked: $real_path"
      return 0
    else
      warn "Relinking: $real_path (was → $current_target)"
      rm "$real_path"
    fi
  elif [ -e "$real_path" ]; then
    local backup="${real_path}.backup.$TIMESTAMP"
    log "Backing up: $real_path → $backup"
    mv "$real_path" "$backup"
  fi

  mkdir -p "$(dirname "$real_path")"
  ln -s "$link_target" "$real_path"
  ok "Linked: $real_path → $link_target"
}

# ─── subcommands ──────────────────────────────────────────────────────────────

cmd_links_only() {
  echo ""
  echo "── global (~/.claude) ────────────────────────────────────────────────"

  make_symlink "$GLOBAL_DIR/CLAUDE.md"             "$REPO_DIR/global/CLAUDE.md"
  make_symlink "$GLOBAL_DIR/settings.json"         "$REPO_DIR/global/settings.json"
  make_symlink "$GLOBAL_DIR/settings.local.json"   "$REPO_DIR/global/settings.local.json"
  make_symlink "$GLOBAL_DIR/agents"                "$REPO_DIR/global/agents"
  make_symlink "$GLOBAL_DIR/rules"                 "$REPO_DIR/global/rules"
  make_symlink "$GLOBAL_DIR/commands"              "$REPO_DIR/global/commands"
  make_symlink "$GLOBAL_DIR/hooks/hooks.json"      "$REPO_DIR/global/hooks/hooks.json"
  make_symlink "$GLOBAL_DIR/bin/codeagent-wrapper" "$REPO_DIR/global/bin/codeagent-wrapper"
  make_symlink "$GLOBAL_DIR/bin/mcp-budget-check.sh" "$REPO_DIR/global/bin/mcp-budget-check.sh"
  make_symlink "$GLOBAL_DIR/bin/tool-observer.sh"    "$REPO_DIR/global/bin/tool-observer.sh"
  make_symlink "$GLOBAL_DIR/skills/superpowers"    "$REPO_DIR/global/skills/superpowers"
  make_symlink "$GLOBAL_DIR/skills/omc"            "$REPO_DIR/global/skills/omc"

  echo ""
  echo "── workspace (~/Development/.claude) ────────────────────────────────"

  # NOTE: agents/ and commands/ are NOT symlinked at workspace level.
  # Global symlinks (~/.claude/agents, ~/.claude/commands) are the single source of truth.
  # Workspace copies were removed in Epic 3, Story 3-1 to prevent drift.
  make_symlink "$WORKSPACE_DIR/hooks/hooks.json"    "$REPO_DIR/workspace/hooks/hooks.json"
  make_symlink "$WORKSPACE_DIR/mcp-configs"         "$REPO_DIR/workspace/mcp-configs"
  make_symlink "$WORKSPACE_DIR/settings.local.json" "$REPO_DIR/workspace/settings.local.json"
  # NOTE: Do NOT symlink rules/ or skills/ — the workspace repo has its own tracked copies

  echo ""
  echo "── bmad (~/Development/_bmad) ────────────────────────────────────────"

  make_symlink "$BMAD_DIR" "$REPO_DIR/bmad"

  echo ""
  echo "── mcp-gw submodule ──────────────────────────────────────────────────"
  if [ -d "$REPO_DIR/mcp-gw/.git" ] || [ -f "$REPO_DIR/mcp-gw/.git" ]; then
    ok "mcp-gw submodule already initialized"
  else
    log "Initializing mcp-gw submodule..."
    git -C "$REPO_DIR" submodule update --init --recursive
    ok "mcp-gw submodule initialized"
  fi

  echo ""
  echo "Done. All symlinks created."
}

cmd_inject_mcp() {
  echo ""
  echo "── inject-mcp ────────────────────────────────────────────────────────"

  local secrets_file="$REPO_DIR/secrets/mcp-servers.local.json"
  local claude_json="$HOME/.claude.json"

  if [ ! -f "$secrets_file" ]; then
    echo ""
    echo "ERROR: secrets/mcp-servers.local.json not found."
    echo "  Run: cp mcp-servers.json.template secrets/mcp-servers.local.json"
    echo "  Then fill in all \${PLACEHOLDER} values."
    exit 1
  fi

  if ! jq -e '.mcpServers' "$secrets_file" > /dev/null 2>&1; then
    echo "ERROR: secrets/mcp-servers.local.json is not valid JSON or missing mcpServers key."
    exit 1
  fi

  if [ ! -f "$claude_json" ]; then
    warn "~/.claude.json not found. Launch Claude Code once to create it, then re-run inject-mcp."
    exit 1
  fi

  local backup="$claude_json.backup.$TIMESTAMP"
  cp "$claude_json" "$backup"
  log "Backed up ~/.claude.json → $backup"

  local new_servers
  new_servers="$(jq '.mcpServers' "$secrets_file")"

  jq --argjson servers "$new_servers" '.mcpServers = $servers' "$claude_json" > "${claude_json}.tmp"
  mv "${claude_json}.tmp" "$claude_json"

  ok "mcpServers written to ~/.claude.json"
  echo ""
  echo "Active MCP servers:"
  jq -r '.mcpServers | keys[]' "$claude_json" | sed 's/^/  - /'
}

cmd_clone_extras() {
  echo ""
  echo "── extra repos ───────────────────────────────────────────────────────"

  if [ ! -d "$EVERYTHING_CC_DIR" ]; then
    log "Cloning everything-claude-code..."
    git clone git@github.com:affaan-m/everything-claude-code.git "$EVERYTHING_CC_DIR"
    ok "Cloned everything-claude-code"
  else
    ok "everything-claude-code already present"
  fi

  if [ ! -d "$HOME/Development/ticktick-mcp" ]; then
    warn "ticktick-mcp not found at ~/Development/ticktick-mcp — clone manually if needed"
  else
    ok "ticktick-mcp present"
  fi
}

cmd_clean_backups() {
  echo ""
  echo "── clean backups ─────────────────────────────────────────────────────"

  local count=0
  for item in "$GLOBAL_DIR"/*.backup.* "$GLOBAL_DIR"/*backup*/ \
              "$WORKSPACE_DIR"/*.backup.* "$WORKSPACE_DIR"/*backup*/; do
    if [ -e "$item" ]; then
      rm -rf "$item"
      ok "Removed: $item"
      count=$((count + 1))
    fi
  done

  # Also remove stale ~HEAD symlinks (from failed rules/skills symlink attempts)
  for item in "$WORKSPACE_DIR"/*~HEAD; do
    if [ -L "$item" ]; then
      rm "$item"
      ok "Removed stale symlink: $item"
      count=$((count + 1))
    fi
  done

  if [ "$count" -eq 0 ]; then
    ok "No backups or stale symlinks found"
  else
    echo ""
    echo "Cleaned $count item(s)."
  fi
}

cmd_check_drift() {
  echo ""
  echo "── check drift (rules & skills) ──────────────────────────────────────"
  echo ""
  echo "Comparing shared rules between claude-config and workspace repo."
  echo "Only rules/common/ is compared (both repos maintain this directory)."
  echo ""

  local has_drift=false

  # Compare rules/common/ (shared between both repos)
  if [ -d "$WORKSPACE_DIR/rules/common" ] && [ -d "$REPO_DIR/global/rules/common" ]; then
    local diff_output
    diff_output=$(diff -rq "$REPO_DIR/global/rules/common" "$WORKSPACE_DIR/rules/common" 2>/dev/null || true)
    if [ -n "$diff_output" ]; then
      warn "rules/common/ has drifted:"
      echo "$diff_output" | sed 's/^/    /'
      echo ""
      has_drift=true
    else
      ok "rules/common/ — in sync"
    fi
  else
    warn "One or both rules/common/ directories missing"
  fi

  # Compare language-specific rules that exist in both locations
  for lang_dir in "$REPO_DIR"/global/rules/*/; do
    local lang
    lang="$(basename "$lang_dir")"
    [ "$lang" = "common" ] && continue
    if [ -d "$WORKSPACE_DIR/rules/$lang" ]; then
      local diff_output
      diff_output=$(diff -rq "$lang_dir" "$WORKSPACE_DIR/rules/$lang" 2>/dev/null || true)
      if [ -n "$diff_output" ]; then
        warn "rules/$lang/ has drifted:"
        echo "$diff_output" | sed 's/^/    /'
        echo ""
        has_drift=true
      else
        ok "rules/$lang/ — in sync"
      fi
    fi
  done

  # Check for stale workspace agent/command copies (should not exist)
  if [ -d "$REPO_DIR/workspace/agents" ] && [ -n "$(ls -A "$REPO_DIR/workspace/agents" 2>/dev/null)" ]; then
    warn "workspace/agents/ contains files — these are stale duplicates of global/agents/"
    ls "$REPO_DIR/workspace/agents" | sed 's/^/    /'
    echo ""
    has_drift=true
  else
    ok "workspace/agents/ — clean (no stale duplicates)"
  fi

  if [ -d "$REPO_DIR/workspace/commands" ] && [ -n "$(ls -A "$REPO_DIR/workspace/commands" 2>/dev/null)" ]; then
    warn "workspace/commands/ contains files — these are stale duplicates of global/commands/"
    ls "$REPO_DIR/workspace/commands" | sed 's/^/    /'
    echo ""
    has_drift=true
  else
    ok "workspace/commands/ — clean (no stale duplicates)"
  fi

  echo ""
  if [ "$has_drift" = true ]; then
    echo "Drift detected. Review the differences and merge as needed."
    echo "  Source of truth: $REPO_DIR/global/rules/"
    echo "  Workspace copy:  $WORKSPACE_DIR/rules/"
  else
    echo "No drift detected. All shared rules are in sync."
  fi
}

cmd_plugins() {
  echo ""
  echo "── plugins (OMC + Superpowers) ───────────────────────────────────────"

  if ! command -v claude &> /dev/null; then
    warn "claude CLI not found — install Claude Code first, then re-run plugins"
    return 1
  fi

  log "Installing oh-my-claudecode plugin..."
  claude plugin install oh-my-claudecode && ok "oh-my-claudecode installed" || warn "oh-my-claudecode install failed"

  log "Installing superpowers plugin..."
  claude plugin install superpowers@claude-plugins-official && ok "superpowers installed" || warn "superpowers install failed"

  echo ""
  echo "Plugins installed. Restart Claude Code to activate."
}

cmd_all() {
  cmd_clone_extras
  cmd_links_only
  cmd_inject_mcp
  cmd_plugins
}

# ─── usage ────────────────────────────────────────────────────────────────────

usage() {
  echo "Usage: $0 <command>"
  echo ""
  echo "Commands:"
  echo "  all             Full first-time setup (clone extras + links + inject-mcp + plugins)"
  echo "  links-only      Create symlinks only (safe to re-run)"
  echo "  inject-mcp      Write mcpServers from secrets/ into ~/.claude.json"
  echo "  plugins         Install/update OMC and Superpowers Claude Code plugins"
  echo "  clean-backups   Remove stale .backup.* files and ~HEAD symlinks"
  echo "  check-drift     Compare rules between claude-config and workspace repo"
  echo ""
  echo "Architecture:"
  echo "  claude-config/global/  → symlinked to ~/.claude/ (global user config)"
  echo "  claude-config/workspace/ → partially symlinked to ~/Development/.claude/"
  echo "  Workspace rules/ and skills/ are NOT symlinked — they are maintained"
  echo "  independently in the everything-claude-code repo. Use 'check-drift'"
  echo "  to detect divergence in shared rules."
  echo ""
  echo "New machine workflow:"
  echo "  1. git clone git@github.com:jee-eun-k/claude-config.git ~/Development/claude-config"
  echo "  2. cd ~/Development/claude-config"
  echo "  3. cp mcp-servers.json.template secrets/mcp-servers.local.json"
  echo "  4. # Fill in secrets/mcp-servers.local.json"
  echo "  5. # Copy mcp-gw/.env.example → mcp-gw/.env and fill in"
  echo "  6. ./install.sh all"
  echo "  7. cd ~/Development/mcp-gw && docker compose up -d"
}

# ─── entry point ──────────────────────────────────────────────────────────────

COMMAND="${1:-help}"

case "$COMMAND" in
  all)            cmd_all ;;
  links-only)     cmd_links_only ;;
  inject-mcp)     cmd_inject_mcp ;;
  plugins)        cmd_plugins ;;
  clean-backups)  cmd_clean_backups ;;
  check-drift)    cmd_check_drift ;;
  help|--help)    usage ;;
  *)
    echo "Unknown command: $COMMAND"
    echo ""
    usage
    exit 1
    ;;
esac
