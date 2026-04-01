{ pkgs, ... }:

{
  networking.hostName = "rikeda-personal";

  environment.systemPackages = with pkgs; [
  ];
}
