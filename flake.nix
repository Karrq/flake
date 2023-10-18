{
  description = "Packages made by and for Karrq";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-darwin" ];
      perSystem = { self', inputs', pkgs, ... }:
        let
          callPackage = pkgs.lib.callPackageWith (self'.packages);
          java8 = callPackage ./java8.nix;
        in {
          packages.java8u232 = java8 {
            inherit pkgs;
            update = "232";
            build = "b09";
            sha256 = "sha256-hh01uzkzhdCX6f53oQut2tfoKTnZvWBsORWLLiXewSY=";
          };
        };
    };
}
