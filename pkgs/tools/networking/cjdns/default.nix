{ lib, stdenv, fetchFromGitHub, nodejs, which, python3, util-linux, nixosTests }:

stdenv.mkDerivation rec {
  pname = "cjdns";
  version = "21.1";

  src = fetchFromGitHub {
    owner = "cjdelisle";
    repo = "cjdns";
    rev = "cjdns-v${version}";
    sha256 = "NOmk+vMZ8i0E2MjrUzksk+tkJ9XVVNEXlE5OOTNa+Y0=";
  };

  buildInputs = [ which python3 nodejs ] ++
    # for flock
    lib.optional stdenv.isLinux util-linux;

  CFLAGS = "-O2 -Wno-error=stringop-truncation";
  buildPhase =
    lib.optionalString stdenv.isAarch32 "Seccomp_NO=1 "
    + "bash do";
  installPhase = ''
    install -Dt "$out/bin/" cjdroute makekeys privatetopublic publictoip6
    mkdir -p $out/share/cjdns
    cp -R tools node_build node_modules $out/share/cjdns/
  '';

  passthru.tests.basic = nixosTests.cjdns;

  meta = with lib; {
    homepage = "https://github.com/cjdelisle/cjdns";
    description = "Encrypted networking for regular people";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ehmry ];
    platforms = platforms.linux;
  };
}
