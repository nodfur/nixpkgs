{ lib, stdenv, fetchzip, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "VASSAL";
  version = "3.6.1";

  src = fetchzip {
    url = "https://github.com/vassalengine/vassal/releases/download/${version}/${pname}-${version}-linux.tar.bz2";
    sha256 = "sha256-elcSwm7KvDpGVBF7Gs6GFreQPyVwWBxYN0NO1N6JWDM=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin $out/share/vassal $out/doc

    cp CHANGES LICENSE README.md $out
    cp -R lib/* $out/share/vassal
    cp -R doc/* $out/doc

    makeWrapper ${jre}/bin/java $out/bin/vassal \
      --add-flags "-Duser.dir=$out -cp $out/share/vassal/Vengine.jar \
      VASSAL.launch.ModuleManager"
  '';

  # Don't move doc to share/, VASSAL expects it to be in the root
  forceShare = [ "man" "info" ];

  meta = with lib; {
      description = "A free, open-source boardgame engine";
      homepage = "http://www.vassalengine.org/";
      license = licenses.lgpl21Only;
      maintainers = with maintainers; [ tvestelind ];
      platforms = platforms.unix;
  };
}
