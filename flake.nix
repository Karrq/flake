{
  description = "My collection of nix things";

  inputs = {
    nixpkgs.url = "github:/NixOS/nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";

    # Common Lisp
    clnix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "sourcehut:~remexre/clnix";
    };

    # Rust
    crane.url = "github:ipetkov/crane";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-analyzer-src.follows = "";
    };

    services-flake.url = "github:juspay/services-flake";

    # Packages
    rust-docs-mcp = {
      url = "github:snowmead/rust-docs-mcp";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.crane.follows = "crane";
      inputs.fenix.follows = "fenix";
    };
  };

  outputs = inputs @ {
    self,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
      imports = [inputs.flake-parts.flakeModules.easyOverlay];

      flake.processComposeModules.default = import ./services {
        multiService = inputs.services-flake.lib.multiService;
      };
      flake.templates = {
        nestjs = {
          path = ./templates/nestjs;
          description = "Nix NestJS template w/ pnpm and docker";
        };

        clojure = {
          path = ./templates/clojure;
          description = "Nix Clojure template w/ Clojure CLI & clj-nix";
        };
      };

      perSystem = {
        system,
        config,
        inputs',
        pkgs,
        ...
      }: let
        lispPackages = pkgs.callPackage ./packages/lisp.nix {
          lisp = inputs'.clnix.packages.sbcl;
        };
        mcpPackages = {
          rust-docs-mcp = pkgs.callPackage ./packages/mcp/rust-docs.nix {
            fenix = inputs'.fenix.packages;
            rust-docs-mcp = inputs'.rust-docs-mcp;
          };
        };
      in {
        packages = {
          inherit (lispPackages) cl-kiln;
          inherit
            (pkgs.callPackage ./packages/boot.nix {})
            boot
            boot-unwrapped
            ;

          inherit (mcpPackages) rust-docs-mcp;

          anvil-zksync = pkgs.callPackage ./packages/anvil-zksync.nix {};
          aider-chat = pkgs.callPackage ./packages/aider-chat.nix {};
        };

        devShells.default = pkgs.mkShell {packages = [pkgs.niv];};

        overlayAttrs = {
          inherit (config.packages) anvil-zksync boot cl-kiln aider-chat rust-docs-mcp;
        };
      };
    };
}
