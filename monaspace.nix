{ pkgs, fetchurl ? pkgs.fetchurl, stdenvNoCC ? pkgs.stdenvNoCC
, unzip ? pkgs.unzip }:
stdenvNoCC.mkDerivation rec {
  name = "monaspace";
  version = "v1.000";

  src = fetchurl {
    url =
      "https://github.com/githubnext/${name}/releases/download/${version}/monaspace-${version}.zip";
    hash = "sha256-Pgg3b9Cuyh+FH94MCOGMoteX9qTHpElnC/TRJwMDyPY=";
  };

  nativeBuildInputs = [ unzip ];

  dontInstall = true;

  unpackPhase = ''
    mkdir -p $out/share/fonts
    unzip -j $src "${name}-${version}/fonts/otf/*" -d $out/share/fonts/otf
    unzip -j $src "${name}-${version}/fonts/variable/*" -d $out/share/fonts/variable
    unzip -j $src "${name}-${version}/fonts/webfonts/*" -d $out/share/fonts/webfonts
  '';
}
