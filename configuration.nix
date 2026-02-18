{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    # Core
    ./modules/nixos/determinate.nix
    ./modules/nixos/bootloader.nix
    ./modules/nixos/locale.nix
    ./modules/nixos/networking.nix

    # Hardware & Services
    ./modules/nixos/audio.nix
    ./modules/nixos/DNS.nix
    ./modules/nixos/printing.nix
    ./modules/nixos/xserver.nix

    # Applications
    ./modules/nixos/postgres.nix
    ./modules/nixos/waydroid.nix
  ];

  users.users.rijan = {
    isNormalUser = true;
    description = "Rijan";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.fish;
  };

  home-manager.users.rijan = import ./modules/home-manager/rijan.nix;

  # Needed so Fish is added to /etc/shells
  programs.fish.enable = true;

  # Required for Waydroid
  services.xserver.displayManager.gdm.wayland = true;

  # Custom packages (defined in ./pkgs/)
  environment.systemPackages = with pkgs; [
    google-antigravity
    moly-ai
    plink2
    mzmine
    snpeff
    edge-tts
  ];

  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    flake = "github:Rijan2055/My-NixOS-Config#nixos";
    dates = "04:00";
  };

  # Do NOT change after initial install — breaks stateful services.
  # To upgrade NixOS, update the nixpkgs input in flake.nix instead.
  system.stateVersion = "25.05";

  # Nix config is now managed by Determinate Nix (see modules/nixos/determinate.nix)
}
