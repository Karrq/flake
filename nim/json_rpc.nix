{ lib, buildNimPackage, fetchFromGitHub, stew, nimcrypto, stint, chronos
, httputils, chronicles, websock, json_serialization, unittest2 }:

buildNimPackage {
  pname = "json_rpc";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "status-im";
    repo = "nim-json-rpc";
    rev = "f79be14c997092e29ba1edf706bb15a238fb37a5";
    sha256 = lib.fakeSha256;
  };

  doCheck = false;
  propagatedBuildInputs = [
    stew
    nimcrypto
    stint
    chronos
    httputils
    chronicles
    websock
    json_serialization
    unittest2
  ];
}
