{ lib, stdenv, fetchurl
, cmake, docbook_xml_dtd_45, docbook_xsl, doxygen, graphviz-nox, pkg-config, qttools, wrapQtAppsHook
, alsa-lib, fluidsynth, qtbase, qtsvg, libpulseaudio
}:

stdenv.mkDerivation rec {
  pname = "drumstick";
  version = "2.4.1";

  src = fetchurl {
    url = "mirror://sourceforge/drumstick/${version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-nmqgS08ZBQ2vBEDtoriNbYLaNQA1DWeDhbRo70rBOP0=";
  };

  patches = [
    ./drumstick-plugins.patch
  ];

  postPatch = ''
    substituteInPlace library/rt/backendmanager.cpp --subst-var out
  '';

  outputs = [ "out" "dev" "man" ];

  nativeBuildInputs = [
    cmake docbook_xml_dtd_45 docbook_xml_dtd_45 docbook_xsl doxygen graphviz-nox pkg-config qttools wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib fluidsynth libpulseaudio qtbase qtsvg
  ];

  cmakeFlags = [
    "-DUSE_DBUS=ON"
  ];

  meta = with lib; {
    maintainers = [];
    description = "MIDI libraries for Qt5/C++";
    homepage = "http://drumstick.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
