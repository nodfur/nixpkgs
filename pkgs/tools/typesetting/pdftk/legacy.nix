{ fetchurl, lib, stdenv, gcj, unzip }:

stdenv.mkDerivation rec {
  pname = "pdftk";
  version = "2.02";

  src = fetchurl {
    url = "https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk-${version}-src.zip";
    sha256 = "1hdq6zm2dx2f9h7bjrp6a1hfa1ywgkwydp14i2sszjiszljnm3qi";
  };

  nativeBuildInputs = [ gcj unzip ];

  hardeningDisable = [ "fortify" "format" ];

  preBuild = ''
    cd pdftk
    sed -e 's@/usr/bin/@@g' -i Makefile.*
    NIX_ENFORCE_PURITY= \
      make \
      LIBGCJ="${gcj.cc}/share/java/libgcj-${gcj.cc.version}.jar" \
      GCJ=gcj GCJH=gcjh GJAR=gjar \
      -iC ../java all
  '';

  # Makefile.Debian has almost fitting defaults
  makeFlags = [ "-f" "Makefile.Debian" "VERSUFF=" ];

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1
    cp pdftk $out/bin
    cp ../pdftk.1 $out/share/man/man1
  '';


  meta = {
    description = "Simple tool for doing everyday things with PDF documents";
    homepage = "https://www.pdflabs.com/tools/pdftk-server/";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ raskin ];
    platforms = with lib.platforms; linux;
    broken = true; # Broken on Hydra since 2020-08-24
  };
}
