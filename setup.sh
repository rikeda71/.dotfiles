#!/bin/sh

#sh ~/.dotfiles/install.sh

DOT_FILES=( .vimrc .zshrc .zshenv .tmux.conf .rbenv_init )

for file in ${DOT_FILES[@]}
do
  ln -s $HOME/.dotfiles/$file $HOME/$file
done
