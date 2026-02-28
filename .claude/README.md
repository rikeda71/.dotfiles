# Claude Code 設定

## ファイル構成

```
.claude/
├── CLAUDE.md            # AI コーディングルール（Claude Code が従う指示）
├── settings.json        # Claude Code 本体の設定
├── settings.local.json  # ローカル環境固有の設定（git 管理外）
├── statusline.sh        # カスタムステータスライン
├── hooks/
│   └── ghostty-bg.sh   # Ghostty 背景色変更（処理中インジケーター）
├── agents/              # カスタムエージェント定義
├── commands/            # カスタムスラッシュコマンド
├── mcp-servers/         # MCP サーバー設定
├── install-mcp.sh       # MCP サーバーインストールスクリプト
└── install-skills.sh    # スキルインストールスクリプト
```

## settings.json

主要な設定項目：

| 項目 | 説明 |
|------|------|
| `model` | 使用モデル（`opus`） |
| `permissions` | ツール許可リスト + `bypassPermissions` モード |
| `hooks` | PreToolUse / Stop フックの定義 |
| `statusLine` | カスタムステータスラインコマンド |
| `enabledPlugins` | 有効なプラグイン（frontend-design, gopls-lsp, typescript-lsp） |
| `alwaysThinkingEnabled` | 常に extended thinking を使用 |

## statusline.sh

Claude Code のステータスラインをカスタマイズするスクリプト。
stdin で JSON（`model`, `cwd`, `transcript_path`）を受け取り、以下を表示する：

- 󰚩 モデル名（cyan）
- ディレクトリ名（yellow）
-  ブランチ名（magenta）
- 󰆃 トークン使用量と割合（green / yellow / red）

各項目は `|` で区切り、Nerd Font アイコン付き。
トークン割合は 70% 以上で黄色、90% 以上で赤色に変化する。

## hooks/ghostty-bg.sh

Ghostty ターミナルの背景色を OSC 11 エスケープシーケンスで動的に変更し、
Claude Code の処理状態を視覚的に示すスクリプト。

### 動作

| フックイベント | 動作 |
|---|---|
| **PreToolUse** | 背景を白（`#ffffff`）に変更 |
| **Stop** | 背景をテーマ本来の色に戻す |

### 仕組み

1. 初回実行時に Ghostty の設定ファイルからテーマの背景色を読み取り、`/tmp/claude-ghostty-colors` にキャッシュ
2. `processing` モード: `/dev/tty` へ OSC 11 を送信して背景を白に変更
3. `reset` モード: `/dev/tty`（または保存済み TTY パス）へ OSC 11 を送信して元の背景色に戻す

### 複数 pane 対応

TTY パスを `${PPID}` 付きファイル（`/tmp/claude-ghostty-tty.${PPID}`）に保存するため、
Ghostty で複数 pane を開いて別々の Claude Code を実行しても、各 pane が独立して動作する。

### 既知の制限

- Interrupted（Escape / Ctrl+C による中断）時は Stop フックが発火しないため、背景が白のまま残る。次のターンの Stop で自動的にリセットされる。
