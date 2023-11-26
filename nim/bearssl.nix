{ lib, buildNimPackage, fetchFromGitHub, unittest2 }:

buildNimPackage {
  pname = "bearssl";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "status-im";
    repo = "nim-bearssl";
    rev = "99fcb3405c55b27cfffbf60f5368c55da7346f23";
    sha1 = "sha1-ykipHUtds4HgAIgQl5oW9QsQhdM=";
  };

  doCheck = false;
  checkInputs = [ unittest2 ];
}
