{ lib }:

let
  sources = lib.importJSON ./sources.json;
in
{
  jdk-hotspot = import ./jdk-darwin-base.nix { sourcePerArch = sources.openjdk15.mac.jdk.hotspot; };
  jre-hotspot = import ./jdk-darwin-base.nix { sourcePerArch = sources.openjdk15.mac.jre.hotspot; };
  jdk-openj9 = import ./jdk-darwin-base.nix { sourcePerArch = sources.openjdk15.mac.jdk.openj9; };
  jre-openj9 = import ./jdk-darwin-base.nix { sourcePerArch = sources.openjdk15.mac.jre.openj9; };
}
