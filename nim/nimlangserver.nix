{ lib, buildNimPackage, fetchFromGitHub, asynctools, json_rpc, faststreams
, nim_with, chronicles }:
let
  fork_asynctools = asynctools.overrideAttrs (prev: {
    version = "0.1.1";
    src = fetchFromGitHub {
      owner = "yyoncho";
      repo = "asynctools";
      rev = "f1ad7289ff38f3b1c1987307845de373fc9af499";
      sha1 = "sha1-dFQkRmmVMCQNFndsaiy+fLSx9f4=";
    };
  });

  fork_json_rpc = json_rpc.overrideAttrs (prev: {
    version = "0.0.2";
    src = fetchFromGitHub {
      owner = "yyoncho";
      repo = "nim-json-rpc";
      rev = "c8a5cbe26917e6716b1597dae2d08166f3ce789a";
      sha1 = "sha1-sUaWs3YyhZDYwu4R7SgpdPoAYvM=";
    };
  });
in buildNimPackage {
  pname = "nimlangserver";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "85c1b32fc1fb28552cc45f5cf8ca005ae345e1e9";
    sha256 = "sha256-nZ2iGFjczpt9+4uE/3y6SGyjMoQgSsF+dGJ/8XIjs/0=";
  };

  doCheck = false;
  propagatedBuildInputs =
    [ fork_asynctools fork_json_rpc faststreams nim_with chronicles ];
}
