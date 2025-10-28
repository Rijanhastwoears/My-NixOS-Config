{ config, pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.stdenv.mkDerivation {
      pname = "mzmine";
      version = "4.8.0";
      
      src = pkgs.fetchurl {
        url = "https://github.com/mzmine/mzmine/releases/download/v4.8.0/mzmine_Linux_portable-4.8.0.zip";
        sha256 = "940a545dc45ae7a087638638a8e4dc461d2e78141ab455c6d8962568002349cc";
      };
      
      nativeBuildInputs = [ 
        pkgs.unzip 
        pkgs.makeWrapper 
        pkgs.autoPatchelfHook
        pkgs.copyDesktopItems
      ];
      
      buildInputs = [
        pkgs.stdenv.cc.cc.lib
        pkgs.zlib
        pkgs.xorg.libX11
        pkgs.xorg.libXext
        pkgs.xorg.libXtst
        pkgs.xorg.libXi
        pkgs.xorg.libXrender
        pkgs.freetype
        pkgs.fontconfig
        pkgs.glib
        pkgs.gtk3
        pkgs.libGL
        pkgs.alsa-lib
      ];
      
      unpackPhase = ''
        unzip $src
      '';
      
      installPhase = ''
        # Create directories
        mkdir -p $out/opt/mzmine
        mkdir -p $out/bin
        mkdir -p $out/share/pixmaps
        mkdir -p $out/share/applications
        
        # Copy all mzmine files
        cp -r * $out/opt/mzmine/
        
        # Copy icon
        cp lib/mzmine.png $out/share/pixmaps/mzmine.png
        
        # The binary is already in bin/mzmine, make it executable
        chmod +x $out/opt/mzmine/bin/mzmine
        
        # Create wrapper script for the binary
        makeWrapper $out/opt/mzmine/bin/mzmine $out/bin/mzmine \
          --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath [ 
            pkgs.stdenv.cc.cc.lib
            pkgs.zlib
            pkgs.xorg.libX11
            pkgs.xorg.libXext
            pkgs.xorg.libXtst
            pkgs.xorg.libXi
            pkgs.xorg.libXrender
            pkgs.freetype
            pkgs.fontconfig
            pkgs.glib
            pkgs.gtk3
            pkgs.libGL
            pkgs.alsa-lib
          ]}" \
          --set MZMINE_HOME "$out/opt/mzmine"
        
        # Create desktop entry
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
      
      meta = with pkgs.lib; {
        description = "Mass spectrometry data processing software";
        homepage = "https://mzmine.github.io/";
        license = licenses.mit;
        platforms = platforms.linux;
      };
    })
  ];
}