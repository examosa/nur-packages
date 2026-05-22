{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmakeMinimal,
  installShellFiles,
  gitMinimal,
  pkg-config,
  rustc,
  usage,
  zstd,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "aube";
  version = "1.9.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "endevco";
    repo = "aube";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uwOEou6DH+bePNupYKmTc82xQV9T08bDmSPG9RU9yBk=";
  };

  cargoHash = "sha256-CBI44O2iMwdMym+ZOO9MvJQ73n+12J6FjzIXAOQTGT0=";

  nativeBuildInputs = [
    cmakeMinimal
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    zstd
  ];

  postPatch = ''
    substituteInPlace ./crates/aube-lockfile/src/lib.rs \
      --replace-fail '"git"' '"${lib.getExe gitMinimal}"'

    substituteInPlace ./crates/aube/src/commands/completion.rs \
      --replace-fail '"usage"' '"${lib.getExe usage}"'
  '';

  postInstall = ''
    installShellCompletion --cmd aube \
      --bash <($out/bin/aube completion bash) \
      --fish <($out/bin/aube completion fish) \
      --zsh <($out/bin/aube completion zsh)
  '';

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = {
    broken = lib.versionOlder rustc.version "1.93";
    description = "A fast Node.js package manager";
    homepage = "https://github.com/endevco/aube";
    changelog = "https://github.com/endevco/aube/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = [lib.licenses.mit lib.licenses.bsd2Patent];
    mainProgram = "aube";
  };
})
