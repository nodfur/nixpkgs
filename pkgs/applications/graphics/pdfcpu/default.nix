{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pdfcpu";
  version = "0.3.13";

  src = fetchFromGitHub {
    owner = "pdfcpu";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-CFKo8YEAXAniX+jL2A0naJUOn3KAWwcrPsabdiZevhI=";
  };

  vendorSha256 = "sha256-p/2Bu5h2P3ebgvSC12jdR2Zpd27xCFwtB/KZV0AULAM=";

  # No tests
  doCheck = false;
  doInstallCheck = true;
  installCheckPhase = ''
    export HOME=$(mktemp -d)
    echo checking the version print of pdfcpu
    $out/bin/pdfcpu version | grep ${version}
  '';

  subPackages = [ "cmd/pdfcpu" ];

  meta = with lib; {
    description = "A PDF processor written in Go";
    homepage = "https://pdfcpu.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ doronbehar ];
  };
}
