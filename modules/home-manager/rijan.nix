{ pkgs, ... }:

{
  imports = [
    ./python.nix
    ./R.nix
  ];

  home.packages = with pkgs; [
    # Terminals & Shell
    fish
    ghostty
    tmux
    zellij
    jujutsu
    atuin
    fzf
    ripgrep
    tree
    yazi
    lazygit
    gh

    # Editors
    emacs
    helix
    neovim
    opencode
    zed-editor

    # Browsers
    brave
    firefox
    tor-browser

    # Communication
    beeper
    ripcord
    thunderbird
    zoom-us

    # Media
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

    # Documents
    calibre
    joplin-desktop
    libreoffice
    logseq
    pandoc
    sioyek
    tesseract4
    typst
    tinymist
    zotero
    languagetool # For grammar checking
    vale # For style checking

    # Development — Version Control
    git
    mercurial

    # Development — Build Tools
    autoconf
    automake
    gnumake

    # Development — Languages
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
    sbcl
    perl
    c2nim
    uv
    pixi

    # Development — Debugging
    gdb
    valgrind

    # Development — LSP
    pyright

    # Databases
    duckdb
    postgresql_16
    sqlite-interactive
    csvlens

    # Bioinformatics
    bcftools
    htslib
    plink-ng
    vcftools

    # Cloud & Networking
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

    # Desktop
    anki-bin
    authenticator
    gnome-podcasts
    onedriver
    syncthing
    waydroid
    xournalpp

    # Utilities
    bzip2
    comma
    hugo
    mermaid-cli
    # ncurses  # Conflicts with ghostty's terminfo
    notcurses
    ollama
    stow
    the-way
    poppler
    unzip
    xclip
    xz
    zip

    # System Libraries
    glibc
    jdk17
    libgcc
    samba4Full
    zlib
    zlib.dev

    # Misc
    filen-cli
    filen-desktop

    # Printers
    canon-cups-ufr2
  ];

  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  # Do NOT change after initial setup
  home.stateVersion = "25.05";
}
