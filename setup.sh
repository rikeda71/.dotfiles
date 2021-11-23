#!/bin/zsh

# use Starship
echo "install 'Starship' prompt"
echo "press 'y' key!"
sh -c "$(curl -fsSL https://starship.rs/install.sh)"

# symbolic links
DOT_FILES=( .zshrc .zshenv .tmux.conf .vimrc .vim .latexmkrc .ideavimrc .gitconfig )

for file in ${DOT_FILES[@]}
do
  if [ ! -e "$HOME/$file" ]; then
    rm -rf $HOME/$file
    ln -fs $HOME/.dotfiles/$file $HOME
  fi
done

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

mkdir -p ~/.jenv/versions

curl -flo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

chsh -s $(which zsh)

source ~/.dotfiles/.zshrc
