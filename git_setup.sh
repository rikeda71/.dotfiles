#!/bin/sh
# http://qiita.com/wnoguchi/items/f7358a227dfe2640cce3 参考
git config --global user.name "First-name Family-name"
git config --global user.email "username@example.com"
git config --global core.editor 'vim -c "set fenc=utf-8"'
git config --global color.diff auto
git config --global color.status auto
git config --global color.branch auto
#git config --global push.default simple
git config --global core.precomposeunicode true
git config --global core.quotepath false
# 以下「~/.netrc」に記述
# machine github.com
# login account_name
# password account_pass

