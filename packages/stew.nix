{
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
  lib,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "stew";
  version = "0.6.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "marwanhawari";
    repo = "stew";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ecmTvo01xbAui9YLeEaQ90/GM1aYmjS+Tae8cE95krU=";
  };

  vendorHash = null;

  ldflags = ["-s"];

  patches = [
    (fetchpatch {
      name = "stew-update-test-fixtures.patch";
      url = "https://github.com/marwanhawari/stew/pull/89.patch";
      hash = "sha256-F7mO7NivFy97HHJQhu7CiIg1RxgU9eh30uFBZ0NvOmI=";
    })
  ];

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "An independent package manager for compiled binaries";
    homepage = "https://github.com/marwanhawari/stew";
    license = lib.licenses.mit;
    mainProgram = "stew";
  };
})
