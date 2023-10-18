{ pkgs, update, build, sha256 ? pkgs.lib.fakeHash, headless ? false
, enableGnome2 ? true
, java8 ? pkgs.path + /. + "/pkgs/development/compilers/openjdk/8.nix" }:
let
  version = "8u${update}-${build}";
  src = pkgs.fetchFromGitHub {
    owner = "openjdk";
    repo = "jdk8u";
    rev = "jdk${version}";
    inherit sha256 version;
  };
  overrides = (prev: {
    inherit version src;
    buildInputs = prev.buildInputs ++ [ pkgs.sysctl ];
    patches = prev.patches ++ [
      # glibc 2.32 removed sys/sysctl.h
      ./patches/java8-remove-sysctl.patch
    ];
    NIX_LDFLAGS = toString ([ prev.NIX_LDFLAGS "-zmuldefs" ]);
  });
  package = with pkgs.gnome2;
    pkgs.callPackage java8 {
      inherit headless enableGnome2 GConf gnome_vfs glib;
    };
in package.overrideAttrs overrides
