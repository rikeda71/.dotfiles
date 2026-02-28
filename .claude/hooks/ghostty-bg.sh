#!/bin/bash
# ============================================================================
# Ghostty 背景色変更スクリプト（Claude Code 処理中インジケーター）
#
# OSC 11 エスケープシーケンスで Ghostty の背景色を動的に切り替える。
#   - processing: 背景を白に変更（PreToolUse フックから呼ばれる）
#   - reset:      背景をテーマ本来の色に戻す（Stop フックから呼ばれる）
#
# 初回実行時に Ghostty のテーマファイルから背景色を読み取りキャッシュする。
# PPID ごとに TTY パスを保存するため、複数 pane でも独立して動作する。
# ============================================================================

set -euo pipefail

mode="${1:-reset}"

# --- 定数 ---
PROCESSING_COLOR="#ffffff"
CACHE_FILE="/tmp/claude-ghostty-colors"
TTY_FILE="/tmp/claude-ghostty-tty.${PPID}"

# --- ヘルパー関数 ---

# OSC 11 で背景色を変更する
# $1: 色コード (例: #1a1b26)
# $2: 出力先 (例: /dev/tty, /dev/ttys005)
send_osc11() {
  printf '\e]11;%s\e\\' "$1" > "$2" 2>/dev/null
}

# Ghostty の設定ファイルパスを返す
find_ghostty_config() {
  local config="${HOME}/.config/ghostty/config"
  [ -f "$config" ] && echo "$config" && return
  config="${HOME}/.dotfiles/ghostty/config"
  [ -f "$config" ] && echo "$config" && return
  return 1
}

# Ghostty テーマファイルから背景色を抽出する
# $1: テーマ名
resolve_theme_bg() {
  local theme_file="/Applications/Ghostty.app/Contents/Resources/ghostty/themes/$1"
  [ ! -f "$theme_file" ] && return 1
  grep '^background' "$theme_file" | head -1 | sed 's/^background[[:space:]]*=[[:space:]]*//' | tr -d '[:space:]'
}

# --- キャッシュ構築（初回のみ） ---
# 1行目: テーマ背景色、2行目: 処理中の色
if [ ! -f "$CACHE_FILE" ]; then
  config=$(find_ghostty_config) || exit 0
  theme=$(grep '^theme' "$config" | head -1 | sed 's/^theme[[:space:]]*=[[:space:]]*//')
  [ -z "$theme" ] && exit 0
  bg=$(resolve_theme_bg "$theme") || exit 0
  [ -z "$bg" ] && exit 0
  printf '%s\n%s\n' "$bg" "$PROCESSING_COLOR" > "$CACHE_FILE"
fi

theme_bg=$(sed -n '1p' "$CACHE_FILE")
[ -z "$theme_bg" ] && exit 0

# --- メイン処理 ---
if [ "$mode" = "processing" ]; then
  # TTY デバイスパスを保存（tty コマンドは stdin がパイプだと失敗するため ps を使う）
  tty_name=$(ps -o tty= -p $$ 2>/dev/null | tr -d ' ')
  [ -n "$tty_name" ] && [ "$tty_name" != "??" ] && echo "/dev/$tty_name" > "$TTY_FILE"
  send_osc11 "$PROCESSING_COLOR" /dev/tty || true
else
  # /dev/tty へ直接書けない場合（Stop フック等）は保存済み TTY パスにフォールバック
  send_osc11 "$theme_bg" /dev/tty || {
    tty_path=$(cat "$TTY_FILE" 2>/dev/null)
    [ -n "$tty_path" ] && [ -e "$tty_path" ] && send_osc11 "$theme_bg" "$tty_path"
  }
fi
