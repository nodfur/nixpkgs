{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, pkg-config, ilmbase, libtiff, openexr }:

stdenv.mkDerivation rec {
  pname = "ctl";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "ampas";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "0a698rd1cmixh3mk4r1xa6rjli8b8b7dbx89pb43xkgqxy67glwx";
  };

  patches = [
    (fetchpatch {
      name = "ctl-1.5.2-ilm_230.patch";
      url = "https://src.fedoraproject.org/rpms/CTL/raw/9d7c15a91bccdc0a9485d463bf2789be72e6b17d/f/ctl-1.5.2-ilm_230.patch";
      sha256 = "0mdx7llwrm0q8ai53zhyxi40i9h5s339dbkqpqv30yzi2xpnfj3d";
    })
  ];

  postPatch = ''
    # Fix include guard name
    substituteInPlace lib/dpx/dpx_raw.hh \
        --replace CRL_DPX_RAW_INTERNAL_INCLUDE CTL_DPX_RAW_INTERNAL_INCLUDE

    # Fix undefined symbols (link with Imath)
    substituteInPlace lib/IlmCtlMath/CMakeLists.txt \
        --replace "( IlmCtlMath IlmCtl )" "( IlmCtlMath IlmCtl Imath)"
  '';

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ libtiff ilmbase openexr ];

  meta = with lib; {
    description = "Color Transformation Language";
    homepage = "https://github.com/ampas/CTL";
    license = "A.M.P.A.S"; # BSD-derivative, free but GPL incompatible
    platforms = platforms.all;
  };
}
