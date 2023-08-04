#!/bin/zsh

# use homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# install from Brewfile
brew bundle

# symbolic links
DOT_FILES=( .zshrc .zshenv .tmux.conf .vimrc .vim .latexmkrc .ideavimrc .gitconfig )

for file in ${DOT_FILES[@]}
do
  if [ ! -e "$HOME/$file" ]; then
    rm -rf $HOME/$file
    ln -fs $HOME/.dotfiles/$file $HOME
  fi
done

# symbolic link of starship config
curl -sS https://starship.rs/install.sh | sh
mkdir -p ~/.config
ln -fs ~/.dotfiles/starship.toml ~/.config/starship.toml

# vscode settings
case "${OSTYPE}" in
  darwin*)
    if [ -e ~/Library/Application\ Support/Code/User ]; then
      ln -fs $HOME/.dotfiles/.vscode/settings.json ~/Library/Application\ Support/Code/User/
      for extension in `cat ~/.dotfiles/.vscode/extensions`; do
        code --install-extension $extension
      done
    fi
    ;;
esac

curl -flo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


case "${OSTYPE}" in
  linux*)
    chsh -s $(which zsh)
    ;;
esac

mkdir -p ~/.gnupg
echo "standard-resolver" >  ~/.gnupg/dirmngr.conf

source ~/.dotfiles/.zshrc
