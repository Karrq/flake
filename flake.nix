{
  description = "My collection of nix things";

  inputs = {
    nixpkgs.url = "github:/NixOS/nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";

    clnix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "sourcehut:~remexre/clnix";
    };
    services-flake.url = "github:juspay/services-flake";
  };

  outputs = inputs @ {
    self,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];

      flake.processComposeModules.default = import ./services {multiService = inputs.services-flake.lib.multiService;};
      flake.templates = {
        nestjs = {
          path = ./templates/nestjs;
          description = "Nix NestJS template w/ pnpm and docker";
        };
      };

      perSystem = {
        system,
        config,
        inputs',
        pkgs,
        ...
      }: let
        lispPackages = pkgs.callPackage ./packages/lisp.nix {lisp = inputs'.clnix.packages.sbcl;};
      in {
        packages = {inherit (lispPackages) cl-kiln;};

        devShells.default = pkgs.mkShell {
          packages = [pkgs.niv];
        };
      };
    };
}
