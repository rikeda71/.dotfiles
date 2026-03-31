{ pkgs, username, self, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # CLI ツール
    coreutils
    difftastic
    eza
    fzf
    gnused
    jq
    starship
    tree
    wget

    # Git 関連
    gh
    ghq
    git-lfs
    lazygit

    # エディタ
    neovim

    # インフラ
    awscli2
    cloudflared
    google-cloud-sdk

    # DB クライアント
    mysql-client
    postgresql_16

    # ビルドツール
    protobuf

    # メディア
    ffmpeg
    imagemagick
    plantuml
  ];

  programs.zsh.enable = true;

  users.users.${username} = {
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };

  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 5;
}
