{
  pkgs,
  clj-nix,
  ...
}: {
  deps ? (src: src + /deps.edn),
  deps-lock-args ? [""],
}: package: let
  deps-lock = prev:
    pkgs.stdenv.mkDerivation {
      name = "${prev.name}-deps-lock";

      nativeBuildInputs = [pkgs.git pkgs.clojure clj-nix.deps-lock];

      src = deps prev.projectSrc;
      dontUnpack = true;
      buildPhase = ''
        args=${builtins.concatStringsSep "," deps-lock-args}
        ${clj-nix.deps-lock}/bin/deps-lock $args
      '';

      installPhase = ''
        mkdir -p $out
        cp deps-lock.json $out/deps-lock.json
      '';
    };
  withDepsOverride = prev: {lockfile = (deps-lock prev) + /deps-lock.json;};
in
  package.override withDepsOverride
