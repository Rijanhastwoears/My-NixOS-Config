# edge-tts.nix  –  single-file derivation for NixOS / home-manager
# Usage:
#   environment.systemPackages = [ (import ./edge-tts.nix { inherit pkgs; }) ];
# or
#   home.packages = [ (import ./edge-tts.nix { inherit pkgs; }) ];

{ pkgs }:

let
  py = pkgs.python311;
in
py.pkgs.buildPythonPackage rec {
  pname = "edge-tts";
  version = "6.1.12";

  # Build from the GitHub tarball so you always get the exact code
  src = pkgs.fetchFromGitHub {
    owner  = "rany2";
    repo   = "edge-tts";
    rev    = "v${version}";
    sha256 = "sha256-8Q1mXg7qP/M2j52hU8dOQh9+9mQ=="; # <- nix-prefetch-url --unpack <tarball-url>
  };

  propagatedBuildInputs = with py.pkgs; [
    aiohttp
    certifi
    srt
    tabulate
    typing-extensions
  ];

  # CLI entry points
  nativeBuildInputs = [ py.pkgs.setuptools py.pkgs.wheel ];
  buildInputs = [ py.pkgs.pythonRelaxDepsHook ];

  # No test suite in the repo
  doCheck = false;

  # Sanity check
  pythonImportsCheck = [ "edge_tts" ];

  meta = with pkgs.lib; {
    description = "Use Microsoft Edge’s online TTS from Python without Edge/Windows/API key";
    homepage    = "https://github.com/rany2/edge-tts";
    license     = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
  };
}
