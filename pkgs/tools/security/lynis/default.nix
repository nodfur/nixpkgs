{ lib, stdenv, makeWrapper, fetchFromGitHub, gawk, installShellFiles }:

stdenv.mkDerivation rec {
  pname = "lynis";
  version = "3.0.7";

  src = fetchFromGitHub {
    owner = "CISOfy";
    repo = pname;
    rev = version;
    sha256 = "sha256-tO9/egY4eNwQpCZU0zx8G3k4UYsf7S3tUdr6pCMTAWU=";
  };

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  postPatch = ''
    grep -rl '/usr/local/lynis' ./ | xargs sed -i "s@/usr/local/lynis@$out/share/lynis@g"
  '';

  installPhase = ''
    install -d $out/bin $out/share/lynis/plugins
    cp -r include db default.prf $out/share/lynis/
    cp -a lynis $out/bin
    wrapProgram "$out/bin/lynis" --prefix PATH : ${lib.makeBinPath [ gawk ]}

    installManPage lynis.8
    installShellCompletion --bash --name lynis.bash \
      extras/bash_completion.d/lynis
  '';

  meta = with lib; {
    description = "Security auditing tool for Linux, macOS, and UNIX-based systems";
    homepage = "https://cisofy.com/lynis/";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.ryneeverett ];
  };
}
