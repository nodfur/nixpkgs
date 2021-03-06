{ lib
, fetchFromGitHub
, buildPythonApplication
, asciidoc-full
, docopt
, gettext
, gobject-introspection
, gtk3
, keyutils
, libappindicator-gtk3
, libnotify
, librsvg
, nose
, pygobject3
, pyyaml
, udisks2
, wrapGAppsHook
}:

buildPythonApplication rec {
  pname = "udiskie";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "coldfix";
    repo = "udiskie";
    rev = "v${version}";
    hash = "sha256-T4kMPMXfehZT7P+TOd1llR2TbHPA/quNL545xxlmJfE=";
  };

  outputs = [ "out" "man" ];

  nativeBuildInputs = [
    asciidoc-full # Man page
    gettext
    gobject-introspection
    wrapGAppsHook
  ];

  buildInputs = [
    gobject-introspection
    gtk3
    libappindicator-gtk3
    libnotify
    librsvg # SVG icons
    udisks2
  ];

  propagatedBuildInputs = [
    docopt
    pygobject3
    pyyaml
  ];

  postBuild = ''
    make -C doc
  '';

  postInstall = ''
    mkdir -p $man/share/man/man8
    cp -v doc/udiskie.8 $man/share/man/man8/
  '';

  checkInputs = [
    keyutils
    nose
  ];

  checkPhase = ''
    nosetests
  '';

  meta = with lib; {
    homepage = "https://github.com/coldfix/udiskie";
    description = "Removable disk automounter for udisks";
    longDescription = ''
      udiskie is a udisks2 front-end that allows to manage removeable media such
      as CDs or flash drives from userspace.

      Its features include:
      - automount removable media
      - notifications
      - tray icon
      - command line tools for manual un-/mounting
      - LUKS encrypted devices
      - unlocking with keyfiles (requires udisks 2.6.4)
      - loop devices (mounting iso archives)
      - password caching (requires python keyutils 0.3)
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
