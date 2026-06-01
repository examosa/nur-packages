{
  fetchFromGitHub,
  installShellFiles,
  lib,
  makeWrapper,
  proot,
  python3Packages,
  qemu,
  stdenv,
  withQemu ? false,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "proot-distro";
  version = "5.1.2";

  src = fetchFromGitHub {
    owner = "termux";
    repo = "proot-distro";
    rev = "v${finalAttrs.version}";
    hash = "sha256-z20af/J7zueIGHFqa+/t2kRfDpCwR7WeTj7ZFhCS1PQ=";
  };

  nativeBuildInputs = [makeWrapper installShellFiles];

  propagatedBuildInputs = [proot] ++ lib.optional withQemu qemu;

  doCheck = true;
  checkPhase = ''
    python -c '
      import importlib, sys
      importlib.import_module("proot_distro")
      print("import ok", file=sys.stderr)
    '
  '';

  postInstall =
    ''
      installShellCompletion \
        proot_distro/completions/proot-distro.{ba,fi}sh \
        --zsh proot_distro/completions/_proot-distro
    ''
    + lib.optionalString withQemu ''
      for prog in $out/bin/{pd,proot-distro}; do
        [[ -x "$prog" ]] &&
          wrapProgram "$prog" --prefix PATH : ${lib.makeBinPath [qemu]}
      done
    '';

  meta = {
    description = "A utility for managing installations of the Linux distributions in Termux";
    longDescription = ''
      PRoot-Distro is a utility for managing rootless Linux containers in Termux and on regular Linux hosts. It uses proot to provide a chroot-like environment without requiring root access on the device.

      Containers are created by pulling Docker/OCI images directly from Docker Hub or any compatible registry — or by extracting a local tarball / OCI image archive.
      The container filesystem is assembled from the image layers and stored locally, ready to be entered at any time.

      PRoot-Distro can also build OCI images from a Dockerfile (no Docker daemon required), storing the result in the local manifest cache or exporting it as a standalone OCI tarball.
    '';
    homepage = "https://github.com/termux/proot-distro";
    license = lib.licenses.gpl3Only;
  };
})
