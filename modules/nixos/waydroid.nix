{ config, pkgs, lib, ... }:

{
  virtualisation.waydroid.enable = true;

  boot.kernelModules = [
    "binder_linux"
    "ashmem_linux"
  ];

  boot.kernelParams = [ "psi=1" ];

  # After first rebuild: sudo waydroid init
  # Then: waydroid show-full-ui
}
