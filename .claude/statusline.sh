#!/bin/zsh
# Claude Code custom statusline
# Receives JSON from Claude Code via stdin
# Format: 󰚩 model |  dir  branch |  tokens (pct%)

input=$(cat)

# Extract model name
model=$(echo "$input" | python3 -c "
import json, sys
try:
    d = json.load(sys.stdin)
    m = d.get('model', '') or ''
    m = m.replace('claude-', '')
    print(m)
except:
    print('claude')
" 2>/dev/null || echo "claude")

# Extract working directory
cwd=$(echo "$input" | python3 -c "
import json, sys
try:
    d = json.load(sys.stdin)
    print(d.get('cwd', '') or '')
except:
    print('')
" 2>/dev/null)

# Extract transcript path for token counting
transcript_path=$(echo "$input" | python3 -c "
import json, sys
try:
    d = json.load(sys.stdin)
    print(d.get('transcript_path', '') or '')
except:
    print('')
" 2>/dev/null)

# Directory display name
dir_name=$(basename "$cwd" 2>/dev/null || echo "")

# Git branch
branch=""
if [ -n "$cwd" ] && [ -d "$cwd" ]; then
  branch=$(git -C "$cwd" branch --show-current 2>/dev/null || true)
fi

# Count tokens from transcript
total_tokens=0
if [ -n "$transcript_path" ] && [ -f "$transcript_path" ]; then
  total_tokens=$(python3 -c "
import json
total = 0
try:
    with open('$transcript_path') as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            try:
                d = json.loads(line)
                u = d.get('usage') or {}
                total += int(u.get('input_tokens', 0))
                total += int(u.get('cache_creation_input_tokens', 0))
            except:
                pass
except:
    pass
print(total)
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

# Color coding (ANSI escape codes)
pct_int=$(python3 -c "print(int(float('$pct')))" 2>/dev/null || echo "0")
if [ "$pct_int" -ge 90 ]; then
  c="\033[31m"  # red
elif [ "$pct_int" -ge 70 ]; then
  c="\033[33m"  # yellow
else
  c="\033[32m"  # green
fi
r="\033[0m"

# Build statusline
out="󰚩 ${model:-claude}"
[ -n "$dir_name" ] && out="${out} |  ${dir_name}"
[ -n "$branch" ] && out="${out}  ${branch}"
out="${out} | ${c}${tokens_display} (${pct}%)${r}"

printf "%b\n" "$out"
