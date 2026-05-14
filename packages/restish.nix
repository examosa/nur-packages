{
  fetchFromGitHub,
  lib,
  nix-update-script,
  buildGoModule,
  installShellFiles,
}:
buildGoModule (finalAttrs: {
  pname = "restish";
  version = "0.21.2";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rest-sh";
    repo = "restish";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C+fB9UeEq+h6SlBtVPPZWs5fCCsJVe/TJFy4KhhaItU=";
  };

  vendorHash = "sha256-5+N6iL9wD5J/E6H5qn1InQR8bbuAlTOzPQn0sawVbrI=";

  ldflags = ["-s" "-w" "-X main.version=${finalAttrs.version}"];

  nativeBuildInputs = [installShellFiles];

  preCheck = ''
    export HOME=$(mktemp -d) EDITOR=true
  '';

  postInstall = ''
    installShellCompletion --cmd restish \
      --bash <($out/bin/restish completion bash) \
      --fish <($out/bin/restish completion fish) \
      --zsh <($out/bin/restish completion zsh)
  '';

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "A CLI for interacting with REST-ish HTTP APIs with some nice features built-in";
    longDescription = ''
      Restish is a CLI for interacting with REST-ish HTTP APIs with some nice features built-in,
      like always having the latest API resources, fields, and operations available when they go
      live on the API without needing to install or update anything.
    '';
    homepage = "https://rest.sh/";
    changelog = "https://github.com/danielgtaylor/restish/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "restish";
  };
})
