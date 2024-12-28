{
  description = "My Nix configuration";

  # This section defines which package sources it should look up
  inputs = {
    # NixOS official package source
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # home-manager's repository
    home-manager = {
      url = "github:nix-community/home-manager";
      # It instructs home-manager to use the same packages as nixpkgs in this file
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Ghostty
    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.nixpkgs-unstable.follows = "nixpkgs";
    };

    # nixGL is required if you're not in NixOS, so that packages can refer to
    # openGL-related libraries under Nix's management
    nixgl = {
      url = "github:nix-community/nixgl";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ghostty, nixgl, ... }@inputs: let

    selectPkgs = system: import nixpkgs {
      inherit system;
      # This makes ghostty available through a single source (`pkgs` below)
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

