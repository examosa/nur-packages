{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  nix-update-script,
  stdenv,
}:
buildGoModule (finalAttrs: {
  pname = "restish";
  version = "2.0.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rest-sh";
    repo = "restish";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4piN0W/9y2NTsTuZ2B4Czhr9RQNb4eT9ZIX9MYzfMLI=";
  };

  vendorHash = "sha256-ZRyGCdmPenOeLtFuj0howJH0rah05sPUuD7RH/c0LKI=";

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
    broken = stdenv.hostPlatform.isLinux;
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
