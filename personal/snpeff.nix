{ config, pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.stdenv.mkDerivation {
      pname = "snptools";
      version = "4.3t";  # Update with the appropriate version
      
      src = pkgs.fetchurl {
        url = "https://snpeff.blob.core.windows.net/versions/snpEff_latest_core.zip";
        sha256 = "445f4b73a723a018afbcbcbfe49c77c6771745f55cf662246bf265f53342d961";
      };
      
      nativeBuildInputs = [ pkgs.unzip pkgs.makeWrapper ];
      
      unpackPhase = ''
        unzip $src
      '';
      
      installPhase = ''
        # Create directories
        mkdir -p $out/share/java $out/bin
        
        # Looking at the error, the JAR files are in a 'snpEff' subdirectory
        cp snpEff/snpEff.jar $out/share/java/
        cp snpEff/SnpSift.jar $out/share/java/
        
        # Copy any necessary data files
        if [ -d "snpEff/data" ]; then
          mkdir -p $out/share/snpEff
          cp -r snpEff/data $out/share/snpEff/
        fi
        
        # Create wrapper scripts for each JAR
        makeWrapper ${pkgs.jre}/bin/java $out/bin/snpeff \
          --add-flags "-jar $out/share/java/snpEff.jar"
          
        makeWrapper ${pkgs.jre}/bin/java $out/bin/snpsift \
          --add-flags "-jar $out/share/java/SnpSift.jar"
      '';
    })
  ];
}
