{
  description = "rikeda71 dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ... }:
    let
      system = "aarch64-darwin";
      username = let
        sudoUser = builtins.getEnv "SUDO_USER";
        user = builtins.getEnv "USER";
      in if sudoUser != "" then sudoUser else user;
      dotfilesPath = "/Users/${username}/.dotfiles";
      mkDarwinConfig = { hostModule, hostName }: nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit username dotfilesPath self; };
        modules = [
          ./nix/common.nix
          ./nix/darwin.nix
          hostModule
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit username dotfilesPath hostName; };
            home-manager.users.${username} = import ./nix/home.nix;
          }
        ];
      };
    in
    {
      darwinConfigurations = {
        personal = mkDarwinConfig { hostModule = ./nix/hosts/personal.nix; hostName = "personal"; };
        work = mkDarwinConfig { hostModule = ./nix/hosts/work.nix; hostName = "work"; };
      };
    };
}
