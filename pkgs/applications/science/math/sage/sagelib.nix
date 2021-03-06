{ sage-src
, env-locations
, perl
, buildPythonPackage
, arb
, blas
, lapack
, brial
, cliquer
, cypari2
, cysignals
, cython
, lisp-compiler
, eclib
, ecm
, flint
, gd
, giac
, givaro
, glpk
, gsl
, iml
, jinja2
, lcalc
, lrcalc
, gap
, linbox
, m4ri
, m4rie
, memory-allocator
, libmpc
, mpfi
, ntl
, numpy
, pari
, pkgconfig # the python module, not the pkg-config alias
, pkg-config
, planarity
, ppl
, pynac
, python
, ratpoints
, readline
, rankwidth
, symmetrica
, zn_poly
, fflas-ffpack
, boost
, singular
, pip
, jupyter_core
, libhomfly
, libbraiding
, gmpy2
, pplpy
, sqlite
}:

assert (!blas.isILP64) && (!lapack.isILP64);

# This is the core sage python package. Everything else is just wrappers gluing
# stuff together. It is not very useful on its own though, since it will not
# find many of its dependencies without `sage-env`, will not be tested without
# `sage-tests` and will not have html docs without `sagedoc`.

buildPythonPackage rec {
  version = src.version;
  pname = "sagelib";
  src = sage-src;

  nativeBuildInputs = [
    iml
    perl
    jupyter_core
    pkg-config
    pip # needed to query installed packages
    lisp-compiler
  ];

  buildInputs = [
    gd
    readline
    iml
  ];

  propagatedBuildInputs = [
    cypari2
    jinja2
    numpy
    pkgconfig
    boost
    arb
    brial
    cliquer
    lisp-compiler
    eclib
    ecm
    fflas-ffpack
    flint
    giac
    givaro
    glpk
    gsl
    lcalc
    gap
    libmpc
    linbox
    lrcalc
    m4ri
    m4rie
    memory-allocator
    mpfi
    ntl
    blas
    lapack
    pari
    planarity
    ppl
    pynac
    rankwidth
    ratpoints
    singular
    symmetrica
    zn_poly
    pip
    cython
    cysignals
    libhomfly
    libbraiding
    gmpy2
    pplpy
    sqlite
  ];

  preBuild = ''
    export SAGE_ROOT="$PWD"
    export SAGE_LOCAL="$SAGE_ROOT"
    export SAGE_SHARE="$SAGE_LOCAL/share"

    # set locations of dependencies (needed for nbextensions like threejs)
    . ${env-locations}/sage-env-locations

    export JUPYTER_PATH="$SAGE_LOCAL/jupyter"
    export PATH="$SAGE_ROOT/build/bin:$SAGE_ROOT/src/bin:$PATH"

    export SAGE_NUM_THREADS="$NIX_BUILD_CORES"

    mkdir -p "$SAGE_SHARE/sage/ext/notebook-ipython"
    mkdir -p "var/lib/sage/installed"

    # src/setup.py should not be used, see https://trac.sagemath.org/ticket/31377#comment:124
    cd build/pkgs/sagelib/src
  '';

  postInstall = ''
    rm -r "$out/${python.sitePackages}/sage/cython_debug"
  '';

  doCheck = false; # we will run tests in sage-tests.nix
}
