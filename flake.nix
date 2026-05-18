{
  description = "My personal NUR repository";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    systems.url = "github:nix-systems/default";
  };

  nixConfig = {
    extra-substituters = ["https://examosa.cachix.org"];
    extra-trusted-public-keys = ["examosa.cachix.org-1:ygyyHGQtFnPwyk31fWUOvGq0Z4J+cPCCMcwBFEJT8GA="];
  };

  outputs = {
    self,
    nixpkgs,
    emacs-overlay,
    systems,
  }: let
    inherit (nixpkgs) lib;
    forAllSystems = lib.genAttrs (import systems);
  in {
    legacyPackages = forAllSystems (system:
      import ./default.nix {
        pkgs = nixpkgs.legacyPackages.${system}.extend emacs-overlay.overlays.emacs;
      });

    overlays = import ./overlays;

    packages = forAllSystems (system: lib.filterAttrs (_: lib.isDerivation) self.legacyPackages.${system});
  };
}
