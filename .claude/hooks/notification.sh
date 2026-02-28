#!/bin/bash
# Notification hook: macOS native notification
# Ghostty background reset is handled by settings.json hooks, not here

input=$(cat)

message=$(echo "$input" | python3 -c "
import json, sys
try:
    d = json.load(sys.stdin)
    print(d.get('message', 'Claude Code が入力を待っています'))
except:
    print('Claude Code が入力を待っています')
" 2>/dev/null || echo "Claude Code が入力を待っています")

safe_message=$(echo "$message" | sed 's/"/\\"/g')
osascript -e "display notification \"$safe_message\" with title \"Claude Code\" sound name \"Glass\"" 2>/dev/null || true
