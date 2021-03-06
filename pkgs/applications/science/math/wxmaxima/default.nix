{ lib
, stdenv
, fetchFromGitHub
, wrapGAppsHook
, cmake
, gettext
, maxima
, wxGTK
, gnome
}:

stdenv.mkDerivation rec {
  pname = "wxmaxima";
  version = "21.11.0";

  src = fetchFromGitHub {
    owner = "wxMaxima-developers";
    repo = "wxmaxima";
    rev = "Version-${version}";
    sha256 = "sha256-LwuqldMGsmFR8xrNg5vsrogmdi5ysqEQGWITM460IZk=";
  };

  buildInputs = [
    wxGTK
    maxima
    # So it won't embed svg files into headers.
    gnome.adwaita-icon-theme
  ];

  nativeBuildInputs = [
    wrapGAppsHook
    cmake
    gettext
  ];

  preConfigure = ''
    gappsWrapperArgs+=(--prefix PATH ":" ${maxima}/bin)
  '';

  meta = with lib; {
    description = "Cross platform GUI for the computer algebra system Maxima";
    license = licenses.gpl2;
    homepage = "https://wxmaxima-developers.github.io/wxmaxima/";
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.linux;
  };
}
