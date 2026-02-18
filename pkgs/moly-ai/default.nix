{ lib
, appimageTools
, fetchurl
, makeDesktopItem
}:

let
  pname = "moly-ai";
  version = "0.2.4";

  src = fetchurl {
    url = "https://github.com/moly-ai/moly-ai/releases/download/v${version}/moly_${version}_x86_64.AppImage";
    sha256 = "sha256-sPs9z4j/1j3/W8Qm/T956YMS/Ig+2ytPe0HbMcant+Y=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };

  desktopItem = makeDesktopItem {
    name = "moly-ai";
    desktopName = "Moly AI";
    comment = "Local + cloud AI LLM client in Rust";
    exec = "moly-ai %U";
    icon = "moly-ai";
    categories = [ "Utility" "ArtificialIntelligence" ];
    startupNotify = true;
    startupWMClass = "moly";
  };

in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: with pkgs; [
    # Display / windowing
    libGL
    libglvnd
    vulkan-loader
    mesa
    libdrm
    wayland
    libxkbcommon
    libx11
    libxcursor
    libxi
    libxrandr
    libxcb

    # Audio
    alsa-lib
    pulseaudio

    # System
    openssl
    glib
    dbus
    systemd
  ];

  extraInstallCommands = ''
    # Desktop entry
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/*.desktop $out/share/applications/

    # Try to extract icon from AppImage contents
    if [ -f ${appimageContents}/moly.png ]; then
      mkdir -p $out/share/pixmaps
      cp ${appimageContents}/moly.png $out/share/pixmaps/moly-ai.png
    elif [ -f ${appimageContents}/usr/share/icons/hicolor/256x256/apps/moly.png ]; then
      mkdir -p $out/share/pixmaps
      cp ${appimageContents}/usr/share/icons/hicolor/256x256/apps/moly.png $out/share/pixmaps/moly-ai.png
    elif [ -f ${appimageContents}/.DirIcon ]; then
      mkdir -p $out/share/pixmaps
      cp ${appimageContents}/.DirIcon $out/share/pixmaps/moly-ai.png
    fi
  '';

  meta = with lib; {
    description = "Moly AI – local + cloud AI LLM multi-platform GUI app in Rust";
    homepage = "https://github.com/moly-ai/moly-ai";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}
