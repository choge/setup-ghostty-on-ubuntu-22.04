{
  description = "My Nix configuration";

  inputs = {
    # NixOS official package source
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      # It instructs home-manager to use the same packages as nixpkgs in this file ...?
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.nixpkgs-unstable.follows = "nixpkgs";
    };

    nixgl = {
      url = "github:nix-community/nixgl";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ghostty, nixgl, ... }@inputs: let

    selectPkgs = system: import nixpkgs {
      inherit system;
      overlays = [
        (final: prev: {
          ghostty = ghostty.packages.${system}.ghostty;
        })
      ];
    };

  in {

    homeConfigurations = {
      ubuntu = home-manager.lib.homeManagerConfiguration {
        pkgs = selectPkgs "x86_64-linux";
        extraSpecialArgs = {
          inherit nixgl;
        };

	modules = [
	  ./packages.nix
	];
      };
    };
  };
}

