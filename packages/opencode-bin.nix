{
  pkgs,
  lib,
  version ? "0.3.17",
  system ? builtins.currentSystem,
  extraAssets ? {}, # allow adding versions and hashes
}: let
  # Mapping from version to per-platform asset info (fill in hashes!)
  assets =
    {
      "0.2.27" = {
        "x86_64-linux" = {
          name = "opencode-linux-x64.zip";
          sha256 = lib.fakeSha256;
        };
        "aarch64-linux" = {
          name = "opencode-linux-arm64.zip";
          sha256 = lib.fakeSha256;
        };
        "x86_64-darwin" = {
          name = "opencode-darwin-x64.zip";
          sha256 = lib.fakeSha256;
        };
        "aarch64-darwin" = {
          name = "opencode-darwin-arm64.zip";
          sha256 = "sha256-hbR3TEQlyZaCR8hSRnENRAz9xxnNh/aoJRxmC+gc738=";
        };
      };
      "0.3.17" = {
        "aarch64-darwin" = {
          name = "opencode-darwin-arm64.zip";
          sha256 = "sha256-CShs2zW8sZqyBW2MXNR8RXfL0rfPsdeHJf6oc8ZEeHc=";
        };
      };
    }
    // extraAssets;

  platformAssets =
    assets.${version} or (throw "Unsupported version: ${version}");

  asset =
    platformAssets.${system} or (throw "Unsupported system for version ${version}: ${system}");
  url = "https://github.com/sst/opencode/releases/download/v${version}/${asset.name}";
in
  pkgs.stdenv.mkDerivation {
    pname = "opencode";
    inherit version;

    src = pkgs.fetchurl {
      inherit url;
      sha256 = asset.sha256;
    };
    dontUnpack = true;

    buildInputs = [];
    nativeBuildInputs = [pkgs.unzip];

    installPhase = ''
      mkdir -p $out/bin
      unzip -j $src
      # Adjust if more files in archive
      cp opencode $out/bin/
    '';

    meta = {
      mainProgram = "opencode";
      description = "OpenCode: AI coding agent for the terminal";
      homepage = "https://github.com/sst/opencode";
    };
  }
