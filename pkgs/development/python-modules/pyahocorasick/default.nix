{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyahocorasick";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "WojciechMula";
    repo = pname;
    rev = version;
    sha256 = "13x3718if28l50474xrz1b9709kvnvdg3nzm6y8bh7mc9a4zyss5";
  };

  patches = [
    # Use proper temporary directory on Hydra
    (fetchpatch {
      url = "https://github.com/WojciechMula/pyahocorasick/commit/b6549e06f3cced7ffdf4d1b587cd7de12041f495.patch";
      sha256 = "sha256-v3J/0aIPOnBhLlJ18r/l7O0MckqLOCtcmqIS9ZegaSI=";
    })
  ];

  checkInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "unittests.py" ];
  pythonImportsCheck = [ "ahocorasick" ];

  meta = with lib; {
    description = "Python module implementing Aho-Corasick algorithm";
    longDescription = ''
      This Python module is a fast and memory efficient library for exact or
      approximate multi-pattern string search meaning that you can find multiple
      key strings occurrences at once in some input text.
    '';
    homepage = "https://github.com/WojciechMula/pyahocorasick";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
