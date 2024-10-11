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
    rev = "v0.1.0-alpha.29";
    sha256 = "sha256-9O71E5P4WL75KiSLZlIv5w52gmQDByUI7LgGwmqDJ18=";
  };
in
  crane.buildPackage {
    inherit src;
    buildInputs = with pkgs; [cmake pkg-config perl openssl clang] ++ lib.optionals pkgs.stdenv.isDarwin (with pkgs.darwin; [libiconv apple_sdk.frameworks.SystemConfiguration]);
  }
