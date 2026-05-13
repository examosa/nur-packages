{
  description = "My personal NUR repository";

  inputs.nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";

  outputs = { self, nixpkgs }:
    let
      inherit (nixpkgs) lib;
      forAllSystems = lib.genAttrs lib.systems.flakeExposed;
    in
    {
      legacyPackages = forAllSystems (system: import ./default.nix {
        pkgs = nixpkgs.legacyPackages.${system};
      });

      packages = forAllSystems (system: lib.filterAttrs (_: lib.isDerivation) self.legacyPackages.${system});
    };
}
