{
  config,
  lib,
  pkgs,
  craneLib,
  fenix,
  ...
}: let
  rust =
    fenix.packages.stable.minimalToolchain;
  crane = craneLib.overrideToolchain rust;
  src = pkgs.fetchFromGitHub {
    owner = "matter-labs";
    repo = "anvil-zksuync";
    rev = "v0.2.5";
    sha256 = lib.fakeSha256;
  };
in
  crane.buildPackage {
    inherit src;
    buildInputs = with pkgs; [cmake pkg-config perl openssl clang] ++ lib.optionals pkgs.stdenv.isDarwin (with pkgs.darwin; [libiconv apple_sdk.frameworks.SystemConfiguration]);
  }
