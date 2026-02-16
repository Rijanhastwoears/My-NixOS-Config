#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                          NixOS Update Script                                ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
#
# Updates the NixOS system: flake update → rebuild → boot → garbage collect.
#
# Usage:
#   ./update-nixos.sh          # Keep last 2 generations (default)
#   ./update-nixos.sh 5        # Keep last 5 generations
#   ./update-nixos.sh 1        # Keep only the current generation

set -euo pipefail

# ── Configuration ─────────────────────────────────────────────────────────────
FLAKE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
KEEP_GENERATIONS="${1:-2}"
LOG_FILE="/tmp/nixos-update-$(date +%Y%m%d-%H%M%S).log"

# ── Helpers ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

step() { echo -e "\n${BLUE}══════════════════════════════════════════════════${NC}"; echo -e "${BLUE}  $1${NC}"; echo -e "${BLUE}══════════════════════════════════════════════════${NC}"; }
ok()   { echo -e "${GREEN}  ✓ $1${NC}"; }
warn() { echo -e "${YELLOW}  ⚠ $1${NC}"; }
fail() { echo -e "${RED}  ✗ $1${NC}"; echo -e "${RED}  Error log: ${LOG_FILE}${NC}"; exit 1; }

# Run a command, suppress stdout, capture stderr to log on failure
run() {
    if "$@" > /dev/null 2>>"$LOG_FILE"; then
        return 0
    else
        return 1
    fi
}

# ── Preflight ─────────────────────────────────────────────────────────────────
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}This script must be run as root (sudo).${NC}"
    exit 1
fi

echo -e "${GREEN}NixOS Update${NC} — $(date)"
echo -e "Flake:       ${FLAKE_DIR}"
echo -e "Keeping:     last ${KEEP_GENERATIONS} generation(s)"
echo -e "Error log:   ${LOG_FILE}"

# ── Step 1: Update Flake ─────────────────────────────────────────────────────
step "1/4  Updating flake inputs"
if run nix flake update --flake "$FLAKE_DIR"; then
    ok "Flake lock updated"
else
    fail "Flake update failed"
fi

# ── Step 2: Rebuild System ───────────────────────────────────────────────────
step "2/4  Rebuilding NixOS (switch)"
if run nixos-rebuild switch --flake "${FLAKE_DIR}#nixos"; then
    ok "System rebuilt and switched"
else
    fail "nixos-rebuild switch failed"
fi

# ── Step 3: Rebuild Boot ─────────────────────────────────────────────────────
step "3/4  Rebuilding boot entries"
if run nixos-rebuild boot --flake "${FLAKE_DIR}#nixos"; then
    ok "Boot entries updated"
else
    fail "nixos-rebuild boot failed"
fi

# ── Step 4: Garbage Collection ───────────────────────────────────────────────
step "4/4  Garbage collection (keeping last ${KEEP_GENERATIONS})"

# Clean system profile
if run nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than "${KEEP_GENERATIONS}"; then
    ok "System profile history cleaned"
else
    warn "System profile wipe-history failed (non-fatal)"
fi

# Clean user profiles
for profile_dir in /home/*/. ; do
    user="$(basename "$(dirname "$profile_dir")")"
    for profile in "/home/${user}/.local/state/nix/profiles/profile" \
                   "/home/${user}/.local/state/nix/profiles/home-manager"; do
        if [[ -e "$profile" ]]; then
            if run nix profile wipe-history --profile "$profile" --older-than "${KEEP_GENERATIONS}"; then
                ok "Cleaned profile: ${profile}"
            else
                warn "Failed to clean: ${profile} (non-fatal)"
            fi
        fi
    done
done

# Collect garbage
if run nix-collect-garbage; then
    ok "Garbage collected"
else
    warn "Garbage collection had issues (non-fatal)"
fi

# ── Summary ──────────────────────────────────────────────────────────────────
echo ""
step "Done!"
echo -e "  System:  $(nixos-version)"
echo -e "  Store:   $(du -sh /nix/store 2>/dev/null | cut -f1)"
echo ""

# Clean up log if empty (no errors)
if [[ ! -s "$LOG_FILE" ]]; then
    rm -f "$LOG_FILE"
    ok "No errors recorded"
else
    warn "Some warnings/errors were logged to: ${LOG_FILE}"
fi
