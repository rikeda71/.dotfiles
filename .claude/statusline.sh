#!/bin/zsh
# Claude Code statusline
# Stdin: JSON with model, cwd, transcript_path from Claude Code

input=$(cat)

# --- Parse JSON to get basic info ---
eval "$(echo "$input" | python3 -c "
import json, sys, shlex

try:
    d = json.load(sys.stdin)
except:
    d = {}

# Model name
m = d.get('model', '')
if isinstance(m, dict):
    m = m.get('id', '') or m.get('display_name', '') or ''
raw_model = m if m else 'claude-3-5-sonnet-20241022'
m = (m or '').replace('claude-', '').replace('Claude ', '')
print(f'model={shlex.quote(m or \"claude\")}')
print(f'raw_model={shlex.quote(raw_model)}')

# Paths
cwd = d.get('cwd', '') or ''
print(f'cwd={shlex.quote(cwd)}')
" 2>/dev/null || echo "model=claude\nraw_model=claude-3-5-sonnet-20241022\ncwd=")"

# --- Derived fields ---
dir_name=$(basename "$cwd" 2>/dev/null || echo "")
branch=""
[ -n "$cwd" ] && [ -d "$cwd" ] && branch=$(git -C "$cwd" branch --show-current 2>/dev/null || true)

# ---------- Rate limit via Haiku probe (cached 360s) ----------
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/claude"
CACHE_FILE="$CACHE_DIR/usage-cache.json"
CACHE_TTL=360
FIVE_HOUR_UTIL=""
SEVEN_DAY_UTIL=""

fetch_usage() {
  local token
  token=$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null || true)
  [ -z "$token" ] && return 1

  local access_token=""
  if echo "$token" | jq -e . >/dev/null 2>&1; then
    access_token=$(echo "$token" | jq -r '.claudeAiOauth.accessToken // empty' 2>/dev/null)
  fi
  if [ -z "$access_token" ]; then
    # Fallback for when macOS security command truncates long JSON
    access_token=$(echo "$token" | grep -o 'sk-ant-[a-zA-Z0-9_-]*' | head -n 1)
  fi
  [ -z "$access_token" ] && return 1

  # Tiny call (max_tokens=1) to get rate limit response headers
  local full_response
  full_response=$(curl -sD- --max-time 8 -o /dev/null \
    -H "Authorization: Bearer ${access_token}" \
    -H "Content-Type: application/json" \
    -H "User-Agent: claude-code/0.0.0" \
    -H "anthropic-beta: oauth-2025-04-20" \
    -H "anthropic-version: 2023-06-01" \
    -d "{\"model\":\"${raw_model}\",\"max_tokens\":1,\"messages\":[{\"role\":\"user\",\"content\":\"h\"}]}" \
    "https://api.anthropic.com/v1/messages" 2>/dev/null || true)
  local headers="$full_response"
  [ -z "$headers" ] && return 1

  # Parse rate limit headers
  local h5_util h7_util
  h5_util=$(echo "$headers" | grep -i 'anthropic-ratelimit-unified-5h-utilization' | tr -d '\r' | awk '{print $2}')
  h7_util=$(echo "$headers" | grep -i 'anthropic-ratelimit-unified-7d-utilization' | tr -d '\r' | awk '{print $2}')

  [ -z "$h5_util" ] && return 1

  # Save to cache as JSON
  mkdir -p "$CACHE_DIR"
  jq -n \
    --arg h5u "$h5_util" \
    --arg h7u "$h7_util" \
    '{five_hour_util: $h5u, seven_day_util: $h7u}' \
    > "$CACHE_FILE"
  return 0
}

load_usage() {
  local data="$1"
  FIVE_HOUR_UTIL=$(echo "$data" | jq -r '.five_hour_util // empty' 2>/dev/null)
  SEVEN_DAY_UTIL=$(echo "$data" | jq -r '.seven_day_util // empty' 2>/dev/null)
}

USE_CACHE=false
if [ -f "$CACHE_FILE" ]; then
  cache_age=$(( $(date +%s) - $(stat -f '%m' "$CACHE_FILE" 2>/dev/null || echo 0) ))
  if [ "$cache_age" -lt "$CACHE_TTL" ]; then
    USE_CACHE=true
  fi
fi

if $USE_CACHE; then
  load_usage "$(cat "$CACHE_FILE")"
else
  if fetch_usage; then
    load_usage "$(cat "$CACHE_FILE")"
  elif [ -f "$CACHE_FILE" ]; then
    load_usage "$(cat "$CACHE_FILE")"
  fi
fi

# Convert utilization (0.0-1.0) to percentage
to_pct() {
  local val="$1"
  if [ -z "$val" ] || [ "$val" = "null" ]; then
    echo "--"
    return
  fi
  awk "BEGIN{printf \"%.0f\", $val * 100}" 2>/dev/null || echo "--"
}

FIVE_HOUR_PCT=$(to_pct "$FIVE_HOUR_UTIL")
SEVEN_DAY_PCT=$(to_pct "$SEVEN_DAY_UTIL")

# --- Build output with per-item colors ---
reset="\033[0m"

out="\033[36m󰚩 ${model}${reset}"
[ -n "$dir_name" ] && out="${out} | \033[33m ${dir_name}${reset}"
[ -n "$branch" ]   && out="${out} | \033[35m ${branch}${reset}"

# Only show rate limits if we successfully fetched them
if [ "$FIVE_HOUR_PCT" != "--" ] && [ -n "$FIVE_HOUR_PCT" ]; then
  tc5="\033[32m"
  [ "$FIVE_HOUR_PCT" -ge 50 ] && tc5="\033[33m"
  [ "$FIVE_HOUR_PCT" -ge 80 ] && tc5="\033[31m"
  out="${out} | ⏱  5h: ${tc5}${FIVE_HOUR_PCT}%${reset}"
fi

if [ "$SEVEN_DAY_PCT" != "--" ] && [ -n "$SEVEN_DAY_PCT" ]; then
  tc7="\033[32m"
  [ "$SEVEN_DAY_PCT" -ge 50 ] && tc7="\033[33m"
  [ "$SEVEN_DAY_PCT" -ge 80 ] && tc7="\033[31m"
  out="${out} | 📅 7d: ${tc7}${SEVEN_DAY_PCT}%${reset}"
fi

printf "%b\n" "$out"
