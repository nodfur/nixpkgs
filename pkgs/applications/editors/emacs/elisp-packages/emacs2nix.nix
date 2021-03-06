let
  pkgs = import ../../../../.. { };

  src = pkgs.fetchgit {
    url = "https://github.com/nix-community/emacs2nix.git";
    fetchSubmodules = true;
    rev = "2e8d2c644397be57455ad32c2849f692eeac7797";
    sha256 = "sha256-qnOYDYHAQ+r5eegKP9GqHz5R2ig96B2W7M+uYa1ti9M=";
  };
in
pkgs.mkShell {

  packages = [
    pkgs.bash
  ];

  EMACS2NIX = src;

  shellHook = ''
    export PATH=$PATH:${src}
  '';

}
