{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  pkg-config,
  dbus,
  openssl,
  usage,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fnox";
  version = "1.25.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "fnox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4trfagKs8AO6agOazCdPH4jaTIPuMkF1mdxXLl5Cg3k=";
  };

  cargoHash = "sha256-GWyQrAnW0gFz+OBvYuHZ+btdUAIbQc77HdwiWL++DaE=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    dbus
    openssl
  ];

  postPatch = ''
    substituteInPlace ./src/commands/completion.rs \
      --replace-fail '"usage"' '"${lib.getExe usage}"'
  '';

  postInstall = ''
    installShellCompletion --cmd fnox \
      --bash <($out/bin/fnox completion bash) \
      --fish <($out/bin/fnox completion fish) \
      --zsh <($out/bin/fnox completion zsh)
  '';

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "Encrypted/remote secret manager";
    homepage = "https://github.com/jdx/fnox";
    changelog = "https://github.com/jdx/fnox/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "fnox";
  };
})
