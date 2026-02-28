#!/bin/bash
# Change Ghostty background via OSC 11
# Usage: ghostty-bg.sh [processing|reset]
# - processing: set background to white (called by PreToolUse)
# - reset: restore original theme background (called by Stop)

mode="${1:-reset}"
cache="/tmp/claude-ghostty-colors"
# Use PPID to isolate TTY path per Claude Code instance (each pane has its own)
tty_file="/tmp/claude-ghostty-tty.${PPID}"

# Build color cache on first call
if [ ! -f "$cache" ]; then
  config="${HOME}/.config/ghostty/config"
  [ ! -f "$config" ] && config="${HOME}/.dotfiles/ghostty/config"
  [ ! -f "$config" ] && exit 0

  theme=$(grep '^theme' "$config" | head -1 | sed 's/^theme[[:space:]]*=[[:space:]]*//')
  [ -z "$theme" ] && exit 0

  theme_file="/Applications/Ghostty.app/Contents/Resources/ghostty/themes/${theme}"
  [ ! -f "$theme_file" ] && exit 0

  bg=$(grep '^background' "$theme_file" | head -1 | sed 's/^background[[:space:]]*=[[:space:]]*//' | tr -d '[:space:]')
  [ -z "$bg" ] && exit 0

  printf '%s\n%s\n' "$bg" "#ffffff" > "$cache"
fi

bg=$(sed -n '1p' "$cache")
[ -z "$bg" ] && exit 0

if [ "$mode" = "processing" ]; then
  # Save TTY device path via ps (tty command fails when stdin is piped)
  tty_name=$(ps -o tty= -p $$ 2>/dev/null | tr -d ' ')
  [ -n "$tty_name" ] && [ "$tty_name" != "??" ] && echo "/dev/$tty_name" > "$tty_file"
  printf '\e]11;%s\e\\' "$(sed -n '2p' "$cache")" > /dev/tty 2>/dev/null || true
else
  # Immediate reset: try /dev/tty first, fall back to saved TTY path
  if printf '\e]11;%s\e\\' "$bg" > /dev/tty 2>/dev/null; then
    :
  else
    tty_path=$(cat "$tty_file" 2>/dev/null)
    [ -n "$tty_path" ] && [ -e "$tty_path" ] && printf '\e]11;%s\e\\' "$bg" > "$tty_path" 2>/dev/null
  fi
fi
