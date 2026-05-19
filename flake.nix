{
  description = "My personal NUR repository";

  inputs = {
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
