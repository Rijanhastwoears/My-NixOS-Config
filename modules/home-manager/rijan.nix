# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                         Home Manager Configuration                           ║
# ║                               User: rijan                                    ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
#
# This module defines the user environment for 'rijan', including:
#   • User packages (installed in ~/.nix-profile)
#   • Application configurations
#   • Shell integrations
#
# Changes here are applied when you run:
#   sudo nixos-rebuild switch --flake .#nixos
#
# For available packages, search: https://search.nixos.org/packages

{ pkgs, ... }:

{
  # ════════════════════════════════════════════════════════════════════════════
  #                           Module Imports
  # ════════════════════════════════════════════════════════════════════════════
  # Split configurations for languages and complex setups into separate files.

  imports = [
    ./python.nix  # Python with scientific packages
    ./R.nix       # R and RStudio with packages
  ];

  # ════════════════════════════════════════════════════════════════════════════
  #                           User Packages
  # ════════════════════════════════════════════════════════════════════════════
  # Packages installed for this user only. Organized by category for clarity.

  home.packages = with pkgs; [
    # ─────────────────────────────────────────────────────────────────────────
    # Terminals & Shell Tools
    # ─────────────────────────────────────────────────────────────────────────
    fish
    ghostty
    kitty
    tmux
    zellij
    atuin           # Shell history search
    fzf             # Fuzzy finder
    ripgrep         # Fast grep
    tree
    yazi            # Terminal file manager
    lazygit
    gh
    

    # ─────────────────────────────────────────────────────────────────────────
    # Editors & IDEs
    # ─────────────────────────────────────────────────────────────────────────
    emacs
    helix
    neovim
    opencode
    vscode-fhs
    zed-editor

    # ─────────────────────────────────────────────────────────────────────────
    # Web Browsers
    # ─────────────────────────────────────────────────────────────────────────
    brave
    firefox
    tor-browser

    # ─────────────────────────────────────────────────────────────────────────
    # Communication & Social
    # ─────────────────────────────────────────────────────────────────────────
    beeper
    ripcord
    thunderbird
    zoom-us

    # ─────────────────────────────────────────────────────────────────────────
    # Media & Creative
    # ─────────────────────────────────────────────────────────────────────────
    audacity
    clementine
    gimp
    inkscape
    jellyfin-ffmpeg
    kdePackages.kdenlive
    monophony
    obs-studio
    sox
    spotify
    spotube
    vlc
    yt-dlp
    ytdownloader

    # ─────────────────────────────────────────────────────────────────────────
    # Documents & Reading
    # ─────────────────────────────────────────────────────────────────────────
    calibre
    joplin-desktop
    libreoffice
    logseq
    pandoc
    sioyek          # PDF viewer
    tesseract4      # OCR
    typst
    tinymist        # Typst LSP
    zotero

    # ─────────────────────────────────────────────────────────────────────────
    # Development Tools
    # ─────────────────────────────────────────────────────────────────────────
    # Version Control
    git
    glab            # GitLab CLI
    mercurial

    # Build Tools
    autoconf
    automake
    gnumake

    # Compilers & Languages
    cargo
    rustc
    racket
    gccgo13
    nim
    nimble
    nimlangserver
    julia
    flutter
    zig
    sbcl            # Common Lisp
    perl
    c2nim
    uv
    # Debugging & Profiling
    gdb
    valgrind

    # Language Servers
    pyright

    # ─────────────────────────────────────────────────────────────────────────
    # Databases
    # ─────────────────────────────────────────────────────────────────────────
    duckdb
    postgresql_16
    sqlite-interactive
    csvlens

    # ─────────────────────────────────────────────────────────────────────────
    # Bioinformatics
    # ─────────────────────────────────────────────────────────────────────────
    bcftools
    htslib
    plink-ng
    vcftools

    # ─────────────────────────────────────────────────────────────────────────
    # Cloud & Networking
    # ─────────────────────────────────────────────────────────────────────────
    awscli2
    backblaze-b2
    inetutils
    mosh
    nodePackages_latest.wrangler
    openconnect
    protonvpn-gui
    rclone
    slackdump
    wget

    # ─────────────────────────────────────────────────────────────────────────
    # Desktop Applications
    # ─────────────────────────────────────────────────────────────────────────
    anki-bin
    authenticator
    gnome-podcasts
    onedriver       # OneDrive client
    syncthing
    waydroid
    xournalpp

    # ─────────────────────────────────────────────────────────────────────────
    # Utilities
    # ─────────────────────────────────────────────────────────────────────────
    bzip2
    comma           # Run any package with ,
    hugo            # Static site generator
    kbfs
    keybase
    mermaid-cli
    mkdocs
    # ncurses  # Conflicts with ghostty's terminfo; already available as a system dependency
    notcurses
    ollama          # Local LLMs
    stow
    the-way         # Code snippets
    unzip
    xclip
    xz
    zip

    # ─────────────────────────────────────────────────────────────────────────
    # System Libraries (sometimes needed for building)
    # ─────────────────────────────────────────────────────────────────────────
    glibc
    jdk17
    libgcc
    samba4Full
    zlib
    zlib.dev

    # ────────────────────────────────────────────────────────────────────────────
    # misc
    # ────────────────────────────────────────────────────────────────────────────
    filen-cli
    filen-desktop
    # ─────────────────────────────────────────────────────────────────────────
    # Printers
    # ─────────────────────────────────────────────────────────────────────────
    canon-cups-ufr2
  ];

  # ════════════════════════════════════════════════════════════════════════════
  #                        Program Configurations
  # ════════════════════════════════════════════════════════════════════════════
  # Some programs have dedicated Home Manager modules for richer configuration.

  programs.atuin = {
    enable = true;
    enableFishIntegration = true;  # Ctrl+R history search in Fish
  };

  # ════════════════════════════════════════════════════════════════════════════
  #                         Nixpkgs Configuration
  # ════════════════════════════════════════════════════════════════════════════
  # NOTE: These settings are also set in flake.nix for the system.
  # We repeat them here because Home Manager has its own nixpkgs evaluation
  # in some contexts.

  nixpkgs.config = {
    allowUnfree = true;
  };

  # ════════════════════════════════════════════════════════════════════════════
  #                            State Version
  # ════════════════════════════════════════════════════════════════════════════
  # IMPORTANT: Don't change after initial setup. This is for Home Manager's
  # internal state management, not for upgrading.

  home.stateVersion = "25.05";
}
