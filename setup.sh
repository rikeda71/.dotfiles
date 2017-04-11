#!/bin/bash

DOT_FILES=( .zshrc .zshenv .tmux.conf .vimrc .vim )

for file in ${DOT_FILES[@]}
do
  ln -s $HOME/.dotfiles/$file $HOME/$file
done
