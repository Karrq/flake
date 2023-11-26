{ lib, buildNimPackage, fetchFromGitHub }:
buildNimPackage {
  pname = "results";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "arnetheduck";
    repo = "nim-results";
    rev = "f3c666a272c69d70cb41e7245e7f6844797303ad";
    sha256 = "sha256-x8EJ2GX5IDqTKz/c4EgXPAuPEqkrS09A6MtlrnXKiVk=";
  };

}
