{ lib
, stdenv
, fetchurl
, unzip
, makeWrapper
, autoPatchelfHook
, zlib
, xorg
, freetype
, fontconfig
, glib
, gtk3
, libGL
, alsa-lib
}:

stdenv.mkDerivation {
  pname = "mzmine";
  version = "4.8.0";

  src = fetchurl {
    url = "https://github.com/mzmine/mzmine/releases/download/v4.8.0/mzmine_Linux_portable-4.8.0.zip";
    sha256 = "940a545dc45ae7a087638638a8e4dc461d2e78141ab455c6d8962568002349cc";
  };

  nativeBuildInputs = [
    unzip
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    zlib
    xorg.libX11
    xorg.libXext
    xorg.libXtst
    xorg.libXi
    xorg.libXrender
    freetype
    fontconfig
    glib
    gtk3
    libGL
    alsa-lib
  ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    mkdir -p $out/opt/mzmine
    mkdir -p $out/bin
    mkdir -p $out/share/pixmaps
    mkdir -p $out/share/applications

    cp -r * $out/opt/mzmine/
    cp lib/mzmine.png $out/share/pixmaps/mzmine.png

    chmod +x $out/opt/mzmine/bin/mzmine

    makeWrapper $out/opt/mzmine/bin/mzmine $out/bin/mzmine \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [
        stdenv.cc.cc.lib
        zlib
        xorg.libX11
        xorg.libXext
        xorg.libXtst
        xorg.libXi
        xorg.libXrender
        freetype
        fontconfig
        glib
        gtk3
        libGL
        alsa-lib
      ]}" \
      --set MZMINE_HOME "$out/opt/mzmine"

    cat > $out/share/applications/mzmine.desktop <<EOF
    [Desktop Entry]
    Type=Application
    Name=MZmine
    Comment=Mass spectrometry data processing software
    Exec=$out/bin/mzmine
    Icon=mzmine
    Terminal=false
    Categories=Science;Chemistry;Education;
    EOF
  '';

  meta = with lib; {
    description = "Mass spectrometry data processing software";
    homepage = "https://mzmine.github.io/";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
