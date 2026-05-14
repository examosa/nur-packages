{
  emacs-macport,
  fetchFromGitHub,
  lib,
  stdenv,
}: let
  src = fetchFromGitHub {
    owner = "d12frosted";
    repo = "homebrew-emacs-plus";
    tag = "cask-31-163";
    hash = "sha256-7kML/eqQ6qqgirrXhALIS/Gt5s10wfS8cO3Y3pn/KJk=";
  };
in
  emacs-macport.overrideAttrs (oldAttrs: {
    pname = "emacs-plus";

    patches =
      oldAttrs.patches
      ++ map (patch: src + /patches/emacs-30/${patch}.patch) [
        "fix-macos-tahoe-scrolling"
        "fix-ns-x-colors"
        "fix-window-role"
        "round-undecorated-frame"
        "system-appearance"
      ];

    # https://github.com/d12frosted/homebrew-emacs-plus#icons
    postPatch =
      oldAttrs.postPatch
      + ''
        cp ${src}/community/icons/memeplex-wide/icon.icns nextstep/Cocoa/Emacs.base/Contents/Resources/Emacs.icns
      '';

    # https://github.com/nix-community/emacs-overlay/issues/536
    configureFlags =
      oldAttrs.configureFlags
      ++ lib.optionals stdenv.hostPlatform.isDarwin ["ac_cv_prog_cc_c23=no"];

    meta.platforms = lib.platforms.darwin;
  })
