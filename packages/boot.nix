{
  lib,
  pkgs,
  nix-gitignore,
  ...
}: let
  boot-src = pkgs.fetchgit {
    url = "https://github.com/boot-clj/boot";
    sha256 = "sha256-CRLtk3IXxeiWW2b76glh54D15qlPDWraaM6n1lAJTiI=";
  };

  # Boot version - could be retrieved by src tbh
  boot_version = "2.8.3";
  version = "${boot_version}-1";

  boot-jar = pkgs.stdenv.mkDerivation {
    inherit version;
    name = "boot-jar";

    src = boot-src;
    patches = [
      ./patches/boot-no-home-install.patch
      ./patches/boot-make-default.patch
      ./patches/boot-update-target-version.patch
      ./patches/boot-maven-assembly-goal.patch
    ];

    # Setup a local repo - ideally we could cache these deps
    preConfigure = ''
      export HOME=$PWD
      export LOCAL_REPO="$HOME/.m2"
      export _JAVA_OPTIONS="-Duser.home=$HOME,-Dmavem.repo.local=$LOCAL_REPO"

      # Configure lein to use the local repo with all the deps
      export LEIN_HOME=$HOME/.lein
      mkdir -p $LEIN_HOME

      echo "{:user {:local-repo \"$LOCAL_REPO\"}}" > $LEIN_HOME/profiles.clj
    '';

    nativeBuildInputs = [pkgs.leiningen pkgs.maven];

    # Copy over the boot uberjar and the aether dep
    installPhase = ''
      mkdir -p $out/{bin,lib}

      cp boot/base/src/main/resources/aether.uber.jar $out/lib/aether.uber.jar
      cp boot/base/target/base-${boot_version}-jar-with-dependencies.jar $out/bin/boot.jar
    '';
  };

  # Script to setup $BOOT_HOME (if not already existing)
  # and install our jars
  setup_boot_home = ''
    # Set BOOT_HOME to $HOME/.boot if not already set
    if [ -z "$BOOT_HOME" ]; then
      export BOOT_HOME="$HOME/.boot"
    fi

    # Prepare boot.properties file
    if  [ -n "$FORCE_BOOT_INSTALL" ] || [ ! -f "$BOOT_HOME/boot.properties" ]; then
      mkdir -p $BOOT_HOME
      echo "BOOT_VERSION=${boot_version}" >> $BOOT_HOME/boot.properties
    fi

    # Copy boot uberjar and aether dep
    if  [ -n "$FORCE_BOOT_INSTALL" ] || [ ! -f "$BOOT_HOME/cache/lib/${boot_version}/aether.uber.jar" ]; then
      mkdir -p $BOOT_HOME/cache/lib/${boot_version}
      cp ${boot-jar}/lib/aether.uber.jar $BOOT_HOME/cache/lib/${boot_version}/aether.uber.jar
    fi

    if  [ -n "$FORCE_BOOT_INSTALL" ] || [ ! -f "$BOOT_HOME/cache/bin/${boot_version}/boot.jar" ]; then
      mkdir -p $BOOT_HOME/cache/bin/${boot_version}
      cp ${boot-jar}/bin/boot.jar $BOOT_HOME/cache/bin/${boot_version}/boot.jar
    fi
  '';

  # Wrap boot to setup $BOOT_HOME with our jars
  boot = pkgs.stdenv.mkDerivation {
    inherit version;
    name = "boot";

    src = boot-jar;

    buildInputs = [boot-jar];
    nativeBuildInputs = [pkgs.makeWrapper];

    installPhase = ''
      mkdir -p $out/bin

      # Wrap the boot binary so that its $BOOT_HOME points
      # to our prepared location
      makeWrapper ${pkgs.boot}/bin/boot $out/bin/boot \
        --run '${setup_boot_home}'
    '';
  };
in
  boot
