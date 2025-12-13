{ lib, stdenv, fetchurl, unzip, makeWrapper, jre }:

stdenv.mkDerivation {
  pname = "snptools";
  version = "4.3t";

  src = fetchurl {
    url = "https://snpeff.blob.core.windows.net/versions/snpEff_latest_core.zip";
    sha256 = "445f4b73a723a018afbcbcbfe49c77c6771745f55cf662246bf265f53342d961";
  };

  nativeBuildInputs = [ unzip makeWrapper ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    mkdir -p $out/share/java $out/bin

    cp snpEff/snpEff.jar $out/share/java/
    cp snpEff/SnpSift.jar $out/share/java/

    if [ -d "snpEff/data" ]; then
      mkdir -p $out/share/snpEff
      cp -r snpEff/data $out/share/snpEff/
    fi

    makeWrapper ${jre}/bin/java $out/bin/snpeff \
      --add-flags "-jar $out/share/java/snpEff.jar"

    makeWrapper ${jre}/bin/java $out/bin/snpsift \
      --add-flags "-jar $out/share/java/SnpSift.jar"
  '';

  meta = with lib; {
    description = "Genetic variant annotation and functional effect prediction toolbox";
    homepage = "https://pcingola.github.io/SnpEff/";
    license = licenses.lgpl3;
    platforms = platforms.linux;
  };
}
