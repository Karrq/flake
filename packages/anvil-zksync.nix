{ lib, pkgs, ... }:
pkgs.stdenv.mkDerivation rec {
  pname = "anvil-zksync";
  version = "0.2.5"; # Replace with the version of the binary

  src = pkgs.fetchzip {
    url =
      "https://github.com/matter-labs/anvil-zksync/releases/download/v${version}/${pname}-v${version}-aarch64-apple-darwin.tar.gz";
    sha256 = "sha256-N4cXdoMvfgPeTPZZXfcZLqeoZQVtIxPW4k5b9YPei80=";
  };
  installPhase = ''
    mkdir -p $out/bin
    cp $src/anvil-zksync $out/bin/anvil-zksync
    chmod +x $out/bin/anvil-zksync
  '';
}
