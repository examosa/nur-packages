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
        --zsh  proot_distro/completions/_proot-distro
    ''
    + lib.optionalString withQemu ''
      for prog in $out/bin/{pd,proot-distro}; do
        [[ -x "$prog" ]] &&
          wrapProgram "$prog" --prefix PATH : ${lib.makeBinPath [qemu]}
      done
    '';

  meta = {
    description = "PRoot-Distro — lightweight rootless Linux container manager built around proot";
    homepage = "https://github.com/termux/proot-distro";
    license = lib.licenses.gpl3Only;
  };
})
