#!/bin/zsh
# Install/register MCP servers for Claude Code
# Usage: zsh ~/.dotfiles/.claude/install-mcp.sh [personal|work]
#
# Required environment variables (personal only):
#   FIGMA_API_KEY       — Figma API key
#   DD_API_KEY          — Datadog API key
#   DD_APPLICATION_KEY  — Datadog Application key

set -e

HOST_TYPE="${1:-personal}"
CLAUDE_JSON="$HOME/.claude.json"

is_registered() {
  local name="$1"
  python3 -c "
import json, sys
with open('$CLAUDE_JSON') as f:
    d = json.load(f)
sys.exit(0 if '$name' in d.get('mcpServers', {}) else 1)
" 2>/dev/null
}

add_mcp_http() {
  local name="$1"
  local url="$2"
  shift 2
  if is_registered "$name"; then
    echo "[$name] already registered, skipping"
  else
    claude mcp add --transport http "$name" "$url" "$@"
    echo "[$name] registered (HTTP)"
  fi
}

add_mcp_stdio() {
  local name="$1"
  shift
  if is_registered "$name"; then
    echo "[$name] already registered, skipping"
  else
    claude mcp add "$name" -- "$@"
    echo "[$name] registered (stdio)"
  fi
}

echo "Installing MCP servers (${HOST_TYPE})..."

# === 共通 ===
add_mcp_stdio "drawio" npx @drawio/mcp

# === personal のみ ===
if [[ "$HOST_TYPE" == "personal" ]]; then
  add_mcp_http  "clickup" "https://mcp.clickup.com/mcp"
  add_mcp_http  "sentry"  "https://mcp.sentry.dev/mcp"
  add_mcp_http  "notion"  "https://mcp.notion.com/mcp"
  add_mcp_stdio "next-devtools" npx next-devtools-mcp@latest
  add_mcp_stdio "auth0" npx -y @auth0/auth0-mcp-server run

  # Figma（FIGMA_API_KEY 必須）
  if [[ -n "$FIGMA_API_KEY" ]]; then
    if is_registered "figma"; then
      echo "[figma] already registered, skipping"
    else
      claude mcp add figma -e FIGMA_API_KEY="$FIGMA_API_KEY" -- npx -y figma-developer-mcp --stdio
      echo "[figma] registered (stdio)"
    fi
  else
    echo "[figma] skipped (FIGMA_API_KEY not set)"
  fi

  # Datadog（DD_API_KEY, DD_APPLICATION_KEY 必須）
  if [[ -n "$DD_API_KEY" && -n "$DD_APPLICATION_KEY" ]]; then
    if is_registered "datadog"; then
      echo "[datadog] already registered, skipping"
    else
      claude mcp add --transport http "datadog" \
        "https://mcp.ap1.datadoghq.com/api/unstable/mcp-server/mcp?toolsets=core,apm,alerting,dbm,synthetics" \
        -h DD_API_KEY="$DD_API_KEY" \
        -h DD_APPLICATION_KEY="$DD_APPLICATION_KEY"
      echo "[datadog] registered (HTTP)"
    fi
  else
    echo "[datadog] skipped (DD_API_KEY or DD_APPLICATION_KEY not set)"
  fi
fi

echo ""
echo "Done."
