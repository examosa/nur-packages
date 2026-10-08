{pkgs ? import <nixpkgs> {}}: let
  inherit (pkgs) lib;

  packages = lib.packagesFromDirectoryRecursive {
    inherit (pkgs) callPackage;
    directory = ./packages;
  };
in
  {
    overlays = import ./overlays;
  }
  // packages
