{ clangMultiStdenv
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
clangMultiStdenv.mkDerivation {
  name = "rustc";

  nativeBuildInputs = [
    cmake
    gdb
    gnumake
    ninja
    pkg-config
    python3Full
    rustup
    mdbook
    mdbook-i18n-helpers
    html-tidy
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
