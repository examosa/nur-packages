# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `overlays`,
# `nixosModules`, `homeModules`, `darwinModules` and `flakeModules`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage
{pkgs ? import <nixpkgs> {}}: let
  inherit (pkgs) lib;
  inherit (pkgs.stdenv.hostPlatform) system;

  flake-compat = let
    lock = lib.importJSON ./flake.lock;
    sourceInfo = lock.nodes.flake-compat.locked;
  in
    fetchTarball {
      url =
        sourceInfo.url
        or "https://github.com/${sourceInfo.owner}/${sourceInfo.repo}/archive/${sourceInfo.rev}.tar.gz";
      sha256 = sourceInfo.narHash;
    };

  self = (import flake-compat {src = ./.;}).outputs;

  packages = lib.packagesFromDirectoryRecursive {
    callPackage = pkgs.newScope {
      inherit (self.inputs.emacs-overlay.packages.${system}) emacs-unstable;
    };

    directory = ./packages;
  };
in
  {
    # The `lib`, `overlays`, `nixosModules`, `homeModules`,
    # `darwinModules` and `flakeModules` names are special
    overlays = import ./overlays; # nixpkgs overlays
  }
  // packages
