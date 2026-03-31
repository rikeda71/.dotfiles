{ pkgs, config, lib, username, dotfilesPath, ... }:

{
  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "24.11";

  # ========================
  # ドットファイル symlinks (mkOutOfStoreSymlink)
  # ========================

  # $HOME 直下
  home.file.".zshrc".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.zshrc";
  home.file.".vimrc".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.vimrc";
  home.file.".ideavimrc".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.ideavimrc";
  home.file.".vim".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.vim";
  home.file.".gitconfig".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.gitconfig";

  # ~/.ssh
  home.file.".ssh/config".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.ssh/config";

  # ~/.config
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/nvim";
  xdg.configFile."starship.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/starship.toml";
  xdg.configFile."mise/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/mise/config.toml";

  # macOS アプリ設定
  home.file."Library/Application Support/com.mitchellh.ghostty/config".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/ghostty/config";
  home.file."Library/Application Support/Code/User/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.vscode/settings.json";

  # Claude Code
  home.file.".claude/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.claude/settings.json";
  home.file.".claude/CLAUDE.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.claude/CLAUDE.md";
  home.file.".claude/mcp-servers/package.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.claude/mcp-servers/package.json";

  # GnuPG
  home.file.".gnupg/dirmngr.conf".text = "standard-resolver\n";

  # ========================
  # Activation scripts
  # ========================

  home.activation = {
    # SSH ディレクトリのパーミッション設定
    sshSetup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run mkdir -p "$HOME/.ssh"
      run chmod 700 "$HOME/.ssh"
    '';

    # vim-plug インストール
    vimPlug = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
        run ${pkgs.curl}/bin/curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
          https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      fi
    '';

    # Claude Code セットアップ
    claudeSetup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run mkdir -p "$HOME/.claude/mcp-servers"
      run chmod +x "${dotfilesPath}/.claude/hooks/"*.sh 2>/dev/null || true
      run chmod +x "${dotfilesPath}/.claude/statusline.sh" 2>/dev/null || true

      if [ -f "$HOME/.claude/mcp-servers/package.json" ]; then
        (cd "$HOME/.claude/mcp-servers" && ${pkgs.nodejs}/bin/npm install) || true
      fi

      if command -v claude &>/dev/null; then
        ${pkgs.zsh}/bin/zsh "${dotfilesPath}/.claude/install-mcp.sh" || true
        ${pkgs.zsh}/bin/zsh "${dotfilesPath}/.claude/install-skills.sh" || true
      fi
    '';
  };

  programs.home-manager.enable = true;
}
