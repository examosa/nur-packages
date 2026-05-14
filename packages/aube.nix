{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmakeMinimal,
  gitMinimal,
  pkg-config,
  zstd,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "aube";
  version = "1.9.1";

  strictDeps = true;
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
    pkg-config
  ];

  buildInputs = [
    zstd
  ];

  nativeCheckInputs = [
    # Necessary for a test that invokes git
    # https://github.com/endevco/aube/blob/v1.9.1/crates/aube-lockfile/src/lib.rs#L2221
    gitMinimal
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = {
    description = "A fast Node.js package manager";
    homepage = "https://github.com/endevco/aube";
    changelog = "https://github.com/endevco/aube/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = [lib.licenses.mit lib.licenses.bsd2Patent];
    mainProgram = "aube";
  };
})
