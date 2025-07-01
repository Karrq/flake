{
  pkgs,
  lib,
}:
pkgs.stdenv.mkDerivation rec {
  pname = "bigparse";
  version = "1.0.1";

  src = pkgs.fetchFromGitHub {
    owner = "agentbrazley";
    repo = "bigparse";
    rev = "v${version}";
    sha256 = "sha256-/GHuBQvJmPXEtoZbujyTOaYSiMUogrOoK6iNjxkjsDo=";
  };

  nativeBuildInputs = [pkgs.nodejs pkgs.yarn pkgs.makeWrapper];

  buildPhase = ''
    yarn install --frozen-lockfile || npm install
    yarn build || npm run build
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r dist $out/
    cp -r node_modules $out/
    makeWrapper ${pkgs.nodejs}/bin/node $out/bin/bigparse \
      --add-flags "$out/dist/index.js" \
      --set NODE_PATH "$out/node_modules"
  '';

  meta = with lib; {
    description = "MCP server that gives Claude intelligent access to your codebase";
    license = licenses.mit;
    platforms = platforms.unix;
    homepage = "https://github.com/agentbrazley/bigparse";
  };
}
