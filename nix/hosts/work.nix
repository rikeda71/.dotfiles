{ pkgs, ... }:

{
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
