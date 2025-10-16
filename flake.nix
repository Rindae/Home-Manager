{
  description = "Home Manager configuration of adriendumazaud";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      	url = "github:nix-community/home-manager";
      	inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
    	url = "github:nix-community/nixvim";
    	inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
  { nixpkgs, home-manager, nixvim, ... }:
  let
      system = "aarch64-darwin";
  pkgs = nixpkgs.legacyPackages.${system};
  in
  {
      homeConfigurations."adriendumazaud" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

# Specify your home configuration modules here, for example,
# the path to your home.nix.
          modules = [ ./home.nix ];

# Optionally use extraSpecialArgs
# to pass through arguments to home.nix
          extraSpecialArgs = {
              nixvim = nixvim;
          };
      };
  };
}
