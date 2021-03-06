{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, setuptools
, packaging
, toml
, structlog
, appdirs
, pytest-asyncio
, flaky
, tornado
, pycurl
, aiohttp
, pytest-httpbin
, docutils
, installShellFiles
}:

buildPythonPackage rec {
  pname = "nvchecker";
  version = "2.5";

  # Tests not included in PyPI tarball
  src = fetchFromGitHub {
    owner = "lilydjwg";
    repo = pname;
    rev = "v${version}";
    sha256 = "0jzmpra87dlj88d20ihnva9fj81wqbbd9qbzsjwwvzdx062136mg";
  };

  nativeBuildInputs = [ installShellFiles docutils ];
  propagatedBuildInputs = [ setuptools packaging toml structlog appdirs tornado pycurl aiohttp ];
  checkInputs = [ pytestCheckHook pytest-asyncio flaky pytest-httpbin ];

  disabled = pythonOlder "3.7";

  postBuild = ''
    patchShebangs docs/myrst2man.py
    make -C docs man
  '';

  postInstall = ''
    installManPage docs/_build/man/nvchecker.1
  '';

  pytestFlagsArray = [ "-m 'not needs_net'" ];

  meta = with lib; {
    homepage = "https://github.com/lilydjwg/nvchecker";
    description = "New version checker for software";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
