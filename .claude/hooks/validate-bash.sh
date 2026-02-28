#!/bin/bash
# PreToolUse hook: Bash tool validation
# Blocks: git add -A / --all / .  and  git push
# Exit 2 to block the tool call

input=$(cat)

tool_name=$(echo "$input" | python3 -c "
import json, sys
try:
    print(json.load(sys.stdin).get('tool_name', ''))
except:
    print('')
" 2>/dev/null)

[ "$tool_name" != "Bash" ] && exit 0

command=$(echo "$input" | python3 -c "
import json, sys
try:
    d = json.load(sys.stdin)
    print(d.get('tool_input', {}).get('command', ''))
except:
    print('')
" 2>/dev/null)

# Block: git add -A / --all / .
if echo "$command" | grep -qE 'git\s+add\s+((-A|--all)|\.)(\s|$)'; then
  echo "git add -A / --all / . は禁止されています。ファイル名を指定してステージングしてください。" >&2
  exit 2
fi

# Block: git push (allow --dry-run)
if echo "$command" | grep -qE 'git\s+push' && ! echo "$command" | grep -q '\-\-dry-run'; then
  echo "git push は自動実行禁止です。ユーザーが確認後、手動で実行してください。" >&2
  exit 2
fi

exit 0
