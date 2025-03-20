{
  lib,
  pkgs,
  package,
  dockerTools ? pkgs.dockerTools,
  lastModifiedDate,
  dockerConfig ? {Cmd = ["${package}/bin/${package.pname}"];},
  ...
}:
dockerTools.buildLayeredImage {
  name = package.pname;
  contents = [package];

  compressor = "zstd";
  config = dockerConfig;
  tag = package.version;
  created = builtins.substring 0 8 lastModifiedDate;
}
