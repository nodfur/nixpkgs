{ lib, stdenv, fetchurl, unzip, makeWrapper, openjdk }:

stdenv.mkDerivation rec {
  pname = "pmd";
  version = "6.41.0";

  src = fetchurl {
    url = "mirror://sourceforge/pmd/pmd-bin-${version}.zip";
    sha256 = "sha256-kXyUukqLFIdaBpO+oimyrzmGm6bNwoQaRDIoMtZq45k=";
  };

  nativeBuildInputs = [ unzip makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -R {bin,lib} $out
    wrapProgram $out/bin/run.sh --prefix PATH : ${openjdk.jre}/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "An extensible cross-language static code analyzer";
    homepage = "https://pmd.github.io/";
    changelog = "https://pmd.github.io/pmd-${version}/pmd_release_notes.html";
    platforms = platforms.unix;
    license = with licenses; [ bsdOriginal asl20 lgpl3Plus ];
  };
}
