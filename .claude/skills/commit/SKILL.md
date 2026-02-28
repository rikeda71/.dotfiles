---
<<<<<<<< HEAD:.claude/skills/commit/SKILL.md
name: commit
description: ステージされた変更からコミットを作成する。"コミットして", "commit", "変更をコミット" と言われた場合に使用する。
allowed-tools: Bash(git add *), Bash(git commit *), Bash(git diff *), Bash(git log *), Bash(git show *), Bash(git status *), Glob, Grep, Read
---
========
name: commit-maker
description: >
  Creates git commits from staged changes using Conventional Commits format.
  Analyzes staged diffs and generates appropriate commit messages.
allowed-tools:
  - Bash(git add *)
  - Bash(git commit *)
  - Bash(git diff *)
  - Bash(git log *)
  - Bash(git show *)
  - Bash(git status *)
  - Glob
  - Grep
  - Read
---

# commit-maker
>>>>>>>> origin/master:.claude/skills/commit-maker/SKILL.md

# Git コミットの作成

ステージされた変更から適切なコミットメッセージを生成し、コミットを作成する。

## ルール

- Conventional Commits 形式でコミットメッセージを作成する
  - フォーマット: `type(scope): subject`
  - type: feat, fix, docs, style, refactor, test, chore など
- `git diff --staged` で変更内容を確認してからコミットメッセージを決定する
- `git add` は実行しない（ステージングはユーザーが行う）
- コミットメッセージは英語で記述する
- subject は小文字で始め、末尾にピリオドをつけない

## 手順

1. `git status` でステージされたファイルを確認する
2. `git diff --staged` で変更内容を確認する
3. 変更内容に適したコミットメッセージを作成する
4. `git commit -m "..."` でコミットを実行する

$ARGUMENTS
