{ lib
, stdenv
, cmake
, fetchFromGitHub
, glib
, glib-networking
, gnutls
, gpgme
, hiredis
, libgcrypt
, libnet
, libpcap
, libssh
, libuuid
, libxml2
, pkg-config
, zlib
, freeradius
}:

stdenv.mkDerivation rec {
  pname = "gvm-libs";
  version = "21.4.3";

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1NVLGyUDUnOy3GYDtVyhGTvWOYoWp95EbkgTlFWuxE8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    glib
    glib-networking
    gnutls
    gpgme
    hiredis
    libgcrypt
    freeradius
    libnet
    libpcap
    libssh
    libuuid
    libxml2
    zlib
  ];

  cmakeFlags = [
    "-DGVM_RUN_DIR=$out/run/gvm"
  ];

  meta = with lib; {
    description = "Libraries module for the Greenbone Vulnerability Management Solution";
    homepage = "https://github.com/greenbone/gvm-libs";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ fab ];
    platforms = platforms.linux;
  };
}
