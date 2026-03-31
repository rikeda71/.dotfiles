# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## セットアップ

```shell
darwin-rebuild switch --flake ~/.dotfiles#personal   # プライベート Mac
darwin-rebuild switch --flake ~/.dotfiles#work       # 会社 Mac
```

## 構成

このリポジトリは macOS 向け dotfiles。Nix (nix-darwin + home-manager) で宣言的に管理する。

- `flake.nix` — Nix flake エントリポイント
- `nix/` — Nix 設定モジュール
  - `common.nix` — 共通パッケージ (CLI ツール)
  - `darwin.nix` — macOS システム設定 + Homebrew casks
  - `home.nix` — home-manager (dotfile symlinks, activation scripts)
  - `hosts/personal.nix` — プライベート Mac 固有設定
  - `hosts/work.nix` — 会社 Mac 固有設定
- `AGENTS.md` — AI コーディングルール（Claude Code / Codex CLI 共通）
- `.claude/` — Claude Code のグローバル設定（`~/.claude/` にシンリンク）
  - `settings.json` — Claude Code 設定
  - `CLAUDE.md` — `../AGENTS.md` への symlink
  - `skills/` — カスタムスキル（`install-skills.sh` でシンリンクを張る）
  - `hooks/` — フック（`validate-bash`, `notification`）
  - `install-mcp.sh` — MCP サーバー登録スクリプト
  - `install-skills.sh` — スキルインストール・シンリンクスクリプト

## パッケージ管理の分担

- **Nix** (`nix/common.nix`): CLI ツール全般
- **Homebrew cask** (`nix/darwin.nix`): GUI アプリ (ghostty, obsidian, raycast)
- **mise** (`mise/config.toml`): 言語ランタイム (go, java, python, rust, node)

## Skills の管理

`.claude/skills/` に新しいスキルを追加したら、`.claude/install-skills.sh` にも `link_local_skill "<スキル名>"` の行を追加し、スクリプトを再実行する。

```shell
zsh ~/.dotfiles/.claude/install-skills.sh
```
