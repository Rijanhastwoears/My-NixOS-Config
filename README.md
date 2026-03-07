# Rijan's NixOS Configuration

## System Update

```bash
# Update flake lock file (nixpkgs, home-manager, etc.)
nix flake update

# Rebuild and switch
sudo nixos-rebuild switch --flake .#nixos

# Or rebuild for next boot only
sudo nixos-rebuild boot --flake .#nixos
```

## Updating Custom Packages

Custom overlay packages (in `pkgs/`) have pinned versions and hashes.
Use [nix-update](https://github.com/Mic92/nix-update) to bump them automatically.

### Quick start

```bash
# Update all auto-updatable packages
./update-pkgs.sh

# Update a specific package
./update-pkgs.sh ferrite
```

### Package update support

| Package | Source | Auto-update? |
|---|---|---|
| `ferrite` | GitHub (OlaProeis/Ferrite) | ✅ Fully automatic |
| `edge-tts` | GitHub (rany2/edge-tts) | ✅ Fully automatic |
| `mzmine` | GitHub release (mzmine/mzmine) | ⚠️ Semi-auto (uses `--url` hint) |
| `google-antigravity` | RPM repo (Google Artifact Registry) | ✅ Auto via RPM repo metadata |
| `plink2` | S3 | ❌ Fully manual |
| `snpeff` | S3 | ❌ Fully manual |

For packages marked fully manual, update `version`, `url`, and `hash` by hand.
Use `nix-prefetch-url <new-url>` to compute the new hash.

### One-off usage (without the script)

```bash
# Run nix-update directly
nix-update --flake ferrite

# Or without installing nix-update
nix run github:Mic92/nix-update -- --flake ferrite
```

## Garbage Collection

```bash
sudo nix-collect-garbage -d
```
