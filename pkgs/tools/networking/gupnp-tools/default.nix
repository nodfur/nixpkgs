{ stdenv
, lib
, fetchurl
, meson
, ninja
, gupnp
, gssdp
, pkg-config
, gtk3
, libuuid
, gettext
, gupnp-av
, gtksourceview4
, gnome
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gupnp-tools";
  version = "0.10.2";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "beSe9LN1uKFk90t2YWixGE4NKBlrawek9TQfCN/YXWw=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    wrapGAppsHook
  ];

  buildInputs = [
    gupnp
    libuuid
    gssdp
    gtk3
    gupnp-av
    gtksourceview4
    gnome.adwaita-icon-theme
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Set of utilities and demos to work with UPnP";
    homepage = "https://wiki.gnome.org/Projects/GUPnP";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
