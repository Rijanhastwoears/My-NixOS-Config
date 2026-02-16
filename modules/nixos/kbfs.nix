{ config, pkgs, ... }:

{
  services.keybase.enable = true;
  services.kbfs = {
    enable = true;
    mountPoint = "/home/rijan/keybase/";
  };
}
