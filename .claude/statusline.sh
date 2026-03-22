#!/bin/zsh
# Claude Code statusline
# Stdin: JSON with model, cwd, transcript_path, rate_limits from Claude Code

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
raw_model = m if m else 'unknown'
m = (m or '').replace('claude-', '').replace('Claude ', '')
print(f'model={shlex.quote(m or \"claude\")}')

# Paths
cwd = d.get('cwd', '') or ''
print(f'cwd={shlex.quote(cwd)}')

# Rate limits (added in 2.1.80)
rl = d.get('rate_limits', {}) or {}
for window in ['five_hour', 'seven_day']:
    w = rl.get(window, {}) or {}
    pct = w.get('used_percentage')
    if pct is not None:
        print(f'{window}_pct={int(round(pct))}')
    else:
        print(f'{window}_pct=')
" 2>/dev/null || printf '%s\n' 'model=claude' 'cwd=' 'five_hour_pct=' 'seven_day_pct=')"

# --- Derived fields ---
dir_name=$(basename "$cwd" 2>/dev/null || echo "")
branch=""
[ -n "$cwd" ] && [ -d "$cwd" ] && branch=$(git -C "$cwd" branch --show-current 2>/dev/null || true)

# --- Build output with per-item colors ---
reset="\033[0m"

out="\033[36m󰚩 ${model}${reset}"
[ -n "$dir_name" ] && out="${out} | \033[33m ${dir_name}${reset}"
[ -n "$branch" ]   && out="${out} | \033[35m ${branch}${reset}"

# Rate limits from stdin JSON (no more API probing needed)
if [ -n "$five_hour_pct" ]; then
  tc5="\033[32m"
  [ "$five_hour_pct" -ge 50 ] && tc5="\033[33m"
  [ "$five_hour_pct" -ge 80 ] && tc5="\033[31m"
  out="${out} | ⏱  5h: ${tc5}${five_hour_pct}%${reset}"
fi

if [ -n "$seven_day_pct" ]; then
  tc7="\033[32m"
  [ "$seven_day_pct" -ge 50 ] && tc7="\033[33m"
  [ "$seven_day_pct" -ge 80 ] && tc7="\033[31m"
  out="${out} | 📅 7d: ${tc7}${seven_day_pct}%${reset}"
fi

printf "%b\n" "$out"
