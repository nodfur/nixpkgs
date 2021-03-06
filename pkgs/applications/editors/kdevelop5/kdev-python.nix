{ stdenv, lib, fetchFromGitHub, cmake, extra-cmake-modules, threadweaver, ktexteditor, kdevelop-unwrapped, python }:

stdenv.mkDerivation rec {
  pname = "kdev-python";
  version = "5.6.2";

  src = fetchFromGitHub {
    owner = "KDE";
    repo = "kdev-python";
    rev = "v${version}";
    sha256 = "sha256-xYElqpJjRtBRIyZGf6JaCvurQ+QrGrdLHxtuANYfCds=";
  };

  cmakeFlags = [
    "-DPYTHON_EXECUTABLE=${python}/bin/python"
  ];

  nativeBuildInputs = [ cmake extra-cmake-modules ];
  buildInputs = [ threadweaver ktexteditor kdevelop-unwrapped ];

  dontWrapQtApps = true;

  meta = with lib; {
    maintainers = [ maintainers.aanderse ];
    platforms = platforms.linux;
    description = "Python support for KDevelop";
    homepage = "https://www.kdevelop.org";
    license = [ licenses.gpl2 ];
  };
}
