# .dotfiles

macOS 環境を [Nix](https://nixos.org/) で宣言的に管理する dotfiles。

## 環境

| カテゴリ | ツール |
|---|---|
| パッケージ管理 | [Nix](https://nixos.org/) ([nix-darwin](https://github.com/LnL7/nix-darwin) + [home-manager](https://github.com/nix-community/home-manager)) |
| ターミナル | [Ghostty](https://ghostty.org/) |
| シェル | zsh ([Zinit](https://github.com/zdharma-continuum/zinit)) |
| プロンプト | [Starship](https://starship.rs/) |
| エディタ | [Neovim](https://neovim.io/) |
| 言語ランタイム | [mise](https://mise.jdx.dev/) |
| AI | [Claude Code](https://claude.ai/code) |

## セットアップ

### 1. Nix のインストール

```shell
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### 2. Homebrew のインストール

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 3. リポジトリのクローン

```shell
git clone https://github.com/rikeda71/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### 4. ビルド・適用

```shell
# 初回（darwin-rebuild 未導入時）
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#personal --impure

# 2回目以降
sudo darwin-rebuild switch --flake .#personal --impure   # プライベート Mac
sudo darwin-rebuild switch --flake .#work --impure       # 会社 Mac
```

### 5. Raycast の設定復元

Raycast を起動し、Settings > Advanced > Import から `raycast/Raycast.rayconfig` をインポートする。

### 自動で行われること

`darwin-rebuild switch` により以下が自動的に行われます:

- CLI ツールのインストール (Nix)
- GUI アプリのインストール (Homebrew cask)
- dotfile の symlink 作成 (home-manager)
- macOS システム設定の適用
- Claude Code の MCP サーバー登録・スキルインストール

## 構成

```text
.dotfiles/
├── flake.nix               # Nix flake エントリポイント
├── nix/
│   ├── common.nix          # 共通パッケージ (CLI ツール)
│   ├── darwin.nix          # macOS 設定 + Homebrew casks
│   ├── home.nix            # dotfile symlinks + activation scripts
│   └── hosts/
│       ├── personal.nix    # プライベート Mac 固有設定
│       └── work.nix        # 会社 Mac 固有設定
├── .zshrc                  # Zsh 設定
├── .gitconfig              # Git 設定
├── .vimrc / .vim/          # Vim 設定
├── .ideavimrc              # IdeaVim 設定
├── nvim/                   # Neovim 設定 (lazy.nvim)
├── ghostty/                # Ghostty ターミナル設定
├── starship.toml           # Starship プロンプト設定
├── mise/                   # mise 言語ランタイム設定
├── .vscode/                # VS Code 設定
├── .ssh/config             # SSH 設定
├── raycast/                # Raycast 設定（手動インポート）
└── .claude/                # Claude Code 設定
    ├── settings.json       # グローバル設定
    ├── CLAUDE.md           # AI コーディングルール
    ├── skills/             # カスタムスキル
    ├── hooks/              # フック
    ├── install-mcp.sh      # MCP サーバー登録
    └── install-skills.sh   # スキルインストール
```

## パッケージ管理の分担

| 管理先 | 対象 | 設定ファイル |
|--------|------|-------------|
| **Nix** | CLI ツール (eza, fzf, gh, neovim, etc.) | `nix/common.nix` |
| **Homebrew cask** | GUI アプリ (Ghostty, Obsidian, Raycast) | `nix/darwin.nix` |
| **mise** | 言語ランタイム (Go, Java, Python, Rust, Node) | `mise/config.toml` |

## Claude Code

MCP サーバー (Sentry, ClickUp, DrawIO, Next Devtools) と各種スキルは `darwin-rebuild switch` 時に自動登録されます（`claude` CLI が PATH 上にある場合のみ）。

Figma MCP は API キーが必要なため手動で登録してください:

```shell
claude mcp add figma -e FIGMA_API_KEY="your-key" -- npx -y figma-developer-mcp --stdio
```
