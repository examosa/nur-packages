# This file provides all the buildable and cacheable packages and
# package outputs in your package set. These are what gets built by CI,
# so if you correctly mark packages as
#
# - broken (using `meta.broken`),
# - unfree (using `meta.license.free`), and
# - locally built (using `preferLocalBuild`)
#
# then your CI will be able to build and cache only those packages for
# which this is possible.
{pkgs ? import <nixpkgs> {}}: let
  inherit (pkgs) lib;

  isFree = lib.licenses.isFree or (l: l.free or true);

  isBuildable = p: let
    licenseList = lib.flatten [p.meta.license or []];
  in
    !(p.meta.broken or false) && lib.all isFree licenseList;

  isCacheable = p: !(p.preferLocalBuild or false);

  shouldRecurseForDerivations = p: lib.isAttrs p && p.recurseForDerivations or false;

  flattenPkgs = s: let
    normalizePkg = p:
      if shouldRecurseForDerivations p
      then flattenPkgs p
      else if lib.isDerivation p
      then [p]
      else [];
  in
    lib.concatMap normalizePkg (lib.attrValues s);

  outputsOf = p: map (o: p.${o}) p.outputs;

  overlayAttrs = import ./overlay.nix pkgs pkgs;

  nurPkgs = flattenPkgs overlayAttrs;

  buildPkgs = lib.filter isBuildable nurPkgs;
  cachePkgs = lib.filter isCacheable buildPkgs;
in {
  inherit buildPkgs cachePkgs;
  buildOutputs = lib.concatMap outputsOf buildPkgs;
  cacheOutputs = lib.concatMap outputsOf cachePkgs;
}
