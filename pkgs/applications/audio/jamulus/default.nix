{ mkDerivation, lib, fetchFromGitHub, pkg-config, qtscript, qmake, libjack2
}:

mkDerivation rec {
  pname = "jamulus";
  version = "3.8.1";
  src = fetchFromGitHub {
    owner = "jamulussoftware";
    repo = "jamulus";
    rev = "r${lib.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "sha256-QtlvcKVqKgRAO/leHy4CgvjNW49HAyZLI2JtKERP7HQ=";
  };

  nativeBuildInputs = [ pkg-config qmake ];
  buildInputs = [ qtscript libjack2 ];

  qmakeFlags = [ "CONFIG+=noupcasename" ];

  meta = {
    description = "Enables musicians to perform real-time jam sessions over the internet";
    longDescription = "You also need to enable JACK and should enable several real-time optimizations. See project website for details";
    homepage = "https://github.com/corrados/jamulus/wiki";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.seb314 ];
  };
}
