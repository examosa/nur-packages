{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rw-rs";
  version = "1.0.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jridgewell";
    repo = "rw";
    rev = "05f3e4f756aa69f9b85da76dbf723f8f620f90c1";
    hash = "sha256-0zvpcvypUhWp0nqHsj8vUSEwFOnCiAGIpMP3Neraugg=";
  };

  # cargoHash = "sha256-0zvpcvypUhWp0nqHsj8vUSEwFOnCiAGIpMP3Neraugg=";
  # Using IFD as workaround for unsupported v1 Cargo.lock
  cargoLock.lockFile = finalAttrs.src + /Cargo.lock;

  passthru.updateScript = nix-update-script {};

  meta = {
    broken = true;
    description = "Like sponge, but without the moreutils kitchen sink";
    homepage = "https://github.com/jridgewell/rw";
    license = lib.licenses.mit;
    mainProgram = "rw";
  };
})
