# commit-maker

Git コミットを作成するエージェントです。

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
