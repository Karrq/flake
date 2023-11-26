{ lib, buildNimPackage, fetchFromGitHub }:
let
  unittest2 = buildNimPackage {
    pname = "unittest2";
    version = "0.5.0";

    src = fetchFromGitHub {
      owner = "status-im";
      repo = "nim-testutils";
      rev = "dfc4c1b39f9ded9baf6365014de2b4bfb4dafc34";
      sha1 = "sha1-INAsDSW9cL8dJ2kyAoOcYO5Fvk8=";
    };

    doCheck = false;
  };
in unittest2
