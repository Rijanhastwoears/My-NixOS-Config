# modules/nixos/printing.nix
{ config, pkgs, ... }:

{
  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint ]; # Add other drivers if needed e.g. pkgs.hplip
    browsing = true; # Enable network printer discovery
    browsedConf = ''
      BrowseDNSSDSubTypes _cups,_print
      BrowseLocalProtocols all
      BrowseRemoteProtocols all
      CreateIPPPrinterQueues All
      BrowseProtocols all
    '';
  };

  # Avahi (mDNS/DNS-SD) is often needed for network printing discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true; # Enable mDNS for hostname resolution
    openFirewall = true; # Open firewall ports for Avahi
    # If you enable the firewall later, ensure CUPS ports (like 631) are open too.
    # networking.firewall.allowedTCPPorts = [ 631 ];
    # networking.firewall.allowedUDPPorts = [ 5353 ]; # For Avahi/mDNS
  };
}
