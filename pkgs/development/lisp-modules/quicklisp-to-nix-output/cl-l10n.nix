/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-l10n";
  version = "20211209-git";

  parasites = [ "cl-l10n/test" ];

  description = "Portable CL Locale Support";

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cl-fad" args."cl-l10n-cldr" args."cl-ppcre" args."closer-mop" args."closure-common" args."cxml" args."flexi-streams" args."hu_dot_dwim_dot_stefil" args."iterate" args."local-time" args."metabang-bind" args."parse-number" args."puri" args."trivial-features" args."trivial-gray-streams" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-l10n/2021-12-09/cl-l10n-20211209-git.tgz";
    sha256 = "0l67xg282pim6167g27zcqk4xj51cfpmcbzc8bjg8933w42fdjf4";
  };

  packageName = "cl-l10n";

  asdFilesToKeep = ["cl-l10n.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-l10n DESCRIPTION Portable CL Locale Support SHA256
    0l67xg282pim6167g27zcqk4xj51cfpmcbzc8bjg8933w42fdjf4 URL
    http://beta.quicklisp.org/archive/cl-l10n/2021-12-09/cl-l10n-20211209-git.tgz
    MD5 e575bb4ff3a6d0bbba5220c631f9c83a NAME cl-l10n FILENAME cl-l10n DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-fad FILENAME cl-fad) (NAME cl-l10n-cldr FILENAME cl-l10n-cldr)
     (NAME cl-ppcre FILENAME cl-ppcre) (NAME closer-mop FILENAME closer-mop)
     (NAME closure-common FILENAME closure-common) (NAME cxml FILENAME cxml)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME hu.dwim.stefil FILENAME hu_dot_dwim_dot_stefil)
     (NAME iterate FILENAME iterate) (NAME local-time FILENAME local-time)
     (NAME metabang-bind FILENAME metabang-bind)
     (NAME parse-number FILENAME parse-number) (NAME puri FILENAME puri)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams))
    DEPENDENCIES
    (alexandria babel bordeaux-threads cl-fad cl-l10n-cldr cl-ppcre closer-mop
     closure-common cxml flexi-streams hu.dwim.stefil iterate local-time
     metabang-bind parse-number puri trivial-features trivial-gray-streams)
    VERSION 20211209-git SIBLINGS NIL PARASITES (cl-l10n/test)) */
