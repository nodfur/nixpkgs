{ stdenv, lib, mkDerivation, fetchFromGitHub
, cmake, freetype, libpng, libGLU, libGL, openssl, perl, libiconv
, qtscript, qtserialport, qttools
, qtmultimedia, qtlocation, qtbase, wrapQtAppsHook
}:

mkDerivation rec {
  pname = "stellarium";
  version = "0.21.3";

  src = fetchFromGitHub {
    owner = "Stellarium";
    repo = "stellarium";
    rev = "v${version}";
    sha256 = "sha256-TQMLy5ziBF7YqPDzPwgjY5FHxxMUe7MXo/TGxQ1nGcg=";
  };

  nativeBuildInputs = [ cmake perl wrapQtAppsHook ];

  buildInputs = [
    freetype libpng libGLU libGL openssl libiconv qtscript qtserialport qttools
    qtmultimedia qtlocation qtbase
  ];

  preConfigure = lib.optionalString stdenv.isDarwin ''
    substituteInPlace CMakeLists.txt \
      --replace 'SET(CMAKE_INSTALL_PREFIX "''${PROJECT_BINARY_DIR}/Stellarium.app/Contents")' \
                'SET(CMAKE_INSTALL_PREFIX "${placeholder "out"}/Stellarium.app/Contents")'
  '';

  meta = with lib; {
    description = "Free open-source planetarium";
    homepage = "http://stellarium.org/";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ma27 ];
  };
}
