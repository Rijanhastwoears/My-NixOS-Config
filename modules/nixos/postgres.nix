{ config, pkgs, lib, ... }:

{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    ensureUsers = [
      {
        name = "rijan";
        ensureClauses = {
          superuser = true;
          login = true;
        };
      }
    ];
    ensureDatabases = [ "rijan" ];
    authentication = lib.mkOverride 10 ''
      # TYPE  DATABASE  USER  ADDRESS        METHOD
      local   all       all                  peer
      host    all       all   127.0.0.1/32   scram-sha-256
      host    all       all   ::1/128        scram-sha-256
    '';
  };
}
