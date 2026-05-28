{
  description = "My personal NUR repository";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";
    systems.url = "github:nix-systems/default";
  };

  nixConfig = {
    extra-substituters = [
      "https://examosa.cachix.org"
      "https://nix-community.cachix.org"
    ];

    extra-trusted-public-keys = [
      "examosa.cachix.org-1:ygyyHGQtFnPwyk31fWUOvGq0Z4J+cPCCMcwBFEJT8GA="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs = inputs @ {
    flake-parts,
    systems,
    self,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = import systems;

      perSystem = {
        lib,
        pkgs,
        ...
      }: let
        legacyPackages = import self {inherit pkgs;};
      in {
        inherit legacyPackages;
        packages = lib.filterAttrs (_: lib.isDerivation) legacyPackages;
      };

      flake.overlays = import ./overlays;
    };
}
