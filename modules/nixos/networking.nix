# modules/nixos/networking.nix
{ config, pkgs, ... }:

{
  networking.hostName = "nixos"; # Define your hostname.

  # Enable networking management via NetworkManager
  networking.networkmanager.enable = true;

  # Optional: Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Optional: Enable wireless support (handled by NetworkManager if enabled)
  # networking.wireless.enable = true;

  # Optional: Firewall configuration (can be its own module later)
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # networking.firewall.enable = false; # Or disable
}
