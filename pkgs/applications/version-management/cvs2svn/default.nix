{ lib, fetchurl, makeWrapper
, pypy2Packages
, cvs, subversion, git, breezy
}:

pypy2Packages.buildPythonApplication  rec {
  pname = "cvs2svn";
  version = "2.5.0";

  src = fetchurl {
    url = "http://cvs2svn.tigris.org/files/documents/1462/49543/${pname}-${version}.tar.gz";
    sha256 = "1ska0z15sjhyfi860rjazz9ya1gxbf5c0h8dfqwz88h7fccd22b4";
  };

  nativeBuildInputs = [ makeWrapper ];

  checkInputs = [ subversion git breezy ];

  checkPhase = "${pypy2Packages.python.interpreter} run-tests.py";

  doCheck = false; # Couldn't find node 'transaction...' in expected output tree

  postInstall = ''
    for i in bzr svn git; do
      wrapProgram $out/bin/cvs2$i \
          --prefix PATH : "${lib.makeBinPath [ cvs ]}"
    done
  '';

  meta = with lib; {
    description = "A tool to convert CVS repositories to Subversion repositories";
    homepage = "http://cvs2svn.tigris.org/";
    maintainers = [ maintainers.makefu ];
    platforms = platforms.unix;
    license = licenses.asl20;
  };
}
