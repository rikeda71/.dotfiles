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
      username = "rikeda";
      dotfilesPath = "/Users/${username}/.dotfiles";
      mkDarwinConfig = hostModule: nix-darwin.lib.darwinSystem {
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
            home-manager.extraSpecialArgs = { inherit username dotfilesPath; };
            home-manager.users.${username} = import ./nix/home.nix;
          }
        ];
      };
    in
    {
      darwinConfigurations = {
        personal = mkDarwinConfig ./nix/hosts/personal.nix;
        work = mkDarwinConfig ./nix/hosts/work.nix;
      };
    };
}
