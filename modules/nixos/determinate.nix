# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                        Determinate Nix Configuration                         ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
#
# Determinate Nix is an enhanced distribution of Nix by Determinate Systems.
# It provides performance improvements and quality-of-life features not yet
# available in upstream Nix.
#
# Key Features (enabled by default):
#   • Lazy Trees: Only copies files that expressions actually need (3-20x faster)
#   • Managed GC: Automatic garbage collection to maintain disk space
#   • FlakeHub Cache: Access to pre-built binaries for faster builds
#   • Flakes & nix-command enabled by default
#
# Optional Feature (requires manual setup):
#   • Parallel Evaluation: Spreads Nix evaluation across multiple CPU cores
#
# Documentation: https://docs.determinate.systems/determinate-nix
#
# ════════════════════════════════════════════════════════════════════════════════
#                         Custom Configuration
# ════════════════════════════════════════════════════════════════════════════════
#
# Determinate Nix manages /etc/nix/nix.conf itself. To add custom settings,
# create or edit /etc/nix/nix.custom.conf
#
# Example: Enable parallel evaluation (uses all CPU cores)
#
#   sudo tee /etc/nix/nix.custom.conf << 'EOF'
#   # Use all cores for parallel evaluation (0 = auto, 1 = disabled)
#   eval-cores = 0
#   EOF
#
# After adding custom settings, restart the Nix daemon:
#   sudo systemctl restart nix-daemon
#
# ════════════════════════════════════════════════════════════════════════════════

{ config, lib, ... }:

{
  # The Determinate NixOS module (determinate.nixosModules.default) is loaded
  # directly in flake.nix. This file serves as documentation and a placeholder
  # for any future NixOS-level configuration that complements Determinate Nix.
  
  # No additional configuration needed - Determinate Nix works out of the box!
}
