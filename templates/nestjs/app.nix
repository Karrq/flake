{ lib, pkgs, mkPnpmPackage, nodejs ? pkgs.nodePackages_latest.nodejs, nix-filter
, ... }:
(mkPnpmPackage {
  src = nix-filter {
    root = ./.;
    include = [
      (nix-filter.inDirectory "src")
      "nest-cli.json"
      "package.json"
      "pnpm-lock.yaml"
      "tsconfig.json"
      "tsconfig.build.json"
      "webpack.config.js"
    ];
  };
  inherit nodejs;
}).overrideAttrs (_: prev:
  let
    split = builtins.split "-" prev.name;
    reverse = list:
      if list == [ ] then
        [ ]
      else
        let
          h = builtins.head list;
          hh = builtins.tail list;
        in (reverse hh) ++ [ h ];
    reversed = reverse (builtins.filter builtins.isString split);
    version = builtins.elemAt reversed 0;
    pname = builtins.concatStringsSep "-" (reverse (builtins.tail reversed));
  in { inherit pname version; })
