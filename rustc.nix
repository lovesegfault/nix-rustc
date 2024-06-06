{ mkShell
, bashInteractive
, binutils
, cacert
, cmake
, curl
, formats
, git
, glibc
, mdbook
, mdbook-i18n-helpers
, ninja
, openssl
, patchelf
, pkg-config
, python3

, bootstrapConfig ? null
, extraBootstrapConfig ? { }
}:
mkShell {
  name = "rustc";

  nativeBuildInputs = [
    binutils
    cmake
    ninja
    pkg-config
    python3
    git
    patchelf

    # for pure interactive shells
    bashInteractive

    # bootstrap downloads
    curl
    cacert

    # docs
    mdbook
    mdbook-i18n-helpers
  ];

  buildInputs = [
    openssl
    glibc.out
    glibc.static
  ];

  RUST_BOOTSTRAP_CONFIG = (formats.toml { }).generate "config.toml" (
    if bootstrapConfig != null then bootstrapConfig
    else
      ({
        change-id = 125535;

        build.patch-binaries-for-nix = true;

        llvm.download-ci-llvm = false;
      } // extraBootstrapConfig)
  );

  # Avoid creating text files for ICEs.
  RUSTC_ICE = "0";

  # Enable backtraces
  RUST_BACKTRACE = "1";

  shellHook = ''
    export PATH="$PATH:/nix/var/nix/profiles/default/bin"
  '';
}
