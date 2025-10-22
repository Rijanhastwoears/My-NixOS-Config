{pkgs, ...}:

{

  imports = [
    ./python.nix
    ./R.nix
  ];
    home.packages = with pkgs;
     [
      anki-bin
      atuin
      authenticator
      autoconf269
      automake115x
      audacity
      awscli2
      backblaze-b2
      bcftools
      beeper
      brave
      bzip2
      c2nim
      calibre
      canon-cups-ufr2
      cargo
      clementine
      comma
      csvlens
      duckdb
      emacs
      firefox
      fish
      flutter
      fzf
      gccgo13
      gdb
      gimp
      git
      ghostty
      glab
      glibc
      gnome-podcasts
      gnumake42
      helix
      htslib
      hugo
      inetutils
      inkscape
      jdk17
      jellyfin-ffmpeg
      joplin-desktop
      julia
      kitty
      kbfs
      keybase
      lazygit
      libgcc
      libreoffice
      libsForQt5.kdenlive
      logseq
      mercurial
      mermaid-cli
      monophony
      mosh
      ncurses
      nim
      nimble
      nimlangserver
      neovim
      nodePackages_latest.wrangler
      notcurses
      obs-studio
      ollama
      onedriver
      openconnect
      pandoc
      perl
      plink-ng
      postgresql_16
      protonvpn-gui
      pyright
      rclone
      ripcord
      ripgrep
      rustc
      samba4Full
      sbcl
      sioyek
      slackdump
      sox
      spotify
      spotube
      sqlite-interactive
      stow
      syncthing
      tangram
      tesseract4
      the-way
      thunderbird
      tinymist
      tmux
      tree
      tor-browser
      typst
      unzip
      valgrind
      vcftools
      vlc
      vivaldi
      vscode-fhs
      waydroid
      wget
      xclip
      xz
      yazi
      yt-dlp
      ytdownloader
      zellij
      zig
      zip
      zlib
      zlib.dev
      zoom-us
      zotero
    ];

    programs.atuin = {
      enable = true;
      enableFishIntegration = true;
    };

    nixpkgs.config.permittedInsecurePackages = [
      "electron-27.3.11"
    ];
    # this should enable zsh as the default shell
    
    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    home.stateVersion = "25.05";
}
