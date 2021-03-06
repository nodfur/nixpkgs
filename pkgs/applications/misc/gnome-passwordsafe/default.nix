{ lib, stdenv
, meson
, ninja
, pkg-config
, gettext
, fetchFromGitLab
, python3Packages
, libhandy
, libpwquality
, wrapGAppsHook
, gtk3
, glib
, gdk-pixbuf
, gobject-introspection
, desktop-file-utils
, appstream-glib }:

python3Packages.buildPythonApplication rec {
  pname = "gnome-passwordsafe";
  version = "5.1";
  format = "other";
  strictDeps = false; # https://github.com/NixOS/nixpkgs/issues/56943

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "secrets";
    rev = version;
    sha256 = "sha256-RgpkLoqhwCdaPZxC1Qe0MpLtYLevNCOxbvwEEI0cpE0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    gettext
    pkg-config
    wrapGAppsHook
    desktop-file-utils
    appstream-glib
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    glib
    gdk-pixbuf
    libhandy
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    construct
    pykeepass
  ] ++ [
    libpwquality # using the python bindings
  ];

  meta = with lib; {
    broken = stdenv.hostPlatform.isStatic; # libpwquality doesn't provide bindings when static
    description = "Password manager for GNOME which makes use of the KeePass v.4 format";
    homepage = "https://gitlab.gnome.org/World/secrets";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mvnetbiz ];
  };
}

