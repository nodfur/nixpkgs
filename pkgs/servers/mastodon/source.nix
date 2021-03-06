# This file was generated by pkgs.mastodon.updateScript.
{ fetchgit, applyPatches }: let
  src = fetchgit {
    url = "https://github.com/tootsuite/mastodon.git";
    rev = "v3.4.4";
    sha256 = "0gi818ns7ws63g7izhcqq5b28kifzmvg0p278lq82h02ysg9grj3";
  };
in applyPatches {
  inherit src;
  patches = [./resolutions.patch ./version.patch ];
}
