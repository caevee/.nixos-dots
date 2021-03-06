{
  description = "System Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ...  }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };

    lib = nixpkgs.lib;

  in {

    homeManagerConfigurations = {
      caevee = home-manager.lib.homeManagerConfiguration {
        inherit system pkgs;
        username = "caevee";
        homeDirectory = "/home/caevee";
        configuration = {
          imports = [ ./home/home.nix ];
        };
      };
    };

    nixosConfigurations = {
      nixos = lib.nixosSystem {
        inherit system;

        modules = [
          ./hosts/configuration.nix
        ];

      };
    };


  };
}
