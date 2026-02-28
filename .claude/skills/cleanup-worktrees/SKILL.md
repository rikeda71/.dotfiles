---
name: cleanup-worktrees
description: >
  不要な .claude/worktrees 配下のディレクトリを削除する。
  "worktree を整理", "worktree を削除", "cleanup worktrees" と言われた場合に使用する。
allowed-tools:
  - Bash(git worktree *)
  - Bash(git branch *)
  - Bash(git push origin --delete *)
  - Bash(gh pr *)
  - Bash(rm -rf *)
  - Bash(ls *)
  - Glob
  - Read
---

# 不要な worktree の削除

`.claude/worktrees` 配下の不要なディレクトリを特定し、削除する。

## ルール

- 削除対象の一覧をユーザーに提示し、確認後に削除する
- 現在作業中の worktree（カレントディレクトリ）は削除しない

## 不要と判断する基準

以下のいずれかに該当する worktree を不要と判断する（優先度順）:

1. **PR がマージ済み**: `gh pr list --state merged --head <branch>` で該当 PR がある
2. **ブランチが master にマージ済み**: `git branch --merged master` に含まれる
3. **リモートブランチが存在しない**: `git branch -r` に対応するリモートブランチがない
4. **git worktree として登録されていない**: `git worktree list` に含まれないディレクトリ

## 手順

1. `.claude/worktrees` 配下のディレクトリを列挙する
2. 各ディレクトリに対して上記基準を確認し、不要かどうか判定する
3. 結果を表形式で表示する（ディレクトリ名・ブランチ名・判定理由・削除対象かどうか）
4. ユーザーの確認後、`git worktree remove` でワークツリーを削除する
5. `git worktree prune` で不整合を解消する
6. 対応するリモートブランチがあれば `git push origin --delete <branch>` で削除する
