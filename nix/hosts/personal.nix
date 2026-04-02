{ pkgs, ... }:

let
  localConfig = ./personal-local.nix;
in
{
  imports = if builtins.pathExists localConfig then [ localConfig ] else [];
  networking.hostName = "rikeda-personal";

  environment.systemPackages = with pkgs; [
  ];
}
