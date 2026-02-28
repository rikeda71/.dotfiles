# .dotfiles

## 環境

| カテゴリ | ツール |
|---|---|
| ターミナル | [Ghostty](https://ghostty.org/) |
| シェル | zsh ([Zinit](https://github.com/zdharma-continuum/zinit)) |
| プロンプト | [Starship](https://starship.rs/) |
| マルチプレクサ | tmux |
| エディタ | Vim |
| AI | [Claude Code](https://claude.ai/code) |
| パッケージ管理 | [Homebrew](https://brew.sh/) |

## セットアップ

```shell
git clone https://github.com/rikeda71/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
zsh setup.sh
```

`setup.sh` が行うこと:

- Homebrew インストール・`Brewfile` から依存パッケージをインストール
- 各設定ファイルを `$HOME` へシンボリックリンク（`.zshrc`, `.gitconfig`, `.tmux.conf` など）
- Starship・Ghostty の設定をシンボリックリンク
- Claude Code の設定をシンボリックリンク（`settings.json`, `CLAUDE.md`, `commands/`, `agents/`）
- MCP サーバーの登録（`install-mcp.sh`）
- Claude Code スキルのインストール（`install-skills.sh`）

## 管理している設定ファイル

```
.dotfiles/
├── .gitconfig          # Git 設定
├── .ideavimrc          # IdeaVim 設定
├── .tmux.conf          # tmux 設定
├── .vimrc              # Vim 設定
├── .vim/               # Vim プラグイン・設定
├── .vscode/            # VSCode 設定
├── .zshrc              # Zsh 設定
├── .claude/            # Claude Code 設定
│   ├── settings.json   # グローバル設定
│   ├── CLAUDE.md       # AI コーディングルール
│   ├── commands/       # スラッシュコマンド (/commit, /pr, /review, /address)
│   ├── agents/         # サブエージェント (commit-maker, pr-maker, reviewer)
│   ├── hooks/          # フック (validate-bash, notification)
│   ├── statusline.sh   # カスタムステータスライン
│   ├── install-mcp.sh  # MCP サーバー登録スクリプト
│   └── install-skills.sh # スキルインストールスクリプト
├── ghostty/
│   └── config.toml     # Ghostty ターミナル設定
├── starship.toml        # Starship プロンプト設定
└── Brewfile             # Homebrew パッケージ一覧
```

## Claude Code

MCP サーバー（Sentry・ClickUp・DrawIO・Next Devtools）と各種スキルは `setup.sh` 実行時に自動登録されます。

Figma MCP は API キーが必要なため手動で登録してください:

```shell
claude mcp add figma -e FIGMA_API_KEY="your-key" -- npx -y figma-developer-mcp --stdio
```
