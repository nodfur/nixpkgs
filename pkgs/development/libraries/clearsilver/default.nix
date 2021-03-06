{ lib, stdenv, fetchurl, fetchpatch, python2 }:

stdenv.mkDerivation rec {
  pname = "clearsilver";
  version = "0.10.5";

  src = fetchurl {
    url = "http://www.clearsilver.net/downloads/clearsilver-${version}.tar.gz";
    sha256 = "1046m1dpq3nkgxbis2dr2x7hynmy51n64465q78d7pdgvqwa178y";
  };

  PYTHON_SITE = "${placeholder "out"}/${python2.sitePackages}";

  configureFlags = [
    "--with-python=${python2.interpreter}"
    "--disable-apache"
    "--disable-perl"
    "--disable-ruby"
    "--disable-java"
    "--disable-csharp"
  ];

  preInstall = ''
    mkdir -p $out
    mkdir -p $out/${python2.sitePackages}
  '';

  patches = [
    (fetchpatch {
      url = "https://sources.debian.net/data/main/c/clearsilver/0.10.5-1.6/debian/patches/clang-gcc5.patch";
      sha256 = "0d44v9jx0b6k8nvrhknd958i9rs59kdh73z0lb4f1mzi8if16c38";
    })
    (fetchpatch {
      url = "https://sources.debian.net/data/main/c/clearsilver/0.10.5-1.6/debian/patches/CVE-2011-4357.diff";
      sha256 = "1lfncavxdqckrz03gv97lcliygbpi9lnih944vmdbn9zw6fwcipi";
    })
  ];

  meta = with lib; {
    description = "Fast, powerful, and language-neutral HTML template system";
    homepage = "http://www.clearsilver.net/";
    license = licenses.free;
  };
}
