#!/usr/bin/env nix-shell
#!nix-shell -p coreutils curl nix jq gnused -i bash

set -eou pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

info() { echo "[INFO] $*"; }

echo_file() { echo "$@" >> hashes.nix; }

verlte() {
    [  "$1" = "$(echo -e "$1\n$2" | sort -V | head -n1)" ]
}

readonly nixpkgs=../../../../..

readonly old_version="$(nix-instantiate "$nixpkgs" --eval --strict -A graalvm11-ce.version)"

if [[ -z "${1:-}" ]]; then
  readonly gh_version="$(curl \
      ${GITHUB_TOKEN:+"-u \":$GITHUB_TOKEN\""} \
      -s https://api.github.com/repos/graalvm/graalvm-ce-builds/releases/latest | \
      jq --raw-output .tag_name)"
  readonly new_version="${gh_version//vm-/}"
else
  readonly new_version="$1"
fi

if verlte "$old_version" "$new_version"; then
  info "graalvm-ce $old_version is up-to-date."
  [[ -z "${FORCE:-}" ]]  && exit 0
else
  info "graalvm-ce $old_version is out-of-date. Updating..."
fi

readonly urls=(
  "https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${new_version}/graalvm-ce-java@platform@-${new_version}.tar.gz"
  "https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${new_version}/native-image-installable-svm-java@platform@-${new_version}.jar"
  "https://github.com/oracle/truffleruby/releases/download/vm-${new_version}/ruby-installable-svm-java@platform@-${new_version}.jar"
  "https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${new_version}/wasm-installable-svm-java@platform@-${new_version}.jar"
  "https://github.com/graalvm/graalpython/releases/download/vm-${new_version}/python-installable-svm-java@platform@-${new_version}.jar"
)

readonly platforms=(
  "11-linux-aarch64"
  "17-linux-aarch64"
  "11-linux-amd64"
  "17-linux-amd64"
  "11-darwin-amd64"
  "17-darwin-amd64"
)

info "Deleting old hashes.nix file..."
rm -f hashes.nix
info "Generating hashes.nix file for 'graalvm-ce' $new_version. This will take a while..."

echo_file "# Generated by $0 script"
echo_file "{ javaVersionPlatform, ... }:"
echo_file "["

for url in "${urls[@]}"; do
  echo_file "  {"
  echo_file "    sha256 = {"
  for platform in "${platforms[@]}"; do
    if hash="$(nix-prefetch-url "${url//@platform@/$platform}")"; then
      echo_file "      \"$platform\" = \"$hash\";"
    fi
  done
  echo_file '    }.${javaVersionPlatform} or null;'
  echo_file "    url = \"${url//@platform@/\$\{javaVersionPlatform\}}\";"
  echo_file "  }"
done

echo_file "]"

info "Updating graalvm-ce version..."
# update-source-version does not work here since it expects src attribute
sed "s|$old_version|\"$new_version\"|" -i default.nix

info "Done!"
