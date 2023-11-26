{ lib, buildNimPackage, fetchFromGitHub, stew, bearssl, httputils, unittest2 }:

buildNimPackage {
  pname = "chronos";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "status-im";
    repo = "nim-chronos";
    rev = "ba143e029f35fd9b4cd3d89d007cc834d0d5ba3c";
    sha1 = "sha1-WdJFDM/nwJNi4Eq7NhgEU1dic8A=";
  };

  doCheck = false;
  checkInputs = [ unittest2 ];
  propagatedBuildInputs = [ stew bearssl httputils ];
}
