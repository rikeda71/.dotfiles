# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 前提条件

- [Nix](https://nixos.org/)（Determinate Systems installer 推奨）
- [Homebrew](https://brew.sh/)（nix-darwin の `homebrew.enable = true` が依存）

## セットアップ

```shell
sudo darwin-rebuild switch --flake ~/.dotfiles#personal --impure   # プライベート Mac
sudo darwin-rebuild switch --flake ~/.dotfiles#work --impure       # 会社 Mac
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
  - `hosts/local.nix.template` — ローカル設定テンプレート
  - `hosts/{personal,work}-local.nix` — Git 管理外のローカル設定（自動生成）
- `AGENTS.md` — AI コーディングルール（Claude Code / Codex CLI 共通）
- `.claude/` — Claude Code のグローバル設定（`~/.claude/` にシンリンク）
  - `settings.json` — Claude Code 設定
  - `CLAUDE.md` — `../AGENTS.md` への symlink
  - `skills/` — カスタムスキル（`install-skills.sh` でシンリンクを張る）
  - `hooks/` — フック（`validate-bash`, `notification`）
  - `install-mcp.sh` — MCP サーバー登録スクリプト（`hostName` で personal/work 切替）
  - `install-skills.sh` — スキルインストール・シンリンクスクリプト
- `raycast/` — Raycast 設定（エクスポートファイル、手動インポートが必要）

## パッケージ管理の分担

- **Nix** (`nix/common.nix`): CLI ツール全般
- **Homebrew cask** (`nix/darwin.nix`): GUI アプリ (ghostty, obsidian, raycast)
- **mise** (`mise/config.toml`): 言語ランタイム (go, java, python, node)
- **rustup** (`nix/common.nix`): Rust toolchain

## ローカル設定（Git 管理外）

`nix/hosts/{personal,work}-local.nix` に Git に反映しないホスト固有の設定を記述できる。初回の `darwin-rebuild switch` 実行時にテンプレート (`nix/hosts/local.nix.template`) から自動生成される。

```nix
# nix/hosts/work-local.nix の例
{ ... }:

{
  homebrew.casks = [ "slack" "zoom" ];
}
```

## MCP サーバー

`install-mcp.sh` で登録。`darwin-rebuild switch` 時に自動実行される。

| MCP | 環境 | 必要な環境変数 |
|-----|------|---------------|
| drawio | 共通 | — |
| clickup | personal | — |
| sentry | personal | — |
| notion | personal | — |
| next-devtools | personal | — |
| auth0 | personal | — |
| figma | personal | `FIGMA_API_KEY` |
| datadog | personal | `DD_API_KEY`, `DD_APPLICATION_KEY` |

API キーが必要な MCP は、事前に環境変数をセットしてから rebuild を実行する：

```shell
export FIGMA_API_KEY="your-key"
export DD_API_KEY="your-key"
export DD_APPLICATION_KEY="your-key"
sudo -E darwin-rebuild switch --flake ~/.dotfiles#personal --impure
```

または `~/.zshrc.local` に環境変数を記述しておけば、次回以降の rebuild で自動適用される。

## Skills の管理

`.claude/skills/` に新しいスキルを追加したら、`.claude/install-skills.sh` にも `link_local_skill "<スキル名>"` の行を追加し、スクリプトを再実行する。

```shell
zsh ~/.dotfiles/.claude/install-skills.sh
```
