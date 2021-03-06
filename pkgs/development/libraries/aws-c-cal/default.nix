{ lib, stdenv, fetchFromGitHub, cmake, aws-c-common, openssl, Security }:

stdenv.mkDerivation rec {
  pname = "aws-c-cal";
  version = "0.5.12";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KzuaT9c1l9Uhyj6IEy8JfDYzEYI2OcUkq+KRDoJx+Cc=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ aws-c-common openssl ];

  propagatedBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  meta = with lib; {
    description = "AWS Crypto Abstraction Layer ";
    homepage = "https://github.com/awslabs/aws-c-cal";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej ];
  };
}
