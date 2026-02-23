{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, cmake
, perl
, makeWrapper
, gtk3
, libxkbcommon
, libGL
, vulkan-loader
, wayland
, openssl
, fontconfig
, freetype
, libgit2
, xorg
}:

rustPlatform.buildRustPackage rec {
  pname = "ferrite";
  version = "0.2.6.1";

  src = fetchFromGitHub {
    owner = "OlaProeis";
    repo = "Ferrite";
    rev = "v${version}";
    hash = "sha256-t05Q4GFSiviIG7vJSGso37wrAyjHUeDQrcXTlqbq+uw=";
  };

  cargoHash = "sha256-HIKu6P4yqeO0jcpC1COIn+jmu8lwkf/yMhQmL1KFmsk=";

  nativeBuildInputs = [
    pkg-config
    cmake
    perl
    makeWrapper
  ];

  buildInputs = [
    gtk3
    libxkbcommon
    libGL
    vulkan-loader
    wayland
    openssl
    fontconfig
    freetype
    libgit2
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
    xorg.libxcb
    xorg.libXScrnSaver
  ];

  # Skip tests as they may require a display
  doCheck = false;

  postInstall = ''
    # Install desktop file
    install -Dm644 assets/icons/linux/ferrite.desktop $out/share/applications/ferrite.desktop

    # Install icons at various sizes
    for size in 16 32 48 64 128 256 512; do
      icon="assets/icons/icon_''${size}.png"
      if [ -f "$icon" ]; then
        install -Dm644 "$icon" "$out/share/icons/hicolor/''${size}x''${size}/apps/ferrite.png"
      fi
    done

    # Wrap binary with runtime library paths for dynamically loaded libs
    wrapProgram $out/bin/ferrite \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
        libGL
        vulkan-loader
        wayland
        libxkbcommon
        xorg.libX11
        xorg.libXcursor
        xorg.libXrandr
        xorg.libXi
        xorg.libxcb
      ]}
  '';

  meta = with lib; {
    description = "A fast, lightweight text editor for Markdown, JSON, YAML, and TOML files";
    homepage = "https://github.com/OlaProeis/Ferrite";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ ];
    mainProgram = "ferrite";
  };
}
