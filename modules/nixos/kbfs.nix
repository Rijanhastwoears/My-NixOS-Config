# modules/nixos/kbfs.nix
{ config, pkgs, ... }:

{
  # Enable basic Keybase and KBFS services
  services.keybase.enable = true;
  services.kbfs = {
     enable = true;
     # Ensure the user 'rijan' exists before this mount point is used.
     # This dependency is usually handled automatically by NixOS.
     mountPoint = "/home/rijan/keybase/";
  };
}
