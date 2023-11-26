{ lib, buildNimPackage, fetchFromGitHub, json_serialization }:

buildNimPackage {
  pname = "chronicles";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "status-im";
    repo = "nim-chronicles";
    rev = "2a2681b60289aaf7895b7056f22616081eb1a882";
    sha1 = "sha1-87nKvN0MlCv8lg8aJtWBxbp9k1w=";
  };

  propagatedBuildInputs = [ json_serialization ];
}
