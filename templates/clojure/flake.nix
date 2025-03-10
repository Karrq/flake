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

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } ({ ... }: {
      systems =
        [ "aarch64-darwin" "x86_64-darwin" "aarch64-linux" "x86_64-linux" ];

      perSystem = { self', inputs', pkgs, ... }:
        let
          clj-nix = inputs'.clj-nix;
          withDeps =
            pkgs.callPackage ./nix/withDeps.nix { clj-nix = clj-nix.packages; };
          projectArgs = {
            projectSrc = ./.;
            name = "hello";
            main-ns = "hello.core";
          };
        in {
          devShells.default = pkgs.mkShell {
            inputsFrom = [ (withDeps ./deps.edn projectArgs) ];
            shellHook = ''
              if [[ ! -f deps-lock.json ]]; then
                echo "Setting up environment..."
                args=$''${CLJNIX_DEPS_LOCK_ARGS:-""}
                ${clj-nix.packages.deps-lock}/bin/deps-lock $args
              fi
            '';
          };

          packages.default = clj-nix.packages.mkCljBin projectArgs;
        };
    });
}
