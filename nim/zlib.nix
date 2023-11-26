{ lib, buildNimPackage, fetchFromGitHub, stew }:

buildNimPackage {
  pname = "zlib";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "status-im";
    repo = "nim-zlib";
    rev = "f34ca261efd90f118dc1647beefd2f7a69b05d93";
    sha256 = "sha256-hD8BHNSueHltVvy4MrZpH9mHxDTTw5up2lma+7G6bY0=";
    fetchSubmodules = true;
  };

  propagatedBuildInputs = [ stew ];
}
