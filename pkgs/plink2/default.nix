{ lib, stdenv, fetchurl, unzip }:

stdenv.mkDerivation {
  pname = "plink2";
  version = "v2.0.0-a.6.9LM AVX2 Intel (29 Jan 2025)";

  src = fetchurl {
    url = "https://s3.amazonaws.com/plink2-assets/alpha6/plink2_linux_avx2_20250129.zip";
    sha256 = "979d33601e5e979139a2c4ef843442830368942a35c8326e4b8b8668df2b6c21";
  };

  nativeBuildInputs = [ unzip ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp plink2 $out/bin/plink2
    cp vcf_subset $out/bin/vcf_subset
  '';

  meta = with lib; {
    description = "Whole genome association analysis toolset (PLINK 2.0)";
    homepage = "https://www.cog-genomics.org/plink/2.0/";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
  };
}
