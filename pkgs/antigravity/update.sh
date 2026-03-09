#!/usr/bin/env bash
# Query the Antigravity RPM repository and update default.nix with the
# latest x86_64 version, URL, and hash.
set -euo pipefail

REPO_BASE="https://us-central1-yum.pkg.dev/projects/antigravity-auto-updater-dev/antigravity-rpm"
PKG_FILE="$(cd "$(dirname "$0")" && pwd)/default.nix"
ARCH="x86_64"

echo "Fetching RPM repo metadata..."

# Parse primary.xml: extract <arch>, <version>, <location> lines, group them,
# and pick the last x86_64 entry (newest).
LATEST=$(curl -sL "${REPO_BASE}/repodata/primary.xml.gz" \
  | gunzip \
  | grep -oP '(<arch>|<version |<location ).*' \
  | paste - - - \
  | grep "${ARCH}" \
  | tail -1)

NEW_VER=$(echo "$LATEST" | grep -oP 'ver="\K[^"]+')
NEW_HREF=$(echo "$LATEST" | grep -oP 'href="\K[^"]+')
NEW_URL="${REPO_BASE}/${NEW_HREF}"

CUR_VER=$(grep '^\s*version\s*=' "$PKG_FILE" | head -1 | sed 's/.*"\(.*\)".*/\1/')

echo "Current version: ${CUR_VER}"
echo "Latest  version: ${NEW_VER}"

if [ "$CUR_VER" = "$NEW_VER" ]; then
  echo "Already up to date."
  exit 0
fi

echo "Prefetching new RPM..."
NEW_HASH=$(nix-prefetch-url --type sha256 "$NEW_URL" 2>/dev/null)
NEW_SRI=$(nix hash convert --hash-algo sha256 --to sri "$NEW_HASH" 2>/dev/null \
  || nix hash to-sri --type sha256 "$NEW_HASH" 2>/dev/null)

echo "New hash: ${NEW_SRI}"

# Get the old URL to replace
OLD_URL=$(grep -oP 'url\s*=\s*"\K[^"]+' "$PKG_FILE" | head -1)

# Update version
sed -i "s|version = \"${CUR_VER}\"|version = \"${NEW_VER}\"|" "$PKG_FILE"
# Update URL
sed -i "s|${OLD_URL}|${NEW_URL}|" "$PKG_FILE"
# Update hash
OLD_HASH=$(grep -oP 'sha256\s*=\s*"\K[^"]+' "$PKG_FILE" | head -1)
sed -i "s|${OLD_HASH}|${NEW_SRI}|" "$PKG_FILE"

echo "Updated ${PKG_FILE}:"
echo "  version: ${CUR_VER} -> ${NEW_VER}"
echo "  url:     ...${NEW_HREF##*/}"
echo "  hash:    ${NEW_SRI}"