{ lib, buildNimPackage, fetchFromGitHub }:

buildNimPackage {
  pname = "with";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "zevv";
    repo = "with";
    rev = "2f95909c767605e06670dc70f5cffd6b9284f192";
    sha1 = "sha1-8FOVuRSXuioOdP3bWfLNujlqIeo=";
  };
}
