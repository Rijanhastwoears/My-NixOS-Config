# modules/nixos/postgres.nix
{ config, pkgs, lib, ... }: # Added lib here

{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    authentication = lib.mkOverride 10 ''
      # TYPE  DATABASE        USER            ADDRESS                 METHOD
      # "peer" uses OS user for authentication (secure for local Unix sockets)
      local   all             all                                     peer
      # "scram-sha-256" requires password for network connections
      host    all             all             127.0.0.1/32            scram-sha-256
      host    all             all             ::1/128                 scram-sha-256
    '';
    # Add other postgres settings here if needed
    # initialScript = pkgs.writeText "postgres-init.sql" ''
    #   -- SQL commands to run on initial setup
    #   CREATE USER myuser WITH PASSWORD 'mypassword';
    #   CREATE DATABASE mydatabase OWNER myuser;
    # '';
  };
}
