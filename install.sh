#!/bin/sh
apt-get update
# zsh
apt-get install zsh
chsh -s /bin/zsh
# vim
apt-get install vim
mkdir -p ~/.vim/bundle
git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
# tmux
apt-get install tmux
# powerline
sh ~/.dotfiles/powerline.sh
# ruby
sh ~/.dotfiles/rbenv.sh
