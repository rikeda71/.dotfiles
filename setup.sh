#!/bin/zsh

# use homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# install from Brewfile
brew bundle

# symbolic links
DOT_FILES=( .zshrc .vimrc .vim .ideavimrc .gitconfig .ssh/config )

mkdir -p ~/.ssh
chmod 700 ~/.ssh
for file in ${DOT_FILES[@]}
do
  ln -fs $HOME/.dotfiles/$file $HOME/$file
done

# neovim settings
mkdir -p ~/.config
ln -fs ~/.dotfiles/nvim ~/.config/nvim

# starship
ln -fs ~/.dotfiles/starship.toml ~/.config/starship.toml

# mise
mkdir -p ~/.config/mise
ln -fs ~/.dotfiles/mise/config.toml ~/.config/mise/config.toml

# ghostty settings
mkdir -p "$HOME/Library/Application Support/com.mitchellh.ghostty"
ln -fs "$HOME/.dotfiles/ghostty/config" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"

# vscode settings
case "${OSTYPE}" in
  darwin*)
    if [ -e ~/Library/Application\ Support/Code/User ]; then
      ln -fs $HOME/.dotfiles/.vscode/settings.json ~/Library/Application\ Support/Code/User/
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

# claude code settings
mkdir -p "$HOME/.claude/mcp-servers"
ln -fs "$HOME/.dotfiles/.claude/settings.json" "$HOME/.claude/settings.json"
ln -fs "$HOME/.dotfiles/.claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
ln -fs "$HOME/.dotfiles/.claude/mcp-servers/package.json" "$HOME/.claude/mcp-servers/package.json"
chmod +x "$HOME/.dotfiles/.claude/hooks/"*.sh
chmod +x "$HOME/.dotfiles/.claude/statusline.sh"
(cd "$HOME/.claude/mcp-servers" && npm install)
zsh "$HOME/.dotfiles/.claude/install-mcp.sh"
zsh "$HOME/.dotfiles/.claude/install-skills.sh"

source ~/.dotfiles/.zshrc
