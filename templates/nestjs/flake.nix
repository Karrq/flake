{
  description = "NestJS Template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    pnpm2nix = {
      url = "github:nzbr/pnpm2nix-nzbr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-filter.url = "github:numtide/nix-filter";
  };

  outputs = inputs @ {
    self,
    flake-parts,
    nixpkgs,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} ({withSystem, ...}: {
      systems = ["aarch64-darwin" "x86_64-darwin" "aarch64-linux" "x86_64-linux"];
      perSystem = {
        config,
        self',
        inputs',
        system,
        pkgs,
        ...
      }: let
        dockerized =
          if pkgs.stdenv.isDarwin
          then self.packages."${builtins.replaceStrings ["darwin"] ["linux"] system}".docker
          else
            # only build docker in linux since macos's containes are linux
            pkgs.callPackage ./dockerize.nix {
              lastModifiedDate = self.lastModifiedDate;
              app = config.packages.app;
            };
        appDev = config.packages.default.overrideAttrs (_: _: {noDevDependencies = false;});
        shell = pkgs.mkShell {
          inputsFrom = [appDev];
          shellHook = ''
            if [[ ! -f pnpm-lock.yaml || ! -d node_modules ]]; then
              echo "Setting up environment..."
              pnpm install
            fi
            export PATH="$PWD/node_modules/.bin:$PATH"
          '';
        };
      in {
        packages.default = config.packages.app;
        packages.app = pkgs.callPackage ./app.nix {
          nix-filter = inputs.nix-filter.lib;
          mkPnpmPackage = inputs'.pnpm2nix.packages.mkPnpmPackage;
        };
        packages.docker = dockerized;
        devShells.default = shell;
      };
    });
}
