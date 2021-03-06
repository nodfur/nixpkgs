{ lib
, buildPythonPackage
, fetchPypi
, gevent
, gunicorn
}:

buildPythonPackage rec {
  pname = "gevent-websocket";
  version = "0.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c2zv2rahp1gil3cj66hfsqgy0n35hz9fny3ywhr2319d0lz7bky";
  };

  propagatedBuildInputs = [ gevent gunicorn ];

  # zero tests run
  doCheck = false;

  pythonImportsCheck = [ "geventwebsocket" ];

  meta = with lib; {
    homepage = "https://www.gitlab.com/noppo/gevent-websocket";
    description = "Websocket handler for the gevent pywsgi server, a Python network library";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };

}
