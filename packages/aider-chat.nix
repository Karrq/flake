{pkgs, ...}: let
  litellm = prev:
    prev.litellm.overrideAttrs {
      src = pkgs.fetchgit {
        url = "https://github.com/nhs000/litellm";
        rev = "22b3035cb797060786d4e5bac5dcc34fbefe7b40";
        hash = "sha256-7BZ/oXB4mLmPdUqaSprYFc5nswv84bbwOvYt/iwh2yY=";
      };
    };
  python = pkgs.python3.override {
    packageOverrides = final: prev: {litellm = litellm prev;};
  };
in
  python.pkgs.aider-chat.overrideAttrs {
    patches = [./patches/aider-github-copilot.patch];
  }
