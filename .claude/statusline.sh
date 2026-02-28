#!/bin/zsh
# Claude Code custom statusline
# Receives JSON from Claude Code via stdin

input=$(cat)

# Parse all fields at once to avoid multiple python3 calls
eval "$(echo "$input" | python3 -c "
import json, sys, shlex
try:
    d = json.load(sys.stdin)
    # model: handle both string and object formats
    m = d.get('model', '')
    if isinstance(m, dict):
        m = m.get('id', '') or m.get('display_name', '') or ''
    m = (m or '').replace('claude-', '').replace('Claude ', '')
    print(f'model={shlex.quote(m or \"claude\")}')
    print(f'cwd={shlex.quote(d.get(\"cwd\", \"\") or \"\")}')
    print(f'transcript_path={shlex.quote(d.get(\"transcript_path\", \"\") or \"\")}')
except:
    print('model=claude')
    print('cwd=')
    print('transcript_path=')
" 2>/dev/null)"

# Directory display name
dir_name=$(basename "$cwd" 2>/dev/null || echo "")

# Git branch
branch=""
if [ -n "$cwd" ] && [ -d "$cwd" ]; then
  branch=$(git -C "$cwd" branch --show-current 2>/dev/null || true)
fi

# Check if Claude is actively processing (transcript file size still growing)
is_processing=0
if [ -n "$transcript_path" ] && [ -f "$transcript_path" ]; then
  size1=$(stat -f %z "$transcript_path" 2>/dev/null || echo "0")
  sleep 0.3
  size2=$(stat -f %z "$transcript_path" 2>/dev/null || echo "0")
  if [ "$size2" -gt "$size1" ]; then
    is_processing=1
  fi
fi

# Count tokens from transcript - use only the most recent API call's usage
total_tokens=0
if [ -n "$transcript_path" ] && [ -f "$transcript_path" ]; then
  total_tokens=$(python3 -c "
import json
latest = 0
try:
    with open('$transcript_path') as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            try:
                d = json.loads(line)
                msg = d.get('message') or {}
                u = msg.get('usage') or {}
                t = (int(u.get('input_tokens', 0)) +
                     int(u.get('cache_creation_input_tokens', 0)) +
                     int(u.get('cache_read_input_tokens', 0)))
                if t > 0:
                    latest = t
            except:
                pass
except:
    pass
print(latest)
" 2>/dev/null || echo "0")
fi

# Context window limit
context_limit=200000
pct=$(python3 -c "
t = int($total_tokens)
lim = $context_limit
p = t / lim * 100 if lim > 0 else 0
print(f'{p:.1f}')
" 2>/dev/null || echo "0.0")

# Format token count (e.g., 42.3K)
tokens_display=$(python3 -c "
t = int($total_tokens)
print(f'{t/1000:.1f}K' if t >= 1000 else str(t))
" 2>/dev/null || echo "$total_tokens")

# Token color by usage level
pct_int=$(python3 -c "print(int(float('$pct')))" 2>/dev/null || echo "0")
if [ "$pct_int" -ge 90 ]; then
  token_color="\033[31m"  # red
elif [ "$pct_int" -ge 70 ]; then
  token_color="\033[33m"  # yellow
else
  token_color="\033[32m"  # green
fi

reset="\033[0m"

if [ "$is_processing" -eq 1 ]; then
  # Amber glow: entire line bold black-on-amber
  glow="\033[1;30;48;5;214m"
  out=" 󰚩 ${model}"
  [ -n "$dir_name" ] && out="${out} |  ${dir_name}"
  [ -n "$branch" ]   && out="${out} |  ${branch}"
  out="${out} | 󰆃 ${tokens_display} (${pct}%) "
  printf "%b\n" "${glow}${out}${reset}"
else
  # Normal: per-item text colors, no background
  c_model="\033[36m"     # cyan
  c_dir="\033[33m"       # yellow
  c_branch="\033[35m"    # magenta
  out="${c_model}󰚩 ${model}${reset}"
  [ -n "$dir_name" ] && out="${out} | ${c_dir} ${dir_name}${reset}"
  [ -n "$branch" ]   && out="${out} | ${c_branch} ${branch}${reset}"
  out="${out} | ${token_color}󰆃 ${tokens_display} (${pct}%)${reset}"
  printf "%b\n" "$out"
fi
