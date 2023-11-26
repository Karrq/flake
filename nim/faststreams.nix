{ lib, buildNimPackage, fetchFromGitHub, stew, unittest2, asynctools }:

buildNimPackage {
  pname = "faststreams";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "status-im";
    repo = "nim-faststreams";
    rev = "422971502bd641703bf78a27cb20429e77fcfb8b";
    sha1 = "sha1-H6SWMe85DL8VJz2W5twIP1w8+cU=";
  };

  doCheck = false;

  propagatedBuildInputs = [ stew ];
  checkInputs = [ unittest2 asynctools ];
}
