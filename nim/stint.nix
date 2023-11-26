{ lib, buildNimPackage, fetchFromGitHub, stew, ttmath }:

buildNimPackage {
  pname = "stint";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "status-im";
    repo = "nim-stint";
    rev = "c0ae9e10a9238883d18226fa28a5435c4d305e45";
    sha1 = "sha1-u+GRwIBwlFAXBc/KsSUvO+hR5s4=";
  };

  doCheck = false;
  propagatedBuildInputs = [ stew ttmath ];
}
