{
  pkgs,
  python3 ? pkgs.python312,
}: let
  src = pkgs.fetchFromGitHub {
    owner = "BeehiveInnovations";
    repo = "zen-mcp-server";
    rev = "0237fb3419a70214ec9ee51130d0685cc2f15b00";
    sha256 = "sha256-1aSlAru1p5UgRMO2X2YzLqtEiok1dUJwJNK1CWW/KT8=";
  };
  zen-mcp-deps = python3.withPackages (ps:
    with ps; [
      mcp
      google-genai
      openai
      pydantic
      python-dotenv
      # (Add more if needed)
    ]);
in
  pkgs.writeShellApplication {
    name = "zen-mcp";
    runtimeInputs = [zen-mcp-deps];
    text = ''
      exec ${zen-mcp-deps.interpreter} ${src}/server.py "$@"
    '';
  }
