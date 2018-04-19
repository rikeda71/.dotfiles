#!/bin/bash

DOT_FILES=( .zshrc .zshenv .tmux.conf .vimrc )

for file in ${DOT_FILES[@]}
do
  if [ ! -e "$HOME/$file" ]; then
    ln -fs $HOME/.dotfiles/$file $HOME
  fi
done

curl -flo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
