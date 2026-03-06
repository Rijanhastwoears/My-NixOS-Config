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

# -- Manual-version packages --
# antigravity: Google CDN, no auto version detection.
#   Pass version explicitly, e.g.:
#   ./update-pkgs.sh google-antigravity --version=1.12.0-XXXX
echo ""
echo "=== Skipped packages (require manual version) ==="
echo "  google-antigravity  — run: ./update-pkgs.sh google-antigravity --version=X.Y.Z-BUILD"
echo "  plink2              — run: ./update-pkgs.sh plink2 --version=..."
echo "  snpeff              — run: ./update-pkgs.sh snpeff --version=..."
