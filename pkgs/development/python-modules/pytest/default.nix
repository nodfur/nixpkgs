{ lib, buildPythonPackage, pythonOlder, fetchPypi, isPy3k, isPyPy
, pythonAtLeast, fetchpatch
, atomicwrites
, attrs
, hypothesis
, iniconfig
, more-itertools
, packaging
, pathlib2
, pluggy
, py
, pygments
, setuptools
, setuptools-scm
, six
, toml
, wcwidth
, writeText
}:

buildPythonPackage rec {
  pname = "pytest";
  version = "6.2.5";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "131b36680866a76e6781d13f101efb86cf674ebb9762eb70d3082b6f29889e89";
  };

  patches = lib.optionals (pythonAtLeast "3.10") [
    (fetchpatch {
      # Fix test_errors_in_xfail_skip_expressions for Python 3.10.1, remove after 6.2.5
      url = "https://github.com/pytest-dev/pytest/commit/913439f5e5691f391e2969b3c8f0a49e50dce43a.patch";
      sha256 = "0hsl3lww6bx5k99cp8gj0fy9rg02kcfbwiiwjx2y8vbhwd5ns41p";
    })
  ];

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    atomicwrites
    attrs
    iniconfig
    more-itertools
    packaging
    pluggy
    py
    setuptools
    six
    toml
    wcwidth
  ] ++ lib.optionals (pythonOlder "3.6") [ pathlib2 ];

  checkInputs = [
    hypothesis
    pygments
  ];

  doCheck = !isPyPy; # https://github.com/pytest-dev/pytest/issues/3460

  preCheck = ''
    # don't test bash builtins
    rm testing/test_argcomplete.py
  '';

  # Ignored file https://github.com/pytest-dev/pytest/pull/5605#issuecomment-522243929
  # test_missing_required_plugins will emit deprecation warning which is treated as error
  checkPhase = ''
    runHook preCheck
    $out/bin/py.test -x testing/ \
      --ignore=testing/test_junitxml.py \
      -k "not test_collect_pyargs_with_testpaths and not test_missing_required_plugins"

    # tests leave behind unreproducible pytest binaries in the output directory, remove:
    find $out/lib -name "*-pytest-${version}.pyc" -delete
    # specifically testing/test_assertion.py and testing/test_assertrewrite.py leave behind those:
    find $out/lib -name "*opt-2.pyc" -delete

    runHook postCheck
  '';

  # Remove .pytest_cache when using py.test in a Nix build
  setupHook = writeText "pytest-hook" ''
    pytestcachePhase() {
        find $out -name .pytest_cache -type d -exec rm -rf {} +
    }
    preDistPhases+=" pytestcachePhase"

    # pytest generates it's own bytecode files to improve assertion messages.
    # These files similar to cpython's bytecode files but are never laoded
    # by python interpreter directly. We remove them for a few reasons:
    # - files are non-deterministic: https://github.com/NixOS/nixpkgs/issues/139292
    #   (file headers are generatedt by pytest directly and contain timestamps)
    # - files are not needed after tests are finished
    pytestRemoveBytecodePhase () {
        # suffix is defined at:
        #    https://github.com/pytest-dev/pytest/blob/6.2.5/src/_pytest/assertion/rewrite.py#L51-L53
        find $out -name "*-pytest-*.py[co]" -delete
    }
    preDistPhases+=" pytestRemoveBytecodePhase"
  '';

  pythonImportsCheck = [
    "pytest"
  ];

  meta = with lib; {
    description = "Framework for writing tests";
    homepage = "https://docs.pytest.org";
    changelog = "https://github.com/pytest-dev/pytest/releases/tag/${version}";
    maintainers = with maintainers; [ domenkozar lovek323 madjar lsix ];
    license = licenses.mit;
  };
}
