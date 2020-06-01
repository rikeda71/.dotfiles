#!/bin/zsh

# add submodule
git submodule update --init --recursive

# prezto
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

DOT_FILES=( .zshrc .zshenv .tmux.conf .vimrc .vim .latexmkrc .zpreztorc .zprezto )

for file in ${DOT_FILES[@]}
do
  if [ ! -e "$HOME/$file" ]; then
    ln -fs $HOME/.dotfiles/$file $HOME
  fi
done

mkdir -p ~/.jenv/versions

curl -flo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

chsh -s $(which zsh)

source ~/.dotfiles/.zshrc
source ~/.dotfiles/.zpreztorc

