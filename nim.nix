{ pkgs, nim2 ? pkgs.nim2, nim-unwrapped-2 ? pkgs.nim-unwrapped-2
, nim2Packages ? pkgs.nim2Packages, buildPackages ? pkgs.buildPackages
, openssl ? pkgs.openssl, fetchFromGitHub ? pkgs.fetchFromGitHub }:
let
  nim-with-checksums = nim-unwrapped-2.overrideAttrs (prev: {
    postInstall = ''
      mkdir -p $out/nim/dist/checksums/
      cp -rp dist/checksums/* $out/nim/dist/checksums/
    '';
  });
  wrapped-nim2 = nim2.override {
    buildPackages = buildPackages // { nim-unwrapped-2 = nim-with-checksums; };
  };

  add-openssl = (prev: {
    buildInputs = (if prev ? buildInputs then prev.buildInputs else [ ])
      ++ [ openssl ];
  });

in {
  nim2 = wrapped-nim2;
  nim2Packages = nim2Packages.overrideScope (final: prev: {
    nim = wrapped-nim2;
    nimble = prev.nimble.overrideAttrs add-openssl;
    stew = prev.stew.overrideAttrs (prev: {
      src = fetchFromGitHub {
        owner = "status-im";
        repo = "nim-stew";
        rev = "2c2544aec13536304438be045bfdd22452741466";
        sha256 = "sha256-OHtu+9FvpbWbJRi4znG4svLE5eLctFWDmWdJZPFYrK4=";
      };

      propagatedBuildInputs = [ final.results ];
    });
    nim_with = final.callPackage ./nim/with.nix { };
    faststreams = final.callPackage ./nim/faststreams.nix { };
    asynctools = final.callPackage ./nim/asynctools.nix { };
    chronicles = final.callPackage ./nim/chronicles.nix { };
    stint = final.callPackage ./nim/stint.nix { };
    chronos = final.callPackage ./nim/chronos.nix { };
    json_rpc = final.callPackage ./nim/json_rpc.nix { };
    json_serialization = final.callPackage ./nim/json_serialization.nix { };
    nimlangserver = final.callPackage ./nim/nimlangserver.nix { };
    bearssl = final.callPackage ./nim/bearssl.nix { };
    httputils = final.callPackage ./nim/httputils.nix { };
    unittest2 = final.callPackage ./nim/unittest2.nix { };
    websock = final.callPackage ./nim/websock.nix { };
    nim-zlib = final.callPackage ./nim/zlib.nix { };
    ttmath = final.callPackage ./nim/ttmath.nix { };
    serialization = final.callPackage ./nim/serialization.nix { };
    results = final.callPackage ./nim/results.nix { };
  });
}
