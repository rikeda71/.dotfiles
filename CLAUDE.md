# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## セットアップ

```shell
zsh setup.sh
```

`setup.sh` が行うこと:
- Homebrew インストール・`Brewfile` から依存パッケージをインストール
- 各設定ファイルを `$HOME` へシンボリックリンク
- Claude Code の設定をシンボリックリンク（`settings.json`, `CLAUDE.md`, `commands/`, `agents/`）
- MCP サーバーの登録・スキルのインストール

## 構成

このリポジトリは macOS 向け dotfiles。設定ファイルを `$HOME` にシンボリックリンクして管理する。

- `setup.sh` — 初期セットアップスクリプト
- `Brewfile` — Homebrew パッケージ一覧
- `.claude/` — Claude Code のグローバル設定（`~/.claude/` にシンリンク）
  - `settings.json` — Claude Code 設定
  - `CLAUDE.md` — AI コーディングルール（`~/.claude/CLAUDE.md` にシンリンク）
  - `skills/` — カスタムスキル（`install-skills.sh` でシンリンクを張る）
  - `hooks/` — フック（`validate-bash`, `notification`）
  - `install-mcp.sh` — MCP サーバー登録スクリプト
  - `install-skills.sh` — スキルインストール・シンリンクスクリプト

## Skills の管理

`.claude/skills/` に新しいスキルを追加したら、`.claude/install-skills.sh` にも `link_local_skill "<スキル名>"` の行を追加し、スクリプトを再実行する。

```shell
zsh ~/.dotfiles/.claude/install-skills.sh
```
