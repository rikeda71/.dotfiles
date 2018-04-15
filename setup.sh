#!/bin/bash

DOT_FILES=( .zshrc .zshenv .tmux.conf .vimrc )

for file in ${DOT_FILES[@]}
do
  if [ ! -e "$HOME/$file" ]; then
    ln -fs $HOME/.dotfiles/$file $HOME
  fi
done

ln -fsdT ~/.dotfiles/.vim/ ~/.vim
ln -fsdT ~/.vim ~/.config/nvim
ln -fs ~/.vimrc ~/.config/nvim/init.vim
