{
  description = "My personal NUR repository";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";
    systems.url = "github:nix-systems/default";
  };

  outputs = {
    self,
    nixpkgs,
    systems,
  }: let
    inherit (nixpkgs) lib;
    forAllSystems = lib.genAttrs (import systems);
  in {
    legacyPackages = forAllSystems (system:
      import ./default.nix {
        pkgs = nixpkgs.legacyPackages.${system};
      });

    overlays = import ./overlays;

    packages = forAllSystems (system: lib.filterAttrs (_: lib.isDerivation) self.legacyPackages.${system});
  };
}
