# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                         NixOS System Configuration                           ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
#
# This is the main configuration entry point for the NixOS system.
# It imports modular configurations and defines core system settings.
#
# Structure:
#   ./modules/nixos/     - System-level modules (services, hardware, etc.)
#   ./modules/home-manager/ - User-level modules (packages, dotfiles, etc.)
#   ./pkgs/              - Custom package definitions
#
# After making changes:
#   sudo nixos-rebuild switch --flake .#nixos

{ config, pkgs, lib, inputs, ... }:
# pkgs is provided by the NixOS module system with our overlays applied

{
  # ════════════════════════════════════════════════════════════════════════════
  #                              Module Imports
  # ════════════════════════════════════════════════════════════════════════════
  # Each module encapsulates related configuration. This keeps the main config
  # clean and makes it easy to enable/disable features.

  imports = [
    # ─────────────────────────────────────────────────────────────────────────
    # Core System
    # ─────────────────────────────────────────────────────────────────────────
    ./modules/nixos/determinate.nix  # Determinate Nix performance settings
    ./modules/nixos/bootloader.nix   # Systemd-boot configuration
    ./modules/nixos/locale.nix       # Timezone & internationalization
    ./modules/nixos/networking.nix   # Hostname & NetworkManager

    # ─────────────────────────────────────────────────────────────────────────
    # Hardware & Services
    # ─────────────────────────────────────────────────────────────────────────
    ./modules/nixos/audio.nix        # PipeWire audio stack
    ./modules/nixos/DNS.nix          # Custom DNS (Cloudflare Family)
    ./modules/nixos/printing.nix     # CUPS & network printing
    ./modules/nixos/xserver.nix      # X11, GDM, GNOME

    # ─────────────────────────────────────────────────────────────────────────
    # Applications & Virtualization
    # ─────────────────────────────────────────────────────────────────────────
    ./modules/nixos/kbfs.nix         # Keybase filesystem
    ./modules/nixos/postgres.nix     # PostgreSQL database
    ./modules/nixos/waydroid.nix     # Android container
  ];

  # ════════════════════════════════════════════════════════════════════════════
  #                              User Account
  # ════════════════════════════════════════════════════════════════════════════
  # Primary user account definition. Groups grant specific permissions:
  #   • wheel: sudo access
  #   • networkmanager: network configuration without sudo

  users.users.rijan = {
    isNormalUser = true;
    description = "Rijan";
    extraGroups = [
      "wheel"          # Sudo access
      "networkmanager" # Network configuration
    ];
    shell = pkgs.fish;
  };

  # ════════════════════════════════════════════════════════════════════════════
  #                             Home Manager
  # ════════════════════════════════════════════════════════════════════════════
  # Home Manager manages user-specific packages and configuration.
  # It's integrated as a NixOS module for atomic system+user updates.

  home-manager.users.rijan = import ./modules/home-manager/rijan.nix;

  # ════════════════════════════════════════════════════════════════════════════
  #                            Shell Configuration
  # ════════════════════════════════════════════════════════════════════════════
  # Enable Fish shell system-wide. This is needed even though the user's
  # shell is set to Fish above, as NixOS needs to add it to /etc/shells.

  programs.fish.enable = true;

  # ════════════════════════════════════════════════════════════════════════════
  #                         Display Manager Settings
  # ════════════════════════════════════════════════════════════════════════════
  # Enable Wayland in GDM for Waydroid compatibility.
  # Waydroid requires a Wayland compositor to function.

  services.xserver.displayManager.gdm.wayland = true;

  # ════════════════════════════════════════════════════════════════════════════
  #                           System Packages
  # ════════════════════════════════════════════════════════════════════════════
  # Packages installed system-wide. These are available to all users.
  # Custom packages from ./pkgs/ are made available via the flake overlay.
  #
  # NOTE: Prefer adding packages to home-manager for user-specific packages.
  # System packages should be reserved for system-wide tools.

  environment.systemPackages = with pkgs; [
    # Custom packages (defined in ./pkgs/)
    google-antigravity
    plink2
    mzmine
    snpeff
    edge-tts
  ];

  # ════════════════════════════════════════════════════════════════════════════
  #                            System Maintenance
  # ════════════════════════════════════════════════════════════════════════════
  # Automatic system updates. The system will update and optionally reboot
  # when new updates are available.
  #
  # NOTE: Determinate Nix handles garbage collection automatically, so
  # manual nix.gc settings are not needed.

  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    
    # Pull updates from your GitHub repo
    flake = "github:Rijan2055/My-NixOS-Config#nixos";
    
    # Run daily at 4 AM
    dates = "04:00";
    
    # Only reboot for kernel/initrd changes (optional, less disruptive)
    # rebootWindow = { lower = "03:00"; upper = "05:00"; };
  };

  # ════════════════════════════════════════════════════════════════════════════
  #                             State Version
  # ════════════════════════════════════════════════════════════════════════════
  # IMPORTANT: Do not change this value after initial installation!
  # This determines the NixOS release that this configuration is compatible with.
  # Changing it can break stateful services that depend on the version.
  #
  # To upgrade NixOS: Update the nixpkgs input in flake.nix instead.

  system.stateVersion = "25.05";

  # ════════════════════════════════════════════════════════════════════════════
  #                          Nix Configuration
  # ════════════════════════════════════════════════════════════════════════════
  # NOTE: Nix configuration is now managed by Determinate Nix!
  #
  # Determinate Nix automatically configures:
  #   • Flakes and nix-command (experimental features)
  #   • Optimal settings for performance
  #   • Garbage collection
  #
  # Custom settings can be added via:
  #   • ./modules/nixos/determinate.nix (determinate-nix.customSettings)
  #   • Directly in /etc/nix/nix.custom.conf
  #
  # The old manual configuration has been removed:
  # ┌────────────────────────────────────────────────────────────────────────┐
  # │  nix = {                                                               │
  # │    package = pkgs.nixVersions.stable;                                  │
  # │    extraOptions = ''experimental-features = nix-command flakes'';      │
  # │  };                                                                    │
  # └────────────────────────────────────────────────────────────────────────┘
}
