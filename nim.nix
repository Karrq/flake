{ pkgs, nim2 ? pkgs.nim2, nim-unwrapped-2 ? pkgs.nim-unwrapped-2
, nim2Packages ? pkgs.nim2Packages, buildPackages ? pkgs.buildPackages
, openssl ? pkgs.openssl }:
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

in nim2Packages.overrideScope (final: prev: {
  nim = wrapped-nim2;
  nimble = final.nimble.overrideAttrs add-openssl;
})
