#!/bin/sh
apt-get update
# zsh
apt-get install zsh
chsh -s /bin/zsh
# vim
apt-get install vim
# tmux
apt-get install tmux
# powerline
sh powerline.sh
# ruby
sh rbemv.sh
