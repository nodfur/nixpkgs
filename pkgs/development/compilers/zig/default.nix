{ lib
, fetchFromGitHub
, cmake
, llvmPackages
, libxml2
, zlib
}:

let
  inherit (llvmPackages) stdenv;
in
stdenv.mkDerivation rec {
  pname = "zig";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "ziglang";
    repo = pname;
    rev = version;
    hash = "sha256-Hfl1KKtGcopMrn+U9r0/qr/wReWJIgb8+IgwMoguv/0=";
  };

  nativeBuildInputs = [
    cmake
    llvmPackages.llvm.dev
  ];
  buildInputs = [
    libxml2
    zlib
  ] ++ (with llvmPackages; [
    libclang
    lld
    llvm
  ]);

  preBuild = ''
    export HOME=$TMPDIR;
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    ./zig test --cache-dir "$TMPDIR" -I $src/test $src/test/behavior.zig
    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://ziglang.org/";
    description =
      "General-purpose programming language and toolchain for maintaining robust, optimal, and reusable software";
    license = licenses.mit;
    maintainers = with maintainers; [ andrewrk AndersonTorres ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin; # See https://github.com/NixOS/nixpkgs/issues/86299
  };
}
