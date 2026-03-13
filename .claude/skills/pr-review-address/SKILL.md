---
name: pr-review-address
description: >
  現在のブランチの PR に対するレビューコメントや PR コメントを網羅的に確認し、対応する。
  指摘が妥当であればコードを修正してコミットし commit hash とともに返信する。
  指摘が妥当でなければ反論コメントを投稿する。
  "レビュー対応をして" など、既存のレビューコメントへの対応を求められた場合に使用する。
  ただし「レビューして」のように新たにレビューを依頼する文脈では使用しない（その場合は review スキルを使う）。
allowed-tools:
  - Bash(gh pr *)
  - Bash(gh api *)
  - Bash(git diff *)
  - Bash(git log *)
  - Bash(git add *)
  - Bash(git commit *)
  - Bash(git status *)
  - Bash(git rev-parse *)
  - Glob
  - Grep
  - Read
  - Edit
  - Write
---

# PR レビューコメントへの対応

現在のブランチの PR に付いたレビューコメントおよび PR コメントを網羅的に確認し、各指摘に対応する。

## 手順

### 1. PR とコメントの取得

現在のブランチに紐づく PR を特定し、全コメントを取得する。

```bash
# PR 番号の確認
gh pr view --json number,url,title

# レビューコメント（コード上の指摘）を取得
gh pr view --json reviewThreads --jq '.reviewThreads[] | {path: .path, line: .line, body: (.comments[0].body), author: (.comments[0].author.login), resolved: .isResolved}'

# PR 全体へのコメントを取得
gh pr view --json comments --jq '.comments[] | {author: .author.login, body: .body, id: .id}'
```

未解決（`resolved: false`）のレビューコメントと、未返信の PR コメントを対応対象とする。

### 2. 各コメントの評価と対応

コメントごとに以下を判断する。

#### 指摘が妥当な場合（コードを修正すべき）

1. 該当ファイルを Read で読み込み、指摘箇所を Edit で修正する
2. 修正をコミットする（ファイル名を指定してステージング）
   ```bash
   git add <修正したファイル>
   git commit -m "fix: <修正内容の要約>"
   ```
3. commit hash を取得する
   ```bash
   git rev-parse HEAD
   ```
4. レビューコメントに返信する
   ```bash
   # コードコメントへの返信
   gh api repos/{owner}/{repo}/pulls/{pr_number}/comments/{comment_id}/replies \
     -f body="修正しました。<commit_hash>"

   # PR コメントへの返信
   gh pr comment <pr_number> --body "修正しました（<commit_hash>）"
   ```

#### 指摘が妥当でない場合（反論する）

理由を明確にして反論コメントを投稿する。

```bash
# コードコメントへの返信
gh api repos/{owner}/{repo}/pulls/{pr_number}/comments/{comment_id}/replies \
  -f body="<反論の内容>"

# PR コメントへの返信
gh pr comment <pr_number> --body "<反論の内容>"
```

### 3. 対応の報告

全コメントへの対応が完了したら、対応内容をまとめてユーザーに報告する。

## ルール

- 未解決コメントを漏れなく確認する（`resolved: false` のもの）
- コミットは明示的に求められた場合のみ自動実行し、それ以外はユーザーに確認する
- コミットメッセージは日本語または英語でレビュー対応の内容を簡潔に示す
- `git push` は自動実行しない（ユーザーが確認後に実行する）
- 反論は根拠を明示し、感情的な表現を避ける
- owner/repo は `gh pr view --json url` から取得する

$ARGUMENTS
