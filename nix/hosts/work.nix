{ pkgs, ... }:

{
  networking.hostName = "rikeda-work";

  environment.systemPackages = with pkgs; [
    _1password-cli
  ];
}
