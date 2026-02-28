#!/bin/zsh
# Claude Code statusline
# Stdin: JSON with model, cwd, transcript_path from Claude Code

input=$(cat)

# --- Parse JSON fields ---
eval "$(echo "$input" | python3 -c "
import json, sys, shlex
try:
    d = json.load(sys.stdin)
    m = d.get('model', '')
    if isinstance(m, dict):
        m = m.get('id', '') or m.get('display_name', '') or ''
    m = (m or '').replace('claude-', '').replace('Claude ', '')
    print(f'model={shlex.quote(m or \"claude\")}')
    print(f'cwd={shlex.quote(d.get(\"cwd\", \"\") or \"\")}')
    print(f'transcript_path={shlex.quote(d.get(\"transcript_path\", \"\") or \"\")}')
except:
    print('model=claude'); print('cwd='); print('transcript_path=')
" 2>/dev/null)"

# --- Derived fields ---
dir_name=$(basename "$cwd" 2>/dev/null || echo "")
branch=""
[ -n "$cwd" ] && [ -d "$cwd" ] && branch=$(git -C "$cwd" branch --show-current 2>/dev/null || true)

# --- Token stats (single python3 call) ---
eval "$(python3 -c "
import json
latest = 0
try:
    with open('$transcript_path') as f:
        for line in f:
            line = line.strip()
            if not line: continue
            try:
                u = json.loads(line).get('message', {}).get('usage', {})
                t = int(u.get('input_tokens', 0)) + int(u.get('cache_creation_input_tokens', 0)) + int(u.get('cache_read_input_tokens', 0))
                if t > 0: latest = t
            except: pass
except: pass
pct = latest / 200000 * 100
disp = f'{latest/1000:.1f}K' if latest >= 1000 else str(latest)
print(f'tokens_display={disp}')
print(f'pct={pct:.1f}')
print(f'pct_int={int(pct)}')
" 2>/dev/null || echo "tokens_display=0\npct=0.0\npct_int=0")"

# --- Build output with per-item colors ---
reset="\033[0m"
tc="\033[32m"
[ "$pct_int" -ge 70 ] && tc="\033[33m"
[ "$pct_int" -ge 90 ] && tc="\033[31m"

out="\033[36m󰚩 ${model}${reset}"
[ -n "$dir_name" ] && out="${out} | \033[33m ${dir_name}${reset}"
[ -n "$branch" ]   && out="${out} | \033[35m ${branch}${reset}"
out="${out} | ${tc}󰆃 ${tokens_display} (${pct}%)${reset}"

printf "%b\n" "$out"
