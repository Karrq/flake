{ pkgs, clj-nix, ... }:
let
  withDeps = deps: package:
    let
      deps-lock = pkgs.stdenv.mkDerivation {
        name = "${package.name}-deps-lock";

        nativeBuildInputs = [ pkgs.git pkgs.clojure clj-nix.deps-lock ];

        src = deps;
        dontUnpack = true;
        buildPhase = ''
          args=$''${CLJNIX_DEPS_LOCK_ARGS:-""}
          ${clj-nix.deps-lock}/bin/deps-lock $args
        '';

        installPhase = ''
          mkdir -p $out
          cp deps-lock.json $out/deps-lock.json
        '';
      };
    in clj-nix.mkCljBin
    (package // { lockfile = deps-lock + /deps-lock.json; });
in withDeps
