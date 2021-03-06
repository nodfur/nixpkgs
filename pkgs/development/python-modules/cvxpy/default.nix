{ lib
, stdenv
, pythonOlder
, buildPythonPackage
, fetchPypi
, cvxopt
, ecos
, numpy
, osqp
, scipy
, scs
, useOpenmp ? (!stdenv.isDarwin)
  # Check inputs
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cvxpy";
  version = "1.1.18";
  format = "pyproject";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-W67+Hy7Wk3dJspNYbGzk9C7TDniQIj92Ycyyu333C+8=";
  };

  propagatedBuildInputs = [
    cvxopt
    ecos
    numpy
    osqp
    scipy
    scs
  ];

  # Required flags from https://github.com/cvxgrp/cvxpy/releases/tag/v1.1.11
  preBuild = lib.optionalString useOpenmp ''
    export CFLAGS="-fopenmp"
    export LDFLAGS="-lgomp"
  '';

  checkInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "./cvxpy" ];

   # Disable the slowest benchmarking tests, cuts test time in half
  disabledTests = [
    "test_tv_inpainting"
    "test_diffcp_sdp_example"
  ] ++ lib.optionals stdenv.isAarch64 [
    "test_ecos_bb_mi_lp_2" # https://github.com/cvxgrp/cvxpy/issues/1241#issuecomment-780912155
  ];

  pythonImportsCheck = [ "cvxpy" ];

  meta = with lib; {
    description = "A domain-specific language for modeling convex optimization problems in Python";
    homepage = "https://www.cvxpy.org/";
    downloadPage = "https://github.com/cvxgrp/cvxpy/releases";
    changelog = "https://github.com/cvxgrp/cvxpy/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
