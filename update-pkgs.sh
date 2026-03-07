#!/usr/bin/env bash
# Update custom overlay packages using nix-update.
# Usage: ./update-pkgs.sh [package-name]
#
# Run with no arguments to update all auto-updatable packages,
# or pass a specific package name to update just that one.
#
# Requires: nix-update (nix run github:Mic92/nix-update -- ...)
#   or:     nix-shell -p nix-update --run "nix-update ..."

set -euo pipefail
cd "$(dirname "$0")"

update() {
  echo ">>> Updating $1 ..."
  nix-update --flake "$@"
}

if [ $# -ge 1 ]; then
  update "$@"
  exit 0
fi

# -- Fully automatic (GitHub source detection) --
update ferrite           # fetchFromGitHub: OlaProeis/Ferrite
update edge-tts          # fetchFromGitHub: rany2/edge-tts

# -- Semi-automatic (need --url hint for version detection) --
update mzmine --url https://github.com/mzmine/mzmine



# -- Fully manual packages (no automated repo to query) --
echo ""
echo "=== Skipped packages (require fully manual update) ==="
echo "  plink2  — S3 URL; update version + URL + hash by hand"
echo "  snpeff  — S3 URL; update version + URL + hash by hand"

