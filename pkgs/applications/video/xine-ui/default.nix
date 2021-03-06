{ lib
, stdenv
, fetchurl
, curl
, libjpeg
, libpng
, lirc
, ncurses
, pkg-config
, readline
, shared-mime-info
, xine-lib
, xorg
}:

stdenv.mkDerivation rec {
  pname = "xine-ui";
  version = "0.99.13";

  src = fetchurl {
    url = "mirror://sourceforge/xine/${pname}-${version}.tar.xz";
    sha256 = "sha256-sjgtB1xysbEAOeDpAxDMhsjZEDWMU1We2C09WEIB9cU=";
  };

  nativeBuildInputs = [
    pkg-config
    shared-mime-info
  ];
  buildInputs = [
    curl
    libjpeg
    libpng
    lirc
    ncurses
    readline
    xine-lib
  ] ++ (with xorg; [
    libXext
    libXft
    libXi
    libXinerama
    libXtst
    libXv
    libXxf86vm
    xlibsWrapper
    xorgproto
  ]);

  configureFlags = [ "--with-readline=${readline.dev}" ];

  LIRC_CFLAGS="-I${lirc}/include";
  LIRC_LIBS="-L ${lirc}/lib -llirc_client";

  postInstall = ''
    substituteInPlace $out/share/applications/xine.desktop \
      --replace "MimeType=;" "MimeType="
  '';

  meta = with lib; {
    homepage = "http://xinehq.de/";
    description = "Xlib-based frontend for Xine video player";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.linux;
  };
}
