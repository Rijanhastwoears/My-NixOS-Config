{ config, pkgs, ... }:

{
  # Cloudflare Family DNS (blocks malware)
  networking.nameservers = [ "1.1.1.3" "2606:4700:4700::1113" ];

  # Prevent NetworkManager from overwriting /etc/resolv.conf
  networking.networkmanager.dns = "none";
}
