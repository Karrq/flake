{ lib, buildNimPackage, fetchFromGitHub, stew, unittest2 }:

buildNimPackage {
  pname = "httputils";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "status-im";
    repo = "nim-http-utils";
    rev = "3b491a40c60aad9e8d3407443f46f62511e63b18";
    sha1 = "sha1-SFl0ANMz3lGn91xlZ+0UExugylg=";
  };

  doCheck = false;

  checkInputs = [ unittest2 ];
  propagatedBuildInputs = [ stew ];
}
