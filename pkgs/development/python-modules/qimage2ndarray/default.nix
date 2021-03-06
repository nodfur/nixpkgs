{ lib, buildPythonPackage, fetchPypi, isPy3k
, numpy
, pyqt5
}:

buildPythonPackage rec {
  pname = "qimage2ndarray";
  version = "1.8.3";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "b02bd2dc7de774f954544312ec1020cf2d7e03fdd23ec9eb79901da55ccb3365";
  };

  propagatedBuildInputs = [
    numpy
    pyqt5
  ];

  # no tests executed
  doCheck = false;

  meta = {
    homepage = "https://github.com/hmeine/qimage2ndarray";
    description = "A small python extension for quickly converting between QImages and numpy.ndarrays (in both directions)";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ tbenst ];
  };
}
