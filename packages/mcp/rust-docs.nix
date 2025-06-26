# MCP Rust Docs - runtime wrapper derivation using upstream flake and fenix toolchain
# Usage: import with { pkgs, fenix, rust-docs-mcp } package set
{
  pkgs,
  fenix,
  rust-docs-mcp,
  ...
}: let
  mcpBin = rust-docs-mcp.packages.default;
  nightlyBin = fenix.fromToolchainName {
    name = "nightly-2025-06-23";
    sha256 = "sha256-UAoZcxg3iWtS+2n8TFNfANFt/GmkuOMDf7QAE0fRxeA=";
  };
in
  pkgs.runCommand "rust-docs-mcp" {
    nativeBuildInputs = [pkgs.makeWrapper];
  } ''
    mkdir -p $out/bin
    makeWrapper "${mcpBin}/bin/rust-docs-mcp" "$out/bin/rust-docs-mcp" \
      --prefix PATH : ${nightlyBin.toolchain}/bin
  ''
