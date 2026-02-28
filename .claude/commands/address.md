---
allowed-tools: Bash(gh pr *), Bash(git diff *), Bash(git log *), Bash(git add *), Bash(git commit *), Bash(git status *), Glob, Grep, Read, Edit, Write
description: PR のレビューコメントに対応する
---

以下の手順で PR のレビューコメントに対応してください:

1. `gh pr view --json reviews,comments` でレビューコメントを確認する
2. 各コメントの内容を理解し、対応方針を検討する
3. 必要な修正を実施する
4. 修正内容をコミットする（ファイル名を指定してステージング）

$ARGUMENTS
