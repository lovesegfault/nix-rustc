{
  description = "Nix flake for rustc development";

  nixConfig = {
    extra-trusted-substituters = [
      "https://rustc.cachix.org"
    ];
    extra-trusted-public-keys = [
      "rustc.cachix.org-1:8ydAwWnCrg7KmYsmw9XmGZ5DSIDGEe04YEWaLkW69Jk="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable-small";
    nix-fast-build = {
      url = "github:Mic92/nix-fast-build";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-fast-build }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
    in
    {
      devShells = forAllSystems (localSystem:
        let
          pkgs = import nixpkgs { inherit localSystem; };
        in
        {
          default = pkgs.callPackage ./rustc.nix { };
        }
      );

      packages = forAllSystems (localSystem: {
        inherit (nix-fast-build.packages.${localSystem}) nix-fast-build;
      });
    };
}
