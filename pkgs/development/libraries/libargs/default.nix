{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "args";
  version = "6.2.7";

  src = fetchFromGitHub {
    owner = "Taywee";
    repo = pname;
    rev = version;
    sha256 = "sha256-I297qPXs8Fj7Ibq2PN6y/Eas3DiW5Ecvqot0ePwFNTI=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "A simple header-only C++ argument parser library";
    homepage = "https://github.com/Taywee/args";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
