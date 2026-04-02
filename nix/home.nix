{ pkgs, config, lib, username, dotfilesPath, hostName, ... }:

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
  home.file."Library/Application Support/Code/User/keybindings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.vscode/keybindings.json";

  # Claude Code
  home.file.".claude/CLAUDE.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/AGENTS.md";
  home.file.".claude/mcp-servers/package.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.claude/mcp-servers/package.json";


  # ========================
  # Activation scripts
  # ========================

  home.activation = {
    localNixSetup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      local_nix="${dotfilesPath}/nix/hosts/${hostName}-local.nix"
      template="${dotfilesPath}/nix/hosts/local.nix.template"
      if [ ! -f "$local_nix" ] && [ -f "$template" ]; then
        run cp "$template" "$local_nix"
      fi
    '';

    sshSetup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run mkdir -p "$HOME/.ssh"
      run chmod 700 "$HOME/.ssh"
    '';

    # vim-plug インストール (コミット固定)
    vimPlug = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
        run ${pkgs.curl}/bin/curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
          https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      fi
    '';

    miseInstall = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ -x "${pkgs.mise}/bin/mise" ]; then
        run "${pkgs.mise}/bin/mise" install --yes
      fi
    '';

    rustSetup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ -x "${pkgs.rustup}/bin/rustup" ]; then
        run "${pkgs.rustup}/bin/rustup" default stable 2>/dev/null || true
      fi
    '';

    # Codex CLI（nixpkgs 未収録のため npm でインストール、work のみ）
    codexInstall = lib.mkIf (hostName == "work") (lib.hm.dag.entryAfter [ "miseInstall" ] ''
      if [ -x "${pkgs.mise}/bin/mise" ]; then
        run "${pkgs.mise}/bin/mise" exec node -- npm i -g @openai/codex 2>/dev/null || true
      fi
    '');

    vscodeExtensions = let
      codeBin = "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code";
    in lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ -x "${codeBin}" ] && [ -f "${dotfilesPath}/.vscode/extensions" ]; then
        while IFS= read -r ext; do
          "${codeBin}" --install-extension "$ext" --force 2>/dev/null || true
        done < "${dotfilesPath}/.vscode/extensions"
      fi
    '';

    claudeSetup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run mkdir -p "$HOME/.claude/mcp-servers"

      # settings.json はコピー（シンリンクだと /model 等の変更が git に反映されるため）
      if [ -f "${dotfilesPath}/.claude/settings.json" ]; then
        run cp "${dotfilesPath}/.claude/settings.json" "$HOME/.claude/settings.json"
      fi

      if ls "${dotfilesPath}/.claude/hooks/"*.sh >/dev/null 2>&1; then
        run chmod +x "${dotfilesPath}/.claude/hooks/"*.sh
      fi
      if [ -f "${dotfilesPath}/.claude/statusline.sh" ]; then
        run chmod +x "${dotfilesPath}/.claude/statusline.sh"
      fi

      if [ -f "$HOME/.claude/mcp-servers/package.json" ] && \
         [ ! -d "$HOME/.claude/mcp-servers/node_modules" ]; then
        if ! (cd "$HOME/.claude/mcp-servers" && ${pkgs.nodejs}/bin/npm install); then
          echo "Warning: npm install for Claude MCP servers failed." >&2
        fi
      fi

      if command -v claude &>/dev/null; then
        run ${pkgs.zsh}/bin/zsh "${dotfilesPath}/.claude/install-mcp.sh" "${hostName}" || true
        run ${pkgs.zsh}/bin/zsh "${dotfilesPath}/.claude/install-skills.sh" || true
      fi
    '';
  };

  programs.home-manager.enable = true;
}
