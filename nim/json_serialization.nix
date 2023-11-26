{ lib, buildNimPackage, fetchFromGitHub, faststreams, serialization, unittest2
}:

buildNimPackage {
  pname = "json_serialization";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "status-im";
    repo = "nim-json-serialization";
    rev = "b068e1440d4cb2cf3ede6b3567eaaeecd6c8c96a";
    sha256 = "sha256-adgf0t4uAQm9PLbZZm+V7uAlOuV3ibMFNP2SmYCwoxk=";
  };

  doCheck = false;
  propagatedBuildInputs = [ faststreams serialization ];
  checkInputs = [ unittest2 serialization ];
}
