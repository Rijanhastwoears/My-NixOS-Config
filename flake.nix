{
  description = "Rijan's NixOS Configuration Flake";

  inputs = {
    # Don't use `follows = "nixpkgs"` here to maximize FlakeHub cache hits
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, determinate, ... }@inputs:
    let
      system = "x86_64-linux";

      customOverlay = final: prev: {
        google-antigravity = final.callPackage ./pkgs/antigravity/default.nix { };
        plink2             = final.callPackage ./pkgs/plink2/default.nix { };
        mzmine             = final.callPackage ./pkgs/mzmine/default.nix { };
        snpeff             = final.callPackage ./pkgs/snpeff/default.nix { };
        edge-tts           = final.callPackage ./pkgs/edge-tts/default.nix { };
      };

    in
    {
      nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs;
        };

        modules = [
          # Must be first to properly configure Nix
          determinate.nixosModules.default

          ({ pkgs, ... }: {
            nixpkgs = {
              hostPlatform = system;
              overlays = [ customOverlay ];
              config = {
                allowUnfree = true;
              };
            };
          })

          ./hardware-configuration.nix
          ./configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };
    };
}
