#!/bin/bash

DOT_FILES=( .zshrc .zshenv .tmux.conf .vimrc .vim )

for file in ${DOT_FILES[@]}
do
  if [ ! -e "$HOME/$file" ]; then
    ln -s $HOME/.dotfiles/$file $HOME/$file
  fi
done

ln -s ~/.vim ~/.config/nvim
ln -s ~/.vimrc ~/.config/nvim/init.vim
