# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                      Rijan's NixOS Configuration Flake                       ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
#
# This flake defines the complete NixOS system configuration.
#
# Key Components:
#   • Determinate Nix: Enhanced Nix distribution with parallel evaluation & lazy trees
#   • Home Manager: User environment management integrated into the system
#   • Custom Packages: Local overlays for packages not in nixpkgs
#
# Usage:
#   Build:    nixos-rebuild build --flake .#nixos
#   Switch:   sudo nixos-rebuild switch --flake .#nixos
#   Update:   nix flake update
#
# Documentation:
#   • Determinate Nix: https://docs.determinate.systems/determinate-nix
#   • NixOS Flakes:    https://nixos.wiki/wiki/Flakes
#   • Home Manager:    https://nix-community.github.io/home-manager/

{
  description = "Rijan's NixOS Configuration Flake";

  # ════════════════════════════════════════════════════════════════════════════
  #                                 INPUTS
  # ════════════════════════════════════════════════════════════════════════════
  # Inputs are external dependencies fetched from various sources.
  # These are locked in flake.lock for reproducibility.

  inputs = {
    # ─────────────────────────────────────────────────────────────────────────
    # Determinate Nix: Enhanced Nix with performance features
    # ─────────────────────────────────────────────────────────────────────────
    # Provides:
    #   • Parallel evaluation (eval-cores): Faster flake operations
    #   • Lazy trees: Only copies files actually needed (3-20x faster)
    #   • Managed garbage collection: Automatic disk space management
    #   • FlakeHub cache access: Faster binary downloads
    #
    # NOTE: We intentionally don't use `follows = "nixpkgs"` here to maximize
    # cache hits from FlakeHub. This is Determinate's recommendation.
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";

    # ─────────────────────────────────────────────────────────────────────────
    # Nixpkgs: The Nix Packages collection
    # ─────────────────────────────────────────────────────────────────────────
    # Using nixos-unstable for the latest tested packages.
    # nixos-25.05 will become the stable option when released (~May 2026).
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # ─────────────────────────────────────────────────────────────────────────
    # Home Manager: Declarative user environment management
    # ─────────────────────────────────────────────────────────────────────────
    # Manages dotfiles, user packages, and per-user services declaratively.
    # The `follows` directive ensures Home Manager uses our nixpkgs version.
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # ════════════════════════════════════════════════════════════════════════════
  #                                 OUTPUTS
  # ════════════════════════════════════════════════════════════════════════════
  # Outputs define what this flake provides: NixOS configurations, packages, etc.

  outputs = { self, nixpkgs, home-manager, determinate, ... }@inputs:
    let
      # ───────────────────────────────────────────────────────────────────────
      # System Architecture
      # ───────────────────────────────────────────────────────────────────────
      system = "x86_64-linux";

      # ───────────────────────────────────────────────────────────────────────
      # Custom Package Overlay
      # ───────────────────────────────────────────────────────────────────────
      # Overlays allow us to add or modify packages in nixpkgs.
      # These custom packages are defined in ./pkgs/ and become available
      # as pkgs.<package-name> throughout the configuration.
      #
      # Pattern: final.callPackage imports the derivation and provides
      # all standard dependencies automatically.
      customOverlay = final: prev: {
        google-antigravity = final.callPackage ./pkgs/antigravity/default.nix { };
        plink2             = final.callPackage ./pkgs/plink2/default.nix { };
        mzmine             = final.callPackage ./pkgs/mzmine/default.nix { };
        snpeff             = final.callPackage ./pkgs/snpeff/default.nix { };
        edge-tts           = final.callPackage ./pkgs/edge-tts/default.nix { };
      };

    in
    {
      # ─────────────────────────────────────────────────────────────────────────
      # NixOS System Configurations
      # ─────────────────────────────────────────────────────────────────────────
      # Each attribute here is a complete NixOS system configuration.
      # Build with: nixos-rebuild switch --flake .#<name>

      nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
        inherit system;

        # Special arguments passed to all modules
        specialArgs = {
          inherit inputs;
        };

        # ─────────────────────────────────────────────────────────────────────
        # Module Loading Order
        # ─────────────────────────────────────────────────────────────────────
        # Modules are evaluated in order, with later modules able to override
        # earlier ones. The order here reflects logical dependencies.
        modules = [
          # Determinate Nix (MUST be first to properly configure Nix)
          # This replaces stock Nix with Determinate Nix distribution
          determinate.nixosModules.default

          # ─────────────────────────────────────────────────────────────────
          # Nixpkgs Configuration
          # ─────────────────────────────────────────────────────────────────
          # Configure nixpkgs inline here for clarity. This sets overlays,
          # allowUnfree, and other package-set options.
          ({ pkgs, ... }: {
            nixpkgs = {
              hostPlatform = system;
              overlays = [ customOverlay ];
              config = {
                # Allow proprietary packages (e.g., Chrome, Spotify, VSCode)
                allowUnfree = true;

              };
            };
          })

          # Hardware-specific configuration (auto-generated)
          ./hardware-configuration.nix

          # Main system configuration
          ./configuration.nix

          # Home Manager integration (user environment management)
          home-manager.nixosModules.home-manager
        ];
      };
    };
}
