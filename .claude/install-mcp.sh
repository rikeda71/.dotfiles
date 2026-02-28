#!/bin/zsh
# Install/register MCP servers for Claude Code
# Run: zsh ~/.dotfiles/.claude/install-mcp.sh
#
# NOTE: figma is excluded because it requires FIGMA_API_KEY.
# Register manually:
#   claude mcp add figma -e FIGMA_API_KEY="your-key" -- npx -y figma-developer-mcp --stdio

set -e

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
  if is_registered "$name"; then
    echo "[$name] already registered, skipping"
  else
    claude mcp add --transport http "$name" "$url"
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

echo "Installing MCP servers..."

add_mcp_http  "clickup"       "https://mcp.clickup.com/mcp"
add_mcp_http  "sentry"        "https://mcp.sentry.dev/mcp"
add_mcp_stdio "drawio"        npx @drawio/mcp
add_mcp_stdio "next-devtools" npx next-devtools-mcp@latest

echo ""
echo "Done. To add figma MCP with your API key, run:"
echo "  claude mcp add figma -e FIGMA_API_KEY=\"your-key\" -- npx -y figma-developer-mcp --stdio"
