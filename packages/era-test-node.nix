{
  config,
  lib,
  pkgs,
  craneLib,
  fenix,
  ...
}: let
  # boojum wants nightly - 2024-07-19 is known working
  rust =
    (fenix.packages.fromToolchainName {
      name = "nightly-2024-07-19";
      sha256 = "sha256-MM2K43Kg+f83XQXT2lI7W/ZdQjLXhMUvA6eGtD+rqDY=";
    })
    .minimalToolchain;
  crane = craneLib.overrideToolchain rust;
  src = pkgs.fetchFromGitHub {
    owner = "matter-labs";
    repo = "era-test-node";
    rev = "ceee937055a5a373e27b0ff9bf2e42391de78c59";
    sha256 = "sha256-6hzGdEEHI74gScO6dd4R5qsCGZxPpAuXKK9WVpNQDGM=";
  };
in
  crane.buildPackage {
    inherit src;
    buildInputs = with pkgs; [cmake pkg-config perl openssl clang] ++ lib.optionals pkgs.stdenv.isDarwin (with pkgs.darwin; [libiconv apple_sdk.frameworks.SystemConfiguration]);
  }
