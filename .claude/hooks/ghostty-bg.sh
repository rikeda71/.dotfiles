#!/bin/bash
# Change Ghostty background via OSC 11
# Usage: ghostty-bg.sh [processing|reset]

mode="${1:-reset}"
cache="/tmp/claude-ghostty-colors"

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

  processing_bg="#ffffff"

  printf '%s\n%s\n' "$bg" "$processing_bg" > "$cache"
fi

# Read cached colors
bg=$(sed -n '1p' "$cache")
processing_bg=$(sed -n '2p' "$cache")
[ -z "$bg" ] && exit 0

[ "$mode" = "processing" ] && color="$processing_bg" || color="$bg"

# Send OSC 11 (with tmux passthrough if needed)
if [ -n "$TMUX" ]; then
  printf '\ePtmux;\e\e]11;%s\e\e\\\e\\' "$color" > /dev/tty 2>/dev/null || true
else
  printf '\e]11;%s\e\\' "$color" > /dev/tty 2>/dev/null || true
fi
