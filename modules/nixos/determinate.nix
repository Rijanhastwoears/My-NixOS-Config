# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                        Determinate Nix Configuration                         ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
#
# Determinate Nix is an enhanced distribution of Nix by Determinate Systems.
# It provides performance improvements and quality-of-life features not yet
# available in upstream Nix.
#
# Features Enabled by Default:
#   • Lazy Trees: Only copies files that expressions actually need (3-20x faster)
#   • Managed GC: Automatic garbage collection to maintain disk space
#   • FlakeHub Cache: Access to pre-built binaries for faster builds
#   • Flakes & nix-command: Enabled out of the box
#
# Additional Feature Enabled Below:
#   • Parallel Evaluation: Spreads Nix evaluation across multiple CPU cores
#
# Documentation: https://docs.determinate.systems/determinate-nix
#
# ════════════════════════════════════════════════════════════════════════════════

{ config, lib, ... }:

{
  # ════════════════════════════════════════════════════════════════════════════
  #                      Custom Nix Configuration
  # ════════════════════════════════════════════════════════════════════════════
  # Determinate Nix manages /etc/nix/nix.conf itself. Custom settings must be
  # placed in /etc/nix/nix.custom.conf, which we manage declaratively here.

  environment.etc."nix/nix.custom.conf" = {
    text = ''
      # ═══════════════════════════════════════════════════════════════════════
      #                    Determinate Nix Custom Settings
      # ═══════════════════════════════════════════════════════════════════════
      # This file is managed by NixOS (modules/nixos/determinate.nix)
      # Do not edit manually - changes will be overwritten on rebuild.

      # ─────────────────────────────────────────────────────────────────────────
      # Parallel Evaluation
      # ─────────────────────────────────────────────────────────────────────────
      # Distributes Nix evaluation work across multiple CPU cores.
      # This dramatically speeds up operations like:
      #   • nix search
      #   • nix flake check
      #   • nix flake show
      #   • nix eval
      #
      # Values:
      #   0 = Use all available cores (recommended)
      #   1 = Disable parallel evaluation (single-threaded)
      #   N = Use exactly N cores
      eval-cores = 0
    '';
    mode = "0644";
  };
}
