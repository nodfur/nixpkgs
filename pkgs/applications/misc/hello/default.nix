{ lib
, stdenv
, fetchurl
, nixos
, testVersion
, testEqualDerivation
, hello
}:

stdenv.mkDerivation rec {
  pname = "hello";
  version = "2.10";

  src = fetchurl {
    url = "mirror://gnu/hello/${pname}-${version}.tar.gz";
    sha256 = "0ssi1wpaf7plaswqqjwigppsg5fyh99vdlb9kzl7c9lng89ndq1i";
  };

  doCheck = true;

  passthru.tests = {
    version = testVersion { package = hello; };

    invariant-under-noXlibs =
      testEqualDerivation
        "hello must not be rebuilt when environment.noXlibs is set."
        hello
        (nixos { environment.noXlibs = true; }).pkgs.hello;
  };

  meta = with lib; {
    description = "A program that produces a familiar, friendly greeting";
    longDescription = ''
      GNU Hello is a program that prints "Hello, world!" when you run it.
      It is fully customizable.
    '';
    homepage = "https://www.gnu.org/software/hello/manual/";
    changelog = "https://git.savannah.gnu.org/cgit/hello.git/plain/NEWS?h=v${version}";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.eelco ];
    platforms = platforms.all;
  };
}
