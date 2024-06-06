{ mkShell
, binutils
, cacert
, cmake
, curl
, git
, glibc
, ninja
, nix
, openssl
, patchelf
, pkg-config
, python3
}:
mkShell {
  name = "rustc";

  nativeBuildInputs =  [
    binutils cmake ninja pkg-config python3 git curl cacert patchelf nix
  ];

  buildInputs = [
    openssl glibc.out glibc.static
  ];

  # Avoid creating text files for ICEs.
  RUSTC_ICE = "0";

  # Enable backtraces
  RUST_BACKTRACE = "1";

  shellHook = ''
    export PATH="$PATH:/nix/var/nix/profiles/default/bin"
  '';
}
