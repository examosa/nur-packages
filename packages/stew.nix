{
  buildGoModule,
  fetchFromGitHub,
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

  checkFlags = let
    skippedTests = [
      "(_extract|Install)Binary(_Fail)?"
      "_readGithubSearchJSON"
      "DownloadFile"
      "NewGithub(Project|Search)"
    ];
  in ["-skip=^Test(${lib.concatStringsSep "|" skippedTests})$"];

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "An independent package manager for compiled binaries";
    homepage = "https://github.com/marwanhawari/stew";
    license = lib.licenses.mit;
    mainProgram = "stew";
  };
})
