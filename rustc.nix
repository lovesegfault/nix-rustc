{ pkgsLLVM
, cmake
, curl
, gdb
, git
, gnumake
, libxml2
, ncurses
, ninja
, openssl
, pkg-config
, python3Full
, rustup
, swig
, zlib
, mdbook
, mdbook-i18n-helpers
, html-tidy
}:
let
  llvmVersion = "17";
  llvmPackages = pkgsLLVM."llvmPackages_${llvmVersion}";
in
llvmPackages.stdenv.mkDerivation {
  name = "rustc";

  nativeBuildInputs = [
    cmake
    gdb
    gnumake
    html-tidy
    llvmPackages.lld
    mdbook
    mdbook-i18n-helpers
    ninja
    pkg-config
    python3Full
    rustup
  ];

  buildInputs = [
    curl
    git
    libxml2
    ncurses
    openssl
    swig
    zlib
  ];

  # Always show backtraces.
  RUST_BACKTRACE = 1;

  # Disable compiler hardening - required for LLVM.
  hardeningDisable = [ "all" ];
}
