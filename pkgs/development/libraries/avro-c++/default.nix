{ lib, stdenv, fetchurl, cmake, boost, python3 }:

stdenv.mkDerivation rec {
  pname = "avro-c++";
  version = "1.8.2";

  src = fetchurl {
    url = "mirror://apache/avro/avro-${version}/cpp/avro-cpp-${version}.tar.gz";
    sha256 = "1ars58bfw83s8f1iqbhnqp4n9wc9cxsph0gs2a8k7r9fi09vja2k";
  };

  nativeBuildInputs = [ cmake python3 ];
  buildInputs = [ boost ];

  preConfigure = ''
    substituteInPlace test/SchemaTests.cc --replace "BOOST_CHECKPOINT" "BOOST_TEST_CHECKPOINT"
    substituteInPlace test/buffertest.cc --replace "BOOST_MESSAGE" "BOOST_TEST_MESSAGE"
  '';

  meta = {
    description = "A C++ library which implements parts of the Avro Specification";
    homepage = "https://avro.apache.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rasendubi ];
    platforms = lib.platforms.all;
  };
}
