{ lib, fetchzip }:

let
  version = "0.62";
in fetchzip {
  name = "sudo-font-${version}";
  url = "https://github.com/jenskutilek/sudo-font/releases/download/v${version}/sudo.zip";
  sha256 = "sha256-I0E2zYbfEFBEIBNC7nnJb+hOaBgGZkAIg08YpA8awso=";

  postFetch = ''
    mkdir -p $out/share/fonts/
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype/
  '';
  meta = with lib; {
    description = "Font for programmers and command line users";
    homepage = "https://www.kutilek.de/sudo-font/";
    changelog = "https://github.com/jenskutilek/sudo-font/raw/v${version}/sudo/FONTLOG.txt";
    license = licenses.ofl;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}
