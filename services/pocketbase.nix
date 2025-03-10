{ pkgs, lib, config, name, ... }:
let inherit (lib) types;
in {
  options = {
    package = lib.mkPackageOption pkgs "pocketbase" { };

    migrationsDir = lib.mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "The directory with the user defined migrations";
    };

    encryptionEnv = lib.mkOption {
      type = types.nullOr types.str;
      default = null;
      description =
        "ENV variable whose value of 32 chatacters will be used as encryption key for the app settings";
      example = "ENCRYPTION_KEY";
    };

    port = lib.mkOption {
      type = types.port;
      default = 8090;
      description = "The port on which the PocketBase service will listen";
    };
    host = lib.mkOption {
      type = types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
      description = "The host on which the PocketBase service will listen";
    };

    https = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Start PocketBase service in https";
    };

    environment = lib.mkOption {
      type = types.attrsOf types.str;
      default = { };
      example = { ENCRYPTION_KEY = "<not a valid encryption key>"; };
      description = ''
        Extra environment variables passed to the `pocketbase` process.
      '';
    };

    _args = lib.mkOption {
      type = types.listOf types.str;
      description = "Extra arguments to pass to the pocketbase serve command";
      default = [ ];
    };
  };

  config.outputs.settings.processes."${name}" = let
    migrationsDir = builtins.toString config.migrationsDir;
    encryptionEnv = builtins.toString config.encryptionEnv;
    host = "${builtins.toString config.host}:${builtins.toString config.port}";
    scheme = if config.https then "https" else "http";
    serveScript = pkgs.writeShellApplication {
      excludeShellChecks = [ "SC2090" ];
      name = "pocketbase-server";
      text = ''
        DATA_OPT='--dir ${config.dataDir}/'

        MIGRATIONS_OPT=
        if [ -n "${migrationsDir}" ]; then
          echo "Creating directory to store migrations"
          mkdir -p ./migrations
          cp "${migrationsDir}" ./migrations
          MIGRATIONS_OPT="--migrationsDir ./migrations"
        fi

        ENCRYPTION_OPT=
        if [ -n "${encryptionEnv}" ]; then
          ENCRYPTION_OPT="--encryptionEnv ${encryptionEnv}"
        fi

        OPTS="$DATA_OPT $MIGRATIONS_OPT $ENCRYPTION_OPT"

        CMD="${lib.getExe config.package} serve $OPTS --${scheme} ${host} ${
          builtins.concatStringsSep " " config._args
        }"
        $CMD
      '';
    };
  in {
    command = serveScript;
    readiness_probe.http_get = {
      host = config.host;
      port = config.port;
      path = "/api/health";
      inherit scheme;
    };
    environment = config.environment;
    availability.restart = "on_failure";
  };
}
