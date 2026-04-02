{ pkgs, ... }:

let
  localConfig = ./work-local.nix;
in
{
  imports = if builtins.pathExists localConfig then [ localConfig ] else [];
  networking.hostName = "rikeda-work";

  environment.systemPackages = with pkgs; [
    _1password-cli
    kubectl
    kustomize
  ];

  homebrew.casks = [
    "intellij-idea"
  ];
}
