{ lib, stdenv, fetchurl, fetchgit, fetchpatch, autogen, flex, bison, python2, autoconf, automake
, gettext, ncurses, libusb-compat-0_1, freetype, qemu, lvm2
, for_HP_laptop ? false
}:

with lib;
let
  pcSystems = {
    i686-linux.target = "i386";
    x86_64-linux.target = "i386";
  };

  inPCSystems = any (system: stdenv.hostPlatform.system == system) (mapAttrsToList (name: _: name) pcSystems);

  version = if for_HP_laptop then "1.2.1" else "1.2.0";

  unifont_bdf = fetchurl {
    url = "http://unifoundry.com/unifont-5.1.20080820.bdf.gz";
    sha256 = "0s0qfff6n6282q28nwwblp5x295zd6n71kl43xj40vgvdqxv0fxx";
  };

  po_src = fetchurl {
    name = "grub-2.02-beta2.tar.gz";
    url = "https://alpha.gnu.org/gnu/grub/grub-2.02~beta2.tar.gz";
    sha256 = "1lr9h3xcx0wwrnkxdnkfjwy08j7g7mdlmmbdip2db4zfgi69h0rm";

  };

in

stdenv.mkDerivation rec {
  pname = "trustedGRUB2";
  inherit version;

  src = if for_HP_laptop
        then fetchgit {
          url = "https://github.com/Sirrix-AG/TrustedGRUB2";
          rev = "ab483d389bda3115ca0ae4202fd71f2e4a31ad41";
          sha256 = "1760d9hsnqkdvlag9nn8f613mqhnsxmidgvdkpmb37b0yi7p6lhz";
        }
        else fetchgit {
          url = "https://github.com/Sirrix-AG/TrustedGRUB2";
          rev = "1ff54a5fbe02ea01df5a7de59b1e0201e08d4f76";
          sha256 = "0yrfwx67gpg9gij5raq0cfbx3jj769lkg3diqgb7i9n86hgcdh4k";
        };

  nativeBuildInputs = [ autogen flex bison python2 autoconf automake ];
  buildInputs = [ ncurses libusb-compat-0_1 freetype gettext lvm2 ]
    ++ optional doCheck qemu;

  hardeningDisable = [ "stackprotector" "pic" ];

  NIX_CFLAGS_COMPILE = "-Wno-error"; # generated code redefines yyfree

  preConfigure =
    '' for i in "tests/util/"*.in
       do
         sed -i "$i" -e's|/bin/bash|${stdenv.shell}|g'
       done

       # Apparently, the QEMU executable is no longer called
       # `qemu-system-i386', even on i386.
       #
       # In addition, use `-nodefaults' to avoid errors like:
       #
       #  chardev: opening backend "stdio" failed
       #  qemu: could not open serial device 'stdio': Invalid argument
       #
       # See <http://www.mail-archive.com/qemu-devel@nongnu.org/msg22775.html>.
       sed -i "tests/util/grub-shell.in" \
           -e's/qemu-system-i386/qemu-system-x86_64 -nodefaults/g'
    '';

  prePatch =
    '' tar zxf ${po_src} grub-2.02~beta2/po
       rm -rf po
       mv grub-2.02~beta2/po po
       sh autogen.sh
       gunzip < "${unifont_bdf}" > "unifont.bdf"
       sed -i "configure" \
           -e "s|/usr/src/unifont.bdf|$PWD/unifont.bdf|g"
    '';

  patches = [
    ./fix-bash-completion.patch
    (fetchpatch {
      # glibc-2.26 and above needs '<sys/sysmacros.h>'
      url = "https://github.com/Rohde-Schwarz/TrustedGRUB2/commit/7a5b301e3adb8e054288518a325135a1883c1c6c.patch";
      sha256 = "1jfrrmcrd9a8w7n419kszxgbpshx7888wc05smg5q4jvc1ag3xm7";
    })
  ];

  # save target that grub is compiled for
  grubTarget = if inPCSystems
               then "${pcSystems.${stdenv.hostPlatform.system}.target}-pc"
               else "";

  doCheck = false;
  # On -j16 races with early header creation:
  #  config.h:38:10: fatal error: ./config-util.h: No such file or directory
  enableParallelBuilding = false;

  meta = with lib; {
    description = "GRUB 2.0 extended with TCG (TPM) support for integrity measured boot process (trusted boot)";
    homepage = "https://github.com/Sirrix-AG/TrustedGRUB2";
    license = licenses.gpl3Plus;
    platforms = platforms.gnu ++ platforms.linux;
  };
}
