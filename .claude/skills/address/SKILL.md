---
name: address
description: >
  PR のレビューコメントに対応する。
  "レビュー対応", "address comments", "指摘対応" と言われた場合に使用する。
allowed-tools:
  - Bash(gh pr *)
  - Bash(git diff *)
  - Bash(git log *)
  - Bash(git add *)
  - Bash(git commit *)
  - Bash(git status *)
  - Glob
  - Grep
  - Read
  - Edit
  - Write
---

# PR レビューコメントへの対応

PR のレビューコメントを確認し、必要な修正を実施する。

## 手順

1. `gh pr view --json reviews,comments` でレビューコメントを確認する
2. 各コメントの内容を理解し、対応方針を検討する
3. 必要な修正を実施する
4. 修正内容をコミットする（ファイル名を指定してステージング）

$ARGUMENTS
