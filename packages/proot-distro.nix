{ stdenv
, fetchFromGitHub
, python3Packages
, proot
, lib
, qemu
, makeWrapper
, installShellFiles
, withQemu ? false
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

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  propagatedBuildInputs = [ proot ] ++ lib.optional withQemu qemu;

  doCheck = true;
  checkPhase = ''
    python -c 'import importlib, sys; importlib.import_module("proot_distro"); print("import ok", file=sys.stderr)'
  '';

  postInstall = ''
    if [ -d "./proot_distro/completions" ]; then
      installShellCompletion \
        --bash "./proot_distro/completions/proot-distro.bash" \
        --zsh  "./proot_distro/completions/_proot-distro" \
        --fish "./proot_distro/completions/proot-distro.fish"
    fi
  '' + lib.optionalString withQemu ''
    wrapProgram "$out/bin/proot-distro" --prefix PATH : "${qemu}/bin"
    if [ -x "$out/bin/pd" ]; then
      wrapProgram "$out/bin/pd" --prefix PATH : "${qemu}/bin"
    fi
  '';

  meta = {
    description = "PRoot-Distro — lightweight rootless Linux container manager built around proot";
    homepage = "https://github.com/termux/proot-distro";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
  };
})
