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
  - Bash(git push *)
  - Bash(git status *)
  - Bash(git rev-parse *)
  - Glob
  - Grep
  - Read
  - Edit
  - Write
---

# PR レビューコメントへの対応

現在のブランチの PR に付いたレビューコメント（コード上の指摘）および PR コメント（PR 全体への指摘）を網羅的に確認し、各指摘に対応する。

## 手順

### 1. PR 情報の取得

```bash
gh pr view --json number,url,title,headRefName
```

owner/repo は url から抽出する。

### 2. 全コメントの取得

レビューコメントと PR コメントの **両方** を取得し、対応対象を洗い出す。

#### 2a. コード上のレビューコメント（review threads）

`gh pr view --json reviewThreads` は利用できないため、GraphQL API を使う。

```bash
gh api graphql -f query='
{
  repository(owner: "{owner}", name: "{repo}") {
    pullRequest(number: {pr_number}) {
      reviewThreads(first: 100) {
        nodes {
          isResolved
          comments(first: 10) {
            nodes {
              id
              databaseId
              author { login }
              body
              path
              line
            }
          }
        }
      }
    }
  }
}' --jq '.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved == false) | {path: .comments.nodes[0].path, line: .comments.nodes[0].line, author: .comments.nodes[0].author.login, comment_id: .comments.nodes[0].databaseId, body: .comments.nodes[0].body, reply_count: (.comments.nodes | length)}'
```

未解決（`isResolved == false`）のスレッドのみ対応対象とする。

#### 2b. PR コメント（issue comments）

```bash
gh pr view --json comments --jq '.comments[] | {author: .author.login, body: .body, id: .id}'
```

bot の自動生成サマリ（coderabbitai の Walkthrough 等）は対応対象外。人間のレビュアーまたは bot のコード指摘コメントを対応対象とする。

### 3. 対応方針の策定

取得した全コメントを一覧化し、各コメントに対して以下を判断する:
- **妥当な指摘** → コード修正が必要
- **妥当でない指摘** → 反論コメントを投稿

対応方針をユーザーに報告してから修正に着手する。

### 4. 修正の実施

#### 指摘が妥当な場合

1. 該当ファイルを Read で読み込み、指摘箇所を Edit で修正する
2. 関連する修正はまとめて1コミットにしてよい
   ```bash
   git add <修正したファイル>
   git commit -m "fix: <修正内容の要約>"
   ```

#### 指摘が妥当でない場合

反論コメントを準備する（投稿は push 後にまとめて行う）。

### 5. push とコメント返信

全修正が完了したら push し、その後各コメントに返信する。

```bash
git push origin <branch>
```

#### コード上のレビューコメントへの返信

```bash
gh api repos/{owner}/{repo}/pulls/{pr_number}/comments -F in_reply_to={comment_id} \
  -f body="修正しました。{commit_hash}"
```

#### PR コメントへの返信

```bash
gh pr comment {pr_number} --body "修正しました（{commit_hash}）"
```

#### 反論の場合

```bash
# コードコメントへの反論
gh api repos/{owner}/{repo}/pulls/{pr_number}/comments -F in_reply_to={comment_id} \
  -f body="{反論の内容}"

# PR コメントへの反論
gh pr comment {pr_number} --body "{反論の内容}"
```

### 6. 対応の報告

全コメントへの対応が完了したら、対応内容をまとめてユーザーに報告する。

## ルール

- コード上のレビューコメントと PR コメントの **両方** を漏れなく確認する
- コミットメッセージは英語でレビュー対応の内容を簡潔に示す
- 修正完了後は push まで自動実行し、push 後にコメント返信する
- 反論は根拠を明示し、感情的な表現を避ける

$ARGUMENTS
