# modules/nixos/dns.nix
{ config, pkgs, ... }:

{
  # Set custom DNS servers via resolv.conf
  # Note: NetworkManager might override this depending on its settings.
  # Consider configuring DNS directly within NetworkManager if this doesn't stick.
  environment.etc."resolv.conf" = {
     text = ''
       nameserver 1.1.1.3
       nameserver 2606:4700:4700::1113
     '';
     # You might want to set permissions/owner/group if needed
     # mode = "0644";
     # user = "root";
     # group = "root";
  };
}
