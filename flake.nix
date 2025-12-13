{
  description = "Rijan's NixOS Configuration Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      overlay = final: prev: {
        google-antigravity = final.callPackage ./pkgs/antigravity/default.nix { };
        plink2 = final.callPackage ./pkgs/plink2/default.nix { };
        mzmine = final.callPackage ./pkgs/mzmine/default.nix { };
        snpeff = final.callPackage ./pkgs/snpeff/default.nix { };
        edge-tts = final.callPackage ./pkgs/edge-tts/default.nix { };
      };

      pkgs = import nixpkgs {
        inherit system;
        overlays = [ overlay ];

        config = {
          allowUnfree = true;
          permittedInsecurePackages = [
            "electron-27.3.11"
          ];
        };
      };

    in {
      nixosConfigurations = {
        "nixos" = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs pkgs; };

          modules = [
            ./hardware-configuration.nix
            ./configuration.nix
            home-manager.nixosModules.home-manager
          ];
        };
      };
    };
}
