{ lib, buildNimPackage, fetchFromGitHub }:

buildNimPackage {
  pname = "ttmath";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "Karrq";
    repo = "nim-ttmath";
    rev = "867677b23962a4fbd27b0dedfe5e5f5926da9457";
    sha256 = "sha256-oIUhN82s3x+GYN/lr7ewxNbM8ZGKtFWkBQ7CiaeeqtI=";
  };

  patches = [ ../patches/nim-ttmath-specify-backend.patch ];
}
