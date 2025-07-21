# personal/edgetts.nix
{ config, lib, pkgs, ... }:

{
  environment.systemPackages = [
    (let
      py = pkgs.python312;
    in
    py.pkgs.buildPythonPackage rec {
      pname = "edge-tts";
      version = "7.0.2";

      src = pkgs.fetchFromGitHub {
        owner  = "rany2";
        repo   = "edge-tts";
        rev    = "${version}";                 # no “v”
        sha256 = "123kpsimz5dmk85k95b87yr1qa9yxx4fah8hkc4r04627glah9k5";          # get real value below
      };

      format = "pyproject";               # ← build from source, not wheel
      nativeBuildInputs = with py.pkgs; [
        setuptools
        wheel
      ];

      propagatedBuildInputs = with py.pkgs; [
        aiohttp
        certifi
        srt
        tabulate
        typing-extensions
      ];

      doCheck = false;
      pythonImportsCheck = [ "edge_tts" ];
    })
  ];
}
