#!/bin/zsh

DOTFILES="$HOME/.dotfiles"

#====================
# Homebrew
#====================

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew bundle --file="$DOTFILES/Brewfile"

#====================
# シンボリックリンク（$HOME 直下）
#====================

DOT_FILES=( .zshrc .vimrc .vim .ideavimrc .gitconfig .ssh/config )

mkdir -p ~/.ssh
chmod 700 ~/.ssh
for file in ${DOT_FILES[@]}; do
  ln -fs "$DOTFILES/$file" "$HOME/$file"
done

#====================
# ~/.config 配下
#====================

mkdir -p ~/.config/mise

ln -fs "$DOTFILES/nvim"             ~/.config/nvim
ln -fs "$DOTFILES/starship.toml"    ~/.config/starship.toml
ln -fs "$DOTFILES/mise/config.toml" ~/.config/mise/config.toml

#====================
# Vim プラグイン
#====================

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

#====================
# GnuPG
#====================

mkdir -p ~/.gnupg
echo "standard-resolver" > ~/.gnupg/dirmngr.conf

#====================
# Claude Code
#====================

mkdir -p "$HOME/.claude/mcp-servers"
ln -fs "$DOTFILES/.claude/settings.json"            "$HOME/.claude/settings.json"
ln -fs "$DOTFILES/.claude/CLAUDE.md"                "$HOME/.claude/CLAUDE.md"
ln -fs "$DOTFILES/.claude/mcp-servers/package.json" "$HOME/.claude/mcp-servers/package.json"
chmod +x "$DOTFILES/.claude/hooks/"*.sh
chmod +x "$DOTFILES/.claude/statusline.sh"
(cd "$HOME/.claude/mcp-servers" && npm install)
zsh "$DOTFILES/.claude/install-mcp.sh"
zsh "$DOTFILES/.claude/install-skills.sh"

#====================
# macOS 固有
#====================

case "${OSTYPE}" in
  darwin*)
    # macOS 設定
    zsh "$DOTFILES/macos.sh"

    # Ghostty
    mkdir -p "$HOME/Library/Application Support/com.mitchellh.ghostty"
    ln -fs "$DOTFILES/ghostty/config" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"

    # VS Code
    if [ -e ~/Library/Application\ Support/Code/User ]; then
      ln -fs "$DOTFILES/.vscode/settings.json" ~/Library/Application\ Support/Code/User/
    fi
    ;;
  linux*)
    chsh -s "$(which zsh)"
    ;;
esac

#====================
# 完了
#====================

source "$DOTFILES/.zshrc"
echo "Setup completed."
