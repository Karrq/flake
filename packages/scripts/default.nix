{pkgs}: {
  gh-thread-pr-comments = pkgs.writeShellScriptBin "gh-thread-pr-comments" ''
    exec ${pkgs.python3}/bin/python3 ${./gh_thread_pr_comments.py} "$@"
  '';
}
