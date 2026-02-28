#!/bin/zsh
# Claude Code statusline
# Stdin: JSON with model, cwd, transcript_path from Claude Code

input=$(cat)

# --- Parse JSON and compute token stats in a single python3 call ---
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
m = (m or '').replace('claude-', '').replace('Claude ', '')
print(f'model={shlex.quote(m or \"claude\")}')

# Paths
cwd = d.get('cwd', '') or ''
transcript_path = d.get('transcript_path', '') or ''
print(f'cwd={shlex.quote(cwd)}')

# Token stats from transcript
latest = 0
if transcript_path:
    try:
        with open(transcript_path) as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                try:
                    u = json.loads(line).get('message', {}).get('usage', {})
                    t = int(u.get('input_tokens', 0)) + int(u.get('cache_creation_input_tokens', 0)) + int(u.get('cache_read_input_tokens', 0))
                    if t > 0:
                        latest = t
                except:
                    pass
    except:
        pass

pct = latest / 200000 * 100
disp = f'{latest/1000:.1f}K' if latest >= 1000 else str(latest)
print(f'tokens_display={shlex.quote(disp)}')
print(f'pct={pct:.1f}')
print(f'pct_int={int(pct)}')
" 2>/dev/null || echo "model=claude\ncwd=\ntokens_display=0\npct=0.0\npct_int=0")"

# --- Derived fields ---
dir_name=$(basename "$cwd" 2>/dev/null || echo "")
branch=""
[ -n "$cwd" ] && [ -d "$cwd" ] && branch=$(git -C "$cwd" branch --show-current 2>/dev/null || true)

# --- Build output with per-item colors ---
reset="\033[0m"
tc="\033[32m"
[ "$pct_int" -ge 70 ] && tc="\033[33m"
[ "$pct_int" -ge 90 ] && tc="\033[31m"

out="\033[36m󰚩 ${model}${reset}"
[ -n "$dir_name" ] && out="${out} | \033[33m ${dir_name}${reset}"
[ -n "$branch" ]   && out="${out} | \033[35m ${branch}${reset}"
out="${out} | ${tc}󰆃 ${tokens_display} (${pct}%)${reset}"

printf "%b\n" "$out"
