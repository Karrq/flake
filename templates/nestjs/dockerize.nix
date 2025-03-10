{ lib, pkgs, app, nodejs ? pkgs.nodePackages_latest.nodejs
, dockerTools ? pkgs.dockerTools, lastModifiedDate, ... }:
dockerTools.buildLayeredImage {
  name = app.pname;
  contents = [ nodejs app ];

  compressor = "zstd";
  config = { Cmd = [ "node" "${app}/main.js" ]; };
  tag = app.version;
  created = builtins.substring 0 8 lastModifiedDate;
}
