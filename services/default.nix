{multiService, ...}: {
  imports = builtins.map multiService [./pocketbase.nix];
}
