# modules/nixos/bootloader.nix
{ config, pkgs, ... }:

{
  # Systemd-boot configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true; # Allows systemd-boot to manage EFI variables
}
