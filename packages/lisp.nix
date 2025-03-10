{ pkgs, lisp ? pkgs.sbcl, sources ? import ../nix/sources.nix, ... }:
let
  lispPackages = lisp.packages;
  lispDerivation = lispPackages.mkDerivation;
  lispName = lisp.pname;
in rec {
  cl-reexport = lispDerivation rec {
    pname = "cl-reexport";
    systems = [ "cl-reexport" ];
    asdfSystemNames = systems;
    lispLibs = [ lispPackages.alexandria ];
    propagatedBuildInputs = lispLibs;
    src = pkgs.lib.cleanSource sources.cl-reexport;
    version = sources.cl-reexport.version;
  };
  cl-bobbin = lispDerivation rec {
    pname = "bobbin";
    systems = [ "bobbin" ];
    asdfSystemNames = systems;
    lispLibs = [ lispPackages.split-sequence ];
    propagatedBuildInputs = lispLibs;
    src = pkgs.lib.cleanSource sources.cl-bobbin;
    version = sources.cl-bobbin.version;
  };
  cl-clingon = lispDerivation rec {
    pname = "clingon";
    systems = [ "clingon" ];
    asdfSystemNames = systems;
    lispLibs =
      [ cl-bobbin cl-reexport lispPackages.split-sequence cl-with-user-abort ];
    propagatedBuildInputs = lispLibs;
    src = pkgs.lib.cleanSource sources.cl-clingon;
    version = sources.cl-clingon.version;
  };
  cl-lisp-invocation = lispDerivation rec {
    pname = "lisp-invocation";
    systems = [ "lisp-invocation" ];
    asdfSystemNames = systems;
    src = pkgs.lib.cleanSource sources.cl-lisp-invocation;
    version = sources.cl-lisp-invocation.version;
  };
  cl-with-user-abort = lispDerivation rec {
    pname = "with-user-abort";
    systems = [ "with-user-abort" ];
    asdfSystemNames = systems;
    src = pkgs.lib.cleanSource sources.cl-with-user-abort;
    version = sources.cl-with-user-abort.version;
  };
  cl-shlex = lispDerivation rec {
    pname = "shlex";
    systems = [ "shlex" ];
    asdfSystemNames = systems;
    lispLibs = with lispPackages; [ alexandria serapeum cl-ppcre cl-unicode ];
    propagatedBuildInputs = lispLibs;
    src = pkgs.lib.cleanSource sources.cl-shlex;
    version = sources.cl-shlex.version;
  };
  cl-cmd = lispDerivation rec {
    pname = "cmd";
    systems = [ "cmd" ];
    asdfSystemNames = systems;
    lispLibs = with lispPackages; [ trivia cl-shlex trivial-garbage ];
    propagatedBuildInputs = lispLibs;
    src = pkgs.lib.cleanSource sources.cl-cmd;
    version = sources.cl-cmd.version;
  };
  cl-kiln = lispDerivation rec {
    pname = "kiln";
    systems = [ "kiln/build" ];
    asdfSystemNames = systems;
    lispLibs = with lispPackages; [
      drakma
      cl-strftime
      cffi
      alexandria
      serapeum
      named-readtables
      cl-cmd
      cl-ppcre
      cl-interpol
      iterate
      lispPackages."trivia-ppcre"
      trivia
      trivial-types
      cl-with-user-abort
      cl-lisp-invocation
      cl-clingon
    ];
    propagatedBuildInputs = lispLibs;
    src = pkgs.lib.cleanSource sources.cl-kiln;
    version = sources.cl-kiln.version;
    patches = [
      ./patches/kiln-rm-utils-orange.patch
      ./patches/kiln-no-ql.patch
      ./patches/kiln-build-op-no-prefix.patch
      ./patches/kiln-build-depend-on-dispatch.patch
    ];
    preBuild = ''
      mkdir -p $out/bin/kiln || exit 1
    '';
    postInstall = ''
      pushd $out/bin
      mv -T kiln/build kiln-bin
      rm -r kiln
      mv kiln-bin kiln
    '';
  };
}
