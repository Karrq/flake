{ lib, buildNimPackage, fetchFromGitHub, stew, faststreams, unittest2 }:

buildNimPackage {
  pname = "serialization";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "status-im";
    repo = "nim-serialization";
    rev = "543b2f3dd0724f7cf631feba6c2a3ec438f3d230";
    sha256 = "sha256-DYmN/JW0qbMuo/N5x4XufU+JK6h5Iz/cbeuyGgcPTUc=";
  };

  doCheck = false;
  propagatedBuildInputs = [ stew faststreams ];
  checkInputs = [ unittest2 ];
}
