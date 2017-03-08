#!/bin/sh
# http://qiita.com/ringo/items/4351c6aee70ed6f346c8　参考
# rbenv + ruby の環境作成
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
apt-get install -y autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev
rbenv install 2.4.0
rbenv global 2.4.0
rbenv rehash
ruby -v
# 確認
which ruby
which gem
