{
  pkgs,
  lib,
}: let
  src = pkgs.fetchgit {
    url = "https://github.com/sst/opencode";
    rev = "refs/heads/dev";
    sha256 = "sha256-S3rrqS03VeNuilKyFo8vP4CyqNBSZjVBbjARZtNe6yo=";
  };
  
  # Since we're building from dev branch, use dev version
  # Release versions come from git tags (e.g., v0.2.33)
  version = "dev";
  # Build the Go TUI component
  tuiComponent = pkgs.buildGoModule {
    pname = "opencode-tui";
    inherit version;
    src = pkgs.runCommand "tui-source" {} ''
      cp -r ${src}/packages/tui $out
    '';
    vendorHash = "sha256-0vf4fOk32BLF9/904W8g+5m0vpe6i6tUFRXqDHVcMIQ=";

    subPackages = ["cmd/opencode"];

    buildPhase = ''
      runHook preBuild
      go build -ldflags="-s -w -X main.Version=${version}" -o opencode-tui ./cmd/opencode/main.go
      runHook postBuild
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp opencode-tui $out/bin/
    '';
  };

  # Node modules derivation
  nodeModules = pkgs.stdenv.mkDerivation {
    pname = "opencode-node-modules";
    inherit version src;
    nativeBuildInputs = [pkgs.bun];
    
    buildPhase = ''
      # Set up temporary directories
      export HOME=$TMPDIR
      export npm_config_cache=$TMPDIR/.npm
      export XDG_CACHE_HOME=$TMPDIR/.cache
      mkdir -p $TMPDIR/.npm $TMPDIR/.cache

      # Install dependencies
      bun install
    '';

    installPhase = ''
      mkdir -p $out
      cp -rL node_modules $out/ || cp -r node_modules $out/
      cp package.json bun.lock $out/
    '';
  };
in
  pkgs.stdenv.mkDerivation rec {
    pname = "opencode";
    inherit version src;

    nativeBuildInputs = with pkgs; [
      bun
      git
    ];

    # Environment variables for build
    CGO_ENABLED = "0";

    # Map Nix system to Go/Bun architectures
    GOOS =
      if pkgs.stdenv.isDarwin
      then "darwin"
      else "linux";
    GOARCH =
      if pkgs.stdenv.isAarch64
      then "arm64"
      else "amd64";
    BUN_TARGET = "bun-${GOOS}-${
      if pkgs.stdenv.isAarch64
      then "arm64"
      else "x64"
    }";

    buildPhase = ''
      runHook preBuild

      # Set up Node modules
      ln -sf ${nodeModules}/node_modules ./node_modules

      # Copy the pre-built TUI binary
      cp ${tuiComponent}/bin/opencode-tui packages/opencode/tui-binary

      # Build the TypeScript CLI with embedded TUI
      cd packages/opencode
      bun build --define OPENCODE_VERSION="'${version}'" \
        --compile --minify --target=$BUN_TARGET \
        --outfile=opencode-binary ./src/index.ts ./tui-binary

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      cp packages/opencode/opencode-binary $out/bin/opencode || cp opencode-binary $out/bin/opencode
      chmod +x $out/bin/opencode

      runHook postInstall
    '';

    meta = with lib; {
      description = "The AI coding agent built for the terminal";
      homepage = "https://github.com/sst/opencode";
      license = licenses.mit;
      platforms = platforms.unix;
      maintainers = [];
    };
  }
