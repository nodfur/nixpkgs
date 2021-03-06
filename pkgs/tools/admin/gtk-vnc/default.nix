{ lib
, stdenv
, fetchurl
, meson
, ninja
, gobject-introspection
, gnutls
, cairo
, glib
, pkg-config
, cyrus_sasl
, libpulseaudio
, libgcrypt
, gtk3
, vala
, gettext
, perl
, python3
, gnome
, gdk-pixbuf
, zlib
}:

stdenv.mkDerivation rec {
  pname = "gtk-vnc";
  version = "1.3.0";

  outputs = [ "out" "bin" "man" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "X6qlgjuMvowLC6HkVsTnDEsa5mhcn+gaQoLZjPAKIR0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    vala
    gettext
    perl # for pod2man
    python3
  ];

  buildInputs = [
    gnutls
    cairo
    gdk-pixbuf
    zlib
    glib
    libgcrypt
    cyrus_sasl
    libpulseaudio
    gtk3
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    description = "GTK VNC widget";
    homepage = "https://wiki.gnome.org/Projects/gtk-vnc";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ raskin offline ];
    platforms = platforms.linux;
  };
}
