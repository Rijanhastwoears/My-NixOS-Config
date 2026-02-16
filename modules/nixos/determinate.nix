# Determinate Nix manages /etc/nix/nix.conf itself.
# Custom settings go in /etc/nix/nix.custom.conf, managed declaratively here.
{ config, lib, ... }:

{
  environment.etc."nix/nix.custom.conf" = {
    text = ''
      # Managed by NixOS (modules/nixos/determinate.nix) — do not edit manually.

      # Parallel evaluation: 0 = use all available cores
      eval-cores = 0
    '';
    mode = "0644";
  };
}
