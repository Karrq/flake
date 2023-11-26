{ lib, buildNimPackage, fetchFromGitHub }:

buildNimPackage {
  pname = "asynctools";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "cheatfate";
    repo = "asynctools";
    rev = "a1a17d06713727d97810cad291e29dd7c672738f";
    sha256 = lib.fakeSha256;
  };
}
