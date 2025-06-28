# modules/nixos/waydroid.nix
{ config, pkgs, lib, ... }:

{
  # Enable the core Waydroid service and basic setup
  # This option handles setting up the necessary systemd services,
  # user groups, and potentially some default configurations.
  virtualisation.waydroid.enable = true;

  # Waydroid requires specific kernel modules to function correctly.
  # - binder_linux: Facilitates Android's Binder IPC mechanism.
  # - ashmem_linux: Provides Android's anonymous shared memory system.
  # We add these to the list of modules loaded at boot.
  # Note: If you have other modules defined elsewhere, you might need
  # to merge these lists instead of overwriting.
  boot.kernelModules = [
    "binder_linux"
    "ashmem_linux"
  ];

  # Waydroid often benefits from the Pressure Stall Information (PSI)
  # kernel feature being enabled. This helps the Android userspace
  # scheduler make better decisions.
  # We add "psi=1" to the kernel command line parameters.
  # Note: Similar to kernelModules, if you set kernelParams elsewhere,
  # you might need to merge this value carefully.
  boot.kernelParams = [
    "psi=1"
  ];

  # Optional: Specify the Waydroid package explicitly.
  # Usually not needed as it defaults to pkgs.waydroid, but shown for completeness.
  # virtualisation.waydroid.package = pkgs.waydroid;

  # Important Prerequisite Notes (Not Nix code, but essential steps):
  #
  # 1. Wayland Compositor: Waydroid requires a running Wayland compositor
  #    (e.g., Sway, Hyprland, GNOME on Wayland, KDE Plasma on Wayland).
  #    Ensure your desktop environment is running on Wayland.
  #
  # 2. Initialisation (Post NixOS Rebuild): After enabling Waydroid in your
  #    NixOS configuration and rebuilding (`sudo nixos-rebuild switch`),
  #    you MUST run the initialisation command manually in your terminal:
  #
  #    $ sudo waydroid init
  #
  #    This command downloads the necessary Android system and vendor images.
  #    It is an imperative step that cannot be fully automated within the
  #    declarative NixOS build process itself.
  #
  # 3. Starting Waydroid: Once initialised, you can start the Waydroid UI using:
  #
  #    $ waydroid show-full-ui
  #
  #    Or start the session service in the background:
  #
  #    $ waydroid session start
  #
  #    (The show-full-ui command usually starts the session if it's not running).
  #
  # 4. GPU Acceleration:
  #    - Intel/AMD: Should generally work out-of-the-box with Mesa drivers.
  #    - NVIDIA: May require additional configuration depending on your driver
  #      (proprietary vs. Nouveau) and system setup. Ensure kernel modesetting
  #      is enabled. Consult the NixOS Wiki or Waydroid documentation for specifics.
}
