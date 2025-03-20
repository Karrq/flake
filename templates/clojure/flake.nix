{
  description = "A Nix-flake-based Clojure development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    flake-parts.url = "github:hercules-ci/flake-parts";

    clj-nix = {
      url = "github:jlesquembre/clj-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    flake-parts,
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
        lib,
        ...
      }: let
        clj-nix =
          lib.concatMapAttrs (name: value: {
            ${name} =
              if lib.isFunction value
              then lib.makeOverridable value
              else value;
          })
          inputs'.clj-nix.packages;

        withDeps = pkgs.callPackage ./nix/withDeps.nix {inherit clj-nix;};
        appDev = withDeps {} config.packages.default;

        dockerized =
          if pkgs.stdenv.isDarwin
          then
            self
            .packages
            ."${builtins.replaceStrings ["darwin"] ["linux"]
              system}"
            .docker
          else
            # only build docker in linux since macos's containes are linux
            pkgs.callPackage ./nix/dockerize.nix rec {
              lastModifiedDate = self.lastModifiedDate;
              package = appDev;
              dockerConfig = {Cmd = ["${package}/bin/${package.pname}"];};
            };
      in {
        devShells.default = pkgs.mkShell {
          inputsFrom = [appDev];
          shellHook = ''
            if [[ ! -f deps-lock.json ]]; then
              echo "Setting up environment..."
              args=$''${CLJNIX_DEPS_LOCK_ARGS:-""}
              ${clj-nix.deps-lock}/bin/deps-lock $args
            fi
          '';
        };

        packages.default = clj-nix.mkCljBin {
          projectSrc = ./.;
          name = "hello";
          main-ns = "hello.core";
        };
        packages.docker = dockerized;
      };
    });
}
