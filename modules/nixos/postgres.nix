# modules/nixos/postgres.nix
{ config, pkgs, lib, ... }: # Added lib here

{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    authentication = lib.mkOverride 10 ''
      # Generated file; do not edit!
      # TYPE  DATABASE        USER            ADDRESS                 METHOD
      local   all             all                                     trust
      host    all             all             127.0.0.1/32            trust
      host    all             all             ::1/128                 trust
    '';
    # Add other postgres settings here if needed
    # initialScript = pkgs.writeText "postgres-init.sql" ''
    #   -- SQL commands to run on initial setup
    #   CREATE USER myuser WITH PASSWORD 'mypassword';
    #   CREATE DATABASE mydatabase OWNER myuser;
    # '';
  };
}
