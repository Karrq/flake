{ lib, buildNimPackage, fetchFromGitHub, stew, chronos, httputils, chronicles
, nimcrypto, bearssl, nim-zlib }:

buildNimPackage {
  pname = "websock";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "status-im";
    repo = "nim-websock";
    rev = "2c3ae3137f3c9cb48134285bd4a47186fa51f0e8";
    sha1 = "sha1-43akD2WbVWF8OLOkwP0c8LW80QU=";
  };

  doCheck = false;
  propagatedBuildInputs =
    [ stew chronos httputils chronicles nimcrypto bearssl nim-zlib ];
}
