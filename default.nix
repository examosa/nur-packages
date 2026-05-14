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

  packages = let
    dir = ./packages;
    basename = lib.removeSuffix ".nix";

    createPackage = file: _:
      lib.nameValuePair
      (basename file) (pkgs.callPackage (dir + /${file}) {});
  in
    lib.mapAttrs' createPackage (lib.readDir dir);
in
  {
    # The `lib`, `overlays`, `nixosModules`, `homeModules`,
    # `darwinModules` and `flakeModules` names are special
    overlays = import ./overlays; # nixpkgs overlays
  }
  // packages
