{ pkgs, ... }:

{
  networking.hostName = "rikeda-work";

  environment.systemPackages = with pkgs; [
    _1password-cli
  ];

  # Codex CLI（nixpkgs 未収録のため npm でインストール）
  system.activationScripts.postActivation.text = ''
    if command -v npm &>/dev/null; then
      npm i -g @openai/codex 2>/dev/null || true
    fi
  '';
}
