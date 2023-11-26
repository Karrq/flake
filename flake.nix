{
  description = "Packages made by and for Karrq";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      imports = [ inputs.flake-parts.flakeModules.easyOverlay ];
      perSystem = { self', inputs', pkgs, ... }:
        let
          java8 = pkgs.callPackage ./java8.nix;
          nim2-with-checksums = pkgs.callPackage ./nim.nix { inherit pkgs; };
          monaspace = pkgs.callPackage ./monaspace.nix { inherit pkgs; };

          nixGLWrap = (p:
            pkgs.writeShellScriptBin p.name ''
              ${inputs'.nixgl.packages.default} ${p.out} "$@"
            '');
        in {
          packages.java8u232 = java8 {
            inherit pkgs;
            update = "232";
            build = "b09";
            sha256 = "sha256-hh01uzkzhdCX6f53oQut2tfoKTnZvWBsORWLLiXewSY=";
          };

          packages.prismlauncher = nixGLWrap pkgs.prismlauncher;

          packages.nim2 = nim2-with-checksums.nim2;
          packages.nimlangserver =
            nim2-with-checksums.nim2Packages.nimlangserver;

          packages.monaspace = monaspace;

          overlayAttrs = {
            inherit (nim2-with-checksums) nim2 nim2Packages;
            inherit (self'.packages) prismlauncher java8u232 monaspace;
          };
        };
    };
}
